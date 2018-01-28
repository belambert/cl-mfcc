;; -*- Mode: Lisp -*- 

(asdf:defsystem "mfcc"
  :name "mfcc"
  :description "MFCC features, or Mel-frequency cepstral coefficients."  
  :version "1.0.0"
  :author "Ben Lambert <belambert@mac.com>"
  :license "Apache-2.0"
  :serial t
  :components
  ((:module src
    :serial t
    :components
    ((:file "package")
     (:file "vector-math")
     ;;(:file "wav-interface")
     (:file "mfcc"))))
  ;; will need some audio reading dependencies here...
  :depends-on (:alexandria
	       :dct
	       :bordeaux-fft
	       :cl-wav))

