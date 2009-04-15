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
  (define (iter x)
    (cond ((= (length x) 1) #f) ;;
        ;�ǽ�α黻�Ҥ� + �ʤ� false
          ((eq? (op1 x) '+) #t)
          ((eq? (op1 x) '*) (iter (cddr x)))
          (else #f)))
  (cond ((not (pair? x)) #f)
        ;�ǽ�α黻�Ҥ� + �ʤ� true
        ((eq? (op1 x) '+) #t)
        ;�ǽ�α黻�Ҥ� * �ʤ�Ƶ���
        ((eq? (op1 x) '*) (iter (cddr x)))
        (else #f)))

(define (product? x)
  (define (iter x)
    (cond ((= (length x) 1) #t) ;; '+ �˽в��ʤ��ä���硣
        ;�ǽ�α黻�Ҥ� + �ʤ� false
          ((eq? (op1 x) '+) #f)
          ((eq? (op1 x) '*) (iter (cddr x)))
          (else #f)))
  (cond ((not (pair? x)) #f) ;; ���ȥब�褿��硣
        ;�ǽ�α黻�Ҥ� + �ʤ� false
        ((eq? (op1 x) '+) #f)
        ((eq? (op1 x) '*) (iter (cddr x)))
        (else #f)))

(define (addend x)
  ; sum? = true.������ˤǤ���
  ;�ǽ�� '+ ���ڤ�
  (define (iter rest term)
    (if (eq? (car rest) '+)
        term
        (iter (cddr rest) (append term (list '* (cadr rest))))
        ))
;  (display "(addend ")
;  (display x)
;  (display ")") (newline)
  (strip (iter (cdr x) (list (car x)))))


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
