
(module info (lib "infotab.ss" "setup")
  (define name "XML")
  ;; the XML tool has been moved to the stepper collection, so that 
  ;; the stepper can create xml snips.  See collects/stepper/tool.ss for (a bit) more information
  (define help-desk-message "Mz/Mr: (require (lib \"xml.ss\" \"xml\"))")
  (define blurb
    `("The XML collection provides functions for reading, writing, and manipulating XML documents."))
  (define tools (list "text-box-tool.ss"))
  (define tool-name (list "Text Box")))


  