(define (tagged-list? exp tag)
  (if (pair? exp)
	  (eq? (car exp) tag)
	  #f))
;;
;;��5.2 �쥸�����׻������ߥ�졼��
;;

;��5.2.1 �׻�����ǥ�
;(make-machine <�쥸����̾�ꥹ��> <�黻�ҥꥹ��> <�����>)
(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
	(for-each (lambda (register-name)
				((machine 'allocate-register) register-name))
			  register-names)
	((machine 'install-operations) ops)
	((machine 'install-instruction-sequence)
	 (assemble controller-text machine))
	machine))

;�쥸����
(define (make-register name)
  (let ((contents '*unassigned*)
		(trace-mode 'off))
	(define (dispatch message)
	  (cond ((eq? message 'get) contents)
			((eq? message 'set)
			 (lambda (value)
			   (if (eq? trace-mode 'on)
				   (print (format "[~a] ~a => ~a" name contents value))
				   '*trace-off*)
			   (set! contents value)
			   ))
			((eq? message 'trace-on) (set! trace-mode 'on))
			((eq? message 'trace-off) (set! trace-mode 'off))
			(else
			 (error "Unknown request -- REGISTER" message))))
	dispatch))

(define (get-contents register)
  (register 'get))

(define (set-contents! register value)
  ((register 'set) value))

;�����å�
(define (make-stack)
  (let ((s '())
		(number-pushes 0)
		(max-depth 0)
		(current-depth 0))
	(define (push x)
	  (set! s (cons x s))
	  (set! number-pushes (+ 1 number-pushes))
	  (set! current-depth (+ 1 current-depth))
	  (set! max-depth (max current-depth max-depth)))
	(define (pop)
	  (if (null? s)
		  (error "Empty stack -- POP")
		  (let ((top (car s)))
			(set! s (cdr s))
			(set! current-depth (- current-depth 1))
			top)))
	(define (initialize)
;	  (print "STACK: initialize")
	  (set! s '())
	  (set! number-pushes 0)
	  (set! max-depth 0)
	  (set! current-depth 0)
	  'done)
	(define (print-statistics)
;	  (print "STACK: print statistics")
;	  (newline)
;	  (display (list 'total-pushes  '= number-pushes
;					 'maximum-depth '= max-depth)))
	  (print (format ">>\t(total-pushes = ~d maximum-depth = ~d)" number-pushes max-depth)))
	(define (dispatch message)
	  (cond ((eq? message 'push) push)
			((eq? message 'pop) (pop))
			((eq? message 'initialize) (initialize))
			((eq? message 'print-statistics)
			 (print-statistics))
			(else (error "Unknown request -- STACK" message))))
	dispatch))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

;���ܷ׻���
(define (make-new-machine)
  (let ((pc (make-register 'pc))
		(flag (make-register 'flag))
		(instruction-count 0) ; 5.15
		(trace-mode 'off) ; 5.16
		(stack (make-stack))
		(the-instruction-sequence '()))
	(let ((the-ops
		   (list (list 'initialize-stack
					   (lambda () (stack 'initialize)))
				 (list 'print-stack-statistics
					   (lambda () (stack 'print-statistics)))
				 (list 'reset-instruction-count
					   (lambda () (set! instruction-count 0)))
				 (list 'print-instruction-count
					   (lambda () (print (format ">>\t(instruction-count ~d)" instruction-count))))
				 (list 'trace-on
					   (lambda () (set! trace-mode 'on)))
				 (list 'trace-off
					   (lambda () (set! trace-mode 'off)))
;				 (list 'reg-trace-on
;					   (lambda (reg) (print reg) (reg 'trace-on)))
;				 (list 'reg-trace-off
;					   (lambda (reg) (print reg) (reg 'trace-off)))
				 ))
		  (register-table
		   (list (list 'pc pc) (list 'flag flag))))
	  (define (allocate-register name)
		(if (assoc name register-table)
			(error "Multiply defined register: " name)
			(set! register-table
				  (cons (list name (make-register name))
						register-table)))
		'register-allocated)
	  (define (lookup-register name)
		(let ((val (assoc name register-table)))
		  (if val
			  (cadr val)
			  (error "Unknown register:" name))))
	  ;5.15
	  (define (reset-instruction-count)
		(set! instruction-count 0))
	  (define (increment-instruction-count)
		(set! instruction-count (+ 1 instruction-count)))

	  (define (execute)
		(let ((insts (get-contents pc)))
		  (if (null? insts)
			  'done
			  (begin
				(if (eq? trace-mode 'on)
					(print 
					 (if (instruction-label (car insts))
						 (format "~a:\n" (instruction-label (car insts)))
						 "")
					 (format "   ~a" (instruction-text (car insts))))
					'*trace-off*)
				((instruction-execution-proc (car insts)))
				(increment-instruction-count)
				(execute)))))
	  (define (dispatch message)
		(cond ((eq? message 'start)
			   (set-contents! pc the-instruction-sequence)
			   (execute))
			  ((eq? message 'install-instruction-sequence)
			   (lambda (seq) (set! the-instruction-sequence seq)))
			  ((eq? message 'allocate-register) allocate-register)
			  ((eq? message 'get-register) lookup-register)
			  ((eq? message 'install-operations)
			   (lambda (ops) (set! the-ops (append the-ops ops))))
			  ((eq? message 'stack) stack)
			  ((eq? message 'operations) the-ops)
;5.15
			  ((eq? message 'reset-instruction-count) (reset-instruction-count))
			  ((eq? message 'increment-instruction-count) (increment-instruction-count))

			  (else (error "Unknown request -- MACHINE" message))))
	  dispatch)))

;(start <������ǥ�>)
(define (start machine)
  (machine 'start))

;(get-register-contents <������ǥ�> <�쥸����̾>)
(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))

;(set-register-contents! <������ǥ�> <�쥸����̾> <��>)
(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name) value))

(define (get-register machine reg-name)
  ((machine 'get-register) reg-name))

;[p.311]
(define (assemble controller-text machine)
  (extract-labels controller-text
				  (lambda (insts labels)
					(update-insts! insts labels machine)
					insts)
				  #f))

(define (extract-labels text receive last-inst) ;; (receive insts labels)
  (if (null? text)
	  (receive '() '())
	  (let ((next-inst (car text)))
		(extract-labels (cdr text)
						(lambda (insts labels)
						  (if (symbol? next-inst) ; if label
							  (receive insts
									   (cons (make-label-entry next-inst
															   insts)
											 labels))
							  (receive (cons (make-instruction next-inst
															   last-inst)
											 insts)
									   labels)))
						(if (symbol? next-inst) next-inst #f)))
	  ))

;[p.312]
(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
		(flag (get-register machine 'flag))
		(stack (machine 'stack))
		(ops (machine 'operations)))
	(for-each
	 (lambda (inst)
	   (set-instruction-execution-proc!
		inst
		(make-execution-procedure
		 (instruction-text inst) labels machine
		 pc flag stack ops))
;	   (set-instruction-label!
;		inst
;		'xxx)
	   )
	 insts)))

(define (make-instruction text label)
  (list text '() label))				;  (cons text '()))

(define (instruction-text inst)
  (car inst))

(define (instruction-execution-proc inst)
  (cadr inst))

(define (instruction-label inst) ; optional
  (caddr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-car! (cdr inst) proc))

(define (set-instruction-label! inst label)
  (set-car! (cddr inst) label))

(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
	(if val
		(cdr val)
		(error "Undefined label -- ASSEMBLE" label-name))))

;��5.2.3 ̿��μ¹Լ�³��������
(define (make-execution-procedure inst labels machine
								  pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
		 (make-assign inst machine labels ops pc))
		((eq? (car inst) 'test)
		 (make-test inst machine labels ops flag pc))
		((eq? (car inst) 'branch)
		 (make-branch inst machine labels flag pc))
		((eq? (car inst) 'goto)
		 (make-goto inst machine labels pc))
		((eq? (car inst) 'save)
		 (make-save inst machine stack pc))
		((eq? (car inst) 'restore)
		 (make-restore inst machine stack pc))
		((eq? (car inst) 'perform)
		 (make-perform inst machine labels ops pc))
		((eq? (car inst) 'reg-trace-on)
		 (make-register-trace-on inst machine pc))
		((eq? (car inst) 'reg-trace-off)
		 (make-register-trace-off inst machine pc))
		(else (error "Unknown instruction type -- ASSEMBLE"
					 inst))))

; assign̿��
(define (make-assign inst machine labels operations pc)
  (let ((target
		 (get-register machine (assign-reg-name inst)))
		(value-exp (assign-value-exp inst)))
	(let ((value-proc
		   (if (operation-exp? value-exp)
			   (make-operation-exp
				value-exp machine labels operations)
			   (make-primitive-exp
				(car value-exp) machine labels))))
	  (lambda ()
		(set-contents! target (value-proc))
		(advance-pc pc)))))

(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))

(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

;
(define (make-register-trace-on inst machine pc)
  (let ((register (get-register machine (register-trace-reg-name inst))))
	(lambda ()
	  (register 'trace-on)
	  (advance-pc pc))))

(define (make-register-trace-off inst machine pc)
  (let ((register (get-register machine (register-trace-reg-name inst))))
	(lambda ()
	  (register 'trace-off)
	  (advance-pc pc))))

(define (register-trace-reg-name inst)
  (cadr inst))

; test, branch, goto
(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
	(if (operation-exp? condition)
		(let ((condition-proc
			   (make-operation-exp
				condition machine labels operations)))
		  (lambda ()
			(set-contents! flag (condition-proc))
			(advance-pc pc)))
		(error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (test-condition test-instruction)
  (cdr test-instruction))

;
(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
	(if (label-exp? dest)
		(let ((insts
			   (lookup-label labels (label-exp-label dest))))
		  (lambda ()
			(if (get-contents flag)
				(set-contents! pc insts)
				(advance-pc pc))))
		(error "Bad BRANCH instruction -- ASSEMBLE" inst))))

(define (branch-dest branch-instruction)
  (cadr branch-instruction))

;[p.315]
(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
	(cond ((label-exp? dest)
		   (let ((insts
				  (lookup-label labels
								(label-exp-label dest))))
			 (lambda () (set-contents! pc insts))))
		  ((register-exp? dest)
		   (let ((reg
				  (get-register machine
								(register-exp-reg dest))))
			 (lambda ()
			   (set-contents! pc (get-contents reg)))))
		  (else (error "Bad GOTO instruction -- ASSEMBLE"
					   inst)))))

(define (goto-dest goto-instruction)
  (cadr goto-instruction))

; ����¾��̿��
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
						   (stack-inst-reg-name inst))))
	(lambda ()
	  (push stack (get-contents reg))
	  (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
						   (stack-inst-reg-name inst))))
	(lambda ()
	  (set-contents! reg (pop stack))
	  (advance-pc pc))))

(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

;
(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
	(if (operation-exp? action)
		(let ((action-proc
			   (make-operation-exp
				action machine labels operations)))
		  (lambda ()
			(action-proc)
			(advance-pc pc)))
		(error "Bad PERFORM instruction -- ASSEMBLE" inst))))

(define (perform-action inst) (cdr inst))

; ��ʬ���μ¹Լ�³��
(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
		 (let ((c (constant-exp-value exp)))
		   (lambda () c)))
		((label-exp? exp)
		 (let ((insts
				(lookup-label labels
							  (label-exp-label exp))))
		   (lambda () insts)))
		((register-exp? exp)
		 (let ((r (get-register machine
								(register-exp-reg exp))))
		   (lambda () (get-contents r))))
		(else
		 (error "Unknown expression type -- ASSEMBLE" exp))))

(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))

(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
		(aprocs
		 (map (lambda (e)
				(make-primitive-exp e machine labels))
			  (operation-exp-operands exp))))
	(lambda ()
	  (apply op (map (lambda (p) (p)) aprocs)))))

(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))

(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))

(define (operation-exp-operands operation-exp)
  (cdr operation-exp))

;[p.317]
(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
	(if val
		(cadr val)
		(error "Unknown operation -- ASSEMBLE" symbol))))

