(require "./232deriv")

;(define (make-sum a1 a2) (list a1 '+ a2))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))));;;

;(define (make-product m1 m2) (list m1 '* m2))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))));;;

(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))

;(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))

;(define (multiplicand p) (caddr p))
;;;;


(define (op1 x) (cadr x))

(define (simple-term? x)
  (and (pair? x) (null? (cdr x))))

(define (strip x)
  (if (simple-term? x)
      (strip (car x))
      x))
 
(define (sum? x)
  (if (not (pair? x)) ;�ꥹ�ȤǤϤʤ��ʤ� false
      #f
      (memq '+ x))) ; �ꥹ�Ȥʤ顢+ ���ޤޤ�Ƥ���� true
(define (product? x)
  (if (not (pair? x)) ;�ꥹ�ȤǤϤʤ��ʤ� false
      #f
      (not (memq '+ x)))) ; �ꥹ�Ȥʤ顢+ ���ޤޤ�Ƥ���� false

(define (before-item item x)
  (define (iter rest result)
    (cond ((null? rest) x)
          ((eq? (car rest) item) (reverse result))
          (else (iter (cdr rest) (cons (car rest) result)))))
  (iter x '()))

(define (addend x)
  ; sum? = true.������ˤǤ���
  ;�ǽ�� '+ ���ڤ�
  (strip (before-item '+ x)))

(define (augend x)
  ; sum? = true.������ˤǤ���
  ;�ǽ�� '+ ���ڤ�
  (strip (cdr (memq '+ x))))

(define (multiplier x)
  ; product? = true. ������ˤǤ��� :: ���٤� * �ǽ���Ƥ���
  ; �Ȥ������ȤϾö˺��Ǥ��������
  (car x))

(define (multiplicand x)
  (strip (cddr x)))

(define t '(x + 3 * (x + y + 2))) ; x + 3(x+y+2) = 4x + 3y + 6
(define s '(x * x * x + x * x + x + 1)) ; x^3 + x^2 + x + 1
