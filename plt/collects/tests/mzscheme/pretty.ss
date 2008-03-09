
; Test pretty-print. Some of it relies on manual inspection of the results

(load-relative "loadtest.ss")

(require (lib "pretty.ss"))

(define (pp-string v)
  (let ([p (open-output-string)])
    (pretty-print v p)
    (let ([s (get-output-string p)])
      (substring s 0 (sub1 (string-length s))))))


(test "10" pp-string 10)
(test "1/2" pp-string 1/2)
(test "-1/2" pp-string -1/2)
(test "1/2+3/4i" pp-string 1/2+3/4i)
(test "0.333" pp-string #i0.333)
(test "2.0+1.0i" pp-string #i2+1i)
(test "'a" pp-string ''a)
(test "`a" pp-string '`a)
(test ",a" pp-string ',a)
(test ",@a" pp-string ',@a)
(test "#'a" pp-string '#'a)

(test #t pretty-print-style-table? (pretty-print-current-style-table))
(test #t pretty-print-style-table? (pretty-print-extend-style-table #f null null))
(test #t pretty-print-style-table? (pretty-print-extend-style-table (pretty-print-current-style-table) null null))

(parameterize ([pretty-print-columns 20])
  (test "(1234567890 1 2 3 4)" pp-string '(1234567890 1 2 3 4))
  (test "(1234567890xx\n  1\n  2\n  3\n  4)" pp-string '(1234567890xx 1 2 3 4))
  (test "(lambda 1234567890\n  1\n  2\n  3\n  4)" pp-string '(lambda 1234567890 1 2 3 4))
  (let ([table (pretty-print-extend-style-table #f null null)])
    (parameterize ([pretty-print-current-style-table 
                    (pretty-print-extend-style-table table '(lambda) '(list))])
      (test "(lambda\n  1234567890\n  1\n  2\n  3\n  4)" pp-string '(lambda 1234567890 1 2 3 4)))
    (test "(lambda 1234567890\n  1\n  2\n  3\n  4)" pp-string '(lambda 1234567890 1 2 3 4))
    (parameterize ([pretty-print-current-style-table table])
      (test "(lambda 1234567890\n  1\n  2\n  3\n  4)" pp-string '(lambda 1234567890 1 2 3 4)))))

(parameterize ([pretty-print-exact-as-decimal #t])
  (test "10" pp-string 10)
  (test "0.5" pp-string 1/2)
  (test "-0.5" pp-string -1/2)
  (test "3500.5" pp-string 7001/2)
  (test "0.0001220703125" pp-string 1/8192)
  (test "0.0000000000000006869768746897623487"
	pp-string 6869768746897623487/10000000000000000000000000000000000)
  (test "0.00000000000001048576" pp-string (/ (expt 5 20)))
  
  (test "1/3" pp-string 1/3)
  (test "1/300000000000000000000000" pp-string 1/300000000000000000000000)
  
  (test "0.5+0.75i" pp-string 1/2+3/4i)
  (test "0.5-0.75i" pp-string 1/2-3/4i)
  (test "1/9+3/17i" pp-string 1/9+3/17i)
  (test "0.333" pp-string #i0.333)
  (test "2.0+1.0i" pp-string #i2+1i))

(err/rt-test (pretty-print-extend-style-table 'ack '(a) '(b)))
(err/rt-test (pretty-print-extend-style-table (pretty-print-current-style-table) 'a '(b)))
(err/rt-test (pretty-print-extend-style-table (pretty-print-current-style-table) '(1) '(b)))
(err/rt-test (pretty-print-extend-style-table (pretty-print-current-style-table) '(a) 'b))
(err/rt-test (pretty-print-extend-style-table (pretty-print-current-style-table) '(a) '(1)))
(err/rt-test (pretty-print-extend-style-table (pretty-print-current-style-table) '(a) '(b c)) exn:application:mismatch?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Manual part
;;   (Why is this manual? Probably I was too lazy to make
;;   a proper test suite.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct s (a b c))

(define (make k?)
  (let ([make (if k? make (lambda (x) '(end)))])
    (list
     1
     'a
     "a"
     (list 'long-name-numero-uno-one-the-first-supreme-item
	   'long-name-number-two-di-ar-ge-second-line)
     (map (lambda (v v2)
	    (make-s v 2 v2))
	  (make #f)
	  (reverse (make #f)))
     '(1)
     '(1 2 3)
     '(1 . 2)
     #(1 2 3 4 5)
     (read (open-input-string "(#0=() . #0#)"))
     (read (open-input-string "#1=(1 . #1#)"))
     (map box (make #f))
     (make #f))))

(define vs (make #t))

(define print-line-no
  (lambda (line port offset width) 
    (if line         
	(begin
	  (when (positive? line) (write-char #\newline port))
	  (fprintf port "~s~a~a~a " line
		   (if (< line 10) " " "")
		   (if (< line 100) " " "")
		   (if (< line 1000) " " ""))
	  5)
	(fprintf port "!~n"))))

(define modes
  (list
   (list "DEPTH=2" pretty-print-depth 2)
   (list "GRAPH-ON" print-graph #t)
   (list "STRUCT-ON" print-struct #t)
   (list "LINE-NO-ON" pretty-print-print-line print-line-no)))

(define num-combinations (arithmetic-shift 1 (length modes)))

(let loop ([n 0])
  (when (< n num-combinations)
     (let loop ([modes modes][n n])
       (cond
	[(null? modes) (printf ":~n") (map pretty-print vs)]
	[(positive? (bitwise-and n 1))
	 (let ([mode (car modes)])
	   (printf "~s " (car mode))
	   (parameterize ([(cadr mode) (caddr mode)])
	      (loop (cdr modes) (arithmetic-shift n -1))))]
	[else
	 (loop (cdr modes) (arithmetic-shift n -1))]))
     (loop (add1 n))))



(report-errs)