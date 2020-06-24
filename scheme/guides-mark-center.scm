;; -*-scheme-*-

(define (photogimp-mark-centre image drawable)
  (let* (
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
        )
    (gimp-image-undo-group-start image)

    (gimp-image-add-vguide image (/ width 2))
    (gimp-image-add-hguide image (/ height 2))

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "photogimp-mark-centre"
  _"Marcar o centro"
  _"Create four guides around the image"
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "photogimp-mark-centre"
                         "<Image>/Image/Guides")
                         

