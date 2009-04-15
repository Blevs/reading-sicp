(use srfi-42) ; 先行評価的内包表記

(define (!= x y) (not (= x y)))

;(define (distinct? items)
;  (cond [(null? items)  #t]
;	;	[(null? (cdr items)) #t]
;		[(member (car items) (cdr items)) #f]
;		[else (distinct? (cdr items))]
;		))

;(define (eight-queen? . positions)
;  #?=positions
;  )

;(map print
(list-ec (: ax 0 8) (: ay 0 8)

		 (: bx 0 8) (: by 0 8)
		 (and (!= bx ax)
			  (!= by ay)
			  (!= (+ bx by) (+ ax ay))
			  (!= (- bx by) (- ax ay))
			  )

		 (: cx 0 8) (: cy 0 8)
		 (and (!= cx bx) (!= cx ax)
			  (!= cy by) (!= cy ay)
			  (!= (+ cx cy) (+ bx by))
			  (!= (- cx cy) (- bx by))
			  (!= (+ cx cy) (+ ax ay))
			  (!= (- cx cy) (- ax ay))
			  )

		 (: dx 0 8) (: dy 0 8)
		 (and (!= dx cx) (!= dx bx) (!= dx ax)
			  (!= dy cy) (!= dy by) (!= dy ay)
			  (!= (+ dx dy) (+ cx cy))
			  (!= (- dx dy) (- cx cy))
			  (!= (+ dx dy) (+ bx by))
			  (!= (- dx dy) (- bx by))
			  (!= (+ dx dy) (+ ax ay))
			  (!= (- dx dy) (- ax ay))
			  )

		 (: ex 0 8) (: ey 0 8)
		 (and (!= ex dx) (!= ex cx) (!= ex bx) (!= ex ax)
			  (!= ey dy) (!= ey cy) (!= ey by) (!= ey ay)
			  (!= (+ ex ey) (+ dx dy))
			  (!= (- ex ey) (- dx dy))
			  (!= (+ ex ey) (+ cx cy))
			  (!= (- ex ey) (- cx cy))
			  (!= (+ ex ey) (+ bx by))
			  (!= (- ex ey) (- bx by))
			  (!= (+ ex ey) (+ ax ay))
			  (!= (- ex ey) (- ax ay))
			  )

		 (: fx 0 8) (: fy 0 8)
		 (and (!= fx ex) (!= fx dx) (!= fx cx) (!= fx bx) (!= fx ax)
			  (!= fy ey) (!= fy dy) (!= fy cy) (!= fy by) (!= fy ay)
			  (!= (+ fx fy) (+ ex ey))
			  (!= (- fx fy) (- ex ey))
			  (!= (+ fx fy) (+ dx dy))
			  (!= (- fx fy) (- dx dy))
			  (!= (+ fx fy) (+ cx cy))
			  (!= (- fx fy) (- cx cy))
			  (!= (+ fx fy) (+ bx by))
			  (!= (- fx fy) (- bx by))
			  (!= (+ fx fy) (+ ax ay))
			  (!= (- fx fy) (- ax ay))
			  )
		 (: gx 0 8) (: gy 0 8)
		 (and (!= gx fx) (!= gx ex) (!= gx dx) (!= gx cx) (!= gx bx) (!= gx ax)
			  (!= gy fy) (!= gy ey) (!= gy dy) (!= gy cy) (!= gy by) (!= gy ay)
			  (!= (+ gx gy) (+ fx fy))
			  (!= (- gx gy) (- fx fy))
			  (!= (+ gx gy) (+ ex ey))
			  (!= (- gx gy) (- ex ey))
			  (!= (+ gx gy) (+ dx dy))
			  (!= (- gx gy) (- dx dy))
			  (!= (+ gx gy) (+ cx cy))
			  (!= (- gx gy) (- cx cy))
			  (!= (+ gx gy) (+ bx by))
			  (!= (- gx gy) (- bx by))
			  (!= (+ gx gy) (+ ax ay))
			  (!= (- gx gy) (- ax ay))
			  )
		 (: hx 0 8) (: hy 0 8)
		 (and (!= hx gx) (!= hx fx) (!= hx ex) (!= hx dx) (!= hx cx) (!= hx bx) (!= hx ax)
			  (!= hy gy) (!= hy fy) (!= hy ey) (!= hy dy) (!= hy cy) (!= hy by) (!= hy ay)
			  (!= (+ hx hy) (+ gx gy))
			  (!= (- hx hy) (- gx gy))
			  (!= (+ hx hy) (+ fx fy))
			  (!= (- hx hy) (- fx fy))
			  (!= (+ hx hy) (+ ex ey))
			  (!= (- hx hy) (- ex ey))
			  (!= (+ hx hy) (+ dx dy))
			  (!= (- hx hy) (- dx dy))
			  (!= (+ hx hy) (+ cx cy))
			  (!= (- hx hy) (- cx cy))
			  (!= (+ hx hy) (+ bx by))
			  (!= (- hx hy) (- bx by))
			  (!= (+ hx hy) (+ ax ay))
			  (!= (- hx hy) (- ax ay))
			  )

;		 (if (distinct? (list ax bx cx dx ex fx gx hx)))
;		 (if (distinct? (list ay by cy dy ey fy gy hy)))

;		 (if (eight-queen? (list ax ay)
;						   (list bx by)
;						   (list cx cy)
;						   (list dx dy)
;						   (list ex ey)
;						   (list fx fy)
;						   (list gx gy)
;						   (list hx hy) ))

		 (print (list (list ax ay)
			   (list bx by)
			   (list cx cy)
			   (list dx dy)
			   (list ex ey)
			   (list fx fy)
			   (list gx gy)
			   (list hx hy))
				))