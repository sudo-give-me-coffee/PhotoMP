;; -*-scheme-*-

(define (layer-via-cut image drawable)
  (let* (
          (height (car (gimp-image-height image)))
          (width  (car (gimp-image-width  image)))
          (new-layer-FG (car (gimp-layer-new image width height 1 "Copy layer" 100 1)))
          
          (boundaries (gimp-selection-bounds image))
          (selection (car boundaries))
          (x1 (cadr boundaries))
          (y1 (caddr boundaries))
          (x2 (cadr (cddr boundaries)))
          (y2 (caddr (cddr boundaries)))
        )
        
    (gimp-image-undo-group-start image)
      (gimp-edit-cut drawable)
      (gimp-edit-clear (car (gimp-image-get-active-layer image)))
      (gimp-image-insert-layer image new-layer-FG 0 0)
      (gimp-image-set-active-layer image new-layer-FG)
      (gimp-floating-sel-anchor (car (gimp-edit-paste new-layer-FG TRUE)))
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "layer-via-cut"
  _"Nova camada por recorte"
  _"Recorta a parte selecionada da camada atual e cola em uma nova camada, caso não tenha nenhuma área selecionada, uma camada em branco será criada"
  "Natanael Barbosa Santos"
  "Natanael Barbosa Santos, 2020.  Licenced under MIT terms"
  ""
  "*"
  SF-IMAGE      "Image"    0
  SF-DRAWABLE   "Drawable" 0
)

(script-fu-menu-register "layer-via-cut"
                         "<Image>/Layer/Área selecionada/")
                         
