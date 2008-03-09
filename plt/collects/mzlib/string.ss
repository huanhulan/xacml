
(module string mzscheme
  (provide string-lowercase!
	   string-uppercase!
	   eval-string
	   read-from-string
	   read-from-string-all
	   expr->string
	   regexp-quote
	   regexp-replace-quote
	   regexp-match*
	   regexp-match-positions*
	   regexp-match-peek-positions*
	   regexp-split
	   regexp-match-exact?
           regexp-match/fail-without-reading)

  (require (lib "etc.ss"))

  (define make-string-do!
    (lambda (translate)
      (lambda (s)
	(let loop ([n (sub1 (string-length s))])
	  (unless (negative? n)
	    (string-set! s n
			 (translate (string-ref s n)))
	    (loop (sub1 n)))))))
  (define string-lowercase! (make-string-do! char-downcase))
  (define string-uppercase! (make-string-do! char-upcase))

  (define eval-string
    (let ([do-eval
	   (lambda (str)
	     (let ([p (open-input-string str)])
	       (apply
		values
		(let loop ()
		  (let ([e (read p)])
		    (if (eof-object? e)
			'()
			(call-with-values
			    (lambda () (eval e))
			  (case-lambda
			   [() (loop)]
			   [(only) (cons only (loop))]
			   [multi 
			    (append multi (loop))]))))))))])
      (case-lambda
       [(str) (eval-string str #f #f)]
       [(str error-display) (eval-string str error-display #f)]
       [(str error-display error-result)
	(if (or error-display error-result)
	    (with-handlers ([void
			     (lambda (exn)
			       ((or error-display (lambda (x)
						    ((error-display-handler) x exn)))
				(exn-message exn))
			       (if error-result
				   (error-result)
				   #f))])
	      (do-eval str))
	    (do-eval str))])))

  (define read-from-string-one-or-all
    (case-lambda
     [(k all? str) (read-from-string-one-or-all k all? str #f #f)]
     [(k all? str error-display) (read-from-string-one-or-all k all? str error-display #f)]
     [(k all? str error-display error-result)
      (let* ([p (open-input-string str)]
	     [go (lambda ()
		   (let loop ()
		     (let ([v (read p)])
		       (if (eof-object? v)
			   '()
			   (cons v
				 (if all?
				     (loop)
				     '()))))))])
	(if error-display
	    (with-handlers ([void
			     (lambda (exn)
			       ((or error-display (lambda (x)
						    ((error-display-handler) x exn)))
				(exn-message exn))
			       (k (if error-result
				      (error-result)
				      #f)))])
	      (go))
	    (go)))]))

  (define read-from-string
    (lambda args
      (let/ec k
	(let ([l (apply read-from-string-one-or-all k #f args)])
	  (if (null? l)
	      eof
	      (car l))))))
  
  (define read-from-string-all
    (lambda args
      (let/ec k
	(apply read-from-string-one-or-all k #t args))))
  
  (define expr->string
    (lambda (v)
      (let ([port (open-output-string)])
	(write v port)
	(get-output-string port))))
  
  (define regexp-quote
    (opt-lambda (s [case-sens? #t])
      (unless (string? s)
	(raise-type-error 'regexp-quote "string" s))
      (list->string
       (apply
	append
	(map
	 (lambda (c)
	   (cond 
	    [(memq c '(#\$ #\| #\\ #\[ #\] #\. #\* #\? #\+ #\( #\) #\^))
	     (list #\\ c)]
	    [(and (char-alphabetic? c)
		  (not case-sens?))
	     (list #\[ (char-upcase c) (char-downcase c) #\])]
	    [else (list c)]))
	 (string->list s))))))

  (define (regexp-replace-quote s)
    (unless (string? s)
      (raise-type-error 'regexp-replace-quote "string" s))
    (regexp-replace* "&" (regexp-replace* "\\\\" s "\\\\\\\\") "\\\\&"))

  (define regexp-match/fail-without-reading
    (opt-lambda (pattern input-port [start-k 0] [end-k #f] [out #f])
      (unless (input-port? input-port)
        (raise-type-error 'regexp-match/fail-without-reading "input port" input-port))
      (unless (or (not out) (output-port? out))
        (raise-type-error 'regexp-match/fail-without-reading "output port or #f" out))
      (let ([m (regexp-match-peek-positions pattern input-port start-k end-k)])
        (and m
             ;; What happens if someone swipes our chars before we can get them?
             (let ([drop (caar m)])
               ;; drop prefix before match:
               (let ([s (read-string drop input-port)])
		 (when out
		   (display s out)))
	       ;; Get the matching part, and shift matching indicies
               (let ([s (read-string (- (cdar m) drop) input-port)])
                 (cons s
                       (map (lambda (p)
                              (and p (substring s (- (car p) drop) (- (cdr p) drop))))
                            (cdr m)))))))))

  ;; Helper function for the regexp functions below.
  (define (regexp-fn name success-k port-success-k failure-k port-failure-k 
		     need-leftover? peek?)
    (lambda (pattern string start end)

      (unless (or (string? pattern) (regexp? pattern))
	(raise-type-error name "regexp or string" pattern))
      (if peek?
	  (unless (input-port? string)
	    (raise-type-error name "input-port" string))
	  (unless (or (string? string) (input-port? string))
	    (raise-type-error name "string or input-port" string)))
      (unless (and (number? start) (exact? start) (integer? start) (start . >= . 0))
	(raise-type-error name "non-negative exact integer" start))
      (unless (or (not end) 
		  (and (number? end) (exact? end) (integer? end) (end . >= . 0)))
	(raise-type-error name "non-negative exact integer or false" end))
      (unless (or (input-port? string)
		  (start . <= . (string-length string)))
	(raise-mismatch-error
	 name
	 (format "starting offset index out of range [0,~a]: " 
		 (string-length string))
	 start))
      (unless (or (not end)
		  (and (start . <= . end)
		       (or (input-port? string)
			   (end . <= . (string-length string)))))
	(raise-mismatch-error
	 name
	 (format "ending offset index out of range [~a,~a]: " 
		 end
		 (string-length string))
	 start))

      (when (and (positive? start)
		 (input-port? string)
		 need-leftover?)
	;; Skip start chars:
	(let ([s (make-string 4096)])
	  (let loop ([n 0])
	    (unless (= n start)
	      (let ([m (read-string-avail! s string 0 (min (- start n) 4096))])
		(unless (eof-object? m)
		  (loop (+ n m))))))))

      (let ((expr (if (regexp? pattern) 
		      pattern 
		      (regexp pattern))))
	(if (and (input-port? string)
		 port-success-k)
	    ;; Input port match, get string
	    (let ([discarded 0]
		  [leftover-port (and need-leftover?
				      (open-output-string))])
	      (let ([match (regexp-match expr string 
					 (if need-leftover? 0 start) 
					 (and end (if need-leftover? (- end start) end))
					 (if need-leftover?
					     leftover-port
					     (make-custom-output-port
					      #f
					      (lambda (s start end flush?)
						(let ([c (- end start)])
						  (set! discarded (+ c discarded))
						  c))
					      void
					      void)))]
		    [leftovers (and need-leftover?
				    (get-output-string leftover-port))])
		(if match
		    (port-success-k expr string (car match) 
				    (and end (- end 
						(if need-leftover?
						    (+ (string-length leftovers) start)
						    discarded)
						(string-length (car match))))
				    leftovers)
		    (port-failure-k leftovers))))
	    ;; String/port match, get positions
	    (let ([match ((if peek?
			      regexp-match-peek-positions
			      regexp-match-positions) 
			  expr string start end)])
	      (if match
		  (let ((match-start (caar match))
			(match-end (cdar match)))
		    (when (= match-start match-end)
		      (error name "pattern matched a zero-length substring"))
		    (success-k expr string start end match-start match-end))
		  (failure-k expr string start end)))))))

  (define-syntax wrap
    (syntax-rules ()
      [(_ out orig)
       (define out 
	 (opt-lambda (pattern string [start 0] [end #f])
	   (orig pattern string start end)))]))

  ;; Returns all the positions at which the pattern matched.
  (define -regexp-match-positions*
    (regexp-fn 'regexp-match-positions*
	       ;; success-k:
	       (lambda (expr string start end match-start match-end)
		 (cons (cons match-start match-end)
		       (if (string? string)
			   (regexp-match-positions* expr string match-end end)
			   ;; Need to shift index of rest as reading:
			   (map (lambda (p)
				  (cons (+ match-end (car p))
					(+ match-end (cdr p))))
				(regexp-match-positions* expr string 0 (and end (- end match-end)))))))
	       ;; port-success-k --- use string case
	       #f
	       ;; fail-k:
	       (lambda (expr string start end)
		 null)
	       ;; port-fail-k --- use string case
	       #f
	       #f
	       #f))
  (wrap regexp-match-positions* -regexp-match-positions*)

  ;; Returns all the positions at which the pattern matched.
  (define -regexp-match-peek-positions*
    (regexp-fn 'regexp-match-peek-positions*
	       ;; success-k:
	       (lambda (expr string start end match-start match-end)
		 (cons (cons match-start match-end)
		       (regexp-match-peek-positions* expr string match-end end)))
	       ;; port-success-k --- use string case
	       #f
	       ;; fail-k:
	       (lambda (expr string start end)
		 null)
	       ;; port-fail-k --- use string case
	       #f
	       #f
	       #t))
  (wrap regexp-match-peek-positions* -regexp-match-peek-positions*)

  ;; Splits a string into a list by removing any piece which matches
  ;; the pattern.
  (define -regexp-split
    (regexp-fn 'regexp-split
	       ;; success-k
	       (lambda (expr string start end match-start match-end)
		 (cons
		  (substring string start match-start)
		  (regexp-split expr string match-end end)))
	       ;; port-success-k:
	       (lambda (expr string match-string new-end leftovers)
		 (cons 
		  leftovers
		  (regexp-split expr string 0 new-end)))
	       ;; failure-k:
	       (lambda (expr string start end)
		 (list
		  (substring string start (or end (string-length string)))))
	       ;; port-fail-k
	       (lambda (leftover)
		 (list leftover))
	       #t
	       #f))
  (wrap regexp-split -regexp-split)

  ;; Returns all the matches for the pattern in the string.
  (define -regexp-match*
    (regexp-fn 'regexp-match*
	       ;; success-k:
	       (lambda (expr string start end match-start match-end)
		 (cons
		  (substring string match-start match-end)
		  (regexp-match* expr string match-end end)))
	       ;; port-success-k:
	       (lambda (expr string match-string new-end leftovers)
		 (cons
		  match-string
		  (regexp-match* expr string 0 new-end)))
	       ;; fail-k:
	       (lambda (expr string start end)
		 null)
	       ;; port-fail-k:
	       (lambda (leftover)
		 null)
	       #f
	       #f))
  (wrap regexp-match* -regexp-match*)

  (define regexp-match-exact?
    (lambda (p s)
      (let ([m (regexp-match-positions p s)])
	(and m
	     (zero? (caar m))
	     (= (string-length s) (cdar m)))))))