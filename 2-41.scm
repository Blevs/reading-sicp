(require "./lib")

(define (unique-trio n)
  (flatmap (lambda (i)
             (flatmap (lambda (j)
                        (map (lambda (k) (list i j k))
                             (enumerate-interval 1 (- j 1))))
                      (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

(define (unique-trio n)
  (flatmap (lambda (i)
             (flatmap (lambda (j)
                        (map (lambda (k) (list i j k))
                             (enumerate-interval 1 (- j 1))))
                      (enumerate-interval 2 (- i 1))))
           (enumerate-interval 3 n)))

(define (s-sum-trios n s)
  (define (sum-equals-s? trio)
    (= (+ (car trio) (cadr trio) (caddr trio)) s))
  (filter sum-equals-s? (unique-trio n)))
