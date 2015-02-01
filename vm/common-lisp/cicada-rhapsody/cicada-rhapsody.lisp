(in-package :cicada-vm)
(defparameter *buffer#cicada-rhapsody#in-line*
  (make#string :length (mul 1024 1024)))

(defparameter *pointer#buffer#cicada-rhapsody#in-line* 0)

(defparameter *bar-ket#square#level-counter* 1)


(defun cicada-rhapsody#in-line (stream the-char)
  (set! *pointer#buffer#cicada-rhapsody#in-line* 0)
  (set! *bar-ket#square#level-counter* 1)
  (let* ((string
          (help#read-string#cicada-rhapsody#in-line stream))
         (list#word
          (string->list#word string))
         (compiler
          (help#get-compiler#cicada-rhapsody#in-line list#word)))
    `(funcall ,compiler ,string)))


(defun help#get-compiler#cicada-rhapsody#in-line (list#word)
  (cond
    ((<= (length list#word) 3)
     (error (cat ()
              ("(help#get-compiler#cicada-rhapsody#in-line)")
              ("the number of words in the string must be greater than 3"))))
    ((not (equal? (car list#word) "(:"))
     (error (cat ()
              ("(help#get-compiler#cicada-rhapsody#in-line)")
              ("the head of the string must be an open smiling face (:"))))
    (:else
     (let ((compiler (string->function (cadr list#word))))
       (if (function? compiler)
           compiler
           (error (cat ()
                    ("(help#get-compiler#cicada-rhapsody#in-line)")
                    ("the string: ~A is not a function name" (cadr list#word)))))))))


(defun help#read-string#cicada-rhapsody#in-line (stream)
  (let ((char (read#char :from stream
                         :eof-as-error? false
                         :read-eof-as 'eof
                         :recursive-call-to-reader? t)))
    (cond
      ((equal? char *bar#square#char*)
       (add1! *bar-ket#square#level-counter*)
       (save#string
        :value char
        :string *buffer#cicada-rhapsody#in-line*
        :index *pointer#buffer#cicada-rhapsody#in-line*)
       (add1! *pointer#buffer#cicada-rhapsody#in-line*)
       (help#read-string#cicada-rhapsody#in-line stream))

      ((equal? char 'eof)
       (error (cat (:postfix (cat () ("~%")))
                ("when calling (cicada-rhapsody#in-line)")
                ("too less ket#square")
                ("bar-ket#square#level = ~S" *bar-ket#square#level-counter*))))

      ((equal? char *ket#square#char*)
       (if (one? *bar-ket#square#level-counter*)
           (make#sub-string
            :string *buffer#cicada-rhapsody#in-line*
            :start 0
            :end *pointer#buffer#cicada-rhapsody#in-line*)
           (progn
             (sub1! *bar-ket#square#level-counter*)
             (save#string
              :value char
              :string *buffer#cicada-rhapsody#in-line*
              :index *pointer#buffer#cicada-rhapsody#in-line*)
             (add1! *pointer#buffer#cicada-rhapsody#in-line*)
             (help#read-string#cicada-rhapsody#in-line stream))))

      (:else
       (save#string
        :value char
        :string *buffer#cicada-rhapsody#in-line*
        :index *pointer#buffer#cicada-rhapsody#in-line*)
       (add1! *pointer#buffer#cicada-rhapsody#in-line*)
       (help#read-string#cicada-rhapsody#in-line stream))
      )))

(bind-char-to-reader :char *bar#square#char*
                     :reader (function cicada-rhapsody#in-line))

