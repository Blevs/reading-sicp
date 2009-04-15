(require "./lib")
(require "./1-21")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

;(+ 1 (random (- n 1)) ���ߤ����Τ� [1 .. n-1] �ʤΤ� (1 .. n-1) �ʤΤ�ʸ�դ��������
; between ��ξü���ޤޤ�뤫���ƥ��Ȥˤϴޤޤ�ʤ��ۤ��������������뤬��random �λȤ��������¬����ˡ�ξü��ޤ����Τǥƥ��Ȥ��Ƥ���äݤ���
; ���ȡ�random �λ��ͤȡ�
; (random x) ��
;   [0 .. x] �ʤ� (+ 1 (random (- n 1))) = (+ 1 [0 .. n-1]) = [1 .. n]
;   [0 .. x-1] �ʤ� (+ 1 (random (- n 1))) = (+ 1 [0 .. n-2]) = [1 .. n-1] ���֤󤳤�����ꤷ�Ƥ�����
;   [1 .. x] �ʤ� (+ 1 (random (- n 1))) = (+ 1 [1 .. n-1]) = [2 .. n]
;   [1 .. x-1] �ʤ� (+ 1 (random (- n 1))) = (+ 1 [1 .. n-2]) = [2 .. n-1]
; ��������a=1 ���� (expmod 1 n n) �������� n(��2) �ˤĤ��� 1 �ˤʤ�Τǥƥ��Ȥˤʤ�ʤ����ܵ���������

(define (random-integer-between a b)
  (+ a (random (+ (- b a) 1))))
(define (random-positive-integer-n-and-less n)
  (+ 1 (random n)))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (random-integer-between 2 (- n 2))))

;  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else #f)))

(define (find-divisor n test-divisor)
  (define (next d)
    (if (= d 2) 3 (+ d 2)))
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(define (timed-prime-test n times)
  (newline)
  (display n)
  (start-prime-test n times (runtime)))

(define (start-prime-test n times start-time)
  (if (fast-prime? n times)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

;(timed-prime-test 1999)

(define (search-for-primes start end times)
  (define (iter n)
    (timed-prime-test n times)
    (if (< n end)
        (iter (+ n 1))))
  (iter start))

(define (test start end)
  (search-for-primes start end 1))
