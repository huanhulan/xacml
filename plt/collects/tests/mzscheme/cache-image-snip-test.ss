(load-relative "loadtest.ss")

(require (lib "cache-image-snip.ss" "mrlib")
         (lib "unit.ss"))

(invoke-unit
 (unit 
   (import)
   (export)
   
   (define (overlay-bitmap/ret argb-str dx dy b1 b2)
     (overlay-bitmap argb-str dx dy b1 b2)
     argb-str)

   (let ([argb-str (vector 100 10 20 30)]
         [bm (build-bitmap void 1 1)])
     (test #(100 10 20 30) overlay-bitmap/ret argb-str 0 0 bm bm))

   (let ([argb-str (make-vector 4 0)]
         [bm (build-bitmap 
              (lambda (dc)
                (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                (send dc draw-line 0 0 0 0))
              1 1)])
     (test #4(0) overlay-bitmap/ret argb-str 0 0 bm bm))
   
   (let ([argb-str (make-vector 4 100)]
         [bm (build-bitmap 
              (lambda (dc)
                (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                (send dc draw-line 0 0 0 0))
              1 1)])
     (test #4(0) overlay-bitmap/ret argb-str 0 0 bm bm))
   
   (let ([argb-str (make-vector 8 254)]
         [bm (build-bitmap void 1 2)])
     (test #8(254) overlay-bitmap/ret argb-str 0 0 bm bm))
   
   (let ([argb-str (make-vector 8 0)]
         [bm (build-bitmap 
              (lambda (dc)
                (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                (send dc draw-line 0 0 0 1))
              1 2)])
     (test #8(0) overlay-bitmap/ret argb-str 0 0 bm bm))
      
   (let ([argb-str (make-vector 16 100)]
         [bm (build-bitmap 
              (lambda (dc)
                (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                (send dc draw-line 0 0 0 0))
              2 2)])
     (test #16(0 0 0 0
               100 100 100 100
               100 100 100 100
               100 100 100 100)
           overlay-bitmap/ret argb-str 0 0 bm bm))
   
   (let ([argb-str (make-vector 16 100)]
         [bm (build-bitmap 
              (lambda (dc)
                (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                (send dc draw-line 1 0 1 0))
              2 2)])
     (test #16(100 100 100 100
               0 0 0 0
               100 100 100 100
               100 100 100 100)
           overlay-bitmap/ret argb-str 0 0 bm bm))
   
   (let ([argb-str (make-vector 16 100)]
         [bm (build-bitmap 
              (lambda (dc)
                (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                (send dc draw-line 0 1 0 1))
              2 2)])
     (test #16(100 100 100 100
               100 100 100 100
               0 0 0 0
               100 100 100 100)
           overlay-bitmap/ret argb-str 0 0 bm bm))
   
   (let ([argb-str (make-vector 16 100)]
         [bm (build-bitmap 
              (lambda (dc)
                (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                (send dc draw-line 1 1 1 1))
              2 2)])
     (test #16(100 100 100 100
               100 100 100 100
               100 100 100 100
               0 0 0 0)
           overlay-bitmap/ret argb-str 0 0 bm bm))
   
   (let ([argb-str (make-vector 4 200)]
         [c (build-bitmap 
             (lambda (dc)
               (send dc set-pen 
                     (send the-pen-list find-or-create-pen (make-object color% 0 0 100) 1 'solid))
               (send dc draw-line 0 0 0 0))
             1 1)]
         [m (build-bitmap 
             (lambda (dc)
               (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
               (send dc draw-line 0 0 0 0))
             1 1)])
     (test #4(0 0 0 100) overlay-bitmap/ret argb-str 0 0 c m))
   
   (let ([argb-str (make-vector 4 200)]
         [c (build-bitmap 
             (lambda (dc)
               (send dc set-pen 
                     (send the-pen-list find-or-create-pen (make-object color% 0 100 0) 1 'solid))
               (send dc draw-line 0 0 0 0))
             1 1)]
         [m (build-bitmap 
             (lambda (dc)
               (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
               (send dc draw-line 0 0 0 0))
             1 1)])
     (test #4(0 0 100 0) overlay-bitmap/ret argb-str 0 0 c m))
   
   (let ([argb-str (make-vector 4 200)]
         [c (build-bitmap 
             (lambda (dc)
               (send dc set-pen 
                     (send the-pen-list find-or-create-pen (make-object color% 100 0 0) 1 'solid))
               (send dc draw-line 0 0 0 0))
             1 1)]
         [m (build-bitmap 
             (lambda (dc)
               (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
               (send dc draw-line 0 0 0 0))
             1 1)])
     (test #4(0 100 0 0) overlay-bitmap/ret argb-str 0 0 c m))
   
   ;; used to test argb-vector->bitmap
   (define (argb-vector->bitmap->string argb-vector w h)
     (bitmap->string (argb-vector->bitmap argb-vector w h)))
   
   ;; extracts the argb strings from the bitmap and its mask for comparison
   (define (bitmap->string main-bm)
     (let* ([w (send main-bm get-width)]
            [h (send main-bm get-height)]
            [get-one
             (lambda (bm)
               (let ([dc (make-object bitmap-dc% bm)]
                     [str (make-string (* 4 w h) #\000)])
                 (send dc get-argb-pixels 0 0 w h str)
                 (send dc set-bitmap #f)
                 str))])
       (list (and (send main-bm get-loaded-mask)
                  (get-one (send main-bm get-loaded-mask)))
             (get-one main-bm))))
   
   ;; takes a bitmap with a mask and flattens the colors and the mask
   ;; drawing them as they would appear on the screen.
   (define (flatten-bitmap bm)
     (let* ([w (send bm get-width)]
            [h (send bm get-height)]
            [new-bm (make-object bitmap% w h)]
            [bdc (make-object bitmap-dc% new-bm)])
       (send bdc draw-bitmap bm 0 0 'solid 
             (send the-color-database find-color "black")
             (send bm get-loaded-mask))
       (send bdc set-bitmap #f)
       new-bm))
   
   (test '("\377\377\377\377" "\377\377\377\377") argb-vector->bitmap->string #(255 255 255 255) 1 1)
   (test '("\377\377\377\377" "\377\0\0\0") argb-vector->bitmap->string #(255 0 0 0) 1 1)
   (test '("\377\1\1\1" "\377\100\100\100") argb-vector->bitmap->string #(1 64 64 64) 1 1)
   (test '("\377\001\001\001\377\010\010\010\377\377\377\377\377\000\000\000"
           "\377\100\100\100\377\001\010\100\377\377\377\377\377\000\000\000") 
         argb-vector->bitmap->string
         #(1 64 64 64 
           8 1 8 64
           255 255 255 255
           0 0 0 0)
         2 2)
   
   (define (show-bitmap bm mask title)
     (define f (new frame% (label title) (width 200) (height 200)))
     (define c (new canvas%
                    (parent f)
                    (paint-callback
                     (lambda (c dc)
                       (send dc draw-bitmap bm 0 0 'solid 
                             (send the-color-database find-color "black")
                             mask)))))
     (send f show #t))
   
   (let* ([font (send the-font-list find-or-create-font 12 'default 'normal 'normal #f 'partly-smoothed)]
          [black (send the-color-database find-color "black")]
          [bkg-color "plum"]
          [font-color (send the-color-database find-color "forestgreen")]
          [str "xXxXx"]
          [w 100]
          [h 30]
          [argb-str (make-vector (* w h 4) 0)]
          [c1 (build-bitmap 
               (lambda (dc)
                 (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                 (send dc set-brush (send the-brush-list find-or-create-brush bkg-color 'solid))
                 (send dc draw-rectangle 0 0 w h))
               w h)]
          [m1 (build-bitmap 
               (lambda (dc)
                 (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
                 (send dc set-brush (send the-brush-list find-or-create-brush "black" 'solid))
                 (send dc draw-rectangle 0 0 w h))
               w h)]
          [c2 (build-bitmap 
               (lambda (dc)
                 (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'transparent))
                 (send dc set-brush (send the-brush-list find-or-create-brush font-color 'solid))
                 (send dc draw-rectangle 0 0 w h))
               w h)]
          [m2 (build-bitmap
               (lambda (dc)
                 (send dc set-font font)
                 (send dc set-text-mode 'solid)
                 (send dc set-text-foreground black)
                 (send dc draw-text str 2 2))
               w h)]
          [final
           (build-bitmap
            (lambda (dc)
              (send dc set-pen (send the-pen-list find-or-create-pen "black" 1 'solid))
              (send dc set-brush (send the-brush-list find-or-create-brush bkg-color 'solid))
              (send dc draw-rectangle 0 0 w h)
              (send dc set-font font)
              (send dc set-text-mode 'transparent)
              (send dc set-text-foreground font-color)
              (send dc draw-text str 2 2))
            w h)])
     
     (overlay-bitmap argb-str 0 0 c1 m1)
     (overlay-bitmap argb-str 0 0 c2 m2)

     ;; at this point, the `final' bitmap should be the same as argb-str,
     ;; but it isn't, due to rounding error (final is actually wrong!)
     ;; the stuff below just makes sure that each entry is within 3
     
     (let* ([argb-bitmap (flatten-bitmap (argb-vector->bitmap argb-str w h))]
            [argb-ents (map char->integer (string->list (cadr (bitmap->string argb-bitmap))))]
            [bitmap-ents (map char->integer (string->list (cadr (bitmap->string final))))])
       (test #t (lambda (x) x) (andmap (lambda (x y) (<= (abs (- x y)) 3))
                                       argb-ents
                                       bitmap-ents))))
  
   (report-errs)
   
))