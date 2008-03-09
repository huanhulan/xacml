(module balloon mzscheme
  (require "mrpict.ss"
	   "utils.ss"
	   (lib "mred.ss" "mred")
           (lib "class.ss")
           (lib "etc.ss")
           (lib "math.ss"))
  
  (provide wrap-balloon
	   place-balloon
	   (rename mk-balloon balloon)
           make-balloon
	   balloon?
           balloon-pict
           balloon-point-x
           balloon-point-y
	   balloon-color)
  
  (define-struct balloon (pict point-x point-y))
    
  (define no-pen (find-pen "white" 1 'transparent))
  (define no-brush (find-brush "white" 'transparent))
  (define black-pen (find-pen "black"))

  (define (series dc steps start-c end-c f pen? brush?)
    (color-series dc steps #e0.5 start-c end-c f pen? brush?))
    
  (define (mk-balloon w h corner-radius spike-pos dx dy color)
    (let ([dw (if (< corner-radius 1)
                  (* corner-radius w)
                  corner-radius)]
          [dh (if (< corner-radius 1)
                  (* corner-radius h)
                  corner-radius)]
          [dxbig (lambda (v) (if (> (abs dx) (abs dy))
                                 v
                                 0))]
          [dybig (lambda (v) (if (<= (abs dx) (abs dy))
                                 v
                                 0))])
      (let-values ([(x0 y0 x1 y1 xc yc mx0 mx1 my0 my1 mfx mfy)
                    (case spike-pos
                      [(w) (values 1 (/ (- h dh) 2)
                                   1 (/ (+ h dh) 2)
                                   1 (/ h 2)
                                   0.5 1 0.5 -1
                                   1 0)]
                      [(nw) (values 0 dh
                                    dw 0
                                    0 0
                                    1 -0.5 -1 0.5
                                    (dxbig 1) (dybig 1))]
                      [(e) (values (sub1 w) (/ (- h dh) 2)
                                   (sub1 w) (/ (+ h dh) 2)
                                   (sub1 w) (/ h 2)
                                   -1 -1 1 -1
                                   -1 0)]
                      [(ne) (values (- w dw) 0
                                    w dh
                                    w 0
                                    0.5 -1 0.5 -1
                                    (dxbig -1) (dybig 1))]
                      [(s) (values (/ (- w dw) 2) (sub1 h)
                                   (/ (+ w dw) 2) (sub1 h)
                                   (/ w 2) (sub1 h)
                                   1 -1 -1 -1
                                   0 -1)]
                      [(n) (values (/ (- w dw) 2) 1
                                   (/ (+ w dw) 2) 1
                                   (/ w 2) 1
                                   1 -1 1 1
                                   0 1)]
                      [(sw) (values 0 (- h dh)
                                    dw (sub1 h)
                                    0 (sub1 h)
                                    0.5 -1 0.5 -1
                                    (dxbig 1) (dybig -1))]
                      [(se) (values (- w dw) h
                                    w (- h dh)
                                    w h
                                    1 -1 1 -1
                                    (dxbig -1) (dybig -1))])])
        (let ([xf (+ xc dx)]
              [yf (+ yc dy)]
              [dark-color (scale-color #e0.6 color)])
          (make-balloon
           (dc (lambda (dc x y)
                 (let ([b (send dc get-brush)]
                       [p (send dc get-pen)]
                       [draw-once
                        (lambda (i rr?)
                          (when rr?
			    (send dc draw-rounded-rectangle 
                                  (+ x (/ i 2)) (+ y (/ i 2))
                                  (- w i) (- h i)
                                  (if (and (< (* 2 corner-radius) (- w i))
					   (< (* 2 corner-radius) (- h i)))
				      corner-radius
				      (/ (min (- w i) (- h i)) 2)))
                            (let ([p (send dc get-pen)])
                              (send dc set-pen no-pen)
                              (send dc draw-polygon (list (make-object point% (+ x0 (* i mx0)) (+ y0 (* i my0)))
                                                          (make-object point% (+ xf (* i mfx)) (+ yf (* i mfy)))
                                                          (make-object point% (+ x1 (* i mx1)) (+ y1 (* i my1))))
                                    x y)
                              (send dc set-pen p)))
                          (send dc draw-line (+ x x0 (* i mx0)) (+ y y0 (* i my0)) 
                                (+ x xf (* i mfx)) (+ y yf (* i mfy)))
                          (send dc draw-line (+ x x1 (* i mx1)) (+ y y1 (* i my1))
                                (+ x xf (* i mfx)) (+ y yf (* i mfy))))])
                   (series dc 5
                           dark-color
                           (if (string? color) (make-object color% color) color)
                           (lambda (i) (draw-once i #t))
                           #t #t)
                   (send dc set-brush no-brush)
                   (send dc set-pen (find-pen dark-color))
                   (draw-once 0 #f)
                   
                   (send dc set-pen p)
                   (send dc set-brush b)))
               w h 0 0)
           xf yf)))))

  (define balloon-color (make-object color% 255 255 170))
  
  (define corner-size 32)

  (define wrap-balloon
    (opt-lambda (p corner dx dy [color balloon-color])
      (let ([b (mk-balloon (+ (pict-width p) (* 2 corner-size))
			   (+ (pict-height p) corner-size)
			   corner-size
			   corner dx dy
			   color)])
	(make-balloon
	 (cc-superimpose
	  (balloon-pict b)
	  p)
	 (balloon-point-x b)
	 (balloon-point-y b)))))
  
  (define (place-balloon balloon p to find-to)
    (let-values ([(x y) (if (and (number? to) 
				 (number? find-to)) 
			    (values to (- (pict-height p)
					  find-to))
			    (find-to p to))])
      (cons-picture
       p
       `((place ,(- x (balloon-point-x balloon))
                ,(- y  ; up-side down!
                    (- (pict-height (balloon-pict balloon))
                       (balloon-point-y balloon)))
                ,(balloon-pict balloon)))))))