;; Copyright (c) 2014 chip-remote workers, All rights reserved.
;;
;; Terms for redistribution and use can be found in LICENCE.

(define-module (chip-remote level-3)
  #:use-module (chip-remote decode)
  #:use-module (chip-remote decode to-text)
  #:export (define-bit-field-frontends
            replay-register
            to-tty?
            value-decoder))

(define-syntax replay-register
  (lambda (x)
    (syntax-case x ()
      ((_ c a (l2 args ...))
       #'(write-register c a (l2 (read-register c a) args ...))))))

(define-syntax define-bit-field-frontend
  (lambda (x)
    (syntax-case x ()
      ((_ name addr lvl2 (args ...))
       #'(define-public (name conn args ...)
           (replay-register conn addr (lvl2 args ...))))
      ((_ name addr lvl2)
       #'(define-bit-field-frontend name addr lvl2 ())))))

(define-syntax define-bit-field-frontends
  (lambda (x)
    (syntax-case x ()
      ((_ (entry ...) ...)
       #'(begin (define-bit-field-frontend entry ...) ...)))))

(define (value-decoder regmap width addr value colour?)
  (display-list (register->text #:register-map regmap
                                #:address addr
                                #:width width
                                #:value value
                                #:colour? colour?)))

(define (device-decoder regmap decoder conn colour?)
  (fold + 0 (map (lambda (a) (decoder conn a))
                 (map car regmap))))

(define (to-tty?)
  (isatty? (current-output-port)))
