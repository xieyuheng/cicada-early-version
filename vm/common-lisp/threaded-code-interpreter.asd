(defsystem #:threaded-code-interpreter
  :description "threaded-code interpreter of cicada language"
  :author "XIE Yuheng <xyheme@gmail.com>"
  :depends-on ()
  :serial t
  :components ((:file "threaded-code-interpreter--package-header")
               (:file "threaded-code-interpreter")))
