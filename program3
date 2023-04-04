#lang racket
(require data/functor)
(require data/either)
(require data/monad)
(require data/maybe)

(define (blah z)
  (display "blah called"))

(define (push cmd stack)
  (append stack (list cmd)))

(define (pop stack)
  (drop-right stack 1))

(define (show stack)
  (for-each (lambda (x) (printf "~a " (from-just #f x))) stack)stack)

(define (top stack)
  (display (last stack))
  stack)

(define (size stack)
  (define (iter stack count)
    (if (empty? stack) (display count)
    (let ([item (first stack)])
      (cond
        [(number? item) (iter (rest stack) (+ count 1))]
        [else (iter (rest stack) count)]))))
  (iter stack 0) stack)

(define (duplicate stack)
  (push (last stack) stack))

(define (safe-add stack)
  (let ([x (from-just #f (last stack))]
        [y (from-just #f (last (pop stack)))])
        (push (just (+ x y)) (pop (pop stack)))))
        
(define (safe-div stack)
  (if (equal? (length stack) 1) (end "ERROR: Not enough operands, " stack)
  (let ([numerator (from-just   #f (last stack))]
        [denominator (from-just #f (last (pop stack)))])
   (if (= denominator 0)
     (end "ERROR: division by 0 " stack)
     (push (just (/ numerator denominator)) (pop (pop stack))) ))))

;(define (safe-div stack)
 ; (do [numerator <- (last stack)]
     ; [denominator <- (last (pop stack))]
  ;   (display (+ numerator 7)) stack))
    
  
(define (end message stack)
  (display message)
  (show stack)
  (exit 0))

(define (get-input x stack)
  (cond
    [(equal? x "ADD")  (safe-add stack)]
    [(equal? x "SUB")  (blah x)]
    [(equal? x "MUL")  (blah x)]
    [(equal? x "DIV")  (safe-div stack)]
    [(equal? x "CLR")  '()]
    [(equal? x "SHOW") (show stack)]
    [(equal? x "TOP")  (top stack)]
    [(equal? x "SIZ")  (size stack)]
    [(equal? x "DUP")  (duplicate stack)]
    [(equal? x "END")  (end "Program terminated, " stack)]
    [(regexp-match #px"[+-]?\\d+(\\.\\d+)?" x) (push (just (string->number x)) stack)]
    [else (end "Unknown command, " stack)]))

(define (handle-input input stack)
  (if (equal? (length input) 1)
      (get-input (first input) stack)
      (handle-input (rest input) (get-input (first input) stack))))
        
(define (stack-loop stack)
  (for ((_ (in-naturals)))
    (define l (read-line))
      (stack-loop (handle-input (string-split l) stack))))

(stack-loop '())
