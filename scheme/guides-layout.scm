;; -*-scheme-*-

(define (cm2pixels cm dpi)
  (/ (* cm dpi) 2.54)
)

(define (point2pixels pt dpi)
  (/ (* pt dpi) 72)
)

(define (photogimp-guide-layout image drawable linhas colunas margem-interna-horizontal
                                                              margem-interna-vertical
                                                              unidade-margem-interna
                                                              margem-externa-superior
                                                              margem-externa-esquerda
                                                              margem-externa-direita
                                                              margem-externa-inferior
                                                              unidade-margem-externa
                                                              definir-margem
                                                              delimitar-imagem)
  (let* (
          (width  (car (gimp-image-width  image)))
          (height (car (gimp-image-height image)))
          
          (dpi-x (car  (gimp-image-get-resolution image)))
          (dpi-y (cadr (gimp-image-get-resolution image)))
         
          (espacadores-verticais   (-  linhas 1))
          (espacadores-horizontais (- colunas 1))
          
          (x 0)
          (y 0)
          
          (box-width  0)
          (box-height 0)
         )
        
    
    (gimp-image-undo-group-start image)

    ;---------------------------------------------------------------------
    
      (if (= unidade-margem-externa 1) (begin
        (set! unidade-margem-externa (+ unidade-margem-interna 1))
      ))
      
      (photogimp-set-margin image drawable margem-externa-superior
                                           margem-externa-esquerda
                                           margem-externa-direita
                                           margem-externa-inferior
                                           (- unidade-margem-externa 1) 
                                           delimitar-imagem FALSE)
                                           
    ;---------------------------------------------------------------------
    
      (if (= unidade-margem-interna 1) (begin
        (set! margem-interna-vertical   (cm2pixels margem-interna-vertical   dpi-y))
        (set! margem-interna-horizontal (cm2pixels margem-interna-horizontal dpi-x))
      ))
      
      (if (= unidade-margem-interna 2) (begin
        (set! margem-interna-vertical   (cm2pixels (/ margem-interna-vertical 10)   dpi-y))
        (set! margem-interna-horizontal (cm2pixels (/ margem-interna-horizontal 10) dpi-x))
      ))
      
      (if (= unidade-margem-interna 3) (begin
        (set! margem-interna-vertical   (cm2pixels (* margem-interna-vertical   2.54) dpi-y))
        (set! margem-interna-horizontal (cm2pixels (* margem-interna-horizontal 2.54) dpi-x))
      ))
      
      (if (= unidade-margem-interna 4) (begin
        (set! margem-interna-vertical   (point2pixels margem-interna-vertical   dpi-y))
        (set! margem-interna-horizontal (point2pixels margem-interna-horizontal dpi-x))
      ))
   
    ;---------------------------------------------------------------------
    
    (set! width  (- width  (+ (+ margem-externa-direita  margem-externa-esquerda) (* espacadores-horizontais margem-interna-horizontal))))
    (set! height (- height (+ (+ margem-externa-superior margem-externa-inferior) (* espacadores-verticais   margem-interna-vertical))))
    
    (set! box-width  (/ width  colunas))
    (set! box-height (/ height colunas))
    
    ;---------------------------------------------------------------------
    
    (set! x (+ margem-externa-esquerda box-width))
    (set! y (+ margem-externa-superior box-height))

    ;---------------------------------------------------------------------
    
    (while (> colunas 1)
      (gimp-image-add-vguide image x)
      (gimp-image-add-vguide image (+ x margem-interna-horizontal))
      (set! x (+ (+ x margem-interna-horizontal) box-width))
      (set! colunas (- colunas 1))
    )
    
    (while (> linhas 1)
      (gimp-image-add-hguide image y)
      (gimp-image-add-hguide image (+ y margem-interna-vertical))
      (set! y (+ (+ y margem-interna-vertical) box-height))
      (set! linhas (- linhas 1))
    )
    
    ;---------------------------------------------------------------------
    
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "photogimp-guide-layout"
  _"Layout de guias"
  _"Create four guides around the image "
  "Alan Horkan"
  "Alan Horkan, 2004.  Public Domain."
  "2004-08-13"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
  SF-ADJUSTMENT "Linhas" (list 3 0 5000 1 10 0 SF-SPINNER)
  SF-ADJUSTMENT "Colunas" (list 3 0 5000 1 10 0 SF-SPINNER)  
  SF-ADJUSTMENT "Margem interna Horizontal"  (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Margem interna Vertical" (list 2 0 5000 1 10 2 SF-SPINNER)
  SF-OPTION    "Unidade de medida da magem interna"  '("Pixels (px)" 
                                                    "Centimetros (cm)" 
                                                    "Milimetros (mm)"
                                                    "Polegads (in)"
                                                    "Pontos (pt)")
  SF-ADJUSTMENT "Margem externa Superior"  (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Margem externa Esquerda"  (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Margem externa Direita" (list 2 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Margem externa Inferior" (list 2 0 5000 1 10 2 SF-SPINNER)
                                                    
  SF-OPTION    "Unidade de medida da magem externa"  '("Mesma que a margem interna" 
                                                    "Pixels (px)" 
                                                    "Centimetros (cm)" 
                                                    "Milimetros (mm)"
                                                    "Polegads (in)"
                                                    "Pontos (pt)")
                                            
  SF-TOGGLE    "Definir margem"               TRUE
  SF-TOGGLE    "Delimitar imagem"               TRUE
)

(script-fu-menu-register "photogimp-guide-layout"
                         "<Image>/Image/Guides")
                         

