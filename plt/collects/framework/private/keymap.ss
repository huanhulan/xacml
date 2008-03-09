
(module keymap mzscheme
  (require (lib "string-constant.ss" "string-constants")
           (lib "unitsig.ss")
	   "../macro.ss"
	   (lib "class.ss")
	   (lib "list.ss")
	   (lib "mred-sig.ss" "mred")
           "sig.ss")
  
  (provide keymap@)
  
  (define keymap@ 
    (unit/sig framework:keymap^
      (import mred^
	      [preferences : framework:preferences^]
	      [finder : framework:finder^]
	      [handler : framework:handler^]
	      [frame : framework:frame^]
              [editor : framework:editor^])
      
      (rename [-get-file get-file])

      (define (remove-chained-keymap ed keymap-to-remove)
        (let ([ed-keymap (send ed get-keymap)])
          (when (eq? keymap-to-remove ed-keymap)
            (error 'keymap:remove-keymap "cannot remove initial keymap from editor"))
          (let p-loop ([parent-keymap ed-keymap])
            (unless (is-a? parent-keymap aug-keymap<%>)
              (error 'keymap:remove-keymap
                     "found a keymap that is not a keymap:aug-keymap<%> ~e" 
                     parent-keymap))
            (let c-loop ([child-keymaps (send parent-keymap get-chained-keymaps)])
              (cond
                [(null? child-keymaps) null]
                [else
                 (let ([child-keymap (car child-keymaps)])
                   (cond
                     [(eq? child-keymap keymap-to-remove)
                      (send parent-keymap remove-chained-keymap child-keymap)
                      (c-loop (cdr child-keymaps))]
                     [else 
                      (p-loop child-keymap)
                      (c-loop (cdr child-keymaps))]))])))))
      
      (define (set-chained-keymaps parent-keymap children-keymaps)
        (for-each (lambda (orig-sub) (send parent-keymap remove-chained-keymap))
                  (send parent-keymap get-chained-keymaps))
        (for-each (lambda (new-sub) (send parent-keymap chain-to-keymap new-sub #f))
                  children-keymaps))
        
      (define aug-keymap<%> (interface ((class->interface keymap%))
			      get-chained-keymaps
			      get-map-function-table
			      get-map-function-table/ht))
      
      (define aug-keymap-mixin
	(mixin ((class->interface keymap%)) (aug-keymap<%>)
          (define chained-keymaps null)
	  (public get-chained-keymaps)
          [define get-chained-keymaps
            (lambda ()
              chained-keymaps)]
	  
          (rename [super-chain-to-keymap chain-to-keymap])
	  (define/override (chain-to-keymap keymap prefix?)
            (super-chain-to-keymap keymap prefix?)
            (set! chained-keymaps
                  (if prefix?
                      (cons keymap chained-keymaps)
                      (append chained-keymaps (list keymap)))))
	  
          (rename [super-remove-chained-keymap remove-chained-keymap])
          (define/override (remove-chained-keymap keymap)
            (super-remove-chained-keymap keymap)
            (set! chained-keymaps (remq keymap chained-keymaps)))
          
	  [define function-table (make-hash-table)]
	  (public get-function-table)
          [define get-function-table (lambda () function-table)]
	  (rename [super-map-function map-function])
	  (override map-function)
          [define map-function
	    (lambda (keyname fname)
	      (super-map-function (canonicalize-keybinding-string keyname) fname)
	      (hash-table-put! function-table (string->symbol keyname) fname))]
	  
	  (public get-map-function-table get-map-function-table/ht)
          [define get-map-function-table
            (lambda ()
              (get-map-function-table/ht (make-hash-table)))]
          
          [define get-map-function-table/ht
            (lambda (table)
              (hash-table-for-each
               function-table
               (lambda (keyname fname)
                 (unless (hash-table-get table keyname (lambda () #f))
                   (hash-table-put! table keyname fname))))
              (for-each
               (lambda (chained-keymap)
                 (when (is-a? chained-keymap aug-keymap<%>)
                   (send chained-keymap get-map-function-table/ht table)))
               chained-keymaps)
              table)]
          
          (super-instantiate ())))
      
      (define aug-keymap% (aug-keymap-mixin keymap%))
      
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;;;;;;                                                     ;;;;;;;;
      ;;;;;;;           canonicalize-keybinding-string            ;;;;;;;;
      ;;;;;;;                                                     ;;;;;;;;
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      
      ;; canonicalize-keybinding-string : string -> string
      ;; The result can be used with string=? to determine
      ;; if two key bindings refer to the same key.
      ;; Assumes a well-formed keystring.
      (define (canonicalize-keybinding-string str)
	(let* ([chars (map char-downcase (string->list str))]
	       [separated-keys
		(map
		 canonicalize-single-keybinding-string
		 (split-out #\; chars))])
	  (join-strings ";" separated-keys)))
      
      ;; join-strings : string (listof string) -> string
      ;; concatenates strs with sep between each of them
      (define (join-strings sep strs)
	(if (null? strs)
	    ""
	    (apply
	     string-append
	     (cons
	      (car strs)
	      (let loop ([sepd-strs (cdr strs)])
		(cond
                  [(null? sepd-strs) null]
                  [else (list*
                         sep
                         (car sepd-strs)
                         (loop (cdr sepd-strs)))]))))))
      
      ;; canonicalize-single-keybinding-string : (listof char) -> string
      (define (canonicalize-single-keybinding-string chars)
	(let* ([neg? (char=? (car chars) #\:)]
	       [mods/key (split-out #\: (if neg? (cdr chars) chars))]
	       [mods
		(let loop ([mods mods/key])
		  (cond
                    [(null? mods) null]
                    [(null? (cdr mods)) null]
                    [else (cons (car mods) (loop (cdr mods)))]))]
	       [key (car (last-pair mods/key))]
	       [shift (if neg? #f 'd/c)]
	       [control (if neg? #f 'd/c)]
	       [alt (if neg? #f 'd/c)]
	       [meta (if neg? #f 'd/c)]
	       [command (if neg? #f 'd/c)]
               
	       [do-key
		(lambda (char val)
		  (cond
                    [(eq? val #t) (string char)]
                    [(eq? val #f) (string #\~ char)]
                    [(eq? val 'd/c) #f]))])
          
	  (for-each (lambda (mod)
		      (let ([val (not (char=? (car mod) #\~))])
			(case (if (char=? (car mod) #\~)
				  (cadr mod)
				  (car mod))
			  [(#\s) (set! shift val)]
			  [(#\c) (set! control val)]
			  [(#\a) (set! alt val)]
			  [(#\d) (set! command val)]
			  [(#\m) (set! meta val)])))
		    mods)
	  (join-strings ":"
			(filter
			 (lambda (x) x)
			 (list
			  (do-key #\a alt)
			  (do-key #\c control)
			  (do-key #\d command)
			  (do-key #\m meta)
			  (do-key #\s shift)
			  (apply string key))))))
      
      ;; split-out : char (listof char) -> (listof (listof char))
      ;; splits a list of characters at its first argument
      ;; if the last character is the same as the first character,
      ;; it is not split into an empty list, but returned.
      (define (split-out split-char chars)
	(let loop ([chars chars]
		   [this-split null]
		   [all-split null])
	  (cond
            [(null? chars)
             (reverse (cons (reverse this-split) all-split))]
            [else (let ([char (car chars)])
                    (cond
                      [(char=? split-char char)
                       (if (null? (cdr chars))
                           (loop null
                                 (cons char this-split)
                                 all-split)
                           (loop (cdr chars)
                                 null
                                 (cons (reverse this-split) all-split)))]
                      [else
                       (loop (cdr chars)
                             (cons char this-split)
                             all-split)]))])))
      
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;;;;;;                                                     ;;;;;;;;
      ;;;;;;;         end canonicalize-keybinding-string          ;;;;;;;;
      ;;;;;;;                                                     ;;;;;;;;
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      
      (define (make-meta-prefix-list key)
	(list (string-append "m:" key)
	      (string-append "ESC;" key)))
      
      (define send-map-function-meta
	(lambda (keymap key func)
	  (for-each (lambda (key) (send keymap map-function key func))
		    (make-meta-prefix-list key))))
      
      (define add-to-right-button-menu (make-parameter void))
      (define add-to-right-button-menu/before (make-parameter void))
      
      (define setup-global
        ; Define some useful keyboard functions
	(let* ([ring-bell
		(lambda (edit event)
		  (bell))]
	       
	       [mouse-popup-menu 
		(lambda (edit event)
		  (when (send event button-down?)
		    (let ([a (send edit get-admin)])
		      (when a
			(let ([m (make-object popup-menu%)])
                          
                          ((add-to-right-button-menu/before) m edit event)
                          
			  (append-editor-operation-menu-items m)
			  (for-each
			   (lambda (i)
			     (when (is-a? i selectable-menu-item<%>)
			       (send i set-shortcut #f)))
			   (send m get-items))
                          
			  ((add-to-right-button-menu) m edit event)
                          
			  (let-values ([(x y) (send edit
						    dc-location-to-editor-location
						    (send event get-x)
						    (send event get-y))])
			    (send a popup-menu m (+ x 1) (+ y 1))))))))]
               
	       [toggle-anchor
		(lambda (edit event)
		  (send edit set-anchor
			(not (send edit get-anchor))))]
	       [center-view-on-line
		(lambda (edit event)
		  (let ([new-mid-line (send edit position-line
					    (send edit get-start-position))]
			[bt (box 0)]
			[bb (box 0)])
		    (send edit get-visible-line-range bt bb #f)
		    (let* ([half (sub1 (quotient (- (unbox bb) (unbox bt)) 2))]
			   [last-pos (send edit position-line (send edit last-position))]
			   [top-pos (send edit line-start-position 
					  (max (min (- new-mid-line half) last-pos) 0))]
			   [bottom-pos (send edit line-start-position 
					     (max 0
						  (min (+ new-mid-line half)
						       last-pos)))])
		      (send edit scroll-to-position 
			    top-pos
			    #f
			    bottom-pos)))
		  #t)]

	       [make-insert-brace-pair
		(lambda (open-brace close-brace)
		  (lambda (edit event)
		    (send edit begin-edit-sequence)
                    (let ([selection-start (send edit get-start-position)])
                      (send edit set-position (send edit get-end-position))
                      (send edit insert close-brace)
                      (send edit set-position selection-start)
                      (send edit insert open-brace))
		    (send edit end-edit-sequence)))]
               
               [insert-lambda-template
                (lambda (edit event)
                  (send edit begin-edit-sequence)
                  (let ([selection-start (send edit get-start-position)])
                    (send edit set-position (send edit get-end-position))
                    (send edit insert ")")
                    (send edit set-position selection-start)
                    (send edit insert ") ")
                    (send edit set-position selection-start)
                    (send edit insert "(lambda ("))
                  (send edit end-edit-sequence))]

	       [collapse-variable-space
                ;; As per emacs: collapse tabs & spaces around the point,
                ;; perhaps leaving a single space.
                ;; drscheme bonus: if at end-of-line, collapse into the next line.
		(lambda (leave-one? edit event)
		  (letrec ([last-pos  (send edit last-position)]
		           [sel-start (send edit get-start-position)]
			   [sel-end   (send edit get-end-position)]
                           [collapsible? (lambda (c) (and (char-whitespace? c)
                                                          (not (char=? #\newline c))))]
			   [find-noncollapsible
                            ; Return index of next non-collapsible char,
                            ; starting at pos in direction dir.
                            ; NB returns -1 or last-pos, if examining
                            ; initial/final whitespace
                            ; (or, when initial pos is outside of [0,last-pos).)
			    (lambda (pos dir)
			      (let loop ([pos pos])
                                (cond [(<  pos 0) -1]
                                      [(>= pos last-pos) last-pos]
                                      [(collapsible? (send edit get-character pos))
                                       (loop (+ pos dir))]
                                      [else pos])))])
                    (when (= sel-start sel-end) ; Only when no selection:
                      (let* ([start (add1 (find-noncollapsible (sub1 sel-start) -1))]
                             [end-heeding-eol (find-noncollapsible sel-start +1)]
                             ; This is the end of the range, were we to always heed newlines.
                             
                             ; Special case: if we're sitting at EOL,
                             ; and we're not affecting much else,
                             ; then delete that EOL and collapse spaces
                             ; at the start of next line, too:
                             [end (if (and (<= (- end-heeding-eol start)
                                               (if leave-one? 1 0))
                                           (char=? #\newline (send edit get-character end-heeding-eol))
                                           ; If you wish to avoid deleting an newline at EOF, do so here.
                                           )
                                      (find-noncollapsible (add1 end-heeding-eol) +1)
                                      end-heeding-eol)]
                             [making-no-difference?
                              ; Don't introduce edits into undo-chain, if no effect.
                              (if leave-one?
                                  (and (= (- end start) 1)
                                       (char=? #\space (send edit get-character start)))
                                  (= (- end start) 0))])
                        (unless making-no-difference?
                          (send edit begin-edit-sequence)
                          (send edit set-position end) ; Even after delete, caret will be at "end".
                          (send edit delete start end)
                          (when leave-one? (send edit insert #\space start))
                          (send edit end-edit-sequence))))))]
	       
	       [collapse-space
		(lambda (edit event)
		  (collapse-variable-space #t edit event))]
	       
	       [remove-space
		(lambda (edit event)
		  (collapse-variable-space #f edit event))]
	       
	       [collapse-newline
		(lambda (edit event)
		  (letrec ([find-nonwhite
			    (lambda (pos d offset)
			      (let/ec escape
				(let ([max (if (> offset 0)
					       (send edit last-position)
					       0)])
				  (let loop ([pos pos])
				    (if (= pos max)
					(escape pos)
					(let ([c (send edit get-character (+ pos offset))])
					  (cond
                                            [(char=? #\newline c)
                                             (loop (+ pos d))
                                             (escape pos)]
                                            [(char-whitespace? c) 
                                             (loop (+ pos d))]
                                            [else pos])))))))])
		    (let ([sel-start (send edit get-start-position)]
			  [sel-end (send edit get-end-position)])
		      (when (= sel-start sel-end)
			(let* ([pos-line (send edit position-line sel-start #f)]
			       [pos-line-start (send edit line-start-position pos-line)]
			       [pos-line-end (send edit line-end-position pos-line)]
			       
			       [whiteline?
				(let loop ([pos pos-line-start])
				  (if (>= pos pos-line-end)
				      #t
				      (and (char-whitespace? (send edit get-character pos))
					   (loop (add1 pos)))))]
			       
			       [start (find-nonwhite pos-line-start -1 -1)]
			       [end (find-nonwhite pos-line-end 1 0)]
			       
			       [start-line 
				(send edit position-line start #f)]
			       [start-line-start
				(send edit line-start-position start-line)]
			       [end-line
				(send edit position-line end #f)]
			       [end-line-start
				(send edit line-start-position (add1 end-line))])
			  (cond
                            [(and whiteline?
                                  (= start-line pos-line)
                                  (= end-line pos-line))
                             ; Special case: just delete this line
                             (send edit delete pos-line-start (add1 pos-line-end))]
                            [(and whiteline? (< start-line pos-line))
                             ; Can delete before & after
                             (send* edit 
                               (begin-edit-sequence)
                               (delete (add1 pos-line-end) end-line-start)
                               (delete start-line-start pos-line-start)
                               (end-edit-sequence))]
                            [else
                             ; Only delete after
                             (send edit delete (add1 pos-line-end) 
                                   end-line-start)]))))))]
	       
	       [open-line
		(lambda (edit event)
		  (let ([sel-start (send edit get-start-position)]
			[sel-end (send edit get-end-position)])
		    (if (= sel-start sel-end)
			(send* edit 
                          (insert #\newline)
                          (set-position sel-start)))))]
	       
	       [transpose-chars
		(lambda (edit event)
		  (let ([sel-start (send edit get-start-position)]
			[sel-end (send edit get-end-position)])
		    (when (and (= sel-start sel-end)
			       (not (= sel-start 0)))
		      
		      (let ([sel-start
			     (if (= sel-start
				    (send edit line-end-position
					  (send edit position-line sel-start)))
				 (sub1 sel-start)
				 sel-start)])
			(let ([s (send edit get-text
				       sel-start (add1 sel-start))])
			  (send* edit
                            (begin-edit-sequence)
                            (delete sel-start (add1 sel-start))
                            (insert s (- sel-start 1))
                            (set-position (add1 sel-start))
                            (end-edit-sequence)))))))]
	       
	       [transpose-words
		(lambda (edit event)
		  (let ([sel-start (send edit get-start-position)]
			[sel-end (send edit get-end-position)])
		    (when (= sel-start sel-end)
		      (let ([word-1-start (box sel-start)])
			(send edit find-wordbreak word-1-start #f 'caret)
			(let ([word-1-end (box (unbox word-1-start))])
			  (send edit find-wordbreak #f word-1-end 'caret)
			  (let ([word-2-end (box (unbox word-1-end))])
			    (send edit find-wordbreak #f word-2-end 'caret)
			    (let ([word-2-start (box (unbox word-2-end))])
			      (send edit find-wordbreak word-2-start #f 'caret)
			      (let ([text-1 (send edit get-text
						  (unbox word-1-start)
						  (unbox word-1-end))]
				    [text-2 (send edit get-text
						  (unbox word-2-start)
						  (unbox word-2-end))])
				(send* edit
                                  (begin-edit-sequence)
                                  (insert text-1 
                                          (unbox word-2-start)
                                          (unbox word-2-end))
                                  (insert text-2 
                                          (unbox word-1-start)
                                          (unbox word-1-end))
                                  (set-position (unbox word-2-end))
                                  (end-edit-sequence))))))))))]
	       
	       [capitalize-it
		(lambda (edit char-case1 char-case2)
		  (let ([sel-start (send edit get-start-position)]
			[sel-end (send edit get-end-position)]
			[real-end (send edit last-position)])
		    (when (= sel-start sel-end)
		      (let ([word-end (let ([b (box sel-start)])
					(send edit find-wordbreak #f b 'caret)
					(min real-end (unbox b)))])
			(send edit begin-edit-sequence)
			(let loop ([pos sel-start]
				   [char-case char-case1])
			  (when (< pos word-end)
			    (let ([c (send edit get-character pos)])
			      (cond
                                [(char-alphabetic? c)
                                 (send edit insert 
                                       (list->string
                                        (list (char-case c)))
                                       pos (add1 pos))
                                 (loop (add1 pos) char-case2)]
                                [else 
                                 (loop (add1 pos) char-case)]))))
			(send* edit 
                          (end-edit-sequence)
                          (set-position word-end))))))]
	       
	       [capitalize-word
		(lambda (edit event)
		  (capitalize-it edit char-upcase char-downcase))]
	       [upcase-word
		(lambda (edit event)
		  (capitalize-it edit char-upcase char-upcase))]
	       [downcase-word
		(lambda (edit event)
		  (capitalize-it edit char-downcase char-downcase))]
	       
	       [kill-word
		(lambda (edit event)
		  (let ([sel-start (send edit get-start-position)]
			[sel-end (send edit get-end-position)])
		    (let ([end-box (box sel-end)])
		      (send edit find-wordbreak #f end-box 'caret)
		      (send edit kill 0 sel-start (unbox end-box)))))]
	       
	       [backward-kill-word
		(lambda (edit event)
		  (let ([sel-start (send edit get-start-position)]
			[sel-end (send edit get-end-position)])
		    (let ([start-box (box sel-start)])
		      (send edit find-wordbreak start-box #f 'caret)
		      (send edit kill 0 (unbox start-box) sel-end))))]
	       
	       [region-click
		(lambda (edit event f)
		  (when (and (send event button-down?)
			     (is-a? edit text%))
		    (let ([x-box (box (send event get-x))]
			  [y-box (box (send event get-y))]
			  [eol-box (box #f)])
		      (send edit global-to-local x-box y-box)
		      (let ([click-pos (send edit find-position 
					     (unbox x-box)
					     (unbox y-box)
					     eol-box)]
			    [start-pos (send edit get-start-position)]
			    [end-pos (send edit get-end-position)])
			(let ([eol (unbox eol-box)])
			  (if (< start-pos click-pos)
			      (f click-pos eol start-pos click-pos)
			      (f click-pos eol click-pos end-pos)))))))]
	       [copy-click-region
		(lambda (edit event)
		  (region-click edit event
				(lambda (click eol start end)
				  (send edit flash-on start end)
				  (send edit copy #f 0 start end))))]
	       [cut-click-region
		(lambda (edit event)
		  (region-click edit event
				(lambda (click eol start end)
				  (send edit cut #f 0 start end))))]
	       [paste-click-region
		(lambda (edit event)
		  (region-click edit event
				(lambda (click eol start end)
				  (send edit set-position click)
				  (send edit paste 0 click))))]
	       
	       [mouse-copy-clipboard
		(lambda (edit event)
		  (send edit copy #f (send event get-time-stamp)))]
	       
	       [mouse-paste-clipboard
		(lambda (edit event)
		  (send edit paste (send event get-time-stamp)))]
	       
	       [mouse-cut-clipboard
		(lambda (edit event)
		  (send edit cut #f (send event get-time-stamp)))]
	       
	       [select-click-word
		(lambda (edit event)
		  (region-click edit event
				(lambda (click eol start end)
				  (let ([start-box (box click)]
					[end-box (box click)])
				    (send edit find-wordbreak 
					  start-box
					  end-box
					  'selection)
				    (send edit set-position
					  (unbox start-box)
					  (unbox end-box))))))]
	       [select-click-line
		(lambda (edit event)
		  (region-click edit event
				(lambda (click eol start end)
				  (let* ([line (send edit position-line 
						     click eol)]
					 [start (send edit line-start-position
						      line #f)]
					 [end (send edit line-end-position
						    line #f)])
				    (send edit set-position start end)))))]
	       
	       [goto-line
		(lambda (edit event)
		  (let ([num-str
			 (call/text-keymap-initializer
			  (lambda ()
			    (get-text-from-user
                             (string-constant goto-line)
                             (string-constant goto-line))))])
		    (when (string? num-str)
		      (let ([line-num (inexact->exact (string->number num-str))])
			(cond
                          [(and (number? line-num)
                                (= line-num (floor line-num))
                                (<= 1 line-num (+ (send edit last-line) 1)))
                           (let ([pos (send edit line-start-position 
                                            (sub1 line-num))])
                             (send edit set-position pos))]
                          [else
                           (message-box
                            (string-constant goto-line)
                            (format 
                             (string-constant goto-line-invalid-number)
                             num-str
                             (+ (send edit last-line) 1)))]))))
                  
		  #t)]
	       [goto-position
		(lambda (edit event)
		  (let ([num-str
			 (call/text-keymap-initializer
			  (lambda ()
			    (get-text-from-user 
                             (string-constant goto-position)
                             (string-constant goto-position))))])
		    (if (string? num-str)
			(let ([pos (string->number num-str)])
			  (when pos
                            (send edit set-position (sub1 pos))))))
		  #t)]
	       [repeater
		(lambda (n edit)
		  (let* ([km (send edit get-keymap)]
			 [done
			  (lambda ()
			    (send km set-break-sequence-callback void)
			    (send km remove-grab-key-function))])
		    (send km set-grab-key-function
			  (lambda (name local-km edit event)
			    (if name
				(begin
				  (done)
				  (dynamic-wind
				   (lambda ()
				     (send edit begin-edit-sequence))
				   (lambda ()
				     (let loop ([n n])
				       (unless (zero? n)
					 (send local-km call-function name edit event)
					 (loop (sub1 n)))))
				   (lambda ()
				     (send edit end-edit-sequence))))
				(let ([k (send event get-key-code)])
				  (if (and (char? k) (char<=? #\0 k #\9))
				      (set! n (+ (* n 10) (- (char->integer k)
							     (char->integer #\0))))
				      (begin
					(done)
					(dynamic-wind
					 (lambda ()
					   (send edit begin-edit-sequence))
					 (lambda ()
					   (let loop ([n n])
					     (unless (zero? n)
					       (send edit on-char event)
					       (loop (sub1 n)))))
					 (lambda ()
					   (send edit end-edit-sequence)))))))			       
			    #t))
		    (send km set-break-sequence-callback done)
		    #t))]
	       [make-make-repeater
		(lambda (n)
		  (lambda (edit event)
		    (repeater n edit)))]
	       [current-macro '()] 
	       [building-macro #f] [build-macro-km #f] [build-protect? #f]
               [show/hide-keyboard-macro-icon
                (lambda (edit on?)
                  (when (is-a? edit editor:basic<%>)
                    (let ([frame (send edit get-top-level-window)])
                      (when (is-a? frame frame:text-info<%>)
                        (send frame set-macro-recording on?)
                        (send frame update-shown)))))]
               
	       [do-macro
		(lambda (edit event)
                  ; If c:x;e during record, copy the old macro
		  (when building-macro
		    (set! building-macro (append (reverse current-macro) 
						 (cdr building-macro))))
		  (let ([bm building-macro]
			[km (send edit get-keymap)])
		    (dynamic-wind
		     (lambda ()
		       (set! building-macro #f)
		       (send edit begin-edit-sequence))
		     (lambda ()
		       (let/ec escape
			 (for-each
			  (lambda (f)
			    (let ([name (car f)]
				  [event (cdr f)])
			      (if name
				  (unless (send km call-function name edit event #t)
				    (escape #t))
				  (send edit on-char event))))
			  current-macro)))
		     (lambda ()
		       (send edit end-edit-sequence)
		       (set! building-macro bm))))
		  #t)]
	       [start-macro
		(lambda (edit event)
		  (if building-macro
		      (send build-macro-km break-sequence)
		      (letrec ([km (send edit get-keymap)]
			       [done
				(lambda ()
				  (if build-protect?
				      (send km set-break-sequence-callback done)
				      (begin
					(set! building-macro #f)
                                        (show/hide-keyboard-macro-icon edit #f)
					(send km set-break-sequence-callback void)
					(send km remove-grab-key-function))))])
			(set! building-macro '())
                        (show/hide-keyboard-macro-icon edit #t)
			(set! build-macro-km km)
			(send km set-grab-key-function
			      (lambda (name local-km edit event)
				(dynamic-wind
				 (lambda ()
				   (set! build-protect? #t))
				 (lambda ()
				   (if name
				       (send local-km call-function name edit event)
				       (send edit on-default-char event)))
				 (lambda ()
				   (set! build-protect? #f)))
				(when building-macro
				  (set! building-macro 
					(cons (cons name event)
					      building-macro)))
				#t))
			(send km set-break-sequence-callback done)))
		  #t)]
	       [end-macro
		(lambda (edit event)
		  (when building-macro
		    (set! current-macro (reverse building-macro))
		    (set! build-protect? #f)		    
		    (send build-macro-km break-sequence))
		  #t)]
	       [delete-key
		(lambda (edit event)
		  (let ([kmap (send edit get-keymap)])
		    (send kmap call-function
			  (if (preferences:get 'framework:delete-forward?)
			      "delete-next-character"
			      "delete-previous-character")
			  edit event #t)))]
               
	       [toggle-overwrite
		(lambda (edit event)
		  (send edit set-overwrite-mode
			(not (send edit get-overwrite-mode))))]
               
               [down-into-embedded-editor
                (lambda (text event)
                  (let ([start (send text get-start-position)]
                        [end (send text get-end-position)])
                    (when (= start end)
                      (let* ([bx (box 0)]
                             [after-snip (send text find-snip start 'after-or-none bx)])
                        (cond
                          [(and (= (unbox bx) start)
                                after-snip
                                (is-a? after-snip editor-snip%))
                           (let ([embedded-editor (send after-snip get-editor)])
                             (when (is-a? embedded-editor text%)
                               (send embedded-editor set-position 0))
                             (send embedded-editor set-caret-owner #f 'global))]
                          [else
                           (let ([before-snip (send text find-snip start 'before-or-none bx)])
                             (when (and (= (+ (unbox bx) 1) start)
                                        before-snip
                                        (is-a? before-snip editor-snip%))
                              (let ([embedded-editor (send before-snip get-editor)])
                                (when (is-a? embedded-editor text%)
                                  (send embedded-editor set-position
                                        (send embedded-editor last-position)))
                                (send embedded-editor set-caret-owner #f 'global))))]))))
                  #t)]
                             
               [forward-to-next-embedded-editor
                (lambda (text event)
                  (let ([start-pos (send text get-start-position)]
                        [end-pos (send text get-end-position)])
                    (when (= start-pos end-pos)
                      (let loop ([snip (send text find-snip start-pos 'after-or-none)])
                        (cond
                          [(not snip) (void)]
                          [(is-a? snip editor-snip%)
                           (send text set-position (send text get-snip-position snip))]
                          [else (loop (send snip next))]))))
                  #t)]
               
               [back-to-prev-embedded-editor
                (lambda (text event)
                  (let ([start-pos (send text get-start-position)]
                        [end-pos (send text get-end-position)])
                    (when (= start-pos end-pos)
                      (let loop ([snip (send text find-snip start-pos 'before-or-none)])
                        (cond
                          [(not snip) (void)]
                          [(is-a? snip editor-snip%)
                           (send text set-position (+ (send text get-snip-position snip) 1))]
                          [else (loop (send snip previous))]))))
                  #t)]
               
               [up-out-of-embedded-editor
		(lambda (text event)
                  (let ([start (send text get-start-position)]
                        [end (send text get-end-position)])
                    (when (= start end)
                      (let ([editor-admin (send text get-admin)])
                        (when (is-a? editor-admin editor-snip-editor-admin<%>)
                          (let* ([snip (send editor-admin get-snip)]
                                 [snip-admin (send snip get-admin)])
                            (when snip-admin
                              (let ([editor (send snip-admin get-editor)])
                                (when (is-a? editor text%)
                                  (let ([new-pos (send editor get-snip-position snip)])
                                    (send editor set-position new-pos new-pos))
                                  (send editor set-caret-owner #f 'display)))))))))
		  #t)]
               
               [make-read-only
                (lambda (text event)
                  (send text lock #t)
                  #t)])
               
	  (lambda (kmap)
	    (let* ([map (lambda (key func) 
			  (send kmap map-function key func))]
		   [map-meta (lambda (key func)
			       (send-map-function-meta kmap key func))]
		   [add (lambda (name func)
			  (send kmap add-function name func))]
		   [add-m (lambda (name func)
			    (send kmap add-function name func))])
              
              ; Map names to keyboard functions

	      (add "down-into-embedded-editor" down-into-embedded-editor)
              (add "up-out-of-embedded-editor" up-out-of-embedded-editor)
              (add "forward-to-next-embedded-editor" forward-to-next-embedded-editor)
              (add "back-to-prev-embedded-editor" back-to-prev-embedded-editor)

	      (add "toggle-overwrite" toggle-overwrite)
	      
	      (add "exit" (lambda (edit event)
			    (let ([frame (send edit get-frame)])
			      (if (and frame
				       (is-a? frame frame:standard-menus<%>))
				  (send frame file-menu:quit)
				  (bell)))))
	      
	      (add "ring-bell" ring-bell)
	      
	      (add "insert-()-pair" (make-insert-brace-pair "(" ")"))
	      (add "insert-[]-pair" (make-insert-brace-pair "[" "]"))
	      (add "insert-{}-pair" (make-insert-brace-pair "{" "}"))
	      (add "insert-\"\"-pair" (make-insert-brace-pair "\"" "\""))
	      (add "insert-||-pair" (make-insert-brace-pair "|" "|"))
              (add "insert-lambda-template" insert-lambda-template)
	     
	      (add "toggle-anchor" toggle-anchor)
	      (add "center-view-on-line" center-view-on-line)
	      (add "collapse-space" collapse-space)
	      (add "remove-space" remove-space)
	      (add "collapse-newline" collapse-newline)
	      (add "open-line" open-line)
	      (add "transpose-chars" transpose-chars)
	      (add "transpose-words" transpose-words)
	      (add "capitalize-word" capitalize-word)
	      (add "upcase-word" upcase-word)
	      (add "downcase-word" downcase-word)
	      (add "kill-word" kill-word)
	      (add "backward-kill-word" backward-kill-word)
	      
	      (let loop ([n 9])
		(unless (negative? n)
		  (let ([s (number->string n)])
		    (add (string-append "command-repeat-" s)
			 (make-make-repeater n))
		    (loop (sub1 n)))))
	      
	      (add "keyboard-macro-run-saved" do-macro)
	      (add "keyboard-macro-start-record" start-macro)
	      (add "keyboard-macro-end-record" end-macro)
	      
	      (add-m "copy-clipboard" mouse-copy-clipboard)
	      (add-m "cut-clipboard" mouse-cut-clipboard)
	      (add-m "paste-clipboard" mouse-paste-clipboard)
	      (add-m "copy-click-region" copy-click-region)
	      (add-m "cut-click-region" cut-click-region)
	      (add-m "paste-click-region" paste-click-region)
	      (add-m "select-click-word" select-click-word)
	      (add-m "select-click-line" select-click-line)
	      
	      (add "goto-line" goto-line)
	      (add "goto-position" goto-position)
	      
	      (add "delete-key" delete-key)
              
	      (add "mouse-popup-menu" mouse-popup-menu)

	      (add "make-read-only" make-read-only)
              
              ; Map keys to functions
              
              (map-meta "c:down" "down-into-embedded-editor")
              (map "a:c:down" "down-into-embedded-editor")
              (map-meta "c:up" "up-out-of-embedded-editor")
              (map "a:c:up" "up-out-of-embedded-editor")
              (map-meta "c:right" "forward-to-next-embedded-editor")
              (map "a:c:right" "forward-to-next-embedded-editor")
              (map-meta "c:left" "back-to-prev-embedded-editor")
              (map "a:c:left" "back-to-prev-embedded-editor")
              
	      (map "c:g" "ring-bell")
	      (map-meta "c:g" "ring-bell")
	      (map "c:x;c:g" "ring-bell")
	      (map "c:c;c:g" "ring-bell")
	      
	      (map-meta "(" "insert-()-pair")
	      (map-meta "[" "insert-[]-pair")
	      (map-meta "{" "insert-{}-pair")
	      (map-meta "\"" "insert-\"\"-pair")
	      (map-meta "|" "insert-||-pair")
	      (map-meta "s:l" "insert-lambda-template")
              
	      (map "c:p" "previous-line")
	      (map "up" "previous-line")
	      (map "s:c:p" "select-up")
	      (map "s:up" "select-up")
	      
	      (map "c:n" "next-line")
	      (map "down" "next-line")
	      (map "s:c:n" "select-down")
	      (map "s:down" "select-down")
	      
	      (map "c:e" "end-of-line")
	      (map "d:RIGHT" "end-of-line")
	      (map "m:RIGHT" "end-of-line")
	      (map "END" "end-of-line")
	      (map "d:s:RIGHT" "select-to-end-of-line")
	      (map "m:s:RIGHT" "select-to-end-of-line")
	      (map "s:END" "select-to-end-of-line")
	      (map "s:c:e" "select-to-end-of-line")
	      
	      (map "c:a" "beginning-of-line")
	      (map "d:LEFT" "beginning-of-line")
	      (map "m:LEFT" "beginning-of-line")
	      (map "HOME" "beginning-of-line")
	      (map "d:s:LEFT" "select-to-beginning-of-line")
	      (map "m:s:LEFT" "select-to-beginning-of-line")
	      (map "s:HOME" "select-to-beginning-of-line")
	      (map "s:c:a" "select-to-beginning-of-line")
	      
	      (map "c:f" "forward-character")
	      (map "right" "forward-character")
	      (map "s:c:f" "forward-select")
	      (map "s:right" "forward-select")
	      
	      (map "c:b" "backward-character")
	      (map "left" "backward-character")
	      (map "s:c:b" "backward-select")
	      (map "s:left" "backward-select")
	      
	      (map-meta "f" "forward-word")
	      (map "a:RIGHT" "forward-word")
	      (map "c:RIGHT" "forward-word")
	      (map-meta "s:f" "forward-select-word")
	      (map "a:s:RIGHT" "forward-select-word")
	      (map "c:s:RIGHT" "forward-select-word")
	      
	      (map-meta "b" "backward-word")
	      (map "a:LEFT" "backward-word")
	      
	      (map "c:left" "backward-word")
	      (map-meta "s:b" "backward-select-word")
	      (map "a:s:LEFT" "backward-select-word")
	      (map "c:s:left" "backward-select-word")
	      
	      (map-meta "<" "beginning-of-file")
	      (map "d:UP" "beginning-of-file")
	      (map "c:HOME" "beginning-of-file")
	      (map "s:c:home" "select-to-beginning-of-file")
	      (map "s:d:up" "select-to-beginning-of-file")
	      
	      (map-meta ">" "end-of-file")
	      (map "d:DOWN" "end-of-file")
	      (map "c:end" "end-of-file")
	      (map "s:c:end" "select-to-end-of-file")
	      (map "s:d:down" "select-to-end-of-file")
	      
	      (map "c:v" "next-page")
	      (map "a:DOWN" "next-page")
	      (map "pagedown" "next-page")
	      (map "c:DOWN" "next-page")
	      (map "s:c:v" "select-page-down")
	      (map "a:s:DOWN" "select-page-down")
	      (map "s:pagedown" "select-page-down")
	      (map "s:c:DOWN" "select-page-down")
	      
	      (map-meta "v" "previous-page")
	      (map "a:up" "previous-page")
	      (map "pageup" "previous-page")
	      (map "c:up" "previous-page")
	      (map-meta "s:v" "select-page-up")
	      (map "s:a:up" "select-page-up")
	      (map "s:pageup" "select-page-up")
	      (map "s:c:up" "select-page-up")
	      
	      (map "c:h" "delete-previous-character")
	      (map "c:d" "delete-next-character")
	      (map "del" "delete-key")
	      
	      (map-meta "d" "kill-word")
	      (map-meta "del" "backward-kill-word")
	      (map-meta "c" "capitalize-word")
	      (map-meta "u" "upcase-word")
	      (map-meta "l" "downcase-word")
	      
	      (map "c:l" "center-view-on-line")
	      
	      (map "c:k" "delete-to-end-of-line")
	      (map "c:y" "paste-clipboard")
	      (map-meta "y" "paste-next")
	      (map "a:v" "paste-clipboard")
	      (map "d:v" "paste-clipboard")
	      (map "c:_" "undo")
	      (map "c:/" "undo")
	      (map (format "~a" (integer->char 31)) "undo") ; for Windows - strange
	      (map "c:+" "redo")
	      (map "a:z" "undo")
	      (map "d:z" "undo")
	      (map "c:x;u" "undo")
	      (map "c:w" "cut-clipboard")
	      (map "a:x" "cut-clipboard")
	      (map "d:x" "cut-clipboard")
	      (map-meta "w" "copy-clipboard")
	      (map "a:c" "copy-clipboard")
	      (map "d:c" "copy-clipboard")
	      
	      (map "s:delete" "cut-clipboard")
	      (map "c:insert" "copy-clipboard")
	      (map "s:insert" "paste-clipboard")
              
	      (map-meta "space" "collapse-space")
              ;(map-meta "\\" "remove-space") ; Conflicts with european keyboards.
	      (map "c:x;c:o" "collapse-newline")
	      (map "c:o" "open-line")
	      (map "c:t" "transpose-chars")
	      (map-meta "t" "transpose-words")
	      
	      (map "c:space" "toggle-anchor")
	      
	      (map "insert" "toggle-overwrite")
	      (map-meta "o" "toggle-overwrite")
	      
	      (map-meta "g" "goto-line")
	      (map-meta "p" "goto-position")
	      
	      (map "c:u" "command-repeat-0")
	      (let loop ([n 9])
		(unless (negative? n)
		  (let ([s (number->string n)])
		    (map-meta s (string-append "command-repeat-" s))
		    (loop (sub1 n)))))
	      
	      (map "c:x;e" "keyboard-macro-run-saved")
	      (map "c:x;(" "keyboard-macro-start-record")
	      (map "c:x;)" "keyboard-macro-end-record")
	      
	      (map "leftbuttontriple" "select-click-line")
	      (map "leftbuttondouble" "select-click-word")
	      
	      ;; the "roller ball" mice map clicking the ball to button 2.
	      (unless (eq? (system-type) 'windows)
		(map "middlebutton" "paste-click-region"))
              
	      (map ":rightbuttonseq" "mouse-popup-menu")
              
              (map "c:c;c:r" "make-read-only")
              ))))
      
      (define setup-search
	(let* ([send-frame
		(lambda (invoke-method)
		  (lambda (edit event)
		    (let ([frame
			   (cond
                             [(is-a? edit editor<%>)
                              (let ([canvas (send edit get-active-canvas)])
                                (and canvas
                                     (send canvas get-top-level-window)))]
                             [(is-a? edit area<%>)
                              (send edit get-top-level-window)]
                             [else #f])])
		      (if frame
			  (invoke-method frame)
			  (bell)))
		    #t))])
	  (lambda (kmap)
	    (let* ([map (lambda (key func) 
			  (send kmap map-function key func))]
		   [map-meta (lambda (key func)
			       (send-map-function-meta kmap key func))]
		   [add (lambda (name func)
			  (send kmap add-function name func))]
		   [add-m (lambda (name func)
			    (send kmap add-function name func))])
	      
	      (add "move-to-search-or-search" 
		   (send-frame (lambda (f) (send f move-to-search-or-search)))) ;; key 1
	      (add "move-to-search-or-reverse-search" 
		   (send-frame (lambda (f) (send f move-to-search-or-reverse-search)))) ;; key 1b, backwards
	      (add "find-string-again" 
		   (send-frame (lambda (f) (send f search-again)))) ;; key 2
	      (add "toggle-search-focus" 
		   (send-frame (lambda (f) (send f toggle-search-focus)))) ;; key 3
	      (add "hide-search" 
		   (send-frame (lambda (f) (send f hide-search)))) ;; key 4
	      
	      (case (system-type)
		[(unix)
		 (map "c:s" "move-to-search-or-search")
		 (map-meta "%" "move-to-search-or-search")
		 (map "c:r" "move-to-search-or-reverse-search")
		 (map "f3" "find-string-again")
		 (map "c:i" "toggle-search-focus")
		 (map "c:g" "hide-search")]
		[(windows)
		 (map "c:r" "move-to-search-or-reverse-search")
		 (map "f3" "find-string-again")
		 (map "c:g" "find-string-again")	     
                 
		 ;; covered by menu
                 ;(map "c:f" "move-to-search-or-search")
                 
		 (map "c:i" "toggle-search-focus")]
		[(macos macosx)
		 (map "c:s" "move-to-search-or-search")
		 (map "c:g" "hide-search")
                 
		 ;; covered by menu
                 ;(map "d:f" "move-to-search-or-search")
                 
		 (map "d:r" "move-to-search-or-reverse-search")
		 (map "d:g" "find-string-again")
		 (map "c:i" "toggle-search-focus")])))))
      
      (define setup-file
	(let* ([get-outer-editor ;; : text% -> text%
                ;; returns the outermost editor, if this editor is nested in an editor snip.
                (lambda (edit)
                  (let loop ([edit edit])
                    (let ([admin (send edit get-admin)])
                      (cond
                        [(is-a? admin editor-snip-editor-admin<%>)
                         (loop (send (send (send admin get-snip) get-admin) get-editor))]
                        [else edit]))))]
               [save-file-as
		(lambda (this-edit event)
                  (let ([edit (get-outer-editor this-edit)])
                    (parameterize ([finder:dialog-parent-parameter 
                                    (and (is-a? edit editor:basic<%>)
                                         (send edit get-top-level-window))])
                      (let ([file (finder:put-file)])
                        (when file
                          (send edit save-file/gui-error file)))))
                  #t)]
	       [save-file
		(lambda (this-edit event)
                  (let ([edit (get-outer-editor this-edit)])
                    (if (send edit get-filename)
                        (send edit save-file/gui-error)
                        (save-file-as edit event)))
		  #t)]
	       [load-file
		(lambda (edit event)
		  (handler:open-file)
		  #t)])
	  (lambda (kmap)
	    (let* ([map (lambda (key func) 
			  (send kmap map-function key func))]
		   [map-meta (lambda (key func)
			       (send-map-function-meta kmap key func))]
		   [add (lambda (name func)
			  (send kmap add-function name func))]
		   [add-m (lambda (name func)
			    (send kmap add-function name func))])
	      
	      (add "save-file" save-file)
	      (add "save-file-as" save-file-as)
	      (add "load-file" load-file)
	      
	      (map "c:x;c:s" "save-file")
	      (map "d:s" "save-file")
	      (map "c:x;c:w" "save-file-as")
	      (map "c:x;c:f" "load-file")))))
      
      (define (setup-editor kmap)
	(let ([add/map
	       (lambda (func op key)
		 (send kmap add-function
		       func
		       (lambda (editor evt)
			 (send editor do-edit-operation op)))
		 (send kmap map-function
		       (string-append
			(case (system-type)
			  [(macosx macos) "d:"]
			  [(windows) "c:"]
			  [(unix) "a:"]
			  [else (error 'keymap.ss "unknown platform: ~s" (system-type))])
			key)
		       func))])
	  (add/map "editor-undo" 'undo "z")
	  (add/map "editor-redo" 'redo "y")
	  (add/map "editor-cut" 'cut "x")
	  (add/map "editor-copy" 'copy "c")
	  (add/map "editor-paste" 'paste "v")
	  (add/map "editor-select-all" 'select-all "a")))
      
      (define (generic-setup keymap)
	(add-editor-keymap-functions keymap)
	(add-pasteboard-keymap-functions keymap)
	(add-text-keymap-functions keymap))
      
      (define global (make-object aug-keymap%))
      (setup-global global)
      (generic-setup global)
      (define (get-global) global)
      
      (define file (make-object aug-keymap%))
      (setup-file file)
      (generic-setup file)
      (define (-get-file) file)
      
      (define search (make-object aug-keymap%))
      (generic-setup search)
      (setup-search search)
      (define (get-search) search)
      
      (define editor (make-object aug-keymap%))
      (setup-editor editor)
      (define (get-editor) editor)
      
      (define (call/text-keymap-initializer thunk)
	(let ([ctki (current-text-keymap-initializer)])
	  (parameterize ([current-text-keymap-initializer
			  (lambda (keymap)
			    (send keymap chain-to-keymap global #t)
			    (ctki keymap))])
	    (thunk)))))))