
(module string-constant mzscheme
  (require-for-syntax (lib "etc.ss")
		      (lib "list.ss")
                      (prefix english: "english-string-constants.ss")
                      (prefix spanish: "spanish-string-constants.ss")
                      (prefix german: "german-string-constants.ss")
                      (prefix french: "french-string-constants.ss")
                      (prefix dutch: "dutch-string-constants.ss")
                      (prefix danish: "danish-string-constants.ss")
		      (prefix italian: "italian-string-constants.ss"))
  
  (require (lib "file.ss")
           (lib "etc.ss")
           "private/only-once.ss")

  (provide string-constant string-constants this-language all-languages set-language-pref)
  
  ;; set-language-pref : symbol -> void
  (define (set-language-pref language)
    (put-preferences (list 'plt:human-language) (list language)))
  
  ;; language : symbol
  (define language (get-preference 'plt:human-language (lambda () 'english)))
  
  (define-syntax-set (string-constant string-constants this-language all-languages)
    ;; type sc = (make-sc symbol (listof (list symbol string)) (union #f hash-table[symbol -o> #t]))
    (define-struct sc (language-name constants ht))
    
    (define available-string-constant-sets
      (list 
       (make-sc 'english english:string-constants #f)
       (make-sc 'spanish spanish:string-constants #f)
       (make-sc 'french french:string-constants #f)
       (make-sc 'german german:string-constants #f)
       (make-sc 'dutch dutch:string-constants #f)
       (make-sc 'danish danish:string-constants #f)
       (make-sc 'italian italian:string-constants #f)))
    
    (define first-string-constant-set (car available-string-constant-sets))
    
    ;; env-var-set? : symbol -> boolean
    ;; returns #t if the user has requested this langage info.
    ;; If the environment variable is set to something that
    ;; isn't well-formed according to `read' you get all output
    ;; If the environment variable is set to a symbol (according to read)
    ;; you get that language. If it is set to a list of symbols
    ;; (again, according to read) you get those langauges.
    ;; if it is set to anything else, you get all langauges.
    (define (env-var-set? lang)
      (cond
        [(symbol? specific) (eq? lang specific)]
        [(list? specific) (memq lang specific)]
        [else #t]))
    
    (define env-var-set 
      (or (getenv "PLTSTRINGCONSTANTS")
          (getenv "STRINGCONSTANTS")))
    
    (define specific
      (and env-var-set
           (with-handlers ([exn:read? (lambda (x) #t)])
             (read (open-input-string env-var-set)))))
    
    (define the-warning-message #f)
    (define (get-warning-message)
      (unless the-warning-message
        (set! the-warning-message
	      (let* (;; type no-warning-cache-key = (cons symbol symbol)
		     ;; warning-table : (listof (list no-warning-cache-key (listof (list sym string))))
                     [warning-table null]
		     [extract-ht
                      (lambda (sc)
                        (unless (sc-ht sc)
                          (let ([ht (make-hash-table)])
                            (for-each (lambda (ent) (hash-table-put! ht (car ent) #t))
                                      (sc-constants sc))
                            (set-sc-ht! sc ht)))
                        (sc-ht sc))]
                     [check-one-way
		      (lambda (sc1 sc2)
			(let ([assoc1 (sc-constants sc1)]
			      [assoc2 (sc-constants sc2)]
                              [ht2 (extract-ht sc2)])
			  (for-each
			   (lambda (pair1)
			     (let* ([constant1 (car pair1)]
				    [value1 (cadr pair1)]
				    [pair2 (hash-table-get ht2 constant1 (lambda () #f))])
			       (unless pair2
				 (let ([no-warning-cache-key (cons (sc-language-name sc1) (sc-language-name sc2))])
				   (when (or (env-var-set? (sc-language-name sc1))
					     (env-var-set? (sc-language-name sc2)))
				     (cond
                                       [(memf (lambda (x) (equal? (car x) no-warning-cache-key)) warning-table)
                                        =>
                                        (lambda (x)
                                          (let ([ent (car x)])
                                            (set-car! (cdr ent) (cons (list constant1 value1) (cadr ent)))))]
                                       [else
                                        (set! warning-table (cons (list no-warning-cache-key
                                                                        (list (list constant1 value1)))
                                                                  warning-table))]))))))
			   assoc1)))])
                
                (for-each (lambda (x) 
                            (check-one-way x first-string-constant-set)
                            (check-one-way first-string-constant-set x))
                          (cdr available-string-constant-sets))
		
		(let ([sp (open-output-string)])
		  (for-each
		   (lambda (bad)
		     (let* ([lang-pair (car bad)]
			    [constants (cadr bad)]
			    [lang1-name (car lang-pair)]
			    [lang2-name (cdr lang-pair)])
		       (fprintf sp "WARNING: language ~a had but ~a does not:\n"
				lang1-name
				lang2-name)
		       (for-each
			(lambda (x) (fprintf sp "   ~s\n" x))
			(quicksort
			 constants
			 (lambda (x y) (string<=? (symbol->string (car x)) (symbol->string (car y))))))
		       (newline sp)))
		   warning-table)
		  (get-output-string sp)))))
      the-warning-message)
    
    (define (string-constant/proc stx)
      (syntax-case stx ()
        [(_ name)
         (let ([assoc-table (sc-constants first-string-constant-set)]
               [datum (syntax-object->datum (syntax name))])
           (unless (symbol? datum)
             (raise-syntax-error #f
                                 (format "expected name, got: ~s" datum)
                                 stx))
           (let ([default-val (assq datum assoc-table)])
             (unless default-val
               (raise-syntax-error 
                #f
                (format "~a is not a known string constant" datum) 
                stx))
             (with-syntax ([(constants ...) (map (lambda (x)
                                                   (let ([val (assq datum (sc-constants x))])
                                                     (if val
                                                         (cadr val)
                                                         (cadr default-val))))
                                                 available-string-constant-sets)]
                           [(languages ...) (map sc-language-name available-string-constant-sets)]
                           [first-constant (cadr (assq datum (sc-constants first-string-constant-set)))])
               (with-syntax ([conditional-for-string
                              (syntax/loc stx
                                (cond
                                  [(eq? language 'languages) constants] ...
                                  [else first-constant]))])
                 (if env-var-set
		     (with-syntax ([warning-message (get-warning-message)])
		       (syntax/loc stx
			 (begin
			   (maybe-print-message warning-message)
			   conditional-for-string)))
                     (syntax/loc stx conditional-for-string))))))]))
    
    (define (string-constants/proc stx)
      (syntax-case stx ()
        [(_ name)
         (let ([assoc-table (sc-constants first-string-constant-set)]
               [datum (syntax-object->datum (syntax name))])
           (unless (symbol? datum)
             (raise-syntax-error #f
                                 (format "expected name, got: ~s" datum)
                                 stx))
           (let ([default-val (assq datum assoc-table)])
             (unless default-val
               (raise-syntax-error 
                #f
                (format "~a is not a known string constant" datum)
                stx))
             (with-syntax ([(constants ...) (map (lambda (x) 
                                                   (let ([val (assq datum (sc-constants x))])
                                                     (if val
                                                         (cadr val)
                                                         (cadr default-val))))
                                                 available-string-constant-sets)])
               (syntax (list constants ...)))))]))
    
    (define (this-language/proc stx)
      (syntax-case stx ()
        [(_)
         (syntax language)]))
    
    (define (all-languages/proc stx)
      (syntax-case stx ()
        [(_) 
         (with-syntax ([(languages ...) (map sc-language-name available-string-constant-sets)])
           (syntax (list 'languages ...)))]))))
#|
(require string-constant)
(string-constant is-this-your-native-language)
(string-constants is-this-your-native-language)
(all-languages)
(this-language)
(expand #'(string-constant is-this-your-native-language))
(expand #'(string-constants is-this-your-native-language))
|#