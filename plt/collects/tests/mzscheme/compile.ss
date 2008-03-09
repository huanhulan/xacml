
; Tests compilation and writing/reading compiled code
;  by setting the eval handler and running all tests

(load-relative "loadtest.ss")

(namespace-variable-value 
 'compile-load
 #f
 (lambda ()
   (namespace-set-variable-value! 'compile-load "quiet.ss")))

(define file
  (if #f
      (open-output-file "x" 'replace)
      (make-custom-output-port #f (lambda (s start end flush?) (- end start)) void void)))

(define try-one
  (lambda (e)
    (let ([c (compile-syntax e)]
	  [ec (compile-syntax (expand e))]
	  [p (open-output-string)]
	  [ep (open-output-string)])
      (write c p)
      (write ec ep)
      (let ([s (get-output-string p)]
	    [es (get-output-string ep)])
	(unless (equal? s es)
	  (error 'try "bad expand ~e~n" e))
	; (write (string->list s)) (newline)
	(let ([e (parameterize ([read-accept-compiled #t])
		     (read (open-input-string s)))])
	  (eval e))))))

(letrec ([orig (current-eval)]
	 [orig-load (current-load)]
	 [my-load
	  (lambda (filename expected-module)
	    (let ([f (open-input-file filename)])
	      (dynamic-wind
	       void
	       (lambda ()
		 (let loop ([results (list (void))])
		   (let ([v (parameterize ([read-accept-compiled #t])
			       (read f))])
		     (if (eof-object? v)
			 (apply values results)
			 (loop (call-with-values
				(lambda () (my-eval v orig))
				list))))))
	       (lambda ()
		 (close-input-port f)))))]
	 [my-eval
	  (case-lambda 
	   [(x next-eval)
	    (if (or (compiled-expression? x)
		    (and (syntax? x) (compiled-expression? (syntax-e x)))
		    (current-module-name-prefix))
		(next-eval x)
		(begin
		  ;; (fprintf file ": ~a~n" +)
		  ;; (write x file) (newline file)
		  (let ([p (open-output-string)]
			[ep (open-output-string)]
			[c ((if (syntax? x) compile-syntax compile) x)]
			[ec (compile-syntax ((if (syntax? x) expand-syntax expand) x))])
		    (write c p)
		    (write ec ep)
		    (let ([s (get-output-string p)]
			  [es (get-output-string ep)])
		      (unless (equal? s es)
			'(fprintf (current-error-port) "bad expand (~a,~a) ~e~n" 
				  (string-length s) (string-length es) x))
					; (display s file) (newline file)
		      (let ([e (parameterize ([read-accept-compiled #t])
				 (read (open-input-string s)))])
					; (write e file) (newline file)
			(parameterize ([current-eval next-eval])
			  (orig e)))))))]
	   [(x) (my-eval x orig)])])
  (dynamic-wind
   (lambda ()
     (set! teval (lambda (x) (my-eval x my-eval)))
     ; (read-accept-compiled #t)
     (current-eval my-eval)
     (current-load my-load))
   (lambda ()
     (load-relative compile-load))
   (lambda ()
     (set! teval eval)
     (close-output-port file)
     ; (read-accept-compiled #f)
     (current-eval orig)
     (current-load orig-load))))

; Check compiled number I/O:
(let ([l (let loop ([n -512][l null])
	   (if (= n 513)
	       l
	       (loop (add1 n) (cons n l))))]
      [p (open-output-string)])
  (write (compile `(quote ,l)) p)
  (let ([s (open-input-string (get-output-string p))])
    (let ([l2 (parameterize ([read-accept-compiled #t])
		    (eval (read s)))])
      (test #t equal? l l2))))

(report-errs)