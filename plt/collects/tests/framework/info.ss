(module info (lib "infotab.ss" "setup")
  (define name "Framework Test Suite")
  (define compile-omit-files '("key-specs.ss" "utils.ss" "receive-sexps-port.ss"))
  (define mred-launcher-libraries (list "framework-test-engine.ss"))
  (define mred-launcher-names (list "Framework Test Engine"))
  (define mzscheme-launcher-libraries (list "main.ss"))
  (define mzscheme-launcher-names (list "Framework Test")))