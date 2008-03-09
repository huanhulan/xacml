#cs
(module Math-native-methods mzscheme
  (require (lib "math.ss"))

  (define-syntax (define/provide stx)
    (syntax-case stx ()
      [(_ id val)
       (identifier? #'id)
       #'(begin
	   (define id val)
	   (provide id))]
      [(_ (id . formals) . rest)
       #'(begin
	   (define (id . formals) . rest)
	   (provide id))]))

  (define/provide (Math-getE-native) e)
  (define/provide (Math-getPI-native) pi)

  (define/provide (Math-abs-double-native n) (abs n))
  (define/provide (Math-abs-float-native n) (abs n))
  (define/provide (Math-abs-int-native n) (abs n))
  (define/provide (Math-abs-long-native n) (abs n))
  (define/provide (Math-acos-double-native a) (acos a))
  (define/provide (Math-asin-double-native a) (asin a))
  (define/provide (Math-atan-double-native a) (atan a))
  (define/provide (Math-atan2-double-double-native y x) (atan y x))
  (define/provide (Math-ceil-double-native a) (ceiling a))
  (define/provide (Math-cos-double-native a) (cos a))
  (define/provide (Math-exp-double-native a) (exp a))
  (define/provide (Math-floor-double-native a) (floor a))
  (define/provide (Math-IEEEremainder-double-double-native f1 f2)
    (let ([q (round (/ f1 f2))])
      (- f1 (* f2 q))))
  (define/provide (Math-log-double-native a) (log a))
  (define/provide (Math-max-double-double-native a b) (max a b))
  (define/provide (Math-max-float-float-native a b) (max a b))
  (define/provide (Math-max-int-int-native a b) (max a b))
  (define/provide (Math-max-long-long-native a b) (max a b))
  (define/provide (Math-min-double-double-native a b) (min a b))
  (define/provide (Math-min-float-float-native a b) (min a b))
  (define/provide (Math-min-int-int-native a b) (min a b))
  (define/provide (Math-min-long-long-native a b) (min a b))
  (define/provide (Math-pow-double-double-native a b) (expt a b))
  (define/provide (Math-random-native) (/ (random (sub1 (expt 2 31))) 
					  (exact->inexact (sub1 (expt 2 31)))))
  (define/provide (Math-rint-double-native a) (round a))
  (define/provide (Math-round-double-native a) (inexact->exact (round a)))
  (define/provide (Math-round-float-native a) (inexact->exact (round a)))
  (define/provide (Math-sin-double-native a) (sin a))
  (define/provide (Math-sqrt-double-native a) (sqrt a))
  (define/provide (Math-tan-double-native a) (tan a))
  (define/provide (Math-toDegrees-double-native angrad)
    (* pi (/ angrad 180.0)))
  (define/provide (Math-toRadians-double-native angdeg)
    (* 180.0 (/ angdeg pi)))

  )