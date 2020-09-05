
(define (remove-linked-layers image drawable)
  (let* (
          (layers (gimp-image-get-layers image))
          (all-layers (cadr layers))
          (count-layers (- (car layers) 1))
        )
    (gimp-image-undo-group-start image)
    (while (>= count-layers 0)
      (let ((current-layer (aref all-layers count-layers)))
      (if (= (car (gimp-item-get-linked current-layer)) TRUE)
         (gimp-image-remove-layer image current-layer)
      )
      (set! count-layers (- count-layers 1)))
    )
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "remove-linked-layers"
  _"Remover camadas vinculadas"
  _"Remove todas as camadas vinculadas"
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
)

(script-fu-menu-register "remove-linked-layers" "<Image>/Layer/Camadas vinculadas")

;------------------------------------------------------------------------------------------


(define (turn-link-off image drawable)
  (let* (
          (layers (gimp-image-get-layers image))
          (all-layers (cadr layers))
          (count-layers (- (car layers) 1))
        )
    (gimp-image-undo-group-start image)
    (while (>= count-layers 0)
      (let ((current-layer (aref all-layers count-layers)))
      (if (= (car (gimp-item-get-linked current-layer)) TRUE)
         (gimp-item-set-linked current-layer FALSE)
      )
      (set! count-layers (- count-layers 1)))
    )
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "turn-link-off"
  _"Remover o vinculo"
  _"Remove todas as camadas vinculadas"
  "Natanael Barbosa Santos"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
)

(script-fu-menu-register "turn-link-off" "<Image>/Layer/Camadas vinculadas")

;------------------------------------------------------------------------------------------

(define (invert-visibility-of-linked-items image drawable)
  (let* (
          (layers (gimp-image-get-layers image))
          (all-layers (cadr layers))
          (count-layers (- (car layers) 1))
          (pass FALSE)
        )
    (gimp-image-undo-group-start image)
    (while (>= count-layers 0) 
      (let ((current-layer (aref all-layers count-layers)))
      
      (if (= (car (gimp-item-get-linked current-layer)) TRUE) (begin
        (if (= (car (gimp-item-get-visible current-layer)) TRUE) (begin
          (gimp-item-set-visible current-layer FALSE)
          (set! pass TRUE)
        ))
        (if (= (car (gimp-item-get-visible current-layer)) FALSE) (begin
          (if (= pass FALSE)
            (gimp-item-set-visible current-layer TRUE)
          )
        ))
      ))
      (set! pass FALSE)
      (set! count-layers (- count-layers 1)))
    )
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "invert-visibility-of-linked-items"
  _"Inverter a visibilidade nas camadas vinculadas"
  _"Remove todas as camadas vinculadas"
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
)

(script-fu-menu-register "invert-visibility-of-linked-items" "<Image>/Layer/Camadas vinculadas")

;------------------------------------------------------------------------------------------

(define (group-linked-layers image drawable group-name)
  (let* (
          (layers (gimp-image-get-layers image))
          (all-layers (cadr layers))
          (count-layers (- (car layers) 1))
          (pass FALSE)
          (group (car (gimp-layer-group-new image)))
          (count-linked 0)
          (has-linked-layers FALSE)
        )
        
    (while (>= count-layers 0) 
      (let ((current-layer (aref all-layers count-layers)))
      (if (= (car (gimp-item-get-linked current-layer)) TRUE) (begin
        (set! has-linked-layers TRUE)
        (set! current-layer -1)
      ))
      (set! count-layers (- count-layers 1)))
    )
    
    (if (= has-linked-layers TRUE) (begin
      (set! count-layers (- (car layers) 1))
      (gimp-image-undo-group-start image)
    
      (gimp-image-insert-layer image group 0 0)
      (gimp-item-set-name group group-name)
    
      (while (>= count-layers 0) 
        (let ((current-layer (aref all-layers count-layers)))
      
        (if (= (car (gimp-item-get-linked current-layer)) TRUE) (begin
          (set! count-linked (- count-linked 1))
          (gimp-image-reorder-item image current-layer group count-linked)
        ))
        (set! pass FALSE)
        (set! count-layers (- count-layers 1)))
      )
      (gimp-image-undo-group-end image)
      (gimp-displays-flush)
    ))
  )
)

(script-fu-register "group-linked-layers"
  _"Agrupar camadas vinculadas"
  _"Remove todas as camadas vinculadas"
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  SF-STRING   "Nome do grupo"  "Camadas Vinculadas"
  
)

(script-fu-menu-register "group-linked-layers" "<Image>/Layer/Camadas vinculadas")

;------------------------------------------------------------------------------------------

(define (merge-linked-layers image drawable group-name)
  (let* (
          (layers (gimp-image-get-layers image))
          (all-layers (cadr layers))
          (count-layers (- (car layers) 1))
          (pass FALSE)
          (group (car (gimp-layer-group-new image)))
          (count-linked 0)
          (has-linked-layers FALSE)
        )
        
    (while (>= count-layers 0) 
      (let ((current-layer (aref all-layers count-layers)))
      (if (= (car (gimp-item-get-linked current-layer)) TRUE) (begin
        (set! has-linked-layers TRUE)
        (set! current-layer -1)
      ))
      (set! count-layers (- count-layers 1)))
    )
    
    (if (= has-linked-layers TRUE) (begin
      (set! count-layers (- (car layers) 1))
      (gimp-image-undo-group-start image)
    
      (gimp-image-insert-layer image group 0 0)
      (gimp-item-set-name group group-name)
    
      (while (>= count-layers 0) 
        (let ((current-layer (aref all-layers count-layers)))
      
        (if (= (car (gimp-item-get-linked current-layer)) TRUE) (begin
          (set! count-linked (- count-linked 1))
          (gimp-image-reorder-item image current-layer group count-linked)
        ))
        (set! pass FALSE)
        (set! count-layers (- count-layers 1)))
      )
      (gimp-image-merge-layer-group image group)
      (gimp-image-undo-group-end image)
      (gimp-displays-flush)
    ))
  )
)

(script-fu-register "merge-linked-layers"
  _"Combinar camadas vinculadas"
  _"Remove todas as camadas vinculadas"
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  SF-STRING   "Nome da camada resultante"  "Combinação"
  
)

(script-fu-menu-register "merge-linked-layers" "<Image>/Layer/Camadas vinculadas")
