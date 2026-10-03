;; Copyright 2010-2018 Ben Lambert

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;     http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(defpackage :mfcc-test
  (:use :common-lisp :mfcc :lisp-unit)
  (:export :run))

(in-package :mfcc-test)

(defun run () (run-tests :all :mfcc-test))

(defun sine (freq &key (rate 16000) (n 3200))
  (let ((s (make-array n :element-type 'single-float)))
    (dotimes (i n)
      (setf (aref s i) (coerce (sin (* 2 pi freq (/ i rate))) 'single-float)))
    (make-audio-segment :samples s :sample-rate rate :seconds (/ n rate))))

(define-test mel-roundtrip
  (assert-float-equal 1000.0 (mfcc::inverse-mel (mel 1000.0)) 1.0)
  (assert-float-equal 0.0 (mel 0.0)))

(define-test mfcc-shape
  (let ((m (get-mfcc-features (sine 1000))))
    (assert-equal 18 (length m))
    (assert-equal 39 (length (aref m 0)))
    (assert-equal 13 (length (aref (coerce (get-mel-cepstrum (sine 1000)) 'vector) 0)))))

(define-test cepstrum-count
  (assert-equal 20 (length (first (get-mel-cepstrum (sine 1000) :cepstrum-count 20)))))

(define-test preemphasis-does-not-mutate
  (let* ((a (sine 500))
	 (orig (copy-seq (audio-segment-samples a))))
    (get-mfcc-features a)
    (assert-equalp orig (audio-segment-samples a))))

(define-test mean-normalization
  (let* ((raw (get-mel-cepstrum (sine 1000)))
	 (norm (mfcc::cepstra-mean-normalization (copy-list raw)))
	 (mean (mfcc::vector-sequence-mean norm)))
    (assert-true (every (lambda (x) (< (abs x) 1e-4)) mean))))

(define-test deltas
  (let ((const (vector #(1.0 2.0) #(1.0 2.0) #(1.0 2.0)))
	(ramp (vector #(0.0) #(1.0) #(2.0) #(3.0) #(4.0))))
    (assert-true (every (lambda (v) (every #'zerop v)) (mfcc::get-feature-deltas const)))
    (assert-float-equal 1.0 (aref (aref (mfcc::get-feature-deltas ramp) 2) 0))))

(define-test tone-has-distinct-spectrum
  (let ((lo (first (get-mel-cepstrum (sine 500))))
	(hi (first (get-mel-cepstrum (sine 2500)))))
    (assert-true (> (reduce #'max (map 'vector #'abs (map 'vector #'- lo hi))) 0.1))))
