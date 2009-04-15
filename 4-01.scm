(require "./eval2")

;;orig
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

; testing cons... gauche�Ǥ� "ab" (�����鱦)
;(cons (display "a") (display "b"))
;(newline)

; �� �� ��
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((left-element (eval (first-operand exps) env)))
        (let ((right-element (list-of-values (rest-operands exps) env)))
          (cons left-element right-element)
          ))))
;
;((lambda (left)
;   ((lambda (right)
;      (cons left right)
;      ) <right>)
;   ) <left>)

; �� �� ��
;(define (list-of-values exps env)
;  (if (no-operands? exps)
;      '()
;      (let ((right-element (list-of-values (rest-operands exps) env)))
;        (let ((left-element (eval (first-operand exps) env)))
;          (cons left-element right-element)
;          ))))

;(define (operands exp)
;  (print "(operands " exp ") = " (cdr exp) ";")
;  (cdr exp))

;(define the-global-environment (setup-environment))

(driver-loop)
