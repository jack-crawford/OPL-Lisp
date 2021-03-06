;;;; -*- Mode: Lisp; -*- 
;;;; Team Members: Shiyu (Jenny) Su, Jack Crawford, Sarah 
;;;;
;;;;
;;;; Submission Deadline: Sunday, December 8, 11:59:59pm
;;;; Report Deadline: Monday, December 9, 11:59:59pm
;;;; 
;;;; Please submit your code as a .lisp file in Blackboard.
;;;;
;;;;



;;;HELPFUL TOPLEVEL HINTS:

;;; To run your program, first load it into the LispWorks Editor,
;;; then click on the "Compile Buffer" button on the top of the
;;; Editor window.  Then, in the LISTENER, you can call any of
;;; the functions in the program file.
;;;
;;; If you find yourself in an error, and you want to know how
;;; you got to that point in the program, when the textual debugger
;;; message appears, you can click on the "Debug" button at the
;;; top of the LISTENER window.  You'll get a GUI debugger that
;;; will show you things like the call stack, the values of the
;;; local variables, and, if you click on a call stack entry,
;;; if the entry corresponds to a function in your program, the
;;; Editor will immediately jump you to the line of code where
;;; the error occured.  Ask in class if you have trouble with
;;; this neat feature. 


;;;HELPFUL PROGRAMMING HINTS:
;;; To create a person structure, use the automatically-generated
;;; function "make-person" as follows:
;;;
;;; (make-person :name xxx :parent1 yyy :parent2 zzz)
;;;
;;; where "xxx" is the string or symbol (or a variable holding it)
;;; for the name of the person, "yyy" is the string or symbol for
;;; the name of the person's first parent, and "zzz" is of course
;;; the name of the person's second parent.
;;;
;;; for example, to store a new person in a variable p, use this:
;;;
;;; (SETF p (make-person :name "Barbara" :parent1 "Fred" :parent2 "Carol"))
;;;
;;;

;;; The DEFSTRUCT function tells Lisp to autmatically create
;;; getter functions for each slot.  Their names are based on
;;; the names of the slots:
;;;
;;;  "person-name" will get the value stored in the NAME slot
;;;  "person-parent1" will get the value in the PARENT1 slot
;;;

;;; The LOOP function (macro) is used to iterate in many ways.
;;; Here are some examples:
;;;
;;; (LET ((newlist nil)
;;;       (mylist (LIST 1 2 3 4 5 6 7 8)))
;;;   (LOOP for i in mylist DOING
;;;     (SETF newlist (APPEND newlist (LIST (+ i 1)))))
;;;   newlist)
;;;
;;;  The above will make a new list that contains
;;;  numbers that are one more than their corresponding
;;;  elements in mylist.  Notice that the new sum is added
;;;  at the END of the growing new list!
;;;  This could also be done more elegantly in Lisp using
;;;  a nameless lambda function
;;;
;;;  (LET ((mylist (LIST 1 2 3 4 5 6 7 8)))
;;;    (MAPCAR #'(lambda (x) (+ x 1)) mylist))
;;;
;;; MAPCAR applies its first argument (a function) to each
;;; element in the second argument (a list), and collects
;;; the results of all the function calls into a new list
;;; and returns that list.
;;;
;;; Here is another LOOP example that does the same thing:
;;;
;;; (LET ((mylist (LIST 1 2 3 4 5 6 7 8)))
;;;  (LOOP for x in mylist collecting
;;;     (+ x 1)))
;;;


;;;-------------------------------
;;;PROJECT CODE STARTS HERE.
;;;-------------------------------

(DEFSTRUCT (person
            (:print-function print-person))
  (parent1 NIL) ; a symbol or string or NIL
  (parent2 NIL) ; a symbol or string or NIL
  (name NIL)
  (children nil); a list or nil
)   ; a symbol or string or NIL


;;If you want to add more slots to the person
;;structure (say, children or spouse), use
;;the same syntax as you see above for the slots
;;to add them to the above definition.
;;It is likely that if you add a "children" slot,
;;it will hold a list or array of children names
;;rather than a single atom.



;;NOTE: This function is complete, no need to change it unless you
;;want to update it to show other slots you add to the person struct
;;definition.
(DEFUN print-person (item stream depth)
  "A helper function for Lispworks to be able to show you what is
in a person structure concisely."
    (DECLARE (IGNORE depth))
    (FORMAT stream "#<P name:~S p1:~S p2:~S>"
            (person-name item) (person-parent1 item) (person-parent2 item))
    item)


;;;NOTE: This function is complete. No need to change it.
(DEFUN lookup-person (name tree)
  "Returns a PERSON structure corresponding to the key NAME in the hashtable TREE.
NAME must be a STRING or a SYMBOL. If there is no one in the tree with the name
in NAME, returns NIL."
  (GETHASH name tree nil))


;;;NOTE: This function is complete. No need to change it.
(DEFUN person-exists (name tree)
  "Returns T when the key NAME has an actual person struct stored in TREE.
Returns NIL (false) otherwise."
  (WHEN (lookup-person name tree)
    t))


;;;NOTE: This function is complete. No need to change it.
(DEFUN ancestors (name tree)
  "Returns a list of names (strings or symbols) of all the ancestors of NAME in TREE. 
Does not remove any duplicated names! Does not sort names! Does dynamic type checking
to see whether all the arguments are of the correct types."
  (WHEN (NOT (OR (SYMBOLP name) (STRINGP name)))
    (ERROR "ANCESTORS called with NAME (~A) that is not a SYMBOL or STRING." name))
  (WHEN (NOT (HASH-TABLE-P tree))
    (ERROR "ANCESTORS called with TREE (~A) that is not a HASH-TABLE." tree))
  (WHEN (person-exists name tree)
    (remove-duplicates (sort (ancestorsb name tree) #'string<=) :test #'equal)))





;;;------------------------------------------------
;;; TEAM SHOULD PUT ALL NEW HELPER FUNCTION
;;; DEFINITIONS BELOW THIS COMMENT
;;;------------------------------------------------ 






(DEFUN add-person (name struct tree)
  "This should enter the person structure in STRUCT into
the hashtable in TREE with the key in NAME."
  (WHEN (NOT (HASH-TABLE-P tree))
    (ERROR "STORE-PERSON called with TREE (~A) that is not a HASH-TABLE." tree))
  (WHEN (NOT (person-p struct))
    (ERROR "STORE-PERSON called with STRUCT (~A) that is not a PERSON structure." struct))
  (WHEN (NOT (OR (SYMBOLP name) (STRINGP name)))
    (ERROR "STORE-PERSON called with NAME (~A) that is not a SYMBOL or a STRING." name))
  ;; NOTE1: TEAMS NEED TO WRITE THE NEXT LINE.
  ;;        Hint: a "setf" expression.
  (setf (gethash name tree)struct)

  ;; NOTE2: Leave this last line as "name" so
  ;;        that the name argument is what is
  ;;        returned by this function.
  name)


(DEFUN getChildren (n1 FamilyTree)
     (remove-duplicates (sort(person-children (lookup-person n1 FamilyTree))#'string<=) :test #'equal) 
)

;;This function needs to be defined by your team.
(DEFUN ancestorsb (name tree)
  "A helper function for the ANCESTORS function. 
Returns a list of names (strings or symbols) of all the ancestors of NAME in TREE. 
Does not remove any duplicated names! Does not sort names! Does not check if NAME 
exists as a person in the TREE!"
  (LET* ((p (lookup-person name tree))
         (parent1 (person-parent1 p))
         (parent2 (person-parent2 p)))
    ;;body of function goes here.
    (when parent1
       (append (list parent1 parent2)
               (ancestorsb parent1 tree)
               (ancestorsb parent2 tree)))))

;get the generation level difference between an ancestor(a) and a descendent(d)
(DEFUN getGenGap (na nd genGap tree)
  (LET* ((pd (lookup-person nd tree)))
         ;(pa (lookup-person na tree))
    ;(When (not pd)
      ;(setf genGap 10000))
    (when pd
      (LET ((parent1 (person-parent1 pd))
            (parent2 (person-parent2 pd)))
        (WHEN (not parent1)
          (setf genGap 10000))
        (WHEN parent1
          (IF (or (equal na parent1)(equal na parent2))
              (setf genGap (+ gengap 1))       
            (setf genGap (min (getGenGap na parent1 (+ genGap 1) tree) (getGenGap na parent2 (+ genGap 1) tree)))
          ;(+ genGap (getGenGap na parent2 (+ genGap 1) tree)))
            )))))
  ;(setf genGap (+ genGap 1))
  genGap)

        
(DEFUN getCommAnc (n1 n2 tree)
  
  (LET* ((anc1 (ancestors n1 tree))
        (anc2 (ancestors n2 tree))
        (commAnc (list)))
    ;(format t "~a~%" anc1)
    ;(format t "~a~%" anc2)
    ;(loop for x in anc2 do (format t "~a~%" x))
    (loop for x in anc2
          do (if (member x anc1 :test #'EQUAL) (push x commAnc)))
  ;(format t "~a~%" commAnc
 commAnc))


(DEFUN getSibs(n1 tree)
  
  (LET* ((p (lookup-person n1 tree))
         (parent1 (person-parent1 p))
         (parent2 (person-parent2 p))
         (siblings (list))
         (childrenParent1 (getChildren parent1 tree))
         (childrenParent2 (getChildren parent2 tree))
         )
       (loop for x in childrenParent1
             do (if(and (not (member x siblings :test #'EQUAL)) (not(equal x n1)))
                    (push x siblings)))
       (loop for x in childrenParent2
             do (if(and (not (member x siblings :test #'EQUAL)) (not(equal x n1)))
                    (push x siblings)))
  (remove-duplicates(sort siblings #'string<=) ::test #'equal))
)



(DEFUN isUnrelated(n1 n2 tree)
  (let*((unrelatedbool t))
    (when (and n1 n2)
      ;(if (getChildren n1 n2 tree)(getChildren n2 n1 tree )
          
      ;(if (getSibs n1 tree)(setf unrelatedbool nil))
      (if (getCousins n1 tree)(setf unrelatedbool nil))                                                   
      (if (or(isAncestor n1 n2 tree) (isAncestor n2 n1 tree))
              (setf unrelatedbool nil)))
    (if unrelatedbool t nil)))

(DEFUN getUnrelated(n1 tree)
  
  (sort (remove nil (loop for i being the hash-keys of tree
                          collecting (if (isUnrelated n1 i tree) i)))#'string<))
    

(DEFUN isChild (n1 n2 tree)
  (member n1 (getChildren n2 tree):test #'EQUAL)
)

(DEFUN isSib(n1 n2 tree)
  (member n1 (getSibs n2 tree):test #'EQUAL)
)

(DEFUN isAncestor (n1 n2 tree)
  (member n1 (ancestors n2 tree):test #'EQUAL)
)
;; this needs degree
(defun isCousin(n1 n2 tree)
  (let* ((direct nil) (cousin nil)
        (person1 (lookup-person n1 tree))
        (person2 (lookup-person n2 tree)))
  (when (and person1 person2)
      (if (string= (person-name person1) (person-name person2)) (setf direct t))
      (if (or (isChild n1 n2 tree) (isChild n2 n1 tree)) (setf direct t))
      (let ((ancestors1 (ancestors n1 tree)) (ancestors2 (ancestors n2 tree)))
      (if (or (member (person-name person1) ancestors2) (member (person-name person2) ancestors1)) (setf direct t))
      (when (not direct)
        (loop for i in ancestors1 doing (if (member i ancestors2 :test #'equal) (setf cousin t))))))
  (if cousin t nil)))


;; this needs degree
(defun getCousins(n1 tree)
  (sort (remove nil (loop for i being the hash-keys of tree
                          collecting (if (isCousin n1 i tree) i)))#'string<))

(DEFUN getCousinX (n1 x tree)
  (sort (remove nil (loop for i being the hash-keys of tree
                          collecting (if (isCousinX n1 x i tree) i)))#'string<))
  
(DEFUN isCousinX (n1 x n2 tree)
  (let* ((cousinX nil)
         (genGaps nil)
         (mini 10000))
    (WHEN (isCousin n1 n2 tree)
      (let ((commAncs (getCommAnc n1 n2 tree)))
        ;(format t "~a~%" commAncs)
        (loop for i in CommAncs doing (push (getGenGap i n1 0 tree) genGaps) (push (getGenGap i n2 0 tree) genGaps))
        (loop for i in genGaps doing (setf mini (min mini i)))
        (IF (equal (parse-integer x) (- mini 1)) (setf cousinX t))))
    (IF cousinX t nil)))





;;NOTE: This function needs to be defined by team   
(DEFUN handle-E (linelist tree)
  "LINELIST is a LIST of strings. TREE is a hash-table."
 (IF (= 2 (LENGTH linelist))
  (LET* ((a (FIRST linelist))
         (b (SECOND linelist))
         (pa (make-person :name a :parent1 nil :parent2 nil :children nil))
         (pb (make-person :name b :parent1 nil :parent2 nil :children nil)))  
    (IF (not (person-exists a tree))
        ;;(LET ((pa (make-person :name a :parent1 nil :parent2 nil)))
        (add-person a pa tree))
    (IF (not (person-exists b tree))
        (add-person b pb tree)))
   ;;else goes here
    
   (LET* ((a (FIRST linelist))
          (b (SECOND linelist))
          (c (THIRD linelist))
          
          (pb (make-person :name b :parent1 nil :parent2 nil))
          (pc (make-person :name c :parent1 a :parent2 b)))  
     
     (IF (not (person-exists a tree))
         (let ((pa (make-person :name a :parent1 nil :parent2 nil)))
           (add-person a pa tree)
           (setf (person-children pa) (append (person-children pa) (list c))))
       (let((pa (lookup-person a tree)))
         (setf (person-children pa) (append (person-children pa) (list c)))))  
     (IF (not (person-exists b tree))
         (add-person b pb tree)
       (let* ((pb (lookup-person b tree)))
         (setf (person-children pb) (append (person-children pb) (list c)))))     
     (IF (not (person-exists c tree))
         (add-person c pc tree)
       (let* ((pc (lookup-person c tree)))
         (setf (person-parent1 pc) a)
         (setf (person-parent2 pc) b))))))
  
  


;;NOTE: This function needs to be defined by team
(DEFUN handle-X (linelist tree)
  "LINELIST is a LIST of strings. TREE is a hash-table."
  (FORMAT T "X ~{~a ~} ~%" linelist)
  (IF(= 3 (LENGTH linelist))
      
        ;(FORMAT t "X ~a ~a ~a~%" (FIRST linelist)(SECOND linelist)(THIRD linelist))
         (LET* ((a (FIRST linelist))
                (b (THIRD linelist)))
           (COND ((not (person-exists a tree))
                  (FORMAT t "~A doesn't exist in the family~%" a))
                 ((not (person-exists b tree))
                  (FORMAT t "~A doesn't exist in the family~%" b))
                 ((and (person-exists a tree) (person-exists b tree))
                  ;(let* ((pa (lookup-person a tree))
                         ;(pb (lookup-person b tree)))              
                    (COND 
                     ((EQUAL "ancestor"(SECOND linelist))
                      (IF (isAncestor a b tree) (FORMAT t "YES~%")
                        (FORMAT t "NO~%")))
                     ((EQUAL "sibling"(SECOND linelist)) 
                      (IF (isSib a b tree) (FORMAT t "YES~%")
                       (FORMAT t "NO~%")))
                     ((EQUAL "child"(SECOND linelist))
                      (IF (isChild a b tree) (FORMAT t "YES~%")
                        (FORMAT t "NO~%")))
                     ((EQUAL "cousin"(SECOND linelist))
                      (IF (isCousin a b tree) (FORMAT t "YES~%")
                        (FORMAT t "NO~%")))
                     ((EQUAL "unrelated"(SECOND linelist))
                      (IF (isUnrelated a b tree) (FORMAT t "YES~%") 
                        (FORMAT t "NO~%")))))))

    ;;else
  
      (LET* ((a (FIRST linelist))
             (b (FOURTH linelist)))
           (cond ((not (person-exists a tree))
                  (FORMAT t "~A doesn't exist in the family~%" a))
                  
                 ((not (person-exists b tree))
                  (FORMAT t "~A doesn't exist in the family~%" b))
                  
                 ((and (person-exists a tree) (person-exists b tree))
                  (IF (isCousinX a (THIRD linelist) b tree) (FORMAT t "YES~%")
                    (FORMAT t "NO~%")))))))

;;NOTE: This function needs to be defined by team
(DEFUN handle-W (linelist tree)
  "LINELIST is a LIST of strings. TREE is a hash-table."
    ;;body of function goes here
    (FORMAT t "W ~{~a ~} ~% " linelist)
(IF(= 2 (LENGTH linelist))
     (LET* ((a (SECOND linelist)))
           ;(FORMAT t "W ~a ~a " (FIRST linelist)(SECOND linelist)))
       (IF (NOT (person-exists a tree))
           (FORMAT t "~A doesn't exist~%" a)
         
         (COND 
           ((EQUAL "ancestor"(FIRST linelist)) (loop for i in (ancestors a tree) doing (FORMAT t "~A~%" i)))
           ((EQUAL "sibling"(FIRST linelist)) (loop for i in (getSibs a tree) doing (FORMAT t "~A~%" i)))
           ((EQUAL "child"(FIRST linelist))(loop for i in (getChildren a tree) doing (format t "~a~%" i)))
           ;((EQUAL "cousin"(FIRST linelist))(loop for i in (getCousins a tree) doing (format t "~a~%" i)))
           ((EQUAL "unrelated"(FIRST linelist)) (loop for i in (getUnrelated a tree) doing (format t "~a~%" i))))))

    ;;else
    (LET* ((a (THIRD linelist)))
     ; (FORMAT t "W cousin ~a ~a " (Second linelist)(THIRD linelist))
      (IF (not (person-exists a tree))
          (FORMAT t "~A doesn't exist~%" a)
        (loop for i in (getCousinX a (SECOND linelist) tree) doing (format t "~a~%" i))))))
 

;;;------------------------------------------------
;;; TEAM SHOULD PUT ALL NEW HELPER FUNCTION
;;; DEFINITIONS ABOVE THIS COMMENT
;;;------------------------------------------------ 




;;;THE TOP LEVEL FUNCTION OF THE WHOLE PROGRAM
;;NOTE: This function is complete.
(DEFUN family (stream)
  "This is the top-level function for the whole Lisp program. Reads
each line from the file opened in STREAM."
  (LET ((tree (MAKE-HASH-TABLE :size 1000 :test #'equal))
        (line-items (SPLIT-SEQUENCE " " (READ-LINE stream nil "") :test #'equal)))
    (LOOP
     (COND
       ((EQUAL "E" (FIRST line-items)) (handle-E (REST line-items) tree))
       ((EQUAL "W" (FIRST line-items)) (handle-W (REST line-items) tree))
       ((EQUAL "X" (FIRST line-items)) (handle-X (REST line-items) tree))
       (t (RETURN nil))) ; end of file reached
     (SETF line-items (SPLIT-SEQUENCE " " (READ-LINE stream nil "") :test #'equal)))
    ;(getGenGap "David" "Daniel" 0 tree)
    ;(getCommAnc "Armond" "Alice" tree)
))


;;How Dr. Klassner and Jenish will test your code in the Listener:
;;
;;(family (open "~/Documents/School/CSC\ 1800-002/Projects/Project3/tests/test.txt"))
;;
;; NOTE: The FilePath for OPEN is just an example. 
;; Use your own laptop directory to where you keep
;; your project's test files.


;;;A helpful tester function for debugging your tree.
(DEFUN test-tree ()
  (LET ((tree (MAKE-HASH-TABLE :size 1000 :test #'equal)))
    (add-person "Zebulon" (make-person :name "Zebulon" :parent1 nil :parent2 nil) tree)
    (add-person "Zenobia" (make-person :name "Zenobia" :parent1 nil :parent2 nil) tree)
    (add-person "Fred" (make-person :name "Fred" :parent1 nil :parent2 nil) tree)
    (add-person "Mary" (make-person :name "Mary" :parent1 "Zebulon" :parent2 "Zenobia") tree)
    (add-person "Karen" (make-person :name "Karen" :parent1 "Fred" :parent2 "Mary") tree)
    (add-person "Kelly" (make-person :name "Kelly" :parent1 "Fred" :parent2 "Mary") tree)
    (add-person "Brenda" (make-person :name "Brenda" :parent1 "Fred" :parent2 "Mary") tree)
    (add-person "Bill" (make-person :name "Bill" :parent1 nil :parent2 nil) tree)
    (add-person "Benjamin" (make-person :name "Benjamin" :parent1 "Karen" :parent2 "Bill") tree)
    (add-person "Alex" (make-person :name "Alex" :parent1 "Karen" :parent2 "Bill") tree)
    ;; if "add-person" is defined correctly and "ancestorsb" is defined correctly,
    ;; this last call should make test-tree return a list containing the following
    ;; in some arbitrary order when you call test-tree in the Listener:
    ;;   ("Karen" "Bill" "Fred" "Mary" "Zebulon" "Zenobia")
    (ancestors "Alex" tree)
    (getGenGap "Zebulon" "Alex" 0 tree)
    (getChildren "Zebulon" tree)
   ))
