(use slib)
(require 'trace)

(define (unless! condition usual-value exceptional-value)
  (print (format #f "unless ~a ~a ~a"
				 condition usual-value exceptional-value))
  (if condition exceptional-value usual-value))

(define (factorial n)
  (newline)
  (print (format #f "(factorial ~d)" n))
  (print (format #f "=> (unless (= ~d 1)" n))
  (print (format #f "           (* ~d (factorial (- ~d 1)))" n n))
  (print            "           1))")
  (print (format #f "=> (unless ~a *** 1)" (if (= n 1) "#t" "#f") ))
;         (format #f " *** 1))" (* n (factorial (- n 1))) ))
  (print (format #f "=> (if ~a 1 ***))" (if (= n 1) "#t" "#f") ))
;  (print            "       1")
;  (print (format #f "       ~a))" (* n (factorial (- n 1))) ))
		 
  (unless! (= n 1)
          (* n (factorial (- n 1)))
          1))

;(trace unless!)
;(trace factorial)

(factorial 5)
; => (unless (= 5 1) (* 5 (factorial 4)) 1)
; => (if #f 1 (* 5 (factorial 4)))
; => (* 5 (factorial 4))
; (factorial 4)
; => (unless (= 4 1) (* 4 (factorial 3)) 1)
; => (if #f 1 (* 4 (factorial 3)))
; => (* 4 (factorial 3))
; (factorial 3)
; => (unless (= 3 1) (* 3 (factorial 2)) 1)
; => (if #f 1 (* 3 (factorial 2)))
; => (* 3 (factorial 2))
; (factorial 2)
; => (unless (= 2 1) (* 2 (factorial 1)) 1)
; => (if #f 1 (* 2 (factorial 1)))
; => (* 2 (factorial 1))
; (factorial 1)
; => (unless (= 1 1) (* 1 (factorial 0)) 1)
; => (if #t 1 (* 1 (factorial 0)))
; => 1

