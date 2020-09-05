
(define (group-mask image drawable)
  (let* (
           (width (car (gimp-image-width image)))
           (height (car (gimp-image-height image)))
                     
           (group (car (gimp-layer-group-new image)))
           (group-mask 0)
           
           (active-layer (car (gimp-image-get-active-layer image)))
           (active-layer-pos (car (gimp-image-get-item-position image active-layer)))
           (active-layer-parent (car (gimp-item-get-parent active-layer)))
           
           (new-layer (car (gimp-layer-new image width height (car (gimp-image-base-type image)) " " 0 0)))
        )

    (gimp-image-undo-group-start image)
      (gimp-image-insert-layer image group active-layer-parent active-layer-pos)
      
      (gimp-image-insert-layer image new-layer group 0)
      (gimp-item-set-visible new-layer FALSE)

      (gimp-layer-add-mask group (car (gimp-layer-create-mask group 1)))
      (gimp-image-select-item image 2 active-layer)
      (gimp-drawable-edit-fill (car (gimp-layer-get-mask group)) 2)
      (gimp-item-set-name group (string-append "-> " (car (gimp-item-get-name active-layer))))
      (gimp-selection-none image)
    (gimp-image-undo-group-end image)
   (gimp-displays-flush)
  )
) 

(script-fu-register
  "group-mask"
  _"Criar grupo de corte"
  _"Transforma o canal alpha da camada atual na máscara de um grupo.Assim qualquer item adicionado ao grupo será \"cortado\" preservando a máscara original do item"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)



(script-fu-menu-register "group-mask" "<Image>/Layer/")
