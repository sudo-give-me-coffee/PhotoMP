;; -*-scheme-*-

(define (guides-delimit-image image drawable)
  (let* (
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
        )
    (gimp-image-undo-group-start image)

    (gimp-image-add-vguide image 0)
    (gimp-image-add-hguide image 0)
    (gimp-image-add-vguide image width)
    (gimp-image-add-hguide image height)

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "guides-delimit-image"
  _"Delimitar imagem"
  _"Create four guides around the image"
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "guides-delimit-image"
                         "<Image>/Image/Guides")
                         

