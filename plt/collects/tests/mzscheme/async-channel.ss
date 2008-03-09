

(load-relative "loadtest.ss")

(require (lib "async-channel.ss"))

(SECTION 'async-channel)

(arity-test make-async-channel 0 1)
(err/rt-test (make-async-channel 0) exn?)
(err/rt-test (make-async-channel 1.0) exn?)
(err/rt-test (make-async-channel -1) exn?)

(err/rt-test (async-channel-get #f) exn?)
(err/rt-test (async-channel-try-get #f) exn?)
(err/rt-test (async-channel-put #f 1) exn?)
(err/rt-test (make-async-channel-put-waitable #f 1) exn?)

(let ([ch (make-async-channel)])
  (test #t async-channel? ch)
  (test #f async-channel-try-get ch)
  (test #f object-wait-multiple 0 ch)
  (test (void) async-channel-put ch 12)
  (test 12 async-channel-get ch)
  (test #f async-channel-try-get ch)
  (test (void) async-channel-put ch 1)
  (test (void) async-channel-put ch 2)
  (test 1 async-channel-get ch)
  (test 2 async-channel-get ch)
  (test #f async-channel-try-get ch)
  (test (void) async-channel-put ch 1)
  (test (void) async-channel-put ch 2)
  (test 1 async-channel-try-get ch)
  (test 2 async-channel-try-get ch)
  (test #f async-channel-try-get ch)
  (let ([p (make-async-channel-put-waitable ch 10)])
    (test p object-wait-multiple #f p)
    (test 10 async-channel-get ch)
    (test p object-wait-multiple 0 p)
    (test p object-wait-multiple #f p p)
    (test 10 async-channel-get ch)
    (test 10 async-channel-get ch)
    (test #f async-channel-try-get ch)))

;; Make sure a channel isn't managed by a
;; custodian:
(for-each
 (lambda (try-after-shutdown)
   (let ([c (make-custodian)]
	 [ch2 #f])
     (parameterize ([current-custodian c])
       (thread-wait
	(thread (lambda ()
		  (set! ch2 (make-async-channel))
		  (async-channel-put ch2 42)))))
     (custodian-shutdown-all c)
     (try-after-shutdown ch2)))
 (list
  (lambda (ch2)
    (test 42 async-channel-get ch2))
  (lambda (ch2)
    (test 42 async-channel-try-get ch2))
  (lambda (ch2)
    (test (void) async-channel-put ch2 10))
  (lambda (ch2)
    (let ([p (make-async-channel-put-waitable ch2 10)])
      (test p object-wait-multiple 0 p)))))

;; Limitted channel:
(let ([ch (make-async-channel 1)])
  (async-channel-put ch 42)
  (test 42 async-channel-get ch)
  (let ([p (make-async-channel-put-waitable ch 10)])
    (test p object-wait-multiple #f p)
    (test #f object-wait-multiple 0.01 p)
    (test #f object-wait-multiple 0 p)
    (test 10 async-channel-get ch)
    (test p object-wait-multiple #f p)))


(report-errs)
