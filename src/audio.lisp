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

(in-package :mfcc)

(defstruct (audio-segment
	    (:print-function
	     (lambda (struct stream depth)
	       (declare (ignore depth))
	       (format stream "[audio-segment: ~A seconds, sample-rate: ~A, sample-count: ~A]"
		       (audio-segment-seconds struct)
		       (audio-segment-sample-rate struct)
		       (length (audio-segment-samples struct))))))
  "Audio samples plus meta-data, such as the sample rate."
  seconds
  id
  source
  sample-rate
  sample-resolution
  transcript
  samples
  filename)

(defun vector-sequence-mean (sequence-of-vectors)
  "Element-wise mean of a sequence of equal-length vectors, as a vector of single-floats."
  (let* ((n (length sequence-of-vectors))
	 (sum (make-array (length (elt sequence-of-vectors 0)) :element-type 'single-float :initial-element 0.0)))
    (map nil (lambda (v) (map-into sum '+ sum v)) sequence-of-vectors)
    (map-into sum (lambda (x) (/ x n)) sum)))
