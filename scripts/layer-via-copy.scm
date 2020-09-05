
(define (layer-via-copy image drawable)
  (let* (
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
          (layer (car (gimp-image-get-active-layer image)))
          (copy (car (gimp-layer-copy layer TRUE)))
        )
    (gimp-image-undo-group-start image)
    (gimp-image-insert-layer image copy 0 0)
    (if (not (= -1 (car (gimp-layer-get-mask copy)) ))
      (gimp-layer-remove-mask copy 0)
    )
    (gimp-layer-add-mask copy (car (gimp-layer-create-mask copy ADD-MASK-BLACK)))
    (gimp-drawable-edit-bucket-fill (car (gimp-layer-mask copy)) FILL-WHITE 0 0)
    (gimp-layer-set-edit-mask copy FALSE)
    (gimp-layer-remove-mask copy 0)
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "layer-via-copy"
  _"Nova camada por cópia"
  _"Cria copi"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
)

(script-fu-menu-register "layer-via-copy" "<Image>/Layer/Criar através da seleção...")

;-------------------------------------------------------------------------------------------------

(define (layer-via-cut image drawable)
  (let* (
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
          (layer (car (gimp-image-get-active-layer image)))
          (copy (car (gimp-layer-copy layer TRUE)))
          (color (car (gimp-context-get-foreground)))
          (boundaries (gimp-selection-bounds image))
          (selection (car boundaries))
        )
    (if (= selection TRUE)
      (begin
        (gimp-image-undo-group-start image)
        (gimp-image-insert-layer image copy 0 0)
        (if (not (= -1 (car (gimp-layer-get-mask layer)) ))
          (gimp-layer-remove-mask layer 0)
        )
        (gimp-layer-add-mask layer (car (gimp-layer-create-mask layer ADD-MASK-WHITE)))
        (gimp-context-set-foreground '(0 0 0))
        (gimp-drawable-edit-bucket-fill (car (gimp-layer-mask layer)) FILL-FOREGROUND 0 0)
        (gimp-layer-remove-mask layer 0)
        (gimp-context-set-foreground color)

        (if (not (= -1 (car (gimp-layer-get-mask copy)) ))
          (gimp-layer-remove-mask copy 0)
        )
    
        (gimp-layer-add-mask copy (car (gimp-layer-create-mask copy ADD-MASK-BLACK)))
        (gimp-drawable-edit-bucket-fill (car (gimp-layer-mask copy)) FILL-WHITE 0 0)
        (gimp-layer-set-edit-mask copy FALSE)
        (gimp-layer-remove-mask copy 0)
    
        (gimp-image-undo-group-end image)
        (gimp-displays-flush)
      )
    )
  )
)

(script-fu-register "layer-via-cut"
  _"Nova camada por recorte"
  _"Cria copi"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
)

(script-fu-menu-register "layer-via-cut" "<Image>/Layer/Criar através da seleção...")


;-------------------------------------------------------------------------------------------------

(define (select-to-mask-with-selection-hidden image drawable)
  (let* (
          (boundaries (gimp-selection-bounds image))
          (selection (car boundaries))
          (x1 (cadr boundaries))
          (y1 (caddr boundaries))
          (x2 (cadr (cddr boundaries)))
          (y2 (caddr (cddr boundaries)))
          (mask-layer 0)
        )
    (if (= selection TRUE)
      (begin
        (gimp-image-undo-group-start image)
          (gimp-selection-invert image)
          (if (not (= -1 (car (gimp-layer-get-mask (car (gimp-image-get-active-layer image)))) ))
            (gimp-layer-remove-mask (car (gimp-image-get-active-layer image)) 1)
          )
          (gimp-layer-add-mask (car (gimp-image-get-active-layer image))
                               (car (gimp-layer-create-mask (car (gimp-image-get-active-layer image)) ADD-MASK-BLACK)))
          (gimp-drawable-edit-bucket-fill (car (gimp-layer-mask (car (gimp-image-get-active-layer image)))) FILL-WHITE 0 0)
          (gimp-layer-set-edit-mask (car (gimp-image-get-active-layer image)) FALSE)
          (gimp-selection-invert image)
        (gimp-image-undo-group-end image)
        (gimp-displays-flush)
      )
    )
  )
)

(script-fu-register "select-to-mask-with-selection-hidden"
  _"Máscara via seleção (área selecionada oculta)"
  _"Transforma a seleção em uma mascara"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE      "Image"    0
  SF-DRAWABLE   "Drawable" 0
)

(script-fu-menu-register "select-to-mask-with-selection-hidden"
                         "<Image>/Layer/Criar através da seleção...")


(define (select-to-mask-with-selection-visible image drawable)
  (let* (
          (boundaries (gimp-selection-bounds image))
          (selection (car boundaries))
          (x1 (cadr boundaries))
          (y1 (caddr boundaries))
          (x2 (cadr (cddr boundaries)))
          (y2 (caddr (cddr boundaries)))
          (mask-layer 0)
        )
    (if (= selection TRUE)
      (begin
        (gimp-image-undo-group-start image)
          (if (not (= -1 (car (gimp-layer-get-mask (car (gimp-image-get-active-layer image)))) ))
            (gimp-layer-remove-mask (car (gimp-image-get-active-layer image)) 1)
          )
          (gimp-layer-add-mask (car (gimp-image-get-active-layer image))
                               (car (gimp-layer-create-mask (car (gimp-image-get-active-layer image)) ADD-MASK-BLACK)))
          (gimp-drawable-edit-bucket-fill (car (gimp-layer-mask (car (gimp-image-get-active-layer image)))) FILL-WHITE 0 0)
          (gimp-layer-set-edit-mask (car (gimp-image-get-active-layer image)) FALSE)
        (gimp-image-undo-group-end image)
        (gimp-displays-flush)
      )
    )
  )
)

(script-fu-register "select-to-mask-with-selection-visible"
  _"Máscara via seleção (área selecionada visível)"
  _"Transforma a seleção em uma mascara"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE      "Image"    0
  SF-DRAWABLE   "Drawable" 0
)

(script-fu-menu-register "select-to-mask-with-selection-visible"
                         "<Image>/Layer/Criar através da seleção...")
