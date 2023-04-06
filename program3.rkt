#lang racket
(require data/functor)
(require data/either)
(require data/monad)
(require data/maybe)

;My stack is represented by a list where the first
;element is the bottom of the stack and the last item is the top.
;push item onto stack
(define (push cmd stack)
  (append stack (list cmd)))

;pop item off of stack
(define (pop stack)
  (drop-right stack 1))

;Operator functions, each one checks for enough operands
;if it doesn't have enough return a failure with the error message and stack
;else return the result of the operation in a success
(define (safe-add stack)
  (if (equal? (length stack) 1) (failure (list "ERROR: Not enough operands" stack))
  (let ([x (last stack)]
        [y (last (pop stack))])
        (success (+ x y)))))

(define (safe-subtract stack)
  (if (equal? (length stack) 1) (failure (list "ERROR: Not enough operands" stack))
  (let ([x (last stack)]
        [y (last (pop stack))])
        (success (- y x)))))

(define (safe-multiply stack)
  (if (equal? (length stack) 1) (failure (list "ERROR: Not enough operands" stack))
  (let ([x (last stack)]
        [y (last (pop stack))])
        (success (* x y)))))

;Checks for division by 0 as well as enough operands
(define (safe-div stack)
  (if (<= (length stack) 1) (failure (list "ERROR: not enough operands" stack))
  (let ([numerator (last (pop stack))]
        [denominator (last stack)])
    (cond
      [(equal? denominator 0) (failure (list "ERROR: division by 0" stack))]
      [else (success (/ numerator denominator))]))))

;Prints the current stack
(define (show stack)
  (display stack)
  (display "\n") stack)

;Prints the item at the top of the stack
(define (top stack)
  (display (last stack))
  (display "\n")
  stack)

;Prints the size of the stack
(define (size stack)
  (display (string-append (number->string (length stack)) "\n"))stack)

;Duplicate the top-most item on the stack
(define (duplicate stack)
  (push (last stack) stack))

;Exits the program and prints the error and the current stack
(define (end x)
  (display (first (from-failure #f x)))
  (display ", current stack: ")
  (show (second (from-failure #f x)))
  (exit 0))

;Checks if the operation was a failure, ends the function if so
;else pops the two operands from the stack and pushes the
;result of the operation onto the stack
(define (stack-bind f s)
  (if (failure? (f s))
      (end (f s))
      (push (from-success #f (f s)) (pop(pop s)))))

;Matches user input to the corresponding operation
;Fancy regex string is used to match digits from the user input
(define (get-input x stack)
  (cond
    [(equal? x "ADD")  (stack-bind safe-add stack)]
    [(equal? x "SUB")  (stack-bind safe-subtract stack)]
    [(equal? x "MUL")  (stack-bind safe-multiply stack)]
    [(equal? x "DIV")  (stack-bind safe-div stack)]
    [(equal? x "CLR")  '()]
    [(equal? x "SHOW") (show stack)]
    [(equal? x "TOP")  (top stack)]
    [(equal? x "SIZ")  (size stack)]
    [(equal? x "DUP")  (duplicate stack)]
    [(equal? x "END")  (end (failure (list "Program terminated" stack)))]
    [(regexp-match #px"[+-]?\\d+(\\.\\d+)?" x) (push (string->number x) stack)]
    [else (end (failure (list "Unknown command" stack)))]))

;Handles the user inputting multiple numbers or commands on the same line
(define (handle-input input stack)
  (if (equal? (length input) 1)
      (get-input (first input) stack)
      (handle-input (rest input) (get-input (first input) stack))))

;Reads in user input continuously
(define (stack-loop stack)
  (for ((_ (in-naturals)))
    (define l (read-line))
      (stack-loop (handle-input (string-split l) stack))))

;Starts the program with an empty stack
(stack-loop '())
