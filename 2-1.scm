(require "./lib")

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))
 
(define (make-rat+ n d) ; n:ʬ��, d:ʬ��
  (let ((g (gcd (abs n) (abs d))))
    (if (< d 0)
        (cons (/ (- n) g) (/ (- d) g))
        (cons (/ n g) (/ d g)))))
