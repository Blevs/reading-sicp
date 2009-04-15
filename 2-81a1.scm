(require "./c252")

(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)
(put-coercion 'scheme-number 'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

;;a
(define (exp x y) (apply-generic 'exp x y))

(put 'exp '(scheme-number scheme-number)
     (lambda (x y) (expt x y)))
;     (lambda (x y) (tag (expt x y))))

(exp 3 3) ; 27
(exp 2 10) ; 1024

(define z (make-complex-from-real-imag 1 2))
;(exp z z) ; loop
;(exp z 2) ; loop
;(exp 2 z) ; loop

;; 'exp '(complex *) (* complex) �ξ��
; scm scm (expt)
; scm cpx (�ʤ�!) --> ͭ(scm->cpx) ��(cpx->scm) ; cpx,cpx
; cpx scm (�ʤ�!) --> ��(cpx->scm) ͭ(scm->cpx) ; cpx,cpx
; cpx cpx (�ʤ�!) --> ��(cpx->cpx) ��(cpx->cpx)
; (b)��������Ʊ�����ʤ顢�ɤ����ʤˤ��Ѥ��ʤ��ΤǤ��ΤޤޤǤ���
;�ʤ��Ǥ˻���Ȥ߹�碌�򤵤�ˣ���Ƶ����ƻ���Ƶ���Ǥ�Ʊ�ͤʤΤ�̵�¤˽����ʤ���
; (c)��������Ʊ�����ʤ� coercion ���ߤʤ��ǡʢ�Ʊ���Ȥ߹�碌�����ʤ�����ˡ���
