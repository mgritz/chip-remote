;; Copyright (c) 2018 chip-remote workers, All rights reserved.
;;
;; Terms for redistribution and use can be found in LICENCE.

(define-module (chip-remote modify)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (chip-remote device)
  #:use-module (chip-remote page-map)
  #:use-module (chip-remote register-map)
  #:use-module (chip-remote register)
  #:use-module (chip-remote item)
  #:use-module (chip-remote codecs)
  #:use-module (chip-remote interpreter)
  #:use-module (chip-remote semantics)
  #:use-module (chip-remote validate)
  #:export (modify modify* chain-modify chain-modify* register-matches? regmap-matches?))

(define (not-integer? x)
  "Predicate for values that are anything **but** integers."
  (not (integer? x)))

(define (modify-ref reg addr)
  "Reference an item in a register

This function supports all addressing schemes that chain-modify advertises at a
register level:

    INTEGER             Reference the Nth item in the register.
    (INTEGER)           Same as the previous.
    SYMBOL              Reference the first item named SYMBOL.
    (SYMBOL)            Same as the previous.
    (SYMBOL INTEGER)    Reference the Nth item named SYMBOL."
  (match addr
    (((? integer? i)) (register-address reg i))
    ((? integer? i) (register-address reg i))
    (((? not-integer? name)) (register-ref reg name))
    ((n (? integer? i)) (register-address reg n i))
    ((? not-integer? name) (register-ref reg name))
    (_ (throw 'unknown-addressing-scheme addr))))

(define (modify-register reg init addr value)
  "Modification backend for registers.

See the modify function about parameters' semantics."
  ;;(format #t "debug: ~a ~a ~a~%" init addr value)
  (let ((item (modify-ref reg addr)))
    (unless (item? item)
      (throw 'addressing-returned-non-item item addr))
    (if (validate-item-value item value)
        ((item-set item) init (item-encode item value))
        (throw 'invalid-value-for-item value item))))

(define (register-matches? reg addr)
  "Checks if an address (`addr`) references something in the given
register (`reg`)."
  (match addr
    ((ra . rest) (eqv? ra (car reg)))
    (name (register-ref (cdr reg) name))
    (_  #f)))

(define (regmap-matches? regmap addr)
  "Checks if an address (`addr`) references something in the given
register-map (`regmap`)."
  (match addr
    ((rma . rest) (eqv? rma (car regmap)))
    (name (register-map-ref (cdr regmap) name))
    (_  #f)))

(define (modify-register-map rm init addr value)
  "Modification backend for register-maps.

See the modify function about parameters' semantics."
  (map (lambda (r v)
         (if (register-matches? r addr)
             (modify-register (cdr r) v
                              (if (list? addr) (cdr addr) addr)
                              value)
             v))
       (register-map-table rm)
       init))

(define (modify-page-map pm init addr value)
  "Modification backend for page-maps.

See the modify function about parameters' semantics."
  (map (lambda (rm v)
         (if (regmap-matches? rm addr)
             (modify-register-map (cdr rm) v
                                  (if (list? addr) (cdr addr) addr)
                                  value)
             v))
       (page-map-table pm)
       init))

(define (modify-device dev init addr value)
  "Modification backend for devices.

See the modify function about parameters' semantics."
  (modify-page-map (device-page-map dev) init addr value))

(define (modify target init address value)
  "Performs a modification on a target

The ‘address’ parameter will be used to reference an item in the target. The
‘init’ parameter is the value to apply the modification to. And ‘value’ is the
value used with the item's semantics to produce the desired result."
  ((cond ((register? target) modify-register)
         ((register-map? target) modify-register-map)
         ((page-map? target) modify-page-map)
         ((device? target) modify-device)
         (else (throw 'invalid-target target init address value)))
   target init address value))

(define (default-by-target target)
  "Returns the default value of a target."
  ((cond ((register? target) register-default)
         ((register-map? target) register-map-default)
         ((page-map? target) page-map-default)
         ((device? target) device-default)
         (else (throw 'invalid-target target)))
   target))

(define (modify* target address value)
  "This is the same as ‘modify’ with its ‘init’ parameter set to the default
value that can be derived for ‘target’."
  (modify target (default-by-target target) address value))

(define (chain-modify target init . lst)
  "Apply multiple modifications to a target

With a `target` being one of: `register`, `register-map`, `page-map` or
`device`. The `init` parameter is the value from which to start applying all
the listed modifications, which are passed to the function as all parameters
following the `init` parameter.

Example:

    (chain-modify (device-default adf4169)
                  adf4169
                  '(deviation-offset 9)
                  '(phase -12)
                  '(delay-clock-select pfd-clock-times-clock1)
                  '(ramp-mode triangular)
                  '(ramp-enabled? yes)))

The modifications are of the form (ADRESS VALUE), where ADDRESS is either a
symbol, that could be passed to one of the `*-ref` functions (like device-ref)
or a list that could be passed to one of the `*-address` functions (like
device-address) to reference an item."
  (if (null? lst)
      init
      (apply chain-modify
             (cons target
                   (cons (modify target init (caar lst) (cadar lst))
                         (cdr lst))))))

(define (chain-modify* target . lst)
  "This is the same as ‘chain-modify’ with its ‘init’ parameter set to the
default value that can be derived for ‘target’."
  (apply chain-modify (cons target (cons (default-by-target target) lst))))
