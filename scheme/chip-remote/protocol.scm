;;;;
;; Copyright 2012 Frank Terbeck <ft@bewatermyfriend.org>, All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:
;;
;; 1. Redistributions of source code must retain the above copyright notice,
;;    this list of conditions and the following disclaimer.
;; 2. Redistributions in binary form must reproduce the above copyright
;;    notice, this list of conditions and the following disclaimer in the
;;    documentation and/or other materials provided with the distribution.
;;
;; THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
;; INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
;; AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
;; AUTHOR OR CONTRIBUTORS OF THE PROJECT BE LIABLE FOR ANY DIRECT, INDIRECT,
;; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
;; NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
;; THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(define-module (chip-remote protocol)
  :use-module (chip-remote io)
  :use-module (srfi srfi-1)
  :export (bye
           hi
           features
           modes
           ports
           protocol-version))

(define (protocol-read conn)
  (let ((reply (io-read conn)))
    (if (or (string-prefix? "WTF" reply)
            (string-prefix? "MALFORMED-COMMAND" reply)
            (string-prefix? "BROKEN-VALUE" reply)
            (string-prefix? "VALUE-OUT-OF-RANGE" reply))
        (let* ((tokens (string-tokenize reply protocol-char-set))
               (excp (symbol-append 'protocol-
                                    (reply->symbol (car tokens)))))
          (throw excp (cdr tokens))))
    reply))

(define (zip2 la lb)
  (let next ((a la)
             (b lb)
             (acc '()))
    (cond ((any null? (list a b))
           (reverse acc))
          (else
           (next (cdr a) (cdr b)
                 (cons (cons (car a) (car b))
                       acc))))))

;; Words in the protocol may contain letters, a dash and digits from ASCII.
(define protocol-char-set
  (char-set-union
   (char-set-diff+intersection char-set:ascii
                               char-set:letter+digit)
   (char-set #\-)))

;; Turn a hexadecimal string into an integer. Returns `#f' in case of an error.
(define (hexstring->int str)
  (string->number str 16))

;; Takes a pair:
;;
;;   - If the second item is a string, the first string must be the same string.
;;   - If the second item is 'int, the first must by a valid hexstring.
;;
;; Returns a pairs: `#t' or `#f' depending on whether the verification
;; succeeded and the (possibly converted) input data; if the first value is
;; `#f', the second is always the unchanged input data.
(define (verify-and-convert pair)
  (let ((got (car pair))
        (want (cdr pair)))
    (cond ((string? want)
           (cons (string=? want got)
                 got))
          ((eq? want 'int)
           (let* ((val (hexstring->int got))
                  (success (integer? val)))
             (cons success
                   (if success val got))))
          ((eq? want 'string)
           (cons #t got))
          (else
           (cons #f got)))))

;; Checks if an input string meets the supplied conditions.
;;
;; Say the input is "VERSION 2 7 c" and the conditions are these: The string's
;; first word has to be "VERSION". The following parts need to be exactly three
;; chunks of hexadecimally encoded integers.
;;
;; You'd call it like this:
;;
;;  (expect-read "VERSION 2 7 c" '("VERSION" int int int))
;;    => ("VERSION" 2 7 12)
(define (expect-read string what)
  (let ((tokens (string-tokenize string protocol-char-set)))
    (unless (eq? (length what) (length tokens))
      (throw 'protocol-number-of-words-mismatch string tokens what))
    (reverse
     (fold (lambda (new acc)
             (let ((v (verify-and-convert new)))
               (unless (eq? (car v) #t)
                 (throw 'protocol-unexpected-data new))
               (cons (cdr v) acc)))
           '()
           (zip2 (string-tokenize string protocol-char-set) what)))))

;; Read from the device, save the reply and run code in case the read was
;; successful. Return `#f' otherwise.
(define-syntax with-read-raw-string
  (lambda (x)
    (syntax-case x ()
      ((_ (c r) code ...)
       #'(let ((r (protocol-read c)))
           code ...)))))

;; Initiate communication channel to the device.
(define (hi conn)
  (io-write conn "HI")
  (with-read-raw-string (conn reply)
    (unless (string=? reply "Hi there, stranger.")
      (throw 'protocol-hi-failed reply))
    #t))

;; Close down communication channel to the device.
(define (bye conn)
  (io-write conn "BYE")
  (with-read-raw-string (conn reply)
    (unless (string=? reply "Have a nice day.")
      (throw 'protocol-bye-failed reply))
    #t))

;; Query protocol version from the board.
(define (protocol-version conn)
  (io-write conn "VERSION")
  (with-read-raw-string (conn reply)
    (expect-read reply '("VERSION" int int int))))

;; A set of commands return more than one reply. The host triggers the 2nd to
;; the N-th reply by saying "MORE". The board will reply with DONE when there
;; is nothing more to say. This function does exactly that and returns a list
;; of replies for further processing.
(define (list-more-done conn item)
  (io-write conn item)
  (let next ((f '())
             (reply (protocol-read conn)))
    (cond ((string=? reply "DONE") f)
          (else (io-write conn "MORE")
                (next (cons reply f)
                      (protocol-read conn))))))

;; Turns a string into a lower-cased symbol: "FOO" => foo
(define (reply->symbol s)
  (string->symbol (string-downcase s)))

(define (request->list-of-symbols conn request)
  (map reply->symbol (list-more-done conn request)))

;; Queries the board's feature list and returns a list of according symbols.
(define (features conn)
  (request->list-of-symbols conn "FEATURES"))

(define (string+int->pair s)
  (let ((l (expect-read s '(string int))))
    (cond ((not (list? l)) l)
          (else (cons (reply->symbol (car l))
                      (cadr l))))))

;; Queries the board for its ports and returns a list of alists.
(define (ports conn)
  (map string+int->pair (list-more-done conn "PORTS")))

(define (modes conn)
  (request->list-of-symbols conn "MODES"))
