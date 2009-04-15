(define (equal?x a b)
   (or (and (symbol? a)
            (symbol? b)
            (eq? a b))
       (and (equal? (car a) (car b))
            (equal? (cdr a) (cdr b)))))

(define (equal?y a b)
  (if (and (symbol? a) (symbol? b))
      (eq? a b)
      (and (equal? (car a) (car b))
           (equal? (cdr a) (cdr b)))))

(define (equal? a b)
  (cond ((and (null? a) (null? b))
         #t)
        ((and (symbol? a) (symbol? b))
         (eq? a b))
        ((and (pair? a) (pair? b))
         (and (equal? (car a) (car b))
              (equal? (cdr a) (cdr b))))
        (else #f)))

(define (equal? a b)
  (cond ((and (null? a) (null? b))
         #t)
        ((and (number? a) (number? b))    ;;追加部分。a,bが共に数値なら
         (= a b))                          ;a=bかどうか
        ((and (symbol? a) (symbol? b))
         (eq? a b))
        ((and (pair? a) (pair? b))
         (and (equal? (car a) (car b))
              (equal? (cdr a) (cdr b))))
        (else #f)))
(define u '(this is a list))
(define v '(this (is a) list))
(define a '(x y z))
(define b '(x y z))
(define c '(x y))
(define x 'a)
(define y 'b)

