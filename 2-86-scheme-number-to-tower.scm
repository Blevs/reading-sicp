scheme-number ������Ȥ߹��ߤ�������scheme-number �Ϥ���餹�٤Ƥ����񤷤Ƥ���Τ����

�Ȥꤢ������scheme-number �ˡ������Ŭ�ڤʷ���Ĥ���ؿ����롣
>||
(define (scheme-number->tower x)
  (cond ((fixnum? x)   (make-integer x))
        ((flonum? x)   (make-real x))
        ((rational? x) (attach-tag 'rational (get-nearest-rational x)))
        ((complex? x) (make-complex-from-real-imag (real-part x) (imag-part x)))
                         ; real-part, imag-part �� R5RS �Τ��
        (else (error "unknown type -- SCHEME-NUMBER->TOWER" x))))
||<
�ȹԤ������Ȥ��������Gauche �Ǥ�ͭ���������ݡ��Ȥ���Ƥ��ʤ��Τ�
>||
(define (scheme-number->tower x)
  (cond ((fixnum? x) (make-integer x))
        ((flonum? x)  ;; Gauche��
         (let ((nearest-rational (get-nearest-rational x)))
           (if (< (cdr nearest-rational) 1000)
               (attach-tag 'rational nearest-rational)
               (attach-tag 'real x))))
        ((complex? x) (make-complex-from-real-imag (real-part x) (imag-part x)))
                         ; real-part, imag-part �� R5RS �Τ��
        (else (error "unknown type -- SCHEME-NUMBER->TOWER" x))))
||<
��real-part, imag-part �� R5RS �Ȥ��֤äƤ���ΤǤ����ǤϻȤ��ʤ���
>||
gosh> (scheme-number->tower 1)
(integer . 1)
gosh> (scheme-number->tower 1/3)
(rational 1.0 . 3)
gosh> (scheme-number->tower 2/4)
(rational 1.0 . 2)
gosh> (scheme-number->tower 1.5) ;; 
(rational 3.0 . 2)
gosh> (scheme-number->tower 1.42857)
(rational 10.0 . 7)
gosh> (scheme-number->tower 3.14159)
(real . 3.14159)
||<
����ʶ�硣
