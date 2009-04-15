;(require "./stream")

(define (stream-map proc . argstreams) ; �����ϣ��İʾ�� stream
  (if (stream-null? (car argstreams)) ; �ǽ�� stream �����ʤ�<�����>
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams)) ; 1st's
       (apply stream-map
              (cons proc (map stream-cdr argstreams)))))) ; 2nd�ʹ�
; ���ϥ��ȥ꡼��� nth = ���ϳƥ��ȥ꡼��� nth �� proc �Ǳ黻�������

;test
;; (define s (stream-map sqrt))
;(define e (stream-map sqrt the-empty-stream))
;(define s (stream-map sqrt integers))
;(define t (stream-map + integers integers integers))
;(display-stream (stream-map sqrt integers))