;; -*- Mode: Lisp -*- 

(asdf:defsystem "mfcc-test"
  :name "mfcc-test"
  :description "MFCC feature computation tests."
  :version "1.0.0"
  :author "Ben Lambert <belambert@mac.com>"
  :license "Apache-2.0"
  :serial t
  :components
  ((:module src
    :serial t
    :components
    ((:file "test"))))
  :depends-on (:mfcc
	       :lisp-unit
	       ;; cl-coverage fails without explicitly loading these
	       :trivial-features
	       :babel
	       :cl-coveralls))
