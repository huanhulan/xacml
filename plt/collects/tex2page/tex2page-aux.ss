;tex2page
;(c) Dorai Sitaram, 1997-2002

(module tex2page-aux mzscheme
  (require (lib "process.ss"))
  (require (lib "date.ss"))
  (provide (all-defined-except ))

(define make-table
  (lambda z (if (null? z) (make-hash-table) (make-hash-table 'equal))))

(define table-get
  (lambda (ht k . d)
    (hash-table-get ht k (let ((d (if (null? d) #f (car d)))) (lambda () d)))))

; ensure shell-magic above
;Configured for Scheme dialect plt by scmxlate, v 2004-09-08,
;(c) Dorai Sitaram, 
;http://www.ccs.neu.edu/~dorai/scmxlate/scmxlate.html

(define *tex2page-version* "2004-09-11")

(define *tex2page-website*
  "http://www.ccs.neu.edu/~dorai/tex2page/tex2page-doc.html")

(define *operating-system*
  (if (getenv "COMSPEC")
    (let ((term (getenv "TERM")))
      (if (and (string? term) (string=? term "cygwin")) 'unix 'windows))
    'unix))

(define *enable-write-18?* #t)

(define *output-extension* ".html")

(define *ghostscript*
  (case *operating-system*
    ((windows)
     (or (ormap
          (lambda (f) (and (file-exists? f) f))
          '("c:\\cygwin\\bin\\gs.exe"
            "g:\\cygwin\\bin\\gs.exe"
            "c:\\aladdin\\gs6.01\\bin\\gswin32c.exe"
            "d:\\aladdin\\gs6.01\\bin\\gswin32c.exe"
            "d:\\gs\\gs8.00\\bin\\gswin32.exe"
            "g:\\gs\\gs8.00\\bin\\gswin32.exe"))
         "gswin32.exe"))
    (else "gs")))

(define *image-format* 'gif)

(define *use-advanced-html-entities?* #f)

(define *use-closing-p-tag?* #t)

(define *metapost* (case *operating-system* ((windows) "mp") (else "mpost")))

(define *navigation-sentence-begin* "Go to ")

(define *navigation-first-name* "first")

(define *navigation-previous-name* "previous")

(define *navigation-next-name* "next")

(define *navigation-page-name* " page")

(define *navigation-contents-name* "contents")

(define *navigation-index-name* "index")

(define *navigation-sentence-end* "")

(define *last-modified* "Last modified")

(define *html-conversion-by* "HTML conversion by")

(define *scheme-version* (string-append "MzScheme " (version)))

(define *path-separator* (if (eqv? *operating-system* 'windows) #\; #\:))

(define *directory-separator* (if (eqv? *operating-system* 'windows) "\\" "/"))

(define *bye-tex*
  (case *operating-system*
    ((windows) " \\bye")
    ((unix) " \\\\bye")
    (else " \\\\bye")))

(define *int-corresp-to-0* (char->integer #\0))

(define *aux-file-suffix* "-Z-A")

(define *bib-aux-file-suffix* "--h")

(define *css-file-suffix* "-Z-S.css")

(define *eval-file-suffix* "-Z-E-")

(define *html-node-prefix* "node_")

(define *html-page-suffix* "-Z-H-")

(define *img-file-suffix* "-Z-G-")

(define *imgdef-file-suffix* "D-")

(define *index-file-suffix* "--h")

(define *label-file-suffix* "-Z-L")

(define *mfpic-tex-file-suffix* ".Z-M-tex")

(define *toc-file-suffix* "-Z-C")

(define *ghostscript-options*
  " -q -dBATCH -dNOPAUSE -dNO_PAUSE -sDEVICE=ppmraw")

(define *invisible-space* (list '*invisible-space*))

(define *month-names*
  (vector
    "January"
    "February"
    "March"
    "April"
    "May"
    "June"
    "July"
    "August"
    "September"
    "October"
    "November"
    "December"))

(define *if-aware-ctl-seqs*
  '("\\csname" "\\else" "\\end" "\\eval" "\\fi" "\\let"))

(define *html-bull* "&curren;")

(define *html-dagger* "&plusmn;")

(define *html-^dagger* "&plusmn;&plusmn;")

(define *html-ldquo* "``")

(define *html-lsaquo* "&lt;")

(define *html-lsquo* "`")

(define *html-mdash* " -- ")

(define *html-ndash* "-")

(define *html-oelig* "oe")

(define *html-^oelig* "OE")

(define *html-rdquo* "''")

(define *html-rsaquo* "&gt;")

(define *html-rsquo* "'")

(define *html-scaron* "<u>s</u>")

(define *html-^scaron* "<u>S</u>")

(define *html-trade* "<sup>TM</sup>")

(define *html-^yuml* "Y&quot;")

(define html-advanced-entities
  (lambda ()
    (set! *use-advanced-html-entities?* #t)
    (set! *html-bull* "&#8226;")
    (set! *html-dagger* "&#8224;")
    (set! *html-^dagger* "&#8225;")
    (set! *html-ldquo* "&#8220;")
    (set! *html-lsaquo* "&#8249;")
    (set! *html-lsquo* "&#8216;")
    (set! *html-mdash* "&#8212;")
    (set! *html-ndash* "&#8211;")
    (set! *html-^oelig* "&#338;")
    (set! *html-oelig* "&#339;")
    (set! *html-rdquo* "&#8221;")
    (set! *html-rsaquo* "&#8250;")
    (set! *html-rsquo* "&#8217;")
    (set! *html-^scaron* "&#352;")
    (set! *html-scaron* "&#353;")
    (set! *html-trade* "&#8482;")
    (set! *html-^yuml* "&#376;")))

(define *filename-delims* '())

(define *scm-token-delims*
  (list #\( #\) #\[ #\] #\{ #\} #\' #\` #\" #\; #\, #\|))

(define *tex-extra-letters* '())

(define *return* (integer->char 13))

(define *tab* (integer->char 9))

(define *afterpar* '())

(define *aux-dir* #f)

(define *aux-dir/* "")

(define *aux-port* #f)

(define *bib-aux-port* #f)

(define *bibitem-num* 0)

(define *colophon-links-to-tex2page-website?* #t)

(define *colophon-mentions-last-mod-time?* #t)

(define *colophon-mentions-tex2page?* #t)

(define *colophon-on-first-page?* #t)

(define *color-names* '())

(define *comment-char* #\%)

(define *css-port* #f)

(define *current-tex2page-input* #f)

(define *current-tex-file* #f)

(define *display-justification* 'center)

(define *dotted-counters* #f)

(define *dumping-nontex?* #f)

(define *epsf-xsize* #f)

(define *epsf-ysize* #f)

(define *equation-number* #f)

(define *equation-numbered?* #t)

(define *equation-position* 0)

(define *esc-char* #\\)

(define *esc-char-std* #\\)

(define *esc-char-verb* #\|)

(define *eval-file-count* 0)

(define *eval-for-tex-only?* #f)

(define *external-label-tables* #f)

(define *footnote-list* '())

(define *footnote-sym* 0)

(define *global-texframe* #f)

(define *graphics-file-extensions* '())

(define *html* #f)

(define *html-head* #f)

(define *html-only* #f)

(define *html-page* #f)

(define *html-page-count* #f)

(define *ignore-timestamp?* #f)

(define *img-magnification* 1)

(define *img-file-count* 0)

(define *img-file-extn* "")

(define *img-file-tally* 0)

(define *imgdef-file-count* 0)

(define *imgpreamble* #f)

(define *imgpreamble-inferred* #f)

(define *in-alltt?* #f)

(define *in-display-math?* #f)

(define *in-para?* #f)

(define *in-small-caps?* #f)

(define *includeonly-list* #f)

(define *index-table* #f)

(define *index-count* #f)

(define *index-page* #f)

(define *index-port* #f)

(define *infructuous-calls-to-tex2page* #f)

(define *input-line-no* #f)

(define *input-streams* '())

(define *inputting-boilerplate?* #f)

(define *inside-appendix?* #f)

(define *jobname* "texput")

(define *label-port* #f)

(define *label-source* #f)

(define *label-table* #f)

(define *last-modification-time* #f)

(define *last-page-number* #f)

(define *latex-probability* #f)

(define *ligatures?* #f)

(define *loading-external-labels?* #f)

(define *log-file* #f)

(define *log-port* #f)

(define *main-tex-file* #f)

(define *math-mode?* #f)

(define *math-script-mode?* #f)

(define *math-roman-mode?* #f)

(define *mfpic-file-num* #f)

(define *mfpic-file-stem* #f)

(define *mfpic-port* #f)

(define *missing-eps-files* #f)

(define *missing-pieces* #f)

(define *mp-files* #f)

(define *not-processing?* #f)

(define *output-streams* '())

(define *outputting-external-title?* #f)

(define *outputting-to-non-html?* #f)

(define *recent-node-name* #f)

(define *remember-index-number* #f)

(define *scm-builtins* '())

(define *scm-dribbling?* #f)

(define *scm-keywords*
  '("=>"
    "and"
    "begin"
    "begin0"
    "case"
    "cond"
    "define"
    "define-macro"
    "define-syntax"
    "defmacro"
    "defstruct"
    "delay"
    "do"
    "else"
    "flet"
    "fluid-let"
    "if"
    "labels"
    "lambda"
    "let"
    "let-syntax"
    "let*"
    "letrec"
    "letrec-syntax"
    "macrolet"
    "or"
    "quasiquote"
    "quote"
    "set!"
    "syntax-case"
    "syntax-rules"
    "unless"
    "unquote"
    "unquote-splicing"
    "when"
    "with"
    "with-handlers"))

(define *scm-variables* '())

(define *section-counters* #f)

(define *section-counter-dependencies* #f)

(define *slatex-like-comments?* #f)

(define *slatex-math-escape* #f)

(define *source-changed-since-last-run?* #f)

(define *stylesheets* #f)

(define *subjobname* *jobname*)

(define *tabular-stack* '())

(define *temp-string-count* #f)

(define *tex2page-inputs* #f)

(define *tex-env* '())

(define *tex-format* #f)

(define *tex-if-stack* '())

(define *title* #f)

(define *toc-list* #f)

(define *toc-page* #f)

(define *tracingcommands?* #f)

(define *tracingmacros?* #f)

(define *unresolved-xrefs* #f)

(define *use-image-for-displayed-math?* #t)

(define *use-image-for-intext-math?* #t)

(define *using-bibliography?* #f)

(define *using-chapters?* #f)

(define *using-index?* #f)

(define *verb-display?* #f)

(define *verb-port* #f)

(define *verb-visible-space?* #f)

(define *verb-written-files* '())

(define *write-log-max* 55)

(define *write-log-index* 0)

(define *write-log-possible-break?* #f)

(define *zeroth-html-page* #f)

(define strftime-like
  (lambda (ignore-format d)
    (string-append
      (date->string d)
      (let ((tz (getenv "TZ"))) (if tz (string-append " " tz) "")))))

(define seconds->human-time
  (lambda (s) (strftime-like "%a, %b %e, %Y, %l:%M %p %Z" (seconds->date s))))

(define number->roman
  (lambda (n upcase?)
    (unless (and (integer? n) (>= n 0))
      (terror 'number->roman "Missing number"))
    (let ((roman-digits
            '((1000 #\m 100)
              (500 #\d 100)
              (100 #\c 10)
              (50 #\l 10)
              (10 #\x 1)
              (5 #\v 1)
              (1 #\i 0)))
          (approp-case (lambda (c) (if upcase? (char-upcase c) c))))
      (let loop ((n n) (dd roman-digits) (s '()))
        (if (null? dd)
          (if (null? s) "0" (list->string (reverse! s)))
          (let* ((d (car dd))
                 (val (car d))
                 (char (approp-case (cadr d)))
                 (nextval (caddr d)))
            (let loop2 ((q (quotient n val)) (r (remainder n val)) (s s))
              (if (= q 0)
                (if (>= r (- val nextval))
                  (loop
                   (remainder r nextval)
                   (cdr dd)
                   (cons char (cons (approp-case (cadr (assv nextval dd))) s)))
                  (loop r (cdr dd) s))
                (loop2 (- q 1) r (cons char s))))))))))

(define list-index
  (lambda (l o)
    (let loop ((l l) (i 0))
      (cond
       ((null? l) #f)
       ((eqv? (car l) o) i)
       (else (loop (cdr l) (+ i 1)))))))

(define string-index
  (lambda (s c)
    (let ((n (string-length s)))
      (let loop ((i 0))
        (cond
         ((>= i n) #f)
         ((char=? (string-ref s i) c) i)
         (else (loop (+ i 1))))))))

(define string-reverse-index
  (lambda (s c)
    (let loop ((i (- (string-length s) 1)))
      (cond
       ((< i 0) #f)
       ((char=? (string-ref s i) c) i)
       (else (loop (- i 1)))))))

(define substring?
  (lambda (s1 s2)
    (let* ((s1-len (string-length s1))
           (s2-len (string-length s2))
           (n-give-up (+ 1 (- s2-len s1-len))))
      (let loop ((i 0))
        (if (< i n-give-up)
          (let loop2 ((j 0) (k i))
            (if (< j s1-len)
              (if (char=? (string-ref s1 j) (string-ref s2 k))
                (loop2 (+ j 1) (+ k 1))
                (loop (+ i 1)))
              i))
          #f)))))

(define list-position
  (lambda (x s)
    (let loop ((s s) (i 0))
      (cond
       ((null? s) #f)
       ((eq? (car s) x) i)
       (else (loop (cdr s) (+ i 1)))))))

(define-syntax defstruct
  (lambda (so)
    (datum->syntax-object
      so
      (let ((so-d (syntax-object->datum so)))
        (let ((s (cadr so-d)) (ff (cddr so-d)))
          (let ((s-s (symbol->string s)) (n (length ff)))
            (let* ((n+1 (+ n 1)) (vv (make-vector n+1)))
              (let loop ((i 1) (ff ff))
                (if (< i n+1)
                  (let ((f (car ff)))
                    (vector-set! vv i (if (pair? f) (cadr f) '(if #f #f)))
                    (loop (+ i 1) (cdr ff)))))
              (let ((ff (map (lambda (f) (if (pair? f) (car f) f)) ff)))
                `(begin
                   (define ,(string->symbol (string-append "make-" s-s))
                     (lambda fvfv
                       (let ((st (make-vector ,n+1)) (ff ',ff))
                         (vector-set! st 0 ',s)
                         ,@(let loop ((i 1) (r '()))
                             (if (>= i n+1)
                               r
                               (loop
                                (+ i 1)
                                (cons
                                 `(vector-set! st ,i ,(vector-ref vv i))
                                 r))))
                         (let loop ((fvfv fvfv))
                           (unless (null? fvfv)
                             (vector-set!
                               st
                               (+ (list-position (car fvfv) ff) 1)
                               (cadr fvfv))
                             (loop (cddr fvfv))))
                         st)))
                   ,@(let loop ((i 1) (procs '()))
                       (if (>= i n+1)
                         procs
                         (loop
                          (+ i 1)
                          (let ((f (symbol->string (list-ref ff (- i 1)))))
                            (cons
                             `(define (unquote
                                       (string->symbol
                                         (string-append s-s "." f)))
                                (lambda (x) (vector-ref x ,i)))
                             (cons
                              `(define (unquote
                                        (string->symbol
                                          (string-append "set!" s-s "." f)))
                                 (lambda (x v) (vector-set! x ,i v)))
                              procs))))))
                   (define ,(string->symbol (string-append s-s "?"))
                     (lambda (x)
                       (and (vector? x) (eq? (vector-ref x 0) ',s)))))))))))))

(define lassoc
  (lambda (k al equ?)
    (let loop ((al al))
      (if (null? al)
        #f
        (let ((c (car al))) (if (equ? (car c) k) c (loop (cdr al))))))))

(define ldelete
  (lambda (y xx equ?)
    (let loop ((xx xx) (r '()))
      (if (null? xx)
        (reverse! r)
        (let ((x (car xx))) (loop (cdr xx) (if (equ? x y) r (cons x r))))))))

(defstruct counter (value 0) (within #f))

(defstruct tocentry level number page label header)

(define string-trim-blanks
  (lambda (s)
    (let ((orig-n (string-length s)))
      (let ((i 0) (n orig-n))
        (let loop ((k i))
          (cond
           ((>= k n) (set! i n))
           ((char-whitespace? (string-ref s k)) (loop (+ k 1)))
           (else (set! i k))))
        (let loop ((k (- n 1)))
          (cond
           ((<= k i) (set! n (+ k 1)))
           ((char-whitespace? (string-ref s k)) (loop (- k 1)))
           (else (set! n (+ k 1)))))
        (if (and (= i 0) (= n orig-n)) s (substring s i n))))))

(define char-tex-alphabetic?
  (lambda (c)
    (or (char-alphabetic? c)
        (ormap (lambda (d) (char=? c d)) *tex-extra-letters*))))

(define gen-temp-string
  (lambda ()
    (set! *temp-string-count* (+ *temp-string-count* 1))
    (string-append "Temp_" (number->string *temp-string-count*))))

(define file-stem-name
  (lambda (f)
    (let ((slash (string-reverse-index f #\/)))
      (when slash (set! f (substring f (+ slash 1) (string-length f))))
      (let ((dot (string-reverse-index f #\.)))
        (if dot (substring f 0 dot) f)))))

(define file-extension
  (lambda (f)
    (let ((slash (string-reverse-index f #\/))
          (dot (string-reverse-index f #\.)))
      (if (and dot (not (= dot 0)) (or (not slash) (< (+ slash 1) dot)))
        (substring f dot (string-length f))
        #f))))

(define ensure-file-deleted (lambda (f) (if (file-exists? f) (delete-file f))))

(define write-aux (lambda (e) (write e *aux-port*) (newline *aux-port*)))

(define write-label
  (lambda (e)
    (unless *label-port*
      (let ((f
             (string-append *aux-dir/* *jobname* *label-file-suffix* ".scm")))
        (ensure-file-deleted f)
        (set! *label-port* (open-output-file f))))
    (write e *label-port*)
    (newline *label-port*)))

(define write-bib-aux
  (lambda (x)
    (unless *bib-aux-port*
      (let ((f
             (string-append
               *aux-dir/*
               *jobname*
               *bib-aux-file-suffix*
               ".aux")))
        (ensure-file-deleted f)
        (set! *bib-aux-port* (open-output-file f))))
    (display x *bib-aux-port*)))

(define write-log
  (lambda (x)
    (unless *log-port*
      (set! *log-file* (string-append *aux-dir/* *jobname* ".hlog"))
      (ensure-file-deleted *log-file*)
      (set! *log-port* (open-output-file *log-file*)))
    (when (and
           *write-log-possible-break?*
           (char? x)
           (ormap (lambda (c) (char=? x c)) '(#\) #\] #\} #\,)))
      (set! *write-log-possible-break?* #f))
    (when (and
           *write-log-possible-break?*
           (> *write-log-index* *write-log-max*))
      (newline *log-port*)
      (newline)
      (set! *write-log-possible-break?* #f)
      (set! *write-log-index* 0))
    (unless (and
             (= *write-log-index* 0)
             (or (eqv? x 'separation-newline) (eqv? x 'separation-space)))
      (case x
        ((#\newline separation-newline)
         (when *write-log-possible-break?*
           (set! *write-log-possible-break?* #f))
         (newline *log-port*)
         (newline)
         (set! *write-log-index* 0))
        ((separation-space) (set! *write-log-possible-break?* #t))
        (else
         (when *write-log-possible-break?*
           (write-char #\space *log-port*)
           (write-char #\space)
           (set! *write-log-index* (+ *write-log-index* 1))
           (set! *write-log-possible-break?* #f))
         (display x *log-port*)
         (display x)
         (flush-output)
         (set! *write-log-index*
           (+
            *write-log-index*
            (cond
             ((char? x) 1)
             ((number? x) (string-length (number->string x)))
             ((string? x) (string-length x))
             (else 1)))))))))

(define display-error-context-lines
  (lambda ()
    (let ((n (let ((c (find-count "\\errorcontextlines"))) (if c (cadr c) 0))))
      (when (and *input-line-no* *current-tex-file* (> n 0))
        (let* ((n1 (max 0 (- *input-line-no* (quotient (- n 1) 2))))
               (nf (+ n1 n -1))
               (ll
                (call-with-input-file
                  *current-tex-file*
                  (lambda (ip)
                    (let loop ((i 1) (ll '()))
                      (let ((l (read-line ip)))
                        (cond
                         ((eof-object? l) ll)
                         ((< i n1) (loop (+ i 1) ll))
                         ((<= i nf) (loop (+ i 1) (cons (cons i l) ll)))
                         (else ll))))))))
          (unless (null? ll)
            (let* ((border "__________________________...")
                   (only-1? (= (length ll) 1))
                   (nf (caar ll))
                   (ll (reverse! ll))
                   (n1 (caar ll)))
              (write-log "Likely error context: ")
              (write-log *current-tex-file*)
              (write-log ", line")
              (unless only-1? (write-log "s"))
              (write-log " ")
              (write-log n1)
              (unless only-1? (write-log "-") (write-log nf))
              (write-log ":")
              (write-log #\newline)
              (write-log " /")
              (write-log border)
              (write-log #\newline)
              (for-each
                (lambda (l)
                  (write-log " | ")
                  (write-log (cdr l))
                  (write-log #\newline))
                ll)
              (write-log " |")
              (write-log border)
              (write-log #\newline)
              (write-log "/"))))))))

(define terror
  (lambda (where . args)
    (write-log 'separation-newline)
    (write-log "! ")
    (for-each write-log args)
    (write-log 'separation-newline)
    (when *input-line-no*
      (write-log "l.")
      (write-log *input-line-no*)
      (write-log #\space))
    (write-log where)
    (write-log " failed.")
    (write-log 'separation-newline)
    (display-error-context-lines)
    (close-all-open-ports)
    (output-stats)
    (display "Type e to edit file at point of error; x to quit.")
    (newline)
    (display "? ")
    (flush-output)
    (let ((c (read-char)))
      (when (and (not (eof-object? c)) (char-ci=? c #\e))
        (edit-offending-file)))
    (error "TeX2page fatal error")))

(define edit-offending-file
  (lambda ()
    (let ((bad-texedit? #f) (cmd #f))
      (cond
       ((getenv "TEXEDIT")
        =>
        (lambda (s)
          (cond
           ((substring? "%d" s)
            =>
            (lambda (i)
              (set! s
                (string-append
                  (substring s 0 i)
                  (number->string *input-line-no*)
                  (substring s (+ i 2) (string-length s))))))
           (else (set! bad-texedit? #t)))
          (cond
           ((and (not bad-texedit?) (substring? "%s" s))
            =>
            (lambda (i)
              (set! s
                (string-append
                  (substring s 0 i)
                  *current-tex-file*
                  (substring s (+ i 2) (string-length s))))))
           (else (set! bad-texedit? #t)))
          (cond
           (bad-texedit? (display "Bad TEXEDIT; using EDITOR.") (newline))
           (else (set! cmd s))))))
      (cond
       ((and (not cmd) (or (getenv "EDITOR") "vi"))
        =>
        (lambda (s)
          (set! cmd
            (string-append
              s
              " +"
              (number->string *input-line-no*)
              " "
              *current-tex-file*)))))
      (when cmd (system cmd)))))

(define trace-if
  (lambda (write? . args)
    (when write?
      (write-log 'separation-newline)
      (when *input-line-no*
        (write-log "l.")
        (write-log *input-line-no*)
        (write-log #\space))
      (for-each write-log args)
      (write-log 'separation-newline))))

(define do-errmessage
  (lambda ()
    (write-log 'separation-newline)
    (write-log "! ")
    (write-log (tex-string->html-string (get-group)))
    (write-log 'separation-newline)
    (terror "\\errmessage")))

(define do-tracingall
  (lambda () (do-tracingcommands #t) (do-tracingmacros #t)))

(define do-tracingcommands
  (lambda (unconditional-set?)
    (set! *tracingcommands?*
      (or unconditional-set? (begin (get-equal-sign) (> (get-number) 0))))))

(define do-tracingmacros
  (lambda (unconditional-set?)
    (set! *tracingmacros?*
      (or unconditional-set? (begin (get-equal-sign) (> (get-number) 0))))))

(defstruct bport (port #f) (buffer '()))

(define call-with-input-file/buffered
  (lambda (f th)
    (unless (file-exists? f)
      (terror 'call-with-input-file/buffered "I can't find file " f))
    (call-with-input-file
      f
      (lambda (i)
        (fluid-let
          ((*current-tex2page-input* (make-bport 'port i))
           (*current-tex-file* f)
           (*input-line-no* 1))
          (th))))))

(define call-with-input-string/buffered
  (lambda (s th)
    (fluid-let
      ((*current-tex2page-input* (make-bport 'buffer (string->list s)))
       (*input-line-no* *input-line-no*))
      (th))))

(define call-with-input-string
  (lambda (s p)
    (let* ((i (open-input-string s)) (r (p i))) (close-input-port i) r)))

(define snoop-char (lambda () (let ((c (get-char))) (toss-back-char c) c)))

(define get-char
  (lambda ()
    (let ((b (bport.buffer *current-tex2page-input*)))
      (if (null? b)
        (let ((p (bport.port *current-tex2page-input*)))
          (if (not p)
            eof
            (let ((c (read-char p)))
              (cond
               ((eof-object? c) c)
               ((char=? c #\newline)
                (set! *input-line-no* (+ *input-line-no* 1))
                c)
               (else c)))))
        (let ((c (car b)))
          (set!bport.buffer *current-tex2page-input* (cdr b))
          c)))))

(define toss-back-string
  (lambda (s)
    (set!bport.buffer
      *current-tex2page-input*
      (append! (string->list s) (bport.buffer *current-tex2page-input*)))))

(define toss-back-char
  (lambda (c)
    (set!bport.buffer
      *current-tex2page-input*
      (cons c (bport.buffer *current-tex2page-input*)))))

(define emit (lambda (s) (display s *html*)))

(define emit-newline (lambda () (newline *html*)))

(define emit-visible-space
  (lambda () (display "<font color=red>&middot;</font>" *html*)))

(define invisible-space? (lambda (x) (eq? x *invisible-space*)))

(define snoop-actual-char
  (lambda ()
    (let ((c (snoop-char)))
      (cond
       ((eof-object? c) c)
       ((invisible-space? c) (get-char) (snoop-actual-char))
       ((char=? c *return*)
        (get-char)
        (let ((c (snoop-actual-char)))
          (if (and (not (eof-object? c)) (char=? c #\newline))
            c
            (begin (toss-back-char #\newline) #\newline))))
       (else c)))))

(define get-actual-char
  (lambda ()
    (let ((c (get-char)))
      (cond
       ((eof-object? c) c)
       ((invisible-space? c) (get-actual-char))
       ((char=? c *return*)
        (let ((c (snoop-actual-char)))
          (if (and (not (eof-object? c)) (char=? c #\newline))
            (get-actual-char)
            #\newline)))
       (else c)))))

(define get-line
  (lambda ()
    (let loop ((r '()))
      (let ((c (get-actual-char)))
        (cond
         ((eof-object? c) (if (null? r) c (list->string (reverse! r))))
         ((char=? c #\newline) (list->string (reverse! r)))
         (else (loop (cons c r))))))))

(define ignorespaces
  (lambda ()
    (if (find-chardef #\space)
      (when (= (the-count "\\TIIPobeyspacestrictly") 0)
        (let ((c (snoop-actual-char)))
          (cond
           ((eof-object? c) #t)
           ((char=? c #\newline) #t)
           ((char-whitespace? c) (get-actual-char))
           (else #t))))
      (let ((newline-active? (find-chardef #\newline))
            (newline-already-read? #f))
        (let loop ()
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) #t)
             ((char=? c #\newline)
              (cond
               (newline-active? #t)
               (newline-already-read? (toss-back-char #\newline))
               (else
                (get-actual-char)
                (set! newline-already-read? #t)
                (loop))))
             ((char-whitespace? c) (get-actual-char) (loop))
             (else #t))))))))

(define ignore-all-whitespace
  (lambda ()
    (let loop ()
      (let ((c (snoop-actual-char)))
        (unless (eof-object? c)
          (when (char-whitespace? c) (get-actual-char) (loop)))))))

(define munch-newlines
  (lambda ()
    (let loop ((n 0))
      (let ((c (snoop-actual-char)))
        (cond
         ((eof-object? c) n)
         ((char=? c #\newline) (get-actual-char) (loop (+ n 1)))
         ((char-whitespace? c) (get-actual-char) (loop n))
         (else n))))))

(define munched-a-newline?
  (lambda ()
    (let loop ()
      (let ((c (snoop-actual-char)))
        (cond
         ((eof-object? c) #f)
         ((char=? c #\newline) (get-actual-char) #t)
         ((char-whitespace? c) (get-actual-char) (loop))
         (else #f))))))

(define do-xspace
  (lambda ()
    (let ((c (snoop-actual-char)))
      (unless (memv c '(#\space #\" #\. #\! #\, #\: #\; #\? #\/ #\' #\) #\-))
        (emit #\space)))))

(define do-relax (lambda () #t))

(define get-ctl-seq
  (lambda ()
    (let ((bs (get-actual-char)))
      (unless (char=? bs *esc-char*)
        (terror 'get-ctl-seq "Missing control sequence (" bs ")")))
    (let ((c (get-char)))
      (cond
       ((eof-object? c) "\\ ")
       ((invisible-space? c) "\\ ")
       ((char-tex-alphabetic? c)
        (list->string
          (reverse!
            (let loop ((s (list c #\\)))
              (let ((c (snoop-char)))
                (cond
                 ((eof-object? c) s)
                 ((invisible-space? c) s)
                 ((char-alphabetic? c) (get-char) (loop (cons c s)))
                 (else
                  (unless (or *math-mode?* *not-processing?*) (ignorespaces))
                  s)))))))
       (else (string #\\ c))))))

(define get-char-as-ctl-seq
  (lambda ()
    (let* ((cs (get-ctl-seq)) (c (string-ref cs 1)))
      (if (char=? c #\^)
        (let ((c2 (snoop-actual-char)))
          (if (char=? c2 #\^)
            (begin
              (get-actual-char)
              (let ((c3 (get-actual-char)))
                (case c3
                  ((#\M) #\newline)
                  ((#\I) *tab*)
                  (else (terror 'get-char-as-ctl-seq)))))
            c))
        c))))

(define ctl-seq? (lambda (z) (char=? (string-ref z 0) #\\)))

(define if-aware-ctl-seq?
  (lambda (z)
    (or (ormap (lambda (y) (string=? z y)) *if-aware-ctl-seqs*)
        (and (>= (string-length z) 3)
             (char=? (string-ref z 1) #\i)
             (char=? (string-ref z 2) #\f))
        (let ((z-th (find-corresp-prim-thunk z)))
          (if (string? z-th)
            #f
            (ormap
             (lambda (y) (eq? z-th (find-corresp-prim-thunk y)))
             *if-aware-ctl-seqs*))))))

(define get-group-as-reversed-chars
  (lambda ()
    (ignorespaces)
    (let ((c (get-actual-char)))
      (if (eof-object? c) (terror 'get-group "Runaway argument?"))
      (unless (char=? c #\{) (terror 'get-group "Missing {"))
      (let loop ((s (list c)) (nesting 0) (escape? #f))
        (let ((c (get-actual-char)))
          (if (eof-object? c) (terror 'get-group "Runaway argument?"))
          (cond
           (escape? (loop (cons c s) nesting #f))
           ((char=? c *esc-char*) (loop (cons c s) nesting #t))
           ((char=? c #\{) (loop (cons c s) (+ nesting 1) #f))
           ((char=? c #\})
            (if (= nesting 0) (cons c s) (loop (cons c s) (- nesting 1) #f)))
           (else (loop (cons c s) nesting #f))))))))

(define get-group
  (lambda () (list->string (reverse! (get-group-as-reversed-chars)))))

(define get-peeled-group
  (lambda () (string-trim-blanks (ungroup (get-group)))))

(define get-token-or-peeled-group
  (lambda () (string-trim-blanks (ungroup (get-token)))))

(define get-grouped-environment-name-if-any
  (lambda ()
    (let ((c (snoop-actual-char)))
      (if (or (eof-object? c) (not (char=? c #\{)))
        #f
        (begin
          (get-actual-char)
          (let loop ((s '()))
            (let ((c (snoop-actual-char)))
              (cond
               ((or (char-alphabetic? c) (char=? c #\*))
                (get-actual-char)
                (loop (cons c s)))
               ((and (pair? s) (char=? c #\}))
                (get-actual-char)
                (list->string (reverse! s)))
               (else
                (for-each toss-back-char s)
                (toss-back-char #\{)
                #f)))))))))

(define get-bracketed-text-if-any
  (lambda ()
    (ignorespaces)
    (let ((c (snoop-actual-char)))
      (if (or (eof-object? c) (not (char=? c #\[)))
        #f
        (begin
          (get-actual-char)
          (list->string
            (reverse!
              (let loop ((s '()) (nesting 0) (escape? #f))
                (let ((c (get-actual-char)))
                  (if (eof-object? c)
                    (terror 'get-bracketed-text-if-any "Runaway argument?"))
                  (cond
                   (escape? (loop (cons c s) nesting #f))
                   ((char=? c *esc-char*) (loop (cons c s) nesting #t))
                   ((char=? c #\{) (loop (cons c s) (+ nesting 1) #f))
                   ((char=? c #\}) (loop (cons c s) (- nesting 1) #f))
                   ((char=? c #\])
                    (if (= nesting 0) s (loop (cons c s) nesting #f)))
                   (else (loop (cons c s) nesting #f))))))))))))

(define ungroup
  (lambda (s)
    (let* ((n (string-length s)) (n-1 (- n 1)))
      (if (or (< n 2)
              (not (char=? (string-ref s 0) #\{))
              (not (char=? (string-ref s n-1) #\})))
        s
        (substring s 1 n-1)))))

(define get-filename
  (lambda (braced?)
    (ignorespaces)
    (when braced?
      (let ((c (snoop-actual-char)))
        (if (and (char? c) (char=? c #\{))
          (get-actual-char)
          (set! braced? #f))))
    (list->string
      (reverse!
        (let loop ((s '()))
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) s)
             ((and (not braced?)
                   (or (char-whitespace? c)
                       (and *comment-char* (char=? c *comment-char*))
                       (ormap (lambda (d) (char=? c d)) *filename-delims*)))
              (unless *not-processing?* (ignorespaces))
              s)
             ((and braced? (char=? c #\})) (get-actual-char) s)
             ((and *esc-char* (char=? c *esc-char*))
              (let ((x (get-ctl-seq)))
                (if (string=? x "\\jobname")
                  (loop (append! (reverse! (string->list *jobname*)) s))
                  (begin
                    (toss-back-char *invisible-space*)
                    (toss-back-string x)
                    s))))
             (else (get-actual-char) (loop (cons c s))))))))))

(define get-plain-filename (lambda () (get-filename #f)))

(define get-filename-possibly-braced
  (lambda ()
    (ignorespaces)
    (let ((c (snoop-actual-char)))
      (get-filename (and (char? c) (char=? c #\{))))))

(define get-integer
  (lambda (base)
    (ignorespaces)
    (string->number
      (list->string
        (reverse!
          (let loop ((s '()))
            (let ((c (snoop-actual-char)))
              (cond
               ((eof-object? c) s)
               ((or (char-numeric? c) (and (= base 16) (char-alphabetic? c)))
                (get-actual-char)
                (loop (cons c s)))
               (else (ignorespaces) s))))))
      base)))

(define get-real
  (lambda ()
    (ignorespaces)
    (let ((minus? #f) (c (snoop-actual-char)))
      (when (char=? c #\-) (set! minus? #t))
      (when (or minus? (char=? c #\+)) (get-actual-char))
      (let ((n
             (string->number
               (list->string
                 (reverse!
                   (let loop ((s '()))
                     (let ((c (snoop-actual-char)))
                       (cond
                        ((eof-object? c) s)
                        ((or (char-numeric? c) (char=? c #\.))
                         (get-actual-char)
                         (loop (cons c s)))
                        (else (ignorespaces) s)))))))))
        (if minus? (- n) n)))))

(define get-equal-sign
  (lambda ()
    (ignorespaces)
    (when (char=? (snoop-actual-char) #\=) (get-actual-char))))

(define get-by
  (lambda ()
    (ignorespaces)
    (when (char=? (snoop-actual-char) #\b)
      (get-actual-char)
      (if (char=? (snoop-actual-char) #\y)
        (get-actual-char)
        (toss-back-char #\b)))))

(define get-to
  (lambda ()
    (ignorespaces)
    (when (char=? (snoop-actual-char) #\t)
      (get-actual-char)
      (cond
       ((char=? (snoop-actual-char) #\o) (get-actual-char) (ignorespaces))
       (else (toss-back-char #\t))))))

(define get-number-corresp-to-ctl-seq
  (lambda (x)
    (cond
     ((string=? x "\\the") (get-number-corresp-to-ctl-seq (get-ctl-seq)))
     ((string=? x "\\active") 13)
     ((string=? x "\\pageno") *html-page-count*)
     ((string=? x "\\inputlineno") *input-line-no*)
     ((string=? x "\\footnotenumber") (get-gcount "\\footnotenumber"))
     ((string=? x "\\figurenumber")
      (counter.value (table-get *dotted-counters* "figure")))
     ((string=? x "\\sectiondnumber")
      (table-get *section-counters* (string->number (ungroup (get-token))) 0))
     ((find-count x) => cadr)
     (else (or (string->number (or (resolve-defs x) x)))))))

(define get-number-or-false
  (lambda ()
    (ignorespaces)
    (let ((c (snoop-actual-char)))
      (cond
       ((char=? c *esc-char*) (get-number-corresp-to-ctl-seq (get-ctl-seq)))
       ((char=? c #\') (get-actual-char) (get-integer 8))
       ((char=? c #\") (get-actual-char) (get-integer 16))
       ((char=? c #\`)
        (get-actual-char)
        (ignorespaces)
        (char->integer
          (if (char=? (snoop-actual-char) *esc-char*)
            (string-ref (get-ctl-seq) 1)
            (get-actual-char))))
       ((char=? c #\+) (get-actual-char) (get-number-or-false))
       ((char=? c #\-)
        (get-actual-char)
        (let ((n (get-number-or-false))) (and n (- n))))
       ((char-numeric? c) (get-integer 10))
       (else #f)))))

(define get-number (lambda () (or (get-number-or-false) (terror 'get-number))))

(define get-tex-char-spec
  (lambda ()
    (ignorespaces)
    (case (snoop-actual-char)
      ((#\`)
       (get-actual-char)
       (ignorespaces)
       (if (char=? (snoop-actual-char) #\\)
         (get-char-as-ctl-seq)
         (get-actual-char)))
      ((#\') (get-actual-char) (integer->char (get-integer 8)))
      ((#\") (get-actual-char) (integer->char (get-integer 16)))
      (else (integer->char (get-integer 10))))))

(define get-url
  (lambda ()
    (ignorespaces)
    (let ((c (get-actual-char)))
      (cond
       ((eof-object? c) (terror 'get-url "Missing {"))
       ((not (char=? c #\{)) (terror 'get-url "Missing {")))
      (string-trim-blanks
        (list->string
          (reverse!
            (let loop ((nesting 0) (s '()))
              (let ((c (get-actual-char)))
                (cond
                 ((eof-object? c) (terror 'get-url "Missing }"))
                 ((and *comment-char* (char=? c *comment-char*))
                  (let ((c1 (snoop-actual-char)))
                    (loop
                     nesting
                     (if (and (char? c1) (char-whitespace? c1))
                       (begin (ignore-all-whitespace) s)
                       (cons c s)))))
                 ((char=? c #\{) (loop (+ nesting 1) (cons c s)))
                 ((char=? c #\})
                  (if (= nesting 0) s (loop (- nesting 1) (cons c s))))
                 (else (loop nesting (cons c s))))))))))))

(define get-csv
  (lambda ()
    (ignorespaces)
    (let ((rev-lbl
            (let loop ((s '()) (nesting 0))
              (let ((c (get-actual-char)))
                (cond
                 ((eof-object? c)
                  (terror
                    'get-csv
                    "Runaway argument of \\cite, "
                    "\\nocite, \\expandhtmlindex?")
                  s)
                 ((and (char=? c #\,) (= nesting 0)) s)
                 ((char=? c #\{) (loop (cons c s) (+ nesting 1)))
                 ((char=? c #\})
                  (if (= nesting 0)
                    (begin (toss-back-char c) s)
                    (loop (cons c s) (- nesting 1))))
                 (else (loop (cons c s) nesting)))))))
      (if (null? rev-lbl) #f (list->string (reverse! rev-lbl))))))

(define get-raw-token
  (lambda ()
    (let ((c (snoop-actual-char)))
      (cond
       ((eof-object? c) c)
       ((char=? c *esc-char*)
        (fluid-let ((*not-processing?* #t)) (get-ctl-seq)))
       (else (string (get-actual-char)))))))

(define get-raw-token/is
  (lambda ()
    (ignorespaces)
    (let ((c (snoop-actual-char)))
      (cond
       ((eof-object? c) c)
       ((char=? c *esc-char*) (get-ctl-seq))
       ((and *comment-char* (char=? c *comment-char*))
        (eat-till-eol)
        (get-raw-token/is))
       (else (string (get-actual-char)))))))

(define get-token
  (lambda ()
    (ignorespaces)
    (let ((c (snoop-actual-char)))
      (cond
       ((eof-object? c) c)
       ((char=? c *esc-char*) (get-ctl-seq))
       ((char=? c #\{) (get-group))
       ((and *comment-char* (char=? c *comment-char*))
        (eat-till-eol)
        (get-token))
       (else (string (get-actual-char)))))))

(define eat-word
  (lambda (word)
    (ignorespaces)
    (let ((n (string-length word)))
      (let loop ((i 0) (r '()))
        (if (>= i n)
          #t
          (let ((c (snoop-actual-char)))
            (cond
             ((char=? c (string-ref word i))
              (get-actual-char)
              (loop (+ i 1) (cons c r)))
             (else (for-each toss-back-char r) #f))))))))

(define eat-dimen
  (lambda ()
    (get-equal-sign)
    (fluid-let
      ((*not-processing?* #t))
      (let loop ((first? #t))
        (ignorespaces)
        (let ((c (snoop-actual-char)))
          (cond
           ((eof-object? c) 'done)
           ((and (char=? c *esc-char*) first?) (get-ctl-seq))
           ((or (char-numeric? c) (char=? c #\.)) (get-real) (loop first?))
           ((or (char=? c #\') (char=? c #\")) (get-number) (loop first?))
           ((ormap eat-word '("+" "-")) (loop first?))
           ((ormap
             eat-word
             '("bp"
               "cc"
               "cm"
               "dd"
               "em"
               "ex"
               "filll"
               "fill"
               "fil"
               "in"
               "minus"
               "mm"
               "pc"
               "plus"
               "pt"
               "sp"
               "true"))
            (loop #f))
           (else 'done)))))))

(define eat-integer
  (lambda ()
    (fluid-let
      ((*not-processing?* #t))
      (ignorespaces)
      (get-equal-sign)
      (get-number))))

(define scm-get-token
  (lambda ()
    (list->string
      (reverse!
        (let loop ((s '()) (esc? #f))
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) s)
             (esc? (get-actual-char) (loop (cons c s) #f))
             ((char=? c #\\) (get-actual-char) (loop (cons c s) #t))
             ((or (char-whitespace? c) (memv c *scm-token-delims*)) s)
             (else (get-actual-char) (loop (cons c s) #f)))))))))

(define emit-html-char
  (lambda (c)
    (unless (eof-object? c)
      (cond
       ((char=? c #\newline) (emit-newline))
       (*outputting-to-non-html?* (emit c))
       (else
        (case c
          ((#\<) (emit "&lt;"))
          ((#\>) (emit "&gt;"))
          ((#\") (emit "&quot;"))
          ((#\&) (emit "&amp;"))
          (else (emit c))))))))

(define emit-html-string
  (lambda (s)
    (let ((n (string-length s)))
      (let loop ((i 0))
        (unless (>= i n) (emit-html-char (string-ref s i)) (loop (+ i 1)))))))

(define member/string-ci=?
  (lambda (s ss) (ormap (lambda (x) (string-ci=? x s)) ss)))

(defstruct
  texframe
  (definitions '())
  (chardefinitions '())
  (counts '())
  (toks '())
  (dimens '())
  (postludes '())
  (aftergroups '()))

(set! *global-texframe* (make-texframe))

(define *primitive-texframe* (make-texframe))

(define *math-primitive-texframe* (make-texframe))

(define bgroup (lambda () (set! *tex-env* (cons (make-texframe) *tex-env*))))

(define egroup
  (lambda ()
    (if (null? *tex-env*) (terror 'egroup "Too many }'s"))
    (perform-postludes)
    (perform-aftergroups)
    (set! *tex-env* (cdr *tex-env*))))

(define perform-postludes
  (lambda () (for-each (lambda (p) (p)) (texframe.postludes (top-texframe)))))

(define perform-aftergroups
  (lambda ()
    (let ((ags (texframe.aftergroups (top-texframe))))
      (unless (null? ags) (toss-back-char *invisible-space*))
      (for-each (lambda (ag) (ag)) ags))))

(define add-postlude-to-top-frame
  (lambda (p)
    (let ((fr (if (null? *tex-env*) *global-texframe* (car *tex-env*))))
      (set!texframe.postludes fr (cons p (texframe.postludes fr))))))

(define add-aftergroup-to-top-frame
  (lambda (ag)
    (let ((fr (if (null? *tex-env*) *global-texframe* (car *tex-env*))))
      (set!texframe.aftergroups fr (cons ag (texframe.aftergroups fr))))))

(define top-texframe
  (lambda () (if (null? *tex-env*) *global-texframe* (car *tex-env*))))

(defstruct
  tdef
  (argpat '())
  (expansion "")
  (optarg #f)
  (thunk #f)
  (prim #f)
  (defer #f))

(defstruct cdef (argpat #f) (expansion #f) (optarg #f) (active #f))

(define kopy-tdef
  (lambda (lft rt)
    (set!tdef.argpat lft (tdef.argpat rt))
    (set!tdef.expansion lft (tdef.expansion rt))
    (set!tdef.optarg lft (tdef.optarg rt))
    (set!tdef.thunk lft (tdef.thunk rt))
    (set!tdef.prim lft (tdef.prim rt))
    (set!tdef.defer lft (tdef.defer rt))))

(define kopy-cdef
  (lambda (lft rt)
    (set!cdef.argpat lft (cdef.argpat rt))
    (set!cdef.expansion lft (cdef.expansion rt))
    (set!cdef.optarg lft (cdef.optarg rt))
    (set!cdef.active lft (cdef.active rt))))

(define cleanse-tdef
  (lambda (d)
    (set!tdef.argpat d '())
    (set!tdef.expansion d "")
    (set!tdef.optarg d #f)
    (set!tdef.thunk d #f)
    (set!tdef.prim d #f)
    (set!tdef.defer d #f)))

(define tex-def
  (lambda (name argpat expansion optarg thunk prim defer frame)
    (unless frame (set! frame (top-texframe)))
    (let ((d
           (cond
            ((lassoc name (texframe.definitions frame) string=?) => cdr)
            (else
             (let ((d (make-tdef)))
               (set!texframe.definitions
                 frame
                 (cons (cons name d) (texframe.definitions frame)))
               d)))))
      (set!tdef.argpat d argpat)
      (set!tdef.expansion d expansion)
      (set!tdef.optarg d optarg)
      (set!tdef.thunk d thunk)
      (set!tdef.prim d prim)
      (set!tdef.defer d defer))))

(define tex-def-prim
  (lambda (prim thunk)
    (tex-def prim '() #f #f thunk prim #f *primitive-texframe*)))

(define tex-def-0arg
  (lambda (cs expn fr) (tex-def cs '() expn #f #f #f #f fr)))

(define tex-let
  (lambda (lft rt frame)
    (unless frame (set! frame (top-texframe)))
    (let ((lft-def
            (cond
             ((lassoc lft (texframe.definitions frame) string=?) => cdr)
             (else
              (let ((lft-def (make-tdef)))
                (set!texframe.definitions
                  frame
                  (cons (cons lft lft-def) (texframe.definitions frame)))
                lft-def)))))
      (cond
       ((find-def rt) => (lambda (rt-def) (kopy-tdef lft-def rt-def)))
       (else (cleanse-tdef lft-def) (set!tdef.defer lft-def rt))))))

(define tex-let-prim (lambda (lft rt) (tex-let lft rt *primitive-texframe*)))

(define tex-def-thunk
  (lambda (name thunk frame)
    (unless (inside-false-world?)
      (tex-def name '() #f #f thunk name #f frame))))

(define tex-def-count
  (lambda (name num global?)
    (let ((frame (if global? *global-texframe* (top-texframe))))
      (cond
       ((lassoc name (texframe.counts frame) string=?)
        =>
        (lambda (c) (set-car! (cdr c) num)))
       (else
        (set!texframe.counts
          frame
          (cons (list name num) (texframe.counts frame))))))))

(define tex-def-toks
  (lambda (name tokens global?)
    (let ((frame (if global? *global-texframe* (top-texframe))))
      (cond
       ((lassoc name (texframe.toks frame) string=?)
        =>
        (lambda (c) (set-car! (cdr c) tokens)))
       (else
        (set!texframe.toks
          frame
          (cons (list name tokens) (texframe.toks frame))))))))

(define tex-def-dimen
  (lambda (name global?)
    (let ((frame (if global? *global-texframe* (top-texframe))))
      (cond
       ((lassoc name (texframe.dimens frame) string=?) #t)
       (else
        (set!texframe.dimens
          frame
          (cons (list name) (texframe.dimens frame))))))))

(define tex-def-char
  (lambda (char argpat expansion frame)
    (unless frame (set! frame (top-texframe)))
    (let ((d (ensure-cdef char frame)))
      (set!cdef.argpat d argpat)
      (set!cdef.expansion d expansion)
      (set!cdef.active d #t))))

(define ensure-cdef
  (lambda (c f)
    (let ((x (assoc c (texframe.chardefinitions f))))
      (if x
        (cdr x)
        (let ((d (make-cdef)))
          (set!texframe.chardefinitions
            f
            (cons (cons c d) (texframe.chardefinitions f)))
          d)))))

(define find-chardef
  (lambda (c)
    (let ((x
           (or (ormap
                (lambda (f) (assoc c (texframe.chardefinitions f)))
                *tex-env*)
               (assoc c (texframe.chardefinitions *global-texframe*))
               (assoc c (texframe.chardefinitions *primitive-texframe*)))))
      (and x (let ((d (cdr x))) (and (cdef.active d) d))))))

(define find-chardef-in-top-frame
  (lambda (c)
    (let ((x
           (if (null? *tex-env*)
             (or (assoc c (texframe.chardefinitions *global-texframe*))
                 (assoc c (texframe.chardefinitions *primitive-texframe*)))
             (assoc c (texframe.chardefinitions (car *tex-env*))))))
      (and x (let ((d (cdr x))) (and (cdef.active d) d))))))

(define do-defcsactive
  (lambda (global?)
    (ignorespaces)
    (let* ((c (get-ctl-seq))
           (argpat (get-def-arguments c))
           (rhs (ungroup (get-group)))
           (f (and global? *global-texframe*)))
      (tex-def-char (string-ref c 1) argpat rhs f))))

(define activate-cdef
  (lambda (c)
    (cond
     ((find-chardef-in-top-frame c) => (lambda (y) (set!cdef.active y #t)))
     (else
      (let* ((y (find-chardef c)) (d (ensure-cdef c (top-texframe))))
        (when y (kopy-cdef d y))
        (set!cdef.active d #t))))))

(define deactivate-cdef
  (lambda (c)
    (cond
     ((find-chardef-in-top-frame c) => (lambda (y) (set!cdef.active y #f)))
     ((find-chardef c)
      =>
      (lambda (y)
        (let ((d (ensure-cdef c (top-texframe))))
          (kopy-cdef d y)
          (set!cdef.active d #f)))))))

(define do-undefcsactive
  (lambda () (ignorespaces) (deactivate-cdef (string-ref (get-ctl-seq) 1))))

(define do-catcode
  (lambda ()
    (let* ((c (get-tex-char-spec)) (val (begin (get-equal-sign) (get-number))))
      (if (= val 13)
        (activate-cdef c)
        (begin (deactivate-cdef c) (when (= val 0) (set! *esc-char* c)))))))

(define do-global
  (lambda ()
    (ignorespaces)
    (let ((next (get-ctl-seq)))
      (cond
       ((ormap (lambda (z) (string=? next z)) '("\\def" "\\edef")) (do-def #t))
       ((string=? next "\\let") (do-let #t))
       ((string=? next "\\newcount") (do-newcount #t))
       ((string=? next "\\newtoks") (do-newtoks #t))
       ((string=? next "\\newdimen") (do-newdimen #t))
       ((string=? next "\\advance") (do-advance #t))
       ((string=? next "\\multiply") (do-multiply #t))
       ((string=? next "\\divide") (do-divide #t))
       ((string=? next "\\read") (do-read #t))
       ((ormap (lambda (z) (string=? next z)) '("\\imgdef" "\\gifdef"))
        (make-reusable-img #t))
       ((find-count next) (do-count= next #t))
       ((find-toks next) (do-toks= next #t))
       (else (toss-back-string next))))))

(define do-externaltitle
  (lambda ()
    (write-aux `(!preferred-title ,(tex-string->html-string (get-group))))))

(define tex2page-string
  (lambda (s) (call-with-input-string/buffered s (lambda () (generate-html)))))

(define make-external-title
  (lambda (title)
    (fluid-let
      ((*outputting-external-title?* #t))
      (bgroup)
      (let ((s
             (tex-string->html-string
               (string-append
                 "\\let\\\\\\ignorespaces"
                 "\\def\\resizebox#1#2#3{}"
                 "\\let\\thanks\\TIIPgobblegroup"
                 "\\let\\urlh\\TIIPgobblegroup "
                 title))))
        (egroup)
        s))))

(define output-external-title
  (lambda ()
    (fluid-let
      ((*outputting-external-title?* #t))
      (emit "<title>")
      (emit-newline)
      (emit (or *title* *jobname*))
      (emit-newline)
      (emit "</title>")
      (emit-newline))))

(define output-title
  (lambda (title)
    (emit "<h1 class=title align=center><br><br>")
    (bgroup)
    (tex2page-string (string-append "\\let\\\\\\break " title))
    (egroup)
    (emit "</h1>")
    (emit-newline)))

(define do-subject
  (lambda ()
    (do-end-para)
    (let ((title (get-group)))
      (unless *title* (flag-missing-piece 'document-title))
      (write-aux `(!default-title ,(make-external-title title)))
      (output-title title))))

(define do-latex-title
  (lambda ()
    (let ((title (get-group)))
      (unless *title* (flag-missing-piece 'document-title))
      (write-aux `(!default-title ,(make-external-title title)))
      (toss-back-string title)
      (toss-back-string "\\def\\TIIPtitle"))))

(define do-title
  (lambda () ((if (eqv? *tex-format* 'latex) do-latex-title do-subject))))

(define do-author (lambda () (toss-back-string "\\def\\TIIPauthor")))

(define do-date (lambda () (toss-back-string "\\def\\TIIPdate")))

(define do-today
  (lambda ()
    (let ((m (get-gcount "\\month")))
      (if (= m 0)
        (emit "[today]")
        (begin
          (emit (vector-ref *month-names* (- m 1)))
          (emit " ")
          (emit (get-gcount "\\day"))
          (emit ", ")
          (emit (get-gcount "\\year")))))))

(define add-afterpar (lambda (ap) (set! *afterpar* (cons ap *afterpar*))))

(define do-end-para
  (lambda ()
    (when *in-para?*
      (when *use-closing-p-tag?* (emit "</p>"))
      (unless (null? *afterpar*)
        (for-each (lambda (ap) (ap)) (reverse! *afterpar*))
        (set! *afterpar* '()))
      (emit-newline)
      (set! *in-para?* #f))))

(define do-para
  (lambda ()
    (do-end-para)
    (let ((in-table?
            (and (not (null? *tabular-stack*))
                 (memv (car *tabular-stack*) '(block)))))
      (when in-table? (emit "</td></tr><tr><td>") (emit-newline))
      (emit "<p>")
      (set! *in-para?* #t))))

(define do-maketitle
  (lambda ()
    (do-end-para)
    (bgroup)
    (tex2page-string
      (string-append
        "\\let\\\\\\break"
        "\\let\\and\\break"
        "\\let\\thanks\\symfootnote"))
    (output-title "\\TIIPtitle")
    (do-para)
    (do-end-para)
    (emit "<div align=center>")
    (emit-newline)
    (tex2page-string "\\TIIPauthor")
    (do-para)
    (tex2page-string "\\TIIPdate")
    (do-end-para)
    (emit "</div>")
    (emit-newline)
    (egroup)
    (do-para)))

(define do-html-stylesheet
  (lambda ()
    (when (null? *stylesheets*) (flag-missing-piece 'stylesheets))
    (write-aux `(!stylesheet ,(ungroup (get-group))))))

(define do-inputcss
  (lambda ()
    (ignorespaces)
    (let ((f (get-filename-possibly-braced)))
      (when (null? *stylesheets*) (flag-missing-piece 'stylesheets))
      (write-aux `(!stylesheet ,f)))))

(define do-csname
  (lambda ()
    (ignorespaces)
    (let loop ((r '()))
      (let ((c (snoop-actual-char)))
        (cond
         ((char=? c *esc-char*)
          (let ((x (get-ctl-seq)))
            (cond
             ((string=? x "\\endcsname")
              (toss-back-char *invisible-space*)
              (for-each toss-back-string r)
              (toss-back-char *esc-char*))
             (else (loop (cons (expand-ctl-seq-into-string x) r))))))
         (else (get-actual-char) (loop (cons (string c) r))))))))

(define do-cssblock
  (lambda ()
    (fluid-let
      ((*dumping-nontex?* #t))
      (dump-till-end-env "cssblock" *css-port*))))

(define link-stylesheets
  (lambda ()
    (for-each
      (lambda (css)
        (emit "<link rel=\"stylesheet\" type=\"text/css\" href=\"")
        (emit css)
        (emit "\" title=default>")
        (emit-newline))
      *stylesheets*)
    (emit "<link rel=\"stylesheet\" type=\"text/css\" href=\"")
    (emit *jobname*)
    (emit *css-file-suffix*)
    (emit "\" title=default>")
    (emit-newline)))

(define increment-section-counter
  (lambda (seclvl unnumbered?)
    (unless unnumbered?
      (hash-table-put!
        *section-counters*
        seclvl
        (+ 1 (table-get *section-counters* seclvl 0))))
    (hash-table-for-each
      *section-counters*
      (lambda (k v)
        (if (and (> k seclvl) (> k 0))
          (hash-table-put! *section-counters* k 0))))
    (for-each
      (lambda (counter-name)
        (set!counter.value (table-get *dotted-counters* counter-name) 0))
      (table-get *section-counter-dependencies* seclvl '()))))

(define section-counter-value
  (lambda (seclvl)
    (if (= seclvl -1)
      (number->roman (table-get *section-counters* -1) #t)
      (let ((i (if *using-chapters?* 0 1)))
        (let ((outermost-secnum
                (let ((n (table-get *section-counters* i 0)))
                  (if *inside-appendix?*
                    (string (integer->char (+ (char->integer #\A) -1 n)))
                    (number->string n)))))
          (let loop ((i (+ i 1)) (r outermost-secnum))
            (if (> i seclvl)
              r
              (loop
               (+ i 1)
               (string-append
                 r
                 "."
                 (number->string (table-get *section-counters* i 0)))))))))))

(define section-ctl-seq?
  (lambda (s)
    (cond
     ((string=? s "\\sectiond") (string->number (ungroup (get-token))))
     ((string=? s "\\part") -1)
     ((string=? s "\\chapter")
      (!using-chapters)
      (write-aux `(!using-chapters))
      (if (and (eqv? *tex-format* 'latex) (< (get-gcount "\\secnumdepth") -1))
        (set-gcount! "\\secnumdepth" 2))
      0)
     (else
      (let ((n (string-length s)))
        (cond
         ((< n 8) #f)
         ((and (>= n 10) (string=? (substring s (- n 9) n) "paragraph"))
          (let ((n-9 (- n 9)))
            (let loop ((i 1) (i+3 4) (k 4))
              (cond
               ((> i+3 n-9) k)
               ((string=? (substring s i i+3) "sub")
                (loop i+3 (+ i+3 3) (+ k 1)))
               (else #f)))))
         ((string=? (substring s (- n 7) n) "section")
          (let ((n-7 (- n 7)))
            (let loop ((i 1) (i+3 4) (k 1))
              (cond
               ((> i+3 n-7) k)
               ((string=? (substring s i i+3) "sub")
                (loop i+3 (+ i+3 3) (+ k 1)))
               (else #f)))))
         (else #f)))))))

(define do-heading
  (lambda (seclvl)
    (let* ((starred?
             (cond
              ((char=? (snoop-actual-char) #\*) (get-actual-char) #t)
              (else #f)))
           (too-deep?
             (let ((secnumdepth (get-gcount "\\secnumdepth")))
               (cond
                ((< secnumdepth -1) #f)
                ((> seclvl secnumdepth) #t)
                (else #f))))
           (unnumbered? (or starred? too-deep?)))
      (if (<= seclvl 0) (do-eject))
      (increment-section-counter seclvl unnumbered?)
      (let* ((htmlnum
               (max 1 (min 6 (if *using-chapters?* (+ seclvl 1) seclvl))))
             (header (get-group))
             (lbl-val (if unnumbered? "IGNORE" (section-counter-value seclvl)))
             (lbl
              (string-append
                *html-node-prefix*
                (case seclvl ((-1) "part") ((0) "chap") (else "sec"))
                "_"
                (if unnumbered? (gen-temp-string) lbl-val))))
        (unless unnumbered?
          (tex-def-toks "\\TIIPrecentlabelname" lbl #f)
          (tex-def-toks "\\TIIPrecentlabelvalue" lbl-val #f))
        (do-end-para)
        (emit-anchor lbl)
        (emit-newline)
        (ignore-all-whitespace)
        (emit "<h")
        (emit htmlnum)
        (case seclvl
          ((-1) (emit " class=part align=center"))
          ((0) (emit " class=chapter")))
        (emit ">")
        (let ((write-to-toc?
                (and *toc-page*
                     (not
                      (and (eqv? *tex-format* 'latex)
                           (string=? header "{Contents}"))))))
          (case seclvl
            ((-1)
             (emit "<div class=partheading>")
             (if unnumbered?
               (emit-nbsp 1)
               (begin
                 (when write-to-toc?
                   (emit-page-node-link-start
                     *toc-page*
                     (string-append *html-node-prefix* "toc_" lbl)))
                 (tex2page-string "\\partname")
                 (emit " ")
                 (emit lbl-val)
                 (when write-to-toc? (emit-link-stop))))
             (emit "</div><br>")
             (emit-newline))
            ((0)
             (emit-newline)
             (emit "<div class=chapterheading>")
             (if unnumbered?
               (emit-nbsp 1)
               (begin
                 (when write-to-toc?
                   (emit-page-node-link-start
                     *toc-page*
                     (string-append *html-node-prefix* "toc_" lbl)))
                 (tex2page-string
                   (if *inside-appendix?* "\\appendixname" "\\chaptername"))
                 (emit " ")
                 (emit lbl-val)
                 (when write-to-toc? (emit-link-stop))))
             (emit "</div><br>")
             (emit-newline)))
          (when write-to-toc?
            (emit-page-node-link-start
              *toc-page*
              (string-append *html-node-prefix* "toc_" lbl)))
          (unless (or (<= seclvl 0) unnumbered?) (emit lbl-val) (emit-nbsp 2))
          (fluid-let
            ((*tabular-stack* (list 'header)))
            (tex2page-string header))
          (when write-to-toc? (emit-link-stop))
          (emit "</h")
          (emit htmlnum)
          (emit ">")
          (emit-newline)
          (do-para)
          (let ((tocdepth (get-gcount "\\tocdepth")))
            (when (and
                   write-to-toc?
                   (not (and (eqv? *tex-format* 'latex) starred?))
                   (or (< tocdepth -1) (<= seclvl tocdepth)))
              (write-aux
                `(!toc-entry
                   ,(if (= seclvl -1)
                      -1
                      (if *using-chapters?* seclvl (- seclvl 1)))
                   ,lbl-val
                   ,*html-page-count*
                   ,lbl
                   ,header)))))
        (when *recent-node-name*
          (do-label-aux *recent-node-name*)
          (set! *recent-node-name* #f))))))

(define do-documentclass
  (lambda ()
    (probably-latex)
    (get-bracketed-text-if-any)
    (let ((x (get-peeled-group)))
      (when (ormap (lambda (z) (string=? x z)) '("report" "book"))
        (!using-chapters)
        (write-aux `(!using-chapters))))))

(define do-beginsection
  (lambda ()
    (ignorespaces)
    (let ((header
            (let loop ((r '()) (newline? #f))
              (let ((c (get-actual-char)))
                (cond
                 ((or (eof-object? c) (and newline? (char=? c #\newline)))
                  (list->string (reverse! r)))
                 (else
                  (loop
                   (cons c r)
                   (if newline?
                     (char-whitespace? c)
                     (char=? c #\newline)))))))))
      (do-end-para)
      (emit "<h1 class=beginsection>")
      (bgroup)
      (fluid-let ((*tabular-stack* (list 'header))) (tex2page-string header))
      (egroup)
      (emit "</h1>")
      (emit-newline))))

(define do-appendix
  (lambda ()
    (unless *inside-appendix?*
      (set! *inside-appendix?* #t)
      (hash-table-put! *section-counters* (if *using-chapters?* 0 1) 0))))

(define do-table-plain
  (lambda () (do-end-para) (emit "<table width=100%><tr><td>")))

(define do-end-table-plain
  (lambda () (do-end-para) (emit "</td></tr></table>")))

(define do-table/figure
  (lambda (type)
    (do-end-para)
    (bgroup)
    (when (and (eqv? type 'figure) (char=? (snoop-actual-char) #\*))
      (get-actual-char))
    (set! *tabular-stack* (cons type *tabular-stack*))
    (get-bracketed-text-if-any)
    (let ((tbl-tag
            (string-append
              *html-node-prefix*
              (if (eqv? type 'table) "tbl_" "fig_")
              (gen-temp-string))))
      (tex-def-toks "\\TIIPrecentlabelname" tbl-tag #f)
      (emit-anchor tbl-tag)
      (emit-newline)
      (emit "<div class=")
      (emit type)
      (emit " align=")
      (emit *display-justification*)
      (emit "><table width=100%><tr><td align=")
      (emit *display-justification*)
      (emit ">"))))

(define pop-tabular-stack
  (lambda (type)
    (if (null? *tabular-stack*)
      (terror 'pop-tabular-stack "Bad environment closer: " type)
      (set! *tabular-stack* (cdr *tabular-stack*)))))

(define do-end-table/figure
  (lambda (type)
    (when (and (eqv? type 'figure) (char=? (snoop-actual-char) #\*))
      (get-actual-char))
    (do-end-para)
    (emit "</td></tr>")
    (emit "</table>")
    (emit "</div>")
    (pop-tabular-stack type)
    (egroup)
    (do-para)))

(define bump-dotted-counter
  (lambda (name)
    (let* ((counter (table-get *dotted-counters* name))
           (new-value (+ 1 (counter.value counter))))
      (set!counter.value counter new-value)
      (let ((num
             (string-append
               (cond
                ((counter.within counter)
                 =>
                 (lambda (sec-num)
                   (string-append (section-counter-value sec-num) ".")))
                (else ""))
               (number->string new-value))))
        (tex-def-toks "\\TIIPrecentlabelvalue" num #f)
        num))))

(define do-caption
  (lambda ()
    (do-end-para)
    (let* ((i-fig (list-index *tabular-stack* 'figure))
           (i-tbl (list-index *tabular-stack* 'table))
           (type
            (cond
             ((and (not i-fig) (not i-tbl))
              (terror 'do-caption "Mislaid \\caption"))
             ((not i-fig) 'table)
             ((not i-tbl) 'figure)
             ((< i-fig i-tbl) 'figure)
             ((< i-tbl i-fig) 'table)
             (else (terror 'do-caption "cant happen"))))
           (counter-name (if (eqv? type 'table) "table" "figure"))
           (caption-title (if (eqv? type 'table) "\\tablename" "\\figurename"))
           (num (bump-dotted-counter counter-name)))
      (get-bracketed-text-if-any)
      (emit "</td></tr>")
      (emit-newline)
      (emit "<tr><td align=")
      (emit *display-justification*)
      (emit "><b>")
      (tex2page-string caption-title)
      (emit " ")
      (emit num)
      (emit ":</b>")
      (emit-nbsp 2)
      (tex2page-string (get-group))
      (emit "</td></tr>")
      (emit-newline)
      (emit "<tr><td>"))))

(define do-marginpar
  (lambda ()
    (get-bracketed-text-if-any)
    (emit "<table align=left border=2><tr><td>")
    (tex2page-string (get-group))
    (emit "</td></tr></table>")))

(define do-minipage
  (lambda ()
    (get-bracketed-text-if-any)
    (get-group)
    (let ((in-table?
            (and (not (null? *tabular-stack*))
                 (memv (car *tabular-stack*) '(block figure table)))))
      (if in-table? (emit "</td><td>") (begin (do-para) (do-end-para)))
      (emit "<div align=left>")
      (set! *tabular-stack* (cons 'minipage *tabular-stack*)))))

(define do-endminipage
  (lambda ()
    (pop-tabular-stack 'minipage)
    (let ((in-table?
            (and (not (null? *tabular-stack*))
                 (memv (car *tabular-stack*) '(block figure table)))))
      (emit "</div>")
      (if in-table? (emit "</td><td>") (do-para)))))

(define do-tabbing
  (lambda () (set! *tabular-stack* (cons 'tabbing *tabular-stack*)) (do-para)))

(define do-end-tabbing (lambda () (pop-tabular-stack 'tabbing) (do-para)))

(define do-equation
  (lambda (type)
    (cond
     (*use-image-for-displayed-math?*
      (do-latex-env-as-image
        (if (eqv? type 'equation) "equation" "eqnarray")
        'display))
     (else
      (do-end-para)
      (bgroup)
      (when (and (eqv? type 'eqnarray) (eat-star)) (set! type 'eqnarray*))
      (set! *tabular-stack* (cons type *tabular-stack*))
      (set! *math-mode?* #t)
      (set! *in-display-math?* #t)
      (let ((eqn-tag
              (string-append *html-node-prefix* "eqn_" (gen-temp-string))))
        (tex-def-toks "\\TIIPrecentlabelname" eqn-tag #f)
        (emit-anchor eqn-tag)
        (emit-newline)
        (unless (eqv? type 'eqnarray*)
          (set! *equation-number* (bump-dotted-counter "equation")))
        (emit "<div align=")
        (emit *display-justification*)
        (emit "><table width=100%>")
        (emit-newline)
        (emit "<tr><td align=")
        (emit (if (eqv? type 'equation) "center" "right"))
        (emit ">"))))))

(define do-end-equation
  (lambda ()
    (do-end-para)
    (emit "</td>")
    (unless (or
             (and (not (null? *tabular-stack*))
                  (eqv? (car *tabular-stack*) 'eqnarray*))
             (not *equation-numbered?*))
      (emit "<td>(")
      (emit *equation-number*)
      (emit ")</td>"))
    (emit "</tr>")
    (emit-newline)
    (emit "</table></div>")
    (pop-tabular-stack 'equation)
    (set! *math-mode?* #f)
    (set! *in-display-math?* #f)
    (egroup)
    (set! *equation-numbered?* #t)
    (set! *equation-position* 0)
    (do-para)))

(define do-eqnarray
  (lambda ()
    (do-end-para)
    (bgroup)
    (let ((star? (eat-star)))
      (set! *tabular-stack*
        (cons (if star? 'eqnarray* 'eqnarray) *tabular-stack*))
      (set! *math-mode?* #t)
      (let ((eqn-tag
              (string-append *html-node-prefix* "eqn_" (gen-temp-string))))
        (tex-def-toks "\\TIIPrecentlabelname" eqn-tag #f)
        (emit-anchor eqn-tag)
        (emit-newline)
        (emit "<div align=")
        (emit *display-justification*)
        (emit "><table width=100%>")
        (emit-newline)
        (emit "<tr><td align=right>")))))

(define do-nonumber (lambda () (set! *equation-numbered?* #f)))

(define indent-n-levels
  (lambda (n)
    (let loop ((i -1))
      (unless (>= i n)
        (emit-nbsp 1)
        (emit " ")
        (emit-nbsp 1)
        (emit " ")
        (loop (+ i 1))))))

(define do-toc
  (lambda ()
    (fluid-let
      ((*subjobname* (string-append *jobname* *toc-file-suffix*))
       (*img-file-count* 0)
       (*imgdef-file-count* 0))
      (when (eqv? *tex-format* 'latex)
        (tex2page-string
          (if *using-chapters?*
            "\\chapter*{\\contentsname}"
            "\\section*{\\contentsname}")))
      (emit-anchor (string-append *html-node-prefix* "toc_start"))
      (!toc-page *html-page-count*)
      (write-aux `(!toc-page ,*html-page-count*))
      (cond
       ((null? *toc-list*)
        (flag-missing-piece 'toc)
        (non-fatal-error "Table of contents not generated; rerun TeX2page"))
       (else
        (let ((tocdepth (get-gcount "\\tocdepth")))
          (for-each
            (lambda (x)
              (let* ((lvl (tocentry.level x))
                     (secnum (tocentry.number x))
                     (seclabel (tocentry.label x))
                     (subentries?
                       (or (= lvl -1)
                           (and (= lvl 0)
                                (or (< tocdepth -1)
                                    (and *using-chapters?* (> tocdepth 0))
                                    (and (not *using-chapters?*)
                                         (> tocdepth 1)))))))
                (when subentries? (do-para) (emit "<b>") (emit-newline))
                (indent-n-levels lvl)
                (emit-anchor
                  (string-append *html-node-prefix* "toc_" seclabel))
                (emit-page-node-link-start (tocentry.page x) seclabel)
                (unless (string=? secnum "IGNORE") (emit secnum) (emit-nbsp 2))
                (fluid-let
                  ((*tabular-stack* (list 'header)))
                  (tex2page-string (tocentry.header x)))
                (emit-link-stop)
                (when subentries? (emit "</b>"))
                (emit "<br>")
                (emit-newline)))
            *toc-list*)))))))

(defstruct footnotev mark text tag caller)

(define do-numbered-footnote
  (lambda ()
    (let ((num (+ (get-gcount "\\footnotenumber") 1)))
      (set-gcount! "\\footnotenumber" num)
      (let ((s (number->string num))) (do-footnote-aux s)))))

(define do-symfootnote
  (lambda ()
    (set! *footnote-sym* (+ *footnote-sym* 1))
    (do-footnote-aux (number->footnote-symbol *footnote-sym*))))

(define number->footnote-symbol
  (lambda (n)
    (list-ref
      '("*"
        "\\dag"
        "\\ddag"
        "\\S"
        "\\P"
        "\\Vert"
        "**"
        "\\dag\\dag"
        "\\ddag\\ddag")
      (modulo (- n 1) 9))))

(define do-plain-footnote
  (lambda () (let ((fnmark (get-token))) (do-footnote-aux fnmark))))

(define do-footnote
  (lambda ()
    ((if (eqv? *tex-format* 'latex) do-numbered-footnote do-plain-footnote))))

(define do-footnote-aux
  (lambda (fnmark)
    (let* ((fnlabel (gen-temp-string))
           (fntag (string-append "footnote_" fnlabel))
           (fncalltag (string-append "call_footnote_" fnlabel))
           (fn-tmp-port (open-output-string)))
      (emit-anchor fncalltag)
      (emit-page-node-link-start #f fntag)
      (emit "<sup><small>")
      (tex2page-string fnmark)
      (emit "</small></sup>")
      (emit-link-stop)
      (ignorespaces)
      (unless (char=? (get-actual-char) #\{)
        (terror 'do-footnote-aux "Missing {"))
      (bgroup)
      (let ((old-html *html*))
        (set! *html* fn-tmp-port)
        (tex-def-toks "\\TIIPrecentlabelname" fntag #f)
        (tex-def-toks "\\TIIPrecentlabelvalue" fnmark #f)
        (add-aftergroup-to-top-frame
          (lambda ()
            (set! *footnote-list*
              (cons
               (make-footnotev
                 'mark
                 fnmark
                 'text
                 (get-output-string fn-tmp-port)
                 'tag
                 fntag
                 'caller
                 fncalltag)
               *footnote-list*))
            (set! *html* old-html)))))))

(define output-footnotes
  (lambda ()
    (let ((n (length *footnote-list*)))
      (unless (= n 0)
        (do-end-para)
        (emit "<div class=footnoterule><hr></div>")
        (do-para)
        (do-end-para)
        (emit "<div class=footnote>")
        (let loop ((i (- n 1)))
          (unless (< i 0)
            (let ((fv (list-ref *footnote-list* i)))
              (do-para)
              (emit-anchor (footnotev.tag fv))
              (emit-page-node-link-start #f (footnotev.caller fv))
              (emit "<sup><small>")
              (tex2page-string (footnotev.mark fv))
              (emit "</small></sup>")
              (emit-link-stop)
              (emit " ")
              (emit (footnotev.text fv))
              (do-end-para)
              (loop (- i 1)))))
        (emit "</div>")
        (emit-newline)))))

(define rgb.dec->hex
  (let ((f
         (lambda (x)
           (let* ((n (inexact->exact (round (* 1.0 x))))
                  (s (number->string n 16)))
             (if (< n 16) (string-append "0" s) s)))))
    (lambda (r g b) (string-append (f r) (f g) (f b)))))

(define rgb.frac->hex
  (lambda (r g b) (rgb.dec->hex (* r 255) (* g 255) (* b 255))))

(define cmyk->rgb
  (let ((f (lambda (x k) (- 1 (min (max (+ x k) 0) 1)))))
    (lambda (c m y k) (rgb.frac->hex (f c k) (f m k) (f y k)))))

(define do-color
  (lambda ()
    (let ((model (get-bracketed-text-if-any)))
      (do-switch
        (cond
         ((not model) 'colornamed)
         ((string=? model "rgb") 'rgb)
         ((string=? model "RGB") 'rgb255)
         ((string=? model "cmyk") 'cmyk)
         ((string=? model "gray") 'gray)
         (else 'colornamed))))))

(define do-definecolor
  (lambda ()
    (let* ((name (get-peeled-group))
           (model (get-peeled-group))
           (spec (get-peeled-group)))
      (bgroup)
      (set! *color-names*
        (cons
         (cons
          name
          (if (string=? model "named")
            (let ((c (lassoc name *color-names* string=?)))
              (if c
                (cdr c)
                (terror 'do-definecolor "Color name " name " not defined")))
            (let ((rgb #f))
              (call-with-input-string
                (tex-string->html-string
                  (string-append "\\defcsactive\\,{ }" spec))
                (lambda (i)
                  (cond
                   ((string=? model "cmyk")
                    (let* ((c (read i)) (m (read i)) (y (read i)) (k (read i)))
                      (cmyk->rgb c m y k)))
                   ((string=? model "rgb")
                    (let* ((r (read i)) (g (read i)) (b (read i)))
                      (rgb.frac->hex r g b)))
                   ((string=? model "gray") (cmyk->rgb 0 0 0 (read i)))
                   (else (terror 'do-definecolor "Unknown color model"))))))))
         *color-names*))
      (egroup))))

(define do-switch
  (lambda (sw)
    (ignorespaces)
    (unless *outputting-external-title?*
      (add-postlude-to-top-frame
        (case sw
          ((rm)
           (when *math-mode?*
             (let ((old-math-roman-mode? *math-roman-mode?*))
               (set! *math-roman-mode?* #t)
               (lambda () (set! *math-roman-mode?* old-math-roman-mode?)))))
          ((em) (emit "<em>") (lambda () (emit "</em>")))
          ((it itshape sl) (emit "<i>") (lambda () (emit "</i>")))
          ((bf strong) (emit "<strong>") (lambda () (emit "</strong>")))
          ((tt)
           (let ((old-ligatures? *ligatures?*))
             (set! *ligatures?* #f)
             (emit "<tt>")
             (lambda () (emit "</tt>") (set! *ligatures?* old-ligatures?))))
          ((sc scshape)
           (let ((old-in-small-caps? *in-small-caps?*))
             (set! *in-small-caps?* #t)
             (lambda () (set! *in-small-caps?* old-in-small-caps?))))
          ((tiny) (emit "<span class=tiny>") (lambda () (emit "</span>")))
          ((scriptsize)
           (emit "<span class=scriptsize>")
           (lambda () (emit "</span>")))
          ((footnotesize fiverm)
           (emit "<span class=footnotesize>")
           (lambda () (emit "</span>")))
          ((small sevenrm)
           (emit "<span class=small>")
           (lambda () (emit "</span>")))
          ((normalsize)
           (emit "<span class=normalsize>")
           (lambda () (emit "</span>")))
          ((large) (emit "<span class=large>") (lambda () (emit "</span>")))
          ((large-cap)
           (emit "<span class=largecap>")
           (lambda () (emit "</span>")))
          ((large-up)
           (emit "<span class=largeup>")
           (lambda () (emit "</span>")))
          ((huge) (emit "<span class=huge>") (lambda () (emit "</span>")))
          ((huge-cap)
           (emit "<span class=hugecap>")
           (lambda () (emit "</span>")))
          ((cmyk)
           (bgroup)
           (call-with-input-string
             (tex-string->html-string
               (string-append "\\defcsactive\\,{}" (get-token)))
             (lambda (i)
               (let* ((c (read i)) (m (read i)) (y (read i)) (k (read i)))
                 (ignorespaces)
                 (emit "<font color=\"#")
                 (emit (cmyk->rgb c m y k))
                 (emit "\">"))))
           (egroup)
           (lambda () (emit "</font>")))
          ((rgb)
           (bgroup)
           (call-with-input-string
             (tex-string->html-string
               (string-append "\\defcsactive\\,{}" (get-token)))
             (lambda (i)
               (let* ((r (read i)) (g (read i)) (b (read i)))
                 (ignorespaces)
                 (emit "<font color=\"#")
                 (emit (rgb.frac->hex r g b))
                 (emit "\">"))))
           (egroup)
           (lambda () (emit "</font>")))
          ((rgb255)
           (bgroup)
           (call-with-input-string
             (tex-string->html-string
               (string-append "\\defcsactive\\,{}" (get-token)))
             (lambda (i)
               (let* ((r (read i)) (g (read i)) (b (read i)))
                 (ignorespaces)
                 (emit "<font color=\"#")
                 (emit (rgb.dec->hex r g b))
                 (emit "\">"))))
           (egroup)
           (lambda () (emit "</font>")))
          ((gray)
           (call-with-input-string
             (tex-string->html-string (get-token))
             (lambda (i)
               (let ((g (read i)))
                 (ignorespaces)
                 (emit "<font color=\"#")
                 (emit (cmyk->rgb 0 0 0 (- 1 g)))
                 (emit "\">"))))
           (lambda () (emit "</font>")))
          ((colornamed)
           (let* ((name (get-peeled-group))
                  (c (lassoc name *color-names* string=?)))
             (ignorespaces)
             (emit "<font color=\"")
             (emit (if c (begin (emit #\#) (cdr c)) name))
             (emit "\">")
             (lambda () (emit "</font>"))))
          ((bgcolor)
           (emit "<font style=\"background-color: ")
           (let ((color (ungroup (get-group))))
             (if (string->number color 16) (emit "#"))
             (emit color)
             (emit "\">")
             (lambda () (emit "</font>"))))
          ((strike) (emit "<strike>") (lambda () (emit "</strike>")))
          ((narrower) (emit "<blockquote>") (lambda () (emit "</blockquote>")))
          ((raggedleft)
           (do-end-para)
           (emit "<div align=right>")
           (lambda () (do-end-para) (emit "</div>") (do-para)))
          (else (terror 'do-switch "Unknown switch " sw)))))))

(define do-obeylines
  (lambda ()
    (if (eqv? (snoop-actual-char) #\newline) (get-actual-char))
    (tex-def-char #\newline '() "\\TIIPbr" #f)))

(define do-obeyspaces (lambda () (tex-def-char #\space '() "\\TIIPnbsp" #f)))

(define do-obeywhitespace (lambda () (do-obeylines) (do-obeyspaces)))

(define do-block
  (lambda (z)
    (do-end-para)
    (emit "<div ")
    (emit
     (case z
       ((flushleft) "align=left")
       ((flushright) "align=right")
       (else "align=center")))
    (emit ">")
    (set! *tabular-stack* (cons 'block *tabular-stack*))
    (emit "<table><tr><td>")
    (bgroup)
    (emit-newline)))

(define do-end-block
  (lambda ()
    (do-end-para)
    (egroup)
    (emit "</td></tr></table></div>")
    (pop-tabular-stack 'block)
    (emit-newline)))

(define do-function
  (lambda (fn)
    (fluid-let
      ((*math-mode?* *math-mode?*))
      (cond
       (*outputting-external-title?* #f)
       ((string=? fn "\\emph") (emit "<em>"))
       ((string=? fn "\\leftline") (do-end-para) (emit "<div align=left>"))
       ((string=? fn "\\centerline")
        (do-end-para)
        (emit "<div align=center>&nbsp;"))
       ((string=? fn "\\rightline")
        (do-end-para)
        (emit "<div align=right>&nbsp;"))
       ((string=? fn "\\underline") (emit "<u>"))
       ((string=? fn "\\textbf") (set! *math-mode?* #f) (emit "<b>"))
       ((ormap (lambda (z) (string=? fn z)) '("\\textit" "\\textsl"))
        (set! *math-mode?* #f)
        (emit "<i>"))
       ((string=? fn "\\textrm") (set! *math-mode?* #f))
       ((string=? fn "\\texttt") (set! *math-mode?* #f) (emit "<tt>"))
       (else (terror 'do-function "Unknown function " fn)))
      (bgroup)
      (tex2page-string (get-token))
      (egroup)
      (cond
       (*outputting-external-title?* #f)
       ((string=? fn "\\emph") (emit "</em>"))
       ((string=? fn "\\rightline") (emit "</div>") (emit-newline))
       ((ormap (lambda (z) (string=? fn z)) '("\\leftline" "\\centerline"))
        (do-end-para)
        (emit "&nbsp;</div>")
        (emit-newline))
       ((string=? fn "\\underline") (emit "</u>"))
       ((string=? fn "\\textbf") (emit "</b>"))
       ((ormap (lambda (z) (string=? fn z)) '("\\textsl" "\\textit"))
        (emit "</i>"))
       ((string=? fn "\\texttt") (emit "</tt>"))))))

(define do-discretionary
  (lambda () (tex2page-string (get-group)) (get-group) (get-group)))

(define do-aftergroup
  (lambda ()
    (ignorespaces)
    (let ((z (get-ctl-seq)))
      (add-aftergroup-to-top-frame (lambda () (toss-back-string z))))))

(define do-space (lambda () (emit #\space)))

(define do-tab (lambda () (emit-nbsp 8)))

(define emit-nbsp
  (lambda (n)
    (let loop ((n n)) (unless (<= n 0) (emit "&nbsp;") (loop (- n 1))))))

(define get-pixels
  (lambda ()
    (let ((n (or (get-real) 1)))
      (ignorespaces)
      (inexact->exact
        (floor
         (*
          n
          1.0
          (if (char=? (snoop-actual-char) *esc-char*)
            (let ((x (get-ctl-seq))) (* 6.5 72.27))
            (let loop ()
              (cond
               ((eat-word "bp") (* (/ 72) 72.27))
               ((eat-word "cc") (* 12 1238 (/ 1157)))
               ((eat-word "cm") (* (/ 2.54) 72.27))
               ((eat-word "dd") (/ 1238 1157))
               ((eat-word "in") 72.27)
               ((eat-word "mm") (* 0.1 (/ 2.54) 72.27))
               ((eat-word "pc") 12)
               ((eat-word "pt") 1)
               ((eat-word "sp") (/ 65536))
               ((eat-word "true") (loop))
               (else 1))))))))))

(define do-hskip (lambda () (emit-nbsp (/ (get-pixels) 5))))

(define do-newline
  (lambda () (when (>= (munch-newlines) 1) (do-para)) (emit-newline)))

(define do-br
  (lambda ()
    (if (find-chardef #\space)
      (emit "<br>")
      (unless (eqv? (snoop-actual-char) #\newline) (emit "<br>")))
    (emit-newline)))

(define do-sup
  (lambda ()
    (emit "<sup>")
    (fluid-let ((*math-script-mode?* #t)) (tex2page-string (get-token)))
    (emit "</sup>")))

(define do-sub
  (lambda ()
    (emit "<sub>")
    (fluid-let ((*math-script-mode?* #t)) (tex2page-string (get-token)))
    (emit "</sub>")))

(define do-hyphen
  (lambda ()
    (cond
     (*math-mode?*
      (emit
       (cond
        (*math-roman-mode?* "-")
        (*math-script-mode?* "<tt>-</tt>")
        (else " <tt>-</tt> "))))
     ((not *ligatures?*) (emit #\-))
     (else
      (let ((c (snoop-actual-char)))
        (if (and (char? c) (char=? c #\-))
          (begin (get-actual-char) (do-ndash))
          (emit #\-)))))))

(define do-excl
  (lambda ()
    (if (or *math-mode?* (not *ligatures?*))
      (emit #\!)
      (let ((c (snoop-actual-char)))
        (if (and (char? c) (char=? c #\`))
          (begin (get-actual-char) (emit "&iexcl;"))
          (emit #\!))))))

(define do-quest
  (lambda ()
    (if (or *math-mode?* (not *ligatures?*))
      (emit #\?)
      (let ((c (snoop-actual-char)))
        (if (and (char? c) (char=? c #\`))
          (begin (get-actual-char) (emit "&iquest;"))
          (emit #\?))))))

(define do-ndash
  (lambda ()
    (emit
     (let ((c (snoop-actual-char)))
       (if (and (char? c) (char=? c #\-))
         (begin (get-actual-char) *html-mdash*)
         *html-ndash*)))))

(define do-lsquo
  (lambda ()
    (emit
     (if (not *ligatures?*)
       *html-lsquo*
       (let ((c (snoop-actual-char)))
         (if (and (char? c) (char=? c #\`))
           (begin (get-actual-char) *html-ldquo*)
           *html-lsquo*))))))

(define do-rsquo
  (lambda ()
    (emit
     (if (not *ligatures?*)
       *html-rsquo*
       (let ((c (snoop-actual-char)))
         (if (and (char? c) (char=? c #\'))
           (begin (get-actual-char) *html-rdquo*)
           *html-rsquo*))))))

(defstruct label (src #f) page name value)

(define get-label
  (lambda ()
    (let loop ((lbl (get-peeled-group)))
      (let ((i
             (or (string-index lbl #\space)
                 (string-index lbl *tab*)
                 (string-index lbl #\newline))))
        (if (not i)
          lbl
          (let loop ((s (string->list lbl)) (r '()) (ws? #f))
            (if (null? s)
              (list->string (reverse! r))
              (let ((c (car s)))
                (loop
                 (cdr s)
                 (if (char-whitespace? c)
                   (if ws? r (cons #\space r))
                   (cons c r))
                 (char-whitespace? c))))))))))

(define emit-anchor
  (lambda (lbl) (emit "<a name=\"") (emit lbl) (emit "\"></a>")))

(define emit-link-start
  (lambda (link) (emit "<a href=\"") (emit link) (emit "\">")))

(define emit-ext-page-node-link-start
  (lambda (extfile pageno node)
    (emit "<a href=\"")
    (unless (and (not extfile) (or (not pageno) (= *html-page-count* pageno)))
      (emit (or extfile *jobname*))
      (unless (= pageno 0) (emit *html-page-suffix*) (emit pageno))
      (emit *output-extension*))
    (when node (emit "#") (emit node))
    (emit "\">")))

(define emit-page-node-link-start
  (lambda (pageno node) (emit-ext-page-node-link-start #f pageno node)))

(define emit-link-stop (lambda () (emit "</a>")))

(define do-label (lambda () (do-label-aux (get-label))))

(define do-node (lambda () (set! *recent-node-name* (get-peeled-group))))

(define do-label-aux
  (lambda (label)
    (let ((name (get-toks "\\TIIPrecentlabelname"))
          (value (get-toks "\\TIIPrecentlabelvalue")))
      (!label label *html-page-count* name value)
      (write-label `(!label ,label ,*html-page-count* ,name ,value)))))

(define do-inputexternallabels
  (lambda ()
    (let* ((f (get-filename-possibly-braced))
           (fq-f
            (if (fully-qualified-pathname? f) f (string-append *aux-dir/* f)))
           (ext-label-file (string-append fq-f *label-file-suffix* ".scm"))
           (ext-label-table (table-get *external-label-tables* f)))
      (unless ext-label-table
        (set! ext-label-table (make-table 'equ string=?))
        (hash-table-put! *external-label-tables* f ext-label-table))
      (when (file-exists? ext-label-file)
        (fluid-let
          ((*label-source* fq-f) (*label-table* ext-label-table))
          (load-tex2page-data-file ext-label-file))))))

(define do-includeexternallabels
  (lambda ()
    (let ((jobname (get-filename-possibly-braced)))
      (let ((ext-label-file
              (string-append
                (if (fully-qualified-pathname? jobname)
                  jobname
                  (string-append *aux-dir/* jobname))
                *label-file-suffix*
                ".scm")))
        (when (file-exists? ext-label-file)
          (fluid-let
            ((*label-source* jobname))
            (load-tex2page-data-file ext-label-file)))))))

(define do-tag
  (lambda ()
    (let ((tag-name (get-peeled-group))) (do-tag-aux tag-name (get-group)))))

(define do-tag-aux
  (lambda (tag-name tag-val)
    (let ((node-name
            (string-append *html-node-prefix* "tag_" (gen-temp-string))))
      (tex-def-toks "\\TIIPrecentlabelname" node-name #f)
      (tex-def-toks "\\TIIPrecentlabelvalue" tag-val #f)
      (emit-anchor node-name)
      (do-label-aux tag-name))))

(define do-htmlpagelabel
  (lambda ()
    (let ((label (get-peeled-group)))
      (!label label *html-page-count* #f #f)
      (write-label `(!label ,label ,*html-page-count* #f #f)))))

(define do-ref (lambda () (do-ref-aux (get-label) #f #f)))

(define do-refexternal
  (lambda ()
    (let ((ext-file (get-peeled-group)))
      (do-ref-aux (get-label) ext-file #f))))

(define do-ref-aux
  (lambda (label ext-file link-text)
    (let* ((label-ref (label-bound? label ext-file))
           (label-text
             (cond
              (link-text (tex-string->html-string link-text))
              (label-ref (tex-string->html-string (label.value label-ref)))
              (else label))))
      (if label-ref
        (emit-ext-page-node-link-start
          (or ext-file (label.src label-ref))
          (label.page label-ref)
          (label.name label-ref))
        (emit-link-start (string-append *jobname* ".hlog")))
      (emit label-text)
      (emit-link-stop))))

(define maybe-label-page
  (lambda (this-label-src this-label-pageno)
    (if (and (not this-label-src) (= *html-page-count* this-label-pageno))
      "#"
      (string-append
        (or this-label-src *jobname*)
        (if (= this-label-pageno 0)
          ""
          (string-append
            *html-page-suffix*
            (number->string this-label-pageno)))
        *output-extension*))))

(define do-htmlref
  (lambda ()
    (let* ((text (get-group)) (lbl (get-peeled-group)))
      (do-ref-aux lbl #f text))))

(define do-htmlrefexternal
  (lambda ()
    (let* ((text (get-group))
           (extf (get-peeled-group))
           (lbl (get-peeled-group)))
      (do-ref-aux lbl extf text))))

(define do-hyperref
  (lambda ()
    (let* ((text (get-group))
           (lbl (begin (get-group) (get-group) (get-peeled-group))))
      (do-ref-aux lbl #f text))))

(define do-hypertarget
  (lambda () (let ((lbl (get-peeled-group))) (do-tag-aux lbl "hypertarget"))))

(define do-hyperlink
  (lambda ()
    (emit-link-start
      (fully-qualify-url (string-append "#" (get-peeled-group))))
    (tex2page-string (get-token))
    (emit-link-stop)))

(define label-bound?
  (lambda (label . ext-file)
    (let* ((ext-file (if (pair? ext-file) (car ext-file) #f))
           (label-table
             (if ext-file
               (table-get *external-label-tables* ext-file)
               *label-table*)))
      (or (and label-table (table-get label-table label))
          (begin
            (flag-unresolved-xref
              (if ext-file
                (string-append "{" ext-file " -> " label "}")
                label))
            #f)))))

(define flag-unresolved-xref
  (lambda (xr)
    (unless (member xr *unresolved-xrefs*)
      (set! *unresolved-xrefs* (cons xr *unresolved-xrefs*)))))

(define flag-missing-piece
  (lambda (mp)
    (unless (member mp *missing-pieces*)
      (set! *missing-pieces* (cons mp *missing-pieces*)))))

(define show-unresolved-xrefs-and-missing-pieces
  (lambda ()
    (unless (and (null? *unresolved-xrefs*) (null? *missing-pieces*))
      (show-unresolved-xrefs)
      (show-missing-pieces)
      (write-log 'separation-newline)
      (write-log "Rerun: tex2page ")
      (write-log *main-tex-file*)
      (write-log 'separation-newline)
      (write-log "If problem persists, check for ")
      (write-log "missing \\label's and \\bibitem's"))))

(define show-unresolved-xrefs
  (lambda ()
    (unless (null? *unresolved-xrefs*)
      (write-log 'separation-newline)
      (write-log "Unresolved cross-reference")
      (if (> (length *unresolved-xrefs*) 1) (write-log "s"))
      (write-log ": ")
      (set! *unresolved-xrefs* (reverse! *unresolved-xrefs*))
      (write-log (car *unresolved-xrefs*))
      (for-each
        (lambda (x)
          (write-log #\,)
          (write-log 'separation-space)
          (write-log x))
        (cdr *unresolved-xrefs*))
      (write-log 'separation-newline))))

(define show-missing-pieces
  (lambda ()
    (unless (null? *missing-pieces*)
      (write-log 'separation-newline)
      (when (memv 'document-title *missing-pieces*)
        (write-log "Document title not determined")
        (write-log 'separation-newline))
      (when (memv 'last-page *missing-pieces*)
        (write-log "Last page not determined")
        (write-log 'separation-newline))
      (when (memv 'last-modification-time *missing-pieces*)
        (write-log "Last modification time not determined")
        (write-log 'separation-newline))
      (when (memv 'stylesheets *missing-pieces*)
        (write-log "Style sheets not determined")
        (write-log 'separation-newline))
      (when (memv 'html-head *missing-pieces*)
        (write-log "HTML header info not determined")
        (write-log 'separation-newline))
      (when (memv 'toc *missing-pieces*)
        (write-log "Table of contents not determined")
        (write-log 'separation-newline))
      (cond
       ((memv 'fresh-index *missing-pieces*)
        (write-log "Index not refreshed")
        (write-log 'separation-newline))
       ((memv 'index *missing-pieces*)
        (write-log "Index not included")
        (write-log 'separation-newline)))
      (cond
       ((memv 'fresh-bibliography *missing-pieces*)
        (write-log "Bibliography not refreshed")
        (write-log 'separation-newline))
       ((memv 'bibliography *missing-pieces*)
        (write-log "Bibliography not included")
        (write-log 'separation-newline)))
      (when (memv 'metapost *missing-pieces*)
        (write-log "MetaPost output not included")
        (write-log 'separation-newline)))))

(define do-pageref
  (lambda ()
    (let ((label-ref (label-bound? (get-peeled-group))))
      (if label-ref
        (let ((pageno (label.page label-ref)))
          (emit-ext-page-node-link-start (label.src label-ref) pageno #f)
          (emit pageno)
          (emit-link-stop))
        (non-fatal-error "***")))))

(define do-htmlpageref
  (lambda ()
    (let ((label (get-peeled-group)))
      (let ((label-ref (label-bound? label)))
        (emit "\"")
        (if label-ref
          (emit
           (maybe-label-page (label.src label-ref) (label.page label-ref)))
          (emit *log-file*))
        (emit "\"")))))

(define fully-qualify-url
  (lambda (url)
    (let ((n (string-length url)))
      (cond
       ((and (> n 0) (char=? (string-ref url 0) #\#))
        (let* ((label (substring url 1 n)) (label-ref (label-bound? label)))
          (if label-ref
            (string-append
              (maybe-label-page (label.src label-ref) (label.page label-ref))
              "#"
              (label.name label-ref))
            url)))
       ((fully-qualified-url? url) url)
       (else (ensure-url-reachable url) url)))))

(define do-url
  (lambda ()
    (let ((url (get-url)))
      (emit-link-start (fully-qualify-url url))
      (emit url)
      (emit-link-stop))))

(define do-mailto
  (lambda ()
    (let ((addr (get-url)))
      (emit-link-start (string-append "mailto:" addr))
      (emit addr)
      (emit-link-stop))))

(define do-urlh
  (lambda ()
    (emit-link-start (fully-qualify-url (get-url)))
    (bgroup)
    (tex2page-string
      (string-append "\\def\\\\{\\egroup\\endinput}" (get-token)))
    (egroup)
    (emit-link-stop)))

(define do-urlhd (lambda () (do-urlh) (get-token)))

(define do-urlp
  (lambda ()
    (let ((link-text (get-token)))
      (emit-link-start (fully-qualify-url (get-url)))
      (tex2page-string link-text)
      (emit-link-stop))))

(define do-htmladdimg
  (lambda ()
    (let* ((align-info (get-bracketed-text-if-any))
           (url (fully-qualify-url (get-url))))
      (emit "<img src=\"")
      (emit url)
      (emit "\" border=\"0\" ")
      (when align-info (tex2page-string align-info))
      (emit " alt=\"[")
      (emit url)
      (emit "]\">"))))

(define do-pdfximage
  (lambda ()
    (let ((height #f) (width #f) (depth #f))
      (let loop ()
        (cond
         ((eat-word "height") (set! height (get-pixels)) (loop))
         ((eat-word "width") (set! width (get-pixels)) (loop))
         ((eat-word "depth") (set! depth (get-pixels)) (loop))
         (else #f)))
      (emit "<img")
      (when height (emit " height=") (emit height))
      (when width (emit " width=") (emit width))
      (emit " src=\"")
      (emit (fully-qualify-url (get-filename-possibly-braced)))
      (emit "\">")
      (ignorespaces)
      (get-ctl-seq)
      (ignorespaces)
      (get-ctl-seq))))

(define do-cite
  (lambda ()
    (let ((extra-text (get-bracketed-text-if-any)))
      (emit "[")
      (ignorespaces)
      (unless (char=? (get-actual-char) #\{) (terror 'do-cite "Missing {"))
      (let ((first-key? #t))
        (let loop ()
          (cond
           ((get-csv)
            =>
            (lambda (key)
              (if first-key?
                (set! first-key? #f)
                (begin (emit ",") (emit-nbsp 1)))
              (write-bib-aux "\\citation{")
              (write-bib-aux key)
              (write-bib-aux "}")
              (write-bib-aux #\newline)
              (do-ref-aux (string-append "cite{" key "}") #f #f)
              (loop)))
           (extra-text (emit ",") (emit-nbsp 1) (tex2page-string extra-text))))
        (unless (char=? (get-actual-char) #\}) (terror 'do-cite "Missing }"))
        (if first-key? (terror 'do-cite "Empty \\cite")))
      (emit "]"))))

(define do-nocite
  (lambda ()
    (ignorespaces)
    (unless (char=? (get-actual-char) #\{) (terror 'do-cite "Missing {"))
    (let loop ()
      (cond
       ((get-csv)
        =>
        (lambda (key)
          (write-bib-aux "\\citation{")
          (write-bib-aux key)
          (write-bib-aux "}")
          (write-bib-aux #\newline)
          (loop)))))
    (unless (char=? (get-actual-char) #\}) (terror 'do-nocite "Missing }"))))

(define do-bibliographystyle
  (lambda ()
    (let ((s (ungroup (get-token))))
      (write-bib-aux "\\bibstyle{")
      (write-bib-aux s)
      (write-bib-aux "}")
      (write-bib-aux #\newline))))

(define do-bibliography
  (lambda ()
    (set! *using-bibliography?* #t)
    (let ((bibdata (ungroup (get-token)))
          (bbl-file
            (string-append *aux-dir/* *jobname* *bib-aux-file-suffix* ".bbl")))
      (write-bib-aux "\\bibdata{")
      (write-bib-aux bibdata)
      (write-bib-aux "}")
      (write-bib-aux #\newline)
      (cond
       ((file-exists? bbl-file)
        (set! *bibitem-num* 0)
        (tex2page-file bbl-file)
        (emit-newline))
       (else
        (flag-missing-piece 'bibliography)
        (non-fatal-error "Bibliography not generated; rerun TeX2page"))))))

(define do-thebibliography
  (lambda ()
    (get-group)
    (when (eqv? *tex-format* 'latex)
      (tex2page-string
        (if *using-chapters?*
          "\\chapter*{\\bibname}"
          "\\section*{\\refname}")))
    (bgroup)
    (set! *bibitem-num* 0)
    (tex2page-string "\\let\\em\\it")
    (tex2page-string "\\def\\newblock{ }")
    (tex2page-string "\\def\\providecommand#1#2{}")
    (do-end-para)
    (emit "<table>")
    (emit-newline)))

(define do-bibitem
  (lambda ()
    (let ((bibmark (get-bracketed-text-if-any)))
      (do-end-para)
      (unless (= *bibitem-num* 0) (emit "</td></tr>") (emit-newline))
      (set! *bibitem-num* (+ *bibitem-num* 1))
      (emit "<tr><td align=right valign=top>")
      (let* ((bibitem-num-s (number->string *bibitem-num*))
             (key (string-append "cite{" (get-peeled-group) "}"))
             (node-name
               (string-append *html-node-prefix* "bib_" bibitem-num-s)))
        (tex-def-toks "\\TIIPrecentlabelname" node-name #f)
        (unless bibmark (set! bibmark bibitem-num-s))
        (tex-def-toks "\\TIIPrecentlabelvalue" bibmark #f)
        (emit-anchor node-name)
        (emit "[")
        (tex2page-string bibmark)
        (emit "]")
        (emit-nbsp 2)
        (do-label-aux key)
        (emit "</td><td valign=top>")))))

(define display-index-entry
  (lambda (s o)
    (for-each
      (lambda (c) (display (if (or (char=? c #\newline)) #\space c) o))
      (string->list s))))

(define do-index
  (lambda ()
    (let ((idx-entry (ungroup (get-group))))
      (unless (substring? "|)" idx-entry)
        (set! *index-count* (+ *index-count* 2))
        (!index *index-count* *html-page-count*)
        (write-aux `(!index ,*index-count* ,*html-page-count*))
        (let ((tag
               (string-append
                 *html-node-prefix*
                 "idx_"
                 (number->string *index-count*))))
          (emit-anchor tag)
          (unless *index-port*
            (let ((idx-file
                    (string-append
                      *aux-dir/*
                      *jobname*
                      *index-file-suffix*
                      ".idx")))
              (ensure-file-deleted idx-file)
              (set! *index-port* (open-output-file idx-file))))
          (display "\\indexentry{" *index-port*)
          (cond
           ((substring? "|see{" idx-entry)
            (display-index-entry idx-entry *index-port*))
           ((substring? "|seealso{" idx-entry)
            (display-index-entry idx-entry *index-port*))
           ((substring? "|(" idx-entry)
            =>
            (lambda (i)
              (display-index-entry (substring idx-entry 0 i) *index-port*)
              (display "|expandhtmlindex" *index-port*)))
           (else
            (display-index-entry idx-entry *index-port*)
            (display "|expandhtmlindex" *index-port*)))
          (display "}{" *index-port*)
          (display *index-count* *index-port*)
          (display "}" *index-port*)
          (newline *index-port*))))))

(define do-inputindex
  (lambda (insert-heading?)
    (set! *using-index?* #t)
    (when insert-heading?
      (tex2page-string
        (if *using-chapters?*
          "\\chapter*{\\indexname}"
          "\\section*{\\indexname}"))
      (emit-newline))
    (emit-anchor (string-append *html-node-prefix* "index_start"))
    (!index-page *html-page-count*)
    (write-aux `(!index-page ,*html-page-count*))
    (let ((ind-file
            (string-append *aux-dir/* *jobname* *index-file-suffix* ".ind")))
      (cond
       ((file-exists? ind-file) (tex2page-file ind-file))
       (else
        (flag-missing-piece 'index)
        (non-fatal-error "Index not generated; rerun TeX2page"))))))

(define do-theindex
  (lambda ()
    (bgroup)
    (tex2page-string "\\let\\endtheindex\\egroup")
    (tex2page-string "\\let\\indexspace\\par")
    (tex2page-string "\\let\\item\\indexitem")
    (tex2page-string "\\let\\subitem\\indexsubitem")
    (tex2page-string "\\let\\subsubitem\\indexsubsubitem")
    (tex2page-string "\\let\\(\\expandhtmlindex")))

(define expand-html-index
  (lambda (item)
    (ignorespaces)
    (unless (char=? (get-actual-char) #\{)
      (terror 'expand-tex-macro "Missing {"))
    (let ((first-link? #t))
      (let loop ((i (if item 1 *remember-index-number*)))
        (cond
         ((get-csv)
          =>
          (lambda (s)
            (let* ((n (string->number s)) (pageno (table-get *index-table* n)))
              (cond
               (pageno
                (if first-link? (set! first-link? #f) (emit ", "))
                (emit-page-node-link-start
                  pageno
                  (string-append *html-node-prefix* "idx_" s))
                (if item
                  (tex2page-string item)
                  (begin (emit "[") (emit i) (emit "]")))
                (emit-link-stop))
               (else (trace-if #t "Bad index entry around " item)))
              (loop (+ i 1)))))
         (else (set! *remember-index-number* i)))))
    (unless (char=? (get-actual-char) #\})
      (terror 'expand-html-index "Missing }"))
    (ignorespaces)))

(define do-see-also
  (lambda ()
    (let* ((other-entry (get-group)) (discard (get-group)))
      (emit "<em>see also</em> ")
      (tex2page-string other-entry))))

(define do-indexitem
  (lambda (indent)
    (emit "<br>")
    (emit-newline)
    (emit-nbsp (* indent 4))
    (let loop ((s '()) (brace-nesting 0))
      (let ((c (snoop-actual-char)))
        (cond
         ((eof-object? c) (tex2page-string (list->string (reverse! s))))
         ((and (= brace-nesting 0) (char=? c *esc-char*))
          (let ((x (get-ctl-seq)))
            (cond
             ((or (string=? x "\\subitem") (string=? x "\\subsubitem"))
              (tex2page-string (list->string (reverse! s)))
              (toss-back-char *invisible-space*)
              (toss-back-string x))
             (else
              (let ((xr (reverse! (string->list x))))
                (loop
                 (if (char-alphabetic? (car xr))
                   (cons #\space (append xr s))
                   (append xr s))
                 brace-nesting))))))
         ((char=? c #\,)
          (get-actual-char)
          (if (char-whitespace? (snoop-actual-char))
            (begin
              (ignore-all-whitespace)
              (if (char=? (snoop-actual-char) *esc-char*)
                (let ((x (get-ctl-seq)))
                  (cond
                   ((string=? x "\\expandhtmlindex")
                    (expand-html-index (list->string (reverse! s))))
                   ((string=? x "\\see")
                    (tex2page-string (list->string (reverse! s)))
                    (emit ", <em>see</em> ")
                    (tex2page-string (get-group))
                    (get-group))
                   ((string=? x "\\seealso")
                    (tex2page-string (list->string (reverse! s)))
                    (emit ", <em>see also</em> ")
                    (tex2page-string (get-group))
                    (get-group))
                   (else
                    (toss-back-char *invisible-space*)
                    (toss-back-string x)
                    (toss-back-char *invisible-space*)
                    (loop (cons #\space (cons #\, s)) brace-nesting))))
                (loop (cons #\space (cons #\, s)) brace-nesting)))
            (loop (cons #\, s) brace-nesting)))
         (else
          (get-actual-char)
          (loop
           (cons c s)
           (cond
            ((char=? c #\{) (+ brace-nesting 1))
            ((char=? c #\}) (- brace-nesting 1))
            (else brace-nesting)))))))))

(define do-description-item
  (lambda ()
    (do-end-para)
    (emit "</dd><dt>")
    (let ((thing (get-bracketed-text-if-any)))
      (when thing
        (set! thing (string-trim-blanks thing))
        (unless (string=? thing "")
          (bgroup)
          (emit "<b>")
          (tex2page-string thing)
          (emit "</b>")
          (egroup))))
    (emit "</dt><dd>")))

(define do-regular-item
  (lambda ()
    (do-end-para)
    (emit "<li>")
    (do-para)
    (let ((thing (get-bracketed-text-if-any)))
      (when thing
        (emit "<b>")
        (bgroup)
        (tex2page-string thing)
        (egroup)
        (emit "</b>")
        (emit-nbsp 2)))))

(define do-plain-item
  (lambda (n)
    (do-end-para)
    (emit "<table><tr><td width=20 valign=top align=right>")
    (let loop ((n n))
      (unless (<= n 1)
        (emit "</td><td width=20 valign=top align=right>")
        (loop (- n 1))))
    (tex2page-string (get-group))
    (emit-nbsp 2)
    (emit "</td><td>")
    (do-para)
    (add-afterpar (lambda () (emit "</td></tr></table>")))))

(define do-item
  (lambda ()
    (let ((a #f))
      (unless (null? *tabular-stack*) (set! a (car *tabular-stack*)))
      (case a
        ((description) (do-description-item))
        ((itemize enumerate) (do-regular-item))
        (else (do-plain-item 1))))))

(define do-bigskip
  (lambda (type)
    (do-para)
    (when (ormap (lambda (z) (string=? type z)) '("\\bigskip" "\\bigbreak"))
      (emit "<br>")
      (do-para)
      (emit "<br>"))
    (do-para)))

(define do-hspace
  (lambda ()
    (ignorespaces)
    (if (eqv? (snoop-actual-char) #\*) (get-actual-char))
    (get-group)
    (emit-nbsp 3)))

(define do-vspace
  (lambda ()
    (ignorespaces)
    (if (eqv? (snoop-actual-char) #\*) (get-actual-char))
    (get-group)
    (do-bigskip "vspace")))

(define do-htmlmathstyle
  (lambda ()
    (call-with-input-string/buffered
      (ungroup (get-group))
      (lambda ()
        (let loop ()
          (ignore-all-whitespace)
          (let ((c (snoop-actual-char)))
            (unless (eof-object? c)
              (case (string->symbol (scm-get-token))
                ((image)
                 (set! *use-image-for-displayed-math?* #t)
                 (set! *use-image-for-intext-math?* #t))
                ((display-image) (set! *use-image-for-displayed-math?* #t))
                ((in-text-image) (set! *use-image-for-intext-math?* #t))
                ((no-image)
                 (set! *use-image-for-displayed-math?* #f)
                 (set! *use-image-for-intext-math?* #f))
                ((no-display-image) (set! *use-image-for-displayed-math?* #f))
                ((no-in-text-image) (set! *use-image-for-intext-math?* #f)))
              (loop))))))))

(define do-htmlcolophon
  (lambda ()
    (call-with-input-string/buffered
      (ungroup (get-group))
      (lambda ()
        (let loop ()
          (ignore-all-whitespace)
          (let ((c (snoop-actual-char)))
            (unless (eof-object? c)
              (case (string->symbol (scm-get-token))
                ((last-page) (set! *colophon-on-first-page?* #f))
                ((no-timestamp) (set! *colophon-mentions-last-mod-time?* #f))
                ((dont-credit-tex2page ingrate)
                 (set! *colophon-mentions-tex2page?* #f))
                ((dont-link-to-tex2page-website)
                 (set! *colophon-links-to-tex2page-website?* #f)))
              (loop))))))))

(define output-colophon
  (lambda ()
    (when (or *colophon-mentions-last-mod-time?* *colophon-mentions-tex2page?*)
      (do-end-para)
      (emit "<div align=right class=colophon>")
      (emit-newline)
      (emit "<i>")
      (when (and
             *colophon-mentions-last-mod-time?*
             *last-modification-time*
             (> *last-modification-time* 0))
        (tex2page-string *last-modified*)
        (emit ": ")
        (emit (seconds->human-time *last-modification-time*))
        (emit "<br>")
        (emit-newline))
      (when *colophon-mentions-tex2page?*
        (tex2page-string *html-conversion-by*)
        (emit " ")
        (when *colophon-links-to-tex2page-website?*
          (emit-link-start
            "http://www.ccs.neu.edu/~dorai/tex2page/tex2page-doc.html"))
        (emit "TeX2page ")
        (emit *tex2page-version*)
        (when *colophon-links-to-tex2page-website?* (emit-link-stop)))
      (emit "</i>")
      (emit-newline)
      (emit "</div>")
      (emit-newline))))

(define output-navigation-bar
  (lambda (top-or-bottom)
    (let* ((first-page? (= *html-page-count* 0))
           (last-page-not-determined? (< *last-page-number* 0))
           (last-page? (= *html-page-count* *last-page-number*))
           (toc-page? (and *toc-page* (= *html-page-count* *toc-page*)))
           (index-page? (and *index-page* (= *html-page-count* *index-page*)))
           (first-page *zeroth-html-page*)
           (prev-page
             (cond
              (first-page? #f)
              ((= *html-page-count* 1) first-page)
              (else
               (string-append
                 *jobname*
                 *html-page-suffix*
                 (number->string (- *html-page-count* 1))
                 *output-extension*))))
           (next-page
             (cond
              (last-page? #f)
              (else
               (string-append
                 *jobname*
                 *html-page-suffix*
                 (number->string (+ *html-page-count* 1))
                 *output-extension*)))))
      (unless (and
               first-page?
               (or last-page?
                   (and (eq? top-or-bottom 'top) last-page-not-determined?)))
        (do-end-para)
        (emit "<div align=right class=navigation><i>[")
        (emit *navigation-sentence-begin*)
        (emit "<span")
        (when first-page? (emit " class=disable"))
        (emit ">")
        (unless first-page? (emit-link-start first-page))
        (emit *navigation-first-name*)
        (unless first-page? (emit-link-stop))
        (emit ", ")
        (unless first-page? (emit-link-start prev-page))
        (emit *navigation-previous-name*)
        (unless first-page? (emit-link-stop))
        (emit "</span>")
        (emit "<span")
        (when last-page? (emit " class=disable"))
        (emit ">")
        (when first-page? (emit "<span class=disable>"))
        (emit ", ")
        (when first-page? (emit "</span>"))
        (unless last-page? (emit-link-start next-page))
        (emit *navigation-next-name*)
        (unless last-page? (emit-link-stop))
        (emit "</span>")
        (emit *navigation-page-name*)
        (when (or *toc-page* *index-page*)
          (emit "<span")
          (when (or
                 (and toc-page? (not *index-page*) (not index-page?))
                 (and index-page? (not *toc-page*) (not toc-page?)))
            (emit " class=disable"))
          (emit ">; ")
          (emit-nbsp 2)
          (emit "</span>")
          (when *toc-page*
            (emit "<span")
            (when toc-page? (emit " class=disable"))
            (emit ">")
            (unless toc-page?
              (emit-page-node-link-start
                *toc-page*
                (string-append *html-node-prefix* "toc_start")))
            (emit *navigation-contents-name*)
            (unless toc-page? (emit-link-stop))
            (emit "</span>"))
          (when *index-page*
            (emit "<span")
            (when index-page? (emit " class=disable"))
            (emit ">")
            (emit "<span")
            (unless (and *toc-page* (not toc-page?)) (emit " class=disable"))
            (emit ">")
            (when *toc-page* (emit "; ") (emit-nbsp 2))
            (emit "</span>")
            (unless index-page?
              (emit-page-node-link-start
                *index-page*
                (string-append *html-node-prefix* "index_start")))
            (emit *navigation-index-name*)
            (unless index-page? (emit-link-stop))
            (emit "</span>")))
        (emit *navigation-sentence-end*)
        (emit "]</i></div>")
        (do-para)))))

(define do-eject
  (lambda ()
    (unless (and
             (eof-object? (snoop-actual-char))
             (eqv? *current-tex-file* *main-tex-file*))
      (unless (> *last-page-number* 0)
        (flag-missing-piece 'last-modification-time))
      (do-end-page)
      (set! *html-page-count* (+ *html-page-count* 1))
      (set! *html-page*
        (string-append
          *aux-dir/*
          *jobname*
          *html-page-suffix*
          (number->string *html-page-count*)
          *output-extension*))
      (ensure-file-deleted *html-page*)
      (set! *html* (open-output-file *html-page*))
      (do-start))))

(define output-html-preamble
  (lambda (top-level-page?)
    (emit "<!doctype html public ")
    (emit "\"-//W3C//DTD HTML 4.01 Transitional//EN\" ")
    (emit "\"http://www.w3.org/TR/html4/loose.dtd\">")
    (emit-newline)
    (emit "<html>")
    (emit-newline)
    (emit "<!--")
    (emit-newline)
    (emit-newline)
    (emit "Generated from ")
    (emit *main-tex-file*)
    (emit " by tex2page, ")
    (emit "v ")
    (emit *tex2page-version*)
    (emit-newline)
    (emit "(running on ")
    (emit *scheme-version*)
    (emit ", ")
    (emit *operating-system*)
    (emit "), ")
    (emit-newline)
    (emit "(c) Dorai Sitaram, ")
    (emit-newline)
    (emit *tex2page-website*)
    (emit-newline)
    (emit-newline)
    (emit "-->")
    (emit-newline)
    (emit "<head>")
    (emit-newline)
    (output-external-title)
    (link-stylesheets)
    (emit "<meta name=robots content=\"")
    (unless (and top-level-page? (= *html-page-count* 0)) (emit "no"))
    (emit "index,follow\">")
    (emit-newline)
    (for-each emit *html-head*)
    (emit "</head>")
    (emit-newline)
    (emit "<body>")
    (emit-newline)))

(define output-html-postamble
  (lambda () (emit "</body>") (emit-newline) (emit "</html>") (emit-newline)))

(define do-start
  (lambda ()
    (set! *footnote-list* '())
    (output-html-preamble #t)
    (output-navigation-bar 'top)))

(define do-end-page
  (lambda ()
    (output-footnotes)
    (output-navigation-bar 'bottom)
    (when (and *colophon-on-first-page?* (= *html-page-count* 0))
      (output-colophon))
    (do-end-para)
    (when (and
           (not *colophon-on-first-page?*)
           (= *html-page-count* *last-page-number*))
      (output-colophon))
    (output-html-postamble)
    (write-log #\[)
    (write-log *html-page-count*)
    (write-log #\])
    (write-log 'separation-space)
    (close-output-port *html*)))

(define close-all-open-ports
  (lambda ()
    (when *aux-port* (close-output-port *aux-port*))
    (when *css-port* (close-output-port *css-port*))
    (when *index-port* (close-output-port *index-port*))
    (when *label-port* (close-output-port *label-port*))
    (when *bib-aux-port* (close-output-port *bib-aux-port*))
    (when *verb-port* (close-output-port *verb-port*))
    (for-each
      (lambda (c) (let ((p (cdr c))) (when p (close-input-port p))))
      *input-streams*)
    (for-each
      (lambda (c) (let ((p (cdr c))) (when p (close-output-port p))))
      *output-streams*)))

(define output-stats
  (lambda ()
    (write-log 'separation-newline)
    (cond
     (*main-tex-file*
      (let ((num-pages (+ *html-page-count* 1)))
        (write-log "Output written on ")
        (write-log *aux-dir/*)
        (write-log *zeroth-html-page*)
        (when (> num-pages 1) (write-log ", ..."))
        (write-log " (")
        (write-log num-pages)
        (write-log " page")
        (unless (= num-pages 1) (write-log #\s)))
      (when (> *img-file-tally* 0)
        (write-log ", ")
        (write-log *img-file-tally*)
        (write-log " image")
        (unless (= *img-file-tally* 1) (write-log #\s)))
      (write-log ")."))
     (else (write-log "No pages of output.")))
    (write-log #\newline)
    (when *log-port* (close-output-port *log-port*))
    (display "Transcript written on ")
    (display *log-file*)
    (display ".")
    (newline)))

(define do-bye
  (lambda ()
    (unless (null? *tex-if-stack*) (terror 'do-bye "Incomplete \\if"))
    (unless (null? *tex-env*)
      (trace-if
        #t
        "\\end occurred inside a group at level "
        (length *tex-env*)))
    (perform-postludes)
    (unless (or (>= *last-page-number* 0) (= *html-page-count* 0))
      (flag-missing-piece 'last-page))
    (!last-page-number *html-page-count*)
    (write-aux `(!last-page-number ,*last-page-number*))
    (do-end-page)
    (when *last-modification-time*
      (write-aux `(!last-modification-time ,*last-modification-time*)))
    (close-all-open-ports)
    (call-external-programs-if-necessary)
    (show-unresolved-xrefs-and-missing-pieces)))

(define insert-missing-end
  (lambda ()
    (write-log 'separation-newline)
    (write-log "! Missing \\end inserted.")
    (write-log 'separation-newline)))

(define do-diacritic-aux
  (lambda (diac c)
    (case diac
      ((acute)
       (case c
         ((#\a #\e #\i #\o #\u #\y #\A #\E #\I #\O #\U #\Y)
          (emit #\&)
          (emit c)
          (emit "acute;"))
         ((#\space) (emit #\'))
         (else (emit c) (emit #\'))))
      ((cedilla)
       (case c
         ((#\c #\C) (emit #\&) (emit c) (emit "cedil;"))
         ((#\space) (emit #\,))
         (else (emit c) (emit #\,))))
      ((circumflex)
       (case c
         ((#\a #\e #\i #\o #\u #\A #\E #\I #\O #\U)
          (emit #\&)
          (emit c)
          (emit "circ;"))
         ((#\space) (emit #\^))
         (else (emit c) (emit #\^))))
      ((grave)
       (case c
         ((#\a #\e #\i #\o #\u #\A #\E #\I #\O #\U)
          (emit #\&)
          (emit c)
          (emit "grave;"))
         ((#\space) (emit #\`))
         (else (emit c) (emit #\`))))
      ((hacek)
       (case c
         ((#\s) (emit *html-scaron*))
         ((#\S) (emit *html-^scaron*))
         ((#\space) (emit #\^))
         (else (emit c) (emit #\^))))
      ((ring)
       (case c
         ((#\a #\A) (emit #\&) (emit c) (emit "ring;"))
         ((#\space) (emit "&deg;"))
         (else (emit c) (emit "&deg;"))))
      ((tilde)
       (case c
         ((#\a #\n #\o #\A #\N #\O) (emit #\&) (emit c) (emit "tilde;"))
         ((#\space) (emit #\~))
         (else (emit c) (emit #\~))))
      ((umlaut)
       (case c
         ((#\a #\e #\i #\o #\u #\y #\A #\E #\I #\O #\U)
          (emit #\&)
          (emit c)
          (emit "uml;"))
         ((#\Y) (emit *html-^yuml*))
         ((#\space) (emit "&quot;"))
         (else (emit c) (emit "&quot;"))))
      (else (emit "<u>") (emit c) (emit "</u>")))))

(define do-diacritic
  (lambda (diac)
    (let* ((x (ungroup (get-token)))
           (c
            (if (string=? x "\\i")
              #\i
              (case (string-length x)
                ((0) #\space)
                ((1) (string-ref x 0))
                (else (terror 'do-diacritic "`" x "' is not a character"))))))
      (do-diacritic-aux diac c))))

(define do-imageless-display-math
  (lambda ()
    (if *math-mode?*
      (egroup)
      (let ((old-in-math? *math-mode?*)
            (old-in-display-math? *in-display-math?*)
            (old-tabular-stack *tabular-stack*))
        (do-end-para)
        (emit "<div align=")
        (emit *display-justification*)
        (emit "><table><tr><td>")
        (set! *math-mode?* #t)
        (set! *in-display-math?* #t)
        (set! *tabular-stack* '())
        (bgroup)
        (add-postlude-to-top-frame
          (lambda ()
            (set! *math-mode?* old-in-math?)
            (set! *in-display-math?* old-in-display-math?)
            (set! *tabular-stack* old-tabular-stack)
            (emit "</td></tr></table></div>")
            (do-para)))))))

(define do-mathdg
  (lambda ()
    (fluid-let
      ((*math-mode?* #t)
       (*in-display-math?* #t)
       (*tabular-stack* '())
       (*ligatures?* #f))
      (do-end-para)
      (emit "<div align=")
      (emit *display-justification*)
      (emit "><table><tr><td>")
      (tex2page-string (get-group))
      (emit "</td></tr></table></div>")
      (do-para))))

(define do-imageless-intext-math
  (lambda ()
    (if *math-mode?*
      (egroup)
      (let ((old-in-math? *math-mode?*)
            (old-in-display-math? *in-display-math?*)
            (old-tabular-stack *tabular-stack*))
        (set! *math-mode?* #t)
        (set! *in-display-math?* #f)
        (set! *tabular-stack* '())
        (bgroup)
        (add-postlude-to-top-frame
          (lambda ()
            (set! *math-mode?* old-in-math?)
            (set! *in-display-math?* old-in-display-math?)
            (set! *tabular-stack* old-tabular-stack)))))))

(define do-mathg
  (lambda ()
    (fluid-let
      ((*math-mode?* #t)
       (*in-display-math?* #f)
       (*tabular-stack* '())
       (*ligatures?* #f))
      (tex2page-string (get-group)))))

(define dump-tex-preamble
  (lambda (o)
    (case *tex-format*
      ((latex)
       (display "\\documentclass{" o)
       (display (if *using-chapters?* "report" "article") o)
       (display "}" o)
       (newline o)
       (display *imgpreamble* o)
       (newline o)
       (when (memv 'includegraphics *imgpreamble-inferred*)
         (display "\\ifx\\includegraphics\\UNDEFINED" o)
         (display "\\usepackage{graphicx}\\fi" o)
         (newline o))
       (when (memv 'epsfbox *imgpreamble-inferred*)
         (display "\\ifx\\epsfbox\\UNDEFINED" o)
         (display "\\usepackage{epsfig}\\fi" o)
         (newline o))
       (display "\\thispagestyle{empty}" o)
       (newline o)
       (display "\\begin{document}" o)
       (newline o))
      (else
       (display *imgpreamble* o)
       (newline o)
       (when (memv 'epsfbox *imgpreamble-inferred*)
         (display "\\ifx\\epsfbox\\UNDEFINED" o)
         (display "\\input epsf \\fi" o)
         (newline o))
       (display "\\nopagenumbers" o)
       (newline o)))))

(define dump-tex-postamble
  (lambda (o)
    (case *tex-format*
      ((latex) (display "\\end{document}" o) (newline o))
      (else (display "\\bye" o) (newline o)))))

(define skipping-img-file
  (lambda () (set! *img-file-count* (+ *img-file-count* 1))))

(define next-html-image-file-stem
  (lambda ()
    (set! *img-file-count* (+ *img-file-count* 1))
    (string-append
      *subjobname*
      *img-file-suffix*
      (number->string *img-file-count*))))

(define call-with-html-image-port
  (lambda (p)
    (let* ((img-file-stem (next-html-image-file-stem))
           (aux-tex-file (string-append img-file-stem ".tex")))
      (ensure-file-deleted aux-tex-file)
      (call-with-output-file
        aux-tex-file
        (lambda (o) (dump-tex-preamble o) (p o) (dump-tex-postamble o)))
      (tex-to-img img-file-stem)
      (source-img-file img-file-stem))))

(define do-imaged-display-math
  (lambda ()
    (do-end-para)
    (emit "<div align=")
    (emit *display-justification*)
    (emit ">")
    (call-with-html-image-port
      (lambda (o)
        (display "$$" o)
        (dump-till-char #\$ o)
        (let ((c (get-actual-char)))
          (cond
           ((eof-object? c) (terror 'do-imaged-display-math))
           ((char=? c #\$) #t)
           (else (terror 'do-imaged-display-math))))
        (display "$$" o)))
    (emit "</div>")
    (do-para)))

(define do-imaged-intext-math
  (lambda ()
    (call-with-html-image-port
      (lambda (o) (display #\$ o) (dump-till-char #\$ o) (display #\$ o)))))

(define do-mathp
  (lambda ()
    (call-with-html-image-port
      (lambda (o) (display #\$ o) (display (get-group) o) (display #\$ o)))))

(define do-latex-in-text-math
  (lambda ()
    ((if *use-image-for-intext-math?*
       do-img-latex-in-text-math
       do-imgless-latex-in-text-math))))

(define do-latex-display-math
  (lambda ()
    ((if *use-image-for-displayed-math?*
       do-img-latex-display-math
       do-imgless-latex-display-math))))

(define do-img-latex-in-text-math
  (lambda ()
    (call-with-html-image-port
      (lambda (o)
        (display #\$ o)
        (dump-till-ctl-seq "\\)" o)
        (display #\$ o)))))

(define do-img-latex-display-math
  (lambda ()
    (do-end-para)
    (emit "<div align=")
    (emit *display-justification*)
    (emit ">")
    (call-with-html-image-port
      (lambda (o)
        (display "$$" o)
        (dump-till-ctl-seq "\\]" o)
        (display "$$" o)))
    (emit "</div>")
    (do-para)))

(define do-imgless-latex-in-text-math
  (lambda ()
    (let ((old-in-math? *math-mode?*)
          (old-in-display-math? *in-display-math?*)
          (old-tabular-stack *tabular-stack*))
      (set! *math-mode?* #t)
      (set! *in-display-math?* #f)
      (set! *tabular-stack* '())
      (bgroup)
      (add-postlude-to-top-frame
        (lambda ()
          (set! *math-mode?* old-in-math?)
          (set! *in-display-math?* old-in-display-math?)
          (set! *tabular-stack* old-tabular-stack))))))

(define do-imgless-latex-display-math
  (lambda ()
    (let ((old-in-math? *math-mode?*)
          (old-in-display-math? *in-display-math?*)
          (old-tabular-stack *tabular-stack*))
      (do-end-para)
      (emit "<div align=")
      (emit *display-justification*)
      (emit "><table><tr><td>")
      (set! *math-mode?* #t)
      (set! *in-display-math?* #t)
      (set! *tabular-stack* '())
      (bgroup)
      (add-postlude-to-top-frame
        (lambda ()
          (set! *math-mode?* old-in-math?)
          (set! *in-display-math?* old-in-display-math?)
          (set! *tabular-stack* old-tabular-stack)
          (emit "</td></tr></table></div>")
          (do-para))))))

(define do-math
  (lambda ()
    (let ((display? #f))
      (when (eqv? (snoop-actual-char) #\$)
        (set! display? #t)
        (get-actual-char))
      ((if display?
         (if *use-image-for-displayed-math?*
           do-imaged-display-math
           do-imageless-display-math)
         (if *use-image-for-intext-math?*
           do-imaged-intext-math
           do-imageless-intext-math))))))

(define dump-till-char
  (lambda (d o)
    (let loop ((nesting 0) (escape? #f))
      (let ((c (get-actual-char)))
        (cond
         ((eof-object? c) (terror 'dump-till-char))
         ((and (char=? c d) (= nesting 0)) #t)
         (else
          (display c o)
          (cond
           (escape? (loop nesting #f))
           ((char=? c #\{) (loop (+ nesting 1) #f))
           ((char=? c #\}) (loop (- nesting 1) #f))
           ((char=? c #\\) (loop nesting #t))
           (else (loop nesting #f)))))))))

(define dump-till-ctl-seq
  (lambda (cs o)
    (fluid-let
      ((*not-processing?* #t))
      (let loop ((nesting 0))
        (let ((c (snoop-actual-char)))
          (cond
           ((eof-object? c) (terror 'dump-till-ctl-seq))
           ((char=? c *esc-char*)
            (let ((x (get-ctl-seq)))
              (if (string=? x cs) #t (begin (display x o) (loop nesting)))))
           (else
            (display (get-actual-char) o)
            (cond
             ((char=? c #\{) (loop (+ nesting 1)))
             ((char=? c #\}) (loop (- nesting 1)))
             (else (loop nesting))))))))))

(define dump-till-end-env
  (lambda (env o)
    (let* ((endenv (string-append "\\end" env))
           (endenv-prim (find-corresp-prim endenv))
           (endenv-prim-th (find-corresp-prim-thunk endenv)))
      (fluid-let
        ((*not-processing?* #t))
        (let loop ((brace-nesting 0) (env-nesting 0))
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) (terror 'dump-till-end-env env))
             ((char=? c *esc-char*)
              (let ((x (get-ctl-seq)))
                (cond
                 ((string=? (find-corresp-prim x) endenv-prim) #t)
                 ((string=? x "\\begin")
                  (display x o)
                  (let ((g (get-grouped-environment-name-if-any)))
                    (when g (display #\{ o) (display g o) (display #\} o))
                    (loop
                     brace-nesting
                     (if (and g (string=? g env))
                       (+ env-nesting 1)
                       env-nesting))))
                 ((string=? x "\\end")
                  (let ((g (get-grouped-environment-name-if-any)))
                    (unless (and
                             g
                             (or *dumping-nontex?* (= env-nesting 0))
                             (let ((endg (string-append "\\end" g)))
                               (or (string=?
                                     (find-corresp-prim endg)
                                     endenv-prim)
                                   (eqv?
                                    (find-corresp-prim-thunk endg)
                                    endenv-prim-th))))
                      (display x o)
                      (when g (display #\{ o) (display g o) (display #\} o))
                      (loop
                       brace-nesting
                       (if (and g (string=? g env))
                         (- env-nesting 1)
                         env-nesting)))))
                 (else (display x o) (loop brace-nesting env-nesting)))))
             ((and (char=? c *comment-char*) (not *dumping-nontex?*))
              (do-comment)
              (write-char #\% o)
              (newline o)
              (loop brace-nesting env-nesting))
             (else
              (write-char (get-actual-char) o)
              (cond
               ((char=? c #\{) (loop (+ brace-nesting 1) env-nesting))
               ((char=? c #\}) (loop (- brace-nesting 1) env-nesting))
               (else (loop brace-nesting env-nesting)))))))))))

(define dump-imgdef
  (lambda (f)
    (let ((aux-tex-file (string-append f ".tex")))
      (ensure-file-deleted aux-tex-file)
      (call-with-output-file
        aux-tex-file
        (lambda (o)
          (dump-tex-preamble o)
          (display (ungroup (get-group)) o)
          (dump-tex-postamble o))))))

(define do-img-preamble
  (lambda ()
    (set! *imgpreamble*
      (fluid-let
        ((*not-processing?* #t))
        (let loop ((r *imgpreamble*))
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c)
              (terror 'do-img-preamble "Missing \\endimgpreamble"))
             ((char=? c *esc-char*)
              (let ((x (get-ctl-seq)))
                (cond
                 ((ormap
                   (lambda (z) (string=? x z))
                   '("\\endimgpreamble"
                     "\\endgifpreamble"
                     "\\endmathpreamble"))
                  r)
                 (else (loop (string-append r x))))))
             (else
              (get-actual-char)
              (loop (string-append r (string c)))))))))))

(define pick-new-stream-number
  (lambda (stream-list)
    (let loop ((i 0))
      (if (or (assv i stream-list) (= i 16) (= i 18)) (loop (+ i 1)) i))))

(define do-new-stream
  (lambda (type)
    (let* ((x (get-ctl-seq))
           (sl (if (eqv? type 'out) *output-streams* *input-streams*))
           (n (pick-new-stream-number sl))
           (sl-new (cons (cons n #f) sl)))
      (tex-def-count x n #t)
      (case type
        ((out) (set! *output-streams* sl-new))
        (else (set! *input-streams* sl-new))))))

(define do-open-stream
  (lambda (type)
    (let* ((n (get-number))
           (f (get-plain-filename))
           (sl (if (eqv? type 'out) *output-streams* *input-streams*))
           (c (assv n sl)))
      (unless (and c (not (cdr c))) (terror 'do-open-stream))
      (case type
        ((out)
         (set! f (add-dot-tex-if-no-extension-provided f))
         (ensure-file-deleted f)
         (set-cdr! c (open-output-file f)))
        (else
         (set! f (actual-tex-filename f #f))
         (set-cdr! c (make-bport 'port (open-input-file f))))))))

(define do-close-stream
  (lambda (type)
    (let* ((sl (if (eqv? type 'out) *output-streams* *input-streams*))
           (o (get-number))
           (c (assv o sl)))
      (unless (and c (cdr c)) (terror 'do-close-stream))
      (case type
        ((out) (close-output-port (cdr c)))
        ((in) (close-output-port (bport.port (cdr c)))))
      (set-cdr! c #f))))

(define tex-write-output-string
  (lambda (s)
    (let ((o (open-output-string)))
      (fluid-let
        ((*outputting-to-non-html?* #t) (*html* o))
        (call-with-input-string/buffered
          s
          (lambda ()
            (let loop ()
              (let ((c (snoop-actual-char)))
                (unless (eof-object? c)
                  (case c
                    ((#\\) (do-tex-ctl-seq (get-ctl-seq)))
                    (else (emit-html-char (get-actual-char))))
                  (loop)))))))
      (get-output-string o))))

(define do-write-aux
  (lambda (o)
    (let ((output (tex-write-output-string (get-peeled-group))))
      (cond
       ((and (= o 18) *enable-write-18?*) (system output))
       ((or (= o 16) (= o 18))
        (write-log output)
        (write-log 'separation-space))
       ((assv o *output-streams*)
        =>
        (lambda (c)
          (let ((p (cdr c)))
            (cond
             ((not p) (terror 'do-write-aux))
             (else (display output p) (display #\space p))))))
       (else (terror 'do-write))))))

(define do-write (lambda () (do-write-aux (get-number))))

(define do-message (lambda () (do-write-aux 16)))

(define read-tex-line
  (lambda (p)
    (fluid-let
      ((*current-tex2page-input* p))
      (let loop ((r '()))
        (let ((c (snoop-actual-char)))
          (cond
           ((eof-object? c) (if (null? r) c (list->string (reverse! r))))
           ((char=? c #\newline) (get-actual-char) (list->string (reverse! r)))
           ((char=? c #\{)
            (string-append (list->string (reverse! r)) (get-group)))
           (else (loop (cons (get-actual-char) r)))))))))

(define do-read
  (lambda (global?)
    (let* ((i (get-number)) (x (begin (get-to) (get-ctl-seq))) (p #f))
      (cond
       ((ormap (lambda (j) (= i j)) '(-1 16))
        (set! p (make-bport 'port (current-input-port)))
        (unless (= i -1) (write-log x) (write-log #\=)))
       ((assv i *input-streams*)
        =>
        (lambda (c) (set! p (cdr c)) (unless p (terror 'do-read))))
       (else (terror 'do-read)))
      (tex-def-0arg
        x
        (let ((line (read-tex-line p))) (if (eof-object? line) "" line))
        (and global? *global-texframe*)))))

(define do-typein
  (lambda ()
    (let ((ctlseq (get-bracketed-text-if-any))
          (p (make-bport 'port (current-input-port))))
      (write-log 'separation-newline)
      (write-log (tex-string->html-string (get-group)))
      (write-log 'separation-newline)
      (write-log (or ctlseq "\\@typein"))
      (write-log #\=)
      (let ((l (read-tex-line p)))
        (when (eof-object? l) (set! l ""))
        (cond
         (ctlseq (tex-def-0arg ctlseq l #f))
         (else (tex2page-string l)))))))

(define do-ifeof
  (lambda ()
    (let* ((i (get-number)) (c (assv i *input-streams*)))
      (unless (and c (cdr c)) (terror 'do-ifeof))
      (if (eof-object? (read-char (cdr c))) do-iftrue do-iffalse))))

(define do-iffalse (lambda () (set! *tex-if-stack* (cons #f *tex-if-stack*))))

(define do-iftrue (lambda () (set! *tex-if-stack* (cons #t *tex-if-stack*))))

(define do-ifx
  (lambda ()
    (let* ((one (get-raw-token/is)) (two (get-raw-token/is)))
      ((if (string=? one two)
         do-iftrue
         (begin
           (when (ctl-seq? one)
             (set! one
               (cond
                ((find-def one) => tdef.expansion)
                ((find-math-def one) => (lambda (x) x))
                (else "UnDeFiNeD"))))
           (when (ctl-seq? two)
             (set! two
               (cond
                ((find-def two) => tdef.expansion)
                ((find-math-def two) => (lambda (x) x))
                (else "UnDeFiNeD"))))
           (if (or (eqv? one two)
                   (and (string? one) (string? two) (string=? one two)))
             do-iftrue
             do-iffalse)))))))

(define do-if-get-atomic
  (lambda ()
    (let loop ()
      (let ((x (get-raw-token/is)))
        (if (ctl-seq? x)
          (cond
           ((resolve-defs x)
            =>
            (lambda (z)
              (toss-back-char *invisible-space*)
              (toss-back-string z)
              (loop)))
           (else x))
          x)))))

(define do-if
  (lambda ()
    (let* ((one (do-if-get-atomic)) (two (do-if-get-atomic)))
      ((if (or (string=? one two) (and (ctl-seq? one) (ctl-seq? two)))
         do-iftrue
         do-iffalse)))))

(define do-ifmmode
  (lambda () (set! *tex-if-stack* (cons *math-mode?* *tex-if-stack*))))

(define do-ifnum
  (lambda ()
    (let* ((one (get-number))
           (rel (string-ref (get-raw-token/is) 0))
           (two (get-number)))
      ((if ((case rel
              ((#\<) <)
              ((#\=) =)
              ((#\>) >)
              (else (terror 'do-ifnum "Missing relation for \\ifnum")))
            one
            two)
         do-iftrue
         do-iffalse)))))

(define read-ifcase-clauses
  (lambda ()
    (fluid-let
      ((*not-processing?* #t))
      (let* ((else-clause #f)
             (or-clauses
               (let loop ((or-clauses '()) (else? #f))
                 (let loop2 ((clause ""))
                   (let ((c (snoop-actual-char)))
                     (cond
                      ((eof-object? c)
                       (terror 'read-ifcase-clauses "Missing \\fi"))
                      ((char=? c *esc-char*)
                       (let ((x (get-ctl-seq)))
                         (cond
                          ((string=? x "\\or")
                           (if else?
                             (terror 'read-ifcase-clauses "\\or after \\else")
                             (loop (cons clause or-clauses) #f)))
                          ((string=? x "\\else")
                           (if else?
                             (terror
                               'read-ifcase-clauses
                               "\\else after \\else")
                             (loop (cons clause or-clauses) #t)))
                          ((string=? x "\\fi")
                           (if else?
                             (begin (set! else-clause clause) or-clauses)
                             (cons clause or-clauses)))
                          (else (loop2 (string-append clause x))))))
                      (else
                       (get-actual-char)
                       (loop2 (string-append clause (string c))))))))))
        (cons else-clause or-clauses)))))

(define do-ifcase
  (lambda ()
    (let* ((num (get-number))
           (clauses (read-ifcase-clauses))
           (else-clause (car clauses))
           (or-clauses (reverse! (cdr clauses)))
           (num-or-clauses (length or-clauses)))
      (cond
       ((< num num-or-clauses) (tex2page-string (list-ref or-clauses num)))
       (else-clause (tex2page-string else-clause))))))

(define do-ifodd (lambda () ((if (odd? (get-number)) do-iftrue do-iffalse))))

(define do-else
  (lambda ()
    (when (null? *tex-if-stack*) (terror 'do-else "Extra \\else"))
    (let ((top-if (car *tex-if-stack*)))
      (set-car! *tex-if-stack* (not top-if)))))

(define do-fi
  (lambda ()
    (when (null? *tex-if-stack*) (terror 'do-fi "Extra \\fi"))
    (set! *tex-if-stack* (cdr *tex-if-stack*))))

(define do-newif
  (lambda ()
    (let* ((iffoo (get-ctl-seq))
           (init-val #f)
           (foo (string-append "\\" (substring iffoo 3 (string-length iffoo))))
           (foo-register (string-append foo "BOOLEANREGISTER")))
      (tex-def-count foo-register 0 #f)
      (tex-def-thunk
        iffoo
        (lambda ()
          (set! *tex-if-stack*
            (cons (> (the-count foo-register) 0) *tex-if-stack*)))
        #f)
      (tex-def-thunk
        (string-append foo "true")
        (lambda () (tex-def-count foo-register 1 #f))
        #f)
      (tex-def-thunk
        (string-append foo "false")
        (lambda () (tex-def-count foo-register 0 #f))
        #f))))

(define do-htmlimg
  (lambda (env)
    (call-with-html-image-port (lambda (o) (dump-till-end-env env o)))))

(define find-img-file-extn
  (lambda ()
    (case *image-format*
      ((gif) ".gif")
      ((png) ".png")
      ((jpeg) ".jpeg")
      (else (set! *image-format* 'gif) ".gif"))))

(define do-htmlimageformat
  (lambda ()
    (set! *image-format* (string->symbol (ungroup (get-group))))
    (set! *img-file-extn* (find-img-file-extn))))

(define do-htmlimgmagnification
  (lambda ()
    (set! *img-magnification* (string->number (ungroup (get-group))))))

(define call-tex
  (lambda (f)
    (let ((dvifile (string-append f ".dvi"))
          (call-to-tex
            (string-append
              (if (eq? *tex-format* 'latex) "la" "")
              "tex "
              f
              *bye-tex*)))
      (system call-to-tex)
      (and (file-exists? dvifile)
           (let ((logfile (string-append f ".log")))
             (or (not (file-exists? logfile))
                 (call-with-input-file
                   logfile
                   (lambda (i)
                     (let loop ()
                       (let ((x (read-line i)))
                         (cond
                          ((eof-object? x) #t)
                          ((substring? "! I can't find file" x) #f)
                          (else (loop)))))))))))))

(define ps-to-img/gif
  (lambda (ps-file f)
    (system
      (string-append
        *ghostscript*
        *ghostscript-options*
        " -sOutputFile="
        f
        ".ppm.1 "
        ps-file
        " quit.ps"))
    (system (string-append "pnmcrop " f ".ppm.1 > " f ".ppm.tmp"))
    '(unless (= *img-magnification* 1)
       (system
         (string-append
           "pbmpscale "
           (number->string *img-magnification*)
           " "
           f-ppm-tmp
           " > "
           f-ppm))
       (let ((swp f-ppm)) (set! f-ppm f-ppm-tmp) (set! f-ppm-tmp swp)))
    (system (string-append "ppmquant 256 < " f ".ppm.tmp > " f ".ppm"))
    (system
      (string-append
        "ppmtogif -transparent rgb:ff/ff/ff < "
        f
        ".ppm > "
        *aux-dir/*
        f
        ".gif"))
    (for-each
      (lambda (e) (ensure-file-deleted (string-append f e)))
      '(".ppm" ".ppm.tmp" ".ppm.1"))))

(define ps-to-img/png
  (lambda (ps-file f)
    (system
      (string-append
        *ghostscript*
        *ghostscript-options*
        " -sOutputFile="
        f
        ".ppm.1 "
        ps-file
        " quit.ps"))
    (system (string-append "pnmcrop " f ".ppm.1 > " f ".ppm.tmp"))
    '(system (string-append "ppmquant 256 < " f ".ppm.tmp > " f ".ppm"))
    (system
      (string-append
        "pnmtopng -interlace -transparent \"#FFFFFF\" "
        " < "
        f
        ".ppm.tmp > "
        *aux-dir/*
        f
        ".png"))
    (for-each
      (lambda (e) (ensure-file-deleted (string-append f e)))
      '(".ppm.1" ".ppm.tmp" ".ppm"))))

(define ps-to-img/jpeg
  (lambda (ps-file f)
    (system
      (string-append
        *ghostscript*
        *ghostscript-options*
        " -sOutputFile="
        f
        ".ppm.1 "
        ps-file
        " quit.ps"))
    (system (string-append "pnmcrop " f ".ppm.1 > " f ".ppm.tmp"))
    (system (string-append "ppmquant 256 < " f ".ppm.tmp > " f ".ppm"))
    (system
      (string-append
        "ppmtojpeg --grayscale < "
        f
        ".ppm > "
        *aux-dir/*
        f
        ".jpeg"))
    (for-each
      (lambda (e) (ensure-file-deleted (string-append f e)))
      '(".ppm.1" ".ppm.tmp" ".ppm"))))

(define ps-to-img
  (lambda (ps-file img-file-stem)
    ((case *image-format*
       ((gif) ps-to-img/gif)
       ((png) ps-to-img/png)
       ((jpeg) ps-to-img/jpeg)
       (else (terror 'ps-to-img) list))
     ps-file
     img-file-stem)))

(define tex-to-img
  (lambda (f)
    (set! *img-file-tally* (+ *img-file-tally* 1))
    (let ((f.img (string-append *aux-dir/* f *img-file-extn*)))
      (unless (file-exists? f.img)
        (write-log 'separation-space)
        (write-log #\{)
        (write-log (string-append f ".tex"))
        (write-log 'separation-space)
        (write-log "->")
        (write-log 'separation-space)
        (cond
         ((call-tex f)
          (system (string-append "dvips " f ".dvi -o " f ".ps"))
          (ps-to-img (string-append f ".ps") f)
          (write-log f.img)
          (for-each
            (lambda (e) (ensure-file-deleted (string-append f e)))
            '(".aux" ".dvi" ".log" ".ps" ".tex")))
         (else (write-log "failed, try manually")))
        (write-log #\})
        (write-log 'separation-space)))))

(define call-with-lazy-image-port
  (lambda (eps-file img-file-stem p)
    (let ((aux-tex-file (string-append img-file-stem ".tex")))
      (ensure-file-deleted aux-tex-file)
      (call-with-output-file
        aux-tex-file
        (lambda (o) (dump-tex-preamble o) (p o) (dump-tex-postamble o)))
      (if (file-exists? eps-file)
        (tex-to-img img-file-stem)
        (set! *missing-eps-files*
          (cons (cons eps-file img-file-stem) *missing-eps-files*))))))

(define retry-lazy-image
  (lambda (eps-file img-file-stem)
    (cond
     ((file-exists? eps-file) (tex-to-img img-file-stem))
     (else
      (write-log "! I can't find EPS file ")
      (write-log eps-file)
      (write-log 'separation-newline)))))

(define lazily-make-epsf-image-file
  (lambda (eps-file img-file-stem)
    (fluid-let
      ((*imgpreamble-inferred* (cons 'epsfbox *imgpreamble-inferred*)))
      (call-with-lazy-image-port
        eps-file
        img-file-stem
        (lambda (o)
          (display "\\epsfbox{" o)
          (display eps-file o)
          (display #\} o))))))

(define do-epsf-size
  (lambda (x)
    (get-equal-sign)
    (let ((n (get-pixels)))
      (case x ((x) (set! *epsf-xsize* n)) ((y) (set! *epsf-ysize* n))))))

(define do-epsfbox
  (lambda ()
    (let* ((b (get-bracketed-text-if-any)) (f (get-filename-possibly-braced)))
      (unless *eval-for-tex-only?*
        (cond
         ((and (not *epsf-xsize*) (not *epsf-ysize*))
          (let ((img-file-stem (next-html-image-file-stem)))
            (lazily-make-epsf-image-file f img-file-stem)
            (source-img-file img-file-stem)))
         (else
          (fluid-let
            ((*imgpreamble-inferred* (cons 'epsfbox *imgpreamble-inferred*)))
            (call-with-html-image-port
              (lambda (o)
                (when *epsf-xsize*
                  (display "\\epsfxsize=" o)
                  (display *epsf-xsize* o)
                  (set! *epsf-xsize* #f)
                  (display "bp" o)
                  (newline o))
                (when *epsf-ysize*
                  (display "\\epsfysize=" o)
                  (display *epsf-ysize* o)
                  (set! *epsf-ysize* #f)
                  (display "bp" o)
                  (newline o))
                (display "\\epsfbox{" o)
                (display f o)
                (display #\} o))))))))))

(define do-epsfig
  (lambda ()
    (fluid-let
      ((*imgpreamble-inferred* (cons 'epsfbox *imgpreamble-inferred*)))
      (call-with-html-image-port
        (lambda (o)
          (display "\\epsfig{" o)
          (dump-groupoid o)
          (display #\} o))))))

(define do-convertmptopdf
  (lambda ()
    (let ((f (get-filename-possibly-braced))
          (img-file-stem (next-html-image-file-stem)))
      (get-token)
      (get-token)
      (lazily-make-epsf-image-file f img-file-stem)
      (source-img-file img-file-stem))))

(define do-includegraphics
  (lambda ()
    (let* ((star? (eat-star))
           (b1 (get-bracketed-text-if-any))
           (b2 (and b1 (get-bracketed-text-if-any)))
           (f (get-filename-possibly-braced))
           (img-file-stem (next-html-image-file-stem))
           (ffull
            (if (file-exists? f)
              f
              (ormap
               (lambda (e)
                 (let ((f2 (string-append f e))) (and (file-exists? f2) f2)))
               *graphics-file-extensions*))))
      (fluid-let
        ((*imgpreamble-inferred*
           (cons 'includegraphics *imgpreamble-inferred*)))
        (call-with-lazy-image-port
          (or ffull f)
          img-file-stem
          (lambda (o)
            (display "\\includegraphics" o)
            (if star? (display #\* o))
            (when b1 (display #\[ o) (display b1 o) (display #\] o))
            (when b2 (display #\[ o) (display b2 o) (display #\] o))
            (display #\{ o)
            (display f o)
            (display #\} o))))
      (source-img-file img-file-stem))))

(define do-resizebox
  (lambda ()
    (let* ((arg1 (get-group)) (arg2 (get-group)) (arg3 (get-group)))
      (fluid-let
        ((*imgpreamble-inferred*
           (cons 'includegraphics *imgpreamble-inferred*)))
        (call-with-html-image-port
          (lambda (o)
            (display "\\resizebox" o)
            (display arg1 o)
            (display arg2 o)
            (display arg3 o)))))))

(define do-mfpic-opengraphsfile
  (lambda ()
    (set! *mfpic-file-stem* (get-filename-possibly-braced))
    (when *mfpic-port* (close-output-port *mfpic-port*))
    (let ((f (string-append *mfpic-file-stem* *mfpic-tex-file-suffix*)))
      (ensure-file-deleted f)
      (set! *mfpic-port* (open-output-file f)))
    (set! *mfpic-file-num* 0)
    (display "\\input mfpic \\usemetapost " *mfpic-port*)
    (newline *mfpic-port*)
    (display "\\opengraphsfile{" *mfpic-port*)
    (display *mfpic-file-stem* *mfpic-port*)
    (display #\} *mfpic-port*)
    (newline *mfpic-port*)
    (tex-def-prim
      "\\headshape"
      (lambda ()
        (let* ((g1 (get-group)) (g2 (get-group)) (g3 (get-group)))
          (display "\\headshape" *mfpic-port*)
          (display g1 *mfpic-port*)
          (display g2 *mfpic-port*)
          (display g3 *mfpic-port*)
          (newline *mfpic-port*))))
    (tex-def-prim "\\mfpframesep" eat-dimen)
    (tex-def-prim "\\mftitle" get-group)))

(define do-mfpic-closegraphsfile
  (lambda ()
    (display "\\closegraphsfile" *mfpic-port*)
    (newline *mfpic-port*)
    (close-output-port *mfpic-port*)
    (let ((tex-f (string-append *mfpic-file-stem* *mfpic-tex-file-suffix*))
          (mp-f (string-append *mfpic-file-stem* ".mp")))
      (unless (file-exists? mp-f)
        (fluid-let ((*tex-format* 'plain)) (call-tex tex-f)))
      (when (file-exists? mp-f)
        (system (string-append *metapost* " " *mfpic-file-stem*))))))

(define do-mfpic
  (lambda ()
    (display "\\mfpic" *mfpic-port*)
    (dump-till-end-env "mfpic" *mfpic-port*)
    (display "\\endmfpic" *mfpic-port*)
    (newline *mfpic-port*)
    (set! *mfpic-file-num* (+ *mfpic-file-num* 1))
    (let ((f
           (string-append
             *mfpic-file-stem*
             "."
             (number->string *mfpic-file-num*)))
          (img-file-stem (next-html-image-file-stem)))
      (lazily-make-epsf-image-file f img-file-stem)
      (source-img-file img-file-stem))))

(define do-following-latex-env-as-image
  (lambda () (do-latex-env-as-image (ungroup (get-group)) 'display)))

(define do-latex-env-as-image
  (lambda (env inline-or-display?)
    (when (char=? (snoop-actual-char) #\*)
      (get-actual-char)
      (set! env (string-append env "*")))
    (egroup)
    (when (eq? inline-or-display? 'display)
      (do-end-para)
      (emit "<div align=")
      (emit *display-justification*)
      (emit ">"))
    (call-with-html-image-port
      (lambda (o)
        (display "\\begin{" o)
        (display env o)
        (display "}" o)
        (dump-till-end-env env o)
        (display "\\end{" o)
        (display env o)
        (display "}" o)
        (newline o)))
    (when (eq? inline-or-display? 'display) (emit "</div>") (do-para))))

(define do-box
  (lambda ()
    (ignorespaces)
    (get-to)
    (eat-dimen)
    (ignorespaces)
    (let ((c (snoop-actual-char))) (case c ((#\{) #t) ((#\\) (get-ctl-seq))))
    (get-actual-char)
    (bgroup)
    (add-postlude-to-top-frame
      (let ((old-math-mode? *math-mode?*)
            (old-in-display-math? *in-display-math?*)
            (old-tabular-stack *tabular-stack*)
            (old-ligatures? *ligatures?*))
        (set! *math-mode?* #f)
        (set! *in-display-math?* #f)
        (set! *tabular-stack* '())
        (set! *ligatures?* #t)
        (lambda ()
          (set! *math-mode?* old-math-mode?)
          (set! *in-display-math?* old-in-display-math?)
          (set! *tabular-stack* old-tabular-stack)
          (set! *ligatures?* old-ligatures?))))))

(define do-latex-frac
  (lambda ()
    (emit "(")
    (tex2page-string (get-token))
    (emit "/")
    (tex2page-string (get-token))
    (emit ")")))

(define do-tex-frac
  (lambda ()
    (ignorespaces)
    (let ((inner-level?
            (or (not *in-display-math?*) (not (null? *tabular-stack*)))))
      (fluid-let
        ((*tabular-stack* (cons 'frac *tabular-stack*)))
        (cond
         (inner-level?
          (emit "<sup>")
          (tex2page-string (get-till-char #\/))
          (emit "</sup>/<sub>")
          (get-actual-char)
          (ignorespaces)
          (tex2page-string (get-token))
          (emit "</sub>"))
         (else
          (emit "</td><td><table align=left><tr><td align=center>")
          (tex2page-string (get-till-char #\/))
          (get-actual-char)
          (ignorespaces)
          (emit "<hr noshade>")
          (tex2page-string (get-token))
          (emit "</td></tr></table></td><td>")))))))

(define do-frac
  (lambda () ((if (eqv? *tex-format* 'latex) do-latex-frac do-tex-frac))))

(define do-eqno
  (lambda ()
    (unless *in-display-math?*
      (terror 'do-eqno "You can't use \\eqno in math mode"))
    (emit "</td><td width=10% align=right>")))

(define do-eqalign
  (lambda (type)
    (ignorespaces)
    (let ((c (get-actual-char)))
      (when (eof-object? c) (terror 'do-eqalign "Missing {"))
      (unless (char=? c #\{) (terror 'do-eqalign "Missing {"))
      (bgroup)
      (set! *tabular-stack* (cons type *tabular-stack*))
      (add-postlude-to-top-frame
        (lambda ()
          (emit "</td></tr>")
          (emit-newline)
          (emit "</table>")
          (emit-newline)
          (when *in-display-math?* (emit "</td><td>"))
          (pop-tabular-stack type)
          (set! *equation-position* 0)))
      (when *in-display-math?* (emit "</td><td>"))
      (emit-newline)
      (emit "<table><tr><td>"))))

(define do-noalign
  (lambda ()
    (let* ((type (and (not (null? *tabular-stack*)) (car *tabular-stack*)))
           (split? (memv type '(eqalignno displaylines))))
      (when split?
        (egroup)
        (emit "</td></tr></table></div>")
        (emit-newline)
        (do-para))
      (tex2page-string (get-group))
      (cond
       (split?
        (do-end-para)
        (emit-newline)
        (emit "<div align=center><table><tr><td>")
        (toss-back-char #\{)
        (do-eqalign type))
       (else (emit "</td></tr>") (emit-newline) (emit "<tr><td>"))))))

(define do-pmatrix
  (lambda ()
    (ignorespaces)
    (let ((c (get-actual-char)))
      (if (eof-object? c) (terror 'do-pmatrix "Missing {"))
      (unless (char=? c #\{) (terror 'do-pmatrix "Missing {"))
      (bgroup)
      (set! *tabular-stack* (cons 'pmatrix *tabular-stack*))
      (add-postlude-to-top-frame
        (lambda ()
          (emit "</td></tr></table>")
          (when *in-display-math?* (emit "</td><td>"))
          (emit-newline)
          (pop-tabular-stack 'pmatrix)))
      (when *in-display-math?* (emit "</td><td>"))
      (emit "<table border=1><tr><td>")
      (emit-newline))))

(define eat-till-eol
  (lambda ()
    (let loop ()
      (let ((c (get-actual-char)))
        (unless (or (eof-object? c) (char=? c #\newline)) (loop))))))

(define do-comment
  (lambda ()
    (eat-till-eol)
    (if (munched-a-newline?)
      (begin (toss-back-char #\newline) (toss-back-char #\newline)))))

(define latex-style-file?
  (lambda (f) (let ((e (file-extension f))) (and e (string-ci=? e ".sty")))))

(define path-to-list
  (lambda (p)
    (if (not p)
      '()
      (let loop ((p p) (r '()))
        (let ((i (string-index p *path-separator*)))
          (if i
            (loop
             (substring p (+ i 1) (string-length p))
             (cons (substring p 0 i) r))
            (reverse! (cons p r))))))))

(define kpsewhich
  (lambda (f)
    (let ((tmpf (string-append *aux-dir/* *jobname* "-Z-Z.temp")))
      (system (string-append "kpsewhich " f " > " tmpf))
      (let ((f (call-with-input-file tmpf (lambda (i) (read-line i)))))
        (delete-file tmpf)
        (if (eof-object? f)
          #f
          (let ((f (string-trim-blanks f)))
            (cond
             ((= (string-length f) 0) #f)
             ((file-exists? f) f)
             (else #f))))))))

(define find-tex-file
  (lambda (file)
    (let ((files (list (string-append file ".tex") file)))
      (or (ormap (lambda (file) (and (file-exists? file) file)) files)
          (if (not (null? *tex2page-inputs*))
            (ormap
             (lambda (dir)
               (ormap
                (lambda (file)
                  (let ((qfile (string-append dir *directory-separator* file)))
                    (and (file-exists? qfile) qfile)))
                files))
             *tex2page-inputs*)
            (kpsewhich file))))))

(define actual-tex-filename
  (lambda (f check-timestamp?)
    (let ((doing-main-file? (not *main-tex-file*)) (f2 (find-tex-file f)))
      (when (and doing-main-file? f2)
        (set! *jobname* (file-stem-name f2))
        (make-target-dir)
        (initialize-global-texframe))
      (when doing-main-file? (load-aux-file))
      (when (and f2 check-timestamp?) (update-last-modification-time f2))
      f2)))

(define add-dot-tex-if-no-extension-provided
  (lambda (f)
    (let ((e (file-extension f))) (if e f (string-append f ".tex")))))

(define ignore-tex-specific-text
  (lambda (env)
    (let ((endenv (string-append "\\end" env)))
      (let loop ()
        (let ((c (snoop-actual-char)))
          (cond
           ((eof-object? c)
            (terror 'ignore-tex-specific-text "Missing \\end" env))
           ((char=? c *esc-char*)
            (let ((x (get-ctl-seq)))
              (cond
               ((string=? x endenv) #t)
               ((string=? x "\\end")
                (let ((g (get-grouped-environment-name-if-any)))
                  (unless (and g (string=? g env)) (loop))))
               (else (loop)))))
           (else (get-actual-char) (loop))))))))

(define do-rawhtml
  (lambda ()
    (let loop ()
      (let ((c (snoop-actual-char)))
        (cond
         ((eof-object? c) (terror 'do-rawhtml "Missing \\endrawhtml"))
         ((char=? c *esc-char*)
          (let* ((x (get-ctl-seq)) (y (find-corresp-prim x)))
            (cond
             ((string=? y "\\endrawhtml") 'done)
             ((and (string=? x "\\end") (get-grouped-environment-name-if-any))
              =>
              (lambda (g)
                (let ((y (find-corresp-prim (string-append x g))))
                  (if (string=? y "\\endrawhtml")
                    'done
                    (begin (emit "\\end{") (emit g) (emit "}") (loop))))))
             ((string=? x "\\\\") (emit c) (toss-back-char c) (loop))
             (else (emit x) (loop)))))
         (else (get-actual-char) (emit c) (loop)))))))

(define do-htmlheadonly
  (lambda ()
    (when (null? *html-head*) (flag-missing-piece 'html-head))
    (let loop ((s '()))
      (let ((c (snoop-actual-char)))
        (cond
         ((eof-object? c)
          (write-aux `(!html-head ,(list->string (reverse! s)))))
         ((char=? c *esc-char*)
          (write-aux `(!html-head ,(list->string (reverse! s))))
          (let ((x (get-ctl-seq)))
            (cond
             ((string=? x "\\endhtmlheadonly") 'done)
             ((string=? x "\\input")
              (let ((f (get-filename-possibly-braced)))
                (call-with-input-file/buffered f do-htmlheadonly)
                (loop '())))
             (else (write-aux `(!html-head ,x)) (loop '())))))
         (else (get-actual-char) (loop (cons c s))))))))

(define resolve-chardefs
  (lambda (c)
    (cond
     ((find-chardef c)
      =>
      (lambda (y)
        (get-actual-char)
        (expand-tex-macro (cdef.optarg y) (cdef.argpat y) (cdef.expansion y))))
     (else #f))))

(define resolve-defs
  (lambda (x)
    (cond
     ((find-def x)
      =>
      (lambda (y)
        (cond
         ((tdef.defer y) => (lambda (z) z))
         ((tdef.thunk y) #f)
         (else
          (cond
           ((and (inside-false-world?)
                 (not (if-aware-ctl-seq? x))
                 (> (length (tdef.argpat y)) 0))
            #f)
           (else
            (expand-tex-macro
              (tdef.optarg y)
              (tdef.argpat y)
              (tdef.expansion y))))))))
     (else #f))))

(define do-expandafter
  (lambda ()
    (let* ((first (get-raw-token/is)) (second (get-raw-token/is)))
      (toss-back-char *invisible-space*)
      (cond
       ((ctl-seq? second)
        (toss-back-string (expand-ctl-seq-into-string second)))
       (else (toss-back-string second)))
      (toss-back-char *invisible-space*)
      (toss-back-string first))))

(define set-start-time
  (lambda ()
    (let* ((secs (current-seconds)) (ht (and secs (seconds->date secs))))
      (cond
       (ht
        (tex-def-count "\\time" (+ (* 60 (date-hour ht)) (date-minute ht)) #t)
        (tex-def-count "\\day" (date-day ht) #t)
        (tex-def-count "\\month" (+ (date-month ht) (- 1) 1) #t)
        (tex-def-count "\\year" (+ 0 (date-year ht)) #t))
       (else
        (tex-def-count "\\time" 0 #t)
        (tex-def-count "\\day" 0 #t)
        (tex-def-count "\\month" 0 #t)
        (tex-def-count "\\year" 0 #t))))))

(define initialize-global-texframe
  (lambda ()
    (set-start-time)
    (tex-def-count "\\language" 256 #t)
    (tex-def-count "\\secnumdepth" -2 #t)
    (tex-def-count "\\tocdepth" -2 #t)
    (tex-def-count "\\footnotenumber" 0 #t)
    (tex-def-count "\\TIIPtabularborder" 1 #t)
    (tex-def-count "\\TIIPnestedtabularborder" 0 #t)
    (tex-def-count "\\TIIPobeyspacestrictly" 0 #t)
    (tex-def-count "\\errorcontextlines" 5 #t)
    (tex-def-toks "\\TIIPrecentlabelname" "" #t)
    (tex-def-toks "\\TIIPrecentlabelvalue" "" #t)
    (tex-def-toks "\\everypar" "" #t)
    (tex-def-dotted-count "figure" #f)
    (tex-def-dotted-count "table" #f)
    (tex-def-dotted-count "equation" #f)
    (tex-def "\\empty" '() "" #f #f "\\empty" #f *global-texframe*)))

(define find-def
  (lambda (ctlseq)
    (let ((c
           (or (ormap
                (lambda (fr)
                  (lassoc ctlseq (texframe.definitions fr) string=?))
                *tex-env*)
               (lassoc
                 ctlseq
                 (texframe.definitions *global-texframe*)
                 string=?)
               (lassoc
                 ctlseq
                 (texframe.definitions *primitive-texframe*)
                 string=?))))
      (and c (cdr c)))))

(define find-math-def
  (lambda (ctlseq)
    (let ((c
           (lassoc
             ctlseq
             (texframe.definitions *math-primitive-texframe*)
             string=?)))
      (and c (cdr c)))))

(define find-count
  (lambda (ctlseq)
    (or (ormap
         (lambda (fr) (lassoc ctlseq (texframe.counts fr) string=?))
         *tex-env*)
        (lassoc ctlseq (texframe.counts *global-texframe*) string=?)
        (lassoc ctlseq (texframe.counts *primitive-texframe*) string=?))))

(define find-toks
  (lambda (ctlseq)
    (or (ormap
         (lambda (fr) (lassoc ctlseq (texframe.toks fr) string=?))
         *tex-env*)
        (lassoc ctlseq (texframe.toks *global-texframe*) string=?)
        (lassoc ctlseq (texframe.toks *primitive-texframe*) string=?))))

(define find-dimen
  (lambda (ctlseq)
    (or (ormap
         (lambda (fr) (lassoc ctlseq (texframe.dimens fr) string=?))
         *tex-env*)
        (lassoc ctlseq (texframe.dimens *global-texframe*) string=?)
        (lassoc ctlseq (texframe.dimens *primitive-texframe*) string=?))))

(define get-toks
  (lambda (ctlseq)
    (cond ((find-toks ctlseq) => cadr) (else (terror 'get-toks)))))

(define the-count
  (lambda (ctlseq)
    (let ((dracula (find-count ctlseq)))
      (unless dracula (terror 'the-count))
      (cadr dracula))))

(define do-count=
  (lambda (z global?) (get-equal-sign) (tex-def-count z (get-number) global?)))

(define do-toks=
  (lambda (z global?) (get-equal-sign) (tex-def-toks z (get-group) global?)))

(define do-dimen=
  (lambda (z global?)
    (get-equal-sign)
    (ignorespaces)
    (if (char=? (snoop-actual-char) *esc-char*) (get-ctl-seq) (eat-dimen))))

(define get-gcount
  (lambda (ctlseq)
    (cadr (lassoc ctlseq (texframe.counts *global-texframe*) string=?))))

(define set-gcount! (lambda (ctlseq v) (tex-def-count ctlseq v #t)))

(define do-number (lambda () (emit (get-number))))

(define do-the
  (lambda ()
    (let ((ctlseq (get-ctl-seq)))
      (cond
       ((get-number-corresp-to-ctl-seq ctlseq) => emit)
       ((find-toks ctlseq) => (lambda (x) (tex2page-string (cadr x))))
       (else (trace-if #f "do-the failed"))))))

(define find-corresp-prim
  (lambda (ctlseq)
    (let ((y (find-def ctlseq))) (or (and y (tdef.defer y)) ctlseq))))

(define find-corresp-prim-thunk
  (lambda (ctlseq)
    (let ((y (find-def ctlseq)))
      (if (and y (tdef.thunk y)) (tdef.prim y) ctlseq))))

(define do-def
  (lambda (global?)
    (unless (inside-false-world?)
      (let* ((lhs (get-raw-token/is))
             (argpat (get-def-arguments lhs))
             (rhs (ungroup (get-group)))
             (frame (and global? *global-texframe*)))
        (if (ctl-seq? lhs)
          (tex-def lhs argpat rhs #f #f #f #f frame)
          (tex-def-char (string-ref lhs 0) argpat rhs frame))))))

(define do-newcount (lambda (global?) (tex-def-count (get-ctl-seq) 0 global?)))

(define do-newtoks (lambda (global?) (tex-def-toks (get-ctl-seq) "" global?)))

(define do-newdimen (lambda (global?) (tex-def-dimen (get-ctl-seq) global?)))

(define do-advance
  (lambda (global?)
    (let* ((ctlseq (get-ctl-seq)) (count (find-count ctlseq)))
      (get-by)
      (if count
        (tex-def-count ctlseq (+ (cadr count) (get-number)) global?)
        (eat-dimen)))))

(define do-multiply
  (lambda (global?)
    (let* ((ctlseq (get-ctl-seq)) (curr-val (cadr (find-count ctlseq))))
      (get-by)
      (tex-def-count ctlseq (* curr-val (get-number)) global?))))

(define do-divide
  (lambda (global?)
    (let* ((ctlseq (get-ctl-seq)) (curr-val (cadr (find-count ctlseq))))
      (get-by)
      (tex-def-count ctlseq (quotient curr-val (get-number)) global?))))

(define do-newcommand
  (lambda (renew?)
    (ignorespaces)
    (let* ((lhs (string-trim-blanks (ungroup (get-token))))
           (optarg #f)
           (argc
            (cond
             ((get-bracketed-text-if-any)
              =>
              (lambda (s)
                (cond
                 ((get-bracketed-text-if-any) => (lambda (s) (set! optarg s))))
                (string->number (string-trim-blanks s))))
             (else 0)))
           (rhs (ungroup (get-token)))
           (ok-to-def? (or renew? (not (find-def lhs)))))
      (tex-def lhs (latex-arg-num->plain-argpat argc) rhs optarg #f #f #f #f)
      (unless ok-to-def?
        (trace-if *tracingcommands?* lhs " already defined")))))

(define do-advancetally
  (lambda (global?)
    (let* ((ctlseq (get-ctl-seq))
           (increment
             (string->number (string-trim-blanks (ungroup (get-token))))))
      (tex-def
        ctlseq
        '()
        (number->string
          (+ (string->number (or (resolve-defs ctlseq) ctlseq)) increment))
        #f
        #f
        #f
        #f
        global?))))

(define do-newenvironment
  (lambda (renew?)
    (ignorespaces)
    (let* ((envname (string-trim-blanks (ungroup (get-token))))
           (bs-envname (string-append "\\" envname))
           (optarg #f)
           (argc
            (cond
             ((get-bracketed-text-if-any)
              =>
              (lambda (s)
                (cond
                 ((get-bracketed-text-if-any) => (lambda (s) (set! optarg s))))
                (string->number (string-trim-blanks s))))
             (else 0)))
           (beginning (string-append "\\begingroup " (ungroup (get-token))))
           (ending (string-append (ungroup (get-token)) "\\endgroup"))
           (ok-to-def? (or renew? (not (find-def bs-envname)))))
      (tex-def
        bs-envname
        (latex-arg-num->plain-argpat argc)
        beginning
        optarg
        #f
        #f
        #f
        #f)
      (tex-def (string-append "\\end" envname) '() ending #f #f #f #f #f)
      (unless ok-to-def? (trace-if #t "{" envname "} already defined")))))

(define tex-def-dotted-count
  (lambda (counter-name sec-num)
    (when sec-num
      (hash-table-put!
        *section-counter-dependencies*
        sec-num
        (cons
         counter-name
         (table-get *section-counter-dependencies* sec-num '()))))
    (hash-table-put!
      *dotted-counters*
      counter-name
      (make-counter 'within sec-num))))

(define do-newtheorem
  (lambda ()
    (let* ((env (ungroup (get-group)))
           (numbered-like (get-bracketed-text-if-any))
           (counter-name (or numbered-like env))
           (caption (ungroup (get-group)))
           (within (if numbered-like #f (get-bracketed-text-if-any)))
           (sec-num
             (and within (section-ctl-seq? (string-append "\\" within)))))
      (unless numbered-like (tex-def-dotted-count counter-name sec-num))
      (tex-def
        (string-append "\\" env)
        '()
        (string-append
          "\\par\\begingroup\\TIIPtheorem{"
          counter-name
          "}{"
          caption
          "}")
        #f
        #f
        #f
        #f
        *global-texframe*)
      (tex-def
        (string-append "\\end" env)
        '()
        "\\endgroup\\par"
        #f
        #f
        #f
        #f
        *global-texframe*))))

(define do-theorem
  (lambda ()
    (let* ((counter-name (ungroup (get-group)))
           (counter (table-get *dotted-counters* counter-name))
           (caption (ungroup (get-group))))
      (unless counter (terror 'do-theorem))
      (let ((new-counter-value (+ 1 (counter.value counter))))
        (set!counter.value counter new-counter-value)
        (let* ((thm-num
                 (let ((sec-num (counter.within counter)))
                   (if sec-num
                     (string-append
                       (section-counter-value sec-num)
                       "."
                       (number->string new-counter-value))
                     (number->string new-counter-value))))
               (lbl (string-append *html-node-prefix* "thm_" thm-num)))
          (tex-def-toks "\\TIIPrecentlabelname" lbl #f)
          (tex-def-toks "\\TIIPrecentlabelvalue" thm-num #f)
          (emit-anchor lbl)
          (emit-newline)
          (emit "<b>")
          (emit caption)
          (emit " ")
          (emit thm-num)
          (emit ".</b>")
          (emit-nbsp 2))))))

(define do-begin
  (lambda ()
    (cond
     ((get-grouped-environment-name-if-any)
      =>
      (lambda (env)
        (toss-back-char *invisible-space*)
        (toss-back-string (string-append "\\" env))
        (unless (ormap
                 (lambda (y) (string=? env y))
                 '("htmlonly"
                   "cssblock"
                   "document"
                   "latexonly"
                   "rawhtml"
                   "texonly"
                   "verbatim"
                   "verbatim*"))
          (toss-back-string "\\begingroup")
          (do-end-para))))
     (else (terror 'do-begin "\\begin not followed by environment name")))))

(define do-end
  (lambda ()
    (cond
     ((get-grouped-environment-name-if-any)
      =>
      (lambda (env)
        (toss-back-char *invisible-space*)
        (unless (ormap (lambda (y) (string=? env y)) '("htmlonly" "document"))
          (do-end-para)
          (toss-back-string "\\endgroup"))
        (toss-back-string (string-append "\\end" env))))
     (else (toss-back-char *invisible-space*) (toss-back-string "\\bye")))))

(define latex-arg-num->plain-argpat
  (lambda (n)
    (let loop ((n n) (s '()))
      (if (<= n 0)
        s
        (loop
         (- n 1)
         (cons #\# (cons (integer->char (+ *int-corresp-to-0* n)) s)))))))

(define do-let
  (lambda (global?)
    (unless (inside-false-world?)
      (ignorespaces)
      (let* ((lhs (get-ctl-seq))
             (rhs (begin (get-equal-sign) (get-raw-token/is)))
             (frame (and global? *global-texframe*)))
        (unless (and
                 (ormap
                  (lambda (z) (string=? lhs z))
                  '("\\texonly" "\\endtexonly"))
                 (string=? rhs "\\relax"))
          (if (ctl-seq? rhs)
            (tex-let lhs rhs frame)
            (tex-def lhs '() rhs #f #f #f #f frame)))))))

(define make-reusable-img
  (lambda (global?)
    (set! *imgdef-file-count* (+ *imgdef-file-count* 1))
    (ignorespaces)
    (let ((lhs (get-ctl-seq))
          (imgdef-file-stem
            (string-append
              *subjobname*
              *img-file-suffix*
              *imgdef-file-suffix*
              (number->string *imgdef-file-count*))))
      (dump-imgdef imgdef-file-stem)
      (tex-to-img imgdef-file-stem)
      (tex-def
        lhs
        '()
        (string-append "\\TIIPreuseimage{" imgdef-file-stem "}")
        #f
        #f
        #f
        #f
        (and global? *global-texframe*)))))

(define valid-img-file?
  (lambda (f)
    (and (file-exists? f)
         (or (call-with-input-file
               f
               (lambda (i) (not (eof-object? (read-char i)))))
             (begin (delete-file f) #f)))))

(define source-img-file
  (lambda (img-file-stem)
    (let* ((img-file (string-append img-file-stem *img-file-extn*))
           (f (string-append *aux-dir/* img-file)))
      (write-log #\()
      (write-log f)
      (write-log 'separation-space)
      (valid-img-file? f)
      (emit "<img src=\"")
      (emit img-file)
      (emit "\" border=\"0\" alt=\"[")
      (emit img-file)
      (emit "]\">")
      (write-log #\))
      (write-log 'separation-space)
      #t)))

(define source-scaled-image-file
  (lambda (image-file-stem ht wth)
    (let* ((image-file (string-append image-file-stem *img-file-extn*))
           (f (string-append *aux-dir/* image-file)))
      (write-log #\()
      (write-log f)
      (write-log 'separation-space)
      (valid-img-file? f)
      (emit "<img")
      (when ht (emit " height=") (emit ht))
      (when wth (emit " width=") (emit wth))
      (emit " src=\"")
      (emit image-file)
      (emit "\" border=\"0\">")
      (write-log #\))
      (write-log 'separation-space)
      #t)))

(define reuse-img (lambda () (source-img-file (ungroup (get-group)))))

(define get-def-arguments
  (lambda (lhs)
    (let aux ()
      (let ((c (snoop-actual-char)))
        (cond
         ((eof-object? c)
          (terror
            'get-def-arguments
            "EOF found while scanning definition of "
            lhs))
         ((char=? c #\{) '())
         (else
          (cond
           ((char=? c #\newline) (get-actual-char) (ignorespaces))
           ((char-whitespace? c) (ignorespaces) (set! c #\space))
           (else (get-actual-char)))
          (cons c (aux))))))))

(define get-till-char
  (lambda (c0)
    (list->string
      (reverse!
        (let loop ((s '()) (nesting 0) (escape? #f))
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) (terror 'get-till-char "File ended too soon"))
             (escape? (loop (cons (get-actual-char) s) nesting #f))
             ((char=? c c0) s)
             ((char=? c *esc-char*)
              (loop (cons (get-actual-char) s) nesting #t))
             ((char=? c #\{)
              (loop (cons (get-actual-char) s) (+ nesting 1) #f))
             ((char=? c #\})
              (loop (cons (get-actual-char) s) (- nesting 1) #f))
             ((> nesting 0) (loop (cons (get-actual-char) s) nesting #f))
             ((and (char-whitespace? c)
                   (not (char=? c0 #\newline))
                   (char-whitespace? c0))
              s)
             (else (loop (cons (get-actual-char) s) nesting #f)))))))))

(define digit->int (lambda (d) (- (char->integer d) *int-corresp-to-0*)))

(define do-halign
  (lambda ()
    (do-end-para)
    (ignorespaces)
    (let ((c (get-actual-char)))
      (if (eof-object? c) (terror 'do-halign "Missing {"))
      (unless (char=? c #\{) (terror 'do-halign "Missing {")))
    (fluid-let
      ((*tabular-stack* (cons 'halign *tabular-stack*)))
      (bgroup)
      (emit "<table>")
      (let ((tmplt (get-halign-template)))
        (let loop ()
          (ignorespaces)
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) (terror 'do-halign "Eof inside \\halign"))
             ((char=? c #\})
              (get-actual-char)
              (emit "</table>")
              (egroup)
              (do-para))
             (else (expand-halign-line tmplt) (loop)))))))))

(define get-halign-template
  (lambda ()
    (let loop ((s '()))
      (let ((x (get-raw-token)))
        (cond
         ((eof-object? x) (terror 'get-halign-template "Eof in \\halign"))
         ((string=? x "\\cr") (reverse! (cons #f s)))
         ((string=? x "#") (loop (cons #t s)))
         ((string=? x "&") (loop (cons #f s)))
         (else (loop (cons x s))))))))

(define expand-halign-line
  (lambda (tmplt)
    (emit "<tr>")
    (let loop ((tmplt tmplt) (ins " "))
      (let ((x (get-raw-token)))
        (cond
         ((eof-object? x) (terror 'expand-halign-line "Eof in \\halign"))
         ((or (string=? x "&") (string=? x "\\cr"))
          (let loop2 ((tmplt tmplt) (r "{"))
            (if (null? tmplt)
              (terror 'expand-halign-line "Eof in \\halign")
              (let ((y (car tmplt)))
                (case y
                  ((#f)
                   (emit "<td>")
                   (tex2page-string (string-append r "}"))
                   (emit "</td>")
                   (if (string=? x "\\cr")
                     (begin (emit "</tr>") (emit-newline))
                     (loop (cdr tmplt) " ")))
                  ((#t) (loop2 (cdr tmplt) (string-append r ins)))
                  (else (loop2 (cdr tmplt) (string-append r y))))))))
         (else (loop tmplt (string-append ins x))))))))

(define read-till-next-sharp
  (lambda (k argpat)
    (let ((n (length argpat)))
      (let loop ((ss '()))
        (let loop2 ((i k) (s '()))
          (let ((c (if (< i n) (list-ref argpat i) #\#)))
            (if (char=? c #\#)
              (cons i (list->string (reverse! ss)))
              (let ((d (snoop-actual-char)))
                (cond
                 ((and (char=? c #\space) (char-whitespace? d))
                  (if (char=? d #\newline) (get-actual-char) (ignorespaces))
                  (loop2 (+ i 1) (cons c s)))
                 ((and (char=? c #\newline)
                       (char-whitespace? d)
                       (or (munched-a-newline?) (begin (toss-back-char d) #f)))
                  (loop2 (+ i 1) (cons c s)))
                 ((char=? c d) (get-actual-char) (loop2 (+ i 1) (cons c s)))
                 ((= i k)
                  (loop
                   (if (and (char=? d #\{)
                            (or (null? ss) (not (char=? (car ss) *esc-char*))))
                     (append (get-group-as-reversed-chars) ss)
                     (begin
                       (if (and (char-whitespace? d)
                                (not (char=? d #\newline)))
                         (ignorespaces)
                         (get-actual-char))
                       (cons d ss)))))
                 (else (loop (append s ss))))))))))))

(define read-macro-args
  (lambda (argpat k r)
    (let ((n (length argpat)))
      (reverse!
        (let loop ((k k) (r r))
          (if (>= k n)
            r
            (let ((c (list-ref argpat k)))
              (cond
               ((char=? c #\#)
                (cond
                 ((= k (- n 1)) (cons (get-till-char #\{) r))
                 ((= k (- n 2)) (cons (ungroup (get-token)) r))
                 (else
                  (let ((c2 (list-ref argpat (+ k 2))))
                    (if (char=? c2 #\#)
                      (loop (+ k 2) (cons (ungroup (get-token)) r))
                      (let ((x (read-till-next-sharp (+ k 2) argpat)))
                        (loop (car x) (cons (cdr x) r))))))))
               (else
                (let ((d (get-actual-char)))
                  (cond
                   ((eof-object? d)
                    (terror
                      'read-macro-args
                      "Eof before macro got enough args"))
                   ((char=? c d) (loop (+ k 1) r))
                   (else
                    (terror
                      'read-macro-args
                      "Misformed macro call")))))))))))))

(define expand-tex-macro
  (lambda (optarg argpat rhs)
    (let* ((k 0)
           (r
            (if (not optarg)
              '()
              (begin
                (set! k 2)
                (list
                 (cond
                  ((get-bracketed-text-if-any) => (lambda (s) s))
                  (else optarg))))))
           (args (read-macro-args argpat k r))
           (rhs-n (string-length rhs)))
      (list->string
        (let aux ((k 0))
          (if (>= k rhs-n)
            '()
            (let ((c (string-ref rhs k)))
              (cond
               ((char=? c #\\)
                (let loop ((j (+ k 1)) (s (list #\\)))
                  (if (>= j rhs-n)
                    (reverse! s)
                    (let ((c (string-ref rhs j)))
                      (cond
                       ((char-alphabetic? c) (loop (+ j 1) (cons c s)))
                       ((and (char=? c #\#) (> (length s) 1))
                        (append (reverse! s) (cons #\space (aux j))))
                       ((= (length s) 1)
                        (append (reverse! (cons c s)) (aux (+ j 1))))
                       (else (append (reverse! s) (aux j))))))))
               ((char=? c #\#)
                (if (= k (- rhs-n 1))
                  (list #\#)
                  (let ((n (string-ref rhs (+ k 1))))
                    (cond
                     ((char=? n #\#) (cons #\# (aux (+ k 2))))
                     ((and (char-numeric? n) (<= (digit->int n) (length args)))
                      (append
                        (string->list (list-ref args (- (digit->int n) 1)))
                        (aux (+ k 2))))
                     (else (cons #\# (aux (+ k 1))))))))
               (else (cons c (aux (+ k 1))))))))))))

(define do-verbescapechar
  (lambda ()
    (ignorespaces)
    (let* ((c1 (get-actual-char)) (c2 (get-actual-char)))
      (unless (char=? c1 *esc-char*)
        (terror 'do-verbescapechar "Arg must be \\<char>"))
      (set! *esc-char-verb* c2))))

(define do-verb-braced
  (lambda (ignore)
    (fluid-let
      ((*esc-char* *esc-char-verb*) (*tex-extra-letters* '()))
      (let loop ((nesting 0))
        (let ((c (get-actual-char)))
          (cond
           ((eof-object? c) (terror 'do-verb-braced "Eof inside verbatim"))
           ((char=? c *esc-char*)
            (toss-back-char c)
            (let ((x (fluid-let ((*not-processing?* #t)) (get-ctl-seq))))
              (cond
               ((ormap (lambda (z) (string=? x z)) '("\\ " "\\{" "\\}"))
                (emit (string-ref x 1)))
               (else
                (fluid-let
                  ((*esc-char* *esc-char-std*))
                  (do-tex-ctl-seq-completely x)))))
            (loop nesting))
           ((char=? c #\{) (emit #\{) (loop (+ nesting 1)))
           ((char=? c #\})
            (unless (= nesting 0) (emit #\}) (loop (- nesting 1))))
           ((char=? c #\space)
            (if *verb-visible-space?* (emit-visible-space) (emit #\space))
            (loop nesting))
           ((char=? c #\newline)
            (cond
             (*verb-display?* (emit "&nbsp;") (emit-newline))
             (*verb-visible-space?* (emit-visible-space))
             (else (emit-newline)))
            (loop nesting))
           (else (emit-html-char c) (loop nesting))))))))

(define do-verb-delimed
  (lambda (d)
    (let loop ()
      (let ((c (get-actual-char)))
        (cond
         ((eof-object? c) (terror 'do-verb-delimed "Eof inside verbatim"))
         ((char=? c d) 'done)
         ((char=? c #\space)
          (if *verb-visible-space?* (emit-visible-space) (emit #\space))
          (loop))
         ((char=? c #\newline)
          (cond
           (*verb-display?* (emit "&nbsp;") (emit-newline))
           (*verb-visible-space?* (emit-visible-space))
           (else (emit-newline)))
          (loop))
         (else (emit-html-char c) (loop)))))))

(define do-verb
  (lambda ()
    (ignorespaces)
    (bgroup)
    (fluid-let
      ((*verb-visible-space?* (eat-star)) (*ligatures?* #f))
      (let ((d (get-actual-char)))
        (fluid-let
          ((*verb-display?* (munched-a-newline?)))
          (cond
           (*outputting-external-title?* #f)
           (*verb-display?* (do-end-para) (emit "<pre class=verbatim>"))
           (else (emit "<code class=verbatim>")))
          ((if (char=? d #\{) do-verb-braced do-verb-delimed) d)
          (cond
           (*outputting-external-title?* #f)
           (*verb-display?* (emit "</pre>") (do-para))
           (else (emit "</code>"))))))
    (egroup)))

(define do-verbc
  (lambda ()
    (ignorespaces)
    (bgroup)
    (fluid-let
      ((*ligatures?* #f))
      (emit "<code class=verbatim>")
      (emit-html-char (get-actual-char))
      (emit "</code>"))
    (egroup)))

(define do-verbatiminput
  (lambda ()
    (ignorespaces)
    (let ((f (get-filename-possibly-braced)))
      (cond
       ((file-exists? f)
        (do-end-para)
        (bgroup)
        (emit "<pre class=verbatim>")
        (call-with-input-file
          f
          (lambda (p)
            (let loop ()
              (let ((c (read-char p)))
                (unless (eof-object? c) (emit-html-char c) (loop))))))
        (emit "</pre>")
        (egroup)
        (do-para))
       (else (non-fatal-error "File " f " not found"))))))

(define do-verbwritefile
  (lambda ()
    (let ((f (get-filename-possibly-braced)))
      (when *verb-port* (close-output-port *verb-port*))
      (ensure-file-deleted f)
      (set! *verb-written-files* (cons f *verb-written-files*))
      (let ((e (file-extension f)))
        (when (and e (string-ci=? e ".mp"))
          (set! *mp-files* (cons f *mp-files*))))
      (set! *verb-port* (open-output-file f)))))

(define verb-ensure-output-port
  (lambda ()
    (unless *verb-port*
      (let ((output-file (string-append *jobname* ".txt")))
        (ensure-file-deleted output-file)
        (set! *verb-port* (open-output-file output-file))))))

(define dump-groupoid
  (lambda (p)
    (ignorespaces)
    (let ((d (get-actual-char)))
      (case d
        ((#\{)
         (let loop ((nesting 0))
           (let ((c (get-actual-char)))
             (cond
              ((eof-object? c) (terror 'dump-groupoid "Eof inside verbatim"))
              ((char=? c *esc-char-verb*)
               (write-char c p)
               (write-char (get-actual-char) p)
               (loop nesting))
              ((char=? c #\{) (write-char c p) (loop (+ nesting 1)))
              ((char=? c #\})
               (unless (= nesting 0) (write-char c p) (loop (- nesting 1))))
              (else (write-char c p) (loop nesting))))))
        (else
         (let loop ()
           (let ((c (get-actual-char)))
             (cond
              ((eof-object? c) (terror 'dump-groupoid "Eof inside verbatim"))
              ((char=? c d) 'done)
              (else (write-char c p) (loop))))))))))

(define do-makehtmlimage
  (lambda ()
    (ignorespaces)
    (unless (char=? (snoop-actual-char) #\{)
      (terror 'do-makehtmlimage "\\makehtmlimage's argument must be a group"))
    (call-with-html-image-port dump-groupoid)))

(define do-verbwrite
  (lambda () (verb-ensure-output-port) (dump-groupoid *verb-port*)))

(define do-string
  (lambda ()
    (let ((c (snoop-actual-char)))
      (cond
       ((eof-object? c) #f)
       ((char=? c *esc-char*)
        (get-actual-char)
        (toss-back-char *invisible-space*)
        (toss-back-string "\\TIIPbackslash"))
       ((char=? c *comment-char*) (eat-till-eol) (do-string))
       (else (toss-back-char (get-actual-char)))))))

(define do-verbatim-latex
  (lambda ()
    (do-end-para)
    (bgroup)
    (fluid-let
      ((*verb-visible-space?* (eat-star)))
      (emit "<pre class=verbatim>")
      (munched-a-newline?)
      (fluid-let
        ((*ligatures?* #f))
        (let loop ()
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c)
              (terror 'do-verbatim-latex "Eof inside verbatim"))
             ((char=? c #\\)
              (let ((end? (get-ctl-seq)))
                (if (string=? end? "\\end")
                  (cond
                   ((get-grouped-environment-name-if-any)
                    =>
                    (lambda (e)
                      (unless (or
                               (and (not *verb-visible-space?*)
                                    (string=? e "verbatim"))
                               (and *verb-visible-space?*
                                    (string=? e "verbatim*")))
                        (emit-html-string end?)
                        (emit-html-char #\{)
                        (emit-html-string e)
                        (emit-html-char #\})
                        (loop))))
                   (else (emit-html-string end?) (loop)))
                  (begin (emit-html-string end?) (loop)))))
             ((char=? c #\space)
              (get-actual-char)
              (if *verb-visible-space?*
                (emit "<font color=red>&middot;</font>")
                (emit #\space))
              (loop))
             (else (emit-html-char (get-actual-char)) (loop))))))
      (emit "</pre>"))
    (egroup)
    (do-para)))

(define do-alltt
  (lambda ()
    (do-end-para)
    (bgroup)
    (emit "<pre class=verbatim>")
    (munched-a-newline?)
    (fluid-let
      ((*in-alltt?* #t))
      (let loop ()
        (let ((c (snoop-actual-char)))
          (if (eof-object? c)
            (terror 'do-alltt "Eof inside alltt")
            (begin
              (case c
                ((#\\) (do-tex-ctl-seq (get-ctl-seq)))
                ((#\{) (get-actual-char) (bgroup))
                ((#\}) (get-actual-char) (egroup))
                (else (emit-html-char (get-actual-char))))
              (if *in-alltt?* (loop)))))))))

(define do-end-alltt
  (lambda () (emit "</pre>") (egroup) (do-para) (set! *in-alltt?* #f)))

(define *scm-special-symbols* (make-table 'equ string=?))

(define do-scm-set-specialsymbol
  (lambda ()
    (let* ((sym (get-peeled-group)) (xln (get-group)))
      (hash-table-put! *scm-special-symbols* sym xln))))

(define do-scm-unset-specialsymbol
  (lambda ()
    (call-with-input-string/buffered
      (ungroup (get-group))
      (lambda ()
        (let loop ()
          (ignore-all-whitespace)
          (unless (eof-object? (snoop-actual-char))
            (hash-table-put! *scm-special-symbols* (scm-get-token) #f)
            (loop)))))))

(define do-scm-set-builtins
  (lambda ()
    (call-with-input-string/buffered
      (ungroup (get-group))
      (lambda ()
        (let loop ()
          (ignore-all-whitespace)
          (let ((c (snoop-actual-char)))
            (unless (eof-object? c)
              (let ((s (scm-get-token)))
                (set! *scm-keywords* (ldelete s *scm-keywords* string=?))
                (set! *scm-variables* (ldelete s *scm-variables* string=?))
                (set! *scm-builtins* (cons s *scm-builtins*)))
              (loop))))))))

(define do-scm-set-keywords
  (lambda ()
    (call-with-input-string/buffered
      (ungroup (get-group))
      (lambda ()
        (let loop ()
          (ignore-all-whitespace)
          (let ((c (snoop-actual-char)))
            (unless (eof-object? c)
              (let ((s (scm-get-token)))
                (set! *scm-builtins* (ldelete s *scm-builtins* string=?))
                (set! *scm-variables* (ldelete s *scm-variables* string=?))
                (set! *scm-keywords* (cons s *scm-keywords*)))
              (loop))))))))

(define do-scm-set-variables
  (lambda ()
    (call-with-input-string/buffered
      (ungroup (get-group))
      (lambda ()
        (let loop ()
          (ignore-all-whitespace)
          (let ((c (snoop-actual-char)))
            (unless (eof-object? c)
              (let ((s (scm-get-token)))
                (set! *scm-builtins* (ldelete s *scm-builtins* string=?))
                (set! *scm-keywords* (ldelete s *scm-keywords* string=?))
                (set! *scm-variables* (cons s *scm-variables*)))
              (loop))))))))

(define scm-emit-html-char
  (lambda (c)
    (unless (eof-object? c)
      (when *scm-dribbling?* (write-char c *verb-port*))
      (emit-html-char c))))

(define scm-output-next-chunk
  (lambda ()
    (let ((c (snoop-actual-char)))
      (cond
       ((and *slatex-math-escape* (char=? c *slatex-math-escape*))
        (scm-escape-into-math))
       ((char=? c #\;) (scm-output-comment) (do-end-para))
       ((char=? c #\") (scm-output-string))
       ((char=? c #\#) (scm-output-hash))
       ((char=? c #\,)
        (get-actual-char)
        (emit "<span class=keyword>")
        (scm-emit-html-char c)
        (let ((c (snoop-actual-char)))
          (when (char=? c #\@) (get-actual-char) (scm-emit-html-char c)))
        (emit "</span>"))
       ((or (char=? c #\') (char=? c #\`))
        (get-actual-char)
        (emit "<span class=keyword>")
        (scm-emit-html-char c)
        (emit "</span>"))
       ((or (char-whitespace? c) (memv c *scm-token-delims*))
        (get-actual-char)
        (scm-emit-html-char c))
       (else (scm-output-token (scm-get-token)))))))

(define scm-set-mathescape
  (lambda (yes?)
    (let ((c
           (fluid-let
             ((*esc-char* (integer->char 0)))
             (string-ref (ungroup (get-group)) 0))))
      (cond
       (yes?
        (set! *slatex-math-escape* c)
        (set! *scm-token-delims*
          (cons *slatex-math-escape* *scm-token-delims*)))
       (else
        (set! *slatex-math-escape* #f)
        (set! *scm-token-delims* (ldelete c *scm-token-delims* char=?)))))))

(define scm-escape-into-math
  (lambda ()
    (get-actual-char)
    (let ((math-text (get-till-char *slatex-math-escape*)))
      (get-actual-char)
      (emit "<span class=variable>")
      (fluid-let
        ((*esc-char* *esc-char-std*))
        (tex2page-string (string-append "$" math-text "$")))
      (emit "</span>"))))

(define scm-output-slatex-comment
  (lambda ()
    (let ((s (get-line)))
      (emit "<span class=comment>")
      (when *scm-dribbling?* (display s *verb-port*) (newline *verb-port*))
      (fluid-let ((*esc-char* *esc-char-std*)) (tex2page-string s))
      (do-end-para)
      (emit "</span>")
      (toss-back-char #\newline))))

(define scm-output-verbatim-comment
  (lambda ()
    (emit "<span class=comment>")
    (let loop ()
      (let ((c (get-actual-char)))
        (cond
         ((or (eof-object? c) (char=? c #\newline))
          (emit "</span>")
          (scm-emit-html-char c))
         ((and (char-whitespace? c)
               (let ((c2 (snoop-actual-char)))
                 (or (eof-object? c2) (char=? c2 #\newline))))
          (emit "</span>")
          (scm-emit-html-char (get-actual-char)))
         (else (scm-emit-html-char c) (loop)))))))

(define scm-output-comment
  (lambda ()
    ((if *slatex-like-comments?*
       scm-output-slatex-comment
       scm-output-verbatim-comment))))

(define scm-output-extended-comment
  (lambda ()
    (get-actual-char)
    (emit "<span class=comment>")
    (scm-emit-html-char #\#)
    (scm-emit-html-char #\|)
    (let loop ()
      (let ((c (get-actual-char)))
        (cond
         ((eof-object? c) #t)
         ((char=? c #\|)
          (let ((c2 (snoop-actual-char)))
            (cond
             ((eof-object? c2) (scm-emit-html-char c))
             ((char=? c2 #\#) (get-actual-char))
             (else (scm-emit-html-char c) (loop)))))
         (else (scm-emit-html-char c) (loop)))))
    (scm-emit-html-char #\|)
    (scm-emit-html-char #\#)
    (emit "</span>")))

(define scm-output-string
  (lambda ()
    (get-actual-char)
    (emit "<span class=selfeval>")
    (scm-emit-html-char #\")
    (let loop ((esc? #f))
      (let ((c (get-actual-char)))
        (case c
          ((#\") (when esc? (scm-emit-html-char c) (loop #f)))
          ((#\\) (scm-emit-html-char c) (loop (not esc?)))
          (else (scm-emit-html-char c) (loop #f)))))
    (scm-emit-html-char #\")
    (emit "</span>")))

(define scm-output-hash
  (lambda ()
    (get-actual-char)
    (let ((c (snoop-actual-char)))
      (cond
       ((eof-object? c)
        (emit "<span class=selfeval>")
        (scm-emit-html-char #\#)
        (emit "</span>"))
       ((char=? c #\|) (scm-output-extended-comment))
       (else (toss-back-char #\#) (scm-output-token (scm-get-token)))))))

(define scm-output-token
  (lambda (s)
    (case (scm-get-type s)
      ((special-symbol)
       (fluid-let
         ((*esc-char* *esc-char-std*))
         (tex2page-string (table-get *scm-special-symbols* s))))
      ((keyword)
       (emit "<span class=keyword>")
       (scm-display-token s)
       (emit "</span>"))
      ((global)
       (emit "<span class=global>")
       (scm-display-token s)
       (emit "</span>"))
      ((selfeval)
       (emit "<span class=selfeval>")
       (scm-display-token s)
       (emit "</span>"))
      ((builtin)
       (emit "<span class=builtin>")
       (scm-display-token s)
       (emit "</span>"))
      ((background) (scm-display-token s))
      (else
       (emit "<span class=variable>")
       (scm-display-token s)
       (emit "</span>")))))

(define scm-display-token
  (lambda (s)
    (let ((n (string-length s)))
      (let loop ((k 0))
        (when (< k n) (scm-emit-html-char (string-ref s k)) (loop (+ k 1)))))))

(define do-scm-braced
  (lambda (result?)
    (get-actual-char)
    (let ((display? (munched-a-newline?)))
      (cond
       ((not display?)
        (emit "<code class=scheme")
        (when result? (emit "response"))
        (emit ">"))
       (else (do-end-para) (emit "<pre class=scheme>")))
      (bgroup)
      (fluid-let
        ((*esc-char* *esc-char-verb*) (*verb-display?* display?))
        (let loop ((nesting 0))
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) (terror 'do-scm-braced "Eof inside verbatim"))
             ((char=? c *esc-char*)
              (let ((x (fluid-let ((*not-processing?* #t)) (get-ctl-seq))))
                (cond
                 ((ormap (lambda (z) (string=? x z)) '("\\ " "\\{" "\\}"))
                  (scm-emit-html-char (string-ref x 1)))
                 (else
                  (fluid-let
                    ((*esc-char* *esc-char-std*))
                    (do-tex-ctl-seq-completely x)))))
              (loop nesting))
             ((char=? c #\{)
              (get-actual-char)
              (scm-emit-html-char c)
              (loop (+ nesting 1)))
             ((char=? c #\})
              (get-actual-char)
              (unless (= nesting 0)
                (scm-emit-html-char c)
                (loop (- nesting 1))))
             (else (scm-output-next-chunk) (loop nesting))))))
      (egroup)
      (if (not display?) (emit "</code>") (begin (emit "</pre>") (do-para))))))

(define do-scm-delimed
  (lambda (result?)
    (let ((d (get-actual-char)))
      (let ((display? (munched-a-newline?)))
        (cond
         ((not display?)
          (emit "<code class=scheme")
          (when result? (emit "response"))
          (emit ">"))
         (else (do-end-para) (emit "<pre class=scheme>")))
        (fluid-let
          ((*verb-display?* display?)
           (*scm-token-delims* (cons d *scm-token-delims*)))
          (let loop ()
            (let ((c (snoop-actual-char)))
              (cond
               ((eof-object? c) (terror 'do-scm-delimed "Eof inside verbatim"))
               ((char=? c d) (get-actual-char))
               (else (scm-output-next-chunk) (loop))))))
        (if (not display?)
          (emit "</code>")
          (begin (emit "</pre>") (do-para)))))))

(define do-scm
  (lambda (result?)
    (cond
     (*outputting-external-title?* (do-verb))
     (else
      (ignorespaces)
      (bgroup)
      (fluid-let
        ((*ligatures?* #f))
        ((if (char=? (snoop-actual-char) #\{) do-scm-braced do-scm-delimed)
         result?))
      (egroup)))))

(define do-scminput
  (lambda ()
    (ignorespaces)
    (do-end-para)
    (bgroup)
    (emit "<pre class=scheme>")
    (let ((f (get-filename-possibly-braced)))
      (call-with-input-file/buffered
        f
        (lambda ()
          (let loop ()
            (let ((c (snoop-actual-char)))
              (unless (eof-object? c) (scm-output-next-chunk) (loop)))))))
    (emit "</pre>")
    (egroup)
    (do-para)))

(define do-scmdribble
  (lambda ()
    (verb-ensure-output-port)
    (fluid-let ((*scm-dribbling?* #t)) (do-scm #f))
    (newline *verb-port*)))

(define do-scm-slatex-lines
  (lambda (env display? result?)
    (let ((endenv (string-append "\\end" env))
          (in-table?
            (and (not (null? *tabular-stack*))
                 (memv (car *tabular-stack*) '(block figure table)))))
      (cond (display? (do-end-para)) (in-table? (emit "</td><td>")))
      (munched-a-newline?)
      (bgroup)
      (emit "<div align=left><pre class=scheme")
      (when result? (emit "response"))
      (emit ">")
      (fluid-let
        ((*ligatures?* #f) (*verb-display?* #t) (*not-processing?* #t))
        (let loop ()
          (let ((c (snoop-actual-char)))
            (cond
             ((eof-object? c) (terror 'do-scm-slatex-lines "Eof inside " env))
             ((char=? c #\newline)
              (get-actual-char)
              (scm-emit-html-char c)
              (cond
               ((not *slatex-like-comments?*) #f)
               ((char=? (snoop-actual-char) #\;)
                (get-actual-char)
                (if (char=? (snoop-actual-char) #\;)
                  (toss-back-char #\;)
                  (scm-output-slatex-comment))))
              (loop))
             ((char=? c *esc-char*)
              (let ((x (get-ctl-seq)))
                (cond
                 ((string=? x endenv) #t)
                 ((string=? x "\\end")
                  (let ((g (get-grouped-environment-name-if-any)))
                    (if (and g (string=? g env))
                      (egroup)
                      (begin
                        (scm-output-token x)
                        (when g
                          (scm-output-token "{")
                          (scm-output-token g)
                          (scm-output-token "}"))
                        (loop)))))
                 (else (scm-output-token x) (loop)))))
             (else (scm-output-next-chunk) (loop))))))
      (emit "</pre></div>")
      (egroup)
      (cond (display? (do-para)) (in-table? (emit "</td><td>"))))))

(define string-is-all-dots?
  (lambda (s)
    (let ((n (string-length s)))
      (let loop ((i 0))
        (cond
         ((>= i n) #t)
         ((char=? (string-ref s i) #\.) (loop (+ i 1)))
         (else #f))))))

(define string-is-flanked-by-stars?
  (lambda (s)
    (let ((n (string-length s)))
      (and (>= n 3)
           (char=? (string-ref s 0) #\*)
           (char=? (string-ref s (- n 1)) #\*)))))

(define string-starts-with-hash? (lambda (s) (char=? (string-ref s 0) #\#)))

(define scm-get-type
  (lambda (s)
    (cond
     ((table-get *scm-special-symbols* s) 'special-symbol)
     ((member/string-ci=? s *scm-keywords*) 'keyword)
     ((member/string-ci=? s *scm-builtins*) 'builtin)
     ((member/string-ci=? s *scm-variables*) 'variable)
     ((string-is-flanked-by-stars? s) 'global)
     (else
      (let ((colon (string-index s #\:)))
        (cond
         (colon (if (= colon 0) 'selfeval 'variable))
         ((string-is-all-dots? s) 'background)
         ((string-starts-with-hash? s) 'selfeval)
         ((string->number s) 'selfeval)
         (else 'variable)))))))

(define eat-star
  (lambda ()
    (let ((c (snoop-actual-char)))
      (if (and (not (eof-object? c)) (char=? c #\*)) (get-actual-char) #f))))

(define do-cr
  (lambda (z)
    (ignorespaces)
    (let ((top-tabular
            (if (not (null? *tabular-stack*)) (car *tabular-stack*) 'nothing)))
      (case top-tabular
        ((tabular)
         (get-bracketed-text-if-any)
         (egroup)
         (emit "</td></tr>")
         (emit-newline)
         (emit "<tr><td valign=top ")
         (do-tabular-multicolumn))
        ((eqnarray*)
         (emit "</td></tr>")
         (emit-newline)
         (set! *equation-position* 0)
         (emit "<tr><td align=right>"))
        ((eqnarray)
         (emit "</td>")
         (cond
          (*equation-numbered?*
           (emit "<td>(")
           (emit *equation-number*)
           (bump-dotted-counter "equation")
           (emit ")</td>"))
          (else (set! *equation-numbered?* #t)))
         (emit "</tr>")
         (emit-newline)
         (set! *equation-position* 0)
         (emit "<tr><td align=right>"))
        ((ruled-table) (emit "</td></tr>") (emit-newline) (emit "<tr><td>"))
        ((minipage tabbing)
         (get-bracketed-text-if-any)
         (emit "<br>")
         (emit-newline))
        ((eqalign eqalignno displaylines pmatrix)
         (unless (char=? (snoop-actual-char) #\})
           (emit "</td></tr>")
           (emit-newline)
           (emit "<tr><td>")
           (set! *equation-position* 0)
           (emit-newline)))
        ((header) (emit #\space))
        (else
         (when (and (eqv? *tex-format* 'latex) (string=? z "\\\\"))
           (get-bracketed-text-if-any)
           (let ((c (snoop-actual-char)))
             (when (and (not (eof-object? c)) (char=? c #\*))
               (get-actual-char)))
           (emit "<br>")
           (emit-newline)))))))

(define do-ruledtable
  (lambda ()
    (set! *tabular-stack* (cons 'ruled-table *tabular-stack*))
    (emit "<table border=2><tr><td>")
    (emit-newline)))

(define do-endruledtable
  (lambda ()
    (emit-newline)
    (emit "</td></tr></table>")
    (emit-newline)
    (pop-tabular-stack 'ruled-table)))

(define do-tabular
  (lambda ()
    (do-end-para)
    (get-bracketed-text-if-any)
    (bgroup)
    (add-postlude-to-top-frame
      (let ((old-math-mode? *math-mode?*)
            (old-in-display-math? *in-display-math?*))
        (set! *math-mode?* #f)
        (set! *in-display-math?* #f)
        (lambda ()
          (set! *math-mode?* old-math-mode?)
          (set! *in-display-math?* old-in-display-math?))))
    (let ((border-width (if (string-index (get-group) #\|) 1 0)))
      (set! *tabular-stack* (cons 'tabular *tabular-stack*))
      (emit "<table border=")
      (emit border-width)
      (emit "><tr><td valign=top ")
      (do-tabular-multicolumn))))

(define do-end-tabular
  (lambda ()
    (egroup)
    (do-end-para)
    (emit "</td></tr></table>")
    (pop-tabular-stack 'tabular)
    (egroup)))

(define do-tabular-colsep
  (lambda () (egroup) (emit "</td><td valign=top ") (do-tabular-multicolumn)))

(define do-tabular-multicolumn
  (lambda ()
    (let loop ()
      (ignorespaces)
      (let ((c (snoop-actual-char)))
        (when (and (char? c) (char=? c #\\))
          (let ((x (get-ctl-seq)))
            (cond
             ((string=? x "\\hline") (loop))
             ((string=? x "\\multicolumn")
              (let ((n (ungroup (get-token))))
                (get-token)
                (emit " colspan=")
                (emit n)))
             (else
              (toss-back-char *invisible-space*)
              (toss-back-string x)))))))
    (emit ">")
    (bgroup)))

(define do-ruledtable-colsep
  (lambda ()
    (emit-newline)
    (emit "</td><td")
    (ignorespaces)
    (let ((c (snoop-actual-char)))
      (if (char=? c #\\)
        (let ((x (get-ctl-seq)))
          (if (string=? x "\\multispan")
            (let ((n (ungroup (get-token)))) (emit " colspan=") (emit n))
            (toss-back-string x)))))
    (emit ">")
    (emit-newline)))

(define do-tex-logo (lambda () (emit "T<small>E</small>X")))

(define do-latex-logo (lambda () (emit "L<small>A</small>") (do-tex-logo)))

(define do-latex2e-logo (lambda () (do-latex-logo) (emit "2<small>E</small>")))

(define do-romannumeral
  (lambda (upcase?) (emit (number->roman (get-integer 10) upcase?))))

(define set-latex-counter
  (lambda (add?)
    (let* ((counter-name (get-peeled-group))
           (new-value (string->number (get-token-or-peeled-group))))
      (cond
       ((table-get *dotted-counters* counter-name)
        =>
        (lambda (counter)
          (set!counter.value
            counter
            (if add? (+ new-value (counter.value counter)) new-value))))
       (else
        (let ((count-seq (string-append "\\" counter-name)))
          (cond
           ((section-ctl-seq? count-seq)
            =>
            (lambda (n)
              (hash-table-put!
                *section-counters*
                n
                (if add?
                  (+ new-value (table-get *section-counters* n 0))
                  new-value))))
           ((find-count count-seq)
            (set-gcount!
              count-seq
              (if add? (+ new-value (get-gcount count-seq)) new-value)))
           (else #f))))))))

(define do-tex-prim
  (lambda (z)
    (cond
     ((find-def z)
      =>
      (lambda (y)
        (cond
         ((tdef.defer y) => toss-back-string)
         ((tdef.thunk y) => (lambda (th) (th)))
         (else
          (expand-tex-macro
            (tdef.optarg y)
            (tdef.argpat y)
            (tdef.expansion y))))))
     ((section-ctl-seq? z) => (lambda (n) (do-heading n)))
     (*math-mode?* (do-math-ctl-seq z))
     (else (trace-if *tracingcommands?* "Ignoring " z)))))

(define do-char (lambda () (emit-html-char (get-tex-char-spec))))

(define do-tex-char
  (lambda (c)
    (cond
     ((and *comment-char* (char=? c *comment-char*)) (do-comment))
     ((or (memv #f *tex-if-stack*) (memv '? *tex-if-stack*)) #t)
     ((char=? c #\{) (bgroup))
     ((char=? c #\}) (egroup))
     ((char=? c #\$) (do-math))
     ((char=? c #\-) (do-hyphen))
     ((char=? c #\`) (do-lsquo))
     ((char=? c #\') (do-rsquo))
     ((char=? c #\~) (emit-nbsp 1))
     ((char=? c #\!) (do-excl))
     ((char=? c #\?) (do-quest))
     ((or (char=? c #\<) (char=? c #\>) (char=? c #\")) (emit-html-char c))
     ((char=? c #\&)
      (cond
       ((not (null? *tabular-stack*))
        (do-end-para)
        (case (car *tabular-stack*)
          ((pmatrix eqalign displaylines) (emit "</td><td>"))
          ((eqalignno)
           (set! *equation-position* (+ *equation-position* 1))
           (emit "</td><td")
           (when (= *equation-position* 2) (emit " width=30% align=right"))
           (emit ">"))
          ((eqnarray eqnarray*)
           (set! *equation-position* (+ *equation-position* 1))
           (emit "</td><td")
           (when (= *equation-position* 1) (emit " align=center width=2%"))
           (emit ">"))
          ((tabular) (do-tabular-colsep))
          ((ruled-table) (do-ruledtable-colsep))))
       (else (emit-html-char c))))
     ((char=? c #\|)
      (if (and (not (null? *tabular-stack*))
               (eqv? (car *tabular-stack*) 'ruled-table))
        (do-ruledtable-colsep)
        (emit c)))
     ((char=? c #\newline) (do-newline))
     ((char=? c #\space) (do-space))
     ((char=? c *tab*) (do-tab))
     (else
      (cond
       (*math-mode?*
        (case c
          ((#\^) (do-sup))
          ((#\_) (do-sub))
          ((#\+ #\=)
           (unless *math-script-mode?* (emit #\space))
           (emit c)
           (unless *math-script-mode?* (emit #\space)))
          (else
           (if (and (char-alphabetic? c) (not *math-roman-mode?*))
             (begin (emit "<em>") (emit c) (emit "</em>"))
             (emit c)))))
       ((and *in-small-caps?* (char-lower-case? c))
        (emit "<small>")
        (emit (char-upcase c))
        (emit "</small>"))
       (else (emit c)))))))

(define do-tex-ctl-seq-completely
  (lambda (x)
    (cond
     ((resolve-defs x) => tex2page-string)
     ((do-tex-prim (find-corresp-prim x))
      =>
      (lambda (y) (if (eqv? y ':encountered-undefined-command) (emit x)))))))

(define inside-false-world?
  (lambda () (or (memv #f *tex-if-stack*) (memv '? *tex-if-stack*))))

(define do-tex-ctl-seq
  (lambda (z)
    (trace-if *tracingcommands?* z)
    (cond
     ((resolve-defs z)
      =>
      (lambda (s)
        (trace-if *tracingmacros?* "    --> " s)
        (toss-back-char *invisible-space*)
        (toss-back-string s)))
     ((and (inside-false-world?) (not (if-aware-ctl-seq? z))) #f)
     ((string=? z "\\enddocument") (probably-latex) ':encountered-bye)
     ((string=? z "\\bye") ':encountered-bye)
     ((string=? z "\\endinput") ':encountered-endinput)
     ((find-count z) (do-count= z #f))
     ((find-toks z) (do-toks= z #f))
     ((find-dimen z) (do-dimen= z #f))
     (else (do-tex-prim z)))))

(define generate-html
  (lambda ()
    (let loop ()
      (let ((c (snoop-actual-char)))
        (cond
         ((eof-object? c) #t)
         ((resolve-chardefs c)
          =>
          (lambda (s)
            (toss-back-char *invisible-space*)
            (toss-back-string s)
            (loop)))
         ((char=? c *esc-char*)
          (let ((r (do-tex-ctl-seq (get-ctl-seq))))
            (case r
              ((:encountered-endinput) #t)
              ((:encountered-bye) ':encountered-bye)
              (else (loop)))))
         (else (get-actual-char) (do-tex-char c) (loop)))))))

(define do-iffileexists
  (lambda ()
    (let* ((file (actual-tex-filename (get-filename-possibly-braced) #f))
           (thene (ungroup (get-group)))
           (elsee (ungroup (get-group))))
      (tex2page-string (if file thene elsee)))))

(define check-input-file-timestamp?
  (lambda (f)
    (cond
     ((let ((e (file-extension f)))
        (and e (member/string-ci=? e '(".t2p" ".bbl" ".ind"))))
      #f)
     (*inputting-boilerplate?* #f)
     (*ignore-timestamp?* #f)
     ((> *html-only* 0) #f)
     ((and (>= (string-length f) 3)
           (char=? (string-ref f 0) #\.)
           (char=? (string-ref f 1) #\/))
      #f)
     ((member f *verb-written-files*) #f)
     (else #t))))

(define do-inputiffileexists
  (lambda ()
    (let* ((f (actual-tex-filename (get-filename-possibly-braced) #f))
           (then-txt (ungroup (get-group)))
           (else-txt (ungroup (get-group))))
      (cond
       (f (tex2page-string then-txt) (tex2page-file f))
       (else (tex2page-string else-txt))))))

(define tex2page-file
  (lambda (f)
    (write-log #\()
    (write-log f)
    (write-log 'separation-space)
    (set! f (tex2page-massage-file f))
    (trace-if *tracingcommands?* "Inputting file " f)
    (let ((r (call-with-input-file/buffered f generate-html)))
      (write-log #\))
      (write-log 'separation-space)
      r)))

(define do-input
  (lambda ()
    (ignorespaces)
    (let ((f (get-filename-possibly-braced)))
      (let ((boilerplate-index *inputting-boilerplate?*))
        (when (eqv? *inputting-boilerplate?* 0)
          (set! *inputting-boilerplate?* #f))
        (fluid-let
          ((*inputting-boilerplate?*
             (and boilerplate-index (+ boilerplate-index 1))))
          (cond
           ((or (latex-style-file? f)
                (member/string-ci=?
                  f
                  '("btxmac"
                    "btxmac.tex"
                    "eplain"
                    "eplain.tex"
                    "epsf"
                    "epsf.tex"
                    "supp-pdf"
                    "supp-pdf.tex"
                    "tex2page"
                    "tex2page.tex")))
            #f)
           ((ormap (lambda (z) (string=? f z)) '("texinfo" "texinfo.tex"))
            (let ((txi-t2p (actual-tex-filename "texinfo.t2p" #f)))
              (if txi-t2p
                (begin
                  (tex2page-file txi-t2p)
                  (tex2page-file *current-tex-file*)
                  ':encountered-endinput)
                (terror 'do-input "File texinfo.t2p not found"))))
           ((actual-tex-filename f (check-input-file-timestamp? f))
            =>
            tex2page-file)
           (else
            (write-log #\()
            (write-log f)
            (write-log 'separation-space)
            (write-log "not found)")
            (write-log 'separation-space))))))))

(define do-includeonly
  (lambda ()
    (ignorespaces)
    (when (eq? *includeonly-list* #t) (set! *includeonly-list* '()))
    (let ((c (get-actual-char)))
      (when (or (eof-object? c) (not (char=? c #\{)))
        (terror 'do-includeonly)))
    (fluid-let
      ((*filename-delims* (cons #\} (cons #\, *filename-delims*))))
      (let loop ()
        (ignorespaces)
        (let ((c (snoop-actual-char)))
          (cond
           ((eof-object? c) (terror 'do-includeonly))
           ((and *comment-char* (char=? c *comment-char*))
            (eat-till-eol)
            (ignorespaces)
            (loop))
           ((char=? c #\,) (get-actual-char) (loop))
           ((char=? c #\}) (get-actual-char))
           ((ormap (lambda (d) (char=? c d)) *filename-delims*)
            (terror 'do-includeonly))
           (else
            (set! *includeonly-list*
              (cons (get-plain-filename) *includeonly-list*))
            (loop))))))))

(define do-include
  (lambda ()
    (let ((f (ungroup (get-group))))
      (when (or
             (eq? *includeonly-list* #t)
             (ormap (lambda (i) (string=? f i)) *includeonly-list*))
        (fluid-let
          ((*subjobname* (file-stem-name f))
           (*img-file-count* 0)
           (*imgdef-file-count* 0))
          (tex2page-file
            (actual-tex-filename f (check-input-file-timestamp? f))))))))

(define do-eval-string
  (lambda (s)
    (call-with-input-string
      s
      (lambda (i)
        (let loop ()
          (let ((x (read i))) (unless (eof-object? x) (eval x) (loop))))))))

(define with-output-to-port
  (lambda (o th) (parameterize ((current-output-port o)) (th))))

(define do-eval
  (lambda (fmts)
    (let ((s (ungroup (get-group))))
      (unless (inside-false-world?)
        (when (> *html-only* 0) (set! fmts 'html))
        (case fmts
          ((html)
           (let ((o (open-output-string)))
             (with-output-to-port o (lambda () (do-eval-string s)))
             (tex2page-string (get-output-string o))))
          ((quiet) (do-eval-string s))
          (else
           (set! *eval-file-count* (+ *eval-file-count* 1))
           (let ((eval4tex-file
                   (string-append
                     *jobname*
                     *eval-file-suffix*
                     (number->string *eval-file-count*)
                     ".tex")))
             (ensure-file-deleted eval4tex-file)
             (with-output-to-file
               eval4tex-file
               (lambda () (do-eval-string s) (display "\\relax")))
             (fluid-let
               ((*ignore-timestamp?* #t))
               (tex2page-file eval4tex-file)))))))))

(define eval-for-tex-only
  (lambda ()
    (set! *eval-for-tex-only?* #t)
    (do-end-page)
    (ensure-file-deleted *html-page*)
    (set! *main-tex-file* #f)
    (set! *html-page* ".eval4texignore")
    (ensure-file-deleted *html-page*)
    (set! *html* (open-output-file *html-page*))))

(define expand-ctl-seq-into-string
  (lambda (cs)
    (let ((tmp-port (open-output-string)))
      (fluid-let ((*html* tmp-port)) (do-tex-ctl-seq cs))
      (get-output-string tmp-port))))

(define tex-string->html-string
  (lambda (ts)
    (let ((tmp-port (open-output-string)))
      (fluid-let ((*html* tmp-port)) (tex2page-string ts))
      (get-output-string tmp-port))))

(define call-with-html-output-going-to
  (lambda (p th) (fluid-let ((*html* p)) (th))))

(define call-external-programs-if-necessary
  (lambda ()
    (let ((run-bibtex?
            (cond
             ((not *using-bibliography?*) #f)
             ((not
               (file-exists?
                 (string-append
                   *aux-dir/*
                   *jobname*
                   *bib-aux-file-suffix*
                   ".aux")))
              #f)
             ((memv 'bibliography *missing-pieces*) #t)
             (*source-changed-since-last-run?*
              (flag-missing-piece 'fresh-bibliography)
              #t)
             (else #f)))
          (run-makeindex?
            (cond
             ((not *using-index?*) #f)
             ((not
               (file-exists?
                 (string-append
                   *aux-dir/*
                   *jobname*
                   *index-file-suffix*
                   ".idx")))
              #f)
             ((memv 'index *missing-pieces*) #t)
             (*source-changed-since-last-run?*
              (flag-missing-piece 'fresh-index)
              #t)
             (else #f))))
      (when run-bibtex?
        (write-log 'separation-newline)
        (write-log "Running: bibtex ")
        (write-log *aux-dir/*)
        (write-log *jobname*)
        (write-log *bib-aux-file-suffix*)
        (write-log #\space)
        (system
          (string-append "bibtex " *aux-dir/* *jobname* *bib-aux-file-suffix*))
        (unless (file-exists?
                 (string-append *jobname* *bib-aux-file-suffix* ".bbl"))
          (write-log " ... failed; try manually"))
        (write-log 'separation-newline))
      (when run-makeindex?
        (write-log 'separation-newline)
        (write-log "Running: makeindex ")
        (write-log *aux-dir/*)
        (write-log *jobname*)
        (write-log *index-file-suffix*)
        (write-log #\space)
        (system
          (string-append
            "makeindex "
            *aux-dir/*
            *jobname*
            *index-file-suffix*))
        (unless (file-exists?
                 (string-append
                   *aux-dir/*
                   *jobname*
                   *index-file-suffix*
                   ".ind"))
          (write-log " ... failed; try manually"))
        (write-log 'separation-newline))
      (for-each
        (lambda (f)
          (when (file-exists? f)
            (write-log 'separation-newline)
            (write-log "Running: metapost ")
            (write-log f)
            (write-log 'separation-newline)
            (system (string-append *metapost* " " f))))
        *mp-files*)
      (for-each
        (lambda (eps-file+img-file-stem)
          (retry-lazy-image
            (car eps-file+img-file-stem)
            (cdr eps-file+img-file-stem)))
        *missing-eps-files*))))

(define first-file-that-exists
  (lambda ff (ormap (lambda (f) (and f (file-exists? f) f)) ff)))

(define file-in-home
  (lambda (f)
    (let ((home (getenv "HOME")))
      (and home
           (let ((slash-already?
                   (let ((n (string-length home)))
                     (and (>= n 0)
                          (let ((c (string-ref home (- n 1))))
                            (or (char=? c #\/) (char=? c #\\)))))))
             (string-append home (if slash-already? "" "/") f))))))

(define make-target-dir
  (lambda ()
    (let ((hdir-file
            (first-file-that-exists
              (string-append *jobname* ".hdir")
              ".tex2page.hdir"
              (file-in-home ".tex2page.hdir"))))
      (when hdir-file
        (let ((hdir
               (call-with-input-file/buffered
                 hdir-file
                 (lambda () (get-filename-possibly-braced)))))
          (unless (= (string-length hdir) 0)
            (case *operating-system*
              ((unix)
               (system (string-append "mkdir -p " hdir))
               (system (string-append "touch " hdir "/probe")))
              ((windows)
               (system (string-append "mkdir " hdir))
               (system (string-append "echo probe > " hdir "\\probe"))))
            (let ((probe (string-append hdir "/probe")))
              (when (file-exists? probe)
                (ensure-file-deleted probe)
                (set! *aux-dir* hdir)
                (set! *aux-dir/* (string-append *aux-dir* "/"))))))))))

(define move-aux-files-to-aux-dir
  (lambda (f)
    (when (and
           *aux-dir*
           (or (file-exists? (string-append f ".tex"))
               (file-exists? (string-append f ".scm"))
               (file-exists? (string-append f *img-file-extn*))))
      (case *operating-system*
        ((unix) (system (string-append "mv " f ".* " *aux-dir*)))
        ((windows)
         (system (string-append "copy " f ".* " *aux-dir*))
         (when (or
                (file-exists? (string-append f ".tex"))
                (file-exists? (string-append f ".scm")))
           (system (string-append "del " f ".*"))))))))

(define start-off-css-file
  (lambda ()
    (let ((css-file (string-append *aux-dir/* *jobname* *css-file-suffix*)))
      (ensure-file-deleted css-file)
      (set! *css-port* (open-output-file css-file))
      (display
        "\n               body {\n               color: black;\n               /*   background-color: #e5e5e5;*/\n               background-color: #ffffff;\n               /*background-color: beige;*/\n               margin-top: 2em;\n               margin-left: 8%;\n               margin-right: 8%;\n               }\n\n               h1,h2,h3,h4,h5,h6 {\n               margin-top: .5em;\n               }\n\n               .title {\n               font-size: 200%;\n               font-weight: normal;\n               }\n\n               .partheading {\n               font-size: 100%;\n               }\n\n               .chapterheading {\n               font-size: 100%;\n               }\n\n               .beginsection {\n               font-size: 110%;\n               }\n\n               .tiny {\n               font-size: 40%;\n               }\n\n               .scriptsize {\n               font-size: 60%;\n               }\n\n               .footnotesize {\n               font-size: 75%;\n               }\n\n               .small {\n               font-size: 90%;\n               }\n\n               .normalsize {\n               font-size: 100%;\n               }\n\n               .large {\n               font-size: 120%;\n               }\n\n               .largecap {\n               font-size: 150%;\n               }\n\n               .largeup {\n               font-size: 200%;\n               }\n\n               .huge {\n               font-size: 300%;\n               }\n\n               .hugecap {\n               font-size: 350%;\n               }\n\n               pre {\n               margin-left: 2em;\n               }\n\n               blockquote {\n               margin-left: 2em;\n               }\n\n               ol {\n               list-style-type: decimal;\n               }\n\n               ol ol {\n               list-style-type: lower-alpha;\n               }\n\n               ol ol ol {\n               list-style-type: lower-roman;\n               }\n\n               ol ol ol ol {\n               list-style-type: upper-alpha;\n               }\n\n               /*\n               .verbatim {\n               color: #4d0000;\n               }\n               */\n\n               tt i {\n               font-family: serif;\n               }\n\n               .verbatim em {\n               font-family: serif;\n               }\n\n               .scheme em {\n               font-family: serif;\n               color: black;\n               }\n\n               .scheme {\n               color: brown;\n               }\n\n               .scheme .keyword {\n               color: #990000;\n               font-weight: bold;\n               }\n\n               .scheme .builtin {\n               color: #990000;\n               }\n\n               .scheme .variable {\n               color: navy;\n               }\n\n               .scheme .global {\n               color: purple;\n               }\n\n               .scheme .selfeval {\n               color: green;\n               }\n\n               .scheme .comment {\n               color:  teal;\n               }\n\n               .schemeresponse {\n               color: green;\n               }\n\n               .navigation {\n               color: red;\n               text-align: right;\n               font-size: medium;\n               font-style: italic;\n               }\n\n               .disable {\n               /* color: #e5e5e5; */\n               color: gray;\n               }\n\n               .smallcaps {\n               font-size: 75%;\n               }\n\n               .smallprint {\n               color: gray;\n               font-size: 75%;\n               text-align: right;\n               }\n\n               /*\n               .smallprint hr {\n               text-align: left;\n               width: 40%;\n               }\n               */\n\n               .footnoterule {\n               text-align: left;\n               width: 40%;\n               }\n\n               .colophon {\n               color: gray;\n               font-size: 80%;\n               text-align: right;\n               }\n\n               .colophon a {\n               color: gray;\n               }\n\n               "
        *css-port*))))

(define load-aux-file
  (lambda ()
    (let ((label-file
            (string-append *aux-dir/* *jobname* *label-file-suffix* ".scm")))
      (when (file-exists? label-file)
        (load-tex2page-data-file label-file)
        (delete-file label-file)))
    (unless (string=? *jobname* "texput")
      (let ((jobname-aux (string-append "texput" *aux-file-suffix* ".scm")))
        (when (file-exists? jobname-aux) (delete-file jobname-aux))))
    (let ((aux-file
            (string-append *aux-dir/* *jobname* *aux-file-suffix* ".scm")))
      (when (file-exists? aux-file)
        (load-tex2page-data-file aux-file)
        (delete-file aux-file))
      (set! *aux-port* (open-output-file aux-file)))
    (start-off-css-file)
    (when (eqv? *tex-format* 'latex)
      (!definitely-latex)
      (write-aux `(!definitely-latex)))
    (unless (null? *toc-list*) (set! *toc-list* (reverse! *toc-list*)))
    (unless (null? *stylesheets*)
      (set! *stylesheets* (reverse! *stylesheets*)))
    (unless (null? *html-head*) (set! *html-head* (reverse! *html-head*)))))

(define update-last-modification-time
  (lambda (f)
    (when *colophon-mentions-last-mod-time?*
      (let ((s (file-or-directory-modify-seconds f)))
        (when (and
               s
               (or (not *last-modification-time*)
                   (> s *last-modification-time*)))
          (set! *source-changed-since-last-run?* #t)
          (!last-modification-time s)
          (if (and *colophon-on-first-page?* (> *html-page-count* 1))
            (flag-missing-piece 'last-modification-time)))))))

(define probably-latex
  (lambda ()
    (when (null? *tex-env*)
      (set! *latex-probability* (+ *latex-probability* 1))
      (if (>= *latex-probability* 2) (definitely-latex)))))

(define definitely-latex
  (lambda ()
    (unless (eqv? *tex-format* 'latex)
      (!definitely-latex)
      (write-aux `(!definitely-latex)))))

(define !toc-page (lambda (p) (set! *toc-page* p)))

(define !index-page (lambda (p) (set! *index-page* p)))

(define !toc-entry
  (lambda (level number page label header)
    (set! *toc-list*
      (cons
       (make-tocentry
         'level
         level
         'number
         number
         'page
         page
         'label
         label
         'header
         header)
       *toc-list*))))

(define !label
  (lambda (label html-page name value)
    (hash-table-put!
      *label-table*
      label
      (make-label
        'src
        *label-source*
        'page
        html-page
        'name
        name
        'value
        value))))

(define !index
  (lambda (index-number html-page-number)
    (hash-table-put! *index-table* index-number html-page-number)))

(define !last-modification-time (lambda (s) (set! *last-modification-time* s)))

(define !last-page-number (lambda (n) (set! *last-page-number* n)))

(define !using-chapters (lambda () (set! *using-chapters?* #t)))

(define !definitely-latex
  (lambda ()
    (set! *tex-format* 'latex)
    (when (< (get-gcount "\\secnumdepth") -1)
      (set-gcount! "\\secnumdepth" 3))))

(define !using-external-program (lambda (x) #f))

(define !external-labels (lambda (f) #f))

(define fully-qualified-url?
  (lambda (u) (or (substring? "//" u) (char=? (string-ref u 0) #\/))))

(define fully-qualified-pathname?
  (lambda (f)
    (let ((n (string-length f)))
      (if (= n 0)
        #t
        (let ((c0 (string-ref f 0)))
          (cond
           ((char=? c0 #\/) #t)
           ((= n 1) #f)
           ((and (char-alphabetic? c0) (char=? (string-ref f 1) #\:)) #t)
           (else #f)))))))

(define ensure-url-reachable
  (lambda (f)
    (if (and *aux-dir* (not (fully-qualified-url? f)) (not (substring? "/" f)))
      (let ((real-f (string-append *aux-dir/* f)))
        (when (and (file-exists? f) (not (file-exists? real-f)))
          (case *operating-system*
            ((unix) (system (string-append "cp -p " f " " real-f)))
            ((windows) (system (string-append "copy/b " f " " *aux-dir*)))))
        real-f)
      f)))

(define !stylesheet
  (lambda (css)
    (if (file-exists? (ensure-url-reachable css))
      (set! *stylesheets* (cons css *stylesheets*))
      (begin
        (write-log "! Can't find stylesheet ")
        (write-log css)
        (write-log 'separation-newline)))))

(define !html-head (lambda (s) (set! *html-head* (cons s *html-head*))))

(define !default-title (lambda (title) (unless *title* (set! *title* title))))

(define !preferred-title (lambda (title) (set! *title* title)))

(define !infructuous-calls-to-tex2page
  (lambda (n) (set! *infructuous-calls-to-tex2page* n)))

(define load-tex2page-data-file
  (lambda (f)
    (if (file-exists? f)
      (call-with-input-file
        f
        (lambda (i)
          (let loop ()
            (let ((e (read i)))
              (unless (eof-object? e)
                (apply
                 (case (car e)
                   ((!default-title) !default-title)
                   ((!definitely-latex) !definitely-latex)
                   ((!external-labels) !external-labels)
                   ((!html-head) !html-head)
                   ((!index) !index)
                   ((!index-page) !index-page)
                   ((!infructuous-calls-to-tex2page)
                    !infructuous-calls-to-tex2page)
                   ((!label) !label)
                   ((!last-modification-time) !last-modification-time)
                   ((!last-page-number) !last-page-number)
                   ((!preferred-title) !preferred-title)
                   ((!stylesheet) !stylesheet)
                   ((!toc-entry) !toc-entry)
                   ((!toc-page) !toc-page)
                   ((!using-chapters) !using-chapters)
                   ((!using-external-program) !using-external-program))
                 (cdr e))
                (loop)))))))))

(define tex2page-massage-file (lambda (f) f))

(define tex2page-help
  (lambda (not-a-file)
    (write-aux
      `(!infructuous-calls-to-tex2page ,(+ *infructuous-calls-to-tex2page* 1)))
    (unless (or
             (string=? not-a-file "--help")
             (string=? not-a-file "--missing-arg")
             (string=? not-a-file "--version"))
      (write-log "! I can't find file ")
      (write-log not-a-file)
      (write-log 'separation-newline))
    (cond
     ((string=? not-a-file "--version")
      (write-log
        "Copyright (c) 1997-2003, Dorai Sitaram.\n\n                  Permission to distribute and use this work for any\n                  purpose is hereby granted provided this copyright\n                  notice is included in the copy.  This work is provided\n                  as is, with no warranty of any kind.\n\n                  For more information on TeX2page, please see")
      (write-log #\newline)
      (write-log *tex2page-website*)
      (write-log #\.)
      (write-log #\newline)
      (write-log #\newline))
     ((string=? not-a-file "--help")
      (write-log
        "\n                  The command tex2page converts a (La)TeX document into\n                  Web pages.  Call tex2page with the relative or full\n                  pathname of the main (La)TeX file.  The file extension\n                  is optional if it is .tex.\n\n                  The relative pathnames of the main and any subsidiary\n                  (La)TeX files are resolved against the current working\n                  directory and the list of directories in the\n                  environment variable TIIPINPUTS, or if that does not\n                  exist, TEXINPUTS.  \n\n                  The output Web files are generated in the current\n                  directory by default.  An alternate location can be\n                  specified in  <jobname>.hdir, tex2page.hdir, or\n                  ~/tex2page.hdir, where <jobname> is the basename of the\n                  main (La)TeX file.  \n\n                  For more information on tex2page, please see")
      (write-log #\newline)
      (write-log *tex2page-website*)
      (write-log #\.)
      (write-log #\newline)
      (write-log #\newline))
     (else
      (when (string=? not-a-file "--missing-arg")
        (write-log "! Missing command-line argument.")
        (write-log 'separation-newline))
      (when (> *infructuous-calls-to-tex2page* 0)
        (write-log "You have called TeX2page")
        (write-log #\space)
        (write-log (+ *infructuous-calls-to-tex2page* 1))
        (write-log #\space)
        (write-log "times without a valid input document.")
        (write-log 'separation-newline))
      (cond
       ((>= *infructuous-calls-to-tex2page* 4)
        (write-log "I can't go on meeting you like this.")
        (write-log 'separation-newline)
        (write-log "Good bye!")
        (write-log 'separation-newline))
       (else
        (write-log
          "Do you need help using TeX2page?\nTry the commands\n  tex2page --help\n  tex2page --version")
        (write-log 'separation-newline)))))
    (close-all-open-ports)))

(define non-fatal-error
  (lambda ss
    (emit-link-start (string-append *jobname* ".hlog"))
    (emit "[")
    (for-each emit-html-string ss)
    (emit "]")
    (emit-link-stop)))

(define do-math-ctl-seq
  (lambda (s)
    (cond
     ((find-math-def s) => (lambda (x) ((tdef.thunk x))))
     (else (emit (substring s 1 (string-length s)))))))

(define tex-def-math-prim
  (lambda (cs thunk)
    (tex-def cs '() #f #f thunk cs #f *math-primitive-texframe*)))

(define make-reusable-math-image-as-needed
  (lambda (cs . expn)
    (let ((expn (if (null? expn) cs (car expn))))
      (tex-def-math-prim
        cs
        (lambda ()
          (tex2page-string
            (string-append "\\global\\imgdef" cs "{$" expn "$}"))
          (tex2page-string cs))))))

(tex-def-math-prim "\\beta" (lambda () (emit "<i>&szlig;</i>")))

(tex-def-math-prim "\\iota" (lambda () (emit "<i><small>I</small></i>")))

(tex-def-math-prim "\\kappa" (lambda () (emit "<i><small>K</small></i>")))

(tex-def-math-prim "\\mu" (lambda () (emit "&micro;")))

(tex-def-math-prim "\\ell" (lambda () (emit "<i>l</i>")))

(tex-def-math-prim "\\partial" (lambda () (emit "&eth;")))

(tex-def-math-prim "\\prime" (lambda () (emit "/")))

(tex-def-math-prim "\\emptyset" (lambda () (emit "&Oslash;")))

(tex-def-math-prim "\\|" (lambda () (emit "||")))

(tex-def-math-prim "\\backslash" (lambda () (emit "\\")))

(tex-def-math-prim "\\forall" (lambda () (emit "<b>A</b>")))

(tex-def-math-prim "\\exists" (lambda () (emit "<b>E</b>")))

(tex-def-math-prim "\\neg" (lambda () (emit "&not;")))

(tex-def-math-prim "\\sharp" (lambda () (emit "#")))

(tex-def-math-prim "\\pm" (lambda () (emit "&plusmn;")))

(tex-def-math-prim "\\setminus" (lambda () (emit "\\")))

(tex-def-math-prim "\\cdot" (lambda () (emit " &middot; ")))

(tex-def-math-prim "\\div" (lambda () (emit "&divide;")))

(tex-def-math-prim "\\times" (lambda () (emit "&times;")))

(tex-def-math-prim "\\ast" (lambda () (emit #\*)))

(tex-let-prim "\\star" "\\ast")

(tex-def-math-prim "\\circ" (lambda () (emit "<small>o</small>")))

(tex-def-math-prim "\\bullet" (lambda () (emit *html-bull*)))

(tex-def-math-prim "\\vee" (lambda () (emit "V")))

(tex-def-math-prim "\\wedge" (lambda () (emit "^")))

(tex-def-math-prim "\\dagger" (lambda () (emit *html-dagger*)))

(tex-def-math-prim "\\ddagger" (lambda () (emit *html-^dagger*)))

(tex-def-math-prim "\\leq" (lambda () (emit "<u>&lt;</u>")))

(tex-def-math-prim "\\ll" (lambda () (emit "&lt;&lt;")))

(tex-def-math-prim "\\geq" (lambda () (emit "<u>&gt;</u>")))

(tex-def-math-prim "\\gg" (lambda () (emit "&gt;&gt;")))

(tex-def-math-prim "\\equiv" (lambda () (emit "<u>=</u>")))

(tex-def-math-prim "\\sim" (lambda () (emit "~")))

(tex-def-math-prim "\\simeq" (lambda () (emit "<u>~</u>")))

(tex-def-math-prim "\\mid" (lambda () (emit "|")))

(tex-def-math-prim "\\parallel" (lambda () (emit "||")))

(tex-def-math-prim "\\perp" (lambda () (emit "<u>|</u>")))

(tex-def-math-prim "\\not" (lambda () (emit #\!)))

(tex-def-math-prim "\\leftarrow" (lambda () (emit "&lt;--")))

(tex-def-math-prim "\\Leftarrow" (lambda () (emit "&lt;==")))

(tex-def-math-prim "\\rightarrow" (lambda () (emit "-->")))

(tex-def-math-prim "\\Rightarrow" (lambda () (emit "==&gt;")))

(tex-def-math-prim "\\leftrightarrow" (lambda () (emit "&lt;--&gt;")))

(tex-def-math-prim "\\Leftrightarrow" (lambda () (emit "&lt;==&gt;")))

(tex-def-math-prim "\\longleftarrow" (lambda () (emit "&lt;---")))

(tex-def-math-prim "\\Longleftarrow" (lambda () (emit "&lt;===")))

(tex-def-math-prim "\\longrightarrow" (lambda () (emit "---&gt;")))

(tex-def-math-prim "\\Longrightarrow" (lambda () (emit "===&gt;")))

(tex-def-math-prim "\\longleftrightarrow" (lambda () (emit "&lt;---&gt;")))

(tex-def-math-prim "\\Longleftrightarrow" (lambda () (emit "&lt;===&gt;")))

(tex-def-math-prim
  "\\uparrow"
  (lambda () (emit "<table><tr><td>^</td></tr><tr><td>|</td></tr></table>")))

(tex-def-math-prim "\\lbrack" (lambda () (emit "[")))

(tex-def-math-prim "\\lbrace" (lambda () (emit "{")))

(tex-def-math-prim "\\langle" (lambda () (emit *html-lsaquo*)))

(tex-def-math-prim "\\rbrack" (lambda () (emit "]")))

(tex-def-math-prim "\\rbrace" (lambda () (emit "}")))

(tex-def-math-prim "\\rangle" (lambda () (emit *html-rsaquo*)))

(tex-def-math-prim "\\colon" (lambda () (emit #\:)))

(tex-def-math-prim "\\ne" (lambda () (emit "!=")))

(tex-let-prim "\\neq" "\\ne")

(tex-let-prim "\\le" "\\leq")

(tex-let-prim "\\ge" "\\geq")

(tex-let-prim "\\{" "\\lbrace")

(tex-let-prim "\\}" "\\rbrace")

(tex-let-prim "\\to" "\\rightarrow")

(tex-let-prim "\\gets" "\\leftarrow")

(tex-let-prim "\\land" "\\wedge")

(tex-let-prim "\\lor" "\\vee")

(tex-let-prim "\\lnot" "\\neg")

(tex-let-prim "\\vert" "\\mid")

(tex-let-prim "\\Vert" "\\parallel")

(tex-let-prim "\\iff" "\\Longleftrightarrow")

(tex-def-prim "\\S" (lambda () (emit "&sect;")))

(tex-def-prim "\\P" (lambda () (emit "&para;")))

(tex-let-prim "\\dag" "\\dagger")

(tex-let-prim "\\ddag" "\\ddagger")

(tex-def-math-prim "\\eqalign" (lambda () (do-eqalign 'eqalign)))

(tex-def-math-prim "\\eqalignno" (lambda () (do-eqalign 'eqalignno)))

(tex-def-math-prim "\\displaylines" (lambda () (do-eqalign 'displaylines)))

(tex-let-prim "\\leqalignno" "\\eqalignno")

(tex-def-math-prim "\\noalign" do-noalign)

(tex-def-math-prim "\\frac" do-frac)

(tex-def-math-prim "\\pmatrix" do-pmatrix)

(tex-def-math-prim "\\eqno" do-eqno)

(tex-let-prim "\\leqno" "\\eqno")

(tex-def-math-prim "\\," do-space)

(tex-def-math-prim "\\;" do-space)

(tex-def-math-prim "\\!" do-relax)

(tex-def-math-prim "\\mathbf" do-relax)

(tex-def-math-prim "\\mathrm" do-relax)

(tex-def-math-prim "\\over" (lambda () (emit "/")))

(tex-def-math-prim
  "\\sqrt"
  (lambda ()
    (emit "(")
    (tex2page-string (get-token))
    (emit ")<sup>1/2</sup>")))

(tex-def-math-prim "\\left" do-relax)

(tex-def-math-prim "\\right" do-relax)

(tex-def-prim "\\AA" (lambda () (emit "&Aring;")))

(tex-def-prim "\\aa" (lambda () (emit "&aring;")))

(tex-def-prim
  "\\abstract"
  (lambda ()
    (tex2page-string "\\quote")
    (tex2page-string "\\centerline{\\bf\\abstractname}\\par")))

(tex-def-prim "\\addtocounter" (lambda () (set-latex-counter #t)))

(tex-def-prim "\\advance" (lambda () (do-advance #f)))

(tex-def-prim "\\advancetally" (lambda () (do-advancetally #f)))

(tex-def-prim "\\AE" (lambda () (emit "&AElig;")))

(tex-def-prim "\\ae" (lambda () (emit "&aelig;")))

(tex-def-prim "\\aftergroup" do-aftergroup)

(tex-def-prim "\\alltt" do-alltt)

(tex-def-prim "\\appendix" do-appendix)

(tex-def-prim "\\appendixname" (lambda () (emit "Appendix ")))

(tex-def-prim "\\author" do-author)

(tex-def-prim "\\b" (lambda () (do-diacritic 'a)))

(tex-def-prim "\\begin" do-begin)

(tex-def-prim "\\bgroup" bgroup)

(tex-def-prim "\\beginsection" do-beginsection)

(tex-def-prim "\\bf" (lambda () (do-switch 'bf)))

(tex-def-prim "\\bgcolor" (lambda () (do-switch 'bgcolor)))

(tex-def-prim "\\bibitem" do-bibitem)

(tex-def-prim "\\bibliography" do-bibliography)

(tex-def-prim "\\bibliographystyle" do-bibliographystyle)

(tex-def-prim "\\bigbreak" (lambda () (do-bigskip "\\bigbreak")))

(tex-def-prim "\\bigskip" (lambda () (do-bigskip "\\bigskip")))

(tex-def-prim "\\break" (lambda () (emit "<br>")))

(tex-def-prim "\\c" (lambda () (do-diacritic 'cedilla)))

(tex-def-prim "\\caption" do-caption)

(tex-def-prim "\\catcode" do-catcode)

(tex-def-math-prim
  "\\cdots"
  (lambda () (emit "<tt>&middot;&middot;&middot;</tt>")))

(tex-def-prim "\\center" (lambda () (do-block 'center)))

(tex-def-prim "\\centerline" (lambda () (do-function "\\centerline")))

(tex-def-prim
  "\\chapter"
  (lambda ()
    (!using-chapters)
    (write-aux `(!using-chapters))
    (when (and (eqv? *tex-format* 'latex) (< (get-gcount "\\secnumdepth") -1))
      (set-gcount! "\\secnumdepth" 2))
    (do-heading 0)))

(tex-def-prim "\\chaptername" (lambda () (emit "Chapter ")))

(tex-def-prim "\\char" do-char)

(tex-def-prim "\\cite" do-cite)

(tex-def-prim "\\closegraphsfile" do-mfpic-closegraphsfile)

(tex-def-prim "\\closein" (lambda () (do-close-stream 'in)))

(tex-def-prim "\\closeout" (lambda () (do-close-stream 'out)))

(tex-def-prim "\\color" do-color)

(tex-def-prim "\\convertMPtoPDF" do-convertmptopdf)

(tex-def-prim "\\copyright" (lambda () (emit "&copy;")))

(tex-def-prim "\\CR" (lambda () (do-cr "\\CR")))

(tex-def-prim "\\cr" (lambda () (do-cr "\\cr")))

(tex-def-prim "\\csname" do-csname)

(tex-def-prim "\\cssblock" do-cssblock)

(tex-def-prim "\\dag" (lambda () (emit *html-dagger*)))

(tex-def-prim "\\date" do-date)

(tex-def-prim "\\ddag" (lambda () (emit *html-^dagger*)))

(tex-def-prim "\\def" (lambda () (do-def #f)))

(tex-def-prim "\\defcsactive" (lambda () (do-defcsactive #f)))

(tex-def-prim "\\definecolor" do-definecolor)

(tex-def-prim "\\DefineNamedColor" (lambda () (get-token) (do-definecolor)))

(tex-def-prim "\\definitelylatex" definitely-latex)

(tex-def-prim "\\defschememathescape" (lambda () (scm-set-mathescape #t)))

(tex-def-prim
  "\\description"
  (lambda ()
    (do-end-para)
    (set! *tabular-stack* (cons 'description *tabular-stack*))
    (emit "<dl><dt></dt><dd>")))

(tex-def-prim "\\DH" (lambda () (emit "&ETH;")))

(tex-def-prim "\\dh" (lambda () (emit "&eth;")))

(tex-def-prim "\\discretionary" do-discretionary)

(tex-def-prim
  "\\displaymath"
  (lambda () (do-latex-env-as-image "displaymath" 'display)))

(tex-def-prim "\\divide" (lambda () (do-divide #f)))

(tex-def-prim "\\document" probably-latex)

(tex-def-prim "\\documentclass" do-documentclass)

(tex-def-prim
  "\\dontuseimgforhtmlmath"
  (lambda ()
    (set! *use-image-for-displayed-math?* #f)
    (set! *use-image-for-intext-math?* #f)))

(tex-def-prim
  "\\dontuseimgforhtmlmathdisplay"
  (lambda () (set! *use-image-for-displayed-math?* #f)))

(tex-def-prim
  "\\dontuseimgforhtmlmathintext"
  (lambda () (set! *use-image-for-intext-math?* #f)))

(tex-def-prim "\\dots" (lambda () (emit "<tt>...</tt>")))

(tex-def-prim "\\egroup" egroup)

(tex-def-prim "\\eject" do-eject)

(tex-def-prim "\\else" (lambda () (do-else)))

(tex-def-prim "\\em" (lambda () (do-switch 'em)))

(tex-def-prim "\\emph" (lambda () (do-function "\\emph")))

(tex-def-prim "\\end" do-end)

(tex-def-prim "\\endalltt" do-end-alltt)

(tex-def-prim "\\endcenter" do-end-block)

(tex-def-prim
  "\\enddescription"
  (lambda ()
    (pop-tabular-stack 'description)
    (do-end-para)
    (emit "</dd></dl>")
    (do-para)))

(tex-def-prim "\\endeqnarray" do-end-equation)

(tex-def-prim "\\endequation" do-end-equation)

(tex-def-prim
  "\\endenumerate"
  (lambda ()
    (pop-tabular-stack 'enumerate)
    (do-end-para)
    (emit "</ol>")
    (do-para)))

(tex-def-prim "\\endfigure" (lambda () (do-end-table/figure 'figure)))

(tex-def-prim "\\endflushleft" do-end-block)

(tex-def-prim "\\endflushright" do-end-block)

(tex-def-prim "\\endgraf" do-para)

(tex-def-prim
  "\\endhtmlimg"
  (lambda () (terror 'tex-def-prim "Unmatched \\endhtmlimg")))

(tex-def-prim "\\endhtmlonly" (lambda () (set! *html-only* (- *html-only* 1))))

(tex-def-prim
  "\\enditemize"
  (lambda ()
    (pop-tabular-stack 'itemize)
    (do-end-para)
    (emit "</ul>")
    (do-para)))

(tex-def-prim "\\endminipage" do-endminipage)

(tex-def-prim "\\endruledtable" do-endruledtable)

(tex-def-prim "\\endtabbing" do-end-tabbing)

(tex-def-prim "\\endtable" (lambda () (do-end-table/figure 'table)))

(tex-def-prim "\\endtableplain" do-end-table-plain)

(tex-def-prim "\\endtabular" do-end-tabular)

(tex-def-prim
  "\\endthebibliography"
  (lambda () (emit "</table>") (egroup) (do-para)))

(tex-def-prim "\\enspace" (lambda () (emit-nbsp 2)))

(tex-def-prim
  "\\enumerate"
  (lambda ()
    (do-end-para)
    (set! *tabular-stack* (cons 'enumerate *tabular-stack*))
    (emit "<ol>")))

(tex-def-prim "\\epsfbox" do-epsfbox)

(tex-def-prim "\\epsfig" do-epsfig)

(tex-def-prim "\\epsfxsize" (lambda () (do-epsf-size 'x)))

(tex-def-prim "\\epsfysize" (lambda () (do-epsf-size 'y)))

(tex-def-prim "\\eqnarray" (lambda () (do-equation 'eqnarray)))

(tex-def-prim "\\equation" (lambda () (do-equation 'equation)))

(tex-def-prim "\\errmessage" do-errmessage)

(tex-def-prim "\\eval" (lambda () (do-eval 'both)))

(tex-def-prim "\\evalh" (lambda () (do-eval 'html)))

(tex-def-prim "\\evalq" (lambda () (do-eval 'quiet)))

(tex-def-prim "\\expandafter" do-expandafter)

(tex-def-prim "\\expandhtmlindex" (lambda () (expand-html-index #f)))

(tex-def-prim "\\externaltitle" do-externaltitle)

(tex-def-prim "\\fi" (lambda () (do-fi)))

(tex-def-prim "\\figure" (lambda () (do-table/figure 'figure)))

(tex-def-prim "\\fiverm" (lambda () (do-switch 'fiverm)))

(tex-def-prim "\\flushleft" (lambda () (do-block 'flushleft)))

(tex-def-prim "\\flushright" (lambda () (do-block 'flushright)))

(tex-def-prim "\\footnote" do-footnote)

(tex-def-prim "\\footnotesize" (lambda () (do-switch 'footnotesize)))

(tex-def-prim "\\gdef" (lambda () (do-def #t)))

(tex-def-prim "\\global" do-global)

(tex-def-prim "\\globaladvancetally" (lambda () (do-advancetally #t)))

(tex-def-prim "\\gobblegroup" get-group)

(tex-def-prim "\\\"" (lambda () (do-diacritic 'umlaut)))

(tex-def-prim "\\halign" do-halign)

(tex-def-prim "\\hbox" do-box)

(tex-def-prim "\\hfill" (lambda () (emit-nbsp 5)))

(tex-def-prim
  "\\hrule"
  (lambda () (do-end-para) (emit "<hr>") (emit-newline) (do-para)))

(tex-def-prim "\\hskip" do-hskip)

(tex-def-prim "\\hspace" do-hspace)

(tex-def-prim "\\htmladdimg" do-htmladdimg)

(tex-def-prim "\\htmladvancedentities" html-advanced-entities)

(tex-def-prim "\\htmlcolophon" do-htmlcolophon)

(tex-def-prim "\\htmlgif" (lambda () (do-htmlimg "htmlgif")))

(tex-def-prim "\\htmlheadonly" do-htmlheadonly)

(tex-def-prim "\\htmlimageformat" do-htmlimageformat)

(tex-def-prim "\\htmlimg" (lambda () (do-htmlimg "htmlimg")))

(tex-def-prim "\\htmlimgmagnification" do-htmlimgmagnification)

(tex-def-prim "\\htmlmathstyle" do-htmlmathstyle)

(tex-def-prim "\\htmlonly" (lambda () (set! *html-only* (+ *html-only* 1))))

(tex-def-prim "\\htmlpagelabel" do-htmlpagelabel)

(tex-def-prim "\\htmlpageref" do-htmlpageref)

(tex-def-prim "\\htmlref" do-htmlref)

(tex-def-prim "\\htmlrefexternal" do-htmlrefexternal)

(tex-def-prim "\\huge" (lambda () (do-switch 'huge)))

(tex-def-prim "\\Huge" (lambda () (do-switch 'huge-cap)))

(tex-def-prim "\\hyperref" do-hyperref)

(tex-def-prim "\\hyperlink" do-hyperlink)

(tex-def-prim "\\hypertarget" do-hypertarget)

(tex-def-prim "\\if" do-if)

(tex-def-prim "\\ifcase" do-ifcase)

(tex-def-prim "\\ifeof" do-ifeof)

(tex-def-prim "\\ifdim" do-iffalse)

(tex-def-prim "\\iffalse" do-iffalse)

(tex-def-prim "\\IfFileExists" do-iffileexists)

(tex-def-prim "\\ifmmode" do-ifmmode)

(tex-def-prim "\\ifnum" (lambda () (do-ifnum)))

(tex-def-prim "\\iftrue" do-iftrue)

(tex-def-prim "\\ifx" do-ifx)

(tex-def-prim "\\ifodd" do-ifodd)

(tex-def-prim
  "\\ignorenextinputtimestamp"
  (lambda ()
    (unless *inputting-boilerplate?* (set! *inputting-boilerplate?* 0))))

(tex-def-prim "\\ignorespaces" ignorespaces)

(tex-def-prim "\\imgdef" (lambda () (make-reusable-img #f)))

(tex-def-prim "\\imgpreamble" do-img-preamble)

(tex-def-prim
  "\\IMGtabbing"
  (lambda () (do-latex-env-as-image "tabbing" 'display)))

(tex-def-prim
  "\\IMGtabular"
  (lambda () (do-latex-env-as-image "tabular" 'display)))

(tex-def-prim "\\include" do-include)

(tex-def-prim "\\includeexternallabels" do-includeexternallabels)

(tex-def-prim "\\includeonly" do-includeonly)

(tex-def-prim "\\includegraphics" do-includegraphics)

(tex-def-prim "\\index" do-index)

(tex-def-prim "\\indexitem" (lambda () (do-indexitem 0)))

(tex-def-prim "\\indexsubitem" (lambda () (do-indexitem 1)))

(tex-def-prim "\\indexsubsubitem" (lambda () (do-indexitem 2)))

(tex-def-prim "\\input" do-input)

(tex-def-prim "\\inputcss" do-inputcss)

(tex-def-prim "\\inputexternallabels" do-inputexternallabels)

(tex-def-prim "\\InputIfFileExists" do-inputiffileexists)

(tex-def-prim "\\inputindex" (lambda () (do-inputindex #f)))

(tex-def-prim "\\it" (lambda () (do-switch 'it)))

(tex-def-prim "\\item" do-item)

(tex-def-prim "\\itemitem" (lambda () (do-plain-item 2)))

(tex-def-prim
  "\\itemize"
  (lambda ()
    (do-end-para)
    (set! *tabular-stack* (cons 'itemize *tabular-stack*))
    (emit "<ul>")))

(tex-def-prim "\\itshape" (lambda () (do-switch 'itshape)))

(tex-def-prim "\\jobname" (lambda () (tex2page-string *jobname*)))

(tex-def-prim "\\label" do-label)

(tex-def-prim "\\large" (lambda () (do-switch 'large)))

(tex-def-prim "\\Large" (lambda () (do-switch 'large-cap)))

(tex-def-prim "\\LARGE" (lambda () (do-switch 'large-up)))

(tex-def-prim "\\LaTeX" do-latex-logo)

(tex-def-prim "\\LaTeXe" do-latex2e-logo)

(tex-def-prim "\\latexonly" (lambda () (ignore-tex-specific-text "latexonly")))

(tex-def-prim
  "\\leftdisplays"
  (lambda () (set! *display-justification* 'left)))

(tex-def-prim "\\leftline" (lambda () (do-function "\\leftline")))

(tex-def-prim "\\let" (lambda () (do-let #f)))

(tex-def-prim
  "\\linebreak"
  (lambda () (get-bracketed-text-if-any) (emit "<br>")))

(tex-def-prim "\\mailto" do-mailto)

(tex-def-prim "\\makehtmlimage" do-makehtmlimage)

(tex-def-prim "\\maketitle" do-maketitle)

(tex-def-prim "\\marginpar" do-marginpar)

(tex-def-prim "\\mathg" do-mathg)

(tex-def-prim "\\mathdg" do-mathdg)

(tex-def-prim "\\mathp" do-mathp)

(tex-def-prim "\\medbreak" (lambda () (do-bigskip "\\medbreak")))

(tex-def-prim "\\medskip" (lambda () (do-bigskip "\\medskip")))

(tex-def-prim "\\message" do-message)

(tex-def-prim "\\mfpic" do-mfpic)

(tex-def-prim "\\minipage" do-minipage)

(tex-def-prim "\\multiply" (lambda () (do-multiply #f)))

(tex-def-prim "\\narrower" (lambda () (do-switch 'narrower)))

(tex-def-prim "\\newcommand" (lambda () (do-newcommand #f)))

(tex-def-prim "\\newcount" (lambda () (do-newcount #f)))

(tex-def-prim "\\newdimen" (lambda () (do-newdimen #f)))

(tex-def-prim "\\newenvironment" (lambda () (do-newenvironment #f)))

(tex-def-prim "\\newif" do-newif)

(tex-def-prim "\\newread" (lambda () (do-new-stream 'in)))

(tex-def-prim "\\newtheorem" do-newtheorem)

(tex-def-prim "\\newtoks" (lambda () (do-newtoks #f)))

(tex-def-prim "\\newwrite" (lambda () (do-new-stream 'out)))

(tex-def-prim
  "\\noad"
  (lambda () (set! *colophon-links-to-tex2page-website?* #f)))

(tex-def-prim "\\nocite" do-nocite)

(tex-def-prim "\\node" do-node)

(tex-def-prim "\\nonumber" do-nonumber)

(tex-def-prim
  "\\noslatexlikecomments"
  (lambda () (set! *slatex-like-comments?* #f)))

(tex-def-prim
  "\\notimestamp"
  (lambda () (set! *colophon-mentions-last-mod-time?* #f)))

(tex-def-prim "\\nr" (lambda () (do-cr "\\nr")))

(tex-def-prim "\\number" do-number)

(tex-def-prim "\\numfootnote" do-numbered-footnote)

(tex-def-prim "\\O" (lambda () (emit "&Oslash;")))

(tex-def-prim "\\o" (lambda () (emit "&oslash;")))

(tex-def-prim "\\obeylines" do-obeylines)

(tex-def-prim "\\obeyspaces" do-obeyspaces)

(tex-def-prim "\\obeywhitespace" do-obeywhitespace)

(tex-def-prim "\\OE" (lambda () (emit *html-oelig*)))

(tex-def-prim "\\oe" (lambda () (emit *html-^oelig*)))

(tex-def-prim "\\opengraphsfile" do-mfpic-opengraphsfile)

(tex-def-prim "\\openin" (lambda () (do-open-stream 'in)))

(tex-def-prim "\\openout" (lambda () (do-open-stream 'out)))

(tex-def-prim "\\pagebreak" (lambda () (get-bracketed-text-if-any) (do-eject)))

(tex-def-prim "\\pageno" (lambda () (emit *html-page-count*)))

(tex-def-prim "\\pageref" do-pageref)

(tex-def-prim "\\part" (lambda () (do-heading -1)))

(tex-def-prim "\\pdfximage" do-pdfximage)

(tex-def-prim
  "\\picture"
  (lambda () (do-latex-env-as-image "picture" 'inline)))

(tex-def-prim "\\plainfootnote" do-plain-footnote)

(tex-def-prim "\\pounds" (lambda () (emit "&pound;")))

(tex-def-prim "\\printindex" (lambda () (do-inputindex #t)))

(tex-def-prim "\\quad" (lambda () (emit-nbsp 4)))

(tex-def-prim "\\qquad" (lambda () (emit-nbsp 8)))

(tex-def-prim
  "\\quote"
  (lambda () (do-end-para) (emit "<blockquote>") (bgroup)))

(tex-def-prim
  "\\endquote"
  (lambda () (do-end-para) (egroup) (emit "</blockquote>")))

(tex-def-prim "\\r" (lambda () (do-diacritic 'ring)))

(tex-def-prim "\\raggedleft" (lambda () (do-switch 'raggedleft)))

(tex-def-prim "\\rawhtml" do-rawhtml)

(tex-def-prim "\\read" (lambda () (do-read #f)))

(tex-def-prim "\\ref" do-ref)

(tex-def-prim "\\refexternal" do-refexternal)

(tex-def-prim "\\relax" do-relax)

(tex-def-prim "\\renewcommand" (lambda () (do-newcommand #t)))

(tex-def-prim "\\renewenvironment" (lambda () (do-newenvironment #t)))

(tex-def-prim "\\resizebox" do-resizebox)

(tex-def-prim "\\rightline" (lambda () (do-function "\\rightline")))

(tex-def-prim "\\rm" (lambda () (if *math-mode?* (do-switch 'rm))))

(tex-def-prim "\\romannumeral" (lambda () (do-romannumeral #f)))

(tex-def-prim "\\Romannumeral" (lambda () (do-romannumeral #t)))

(tex-def-prim "\\ruledtable" do-ruledtable)

(tex-def-prim "\\sc" (lambda () (do-switch 'sc)))

(tex-def-prim
  "\\schemedisplay"
  (lambda () (do-scm-slatex-lines "schemedisplay" #t #f)))

(tex-def-prim
  "\\schemebox"
  (lambda () (do-scm-slatex-lines "schemebox" #f #f)))

(tex-def-prim
  "\\schemeresponse"
  (lambda () (do-scm-slatex-lines "schemeresponse" #t 'result)))

(tex-def-prim
  "\\schemeresponsebox"
  (lambda () (do-scm-slatex-lines "schemeresponsebox" #f 'result)))

(tex-def-prim "\\schemeresult" (lambda () (do-scm 'result)))

(tex-def-prim "\\scm" (lambda () (do-scm #f)))

(tex-def-prim "\\scmbuiltin" do-scm-set-builtins)

(tex-def-prim "\\scmdribble" do-scmdribble)

(tex-def-prim "\\scminput" do-scminput)

(tex-def-prim "\\scmkeyword" do-scm-set-keywords)

(tex-def-prim "\\scmspecialsymbol" do-scm-set-specialsymbol)

(tex-def-prim "\\scmvariable" do-scm-set-variables)

(tex-def-prim "\\scriptsize" (lambda () (do-switch 'scriptsize)))

(tex-def-prim "\\section" (lambda () (do-heading 1)))

(tex-def-prim "\\seealso" do-see-also)

(tex-def-prim "\\setcounter" (lambda () (set-latex-counter #f)))

(tex-def-prim "\\sevenrm" (lambda () (do-switch 'sevenrm)))

(tex-def-prim "\\sf" do-relax)

(tex-def-prim "\\sl" (lambda () (do-switch 'sl)))

(tex-def-prim "\\slatexdisable" get-group)

(tex-def-prim
  "\\slatexlikecomments"
  (lambda () (set! *slatex-like-comments?* #t)))

(tex-def-prim "\\small" (lambda () (do-switch 'small)))

(tex-def-prim "\\smallbreak" (lambda () (do-bigskip "\\smallbreak")))

(tex-def-prim "\\smallskip" (lambda () (do-bigskip "\\smallskip")))

(tex-def-prim "\\ss" (lambda () (emit "&szlig;")))

(tex-def-prim "\\strike" (lambda () (do-switch 'strike)))

(tex-def-prim "\\string" do-string)

(tex-def-prim "\\subject" do-subject)

(tex-def-prim
  "\\subsection"
  (lambda () (get-bracketed-text-if-any) (do-heading 2)))

(tex-def-prim "\\subsubsection" (lambda () (do-heading 3)))

(tex-def-prim "\\symfootnote" do-symfootnote)

(tex-def-prim "\\tabbing" do-tabbing)

(tex-def-prim "\\table" (lambda () (do-table/figure 'table)))

(tex-def-prim "\\tableplain" do-table-plain)

(tex-def-prim "\\tableofcontents" do-toc)

(tex-def-prim "\\tabular" do-tabular)

(tex-def-prim "\\tag" do-tag)

(tex-def-prim "\\TeX" do-tex-logo)

(tex-def-prim "\\texonly" (lambda () (ignore-tex-specific-text "texonly")))

(tex-def-prim "\\textasciicircum" (lambda () (emit "^")))

(tex-def-prim "\\textbar" (lambda () (emit "|")))

(tex-def-prim "\\textbackslash" (lambda () (emit "\\")))

(tex-def-prim "\\textbf" (lambda () (do-function "\\textbf")))

(tex-def-prim "\\textbullet" (lambda () (emit *html-bull*)))

(tex-def-prim "\\textdegree" (lambda () (emit "&deg;")))

(tex-def-prim "\\textemdash" (lambda () (emit *html-mdash*)))

(tex-def-prim "\\textendash" (lambda () (emit *html-ndash*)))

(tex-def-prim "\\textexclamdown" (lambda () (emit "&iexcl;")))

(tex-def-prim "\\textgreater" (lambda () (emit "&gt;")))

(tex-def-prim "\\textit" (lambda () (do-function "\\textit")))

(tex-def-prim "\\textless" (lambda () (emit "&lt;")))

(tex-def-prim "\\textperiodcentered" (lambda () (emit "&middot;")))

(tex-def-prim "\\textquestiondown" (lambda () (emit "&iquest;")))

(tex-def-prim "\\textquotedblleft" (lambda () (emit *html-ldquo*)))

(tex-def-prim "\\textquotedblright" (lambda () (emit *html-rdquo*)))

(tex-def-prim "\\textquoteleft" (lambda () (emit *html-lsquo*)))

(tex-def-prim "\\textquoteright" (lambda () (emit *html-rsquo*)))

(tex-def-prim "\\textregistered" (lambda () (emit "&reg;")))

(tex-def-prim "\\textrm" (lambda () (do-function "\\textrm")))

(tex-def-prim
  "\\textsc"
  (lambda ()
    (fluid-let ((*in-small-caps?* #t)) (tex2page-string (get-group)))))

(tex-def-prim "\\textsl" (lambda () (do-function "\\textsl")))

(tex-def-prim "\\textasciitilde" (lambda () (emit "~")))

(tex-def-prim "\\texttrademark" (lambda () (emit *html-trade*)))

(tex-def-prim "\\texttt" (lambda () (do-function "\\texttt")))

(tex-def-prim "\\textvisiblespace" emit-visible-space)

(tex-def-prim "\\TH" (lambda () (emit "&THORN;")))

(tex-def-prim "\\th" (lambda () (emit "&thorn;")))

(tex-def-prim "\\the" do-the)

(tex-def-prim "\\thebibliography" do-thebibliography)

(tex-def-prim "\\theindex" do-theindex)

(tex-def-prim "\\TIIPbackslash" (lambda () (emit "\\")))

(tex-def-prim "\\TIIPbr" do-br)

(tex-def-prim "\\TIIPcmyk" (lambda () (do-switch 'cmyk)))

(tex-def-prim "\\TIIPcomment" eat-till-eol)

(tex-def-prim "\\TIIPeatstar" eat-star)

(tex-def-prim "\\TIIPendgraf" do-end-para)

(tex-def-prim "\\TIIPgobblegroup" get-group)

(tex-def-prim "\\TIIPgray" (lambda () (do-switch 'gray)))

(tex-def-prim "\\TIIPlatexenvasimage" do-following-latex-env-as-image)

(tex-def-prim "\\TIIPnbsp" (lambda () (emit-nbsp 1)))

(tex-def-prim "\\TIIPnewline" do-newline)

(tex-def-prim "\\TIIPnull" get-actual-char)

(tex-def-prim "\\TIIPreuseimage" reuse-img)

(tex-def-prim "\\TIIPrgb" (lambda () (do-switch 'rgb)))

(tex-def-prim "\\TIIPRGB" (lambda () (do-switch 'rgb255)))

(tex-def-prim "\\TIIPtheorem" do-theorem)

(tex-def-prim "\\tiny" (lambda () (do-switch 'tiny)))

(tex-def-prim "\\title" do-title)

(tex-def-prim "\\today" do-today)

(tex-def-prim "\\trademark" (lambda () (emit *html-trade*)))

(tex-def-prim "\\tracingall" do-tracingall)

(tex-def-prim "\\tracingcommands" (lambda () (do-tracingcommands #f)))

(tex-def-prim "\\tracingmacros" (lambda () (do-tracingmacros #f)))

(tex-def-prim "\\tt" (lambda () (do-switch 'tt)))

(tex-def-prim "\\typein" do-typein)

(tex-def-prim "\\undefcsactive" do-undefcsactive)

(tex-def-prim "\\undefschememathescape" (lambda () (scm-set-mathescape #f)))

(tex-def-prim "\\underline" (lambda () (do-function "\\underline")))

(tex-def-prim "\\unscmspecialsymbol" do-scm-unset-specialsymbol)

(tex-def-prim "\\url" do-url)

(tex-def-prim "\\urlh" do-urlh)

(tex-def-prim "\\urlhd" do-urlhd)

(tex-def-prim "\\urlp" do-urlp)

(tex-def-prim "\\v" (lambda () (do-diacritic 'hacek)))

(tex-def-prim
  "\\vdots"
  (lambda ()
    (emit "<tt><table><tr><td>.</td></tr>")
    (emit "<tr><td>.</td></tr>")
    (emit "<tr><td>.</td></tr></table></tt>")))

(tex-def-prim "\\verb" do-verb)

(tex-def-prim "\\verbatim" do-verbatim-latex)

(tex-def-prim "\\verbatiminput" do-verbatiminput)

(tex-def-prim "\\verbc" do-verbc)

(tex-def-prim "\\verbescapechar" do-verbescapechar)

(tex-def-prim "\\verbwrite" do-verbwrite)

(tex-def-prim "\\verbwritefile" do-verbwritefile)

(tex-def-prim "\\vskip" (lambda () (eat-dimen) (do-bigskip "vskip")))

(tex-def-prim "\\vspace" do-vspace)

(tex-def-prim "\\write" do-write)

(tex-def-prim "\\xspace" do-xspace)

(tex-def-prim "\\yen" (lambda () (emit "&yen;")))

(tex-def-prim "\\contentsname" (lambda () (emit "Contents")))

(tex-def-prim "\\listfigurename" (lambda () (emit "List of Figures")))

(tex-def-prim "\\listtablename" (lambda () (emit "List of Tables")))

(tex-def-prim "\\refname" (lambda () (emit "References")))

(tex-def-prim "\\indexname" (lambda () (emit "Index")))

(tex-def-prim "\\figurename" (lambda () (emit "Figure")))

(tex-def-prim "\\tablename" (lambda () (emit "Table")))

(tex-def-prim "\\partname" (lambda () (emit "Part")))

(tex-def-prim "\\appendixname" (lambda () (emit "Appendix")))

(tex-def-prim "\\abstractname" (lambda () (emit "Abstract")))

(tex-def-prim "\\bibname" (lambda () (emit "Bibliography")))

(tex-def-prim "\\chaptername" (lambda () (emit "Chapter")))

(tex-def-prim "\\\\" (lambda () (do-cr "\\\\")))

(tex-def-prim "\\`" (lambda () (do-diacritic 'grave)))

(tex-def-prim "\\(" do-latex-in-text-math)

(tex-def-prim "\\[" do-latex-display-math)

(tex-def-prim "\\)" egroup)

(tex-def-prim "\\]" egroup)

(tex-def-prim "\\{" (lambda () (emit "{")))

(tex-def-prim "\\}" (lambda () (emit "}")))

(tex-let-prim "\\-" "\\relax")

(tex-def-prim "\\'" (lambda () (do-diacritic 'acute)))

(tex-def-prim
  "\\="
  (lambda ()
    (unless (and
             (not (null? *tabular-stack*))
             (eqv? (car *tabular-stack*) 'tabbing))
      (do-diacritic 'circumflex))))

(tex-def-prim
  "\\>"
  (lambda ()
    (if (and (not (null? *tabular-stack*))
             (eqv? (car *tabular-stack*) 'tabbing))
      (emit-nbsp 3))))

(tex-def-prim "\\^" (lambda () (do-diacritic 'circumflex)))

(tex-def-prim "\\~" (lambda () (do-diacritic 'tilde)))

(tex-def-prim "\\#" (lambda () (emit "#")))

(tex-def-prim "\\ " (lambda () (emit #\space)))

(tex-def-prim "\\%" (lambda () (emit "%")))

(tex-def-prim "\\&" (lambda () (emit "&amp;")))

(tex-def-prim "\\@" (lambda () (emit "@")))

(tex-def-prim "\\_" (lambda () (emit "_")))

(tex-def-prim "\\$" (lambda () (emit "$")))

(tex-def-prim (string #\\ #\newline) emit-newline)

(tex-let-prim "\\displaystyle" "\\relax")

(tex-let-prim "\\textstyle" "\\relax")

(tex-let-prim "\\endsloppypar" "\\relax")

(tex-let-prim "\\frenchspacing" "\\relax")

(tex-let-prim "\\noindent" "\\relax")

(tex-let-prim "\\oldstyle" "\\relax")

(tex-let-prim "\\protect" "\\relax")

(tex-let-prim "\\raggedbottom" "\\relax")

(tex-let-prim "\\raggedright" "\\relax")

(tex-let-prim "\\sloppy" "\\relax")

(tex-let-prim "\\sloppypar" "\\relax")

(tex-let-prim "\\normalfont" "\\relax")

(tex-let-prim "\\textnormal" "\\relax")

(tex-let-prim "\\unskip" "\\relax")

(tex-def-prim "\\font" eat-till-eol)

(tex-def-prim "\\cline" get-group)

(tex-def-prim "\\externalref" get-group)

(tex-def-prim "\\GOBBLEARG" get-group)

(tex-def-prim "\\hyphenation" get-group)

(tex-def-prim "\\newcounter" get-group)

(tex-def-prim "\\newlength" get-group)

(tex-def-prim "\\hphantom" get-group)

(tex-def-prim "\\vphantom" get-group)

(tex-def-prim "\\phantom" get-group)

(tex-def-prim "\\pagenumbering" get-group)

(tex-def-prim "\\pagestyle" get-group)

(tex-def-prim "\\raisebox" get-group)

(tex-def-prim "\\thispagestyle" get-group)

(tex-def-prim "\\externallabels" (lambda () (get-group) (get-group)))

(tex-let-prim "\\markboth" "\\externallabels")

(tex-def-prim "\\hbadness" eat-integer)

(tex-def-prim "\\exhyphenpenalty" eat-integer)

(tex-def-prim "\\hyphenpenalty" eat-integer)

(tex-def-prim "\\showboxdepth" eat-integer)

(tex-def-prim "\\pretolerance" eat-integer)

(tex-def-prim "\\tolerance" eat-integer)

(tex-def-prim "\\widowpenalty" eat-integer)

(tex-def-prim "\\baselineskip" eat-dimen)

(tex-def-prim "\\columnsep" eat-dimen)

(tex-def-prim "\\columnseprule" eat-dimen)

(tex-def-prim "\\evensidemargin" eat-dimen)

(tex-def-prim "\\fboxsep" eat-dimen)

(tex-def-prim "\\headsep" eat-dimen)

(tex-def-prim "\\itemsep" eat-dimen)

(tex-def-prim "\\kern" eat-dimen)

(tex-def-prim "\\leftcodeskip" eat-dimen)

(tex-def-prim "\\lower" eat-dimen)

(tex-def-prim "\\oddsidemargin" eat-dimen)

(tex-def-prim "\\overfullrule" eat-dimen)

(tex-def-prim "\\parindent" eat-dimen)

(tex-def-prim "\\parsep" eat-dimen)

(tex-def-prim "\\parskip" eat-dimen)

(tex-def-prim "\\raise" eat-dimen)

(tex-def-prim "\\rightcodeskip" eat-dimen)

(tex-def-prim "\\sidemargin" eat-dimen)

(tex-def-prim "\\textheight" eat-dimen)

(tex-def-prim "\\textwidth" eat-dimen)

(tex-def-prim "\\topmargin" eat-dimen)

(tex-def-prim "\\topsep" eat-dimen)

(tex-def-prim "\\vertmargin" eat-dimen)

(tex-def-prim "\\addtolength" (lambda () (get-token) (get-token)))

(tex-let-prim "\\addvspace" "\\vspace")

(tex-let-prim "\\setlength" "\\addtolength")

(tex-let-prim "\\settowidth" "\\addtolength")

(tex-let-prim "\\hookaction" "\\addtolength")

(tex-def-prim "\\enlargethispage" (lambda () (eat-star) (get-group)))

(tex-def-prim "\\parbox" (lambda () (get-bracketed-text-if-any) (get-group)))

(tex-def-prim
  "\\ProvidesFile"
  (lambda () (get-group) (get-bracketed-text-if-any)))

(tex-def-prim
  "\\addcontentsline"
  (lambda () (get-group) (get-group) (get-group)))

(tex-def-prim
  "\\makebox"
  (lambda () (get-bracketed-text-if-any) (get-bracketed-text-if-any)))

(tex-let-prim "\\framebox" "\\makebox")

(tex-def-prim
  "\\rule"
  (lambda () (get-bracketed-text-if-any) (get-group) (get-group)))

(tex-def-prim "\\GOBBLEOPTARG" get-bracketed-text-if-any)

(tex-def-prim "\\nolinebreak" get-bracketed-text-if-any)

(tex-def-prim "\\nopagebreak" get-bracketed-text-if-any)

(tex-def-prim "\\hyphenchar" (lambda () (get-token) (eat-integer)))

(tex-def-prim
  "\\usepackage"
  (lambda () (get-bracketed-text-if-any) (get-group) (probably-latex)))

(tex-def-prim "\\readindexfile" (lambda () (get-token) (do-inputindex #f)))

(tex-let-prim "\\enskip" "\\enspace")

(tex-let-prim "\\colophon" "\\htmlcolophon")

(tex-let-prim "\\path" "\\verb")

(tex-let-prim "\\par" "\\endgraf")

(tex-let-prim "\\u" "\\`")

(tex-let-prim "\\vbox" "\\hbox")

(tex-let-prim "\\endabstract" "\\endquote")

(tex-let-prim "\\mbox" "\\hbox")

(tex-let-prim "\\supereject" "\\eject")

(tex-let-prim "\\dosupereject" "\\eject")

(tex-let-prim "\\endgroup" "\\egroup")

(tex-let-prim "\\begingroup" "\\bgroup")

(tex-let-prim "\\d" "\\b")

(tex-let-prim "\\." "\\b")

(tex-let-prim "\\k" "\\c")

(tex-let-prim "\\ldots" "\\dots")

(tex-let-prim "\\documentstyle" "\\documentclass")

(tex-let-prim "\\edef" "\\def")

(tex-let-prim "\\H" "\\\"")

(tex-let-prim "\\/" "\\relax")

(tex-let-prim "\\leavevmode" "\\relax")

(tex-let-prim "\\space" "\\ ")

(tex-let-prim "\\quotation" "\\quote")

(tex-let-prim "\\endquotation" "\\endquote")

(tex-let-prim "\\xdef" "\\gdef")

(tex-let-prim "\\TIIPdate" "\\today")

(tex-let-prim "\\schemeinput" "\\scminput")

(tex-let-prim "\\sidx" "\\index")

(tex-let-prim "\\obeywhitespaces" "\\obeywhitespace")

(tex-let-prim "\\ensuremath" "\\mathg")

(tex-let-prim "\\epsffile" "\\epsfbox")

(tex-let-prim "\\iffileexists" "\\IfFileExists")

(tex-let-prim "\\htmlimgformat" "\\htmlimageformat")

(tex-let-prim "\\p" "\\verb")

(tex-let-prim "\\ttraggedright" "\\tt")

(tex-let-prim "\\ttfamily" "\\tt")

(tex-let-prim "\\htmladdnormallink" "\\urlp")

(tex-let-prim "\\htmladdnormallinkfoot" "\\urlp")

(tex-let-prim "\\pagehtmlref" "\\htmlref")

(tex-let-prim "\\circledR" "\\textregistered")

(tex-let-prim "\\registered" "\\textregistered")

(tex-let-prim "\\href" "\\urlhd")

(tex-let-prim "\\scmconstant" "\\scmbuiltin")

(tex-let-prim "\\setbuiltin" "\\scmbuiltin")

(tex-let-prim "\\setconstant" "\\scmconstant")

(tex-let-prim "\\setkeyword" "\\scmkeyword")

(tex-let-prim "\\setvariable" "\\scmvariable")

(tex-let-prim "\\unssetspecialsymbol" "\\unscmspecialsymbol")

(tex-let-prim "\\setspecialsymbol" "\\scmspecialsymbol")

(tex-let-prim "\\scmp" "\\scm")

(tex-let-prim "\\q" "\\scm")

(tex-let-prim "\\scheme" "\\scm")

(tex-let-prim "\\tagref" "\\ref")

(tex-let-prim "\\numberedfootnote" "\\numfootnote")

(tex-let-prim "\\f" "\\numfootnote")

(tex-let-prim "\\newpage" "\\eject")

(tex-let-prim "\\clearpage" "\\eject")

(tex-let-prim "\\cleardoublepage" "\\eject")

(tex-let-prim "\\htmlpagebreak" "\\eject")

(tex-let-prim "\\typeout" "\\message")

(tex-let-prim "\\unorderedlist" "\\itemize")

(tex-let-prim "\\htmlstylesheet" "\\inputcss")

(tex-let-prim "\\hr" "\\hrule")

(tex-let-prim "\\htmlrule" "\\hrule")

(tex-let-prim "\\numberedlist" "\\enumerate")

(tex-let-prim "\\orderedlist" "\\enumerate")

(tex-let-prim "\\endunorderedlist" "\\enditemize")

(tex-let-prim "\\endnumberedlist" "\\endenumerate")

(tex-let-prim "\\endorderedlist" "\\endenumerate")

(tex-let-prim "\\newline" "\\break")

(tex-let-prim "\\gifdef" "\\imgdef")

(tex-let-prim "\\schemeeval" "\\eval")

(tex-let-prim "\\gifpreamble" "\\imgpreamble")

(tex-let-prim "\\mathpreamble" "\\imgpreamble")

(tex-let-prim "\\scmverbatim" "\\scm")

(tex-let-prim "\\scmfilename" "\\verbwritefile")

(tex-let-prim "\\scmwritefile" "\\verbwritefile")

(tex-let-prim "\\verbfilename" "\\verbwritefile")

(tex-let-prim "\\scmfileonly" "\\verbwrite")

(tex-let-prim "\\scmverbatimfile" "\\scminput")

(tex-let-prim "\\scmverbatiminput" "\\scminput")

(tex-let-prim "\\scmwrite" "\\verbwrite")

(tex-let-prim "\\scmfile" "\\scmdribble")

(tex-let-prim "\\scmverb" "\\scm")

(tex-let-prim "\\verbinput" "\\verbatiminput")

(tex-let-prim "\\verbatimfile" "\\verbatiminput")

(tex-let-prim "\\setverbatimescapechar" "\\verbescapechar")

(tex-let-prim "\\nohtmlmathimg" "\\dontuseimgforhtmlmath")

(tex-let-prim "\\nohtmlmathintextimg" "\\dontuseimgforhtmlmathintext")

(tex-let-prim "\\nohtmlmathdisplayimg" "\\dontuseimgforhtmlmathdisplay")

(define tex2page
  (lambda (tex-file)
    (unless (= *write-log-index* 0) (newline))
    (fluid-let
      ((*afterpar* '())
       (*aux-dir* #f)
       (*aux-dir/* "")
       (*aux-port* #f)
       (*bib-aux-port* #f)
       (*bibitem-num* 0)
       (*colophon-links-to-tex2page-website?*
         *colophon-links-to-tex2page-website?*)
       (*colophon-mentions-last-mod-time?* *colophon-mentions-last-mod-time?*)
       (*colophon-mentions-tex2page?* *colophon-mentions-tex2page?*)
       (*colophon-on-first-page?* *colophon-on-first-page?*)
       (*color-names* '())
       (*comment-char* #\%)
       (*css-port* #f)
       (*current-tex2page-input* #f)
       (*current-tex-file* #f)
       (*display-justification* 'center)
       (*dotted-counters* (make-table 'equ string=?))
       (*dumping-nontex?* #f)
       (*equation-number* #f)
       (*equation-numbered?* #t)
       (*equation-position* 0)
       (*esc-char* #\\)
       (*esc-char-std* #\\)
       (*esc-char-verb* #\|)
       (*eval-file-count* 0)
       (*eval-for-tex-only?* #f)
       (*external-label-tables* (make-table 'equ string=?))
       (*footnote-list* '())
       (*footnote-sym* 0)
       (*global-texframe* (make-texframe))
       (*graphics-file-extensions* '(".eps"))
       (*html* #f)
       (*html-head* '())
       (*html-only* 0)
       (*html-page* #f)
       (*html-page-count* 0)
       (*image-format* *image-format*)
       (*img-file-count* 0)
       (*img-file-extn* (find-img-file-extn))
       (*img-file-tally* 0)
       (*imgdef-file-count* 0)
       (*imgpreamble* "")
       (*imgpreamble-inferred* '())
       (*in-alltt?* #f)
       (*in-display-math?* #f)
       (*in-para?* #f)
       (*in-small-caps?* #f)
       (*includeonly-list* #t)
       (*index-table* (make-table))
       (*index-count* 0)
       (*index-page* #f)
       (*index-port* #f)
       (*infructuous-calls-to-tex2page* 0)
       (*input-line-no* #f)
       (*input-streams* '())
       (*inputting-boilerplate?* #f)
       (*inside-appendix?* #f)
       (*jobname* "texput")
       (*label-port* #f)
       (*label-source* #f)
       (*label-table* (make-table 'equ string=?))
       (*last-modification-time* #f)
       (*last-page-number* -1)
       (*latex-probability* 0)
       (*ligatures?* #t)
       (*loading-external-labels?* #f)
       (*log-file* #f)
       (*log-port* #f)
       (*main-tex-file* #f)
       (*math-mode?* #f)
       (*mfpic-file-num* #f)
       (*mfpic-file-stem* #f)
       (*mfpic-port* #f)
       (*missing-eps-files* '())
       (*missing-pieces* '())
       (*mp-files* '())
       (*not-processing?* #f)
       (*output-streams* '())
       (*outputting-external-title?* #f)
       (*outputting-to-non-html?* #f)
       (*recent-node-name* #f)
       (*scm-dribbling?* #f)
       (*section-counter-dependencies* (make-table))
       (*section-counters* (make-table))
       (*slatex-like-comments?* #f)
       (*slatex-math-escape* #f)
       (*source-changed-since-last-run?* #f)
       (*stylesheets* '())
       (*subjobname* #f)
       (*tabular-stack* '())
       (*temp-string-count* 0)
       (*tex2page-inputs* (path-to-list (getenv "TIIPINPUTS")))
       (*tex-env* '())
       (*tex-format* 'plain)
       (*tex-if-stack* '())
       (*title* #f)
       (*toc-list* '())
       (*toc-page* #f)
       (*tracingcommands?* #f)
       (*tracingmacros?* #f)
       (*unresolved-xrefs* '())
       (*use-image-for-displayed-math?* #t)
       (*use-image-for-intext-math?* #t)
       (*using-bibliography?* #f)
       (*using-chapters?* #f)
       (*using-index?* #f)
       (*verb-display?* #f)
       (*verb-port* #f)
       (*verb-visible-space?* #f)
       (*verb-written-files* '())
       (*write-log-index* 0)
       (*write-log-possible-break?* #f)
       (*zeroth-html-page* #f))
      (when *use-advanced-html-entities?* (html-advanced-entities))
      (set! *main-tex-file*
        (actual-tex-filename tex-file (check-input-file-timestamp? tex-file)))
      (write-log "This is TeX2page, Version ")
      (write-log *tex2page-version*)
      (write-log #\space)
      (write-log #\()
      (write-log *scheme-version*)
      (write-log #\,)
      (write-log #\space)
      (write-log *operating-system*)
      (write-log #\))
      (write-log 'separation-newline)
      (cond
       (*main-tex-file*
        (set! *subjobname* *jobname*)
        (set! *zeroth-html-page*
          (let ((ext (file-extension *main-tex-file*)))
            (string-append
              *jobname*
              (if (and ext
                       (string-ci=? ext *output-extension*)
                       (not *aux-dir*))
                (string-append *html-page-suffix* "0" *output-extension*)
                *output-extension*))))
        (set! *html-page* (string-append *aux-dir/* *zeroth-html-page*))
        (ensure-file-deleted *html-page*)
        (set! *html* (open-output-file *html-page*))
        (do-start)
        (let ((t2p-file
                (actual-tex-filename (string-append *jobname* ".t2p") #f)))
          (when t2p-file
            (fluid-let
              ((*html-only* (+ *html-only* 1)))
              (tex2page-file t2p-file))))
        (unless (eqv? (tex2page-file *main-tex-file*) ':encountered-bye)
          (insert-missing-end))
        (do-bye))
       (else (tex2page-help tex-file)))
      (output-stats))))


)