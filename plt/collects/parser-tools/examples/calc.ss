;; An interactive calculator inspired by the calculator example in the bison manual.


;; Import the parser and lexer generators.
(require (lib "yacc.ss" "parser-tools")
         (lib "lex.ss" "parser-tools")
         (lib "readerr.ss" "syntax"))

(define-tokens value-tokens (NUM VAR FNCT))
(define-empty-tokens op-tokens (newline = OP CP + - * / ^ EOF NEG))

;; A hash table to store variable values in for the calculator
(define vars (make-hash-table))

(define-lex-abbrevs
 (lower-letter (- "a" "z"))

 (upper-letter (- #\A #\Z))

 ;; (- 0 9) would not work because the lexer does not understand numbers.  (- #\0 #\9) is ok too.
 (digit (- "0" "9")))
 
(define calcl
  (lexer
   [(eof) 'EOF]
   ;; recursively call the lexer on the remaining input after a tab or space.  Returning the
   ;; result of that operation.  This effectively skips all whitespace.
   [(: #\tab #\space) (calcl input-port)]
   ;; The parser will treat the return of 'newline the same as (token-newline)
   [#\newline 'newline]
   [(: "=" "+" "-" "*" "/" "^") (string->symbol lexeme)]
   ["(" 'OP]
   [")" 'CP]
   ["sin" (token-FNCT sin)]
   [(+ (: lower-letter upper-letter)) (token-VAR (string->symbol lexeme))]
   [(+ digit) (token-NUM (string->number lexeme))]
   ;; Strings which dr/mzscheme does not think of as symbols (such as . or ,) must be
   ;; entered as a string or character.  "." would also be ok.
   [(@ (+ digit) #\. (* digit)) (token-NUM (string->number lexeme))]))
   

(define calcp
  (parser

   (start start)
   (end newline EOF)
   (tokens value-tokens op-tokens)
   (error (lambda (a b c) (void)))

   (precs (right =)
          (left - +)
          (left * /)
          (left NEG)
          (right ^))
   
   (grammar
    
    (start [() #f]
           ;; If there is an error, ignore everything before the error
           ;; and try to start over right after the error
           [(error start) $2]
           [(exp) $1])
    
    (exp [(NUM) $1]
         [(VAR) (hash-table-get vars $1 (lambda () 0))]
         [(VAR = exp) (begin (hash-table-put! vars $1 $3)
                             $3)]
         [(FNCT OP exp CP) ($1 $3)]
         [(exp + exp) (+ $1 $3)]
         [(exp - exp) (+ $1 $3)]
         [(exp * exp) (* $1 $3)]
         [(exp / exp) (/ $1 $3)]
         [(- exp) (prec NEG) (- $2)]
         [(exp ^ exp) (expt $1 $3)]
         [(OP exp CP) $2]))))
           
;; run the calculator on the given input-port       
(define (calc ip)
  (port-count-lines! ip)
  (letrec ((one-line
	    (lambda ()
	      (let ((result (calcp (lambda () (calcl ip)))))
		(if result
		    (begin
		      (printf "~a~n" result)
		      (one-line)))))))
    (one-line)))