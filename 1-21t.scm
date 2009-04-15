(require "./lib")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (smallest-divisor n)
  (display "smallest-divisor")
  (newline)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (display "find-divisor")
  (newline)
  (display "square")
  (newline)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (display "divides?")
  (newline)
  (display "remainder")
  (newline)
  (= (remainder b a) 0))

(define (prime? n)
  (display "prime?")
  (newline)
  (= n (smallest-divisor n)))
