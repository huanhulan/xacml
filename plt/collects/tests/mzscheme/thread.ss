

(load-relative "loadtest.ss")

(SECTION 'threads)

(define SLEEP-TIME 0.1)

;; ----------------------------------------

(define t (thread (lambda () 8)))
(test #t thread? t)

(arity-test thread 1 1)
(err/rt-test (thread 5) type?)
(err/rt-test (thread (lambda (x) 8)) type?)
(arity-test thread? 1 1)

;; ----------------------------------------
;; Thread sets

(define (test-set-balance as bs cs ds
			  sa sb sc sd
			  a% b% c% d%)
  (let ([a (box 0)]
	[b (box 0)]
	[c (box 0)]
	[d (box 0)]
	[stop? #f])
    
    (define (go box s s-amt)
      (parameterize ([current-thread-group s])
	(thread (lambda ()
		  (let loop ()
		    (set-box! box (add1 (unbox box)))
		    (sleep s-amt)
		    (unless stop?
		      (loop)))))))
    
    (go a as sa)
    (go b bs sb)
    (go c cs sc)
    (go d ds sd)

    (sleep SLEEP-TIME)

    (set! stop? #t)

    (let ([va (/ (unbox a) a%)]
	  [vb (unbox b)]
	  [vc (unbox c)]
	  [vd (unbox d)])
      (define (roughly= x y)
	(<= (* (- x 1) 0.9) y (* (+ x 1) 1.1)))

      (test #t roughly= vb (* b% va))
      (test #t roughly= vc (* c% va))
      (test #t roughly= vd (* d% va)))))

;; Simple test:
(let ([ts (make-thread-group)])
  (test-set-balance (current-thread-group) ts ts ts
		    0 0 0 0
		    1 1/3 1/3 1/3))

;; Make two sets, should be balanced:
(let ([ts1 (make-thread-group)]
      [ts2 (make-thread-group)])
  (test-set-balance ts1 ts2 ts2 ts1
		    0 0 0 0
		    1 1 1 1))

;; Like first test, but with an explicit "root" set
(let* ([ts1 (make-thread-group)]
       [ts2 (make-thread-group ts1)])
  (test-set-balance ts1 ts2 ts2 ts2
		    0 0 0 0
		    1 1/3 1/3 1/3))

;; Like second test, but with an explicit "root" set
(let* ([ts0 (make-thread-group)]
       [ts1 (make-thread-group ts0)]
       [ts2 (make-thread-group ts0)])
  (test-set-balance ts1 ts2 ts2 ts1
		    0 0 0 0
		    1 1 1 1))

;; Check that suspended threads don't break
;;  scheduling. (The test really continues past this
;;  one, since the threads don't die right away.)
(let* ([ts0 (make-thread-group)]
       [ts1 (make-thread-group ts0)]
       [ts2 (make-thread-group ts0)])
  (test-set-balance ts1 ts2 ts2 ts1
		    0 0 (* SLEEP-TIME 10) (* SLEEP-TIME 10)
		    1 1 0 0))

(arity-test make-thread-group 0 1)
(err/rt-test (make-thread-group 5) type?)
(arity-test thread-group? 1 1)
(test #t thread-group? (make-thread-group))
(test #f thread-group? 5)
(arity-test current-thread-group 0 1)
(err/rt-test (current-thread-group 5))

;; ----------------------------------------

; Should be able to make an arbitrarily deep chain of custodians
; if only the first & last are accssible:
(test #t custodian?
      (let loop ([n 1000][c (current-custodian)])
	(if (zero? n)
	    c
	    (loop (sub1 n) (make-custodian c)))))

(define result 0)
(define th1 0)
(define set-ready
  (let ([s (make-semaphore 1)]
	[r #f])
    (lambda (v)
      (semaphore-wait s)
      (begin0
       r
       (set! r v)
       (semaphore-post s)))))
(define cm (make-custodian))
(define th2 (parameterize ([current-custodian cm])
              (thread 
	       (lambda ()
		 (let ([cm2 (make-custodian cm)])
		   (parameterize ([current-custodian cm2])
		      (set! th1 (thread 
				 (lambda ()
				   (let loop ()
				     (let ([r (set-ready #f)])
				       (sleep SLEEP-TIME)
				       (set! result (add1 result))
				       (when r (semaphore-post r)))
				     (loop)))))))))))
(define start result)
(let ([r (make-semaphore)])
  (set-ready r)
  (semaphore-wait r))
(test #f eq? start result)
(kill-thread th2)
(set! start result)
(let ([r (make-semaphore)])
  (set-ready r)
  (semaphore-wait r))
(test #f eq? start result)
(test #t thread-running? th1)
(test #f thread-dead? th1)
(custodian-shutdown-all cm)
(thread-wait th1)
(set! start result)
(test #f thread-running? th1)
(test #t thread-dead? th1)
(sleep SLEEP-TIME)
(test #t eq? start result)

(let ([kept-going? #f])
  (let ([c (make-custodian)])
    (parameterize ([current-custodian c])
     (thread-wait
      (thread
       (lambda ()
	 (custodian-shutdown-all c)
	 (set! kept-going? #t))))))
  (test #f 'kept-going-after-shutdown? kept-going?))

(err/rt-test (parameterize ([current-custodian cm]) (kill-thread (current-thread)))
	     exn:application:mismatch?)

(test #t custodian? cm)
(test #f custodian? 1)
(arity-test custodian? 1 1)

(arity-test custodian-shutdown-all 1 1)
(err/rt-test (custodian-shutdown-all 0))

(arity-test make-custodian 0 1)
(err/rt-test (make-custodian 0))

(test (void) kill-thread t)
(arity-test kill-thread 1 1)
(err/rt-test (kill-thread 5) type?)

(arity-test break-thread 1 1)
(err/rt-test (break-thread 5) type?)

(arity-test thread-wait 1 1)
(err/rt-test (thread-wait 5) type?)

(test #t thread-running? (current-thread))
(arity-test thread-running? 1 1)
(err/rt-test (thread-running? 5) type?)

(test #f thread-dead? (current-thread))
(arity-test thread-dead? 1 1)
(err/rt-test (thread-dead? 5) type?)

(arity-test sleep 0 1)
(err/rt-test (sleep 'a) type?)
(err/rt-test (sleep 1+3i) type?)
(err/rt-test (sleep -1.0) type?)

(define s (make-semaphore 1))

(test #t semaphore? s)

(arity-test make-semaphore 0 1)
(err/rt-test (make-semaphore "a") type?)
(err/rt-test (make-semaphore -1) type?)
(err/rt-test (make-semaphore 1.0) type?)
(err/rt-test (make-semaphore (expt 2 64)) exn:application:mismatch?)
(arity-test semaphore? 1 1)

(define test-block
  (lambda (block? thunk)
    (let* ([hit? #f]
	   [t (parameterize ([current-custodian (make-custodian)])
		(thread (lambda () (thunk) (set! hit? #t))))])
      (sleep SLEEP-TIME)
      (begin0 (test block? 'nondeterministic-block-test (not hit?))
	      (kill-thread t)))))

(test #t semaphore-try-wait? s) 
(test #f semaphore-try-wait? s) 
(semaphore-post s) 
(test #t semaphore-try-wait? s) 
(test #f semaphore-try-wait? s) 
(semaphore-post s) 
(test-block #f (lambda () (semaphore-wait s)))
(test-block #t (lambda () (semaphore-wait s)))
(semaphore-post s) 
(test-block #f (lambda () (semaphore-wait/enable-break s)))
(test-block #t (lambda () (semaphore-wait/enable-break s)))

(arity-test semaphore-try-wait? 1 1)
(arity-test semaphore-wait 1 1)
(arity-test semaphore-post 1 1)

(define s (make-semaphore))
(define result 0)
(define t-loop
  (lambda (n m)
    (lambda ()
      (if (zero? n)
	  (begin
	    (set! result m)
	    (semaphore-post s))
	  (thread (t-loop (sub1 n) (add1 m)))))))
(thread (t-loop 25 1))
(semaphore-wait s)
(test 26 'thread-loop result)

; Make sure you can break a semaphore-wait:
'(test 'ok
      'break-semaphore-wait
      (let* ([s1 (make-semaphore 0)]
	     [s2 (make-semaphore 0)]
	     [t (thread (lambda ()
			  (semaphore-post s1)
			  (with-handlers ([exn:break? (lambda (x) (semaphore-post s2))])
			    (semaphore-wait (make-semaphore 0)))))])
	(semaphore-wait s1)
	(sleep SLEEP-TIME)
	(break-thread t)
	(semaphore-wait s2)
	'ok))

; Make sure two waiters can be released
(test 'ok
      'double-semaphore-wait
      (let* ([s1 (make-semaphore 0)]
	     [s2 (make-semaphore 0)]
	     [go (lambda ()
		   (semaphore-post s2)
		   (semaphore-wait s1)
		   (semaphore-post s2))])
	(thread go) (thread go)
	(semaphore-wait s2) (semaphore-wait s2)
	(semaphore-post s1) (semaphore-post s1)
	(semaphore-wait s2) (semaphore-wait s2)
	'ok))

; Tests inspired by a question from David Tillman
(define (read-line/expire1 port expiration)
  (with-handlers ([exn:break? (lambda (exn) #f)])
    (let ([timer (thread (let ([id (current-thread)])
			   (lambda () 
			     (sleep expiration)
			     (break-thread id))))])
      (dynamic-wind
       void
       (lambda () (read-line port))
       (lambda () (kill-thread timer))))))
(define (read-line/expire2 port expiration)
  (let ([done (make-semaphore 0)]
	[result #f])
    (let ([t1 (thread (lambda () 
			(set! result (read-line port))
			(semaphore-post done)))]
	  [t2 (thread (lambda () 
			(sleep expiration)
			(semaphore-post done)))])
      (semaphore-wait done)
      (kill-thread t1)
      (kill-thread t2)
      result)))
;; the main thread is special for semaphore blocking,
;;  so we try read-line/expire1 in sub-threads for a couple
;;  of configurations:
(define (read-line/expire3 port expiration)
  (call-in-nested-thread (lambda ()
			   (read-line/expire1 port expiration))))
(define (read-line/expire4 port expiration)
  (let ([v #f])
    (let ([t (thread (lambda ()
		       (set! v (read-line/expire1 port expiration))))])
      (thread-wait t)
      v)))

(define (go read-line/expire)
  (define p (let ([c 0]
		  [nl-sema (make-semaphore 1)]
		  [ready? #f]
		  [nl? #f])
	      (make-custom-input-port 
	       (lambda (s) 
		 (let ([c (if nl?
			      (if ready?
				  #\newline
				  nl-sema)
			      (begin
				(set! nl? #t)
				(semaphore-try-wait? nl-sema)
				(set! ready? #f)
				(thread (lambda ()
					  (sleep 0.4)
					  (set! ready? #t)
					  (semaphore-post nl-sema)))
				(set! c (add1 c))
				(integer->char c)))])
		   (if c
		       (if (char? c)
			   (begin
			     (string-set! s 0 c)
			     1)
			   c)
		       0)))
	       #f
	       void)))
  (test #f read-line/expire p 0.2) ; should get char but not newline
  (test "" read-line/expire p 0.6)) ; picks up newline

(go read-line/expire1)
(go read-line/expire2)
(go read-line/expire3)
(go read-line/expire4)

;; Make sure queueing works, and check kill/wait interaction:
(let* ([s (make-semaphore)]
       [l null]
       [wait (lambda (who)
	       (thread
		(lambda ()
		  (semaphore-wait s)
		  (set! l (cons who l)))))]
       [pause (lambda () (sleep 0.01))])
  (wait 0) (pause)
  (wait 1) (pause)
  (wait 2)
  (pause)
  (test null 'queue l)
  (semaphore-post s) (pause)
  (test '(0) 'queue l)
  (semaphore-post s) (pause)
  (test '(1 0) 'queue l)
  (semaphore-post s) (pause)
  (test '(2 1 0) 'queue l)
  
  (set! l null)
  (wait 0) (pause)
  (let ([t (wait 1)])
    (pause)
    (wait 2)
    (pause)
    (test null 'queue l)
    (kill-thread t)
    (semaphore-post s) (pause)
    (test '(0) 'queue l)
    (semaphore-post s) (pause)
    (test '(2 0) 'queue l)
    (semaphore-post s) (pause)
    (test '(2 0) 'queue l)
    (wait 3) (pause)
    (test '(3 2 0) 'queue l)))

;; Nested threads
(test 5 call-in-nested-thread (lambda () 5))

(err/rt-test (call-in-nested-thread (lambda () (kill-thread (current-thread)))) exn:thread?)
(err/rt-test (call-in-nested-thread (lambda () ((error-escape-handler)))) exn:thread?)
(err/rt-test (call-in-nested-thread (lambda () (raise (box 5)))) box?)

(define output-stream null)
(define (output v)
  (set! output-stream 
	(append output-stream (list v))))
(define (test-stream v)
  (test v 'output-stream output-stream))

(define (chain c)
  (define c1 (make-custodian))
  (define c2 (make-custodian))
  (define c3 (make-custodian))


  (set! output-stream null)
  
  (output 'os)
  (with-handlers ([void (lambda (x) x)])
    (call-in-nested-thread
     (lambda ()
       (output 'ms)
       (begin0
	(dynamic-wind
	 (lambda () (output 'mpre))
	 (lambda ()
	   (let ([t1 (current-thread)])
	     (call-in-nested-thread
	      (lambda ()
		(output 'is)
		(with-handlers ([void (lambda (x) 
					(if (exn:break? x)
					    (output 'ibreak)
					    (output 'iother))
					(raise x))])
		  (let ([get-c (lambda (c)
				 (case c
				   [(1) c1]
				   [(2) c2]
				   [(3) c3]
				   [else c]))])
		    (if (procedure? c)
			(c t1 get-c)
			(custodian-shutdown-all (get-c c)))))
		(output 'ie)
		'inner-result)
	      c2)))
	 (lambda () (output 'mpost)))
	(output 'me)))
     c1)))

(test 'inner-result chain 3)
(test-stream '(os ms mpre is ie mpost me))

(test #t exn:thread? (chain 1))
(test-stream '(os ms mpre is ibreak))

(parameterize ([break-enabled #f])
  (test #t exn:thread? (chain 1))
  (test-stream '(os ms mpre is ie))
  (test (void) 'discard-break
	(with-handlers ([void void])
	  (break-enabled #t)
	  (sleep)
	  'not-void)))

(test #t exn:thread? (chain 2))
(test-stream '(os ms mpre is mpost))

(test #t exn:thread? (chain (lambda (t1 get-c) (kill-thread (current-thread)))))
(test-stream '(os ms mpre is mpost))

(test #t exn:application? (chain 'wrong))
(test-stream '(os ms mpre is iother mpost))

(test #t exn:break? (chain (let ([t (current-thread)]) (lambda (t1 get-c) (break-thread t)))))
(test-stream '(os ms mpre is ibreak mpost))

(test #t exn:thread? (chain (lambda (t1 get-c) (kill-thread t1))))
(test-stream '(os ms mpre is ibreak))

(parameterize ([break-enabled #f])
  (test #t exn:thread? (let ([t (current-thread)])
			 (chain (lambda (t1 get-c)
				  (custodian-shutdown-all (get-c 1))
				  (test #t thread-running? (current-thread))
				  (test #t thread-running? t)
				  (test #f thread-running? t1)))))
  (test-stream '(os ms mpre is ie))
  (test (void) 'discard-break
	(with-handlers ([void void])
	  (break-enabled #t)
	  (sleep)
	  'not-void)))

(err/rt-test (let/cc k (call-in-nested-thread (lambda () (k)))) exn:application:continuation?)
(err/rt-test (let/ec k (call-in-nested-thread (lambda () (k)))) exn:application:continuation?)
(err/rt-test ((call-in-nested-thread (lambda () (let/cc k k)))) exn:application:continuation?)
(err/rt-test ((call-in-nested-thread (lambda () (let/ec k k)))) exn:application:continuation?)

(err/rt-test (call-in-nested-thread 5))
(err/rt-test (call-in-nested-thread (lambda (x) 10)))
(err/rt-test (call-in-nested-thread (lambda () 10) 5))

(arity-test call-in-nested-thread 1 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test wait-multiple:

(let ([s (make-semaphore 1)]
      [s2 (make-semaphore 1)])
  (let ([w (list
	    (object-wait-multiple #f s s2)
	    (object-wait-multiple #f s s2))])
    (test #t 'both (or (equal? w (list s s2))
		       (equal? w (list s2 s))))
    (test #f semaphore-try-wait? s)
    (test #f semaphore-try-wait? s2)))

;; same test, but throw in an empty pipe to avoid the
;;  special case for just semaphores:
(let ([s (make-semaphore 1)]
      [s2 (make-semaphore 1)])
  (let-values ([(r w) (make-pipe)])
    (let ([w (list
	      (object-wait-multiple #f s r s2)
	      (object-wait-multiple #f s r s2))])
      (test #t 'both (or (equal? w (list s s2))
			 (equal? w (list s2 s))))
      (test #f semaphore-try-wait? s)
      (test #f semaphore-try-wait? s2))))

(let ([s (make-semaphore)]
      [s-t (make-semaphore)]
      [portnum (+ 40000 (random 100))]) ; so parallel tests work ok
  (let ([t (thread
	    (lambda ()
	      (object-wait-multiple #f s-t)))]
	[l (tcp-listen portnum 5 #t)]
	[orig-thread (current-thread)])
    (let-values ([(r w) (make-pipe)])
      
      (define (try-all-blocked* wait)
	(let ([v #f])
	  (let ([bt (thread
		     (lambda ()
		       (with-handlers ([exn:break? (lambda (x) (set! v 'break))])
			 (set! v (wait #f s t l r)))))])
	    (sleep 0.05) ;;;     <---------- race condition (that's unlikely to fail)
	    (break-thread bt)
	    (sleep 0.05) ;;;     <----------
	    )
	  (test 'break 'broken-wait v)))

      (define (try-all-blocked)
	(test #f object-wait-multiple 0.05 s t l r))

      (try-all-blocked* object-wait-multiple)
      (try-all-blocked* object-wait-multiple/enable-break)
      (parameterize ([break-enabled #f])
	(try-all-blocked* object-wait-multiple/enable-break))

      (display #\x w)
      (test r object-wait-multiple #f s t l r)
      (test r object-wait-multiple #f s t l r)
      (peek-char r)
      (test r object-wait-multiple #f s t l r)
      (read-char r)
      (try-all-blocked)
	  
      ;; pipe write always available, since no limit:
      (test w object-wait-multiple #f s t l r w)

      (semaphore-post s)
      (test s object-wait-multiple #f s t l r)
      (try-all-blocked)

      (semaphore-post s-t)
      (test t object-wait-multiple #f s t l r)
      (test t object-wait-multiple #f s t l r)

      (set! t (thread (lambda () (semaphore-wait (make-semaphore)))))

      (let-values ([(cr cw) (tcp-connect "localhost" portnum)])
	(test l object-wait-multiple #f s t l r)
	(test l object-wait-multiple #f s t l r)

	(let-values ([(sr sw) (tcp-accept l)])
	  (try-all-blocked)

	  (close-output-port w)
	  (test r object-wait-multiple #f s t l r)
	  (test r object-wait-multiple #f s t l r)

	  (set! r cr)
	  (try-all-blocked)

	  (display #\y sw)
	  (test cr object-wait-multiple #f s t l sr cr)
	  (read-char cr)
	  (try-all-blocked)
	  (test sw object-wait-multiple #f s t l sr cr sw)
	  
	  (display #\z cw)
	  (test sr object-wait-multiple #f s t l sr cr)
	  (read-char sr)
	  (try-all-blocked)
	  (test cw object-wait-multiple #f s t l sr cr cw)

	  ;; Fill up output buffer:
	  (test sw object-wait-multiple 0 sw)
	  (test #t
		positive?
		(let loop ([n 0])
		  (if (and (object-wait-multiple 0 sw)
			   (= 4096 (write-string-avail (make-string 4096 #\x) sw)))
		      (loop (add1 n))
		      n)))
	  (test #f object-wait-multiple 0 sw sr)
	  (test cr object-wait-multiple 0 sw sr cr)
	  ;; Flush cr:
	  (let ([s (make-string 4096)])
	    (let loop ()
	      (when (and (char-ready? cr)
			 (= 4096 (read-string-avail! s cr)))
		(loop))))

	  (close-output-port sw)
	  (test cr object-wait-multiple #f s t l sr cr)
	  (test cr object-wait-multiple #f s t l sr cr)

	  (close-output-port cw)
	  (test sr object-wait-multiple #f s t l sr))))
    (tcp-close l)))

;; Test limited pipe output waiting:
(let-values ([(r w) (make-pipe 5000)])
  (test #f object-wait-multiple 0 r)
  (test w object-wait-multiple 0 r w)
  (display (make-string 4999 #\x) w)
  (test w object-wait-multiple 0 w)
  (display #\y w)
  (test #f object-wait-multiple 0 w)
  (test 0 write-string-avail* "hello" w)
  (test r object-wait-multiple 0 r w)
  (read-char r)
  (test w object-wait-multiple 0 w)
  (display #\z w)
  (test #f object-wait-multiple 0 w)
  (read-string 5000 r)
  (test #f object-wait-multiple 0 r)
  (test w object-wait-multiple 0 r w)
  (display (make-string 5000 #\x) w)
  (test r object-wait-multiple 0 r w)
  (test #f object-wait-multiple 0 w))

;; ----------------------------------------
;; Suspend and resume

;; Suspend main thread:
(let ([v 17]
      [s (make-semaphore)]
      [t (current-thread)])
  (let ([t2 (thread (lambda () 
		      (thread-suspend t)
		      (test #f thread-running? t)
		      (test #f thread-dead? t)
		      (semaphore-post s)
		      (sleep SLEEP-TIME)
		      (test 17 values v)
		      (thread-resume t)))])
    (semaphore-wait s)
    (set! v 99)
    (thread-wait t2)))

;; Self-suspend main thread:
(let ([v 19]
      [t (current-thread)])
  (let ([t2 (thread (lambda () 
		      (sleep SLEEP-TIME)
		      (test 19 values v)
		      (thread-resume t)))])
    (thread-suspend t)
    (set! v 99)
    (thread-wait t2)))

;; Self-suspend child thread:
(let ([v 20])
  (let ([t2 (thread (lambda () 
		      (thread-suspend (current-thread))
		      (set! v 99)))])
    (sleep SLEEP-TIME)
    (test #f thread-running? t2)
    (test #f thread-dead? t2)
    (thread-resume t2)
    (test 20 values v)
    (thread-wait t2)
    (test #f thread-running? t2)
    (test #t thread-dead? t2)
    (test 99 values v)))

;; Suspend child thread:
(let ([v 17]
      [s (make-semaphore)]
      [t (current-thread)])
  (let ([t2 (thread (lambda () 
		      (semaphore-wait s)
		      (set! v 99)))])
    (thread-suspend t2)
    (test #f thread-dead? t2)
    (test #f thread-running? t2)
    (semaphore-post s)
    (sleep SLEEP-TIME)
    (test 17 values v)
    (thread-resume t2)
    (thread-wait t2)
    (test #f thread-running? t2)
    (test #t thread-dead? t2)
    (test 99 values v)))

;; Breaking/killing:
(define /dev/null-for-err
  (make-custom-output-port #f (lambda (s start end ?) (- end start)) void void))
(for-each
 (lambda (sleep0)
   (test (list 'start-sleep0 sleep0) values (list 'start-sleep0 sleep0))
   (let ([goes
	  (lambda (sleep1 sleep2 break-thread)
	    (test 'external-suspend values 'external-suspend)
	    (let ([v 10])
	      (let ([t2 (parameterize ([current-error-port /dev/null-for-err])
			  (thread
			   (lambda () 
			     (let loop () (when (= v 10) (sleep) (loop)))
			     (sleep0)
			     (set! v 99))))])
		(sleep1)
		(thread-suspend t2)
		(set! v 20)
		(test (void) break-thread t2)
		(sleep2)
		(test (void) thread-resume t2)
		(test (void) thread-wait t2)
		(test 20 values v)))
	    (test 'self-suspend values 'self-suspend)
	    (let ([v 20])
	      (let ([t2 (parameterize ([current-error-port /dev/null-for-err])
			  (thread (lambda () 
				    (thread-suspend (current-thread))
				    (sleep0)
				    (set! v 99))))])
		(sleep1)
		(break-thread t2)
		(sleep2)
		;; keep trying to resume until the thread stops:
		(let loop ()
		  (unless (object-wait-multiple 0 t2)
		    (thread-resume t2)
		    (loop)))
		(thread-wait t2)
		(test 20 values v)))
	    (let ([w-block
		   (lambda (post wait)
		     ;; Child thread sleeps
		     (let ([v 20])
		       (let ([t2 (parameterize ([current-error-port /dev/null-for-err])
				   (thread (lambda () 
					     (wait)
					     (sleep0)
					     (set! v 99))))])
			 (sleep1)
			 (thread-suspend t2)
			 (post)
			 (sleep2)
			 (break-thread t2)
			 (sleep2)
			 (thread-resume t2)
			 (thread-wait t2)
			 (test 20 values v)))
		     (unless (eq? break-thread kill-thread)
		       (wait)
		       ;; Main thread sleeps
		       (let ([v 25]
			     [t (current-thread)]
			     [done (make-semaphore)])
			 (with-handlers ([exn:break?
					  (lambda (x) (semaphore-post done))])
			   (let ([t2 (thread (lambda () 
					       (sleep1)
					       (thread-suspend t)
					       (post)
					       (sleep2)
					       (break-thread t)
					       (sleep2)
					       (thread-resume t)
					       (semaphore-wait done)
					       (test 25 values v)))])
			     (wait)
			     (sleep0)
			     (set! v 99)
			     (fprintf (current-error-port) "Shouldn't get here!~n"))))))])
	      (test 'sema-block values 'sema-block)
	      (let ([s (make-semaphore)])
		(w-block (lambda () (semaphore-post s))
			 (lambda () (semaphore-wait s))))
	      (for-each
	       (lambda (init)
		 (test (list 'sema-block/enable-break init) values (list 'sema-block/enable-break init))
		 (let ([s (make-semaphore)])
		   (parameterize ([break-enabled init])
		     (w-block (lambda () (semaphore-post s))
			      (lambda () (semaphore-wait/enable-break s))))))
	       '(#t #f))
	      (test 'ch-block values 'ch-block)
	      (let ([ch (make-channel)])
		(w-block (lambda () (thread (lambda () (channel-put ch 10))))
			 (lambda () (object-wait-multiple #f (make-semaphore) ch))))
	      (for-each
	       (lambda (init)
		 (test (list 'ch-block/enable-break init) values (list 'ch-block/enable-break init))
		 (let ([ch (make-channel)])
		   (parameterize ([break-enabled #f])
		     (w-block (lambda () (thread (lambda () (channel-put ch 10))))
			      (lambda () (object-wait-multiple/enable-break #f (make-semaphore) ch))))))
	       '(#t #f))))])
     (define BKT-SLEEP-TIME (/ SLEEP-TIME 4))
     (goes void void break-thread)
     (goes void void kill-thread)
     (goes sleep void break-thread)
     (goes sleep void kill-thread)
     (goes void sleep break-thread)
     (goes void sleep kill-thread)
     (goes sleep sleep break-thread)
     (goes sleep sleep kill-thread)
     (goes (lambda () (sleep BKT-SLEEP-TIME)) void break-thread)
     (goes (lambda () (sleep BKT-SLEEP-TIME)) void kill-thread)
     (goes void (lambda () (sleep BKT-SLEEP-TIME)) break-thread)
     (goes void (lambda () (sleep BKT-SLEEP-TIME)) kill-thread)
     (goes (lambda () (sleep BKT-SLEEP-TIME)) (lambda () (sleep BKT-SLEEP-TIME)) break-thread)
     (goes (lambda () (sleep BKT-SLEEP-TIME)) (lambda () (sleep BKT-SLEEP-TIME)) kill-thread)))
 (list sleep void))

;; ----------------------------------------
;;  Simple multi-custodian threads

(let ([go
       (lambda (1st1st? derived?)
	 (let* ([c1 (make-custodian)]
		[c2 (make-custodian (if derived? c1 (current-custodian)))])
	   (let ([t (parameterize ([current-custodian c1])
		      (thread (lambda () (sleep 1000))))])
	     (test #t thread-running? t)
	     (thread-resume t c2)
	     (test #t thread-running? t)
	     (custodian-shutdown-all (if 1st1st? c1 c2))
	     (test (not (and derived? 1st1st?)) thread-running? t)
	     (custodian-shutdown-all (if 1st1st? c1 c2))
	     (test (not (and derived? 1st1st?)) thread-running? t)
	     (custodian-shutdown-all (if 1st1st? c2 c1))
	     (test #f thread-running? t))))])
  (go #t #f)
  (go #f #f)
  (go #t #t)
  (go #f #t))

;; Test collapsing custodians for resume
(let* ([c0 (make-custodian)]
       [c1 (make-custodian c0)]
       [c2 (make-custodian c0)]
       [c3 (make-custodian c0)])
  (let ([t (parameterize ([current-custodian c1])
	     (thread (lambda () (sleep 1000))))])
    (thread-resume t c2)
    (thread-resume t c3)
    (thread-resume t c0)
    (custodian-shutdown-all c0)
    (test #f thread-running? t)))
	     
;; ----------------------------------------
;; Kill versus Suspend

(let* ([v 0]
       [loop (lambda ()
	       (let loop ()
		 (set! v (add1 v))
		 (sleep (/ SLEEP-TIME 2))
		 (loop)))]
       [c0 (make-custodian)])
  (let ([try
	 (lambda (resumable?)
	   (let* ([c (parameterize ([current-custodian c0])
		       (make-custodian))]
		  [t (parameterize ([current-custodian c])
		       ((if resumable? thread/suspend-to-kill thread) loop))]
		  [check-inc (lambda (inc?)
			       (let ([v0 v]) 
				 (sleep SLEEP-TIME)
				 (test inc? > v v0)))])
	     (test #t thread-running? t)
	     (check-inc #t)
	     (custodian-shutdown-all c)
	     (test #f thread-running? t)
	     (test (not resumable?) thread-dead? t)
	     (test (and resumable? t) object-wait-multiple 0 (thread-suspend-waitable t))
	     (check-inc #f)
	     (let ([r (thread-resume-waitable t)])
	       (test #f object-wait-multiple 0 r)
	       (set! c (make-custodian))
	       (thread-resume t c)
	       (test (and resumable? t) object-wait-multiple 0 r))
	     (test resumable? thread-running? t)
	     (when resumable?
	       (check-inc #t)
	       (custodian-shutdown-all c)
	       (test #f thread-running? t)
	       (test #f thread-dead? t)
	       (check-inc #f)
	       (set! c (make-custodian))
	       (thread-resume t c)
	       (test #t thread-running? t)
	       (check-inc #t)
	       (kill-thread t)
	       (test #f thread-running? t)
	       (test #f thread-dead? t)
	       (check-inc #f)
	       (thread-resume t)
	       (check-inc #t)
	       (custodian-shutdown-all c)
	       (thread-wait
		(parameterize ([current-custodian c0])
		  (thread (lambda () (thread-resume t (current-thread))))))
	       (check-inc #t)
	       (custodian-shutdown-all c)
	       (test #t thread-running? t)
	       (check-inc #t)
	       (set! c (make-custodian))
	       (thread-resume t c)
	       (custodian-shutdown-all c)
	       (test #t thread-running? t)
	       (check-inc #t)
	       (custodian-shutdown-all c0)
	       (check-inc #f)
	       (thread-resume t (current-thread))
	       (check-inc #t)
	       (custodian-shutdown-all c)
	       (test #t thread-running? t)
	       (check-inc #t)
	       (kill-thread t)
	       (check-inc #f))))])
    (try #f)
    (try #t)))

;; Transitive resume:
(let ([go
       (lambda (thread c-suspend?)
	 (parameterize ([current-custodian (make-custodian)])
	   (letrec ([setup-transitive
		     (lambda (t depth)
		       (if (= depth 0)
			   null
			   (let ([t1 (thread (lambda () (sleep 1000)))]
				 [t2 (thread (lambda () (semaphore-wait (make-semaphore))))])
			     (thread-resume t1 t)
			     (thread-resume t2 t)
			     (append
			      (setup-transitive t1 (sub1 depth))
			      (setup-transitive t2 (sub1 depth))
			      (list t1 t2)))))])
	     (let ([t (thread (lambda () (sleep 10000)))])
	       (let ([threads (cons t (setup-transitive t 5))])
		 (for-each (lambda (t)
			     (test #t thread-running? t))
			   threads)
		 (if c-suspend?
		     (custodian-shutdown-all (current-custodian))
		     (for-each thread-suspend threads))
		 (for-each (lambda (t)
			     (test #f thread-running? t))
			   threads)
		 (test (void) thread-resume t)
		 (for-each (lambda (t)
			     (test (not c-suspend?) thread-running? t))
			   threads)))
	     (custodian-shutdown-all (current-custodian)))))])
  (go thread #f)
  (go thread/suspend-to-kill #t)
  (go thread/suspend-to-kill #f))

(let ([t1 (thread (lambda () (semaphore-wait (make-semaphore))))]
      [t2 (thread (lambda () (semaphore-wait (make-semaphore))))]
      [t3 (thread (lambda () (semaphore-wait (make-semaphore))))])
  (test (void) thread-resume t2 t1)
  (test (void) thread-resume t3 t2)
  (thread-suspend t1)
  (thread-suspend t3)
  (test #f thread-running? t1)
  (test #t thread-running? t2)
  (test #f thread-running? t3)
  (thread-resume t1)
  ;; Thread t3 should not have been resumed...
  (test #f thread-running? t3)
  (thread-resume t2)
  ;; Still, thread t3 should not have been resumed...
  (test #f thread-running? t3)
  (thread-suspend t2)
  (thread-resume t2)
  ;; Now it should be resumed!
  (test #t thread-running? t3)
  (kill-thread t3)
  (thread-suspend t2)
  (thread-resume t2)
  (test #f thread-running? t3))

;; Transitive custodian addition:
(let ([c1 (make-custodian)]
      [c2 (make-custodian)]
      [c3 (make-custodian)])
  (let ([t1 (parameterize ([current-custodian c1])
	      (thread/suspend-to-kill (lambda () (sleep 10000))))]
	[t2 (parameterize ([current-custodian c2])
	      (thread/suspend-to-kill (lambda () (sleep 10000))))])
    (let ([t2-2 (let loop ([n 5][t t2])
		  (if (zero? n)
		      t
		      (loop (sub1 n)
			    (parameterize ([current-custodian c2])
			      (let ([t2 (thread/suspend-to-kill (lambda () (sleep 10000)))])
				(thread-resume t2 t)
				t2)))))])
      (custodian-shutdown-all c2)
      (test #f thread-running? t2)
      (test #f thread-running? t2-2)
      (thread-resume t2)
      (test #f thread-running? t2)
      (test #f thread-running? t2-2)
      (thread-resume t2 t1)
      (test #t thread-running? t2)
      (test #t thread-running? t2-2)
      (thread-resume t1 c3)
      (custodian-shutdown-all c1)
      (test #t thread-running? t1)
      (test #t thread-running? t2)
      (test #t thread-running? t2-2)
      (custodian-shutdown-all c3)
      (test #f thread-running? t1)
      (test #f thread-running? t2)
      (test #f thread-running? t2-2))))

;; Cyclic thread yokes should be ok:
(let* ([c1 (make-custodian)]
       [c2 (make-custodian)]
       [t1 (parameterize ([current-custodian c1])
	     (thread (lambda () (sleep 10000))))]
       [t2 (parameterize ([current-custodian c2])
	     (thread (lambda () (sleep 10000))))])
  (thread-resume t1 t2)
  (thread-resume t2 t1)
  (thread-suspend t1)
  (thread-suspend t2)
  (test #f thread-running? t1)
  (test #f thread-running? t2)
  (thread-resume t1)
  (test #t thread-running? t1)
  (test #t thread-running? t2)
  (thread-suspend t1)
  (thread-suspend t2)
  (test #f thread-running? t1)
  (test #f thread-running? t2)
  (thread-resume t2)
  (test #t thread-running? t1)
  (test #t thread-running? t2)
  (custodian-shutdown-all c1)
  (test #t thread-running? t1)
  (test #t thread-running? t2)
  (custodian-shutdown-all c2)
  (test #f thread-running? t1)
  (test #f thread-running? t2))

;; ----------------------------------------

(report-errs)