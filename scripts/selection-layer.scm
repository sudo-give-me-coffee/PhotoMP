
(define (selection-layer image drawable color exclude-mode)
  (let* (
           (width (car (gimp-image-width image)))
           (height (car (gimp-image-height image)))
                     
           (new-layer (car (gimp-layer-new image width height (car (gimp-image-base-type image)) "Camada de seleção" 45 0)))
           (new-mask (car (gimp-layer-create-mask new-layer exclude-mode)))
           
           (current-layer (car (gimp-image-get-active-layer image)))
           (current-layer-pos (car (gimp-image-get-item-position image current-layer)))
        )

    (gimp-image-undo-group-start image)
      (gimp-context-set-foreground color)
      (gimp-image-insert-layer image new-layer 0 current-layer-pos)
      (gimp-context-set-opacity 100)
      (gimp-selection-none image)
      (gimp-drawable-edit-bucket-fill new-layer 0 0 0)
      (gimp-layer-add-mask new-layer new-mask)
      (gimp-context-set-default-colors)
      (gimp-context-swap-colors)
    (gimp-image-undo-group-end image)
   (gimp-displays-flush)
  )
) 

(script-fu-register
  "selection-layer"
  "Criar camada de seleção"
  ""
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  SF-COLOR    "Cor de destaque" '(255 0 0)
  SF-TOGGLE   "Usar o pincel para marcar as áreas de seleção" TRUE
)

(script-fu-menu-register "selection-layer" "<Image>/Layer/Camada de seleção/")


(define (selection-layer-apply image drawable)
  (let* (
           (width (car (gimp-image-width image)))
           (height (car (gimp-image-height image)))
                     
           (layer (car (gimp-image-get-active-layer image)))
           (mask (car (gimp-layer-get-mask layer)))
           
           (layer-pos (+ (car (gimp-image-get-item-position image layer)) 1))
           
           (layers (gimp-image-get-layers image))
           (all-layers (cadr layers))
           (count-layers (- (car layers) 1))
           (current-layer -1)
        )
    (if (not (= mask -1)) (begin
      (gimp-image-undo-group-start image)
        (gimp-image-select-item image 2 mask)
        (gimp-item-set-visible layer FALSE)
        (while (>= count-layers 0)
          (set! current-layer (aref all-layers count-layers))
          (if (= (car (gimp-image-get-item-position image current-layer)) layer-pos)(begin
            (gimp-image-set-active-layer image current-layer)
            (set! count-layers -1)
          ))
          (set! count-layers (- count-layers 1))
        )
      (gimp-image-undo-group-end image)
      (gimp-displays-flush)
   ))
  )
)

(script-fu-register
  "selection-layer-apply"
  "Aplicar máscara da camada para seleção"
  ""
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "selection-layer-apply" "<Image>/Layer/Camada de seleção/")
