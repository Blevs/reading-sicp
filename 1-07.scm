(define (square x)
  (* x x))

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
;  (print "  improve guess: " guess " >> " (average guess (/ x guess)))
  (average guess (/ x guess)))


(define (good-enough? guess x)
;  (print "  good-enough?: " (- (square guess) x))
  (print " (g*g, x) = (" (square guess) ", " x ") ... " (- (square guess) x) )
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt-iter guess x)
;  (print "(sqrt-iter " guess " " x ")")
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

; (print (sqrt 9))
; (print (sqrt (+ 100 37)))

; (print (sqrt 0.0001))

; |guess2 - micro-x| < 0.001 �ˤʤ�Ф����ʤ�
; micro��x���Ф� ��0.001 �Ȥϡ�����
; guess = ��0.001 = 0.03162277660168379331 �� guess^2 = 0.001
; guess = 

;big: ��ư�����������٤Τ����ǡ�guess�����äƹԤ��ʤ� 
;;(guess + x/guess)/2 ����
;�������� 1e46�ǥ��ᡣ
;good-enough ��... 

;(sqrt-iter 1.0e23 1.0e46)
;  good-enough?: -1.2676506002282294e30
;  Guess: 1.0e23 >> 1.0e23
;�ǡ�| 1.0e23^2

;(* 1.0e23 1.0e23) = 9.999999999999999e45
;�� good-enough �� -1.2676506002282294e30 �����顣
;0.001 �Ϥ��ޤ�ˤ⾮�������롣x �˱����� threshold �����٤���

; ɮ���Ǥ�Ǥ���������


(use slib)
(require 'trace)
(trace sqrt-iter)
(trace improve)
(trace good-enough?)
;(trace new-if)

