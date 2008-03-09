
(module link-unit mzscheme
  (require (lib "unitsig.ss")
	   (lib "include.ss")
	   (lib "process.ss")
	   (lib "sendevent.ss")
	   "private/dirs.ss")

  (require "link-sig.ss")

  (provide dynext:link@)

  (define dynext:link@
    (unit/sig dynext:link^
      (import)

      ;; ---- Find a linker for this platform --------------------
      
      (define (get-windows-linker)
	(or (find-executable-path "cl.exe" #f)
	    (find-executable-path "ld.exe" #f)
	    (find-executable-path "ilink32.exe" #f)))

      (define (get-unix-linker)
	(or (getenv "MZSCHEME_DYNEXT_LINKER")
	    (let ([s (case (string->symbol (system-library-subpath))
		       [(rs6k-aix ppc-macosx ppc-darwin) "cc"]
		       [else "ld"])])
	      (find-executable-path s s))))
      
      ;; See doc.txt:
      (define current-extension-linker 
	(make-parameter 
	 (case (system-type) 
	   [(unix macosx) (get-unix-linker)]
	   [(windows) (get-windows-linker)]
	   [else #f])
	 (lambda (v)
	   (when v 
	     (if (and (string? v) (or (relative-path? v) (absolute-path? v)))
		 (unless (and (file-exists? v)
			      (memq 'execute (file-or-directory-permissions v)))
		   (error 'current-extension-linker 
			  "linker not found or not executable: ~s" v))
		 (raise-type-error 'current-extension-linker "pathname string or #f" v)))
	   v)))

      ;; Helpers to tell us about the selected linker in Windows:
      
      (define (still-win-gcc?)
	(and (eq? 'windows (system-type))
	     (let ([c (current-extension-linker)])
	       (and c (regexp-match "ld.exe$" c)))))
      (define (still-win-borland?)
	(and (eq? 'windows (system-type))
	     (let ([c (current-extension-linker)])
	       (and c (regexp-match "ilink32.exe$" c)))))

      (define win-gcc? (still-win-gcc?))
      (define win-borland? (still-win-borland?))
      
      ;; ---- The right flags for this platform+linker --------------------
      
      ;; We need 
      ;;   1) the basic flags
      ;;   2) a way to wrap inputs on the command line
      ;;   3) a way to wrap the output on the command line
      ;;   4) needed base libraries and objects

      (define link-variant (make-parameter 
			    'normal
			    (lambda (s)
			      (unless (memq s '(normal 3m))
				(raise-type-error 'link-variant "'normal or '3m" s))
			      s)))

      (define (wrap-3m s)
	(lambda ()
	  (list (format s (if (eq? '3m (link-variant)) "3m" "")))))

      (define (drop-3m s)
	(lambda ()
	  (if (eq? '3m (link-variant))
	      null
	      (list s))))
      
      (define (expand-for-link-variant l)
	(apply append (map (lambda (s) (if (string? s) (list s) (s))) l)))


      (define (get-unix-link-flags)
	(case (string->symbol (system-library-subpath))
	  [(sparc-solaris i386-solaris) (list "-G")]
	  [(sparc-sunos4) (list "-Bdynamic")]
	  [(i386-freebsd-2.x) (list "-Bshareable")]
	  [(rs6k-aix) (list "-bM:SRE"
			    "-brtl"
			    (lambda () 
			      (map (lambda (mz-exp)
				     (format "-bI:~a/~a" include-dir mz-exp))
				   ((wrap-3m "mzscheme~a.exp"))))
			    (format "-bE:~a/ext.exp" include-dir)
			    "-bnoentry")]
	  [(parisc-hpux) (list "-b")]
	  [(ppc-macosx ppc-darwin) (list "-bundle" "-flat_namespace" "-undefined" "suppress")]
	  [else (list "-shared")]))

      (define msvc-linker-flags (list "/LD"))
      (define win-gcc-linker-flags (list "--dll"))
      (define borland-linker-flags (list "/Tpd" "/c"))
      
      ;; See doc.txt:
      (define current-extension-linker-flags
	(make-parameter
	 (case (system-type)
	   [(unix macosx) (get-unix-link-flags)]
	   [(windows) (cond
		       [win-gcc? win-gcc-linker-flags]
		       [win-borland? borland-linker-flags]
		       [else msvc-linker-flags])]
	   [(macos) null])
	 (lambda (l)
	   (unless (and (list? l) (andmap string? l))
	     (raise-type-error 'current-extension-linker-flags "list of strings" l))
	   l)))

      ;; See doc.txt:
      (define current-make-link-input-strings
	(make-parameter
	 (lambda (s) (list s))
	 (lambda (p)
	   (unless (procedure-arity-includes? p 1)
	     (raise-type-error 'current-make-link-input-strings "procedure of arity 1" p))
	   p)))
            
      (define win-gcc-link-output-strings (lambda (s) (list "--base-file"
							    (make-win-gcc-temp "base")
							    "-e" "_dll_entry@12" 
							    "-o" s)))
      (define msvc-link-output-strings (lambda (s) (list (string-append "/Fe" s))))
      (define borland-link-output-strings (lambda (s) (list "," s
							    "," "," "c0d32.obj" "cw32.lib" "import32.lib"
							    "," (build-path std-library-dir 
									    "bcc" 
									    "mzdynb.def"))))
      
      ;; See doc.txt:
      (define current-make-link-output-strings
	(make-parameter
	 (case (system-type)
	   [(unix macosx) (lambda (s) (list "-o" s))]
	   [(windows) (cond
		       [win-gcc? win-gcc-link-output-strings]
		       [win-borland? borland-link-output-strings]
		       [else msvc-link-output-strings])]
	   [(macos) (lambda (s) (list "-o" s))])
	 (lambda (p)
	   (unless (procedure-arity-includes? p 1)
	     (raise-type-error 'current-make-link-output-strings "procedure of arity 1" p))
	   p)))

      (define (make-win-link-libraries win-gcc? win-borland?)
	(let* ([file (lambda (f)
                       (build-path std-library-dir 
                                   (cond
                                     [win-gcc? "gcc"]
                                     [win-borland? "bcc"]
                                     [else "msvc"])
                                   f))]
               [filethunk (lambda (f)
                            (lambda ()
			      (map file (f))))]
	       [wrap-xxxxxxx (lambda (f)
                               (lambda ()
				 (map (lambda (s)
					(let ([ver (substring (regexp-replace*
							       "alpha"
							       (format "~a_000000000" (version))
							       "a")
							      0
							      7)])
					  (if (file-exists? (file (format s ver)))
					      (file (format s ver))
					      (file (format s "xxxxxxx")))))
				      (f))))])
	  (cond
	   [win-gcc? (list (wrap-xxxxxxx (wrap-3m "libmzsch~a~~a.lib"))
			   (wrap-xxxxxxx (drop-3m "libmzgc~a.lib"))
			   (filethunk (wrap-3m "mzdyn~a.exp"))
			   (filethunk (wrap-3m "mzdyn~a.o"))
			   (file "init.o")
			   (file "fixup.o"))]
	   [win-borland? (map file (list "mzdynb.obj"))]
	   [else (list (wrap-xxxxxxx (wrap-3m "libmzsch~a~~a.lib"))
		       (wrap-xxxxxxx (drop-3m "libmzgc~a.lib"))
		       (filethunk (wrap-3m "mzdyn~a.exp"))
		       (filethunk (wrap-3m "mzdyn~a.obj")))])))
      
      (define (get-unix/macos-link-libraries)
	(list (lambda ()
		(map (lambda (mz.o)
		       (build-path std-library-dir mz.o))
		     ((wrap-3m "mzdyn~a.o"))))))

      ;; See doc.txt:
      (define current-standard-link-libraries
	(make-parameter
	 (case (system-type)
	   [(unix macos macosx) (get-unix/macos-link-libraries)]
	   [(windows) (make-win-link-libraries win-gcc? win-borland?)])
	 (lambda (l)
	   (unless (and (list? l) 
			(andmap (lambda (s) (or (string? s)
						(and (procedure? s) (procedure-arity-includes? s 0))))
				l))
	     (raise-type-error 'current-stand-link-libraries "list of strings and thunks" l))
	   l)))
      
      ;; ---- Function to install standard linker parameters --------------------

      ;; see doc.txt
      (define (use-standard-linker name)
	(define (bad-name name)
	  (error 'use-standard-linker "unknown linker: ~a" name))
	(case (system-type)
	  [(unix macosx) 
	   (case name
	     [(cc gcc) (current-extension-linker (get-unix-linker))
	      (current-extension-linker-flags (get-unix-link-flags))
	      (current-make-link-input-strings (lambda (s) (list s)))
	      (current-make-link-output-strings (lambda (s) (list "-o" s)))
	      (current-standard-link-libraries (get-unix/macos-link-libraries))]
	     [else (bad-name name)])]
	  [(windows)
	   (case name
	     [(gcc) (let ([f (find-executable-path "ld.exe" #f)])
		      (unless f
			(error 'use-standard-linker "cannot find gcc's ld.exe"))
		      (current-extension-linker f)
		      (current-extension-linker-flags win-gcc-linker-flags)
		      (current-make-link-input-strings (lambda (s) (list s)))
		      (current-make-link-output-strings win-gcc-link-output-strings)
		      (current-standard-link-libraries (make-win-link-libraries #t #f)))]
	     [(borland) (let ([f (find-executable-path "ilink32.exe" #f)])
			  (unless f
			    (error 'use-standard-linker "cannot find ilink32.exe"))
			  (current-extension-linker f)
			  (current-extension-linker-flags borland-linker-flags)
			  (current-make-link-input-strings (lambda (s) (list s)))
			  (current-make-link-output-strings borland-link-output-strings)
			  (current-standard-link-libraries (make-win-link-libraries #f #t)))]
	     [(msvc) (let ([f (find-executable-path "cl.exe" #f)])
		       (unless f
			 (error 'use-standard-linker "cannot find MSVC's cl.exe"))
		       (current-extension-linker f)
		       (current-extension-linker-flags msvc-linker-flags)
		       (current-make-link-input-strings (lambda (s) (list s)))
		       (current-make-link-output-strings msvc-link-output-strings)
		       (current-standard-link-libraries (make-win-link-libraries #f #f)))]
	     [else (bad-name name)])]
	  [(macos)
	   (case name
	     [(cw) (current-extension-linker #f)
	      (current-extension-linker-flags null)
	      (current-make-link-input-strings (lambda (s) (list s)))
	      (current-make-link-output-strings (lambda (s) (list "-o" s)))
	      (current-standard-link-libraries (get-unix/macos-link-libraries))]
	     [else (bad-name name)])]))

      ;; ---- The link driver for each platform --------------------

      (define unix/windows-link
	(lambda (quiet? in out)
	  (let ([c (current-extension-linker)])
	    (if c
		(let* ([output-strings
			((current-make-link-output-strings) out)]
		       [libs (expand-for-link-variant (current-standard-link-libraries))]
		       [command 
			(append 
			 (list c)
			 (expand-for-link-variant (current-extension-linker-flags))
			 (apply append (map (lambda (s) ((current-make-link-input-strings) s))
					    in))
			 libs
			 output-strings)])
		  (unless quiet? 
		    (printf "link-extension: ~a~n" command))
		  (stdio-link (lambda (quiet?)
				(apply my-process* command))
			      quiet?)

		  ;; Stange Cygwin system for relocatable DLLs: we run dlltool twice and
		  ;;  ld three times total
		  (when (still-win-gcc?)
		    (let ([dlltool (find-executable-path "dlltool.exe" "dlltool.exe")]
			  ;; Find base-file name we already made up:
			  [basefile (let ([m (member "--base-file" output-strings)])
				      (and m (cadr m)))]
			  ;; Make new exp file name:
			  [expfile (make-win-gcc-temp "exp")])
		      (when (and dlltool basefile)
			(let* ([dll-command
				;; Generate DLL link information
				`("--dllname" ,out 
				  "--def" ,(build-path std-library-dir "gcc" "mzdyn.def")
				  "--base-file" ,basefile
				  "--output-exp" ,expfile)]
			       ;; Command to link with new .exp, re-create .base:
			       [command1
				(map (lambda (s)
				       (if (regexp-match "[.]exp$" s)
					   expfile
					   s))
				     command)]
			       ;; Command to link with new .exp file, no .base needed:
			       [command2
				(let loop ([l command1])
				  (cond
				   [(null? l) null]
				   [(string=? (car l) "--base-file")
				    (cddr l)]
				   [else (cons (car l) (loop (cdr l)))]))])
			  (unless quiet?
			    (printf "link-extension, dlltool phase: ~a~n" 
				    (cons dlltool dll-command)))
			  (stdio-link (lambda (quiet?) 
					(apply my-process* dlltool dll-command))
				      quiet?)
			  (unless quiet?
			    (printf "link-extension, re-link phase: ~a~n" 
				    command1))
			  (stdio-link (lambda (quiet?) 
					(apply my-process* command1))
				      quiet?)
			  (unless quiet?
			    (printf "link-extension, re-dlltool phase: ~a~n" 
				    (cons dlltool dll-command)))
			  (stdio-link (lambda (quiet?)
					(apply my-process* dlltool dll-command))
				      quiet?)
			  (unless quiet?
			    (printf "link-extension, last re-link phase: ~a~n" 
				    command2))
			  (stdio-link (lambda (quiet?)
					(apply my-process* command2))
				      quiet?)
			  (delete-file basefile)
			  (delete-file expfile))))))
		(error 'link-extension "can't find an installed linker")))))
      
      (define (macos-link quiet? input-files output-file)
	(macos-make 'link-extension "linking-project" "so" quiet? 
		    input-files output-file null))
      
      (define link-extension
	(case (system-type)
	  [(unix windows macosx) unix/windows-link]
	  [(macos) macos-link]))

      ;; ---- some helpers:
      
      (define-values (my-process* stdio-link)
	(let-values ([(p* do-stdio) (include (build-path "private" "stdio.ss"))])
	  (values
	   p*
	   (lambda (start-process quiet?)
	     (do-stdio start-process quiet? (lambda (s) (error 'link-extension "~a" s)))))))
      
      (define (make-win-gcc-temp suffix)
	(let ([d (find-system-path 'temp-dir)])
	  (let loop ([n 1])
	    (let ([f (build-path d (format "tmp~a.~a" n suffix))])
	      (if (file-exists? f)
		  (loop (add1 n))
		  f)))))

      (include (build-path "private" "macinc.ss")))))