(require "./3-59")

(define (average x y)

;��3.5.3
(define (sqrt-improve guess x)
  (average guess (/ x guess)))
