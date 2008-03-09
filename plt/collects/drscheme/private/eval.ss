
(module eval mzscheme
  (require (lib "mred.ss" "mred")
           (lib "unitsig.ss")
           (lib "class.ss")
	   (lib "toplevel.ss" "syntax")
           "drsig.ss"
           (lib "framework.ss" "framework"))
  
  
  ;; to ensure this guy is loaded (and the snipclass installed) in the drscheme namespace & eventspace
  (require (lib "cache-image-snip.ss" "mrlib"))
  
  (define op (current-output-port))
  (define (oprintf . args) (apply fprintf op args))
  
  (provide eval@)
  (define eval@
    (unit/sig drscheme:eval^
      (import [drscheme:language-configuration : drscheme:language-configuration/internal^]
              [drscheme:rep : drscheme:rep^]
              [drscheme:init : drscheme:init^]
              [drscheme:language : drscheme:language^]
              [drscheme:teachpack : drscheme:teachpack^])
      
      (define (traverse-program/multiple language-settings
                                         init
                                         kill-termination)
        (let-values ([(eventspace custodian teachpack-cache) 
                      (build-user-eventspace/custodian
                       language-settings
                       init
                       kill-termination)])
          (let ([language (drscheme:language-configuration:language-settings-language
                           language-settings)]
                [settings (drscheme:language-configuration:language-settings-settings
                           language-settings)])
            (lambda (input iter complete-program?)
              (parameterize ([current-eventspace eventspace])
                (queue-callback
                 (lambda ()
                   (let ([read-thnk 
                          (if complete-program?
                              (send language front-end/complete-program input settings teachpack-cache)
                              (send language front-end/interaction input settings teachpack-cache))])
                     (let loop ()
                       (let ([in (read-thnk)])
                         (cond
                           [(eof-object? in)
                            (iter in (lambda () (void)))]
                           [else
                            (iter in (lambda () (loop)))])))))))))))
      
      (define (expand-program/multiple language-settings
                                       eval-compile-time-part? 
                                       init
                                       kill-termination)
        (let ([res (traverse-program/multiple language-settings init kill-termination)])
          (lambda (input iter complete-program?)
            (let ([expanding-iter
                   (lambda (rd cont)
                     (cond
                       [(eof-object? rd) (iter rd cont)]
                       [eval-compile-time-part? 
                        (iter (expand-top-level-with-compile-time-evals rd) cont)]
                       [else (iter (expand rd) cont)]))])
              (res input 
                   expanding-iter
                   complete-program?)))))
      
      (define (expand-program input
                              language-settings
                              eval-compile-time-part? 
                              init
                              kill-termination
                              iter)
        ((expand-program/multiple 
          language-settings
          eval-compile-time-part? 
          init
          kill-termination)
         input
         iter
         #t))
         
      
      (define (build-user-eventspace/custodian language-settings init kill-termination)
        (let* ([user-custodian (make-custodian)]
               [user-teachpack-cache (preferences:get 'drscheme:teachpacks)]
	       [eventspace (parameterize ([current-custodian user-custodian])
			     (make-eventspace))]
               [language (drscheme:language-configuration:language-settings-language
                          language-settings)]
               [settings (drscheme:language-configuration:language-settings-settings
                          language-settings)]
               [eventspace-main-thread #f]
               [run-in-eventspace
                (lambda (thnk)
                  (parameterize ([current-eventspace eventspace])
                    (let ([sema (make-semaphore 0)]
                          [ans #f])
                      (queue-callback
                       (lambda ()
                         (let/ec k
                           (parameterize ([error-escape-handler
                                           (let ([drscheme-expand-program-error-escape-handler
                                                  (lambda () (k (void)))])
                                             drscheme-expand-program-error-escape-handler)])
                             (set! ans (thnk))))
                         (semaphore-post sema)))
                      (semaphore-wait sema)
                      ans)))]
               [drs-snip-classes (get-snip-classes)])
          (run-in-eventspace
           (lambda ()
             (current-custodian user-custodian)
             (set-basic-parameters drs-snip-classes)
             (drscheme:rep:current-language-settings language-settings)))
          (send language on-execute settings run-in-eventspace)
          (run-in-eventspace
           (lambda ()
             (set! eventspace-main-thread (current-thread))
             (drscheme:teachpack:install-teachpacks user-teachpack-cache)
             (init)
             (break-enabled #t)))
          (thread
           (lambda ()
             (thread-wait eventspace-main-thread)
             (kill-termination)))
          (values eventspace user-custodian user-teachpack-cache)))
      
      ;; get-snip-classes : -> (listof snipclass)
      ;; returns a list of the snip classes in the current eventspace
      (define (get-snip-classes)
        (let loop ([n (send (get-the-snip-class-list) number)])
          (if (zero? n)
              null
              (cons (send (get-the-snip-class-list) nth (- n 1))
                    (loop (- n 1))))))
      
      ;; set-basic-parameters : (listof (is-a/c? snipclass%)) -> void
      ;; sets the parameters that are shared between the repl's initialization
      ;; and expand-program
      (define (set-basic-parameters snip-classes)
        (for-each (lambda (snip-class) (send (get-the-snip-class-list) add snip-class))
                  snip-classes)
        
        (current-thread-group (make-thread-group))        
        (current-command-line-arguments #())
        (read-curly-brace-as-paren #t)
        (read-square-bracket-as-paren #t)
        (error-print-width 250)
        (current-ps-setup (make-object ps-setup%))

        (let ([user-custodian (current-custodian)])
          (exit-handler (lambda (arg) ; =User=
                          (custodian-shutdown-all user-custodian))))
        (current-namespace (make-namespace 'empty))
        (for-each (lambda (x) (namespace-attach-module drscheme:init:system-namespace x))
                  to-be-copied-module-names))
      
      ;; these module specs are copied over to each new user's namespace 
      (define to-be-copied-module-specs
        (list 'mzscheme
              '(lib "mred.ss" "mred")
              '(lib "cache-image-snip.ss" "mrlib")))
      ;; ensure that they are all here.
      (for-each (lambda (x) (dynamic-require x #f)) to-be-copied-module-specs)
      ;; get the names of those modules.
      (define to-be-copied-module-names
        (let ([get-name
               (lambda (spec)
                 (if (symbol? spec)
                     spec
                     ((current-module-name-resolver) spec #f #f)))])
          (map get-name to-be-copied-module-specs)))
      
      ;; build-input-port : string[file-exists?] -> (values input any)
      ;; constructs an input port for the load handler. Also
      ;; returns a value representing the source of code read from the file.
      ;; if the file's first lines begins with #!, skips the first chars of the file.
      (define (build-input-port filename)
        (let* ([p (open-input-file filename)]
               [chars (list (read-char p)
                            (read-char p)
                            (read-char p)
                            (read-char p))])
          (close-input-port p)
          (cond
            [(equal? chars (string->list "WXME"))
             (let ([text (make-object text%)])
               (send text load-file filename)
               (let ([port (open-input-text-editor text)])
                 (port-count-lines! port)
                 (when (and ((send text last-position) . >= . 2)
                            (char=? #\# (send text get-character 0))
                            (char=? #\! (send text get-character 1)))
                   (read-line port))
                 (values port text)))]
            [else
             (let ([port (open-input-file filename)])
               (port-count-lines! port)
               (when (and (equal? #\# (car chars))
                          (equal? #\! (cadr chars)))
                 (read-line port))
               (values port filename))]))))))