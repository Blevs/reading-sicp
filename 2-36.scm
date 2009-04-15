(require "./lib")

; (accumulate-n + 0 '((1 2 3) (4 5 6) (7 8 9) (10 11 12))) => (22 26 30)
; = ((+ 1 4 7 10) (+ 2 5 8 11) (+ 3 6 9 12))

; (map car s) ��: (1 4 7 10), ������Ф��� op
; (map cdr s) ��: (2 3) (5 6) (8 9) (11 12)

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs))
            )))

(define s '((1 2 3) (4 5 6) (7 8 9) (10 11 12)))

(define (test-n s) (accumulate-n + 0 s))

