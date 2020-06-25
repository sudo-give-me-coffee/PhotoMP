;; -*-scheme-*-

(define (select-to-mask image drawable)
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

(script-fu-register "select-to-mask"
  _"Seleção para máscara..."
  _"Transforma a seleção em uma mascara"
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE      "Image"    0
  SF-DRAWABLE   "Drawable" 0
)

(script-fu-menu-register "select-to-mask"
                         "<Image>/Layer")
                         

