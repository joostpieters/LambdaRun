(define (make-carrier owner)
  (let ((base (make-component "carrier" owner))
        (inventory (make-list)))
    (lambda (message)
      (case message
        ((initialize)
         (lambda (self data)
           (for-each (lambda (item)
                       (ask inventory 'prepend item))
                     data)))
        
        ((inventory)
         (lambda (self) inventory))
        
        ((add-item)
         (lambda (self item)
           (ask inventory 'prepend item)))
        
        ((remove-item)
         (lambda (self item)
           (ask inventory 'remove item)))
        
        ((take-item)
         (lambda (self item)
           (ask item 'give owner)
           (ask (ask owner 'location) 'post-event `(take-item ,owner ,item))))
        
        ((drop-item)
         (lambda (self item)
           (ask item 'drop (ask owner 'location))
           (ask (ask owner 'location) 'post-event `(drop-item ,owner))))
        
        (else (get-method base message))))))

(define carrier (make-desc make-carrier))