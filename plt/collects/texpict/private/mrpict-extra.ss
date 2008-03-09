
(module mrpict-extra mzscheme
  (require (lib "unitsig.ss")
	   (lib "class.ss")
           (lib "etc.ss"))

  (require (lib "mred-sig.ss" "mred"))

  (require "mrpict-sig.ss"
	   "common-sig.ss")

  (provide mrpict-extra@)
  (define mrpict-extra@
    (unit/sig ((open mrpict-extra^)
	       (open texpict-common-setup^))
      (import mred^
	      ((open texpict-common^)
	       (open texpict-internal^)))

      (define show-pict
        (opt-lambda (p [w #f] [h #f])
          (define the-pict p)
          (define no-redraw? #f)
          (define pict-frame%
            (class frame%
              (define/public (set-pict p)
                (set! the-pict p)
                (set! no-redraw? #t)
                (let ([pw (inexact->exact (floor (pict-width the-pict)))]
                      [ph (inexact->exact (floor (pict-height the-pict)))])
                  (send c min-width (if w (max w pw) pw))
                  (send c min-height (if h (max h ph) ph)))
                (set! no-redraw? #f)
                (send c on-paint))
              (super-instantiate ())))
          (define pict-canvas%
            (class canvas%
              (inherit get-dc)
              (define/override (on-paint)
                (unless no-redraw?
                  (let ([dc (get-dc)])
                    (send dc clear)
                    (let* ([pw (pict-width the-pict)]
                           [ph (pict-height the-pict)]
                           [xo (if (and w
                                        (pw . < . w))
                                   (- (/ w 2) (/ pw 2))
                                   0)]
                           [yo (if (and h
                                        (ph . < . h))
                                   (- (/ h 2) (/ ph 2))
                                   0)])
                    (draw-pict the-pict dc xo yo)))))
              (super-instantiate ())))
          (define f (make-object pict-frame% "MrPict"))
          (define c (make-object pict-canvas% f))
          (send f set-pict p)
          (send f show #t)))
      
      (define dc-for-text-size (make-parameter 
				#f
				(lambda (x)
				  (unless (or (not x)
					      (is-a? x dc<%>))
				    (raise-type-error 'dc-for-parameter "dc<%> object or #f" x))
				  x)))

      (define (dc f w h a d)
	(make-pict `(prog ,f ,h) w h a d null))
      (define prog-picture dc)

      (define current-expected-text-scale (make-parameter (list 1 1)))
      (define (with-text-scale dc thunk)
	(let ([x (current-expected-text-scale)])
	  (if (equal? x '(1 1))
	      (thunk)
	      (begin
		(send dc set-scale (car x) (cadr x))
		(let-values ([(w h d s) (thunk)])
		  (send dc set-scale 1 1)
	          (values w h d s))))))

      (define (memq* a l)
	(if (pair? l)
	    (or (eq? (car l) a)
		(memq* a (cdr l)))
	    #f))

      (define (extend-font font size style weight)
	(if (send font get-face)
	    (send the-font-list find-or-create-font
		  size 
		  (send font get-face)
		  (send font get-family)
		  style
		  weight
		  #f
		  'default
		  #t)
	    (send the-font-list find-or-create-font
		  size 
		  (send font get-family)
		  style
		  weight
		  #f
		  'default
		  #t)))

      (define text
	(case-lambda
	 [(string) (text string '() 12)]
	 [(string style) (text string style 12)]
	 [(string style size) (text string style size 0)]
	 [(string orig-style size angle)
	  (let ([font
		 (let loop ([style orig-style])
		   (cond
		    [(null? style) 
		     (send the-font-list find-or-create-font
			   size 'default 'normal 'normal #f 'default #t)]
		    [(is-a? style font%)
		     style]
		    [(memq style '(default decorative roman script swiss modern symbol system))
		     (send the-font-list find-or-create-font
			   size style 'normal 'normal #f 'default #t)]
		    [(string? style)
		     (send the-font-list find-or-create-font
			   size style 'default 'normal 'normal #f 'default #t)]
		    [(string? style)
		     (send the-font-list find-or-create-font
			   size style 'default 'normal 'normal #f 'default #t)]
		    [(and (pair? style)
			  (memq (car style)
				'(superscript 
				  subscript
				  bold italic)))
		     (let ([font (loop (cdr style))]
			   [style (car style)])
		       (cond
			[(eq? style 'bold)
			 (extend-font font
				      (send font get-point-size)
				      (send font get-style)
				      'bold)]
			[(eq? style 'italic)
			 (extend-font font
				      (send font get-point-size)
				      'italic
				      (send font get-weight))]
			[else font]))]
		    [else (raise-type-error 'text
					    "style"
					    orig-style)]))]
		[sub? (memq* 'subscript orig-style)]
		[sup? (memq* 'superscript orig-style)])
	    (let ([s-font (if (or sub? sup?)
			      (extend-font font
					   (floor (* 1/2 (send font get-point-size)))
					   (send font get-style)
					   (send font get-weight))
			      font)]
		  [dc (dc-for-text-size)])
	      (unless dc
		(error 'text "no dc<%> object installed for sizing"))
	      (let-values ([(w h d s) (with-text-scale
				       dc
				       (lambda ()
					 (send dc get-text-extent string s-font)))])
		(if (or sub? sup?)
		    (let-values ([(ww wh wd ws) (with-text-scale
						 dc
						 (lambda ()
						   (send dc get-text-extent "Wy" font)))])
		      (prog-picture (lambda (dc x y)
				      (let ([f (send dc get-font)])
					(send dc set-font s-font)
					(send dc draw-text string
					      x (if sub?
						    (+ y (- wh h))
						    y))
					(send dc set-font f)))
				    w wh (- wh wd) wd))
		    (if (zero? angle)
			;; Normal case: no rotation
			(prog-picture (lambda (dc x y)
					(let ([f (send dc get-font)])
					  (send dc set-font font)
					  (send dc draw-text string x y)
					  (send dc set-font f)))
				      w h (- h d) d)
			;; Rotation case. Need to find the bounding box.
			;; Calculate the four corners, relative to top left as origin:
			(let* ([tlx 0]
			       [tly 0]
			       [ca (cos angle)]
			       [sa (sin angle)]
			       [trx (* w ca)]
			       [try (- (* w sa))]
			       [brx (+ trx (* h sa))]
			       [bry (- try (* h ca))]
			       [blx (* h sa)]
			       [bly (- (* h ca))]
			       ;;min-x and min-y must be non-positive,
			       ;; since tlx and tly are always 0
			       [min-x (min tlx trx blx brx)]
			       [min-y (min tly try bly bry)])
			  (let ([pw (- (max tlx trx blx brx) min-x)]
				[ph (- (max tly try bly bry) min-y)]
				[dx (cond
				     [(and (positive? ca) (positive? sa)) 0]
				     [(positive? ca) (- (* h sa))]
				     [(positive? sa) (- (* w ca))]
				     [else (+ (- (* w ca)) (- (* h sa)))])]
				[dy (cond
				     [(and (positive? ca) (negative? sa)) 0]
				     [(positive? ca) (* w sa)]
				     [(negative? sa) (- (* h ca))]
				     [else (+ (- (* h ca)) (* w sa))])])
			    (prog-picture (lambda (dc x y)
					    (let ([f (send dc get-font)])
					      (send dc set-font font)
					      (send dc draw-text string (+ x dx) (+ y dy)
						    #f 0 angle)
					      (send dc set-font f)))
					  pw ph 0 0))))))))]))

      (define caps-text
	(case-lambda
	 [(string) (caps-text string '() 12)]
	 [(string style) (caps-text string style 12)]
	 [(string style size)
	  (let ([strings
		 (let loop ([l (string->list string)][this null][results null][up? #f])
		   (if (null? l)
		       (reverse! (cons (reverse! this) results))
		       (if (eq? up? (char-upper-case? (car l)))
			   (loop (cdr l) (cons (car l) this) results up?)
			   (loop (cdr l) (list (car l)) (cons (reverse! this) results) (not up?)))))]
		[cap-style
		 (let loop ([s style])
		   (cond
		    [(pair? s) (cons (car s) (loop (cdr s)))]
		    [(is-a? s font%) (send the-font-list find-or-create-font
					   (floor (* 8/10 (send s get-point-size)))
					   (send s get-family)
					   (send s get-style)
					   (send s get-weight)
					   (send s get-underlined?)
					   (send s get-smoothing)
					   (send s get-size-in-pixels?))]
		    [else s]))]
		[cap-size (floor (* 8/10 size))])
	    (let ([picts
		   (let loop ([l strings][up? #f])
		     (if (null? l)
			 null
			 (cons (text (list->string (map char-upcase (car l)))
				     (if up? style cap-style)
				     (if up? size cap-size))
			       (loop (cdr l) (not up?)))))])
	      (apply hbl-append 0 picts)))]))

      (define (linewidth n p) (line-thickness n p))

      (define connect
	(case-lambda
	 [(x1 y1 x2 y2) (connect x1 y1 x2 y2 #f)]
	 [(x1 y1 x2 y2 arrow?) (~connect 'r +inf.0 x1 y1 x2 y2 arrow?)]))

      (define ~connect 
	(case-lambda
	 [(exact close-enough x1 y1 x2 y2) (~connect exact close-enough x1 y1 x2 y2 #f)]
	 [(exact close-enough x1 y1 x2 y2 arrow?)
	  `((put ,x1 ,y1 (,(if arrow? 'vector 'line) ,(- x2 x1) ,(- y2 y1) #f)))]))

      (define (render dc h+top l dx dy)
	(define b&w? #f)
	
	(with-method ([draw-line (dc draw-line)]
		      [draw-spline (dc draw-spline)]
		      [draw-ellipse (dc draw-ellipse)]
		      [get-pen (dc get-pen)]
		      [get-brush (dc get-brush)]
		      [get-text-foreground (dc get-text-foreground)]
		      [set-pen (dc set-pen)]
		      [set-brush (dc set-brush)]
		      [set-text-foreground (dc set-text-foreground)]
		      [find-or-create-pen (the-pen-list find-or-create-pen)]
		      [find-or-create-brush (the-brush-list find-or-create-brush)])

	  (set-brush (find-or-create-brush "black" 'solid))
	  
	  (let loop ([dx dx][dy dy][l l])
	    (unless (null? l)
	      (let ([x (car l)])
		(if (string? x)
		    (error 'draw-pict "how did a string get here?: ~s" x)
		    (case (car x)
		      [(offset) (loop (+ dx (cadr x))
				      (+ dy (caddr x))
				      (cadddr x))]
		      [(line vector)
		       (let ([xs (cadr x)]
			     [ys (caddr x)]
			     [len (cadddr x)])
			 (let ([mx (if len (abs (if (zero? xs) ys xs)) 1)]
			       [len (or len 1)])
			   (draw-line dx (- h+top dy)
				      (+ dx (* (/ xs mx) len)) (- h+top (+ dy (* (/ ys mx) len))))))]
		      [(circle circle*)
		       (let ([size (cadr x)])
			 (draw-ellipse (- dx (/ size 2)) (- h+top dy (/ size 2))
				       size size))]
		      [(oval)
		       (let ([b (get-brush)]
			     [rx (- dx (/ (cadr x) 2))]
			     [ry (- h+top dy (/ (caddr x) 2))])
			 (set-brush (find-or-create-brush "BLACK" 'transparent))
			 (let ([part (cadddr x)]
			       [cr (send dc get-clipping-region)]
			       [set-rect (lambda (l t r b)
					   (let ([cr (make-object region% dc)])
					     (send cr set-rectangle
						   (+ rx (* l (cadr x)))
						   (+ ry (* t (caddr x)))
						   (* (- r l) (cadr x))
						   (* (- b t) (caddr x)))
					     cr))])
			   (send dc set-clipping-region
				 (cond
				  [(string=? part "[l]")
				   (set-rect 0 0 0.5 1.0)]
				  [(string=? part "[tl]")
				   (set-rect 0 0 0.5 0.5)]
				  [(string=? part "[tr]")
				   (set-rect 0.5 0 1.0 0.5)]
				  [(string=? part "[r]")
				   (set-rect 0.5 0 1.0 1.0)]
				  [(string=? part "[bl]")
				   (set-rect 0 0.5 0.5 1.0)]
				  [(string=? part "[br]")
				   (set-rect 0.5 0.5 1.0 1.0)]
				  [else cr]))
			   (send dc draw-rounded-rectangle
				 rx ry
				 (cadr x) (caddr x)
				 (if (string=? part "") -0.2 -0.5))
			   (send dc set-clipping-region cr)
			   (set-brush b)))]
		      [(bezier)
		       (draw-spline (+ dx (list-ref x 1))
				    (- h+top (+ dy (list-ref x 2)))
				    (+ dx (list-ref x 3))
				    (- h+top (+ dy (list-ref x 4)))
				    (+ dx (list-ref x 5))
				    (- h+top (+ dy (list-ref x 6))))]
		      [(with-color)
		       (if b&w?
			   (loop dx dy (caddr x))
			   (let ([p (get-pen)]
				 [b (get-brush)]
				 [fg (get-text-foreground)])
			     (let* ([requested-color (if (is-a? (cadr x) color%)
							 (cadr x)
							 (send the-color-database find-color (cadr x)))]
				    [color (or requested-color 
					       (send the-color-database find-color "BLACK"))])
			       (unless requested-color
				 (fprintf (current-error-port)
					  "WARNING: couldn't find color: ~s~n" (cadr x)))
			       (set-pen (find-or-create-pen color (send p get-width) 'solid))
			       (set-brush (find-or-create-brush color 'solid))
			       (set-text-foreground color))
			     (loop dx dy (caddr x))
			     (set-pen p)
			     (set-brush b)
			     (set-text-foreground fg)))]
		      [(with-thickness)
		       (let ([p (get-pen)])
			 (set-pen (find-or-create-pen (send p get-color) 
						      (if (number? (cadr x))
							  (cadr x)
							  (if (eq? (cadr x) 'thicklines)
							      1
							      0))
						      'solid))
			 (loop dx dy (caddr x))
			 (set-pen p))]
		      [(prog)
		       ((cadr x) dc dx (- h+top dy (caddr x)))]
		      [else (error 'render "unknown command: ~a~n" x)])))
	      (loop dx dy (cdr l))))))

      (define (make-pict-drawer p)
	(let ([cmds (pict->command-list p)])
	  (lambda (dc dx dy)
	    (render dc (+ (pict-height p) dy)
		    cmds
		    dx 0))))

      (define (draw-pict p dc dx dy)
	((make-pict-drawer p) dc dx dy)))))