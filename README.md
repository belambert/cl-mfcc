cl-mfcc
=======

Compute MFCC (Mel-frequency cepstral coefficient) features from audio in Common Lisp.

Given an `audio-segment` of samples, `get-mfcc-features` splits it into overlapping frames, applies
pre-emphasis, takes a power spectrum (zero-padded FFT), applies a mel filter bank, takes the log, and
then a DCT.  Each output frame is a vector of the cepstra followed by their velocity (delta) and
acceleration (delta-delta) values, so 13 cepstra gives 39 values per frame.

Status: early; the API may still change.

Dependencies
------------

`alexandria`, `bordeaux-fft`, and [cl-dct](https://github.com/belambert/cl-dct).  Tests use `lisp-unit`.

Usage
-----

    (ql:quickload :mfcc)

    (let* ((samples (make-array 16000 :element-type 'single-float :initial-element 0.0))
           (audio (mfcc:make-audio-segment :samples samples :sample-rate 16000 :seconds 1)))
      (mfcc:get-mfcc-features audio))
    ;; => #(#(...39 floats...) ...), one vector per frame

Samples must be a `(simple-array single-float)`.  Keyword arguments to `get-mfcc-features`:

| Argument                    | Default | Meaning                                         |
|-----------------------------|---------|-------------------------------------------------|
| `:filter-bank-size`         | 40      | number of mel filters                           |
| `:start-freq` `:end-freq`   | 100 4000 | filter bank range in Hz (suits 8 kHz audio)    |
| `:cepstrum-count`           | 13      | cepstra kept per frame                          |
| `:preemphasize`             | 0.95    | pre-emphasis coefficient, or `nil` to disable   |
| `:cepstra-mean-normalization` | `t`   | subtract the per-utterance cepstral mean        |
| `:frame-length` `:frame-delta` | 25 10 | frame size and hop in ms                       |

For 16 kHz audio, consider `:end-freq 8000`.

Tests
-----

    sbcl --eval '(ql:quickload :mfcc-test)' --eval '(mfcc-test:run)'
