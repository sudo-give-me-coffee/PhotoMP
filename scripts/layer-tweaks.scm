
(define (layer-tweaks image drawable rotate 
                                     invert-rotate 
                                     h-pos 
                                     v-pos 
                                     color-effect 
                                     mirror-v 
                                     mirror-h 
                                     add-alpha 
                                     add-mask 
                                     delimit-layer 
                                     mark-centre 
                                     enable-link)
  (let* (
          (height (car (gimp-image-height image)))
          (width  (car (gimp-image-width  image)))
          
          (layer  (car (gimp-image-get-active-layer image)))
          (layer-width  0)
          (layer-height 0)
          
          (layer-width-half  0)
          (layer-height-half 0)

          (layer-x 0)
          (layer-y 0)
          
          (rotate (/ (* rotate *pi*) 180))
        )

    (gimp-image-undo-group-start image)
      (gimp-selection-none image)
      
      (if (= invert-rotate TRUE) (set! rotate (* rotate -1)))
      
      (gimp-item-transform-rotate layer rotate TRUE 0 0)
      (plug-in-autocrop-layer 0 image layer)
      
      (set! layer-x (car  (gimp-drawable-offsets layer)))
      (set! layer-y (cadr (gimp-drawable-offsets layer)))
      (set! layer-width  (car (gimp-drawable-width layer)))
      (set! layer-height (car (gimp-drawable-height layer)))
          
      (set! layer-width-half  (/ layer-width 2))
      (set! layer-height-half (/ layer-height 2))
      
      (if (= h-pos 1) (set! layer-x 0))
      (if (= h-pos 2) (set! layer-x (- (/ width 2) layer-width-half)))
      (if (= h-pos 3) (set! layer-x (- width layer-width)))
      
      (if (= v-pos 1) (set! layer-y 0))
      (if (= v-pos 2) (set! layer-y (- (/ height 2) layer-height-half)))
      (if (= v-pos 3) (set! layer-y (- height layer-height)))
      
      (gimp-layer-set-offsets layer layer-x layer-y)
      
      (if (= 1 color-effect) (gimp-drawable-desaturate layer 0))
      
      (if (= 2 color-effect)
        (begin
          (gimp-drawable-desaturate layer DESATURATE-LIGHTNESS)
          (gimp-drawable-brightness-contrast layer -0.078125 -0.15625)
          (gimp-drawable-color-balance layer TRANSFER-SHADOWS TRUE 30 0 -30)
        )
      )
      
      (if (= 3 color-effect) (gimp-drawable-invert layer 1))
      
      (if (= mirror-v    1) (gimp-item-transform-flip-simple layer 1 TRUE 0))
      (if (= mirror-h    1) (gimp-item-transform-flip-simple layer 0 TRUE 0))
      (if (= add-alpha   1) (gimp-layer-add-alpha layer))
      (if (= add-mask    1) (gimp-layer-add-mask layer (car (gimp-layer-create-mask layer 0))))
      (if (= add-mask    1) (gimp-layer-set-edit-mask layer 0))
      
                     
      (if (= delimit-layer TRUE)
        (begin
          (if (< 0 layer-x) (if (< layer-x width)  (gimp-image-add-vguide image layer-x)))
          (if (< 0 layer-y) (if (< layer-y height) (gimp-image-add-hguide image layer-y)))

          (if (< (+ layer-x layer-width)  width)  (gimp-image-add-vguide image (+ layer-x layer-width)))
          (if (< (+ layer-y layer-height) height) (gimp-image-add-hguide image (+ layer-y layer-height)))
        )
      )
      
      (if (= mark-centre TRUE)
        (begin
          (if (< 0 (+ layer-x layer-width-half))
            (if (< (+ layer-x layer-width-half) width) (gimp-image-add-vguide image (+ layer-x layer-width-half))) 
          )
          (if (< 0 (+ layer-y layer-height-half))
            (if (< (+ layer-y layer-height-half) height) (gimp-image-add-hguide image (+ layer-y layer-height-half))) 
          )
        )
      )
      
      (if (= enable-link 1) (gimp-item-set-linked layer 1))
      
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "layer-tweaks"
  _"Ajustes rápidos..."
  _"Permite aplicar diversos ajustes simulteneamente à camada atual"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
  SF-ADJUSTMENT "Rotação" '(0 0 180 45 45 0 0)
  SF-TOGGLE     "Rotacioar no sentido antihorario"  FALSE
  SF-OPTION     "Posição horizontal" '("Não alterar" "À esquerda" "Ao centro" "À direita")
  SF-OPTION     "Posição vertical"   '("Não alterar" "Em cima" "Ao centro" "Em baixo")
  SF-OPTION     "Cores da camada" '("Não alterar" 
                                    "Deixar em escala de cinza (dessaturar)" 
                                    "Transformar em tons de sépia"
                                    "Inverter cores" )
  SF-TOGGLE     "Espelhar verticalmente"    FALSE
  SF-TOGGLE     "Espelhar Horizontalmente"  FALSE
  SF-TOGGLE     "Adicionar canal alfa"  FALSE
  SF-TOGGLE     "Adicionar máscara"  FALSE
  SF-TOGGLE     "Delimitar camada"  FALSE
  SF-TOGGLE     "Marcar centro da camada"  FALSE
  SF-TOGGLE     "Ativar vínculo"  FALSE
)

(script-fu-menu-register "layer-tweaks"
                         "<Image>/Layer")
                         
