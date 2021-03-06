(define-module (chip-remote register-map)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (ice-9 control)
  #:use-module (ice-9 pretty-print)
  #:use-module (chip-remote process-plist)
  #:use-module (chip-remote item)
  #:use-module (chip-remote register)
  #:use-module (chip-remote utilities)
  #:export (generate-register-map
            make-register-map
            register-map?
            register-map-meta
            register-map-table
            register-map-registers
            register-map-default
            register-map-item-names
            register-map-register
            register-map-fold
            register-map-ref
            register-map-ref->address
            register-map-address
            register-map-address->index
            register-address->index
            define-register-map))

(define-record-type <register-map>
  (make-register-map meta table)
  register-map?
  (meta register-map-meta)
  (table register-map-table))

(define group:table
  (group 'table
         #:type 'list
         #:predicate (lambda (x)
                       (memq x '(#:table #:table*)))
         #:transformer (lambda (e)
                         (syntax-case e ()
                           ((#:table (addr (exps ...)) ...)
                            #'((cons addr (generate-register exps ...)) ...))
                           ((#:table* (addr exp) ...)
                            #'((cons addr exp) ...))))))

(define-syntax generate-register-map
  (lambda (x)
    (syntax-case x ()
      ((kw exp0 expn ...)
       (is-kw? #'exp0)
       (with-syntax (((((table ...) ...) (meta ...))
                      (process-plist #'(exp0 expn ...)
                                     group:table
                                     (group 'meta))))
         #'(make-register-map (list meta ...)
                              (list table ... ...)))))))

(define (register-map-default rm)
  (map (lambda (x) (register-default (cdr x)))
       (register-map-table rm)))

(define (register-map-item-names rm)
  (flatten (map (lambda (x) (register-item-names (cdr x)))
                (register-map-table rm))))

(define-syntax-rule (define-register-map binding e0 e* ...)
  (define binding (generate-register-map e0 e* ...)))

(define (register-map-registers rm)
  (map cdr (register-map-table rm)))

(define (register-map-register rm)
  (let ((rm* (register-map-table rm)))
    (if (and (= (length rm*) 1)
             (eq? (caar rm*) #f))
        (cdar rm*)
        (throw 'more-than-single-register rm))))

(define (register-map-fold fnc init rm)
  (fold (lambda (reg acc)
          (fnc (car reg) (cdr reg) acc))
        init
        (register-map-table rm)))

(define-syntax-rule (rm-iter init return rm fnc)
  (call/ec (lambda (return) (register-map-fold fnc init rm))))

(define (register-map-ref->address rm name)
  (rm-iter #f return rm
           (lambda (ra reg acc)
             (let ((item (register-ref->address reg name)))
               (if item
                   (return (cons ra item))
                   #f)))))

(define (register-map-ref rm name)
  (rm-iter #f return rm
           (lambda (ra reg acc)
             (let ((item (register-ref reg name)))
               (if (item? item)
                   (return item)
                   #f)))))

(define register-map-address
  (case-lambda
    ((rm reg-addr) (rm-iter #f return rm
                            (lambda (ra reg acc)
                              (if (eqv? ra reg-addr)
                                  (return reg)
                                  #f))))
    ((rm reg-addr item-addr)
     (register-ref/address (register-map-address rm reg-addr) item-addr))
    ((rm reg-addr name cnt)
     (register-address (register-map-address rm reg-addr) name cnt))))

(define (register-map-address->index rm addr)
  (let loop ((rest (register-map-table rm)) (idx 0))
    (if (null? rest)
        #f
        (let ((this (car rest)))
          (if (eqv? (car this) addr)
              idx
              (loop (cdr rest) (+ idx 1)))))))

(define (register-address->index rm addr)
  (rm-iter 0 return rm
           (lambda (pa rm idx)
             (if (eqv? pa addr)
                 (return idx)
                 (+ idx 1)))))
