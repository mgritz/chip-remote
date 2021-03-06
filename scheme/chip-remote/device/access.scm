;; Copyright (c) 2018 chip-remote workers, All rights reserved.
;;
;; Terms for redistribution and use can be found in doc/LICENCE.

(define-module (chip-remote device access)
  #:use-module (srfi srfi-9)
  #:use-module (ice-9 optargs)
  #:use-module (chip-remote device spi)
  #:use-module (chip-remote device transfer)
  #:export (make-device-access
            device-access?
            da-bus
            da-transfer
            da-read
            da-write))

(define-record-type <device-access>
  (make-device-access* bus transfer read write)
  device-access?
  (bus da-bus)
  (transfer da-transfer)
  ;; These shoud be interpreter script or scheme procedures too.
  (read da-read)
  (write da-write))

(define* (make-device-access #:key
                             (bus (make-device-access-spi))
                             (transfer (make-device-transfer))
                             (read identity)
                             (write identity))
  (make-device-access* bus transfer read write))
