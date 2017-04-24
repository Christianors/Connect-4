(setq board '(((1 0 0 0 0 0 0) 1)((0 0 0 0 0 0 0) 0)((0 0 0 0 0 0 0) 0)((0 0 0 0 0 0 0) 0)
((0 0 0 0 0 0 0) 0)((0 0 0 0 0 0 0) 0)((0 0 0 0 0 0 0) 0)) )
 

(defun check4horizontal (estado)
    (setf ultima-ficha nil)
    (setf unos 0)
    (setf dos 0)
    (setf puntos-uno 0)
    (setf puntos-dos 0)
    (setf TwoInRow 0 OneInRow 0)
 
    (dotimes (i 6)
        (dolist (n estado)
            (case (nth i (car n))
                (0 (incf unos)(incf dos)(setf ultima-ficha 0))
                (1 (incf unos)(setf dos 0)(setf ultima-ficha 1))
                (2 (incf dos)(setf unos 0)(setf ultima-ficha 2)))
 
                (if (eq ultima-ficha 2)(incf TwoInRow)(setf TwoInRow 0))
                (if (eq ultima-ficha 1)(incf OneInRow)(setf OneInRow 0))
                (if (eq TwoInRow 4)(incf puntos-dos 100))
                (if (eq OneInRow 4)(incf puntos-uno 100))
 
 
 
                (cond 
                    ((and (> i 0) (eq 0 (nth i (car n))) (eq 0 (nth (- i 1) (car n)))) (setf unos 0) (setf dos 0)))
                (cond ((eq 4 unos) (incf puntos-uno) (decf unos)))
                (cond ((eq 4 dos) (incf puntos-dos) (decf dos)))
 
        )
        (setf unos 0 dos 0)
    )
(- puntos-dos puntos-uno))
 
(defun check4vertical (state)
	(setf ultima-ficha nil)
	(setf unos 0 dos 0)
	(setf i 0)
	(setf puntaje-uno 0 puntaje-dos 0)
	(setf OneInRow 0 TwoInRow 0)
 
	(dolist (n state)
		(loop 
		   (case (nth i (car n))
                (0 (incf unos)(incf dos)(setf ultima-ficha 0))
                (1 (incf unos)(setf dos 0)(setf ultima-ficha 1))
                (2 (incf dos)(setf unos 0)(setf ultima-ficha 2)))
 
            (if (eq ultima-ficha 2)(incf TwoInRow)(setf TwoInRow 0))
            (if (eq ultima-ficha 1)(incf OneInRow)(setf OneInRow 0))
 
            (incf i)
            (when (or (> i 5) (eq 4 unos) (eq dos 4)) (return (setf i 0)))
		)
 
		(if (eq unos 4) (incf puntaje-uno))
		(if (eq dos 4) (incf puntaje-dos))
		(if (eq TwoInRow 4)(incf puntaje-dos 1000))
        (if (eq OneInRow 4)(incf puntaje-uno 1000))
		(setf unos 0 dos 0)
	)
(- puntaje-dos puntaje-uno))

(defun valor-nodo (estado)
(+ (check4vertical estado) (check4horizontal estado)))
 

(defun tira-en (columna board)
	(setf (nth (cadr (nth columna board)) (car (nth columna board))) 2)
	(incf (cadr (nth columna board)))
)


(defun insert-at-n (n lst elem)
(cond
((null lst)(list elem))
((zerop n) (cons elem (cdr lst)))
((not(minusp n)) (cons (car lst)
(insert-at-n (1- n)(cdr lst) elem)))
(T (write "error"))))


(defun genera-hijos (board ficha hijos)

    (dotimes (n 7)
    	(cond ((< (cadr (nth n board)) 7)(setf hijo (insert-at-n (cadr (nth n board)) (car (nth n board)) ficha))
    	(setq hijo-wrap '())
    	(push hijo hijo-wrap)
    	(push (+ 1 (cadr (nth n board))) hijo-wrap)
    	(push (insert-at-n n board (reverse hijo-wrap)) hijos))
    	(t (push nil hijos))))
    
hijos)

(setf move nil)
(setf columna-tiro-chido nil)
(setf i 0)
(defun alfa-beta (estado depth maximizer alfa beta time)
    
	(if (eq depth 0)
		(return-from alfa-beta (valor-nodo estado)))
		
	(cond ((= maximizer 1)
		(setf val -1000000)
		(setq hijos '())
		
		(dolist (n (genera-hijos estado 2 hijos))
			
			(setf val (max (alfa-beta n (- depth 1) 0 alfa beta (+ time 1)) val))
			(cond ((> val alfa) (setf alfa (max alfa val))(cond ((= time 1)(setf columna-tiro-chido i)(setf move n)))))
			(if (= time 1)(incf i))
			(if (> alfa beta)(return))
			
		)(return-from alfa-beta val))
	)
	(cond ((= maximizer 0)
		(setf val 1000000)
		(setf hijos '())
		(dolist (n (genera-hijos estado 1 hijos))
			
			(setf val (min (alfa-beta n (- depth 1) 1 alfa beta (+ time 1)) val))
			(setf beta (min beta val))
			(if (> alfa beta)(return))
			
		)(return-from alfa-beta val))
	)	
)

(defun find-column (list1 list2)
	(dotimes (n 7)
		(if (not (equal (nth n list1) (nth n list2)))(setq columna n))
	)
columna)

(print (alfa-beta board 10 1 -1000000 1000000 1))
(print move)
(print (find-column board move))
