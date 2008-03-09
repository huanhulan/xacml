(module danish-string-constants "string-constant-lang.ss"
 ;;; when translating this constant, substitue name of actual langauge for `English'
 (is-this-your-native-language "Foretr�kker du dansk?")

 (are-you-sure-you-want-to-switch-languages
  "Dette �ndrer sproget i den grafiske brugerflade. Er du sikker?")

 (interact-with-drscheme-in-language "Arbejd med DrScheme p� Dansk")

 ;; these two should probably be the same in all languages except English.
 ;; they are the button labels (under macos and windows, respectively)
 ;; that go the with the string above.
 (accept-and-quit "Accepter og afslut")
 (accept-and-exit "Accepter og afslut")

 ;;; general purpose (DrScheme is hereby a word in every language, by decree of Robby :)
 (plt "PLT")
 (drscheme "DrScheme")
 (ok "Ok")
 (cancel "Fortryd")
 (untitled "Uden navn")
 (untitled-n "Uden navn ~a")
 (warning "Advarsel")
 (error "Fejl")
 (close "Luk") ;; as in, close an open window
 (stop "Stop")
 (&stop "&Stop") ;; for use in button and menu item labels, with short cut.
 (are-you-sure-delete? "Er du sikker p�, du vil slette ~a?") ;; ~a is a filename or directory name
 (ignore "Ignorer")
 (revert "Gendan")

 ;; label for a generic check box, often supported on dialogs
 ;; that ask a binary choice of the user. If checked, the
 ;; dialog isn't going to be shown again.
 (dont-ask-again "Sp�rg ikke igen (brugt altid nuv�rende valg)")

 ;;; important urls
 (web-materials "Relaterede websites") ;; menu item title
 (tool-web-sites "Tool Web Sites")   ;; menu item title
 (drscheme-homepage "DrScheme")
 (plt-homepage "PLT")
 (how-to-use-scheme "How to Use Scheme") ;; title of a book.
 (teachscheme!-homepage "TeachScheme!") ;; probably this should be a `word' in all languages

 ;;; bug report form
 (cancel-bug-report? "Fortryd afsendelse af fejlrapport?")
 (are-you-sure-cancel-bug-report?
  "Er du sikker, du ikke vil afsende denne fejlrapport?")
 (bug-report-form "Fejlrapportering")
 (bug-report-field-name "Navn")
 (bug-report-field-email "E-mail")
 (bug-report-field-summary "Resum�")
 (bug-report-field-severity "Alvorlighedsgrad")
 (bug-report-field-class "Klasse")
 (bug-report-field-priority "Prioritet")
 (bug-report-field-description "Beskrivelse")
 (bug-report-field-reproduce1 "Skridt for at")
 (bug-report-field-reproduce2 "reproducere fejlen")
 (bug-report-field-environment "Omgivelse")
 (bug-report-field-tools "V�rkt�jer")
 (bug-report-field-docs-installed "Installeret dokumentation")
 (bug-report-field-language "Sprog")
 (bug-report-field-teachpacks "Undervisningspakker")
 (bug-report-field-collections "Samlinger (Collections)")
 (bug-report-field-human-language "Modersm�l")
 (bug-report-field-version "Version")
 (bug-report-synthesized-information "Indsamlet information")  ;; dialog title
 (bug-report-show-synthesized-info "Vis indsamlet information")
 (bug-report-submit "Send")
 (sending-bug-report "Afsender fejlrapport")
 (error-sending-bug-report "Fejl under afsendelse af fejlrapport")
 (error-sending-bug-report-expln "Der opstod en fejl ved afsendelse af fejlrapporten. Hvis din internetforbindelse ellers er velfungerende, bes�g venligst:\n\n    http://bugs.plt-scheme.org/\n\nog send fejlrapporten ved hj�lp af vores online fejlrapporteringsside. Vi er kede af besv�ret.\n\nFejlmeddelelsen er:\n~a")
 (bug-report-sent "Fejlrapporten er afsendt")
 (bug-report-sent-detail "Tak for fejlrapporten. Du b�r modtage en bekr�ftigelse via e-email indenfor den n�ste halve time. Hvis du ikke f�r en bekr�ftigelse, s� send en e-mail til scheme@plt-scheme.org.")
 (illegal-bug-report "Ugyldig fejlrapport")
 (pls-fill-in-field "Udfyld venligst feltet \"~a\" ")
 (malformed-email-address "Ugyldig e-mail-adresse")
 (pls-fill-in-either-description-or-reproduce "Udfyld venligst enten beskrivelsesfeltet eller feltet til reproduktion af fejlen.")

 ;;; check syntax
 (check-syntax "Syntakstjek")
 (cs-italic "Kursiv")
 (cs-bold "Fed")
 (cs-underline "Understreget")
 (cs-change-color "Skift farve")
 (cs-tack/untack-arrow "Pile til/fra")
 (cs-jump-to-next-bound-occurrence "Hop til n�ste bundne forekomst")
 (cs-jump-to-binding "Hop til den bindende forekomst")
 (cs-jump-to-definition "Hop til definition")
; (cs-jump "Hop")
 (cs-error-message "Fejlmeddelelse")
 (cs-open-file "�bn ~a")
 (cs-rename-var "Omd�b ~a")
 (cs-rename-id "Omd�b navn")
 (cs-rename-var-to "Omd�b ~a til:")
 (cs-name-duplication-error "Det nye navn, du har valgt, ~s, er i konflikt med et allerede eksisterende navn i dette virkefelt.")
 (cs-status-init "Syntakstjek: Initialiserer omgivelser for brugerkode")
 (cs-status-coloring-program "Syntakstjek: farver udtryk")
 (cs-status-eval-compile-time "Syntakstjek: evaluering p� overs�ttelsestid")
 (cs-status-expanding-expression "Syntakstjek: Udvider (expanding) udtryk")
 ;(cs-status-teachpacks "Syntakstjek: installerer undervisningspakke")
 (cs-mouse-over-variable-import "variabel ~s importeret fra ~s")
 (cs-mouse-over-syntax-import "syntaks ~s importeret fra ~s")

 (cs-lexical-variable "leksikalsk varaibel")
 (cs-lexical-syntax "leksikalsl syntaks")
 (cs-imported-variable "importeret variabel")
 (cs-imported-syntax "importeret syntaks")

 ;;; info bar at botttom of drscheme frame
 (collect-button-label "GC")
 (read-only "Skrivebeskyttet")
 (read/write "L�s/Skriv")
 (auto-extend-selection "Auto-udvid")
 (overwrite "Overskriv")
 (running "k�rer")
 (not-running "k�rer ikke")

 ;;; misc
 (welcome-to-something "Velkommen til ~a")

 ; this appears in the drscheme about box.
 (welcome-to-drscheme-version/language "Velkommen til DrScheme, version ~a, ~a")

 ; these appear on subsequent lines in the `Help|Welcome to DrScheme' dialog.
 (welcome-to-drscheme "Velkommen til DrScheme")
 (version/language "version ~a, ~a")

 (goto-line "G� til linje")
 (goto-line-invalid-number
  "~a er ikke et gyldigt linjenummer. Det skal v�re et heltal mellem 1 og ~a")
 (goto-position "G� til position")
 (no-full-name-since-not-saved
  "Filen har ikke et fuldt navn, for den er endnu ikke gemt.")
 (cannot-open-because-dne "Kan ikke �bne ~a, for den findes ikke")
 (interactions-out-of-sync
  "ADVARSEL: Interaktionsvinduet er ude af trit med definitionsvinduet. Klik p� K�r.")
 (file-is-not-saved "Filen \"~a\" er endnu ikke gemt.")
 (save "Gem")
 (please-choose-either "V�lg venligst enten \"~a\" eller \"~a\"")
 (close-anyway "Luk alligevel")
 (clear-anyway "Rens Anyway")

 ;; menu item title
 (log-definitions-and-interactions "Log definitioner og interaktioner...")
 (stop-logging "Stop logf�ring")
 (please-choose-a-log-directory "V�lg en mappe til loggen")
 (logging-to "Log til: ")
 (erase-log-directory-contents "Slet indholdet af log-mappen: ~a?")
 (error-erasing-log-directory "Fejl under sletning ad log-mappens indhold.\n\n~a\n")

 ;; modes
 (mode-submenu-label "Tilstande")
 (scheme-mode "Scheme-tilstand")
 (text-mode "Tekst-tilstand")

 (scheme-mode-color-symbol "Symbol")
 (scheme-mode-color-keyword "N�gleord")
 (scheme-mode-color-comment "Kommentar")
 (scheme-mode-color-string "Strenf")
 (scheme-mode-color-constant "Konstant")
 (scheme-mode-color-parenthesis "Parentes")
 (scheme-mode-color-error "Fejl")
 (scheme-mode-color-other "Andet")

 (url "URL")
 (url: "URL:")
 (open-url... "�bn URL...")
 (open-url "�bn URL")
 (browse... "Gennemse...")
 (bad-url "Ugyldig URL")
 (bad-url:this "Ugyldig URL: ~a")

 ;; Help Desk
 (help "Hj�lp")
 (help-desk "Hj�lpebord")
 (plt:hd:search-results "S�geresultater")
 (plt:hd:search "S�g")
 (plt:hd:search-for "S�g efter")
 (plt:hd:lucky "Heldig!")
 (plt:hd:feeling-lucky "Jeg f�ler mig heldig")
 (plt:hd:stop "Stop")   
 (plt:hd:options "Indstillinger") 
 (plt:hd:configure "Konfigurer")
 (plt:hd:home "Hj�lpebordets start") 
 (plt:hd:show-manuals "Vis manualer") 
 (plt:hd:send-bug-report "Send fejlrapport")
 (plt:hd:query-bug-reports "S�g efter fejlrapporter")
 ; next 3 are popup menu choices in help desk search frame
 (plt:hd:search-for-keyword "N�gleord")
 (plt:hd:search-for-keyword-or-index "N�gleord eller indekseret opslag")
 (plt:hd:search-for-keyword-or-index-or-text "N�gleord, indekseret opslag eller tekst")
 (plt:hd:exact-match "pr�cis match")
 (plt:hd:containing-match "indeholdende match")
 (plt:hd:regexp-match "regul�rt udtryk")
 (plt:hd:find-docs-for "Find dokumentation om:")
 (plt:hd:nothing-found-for-search-key "Intet fundet om \"~a\".")
 (plt:hd:searching "S�ger...")
 (plt:hd:search-stopped "[S�gning stoppet.]")
 (plt:hd:search-stopped-too-many-matches "[S�gning afbrudt: for mange resultater")
 (plt:hd:nothing-found-for "Intet fundet om ~a")
 (plt:hd:error-finding-docs "Kunne ikke finde dokumentation.\n\n~a")
 (plt:hd:and "og")
 (plt:hd:refresh "opdater")
 (plt:hd:refresh-all-manuals "opdater alle manualer")
 (plt:hd:manual-installed-date "(~a installeret)")
 ; Help Desk configuration
 (plt:hd:configuration "PLT Hj�lpebordskonfiguration")
 (plt:hd:no-frames "Ingen rammer (frames)")
 (plt:hd:use-frames "Brug rammer (frames)")
 (plt:hd:use-html-frames "Brug HTML-rammer")
 (plt:hd:search-pane-options "Indstillinger for s�gepanel")
 (plt:hd:height "H�jde")
 (plt:hd:bg-color "Baggrundsfarve")
 (plt:hd:pixels "pixels")
 (plt:hd:text-color "Tekstfarve")
 (plt:hd:link-color "Linkfarve")
 (plt:hd:text-sample "S�gepanelet har denne farve")
 (plt:hd:link-sample "Links i s�gepanelet har denne farve")
 (plt:hd:save-changes "Gem �ndringer")
 (plt:hd:reset "Reset")
 (plt:hd:defaults "Standardindstillinger")
 (plt:hd:javascript-note
    "De valg du g�r vil blive vist her, hvis du har JavaScript sat til, og en ny moderne standard-f�lgende browser.")
 ;; refreshing manuals
 (plt:hd:refresh-downloading "Henter ~a")
 (plt:hd:refresh-installing "Installerer ~a")
 (plt:hd:refresh-clearing-indicies "Renser forgemte indekser")
 (plt:hd:refresh-progress "PLT-manualhentningsfremskridt")
 (plt:hd:refresh-done "F�rdig med at opdatere CVS-manualer")
 (plt:hd:refresh-installation-log "Installationslog")
 (plt:hd:refresh-stopped "Opdatering af PLT-manualer stoppet")
 (plt:hd:refreshing-manuals "Genhenter manualer")
 (plt:hd:refresh-downloading... "Henter ~a...")
 (plt:hd:refresh-deleting... "Sletter gammel version af ~a...")
 (plt:hd:refresh-installing... "Installerer ny version af ~a...")
 (plt:hd:refreshing-manuals-finished "F�rdig.")
 (plt:hd:about-help-desk "Om hj�lpebord")
 (plt:hd:help-desk-about-string
  "Hj�lpebord er en fuldst�ndig kilde af information om PLT-software, inklusive DrScheme, MzScheme og MrEd.\n\nVersion ~a\nCopyright (c) 1995-2003 PLT")
 (plt:hd:help-on-help "Hj�lp om hj�lp")
 (plt:hd:help-on-help-details "For hj�lp om Hj�lpebord, f�lg linket `How to use Help Desk'-linket p� hj�lpebordets startside.")
  (reload "Opdater") ;; refresh the page in a web browser
  (plt:hd:ask-about-separate-browser
   "Du har valgt et link til indhold p� internettet. Vil du se det i Hj�lpebordsbrwoseren eller i et separat browserprogram?")
  (plt:hd:homebrew-browser "Hj�lpebordsbrowser") ;; choice for the above string (in a button)
  (plt:hd:separate-browser "Separat browser") ;; other choice for the above string (also in a button)
  (plt:hd:external-link-in-help "Eksterne URL'er i hj�lp")
  (plt:hd:use-homebrew-browser "Brug hj�lpebordsbrowseren til eksterne URL'er")
  (plt:hd:new-help-desk "Nyt hj�lpebord")
  (plt:hd:teaching-manuals "Elev-dokumentation")
  (plt:hd:professional-manuals "Professionel dokumentation")
  (plt:hd:all-manuals "Al dokumentation")

  ;; in the Help Desk language dialog, title on the right.
  (plt:hd:manual-search-ordering "S�georden")

 ; help desk htty proxy
 (http-proxy "HTTP-proxy")
 (proxy-direct-connection "Direkte forbindelse")
 (proxy-use-proxy "Benyt proxyen:")
 (proxy-host "Host")
 (proxy-port "Port")
 (proxy-bad-host "Ugyldig proxyv�rt")

 ;; browser
 (rewind-in-browser-history "Tilbage")
 (forward-in-browser-history "Fremad")
 (home "Hjem")
 (browser "Browser")
 (external-browser-choice-title "Ekstern browser") ; title for radio-button set
 (browser-command-line-label "Kommandolinje:") ; label for radio button that is followed by text boxes
 (choose-browser "V�lg en browser")
 (no-browser "Sp�rg senere") ; English changed from "None" to "Ask Later"
 (use-internal-browser-for-help "L�s hj�lpen i den interne PLT webbrowser") ; radio-button label
 (use-external-browser-for-help "L�s hj�lpen med en ekstern webbrowser") ; radio-button label
 (browser-cmdline-expl-line-1 "(Kommandolinjen konstrueret ved at s�tte den forudg�ende tekst, URL'en,") ; explanatory text for dialog, line 1
 (browser-cmdline-expl-line-2 "og den efterf�lgende tekst sammen uden brug af mellemrum mellem dem.)") ; ... line 2. (Anyone need more lines?)
 (cannot-display-url "Kan ikke vise URL ~s: ~a")
 (install? "Install�r?")  ;; if a .plt file is found (title of dialog)
 (you-have-selected-an-installable-package "Du har valgt en pakke, som kan installeres.")
 (do-you-want-to-install-it? "Vil du installere den?")
 (paren-file-size "(Filen fylder ~a bytes)")
 (download-and-install "Download og install�r") ;; button label
 (download "Download") ;; button label
 (save-downloaded-file/size "Gem den downloadede fil (~a bytes) som ") ;; label for get-file dialog
 (save-downloaded-file "Gem den downloadede file som")  ;; label for get-file dialog
 (downloading "Downloader") ;; dialog title
 (downloading-file... "Downloader fil...")
 (package-was-installed "Pakken blev installeret.")
 (download-was-saved "Den downloadede fil blev gemt.")
 (getting-page "Henter side") ;; dialog title

 (install-plt-file-menu-item... "Installer .plt-fil...")
 (install-plt-file-dialog-title "Installer .plt-fil")
 (install-plt-web-tab "Web")
 (install-plt-file-tab "Fil")
 (install-plt-filename "Filnavn:")
 (install-plt-url "URL:")

 ;; install plt file when opened in drscheme strings
 (install-plt-file "Installer ~a eller �bn for at redigere?")
 (install-plt-file/yes "Installer")
 (install-plt-file/no "Rediger")

 (plt-installer-progress-window-title "Installeringsfremgang")
 (plt-installer-abort-installation "Afbryd installation") ;; button label
 (plt-installer-aborted "Afbrudt.") ;; msg that appears in the installation window when installation is aborted


 ;;; about box
 (about-drscheme-frame-title "Om DrScheme")
 (take-a-tour "Tag en rundvisning!")
 (release-notes "Udgivelsesbem�rkninger")
 (parenthetical-last-version "(tidligere version ~a)")
 (parenthetical-last-language "(tidligere language ~a)")
 (parenthetical-last-version/language "(tidligere version ~a, modersm�l ~a)")


 ;;; save file in particular format prompting.
 (save-as-plain-text "Gem denne fil som tekt?")
 (save-in-drs-format "Gem denne fil i det DrScheme-specifikke ikke-tekst format?")
 (yes "Ja")
 (no "Nej")

 ;;; preferences
 (preferences "Indstillinger")
 (saving-preferences "Gemmer indstillinger")
 (error-unmarshalling "Error unmarshalling ~a preference")
 (error-saving-preferences "Fejl under lagring af indstillinger: ~a")
 (error-reading-preferences "Fejl ved indl�sning af indstillinger")
 (expected-list-of-length2 "forventede en liste af l�ngde 2")
 (scheme-prefs-panel-label "Scheme")
 (warnings-prefs-panel-label "Advarsler")
 (editor-prefs-panel-label "Redigering")
 (general-prefs-panel-label "Generelt")
 (highlight-parens "Farv mellem samh�rende parenteser")
 (fixup-parens "Korriger parenteser, dvs. lav automatisk ) om til ] ")
 (flash-paren-match "Blink ved samh�rende parenteser")
 (auto-save-files "Auto-save filer")
 (backup-files "Backup filer")
 (map-delete-to-backspace "Bind delete til backspace")
 (verify-exit "Sp�rg ved nedlukning")
 (ask-before-changing-format "Sp�rg f�r �ndring af lagringsformat")
 (wrap-words-in-editor-buffers "Ombryd ord i redigeringsbufferne")
 (show-status-line "Vis statuslinjen")
 (count-columns-from-one "T�l s�jlenumger fra en.")
 (display-line-numbers "Vis linjenumre i bufferen; ikke tegn-offsets")
 (enable-keybindings-in-menus "Sl� tastaturgenveje i menuer til")
 (automatically-to-ps "Udskriv automatisk til postscriptfil")
 (use-mdi "Brug MDI vinduer") ;;; ms windows only -- use that window in a window thingy
 (separate-dialog-for-searching "Brug separat dialog til s�gning")
 (reuse-existing-frames "Genbrug gamle vinduer, n�r nye filer �bnes")
 (default-fonts "Standardskrifttyper")
 (paren-match-color "Parentesfremh�vningsfarve") ; in prefs dialog
 (choose-color "V�lg farve") ; in prefs dialog
 (online-coloring-active "Interaktiv syntaksfarvel�gning")
 (open-files-in-tabs "�bn filer i separate faneblade (ikke separate vinduer)")

 ; title of the color choosing dialog
 (choose-paren-highlight-color "V�lg farve til parentesfremh�vning")

 ; should have entire alphabet
 (font-example-string "H�j bly gom vandt fr�k sexquiz p� wc.")

 (change-font-button-label "Skift")
 (fonts "Fonte")

 ; filled with type of font, eg modern, swiss, etc.
 (choose-a-new-font "V�lg en ny \"~a\" font")

 (font-size-slider-label "St�rrelse")
 (restart-to-see-font-changes "Genstart for at se font�ndringer")

 (font-prefs-panel-title "Font")
 (font-name "Fontnavn")
 (font-size "Fontst�rrelse")
 (set-font "Anvend font...")
 (font-smoothing-label  "Skriftypeudglatning")
 (font-smoothing-none "Ingen")
 (font-smoothing-some "Nogen")
 (font-smoothing-all "Fuld")
 (font-smoothing-default "Brug systemindstillinger")
 (select-font-name "V�lg skrifttypenavn")
 (example-text "Eksempeltekst:")
 (only-warn-once "Advar kun �n gang, n�r k�rsler og interaktioner er ude af trit")

 ; warning message when lockfile is around
 (waiting-for-pref-lock "Venter p� indstillingernes l�sefil...")
 (pref-lock-not-gone
  "Indstillingernes l�sefil:\n\n   ~a\n\nforhindrer indstillingerne i at blive gemt. S�rg for, at du ikke k�rer PLT-programmer og slet denne fil.")
 (still-locked-exit-anyway? "Indstillingerne blev ikke gemt rigtigt. Afslut alligevel?")

 ;;; indenting preferences panel
 (indenting-prefs-panel-label "Indrykning")

 ; filled with define, lambda, or begin
 (enter-new-keyword "Indtast et nyt ~a-lignende n�gleord:")
 (x-keyword "~a n�gleord")
 (x-like-keywords "~a-lignende n�gleord")

 (expected-a-symbol "forventede et symbol, fandt: ~a")
 (already-used-keyword "\"~a\" er allerede et n�gleord med speciel indrykning")
 (add-keyword "Tilf�j")
 (remove-keyword "Fjern")

 ;;; find/replace
 (find-and-replace "S�g og erstat")
 (find "S�g")
 (replace "Erstat")
 (dock "Minimer")
 (undock "Gendan")
 (use-separate-dialog-for-searching "Brug separat dialog til s�gning")
 (replace&find-again "Erstat og S�g igen") ;;; need double & to get a single &
 (replace-to-end "Erstat til slutning")
 (forward "Frem")
 (backward "Tilbage")
 (hide "Skjul")

 ;;; multi-file-search
 (mfs-multi-file-search-menu-item "S�g i filer...")
 (mfs-string-match/graphics "Streng match (klarer filer med grafik)")
 (mfs-regexp-match/no-graphics "Regul�rt udtryk (kun r� tekstfiler)")
 (mfs-searching... "S�ger...")
 (mfs-configure-search "S�geindstillinger") ;; dialog title
 (mfs-files-section "Filer")   ;; section in config dialog
 (mfs-search-section "S�g") ;; section in config dialog
 (mfs-dir "Mappe")
 (mfs-recur-over-subdirectories "Rekursivt i undermapper")
 (mfs-regexp-filename-filter "Regexp filnavnsfilter")
 (mfs-search-string "S�gestreng")
 (mfs-drscheme-multi-file-search "DrScheme - S�gning i flere filer") ;; results window and error message title
 (mfs-not-a-dir "\"~a\" er ikke en mappe")
 (mfs-open-file "�bn fil")
 (mfs-stop-search "Stop s�gning")
 (mfs-case-sensitive-label "Forskel p� store og sm� bogstaver")
 (mfs-no-matches-found "Intet passende fundet.")
 (mfs-search-interrupted "S�gning afbrudt.")

 ;;; reverting a file
 (error-reverting "DrScheme - Fejl ved gendanning")
 (could-not-read "kunne ikke l�se \"~a\"")
 (are-you-sure-revert
  "Er du sikker p�, at du vil gendanne denne fil? En gendannen kan ikke fortrydes.")
 (are-you-sure-revert-title "Gendan?")

 ;;; saving a file
 ; ~a is filled with the filename
 (error-saving "Fejl under lagring") ;; title of error message dialog
 (error-saving-file/name "Der var en fejl ved lagring af ~a.")
 (error-loading "Indl�sefejl")
 (error-loading-file/name "Fejl ved l�sning af ~a.")
 (unknown-filename "<< ukendt >>")

 ;;; finder dialog
 (must-specify-a-filename "Du skal angive et filnavn")
 (file-does-not-exist "Filen \"~a\" findes ikke.")
 (ask-because-file-exists "Filen \"~a\" findes allerede. Erstat den?")
 (dne-or-cycle "Filen \"~a\" indeholder en ikke-eksisterende mappe eller en cykel.")
 (get-file "Hent fil")
 (put-file "Gem fil")
 (full-pathname "Fuldt navn med sti")
 (show-dot-files "Vis filer og mapper, som begynder med punktum.")
 (up-directory-button-label "Op")
 (add-button-label "Tilf�j") ;;; for multi-file selection
 (add-all-button-label "Tilf�j alle") ;;; for multi-file selection
 (remove-button-label "Fjern") ;;; for multi-file selection
 (file-wrong-form "Det filnavn har ikke den rigtige form.")
 (select-files "V�lg filer")
 (select-file "V�lg en fil")
 (dir-dne "Den mappe findes ikke.")
 (file-dne "Den fil findes ikke.")
 (empty-filename "Filnavnet skal indeholde et tegn.")
 (that-is-dir-name "Det er et mappenavn.")

 ;;; raw menu names -- these must match the
 ;;; versions below, once the &s have been stripped.
 ;;; if they don't, DrScheme's menus will appear
 ;;; in the wrong order.
 (file-menu "Filer")
 (edit-menu "Rediger")
 (help-menu "Hj�lp")
 (windows-menu "Vinduer")

 ;;; menus
 ;;; - in menu labels, the & indicates a alt-key based shortcut.
 ;;; - sometimes, things are stuck in the middle of
 ;;; menu item labels. For instance, in the case of
 ;;; the "Save As" menu, you might see: "Save Definitions As".
 ;;; be careful of spacing, follow the English, if possible.
 ;;; - the ellipses in the `after' strings indicates that
 ;;; more information is required from the user before completing
 ;;; the command.

 (file-menu-label-windows "&Filer")
 (file-menu-label-other "F&il")

 (new-info  "Opret en ny fil")
 (new-menu-item "&Ny")
 (new-...-menu-item "&Ny...")

 (open-info "�bn en fil fra disk")
 (open-menu-item "&�bn...")
 (open-here-menu-item "&�bn her...")

 (open-recent-info "En liste af filer brugt for nylig")
 (open-recent-menu-item "�bn gammel")

 (revert-info "Gendan diskkopien af denne fil")
 (revert-menu-item "Gendan")

 (save-info "Gem filen p� disk")
 (save-menu-item "&Gem")

 (save-as-info "Gemmer filen med et nyt filnavn")
 (save-as-menu-item "Gem &Som...")

 (print-info "Udskriv filen p� printer")
 (print-menu-item "&Print...")

 (close-info "Luk denne fil")
 (close-menu-item "&Luk")

 (quit-info "Luk alle vinduer")
 (quit-menu-item-windows "E&xit")  ; TODO
 (quit-menu-item-others "&Quit")

 (edit-menu-label "&Rediger")

 (undo-info "Fortryd sidste handling")
 (undo-menu-item "&Fortryd")

 (redo-info "Fortryd det seneste fortryd")
 (redo-menu-item "&Omg�r")

 (cut-info "Flyt det sidst valgte til klippebordet til senere inds�ttelse")
 (cut-menu-item "K&lip")

 (copy-info "Kopier det sidst valgte til klippebordet til senere inds�ttelse")
 (copy-menu-item "&Kopier")

 (paste-info "Erstat det valgte med det senest kopierede eller klippede")
 (paste-menu-item "&Inds�t")

 (clear-info "Slet de valgte elementer uden at p�virke klippebordet eller inds�tning")
 (clear-menu-item-others "Rens")
 (clear-menu-item-windows "&Rens")

 (select-all-info "Marker alt")
 (select-all-menu-item "Marker &alt")

 (find-info "S�g efter streng")
 (find-menu-item "S�g...")

 (find-again-info "S�g efter samme streng som f�r")
 (find-again-menu-item "S�g igen")

 (replace-and-find-again-info "Erstat den nuv�rende tekst og gentag s�gningen")
 (replace-and-find-again-menu-item "Erstat og s�g igen")

 (preferences-info "Rediger dine indstillinger")
 (preferences-menu-item "Indstillinger...")

 (keybindings-info "Vis de g�ldende, aktive tastebindinger")
 (keybindings-menu-item "Tastebindinger")
 (keybindings-frame-title "Tastebindinger")
 (keybindings-sort-by-name "Sort�r efter Navn")
 (keybindings-sort-by-key "Sort�r efter Tast")

 (insert-text-box-item "Inds�t tekstkasse")
 (insert-pb-box-item   "Inds�t pasteboard-kasse")
 (insert-image-item    "Inds�t billede...")
 (insert-comment-box-menu-item-label "Inds�t kommentarkasse")
 (insert-lambda "Inds�t &Lambda")
 (insert-delta "Inds�t &Delta (define)")

 (wrap-text-item       "Ombryd tekst")

 (windows-menu-label "&Vinduer")
 (bring-frame-to-front "Skift til andet vindue")       ;;; title of dialog
 (bring-frame-to-front... "Skift til andet vindue...") ;;; corresponding title of menu item
 (next-window "N�ste vindue")
 (previous-window "Forrige vindue")
 (most-recent-window "Sidst bes�gte vindue")

 (view-menu-label "&Vis")
 (show-overview "Vis programkontur")
 (hide-overview "Skjul programkontur")
 (show-module-browser "Vis moduloversigt")
 (hide-module-browser "Skjul moduloversigt")

 (help-menu-label "&Hj�lp")
 (about-info "Akkrediteringer og detaljer om dette program")
 (about-menu-item "Om...")
 (help-menu-check-for-updates "Unders�g, om der er opdateringer...")

 ;; open here's new menu item
 (create-new-window-or-clear-current
  "Vil du have et nyt vindue, eller rense det gamle?")
 (clear-current "Rens nuv�rende")
 (new-window "Nyt vindue")

 ;;; exiting and quitting are you sure dialog
 ;;; (exit is used on windows, quit on macos. go figure)
 (exit "Afslut")
 (quit "Afslut")
 ;;; in are-you-sure-format, either exit or quit is filled in (from above)
 ;;; based on the platform drscheme is running on.
 (are-you-sure-exit "Er du sikker, du vil afslutte?")
 (are-you-sure-quit "Er du sikker, du vil afslutte?")

 ;;; autosaving
 (error-autosaving "Fejl under autosaving \"~a\".")
 (autosaving-turned-off "Autosaving er sl�et fra \nindtil filen filen gemmes.")
 (recover-autosave-files-frame-title "Gendan backupfiler")
 (autosave-details "Detaljer")
 (autosave-recover "Gendan")
 (autosave-unknown-filename "<<ukendt>>")

  ;; these are labels in a dialog that drscheme displays
  ;; if you have leftover autosave files. to see the dialog,
  ;; start up drscheme and modify (but don't save) a file
  ;; (also, do this with an unsaved file). Wait for the autosave
  ;; files to appear (typically 5 minutes). Kill DrScheme
  ;; and restart it. You'll see the dialog
  (autosave-autosave-label: "Autosave-fil:")
  (autosave-original-label: "Original fil:")
  (autosave-autosave-label "Autosave-fil")
  (autosave-original-label "Original fil")
  (autosave-compare-files "Sammenlign autosavede filer")

  (autosave-show-autosave "Autosave-fil") ;; title of a window showing the autosave file

  (autosave-explanation "DrScheme fandt autosavede filer, som m�ske indeholde ugemt arbejde.")

  (autosave-recovered! "Gendannet!") ;; status of an autosave file
  (autosave-deleted "Slettet")       ;; status of an autosave file

  (autosave-error-deleting "Fejl under sletning ~a\n\n~a") ;; first is a filename, second is an error message from mz.
  (autosave-delete-button "Slet")
  (autosave-delete-title "Slet")  ;; title of a dialog asking for deletion confirmation
  (autosave-done "F�rdig")
  
  ;; appears in the file dialog
  (autosave-restore-to-where? "V�lg et sted til at gemme autosave-filen.")


 ;;; file modified warning
 (file-has-been-modified
  "Der er rettet i filen, siden den sidst blev gemt. Overskriv �ndringerne?")
 (overwrite-file-button-label "Overskriv")

 (definitions-modified
  "Definitionsteksten er blevet �ndret i filsystemet; gem venligst eller brug 'vend tilbage' for at bruge den gamle version")
 (drscheme-internal-error "Intern fejl i DrScheme")

 ;;; tools
 (invalid-tool-spec "V�rkst�jsspecifikationen i collection ~a's info.ss filen er ugyldig. Forventede enten en streng eller en ikke-tom liste af strenge, fik: ~e")
 (error-loading-tool-title "DrScheme - Fejl under hentning af v�rkt�j ~s; ~s")
 (error-invoking-tool-title "Fejl ved k�rsel af v�rkt�j ~s;~s")
 (tool-tool-names-same-length "forventede `tool-names' og `tools' var to lister af samme l�ngde i info.ss for ~s, fik ~e og ~e")
 (tool-tool-icons-same-length  "forventede `tool-icons' og `tools' var to lister af samme l�ngde i info.ss  for ~s, fik ~e and ~e")
 (tool-tool-urls-same-length
  "forventede `tool-urls' og `tools' var lister af samme l�ngde  i info.ss-filen for ~s, fik ~e og ~e")
 (error-getting-info-tool  "fejl ved hentning af info.ss file for ~s")
 (tool-error-phase1 "Fejl i fase 1 for v�rkt�jet ~s; ~s")
 (tool-error-phase2 "Fejl i fase 2 for v�rkt�jet ~s; ~s")


 ;;; define popup menu
 (end-of-buffer-define "<< slutning af buffer >>")
 (sort-by-name "Sorter efter navn")
 (sort-by-position "Sorter efter r�kkef�lge i programteksten")
 (no-definitions-found "<< ingen definitioner fundet >>")
 (jump-to-defn "Hop til definitionen af ~a")

 (recent-items-sort-by-age "Sorter efter Alder")
 (recent-items-sort-by-name "Sorter efter Navn")


 ;;; view menu
 (hide-definitions-menu-item-label "Skjul &Definitioner")
 (show-definitions-menu-item-label "Vis &Definitioner")
 (definitions-menu-item-help-string "Vis/Skjul definitionsvinduet")
 (show-interactions-menu-item-label "Vis &Interaktioner")
 (hide-interactions-menu-item-label "Skjul &Interaktioner")
 (interactions-menu-item-help-string "Vis/Skjul interaktionsvinduet")
 (show-toolbar "Vis &v�rkt�jslinjen")
 (hide-toolbar "Skjul &v�rkt�jslinjen")

 ;;; file menu
 (save-definitions-as "Gem definitioner som...")
 (save-definitions "Gem definitioner")
 (print-definitions "Udskriv definitioner...")
 (about-drscheme "Om DrScheme")
 (save-other "Gem andet")
 (save-definitions-as-text "Gem definitioner som tekst...")
 (save-interactions "Gem interaktioner")
 (save-interactions-as "Gem interaktioner som...")
 (save-interactions-as-text "Gem interaktioner som tekst...")
 (print-interactions "Udskriv interaktioner...")
 (new-tab "Nyt faneblad")
 (close-tab "Luk faneblad")

 ;;; edit-menu
 (split-menu-item-label "&Split")
 (collapse-menu-item-label "K&ollaps")

 ;;; language menu
 (language-menu-name "&Sprog")

 ;;; scheme-menu
 (scheme-menu-name "S&cheme")
 (execute-menu-item-label "K�r")
 (execute-menu-item-help-string "Genstart programmet i definitionsvinduet")
 (break-menu-item-label "Afbryd")
 (break-menu-item-help-string "Afbryd den nuv�rende evaluering")
 (kill-menu-item-label "Sl� ihjel")
 (kill-menu-item-help-string "Sl� den nuv�rende evaluering ihjel")
 (clear-error-highlight-menu-item-label "Fjern fejlfarvel�gningen")
 (clear-error-highlight-item-help-string "Fjerne den pinke farvel�gning af fejlene")
 (reindent-menu-item-label "&Indryk igen")
 (reindent-all-menu-item-label "Indryk &alt igen")
 (semicolon-comment-out-menu-item-label "&Udkommenter med semikolonner")
 (box-comment-out-menu-item-label "&Udkommenter med en kasse")
 (uncomment-menu-item-label "&Afkommenter")

 (convert-to-semicolon-comment "Konverter til en semikolon-kommentar")


 ;;; executables
 (create-executable-menu-item-label "Lav bin�r k�rselfil...")
 (create-executable-title "Lav bin�r k�rselsfil")
 (must-save-before-executable "Du skal gemme dit program, f�r du laver en bin�r fil")
 (save-an-executable "Gem en selvst�ndig k�rselsfil (binary)")
 (save-a-mred-launcher "Gem en MrEd-starter")
 (save-a-mzscheme-launcher "Gem en MzScheme-starter")
 (save-a-mred-stand-alone-executable "Gem en selvst�ndig MrEd-k�rselsfil")
 (save-a-mzscheme-stand-alone-executable "Gen en selvst�ndig MzScheme k�rselsfil")
 (definitions-not-saved "Definitionsvinduet har ikke v�ret gemt. Den bin�re k�rselsfil vil bruge den senest gemte version af definitionsvinduet. Forts�t?")
 (inline-saved-program-in-executable?  "Indlejr det gemte program i en bin�r k�rselsfil? Hvis ja, s� kan du kopiere k�rselsfilen til en anden ~a computer, men k�rselsfilen vil v�re ret stor. Hvis ikke, kan du ikke kopiere det gemte program til en anden computer, men den vil v�re meget mindre. I tilgift, hvis ikke, vil k�rselsfilen bruge den seneste version af programmet.")
 (use-mred-binary?
  "Brug mred til denne k�rselsfil?\n\nHvis ja, s� kan dit program bruge biblioteket (lib \"mred.ss\" \"mred\"). Hvis nej, s� vil DrScheme bruge mzscheme til k�rselsfilen and du kan ikke bruge mred-biblioteket.\n\nHvis du er i tvivl, s� v�lg ja.")
 (inline-saved-program-in-executable/windows/path
   "ADVARSEL! Den frembragte k�rselsfil afh�nger af tre DLL'er: libmred.dll, libmzsch.gll og libgc.dll, som findes i \n\n~a\n\nK�rselsfilen finder DLL'erne enten i k�rselsfilens mappe eller gennem milj�variablen PATH.\n\nDa du installerede DrScheme, tilf�jede installationsprogrammet mappen med DLL'erne til brugerens PATH. V�r opm�rksom p� konfigurations�ndringer efter installationen.\n\nHvis du flytter k�rselsfilen til en anden maskine, skal du ogs� kopiere DLL'erne til den anden maskine --- enten til samme mappe som k�rselsfilen, eller til en mappe i den anden maskines PATH.")
 (launcher "Starter")
 (stand-alone "Selvst�nding")
 (executable-type "Type")
 (executable-base "Efternavn")
 (filename "Filnavn: ")
 (create "Lav")
 (please-choose-an-executable-filename "V�lg et filnavn til k�rselsfilen.")
 (windows-executables-must-end-with-exe
  "Filnavnet\n\n  ~a\n\ner ikke gyldigt.. Under Windows skal k�rselsfiler have efternavnet .exe.")
 (macosx-executables-must-end-with-app
  "Filnavnet\n\n  ~a\n\ner ikke gyldigt. Under  MacOS X skal k�rselsfiler have efternavnet .app.")
 (warning-directory-will-be-replaced
  "ADVARSEL: mappen:\n\n  ~a\n\nvil blive slettet. Forts�t?")
 
 (create-servlet "Lav en Servlet...")

 ; the ~a is a language such as "module" or "algol60"
 (create-servlet-unsupported-language
  "Lav Servlet virker ikke med sproget ~a .")

 ;;; buttons
 (execute-button-label "K�r")
 (save-button-label "Gem")
 (break-button-label "Afbryd")

 ;;; search help desk popup menu
 (search-help-desk-for "S�g p� hj�lpebordet efter \"~a\"")
 (exact-lucky-search-help-desk-for "Pr�cis, heldig s�gning p� hj�lpebordet efter \"~a\"")

 ;; collapse and expand popup menu items
 (collapse-sexp "Kollaps s-udtryk")
 (expand-sexp "Ekspander s-udtryk")

 ;;; fraction dialog
 (enter-fraction "Indtast br�k")
 (whole-part "Hele del")
 (numerator "T�ller")
 (denominator "N�vner")
 (invalid-number "Ugyldigt tal: skal v�re en v�re et eksakt, reelt, ikke-helt tal.")
 (insert-fraction-menu-item-label "Inds�t br�k...")

 ;; number snip popup menu
 (show-decimal-expansion "Vis som decimaltal")
 (show-fraction-view "Vis som br�k")
 (show-mixed-fraction-view "Vis som blandet tal")
 (show-improper-fraction-view "Vis som u�gte br�k")
 (show-more-decimal-places "Vis flere decimaler")

 ;;; TeachPack messages
 (select-a-teachpack "V�lg undervisningspakke")
 (clear-teachpack "Fjern undervisningspakken ~a")
 (teachpack-error-label "DrScheme - Undervisningspakkefejl")
 (teachpack-dne/cant-read "Undervisningspakkefilen ~a findes ikke, eller er ikke l�selig.")
 (teachpack-didnt-load "Undervisningspakkefilen ~a blev ikke hentet rigtigt.")
 (teachpack-error-invoke "Undervisningspakkefilen ~a gav en fejl ved k�rsel af undervisningspakke...")
 (add-teachpack-menu-item-label "Tilf�j Undervisningspakke")
 (clear-all-teachpacks-menu-item-label "Fjern alle undervisningspakker")
 (drscheme-teachpack-message-title "DrScheme Undervisningspakke")
 (already-added-teachpack "Undervisningspakken ~a er allerede tilf�jet")

 ;;; Language dialog
 (introduction-to-language-dialog
  "V�lg venligst et sprog. Elever i de fleste begynderkurser b�r v�lge det foresl�ede sprog.")
 (language-dialog-title "V�lg sprog")
 (case-sensitive-label "Forskel p� store og sm� bogstaver")
 (output-style-label "Output-stil")
 (constructor-printing-style "Konstrukt�r")
 (quasiquote-printing-style "Kvasicitering")
 (write-printing-style "write")
 (print-printing-style "current-print")
 (sharing-printing-label "Vis deling i v�rdier")
 (use-pretty-printer-label "Inds�t linjeskift i printede v�rdier")
 (input-syntax "Input-syntaks")
 (dynamic-properties "Dynamiske egenskaber")
 (output-syntax "Output-syntaks")
 (no-debugging-or-profiling "Ingen debugning eller profilering")
 (debugging "Debugging")
 (debugging-and-profiling "Debugning og profilering")
 (test-coverage "Syntaktisk d�kning af testsuiten")
 (whole/fractional-exact-numbers-label "Skriv tal som br�ker")
 (booleans-as-true/false-label "Skriv sandhedsv�rdier som true og false")
 (show-details-button-label "Vis detaljer")
 (hide-details-button-label "Skjul detaljer")
 (choose-language-menu-item-label "V�lg sprog...")
 (revert-to-language-defaults "Vend tilbage til standardsproget")
 (language-docs-button-label "Sprogdokumentation")
 (fraction-style "Br�kvisning")
 (use-mixed-fractions "U�gte br�ker")
 (use-repeating-decimals "Periodeiske decimalbr�ker")
 (decimal-notation-for-rationals "Brug decimaltalsnotation for br�ker")
 (please-select-a-language "V�lg venligst et sprog")


 ;;; languages
 (beginning-student "Begynder")
 (beginning-one-line-summary "define, cond, strukturer, konstanter og primitiver")
 (beginning-student/abbrev "Begynder med listeforkortelser")
 (beginning/abbrev-one-line-summary "Begynder, men udskrivning anvender listenotation i REPL")
 (intermediate-student "�vet")
 (intermediate-one-line-summary "Begynder med leksikalske virkefelter")
 (intermediate-student/lambda "�vet med lambda")
 (intermediate/lambda-one-line-summary "�vet med funktioner af h�jere orden")
 (advanced-student "Avanceret")
 (advanced-one-line-summary "�vet med lambda og mutation")
 (full-language "Fuldst�ndig") ;; also in the HtDP languages section
 (how-to-design-programs "How to Design Programs") ;; should agree with MIT Press on this one...
 (r5rs-like-languages "R5RS-lignende")
 (pretty-big-scheme "Temmelig omfattende Scheme (inklusiv MrEd og Avanceret)")
 (pretty-big-scheme-one-line-summary "Grafisk, med mange standardbiblioteker")
 (r5rs-lang-name "Standard (R5RS)")
 (r5rs-one-line-summary "R5RS, uden dikkedarer")
 (expander "Ekspanderen")
 (expander-one-line-summary "Ekspandere, snarere end evaluerer udtryk")
 (professional-languages "Professionelle sprog")
 (teaching-languages "Undervisningssprog")
 (experimental-languages "Eksperimentale sprog")

 (module-language-one-line-summary "Sprog med modul som eneste konstruktion")


 ;;; debug language
 (unknown-debug-frame "[ukendt]")
 (backtrace-window-title "Tilbagesporing - DrScheme")
 (files-interactions "~a's interaktioner") ;; filled with a filename
 (current-interactions "interaktioner")
 (current-definitions "definitioner")
; (stack-frame-in-current-interactions "interaktioner")
; (stack-frame-in-current-definitions "definitioner")
 (mzscheme-w/debug "Tekstuel (MzScheme, inkluderer R5RS)")
 (mzscheme-one-line-summary "PLT Scheme uden GUI ")
 (mred-w/debug "Grafisk (MrEd, inkluderer MzScheme)")
 (mred-one-line-summary "PLT Scheme med GUI")

 ;; profiling
 (profiling-low-color "Lav")
 (profiling-high-color "H�j")
 (profiling-choose-low-color "V�lg en farve til lav")
 (profiling-choose-high-color "V�lg en farve til h�j")
 (profiling "Profilering")
 (profiling-example-text "(define (foo) (foo))")
 (profiling-color-config "Farveomr�de for profilering")
 (profiling-scale "Farveskala for profilering")
 (profiling-sqrt "Kvadratrod")
 (profiling-linear "Line�r")
 (profiling-square "Kvadratisk")
 (profiling-number "Antal funktionskald")
 (profiling-time "Kumuleret tid")
 (profiling-clear "Rens profil")
 (profiling-update "Opdater profil")
 (profiling-col-percent-time "% tid")
 (profiling-col-function "Funktion")
 (profiling-col-name "Navn")
 (profiling-col-time-in-msec "millisekunder")
 (profiling-col-calls "Kald")
 (profiling-show-profile "Vis profil")
 (profiling-hide-profile "Skjul profil")
 (profiling-unknown-src "<< ukendt >>")
 (profiling-no-information-available "Der er ingen profileringsinformation tilg�ngelig. Er du sikker p�, at profilering er sat til i dit sprog, og at du har k�rt dit program?")
 (profiling-clear? "�ndringer i definitionsvinduet g�r profileringsinformationen ugyldig. Forts�t?")

 ;; test coverage
 (test-coverage-clear? "�ndringer i definitionsvinduet ugyldigg�r testd�kningsinformationen. Forts�t?")
 (test-coverage-clear-and-do-not-ask-again "Ja og sp�rg ikke igen")
 (test-coverage-ask? "Sp�rg om at rense d�kningen af testen")

 ;;; repl stuff
 (evaluation-terminated "Evaluering termineret")
 (evaluation-terminated-explanation
  "Evalueringstr�den k�rer ikke l�ngere, s� der kan ikke foretages yderligere evaluering inden n�ste k�rsel.")
 (last-stack-frame "vis sidste stakramme")
 (last-stack-frames "vis de ~a sidste stakrammer")
 (next-stack-frames "vis de n�ste ~a stakrammer")

 ;;; welcoming message in repl
 (language "Sprog")
 (custom "speciel")
 (teachpack "Undervisningspakke")
 (welcome-to "Velkommen til")
 (version "version")

 ;;; kill evaluation dialog
 (kill-evaluation? "Vil du sl� evalueringen ihjel?")
 (just-break "Bare afbryd")
 (kill "Ihjel")
 (kill? "Ihjel?")

 ;;; version checker
 (vc-wizard-check-note 
"Den version, du er ved at installere, er m�ske ikke den seneste.\n Hvis du vil kan DrScheme tjekke det for dig.")
 (vc-wizard-check-button "Tjek om der findes en opdatering")
 (vc-update-check "Opdateringstjek")
 (vc-please-wait "Vent venligst")
 (vc-connecting-version-server "Skaber forbindelse til PLT's versionsserver")
 (vc-network-timeout "Netv�rkstimeout")
 (vc-cannot-connect  "Kan ikke skabe forbindelse til PLT's versionsserver")
 (vc-network-failure "Netv�rksfejl")
 (vc-old-binaries "De instalerede binaries for DrScheme (eller MzScheme) er ikke up-to-date")
 (vc-binary-information-format "Installeret bin�r version: ~a (iteration ~a)")
 (vc-details-format "~a~nDetaljer:~n~a")
 (vc-details-text "Detaljer:~n")
 (vc-error-format "Fejl: ~a") 
 (vc-current-format "~a v.~a (iteration ~a) er up-to-date")
 (vc-update-format "~a v.~a (iteration ~a) beh�ver opdatering til v.~a (iteration ~a)")
 (vc-binary-name "Bin�r")
 (vc-updates-available "Opdateringer kan hentes hos")
 (vc-latest-binary-information-format "Sidste offentliggjorte version: ~a (iteration ~a)")
 (vc-update-dialog-title "PLT opdateringsstatus")
 (vc-need-update-string "En eller flere installerede PLT software-pakker beh�ver opdatering")
 (vc-no-update-string "Alle installerede softwarepakker fra PLT er allerede opdaterede")

 ;; special menu
 (special-menu "Speciel")

 ;; large semi colon letters
 (insert-large-letters... "Inds�t store bogstaver...")
 (large-semicolon-letters "Store semikolon-bogstaver")
 (text-to-insert "Tekst til inds�ttelse")

 (module-browser-filename-format "Fuldt filnavn: ~a (~a linjer)")
 (module-browser-root-filename "Rod-filnavn: ~a")
 (module-browser-font-size-gauge-label "Skriftst�rrelse")
 (module-browser-progress-label "Fremgang for moduloverblik")
 (module-browser-adding-file "Tilf�jer fil: ~a...")
 (module-browser-laying-out-graph-label "Beregner udseende for grafen")
 (module-browser-open-file-format "�bn ~a")
 (module-browser "Moduloversigt") ;; frame title
 (module-browser... "Moduloversigt...") ;; menu item title
 (module-browser-error-expanding "Fejl under ekspansion af programmet:\n\n~a")
 (module-browser-show-lib-paths "Vis filer l�st via (lib ..) stier")
 (module-browser-progress "Moduloversigt: ~a") ;; prefix in the status line
 (module-browser-compiling-defns "Moduloversigt: overs�tter definitioner")
 (module-browser-show-lib-paths/short "F�lg lib requires") ;; check box label in show module browser pane in drscheme window.
 (module-browser-refresh "Opdater") ;; button label in show module browser pane in drscheme window.
 (module-browser-only-in-plt-and-module-langs
  "Moduloversigten er kun tilg�ngelig for programmer i PLT-sprogene og i modul-sproget (og kun for de programmer, som benytter moduler).")

 (happy-birthday-matthias "Tillykke med f�dselsdagen, Matthias!")
 (happy-birthday-matthew  "Tillykke med f�dselsdagen, Matthew!")
 (happy-birthday-shriram  "Tillykke med f�dselsdagen, Shriram!")

 (mrflow-using-default-language-title "Sprog, som bruges n�r andet ikke er valgt")
 (mrflow-using-default-language "Det sprog, som anvendes nu, har ikke en typetabel defineret for dets primitiver. R5RS Scheme bruges i stedet.")
 (mrflow-button-title "Analyser")
 ;(mrflow-unknown-style-delta-error-title "Unknown Box Style Delta")
 ;(mrflow-unknown-style-delta-error "Unknown box style delta: ~a")
 (mrflow-coloring-error-title "Ukendt farve")
 (mrflow-coloring-error "Der er ikke defineret en stil for farven: ~a")
 (mrflow-popup-menu-show-type "Vis type")
 (mrflow-popup-menu-hide-type "Skjul type")
 (mrflow-popup-menu-show-errors "Vis fejl")
 (mrflow-popup-menu-hide-errors "Skjul fejl")

 ;(mrflow-read-exception-title "L�seundtagelse (Read Exception)")
 ;(mrflow-read-exception "L�seundtagelse (Read exception): ~a")
 ;(mrflow-syntax-exception-title "Syntaksundtagelse")
 ;(mrflow-syntax-exception "Syntaksundtagelse: ~a")
 ;(mrflow-unknown-exception-title "Ukendt undtagelse")
 ;(mrflow-unknwon-exception "Ukendt undtagelse: ~a")
 ;(mrflow-language-primitives-error-title "Fejl i sprogprimitiver")
 ;(mrflow-language-primitives-error "Forkert filnavn for tabellen med typer for sprogets primitiver: ~a")

 (snips-and-arrows-popup-menu-tack-all-arrows "Vis alle pile")
 (snips-and-arrows-popup-menu-untack-all-arrows "Skjul alle pile")
 (snips-and-arrows-user-action-disallowed-title "Bruger�ndringer er i �jeblikket ikke tilladt")
 (snips-and-arrows-user-action-disallowed "Bruger�ndringer er ikke tilladt i editorer, som indeholder snips (f.eks. pile) indsat fra et tool. Skjul alle snips for at f� lov til at �ndre editorens indhold.")
 ;(snips-and-arrows-changing-terms-warning-title "Changing terms will be undoable")
 ;(snips-and-arrows-changing-terms-warning "Changing terms in an editor containing snips cannot be undone.  You can either cancel this action, remove the snips, and try the change again, or you can continue with the change, in which case the change will not be undoable (all others changes made before and afterward will still be undoable though).")
 (snips-and-arrows-hide-all-snips-in-editor "Skjul alle snips i editoren")
  
 (xml-tool-menu "XML")
 (xml-tool-insert-xml-box "Inds�t XML-kasse")
 (xml-tool-insert-scheme-box "Inds�t Scheme-kasse")
 (xml-tool-insert-scheme-splice-box "Inds�t Scheme-splejningskasse (Splice Box)")
 (xml-tool-xml-box "XML-Kasse")
 (xml-tool-scheme-box "Scheme-Kasse")
 (xml-tool-scheme-splice-box "Scheme-splejsningskasse Scheme Splice Box")
 (xml-tool-switch-to-scheme "Skift til Scheme-kasse")
 (xml-tool-switch-to-scheme-splice "Skift til Scheme-splejsningskasse")
 (xml-tool-eliminate-whitespace-in-empty-tags "Fjern blanktegn i tomme tags")
 (xml-tool-leave-whitespace-alone "Bevar blanktegn")

 (show-recent-items-window-menu-item "Vis de senest �bnede filer i et separat vindue")
 (show-recent-items-window-label "Senest �bnede filer")
 (number-of-open-recent-items "Antal nye ting")
 (switch-anyway "Skift fil alligevel")

 (stepper-program-has-changed "ADVARSEL: Programmer er �ndret.")
 (stepper-program-window-closed "ADVARSEL: Programvinduet er v�k.")

 (wizard-next "N�ste")
 (wizard-back "Tilbage")
 (wizard-finish "F�rdig")


 ;; warnings about closing a drscheme frame when the program
 ;; might still be doing something interesting
 (program-is-still-running "Programmet i definitionsvinduet k�rer stadig. Luk alligevel?")
  (program-has-open-windows "Programmet i definitionsvinduet har �bne vinduer. Luk dette vindue alligevel?")

  ;; ml-command-line-arguments is for the command line arguments
  ;; label in the module language details in the language dialog.
  (ml-command-line-arguments "Kommandolinje argumenter som en vektor af strenge i read-syntaks.")
 
  ;; ml-cp names are all for the module language collection path
  ;; configuration. See the details portion of the language dialog
  ;; for the module language (at the bottom).
  (ml-cp-default-collection-path "<<standard collection-sti>>")

  ;; in std get-directory 
  (ml-cp-choose-a-collection-path "V�lg en collection-sti")

  ;; err msg when adding default twice
  (ml-cp-default-already-present
   "Standard collection-stien er allerede med")
  
  ;; title of this section of the dialog (possibly the word
  ;; `Collection' should not be translated)
  (ml-cp-collection-paths "Collection-stier")

  ;; button labels
  (ml-cp-add "Tilf�j")
  (ml-cp-add-default "Tilf�j standardindstilling")
  (ml-cp-remove "Fjern")
  (ml-cp-raise "Op")
  (ml-cp-lower "Ned")

  ;; Profj
  (profj-java "Java")
  (profj-java-mode "Java-tilstands")
  (profj-java-mode-color-keyword "n�gleord")
  (profj-java-mode-color-string "streng")
  (profj-java-mode-color-literal "bogstavelighed")
  (profj-java-mode-color-comment "kommentar")
  (profj-java-mode-color-error "fejl")
  (profj-java-mode-color-identifier "navn")
  (profj-java-mode-color-default "andet")
  
  ;; The Test Suite Tool
  ;; Errors
  (test-case-empty-error "Tom test")
  (test-case-too-many-expressions-error "For mange udtryk i en test")
  (test-case-not-at-top-level "Test-boks ikke p� top-niveaue")
  ;; Dr. Scheme window menu items
  (test-case-insert "Inds�t test")
  (test-case-disable-all "Sl� alle tests fra")
  (test-case-enable-all "Sl� alle tests til")
  ;; NOTE: The following three string constants are labels of the test-case fields. The width
  ;;       of the field is determined by the length of the longest of the following three words.
  ;;       if the words are too long the test case will take up too much horizontal room and
  ;;       not look very good.
  ;; This string is the label of the expression that is being tested in a test case.
  (test-case-to-test "Skal testes")
  ;; This string is the label of the expression that is the expected value of the to-test expression.
  (test-case-expected "Forventet")
  ;; This string is the label of the actual result of the to test expression.
  (test-case-actual "Faktisk")

 )