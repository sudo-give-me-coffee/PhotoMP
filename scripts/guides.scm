                         
; Adiciona mais opções de guias

;-----------------------------------------------------------------------------------------------------------

(define (cm2pixels cm dpi)
  (/ (* cm dpi) 2.54)
)

(define (point2pixels pt dpi)
  (/ (* pt dpi) 72)
)

;-----------------------------------------------------------------------------------------------------------

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
  _"Cria 4 guias delimitando a imagem"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "guides-delimit-image"
                         "<Image>/Image/Guides")

;-----------------------------------------------------------------------------------------------------------

(define (guides-mark-centre image drawable)
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

(script-fu-register "guides-mark-centre"
  _"Marcar o centro"
  _"Cria 2 guias marcando o centro exato da imagem"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "guides-mark-centre"
                         "<Image>/Image/Guides")

;-----------------------------------------------------------------------------------------------------------

(define (guides-set-margin image drawable superior esquerda direita inferior unidade delimitar marcar-centro)
  (let* (
          (width  (car  (gimp-image-width image)))
          (height (car (gimp-image-height image)))
          
          (dpi-x (car  (gimp-image-get-resolution image)))
          (dpi-y (cadr (gimp-image-get-resolution image)))
        )
        
    
    (gimp-image-undo-group-start image)
    
    ;---------------------------------------------------------------------

      (if (= delimitar TRUE) (begin
        (guides-delimit-image image drawable 0 0)
      ))
    
      (if (= marcar-centro TRUE) (begin
        (guides-mark-centre image drawable 0 0)
      ))
    
    ;---------------------------------------------------------------------

      (if (= unidade 1) (begin
        (set! superior (cm2pixels superior dpi-y))
        (set! inferior (cm2pixels inferior dpi-y))
        
        (set! esquerda (cm2pixels esquerda dpi-x))
        (set! direita  (cm2pixels direita  dpi-x))
      ))
      
      (if (= unidade 2) (begin
        (set! superior (cm2pixels (/ superior 10) dpi-y))
        (set! inferior (cm2pixels (/ inferior 10) dpi-y))
        
        (set! esquerda (cm2pixels (/ esquerda 10) dpi-x))
        (set! direita  (cm2pixels (/ direita  10) dpi-x))
      ))
      
      (if (= unidade 3) (begin
        (set! superior (cm2pixels (* superior 2.54) dpi-y))
        (set! inferior (cm2pixels (* inferior 2.54) dpi-y))
        
        (set! esquerda (cm2pixels (* esquerda 2.54) dpi-x))
        (set! direita  (cm2pixels (* direita  2.54) dpi-x))
      ))
      
      (if (= unidade 4) (begin
        (set! superior (point2pixels superior dpi-y))
        (set! inferior (point2pixels inferior dpi-y))
        
        (set! esquerda (point2pixels esquerda dpi-x))
        (set! direita  (point2pixels direita  dpi-x))
      ))
    
    ;---------------------------------------------------------------------
    
      (if (> superior 0) (begin
        (if (> height superior) (begin
          (gimp-image-add-hguide image superior)
        ))
      ))
    
      (if (> inferior 0) (begin
        (if (> height superior) (begin
          (gimp-image-add-hguide image (- height inferior))
        ))
      ))
    
      (if (> esquerda 0) (begin
        (if (> width esquerda) (begin
          (gimp-image-add-vguide image esquerda)
        ))
      ))
    
      (if (> direita 0) (begin
        (if (> height superior) (begin
          (gimp-image-add-vguide image (- width direita))
        ))
      ))

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
    
    (list superior esquerda direita inferior)
  )
)

(script-fu-register "guides-set-margin"
  _"Definir margens"
  _"Cria 4 guias criando uma margem na imagem"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
  SF-ADJUSTMENT "Superior" (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Esquerda" (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Direita"  (list 2 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Inferior" (list 2 0 5000 1 10 2 SF-SPINNER)

  SF-OPTION    "Unidade de medida"        '("Pixels (px)" 
                                            "Centimetros (cm)" 
                                            "Milimetros (mm)"
                                            "Polegadas (in)"
                                            "Pontos (pt)")
                                            
  SF-TOGGLE    "Delimitar imagem"             TRUE
  SF-TOGGLE    "Marcar o centro"              FALSE
)

(script-fu-menu-register "guides-set-margin"
                         "<Image>/Image/Guides")

;-----------------------------------------------------------------------------------------------------------

(define (guides-guide-layout image drawable linhas colunas margem-interna-horizontal
                                                           margem-interna-vertical
                                                           unidade-margem-interna
                                                           margem-externa-superior
                                                           margem-externa-esquerda
                                                           margem-externa-direita
                                                           margem-externa-inferior
                                                           unidade-margem-externa
                                                           delimitar-imagem
                                                           remover-guias-existentes)
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
    
      (if (= remover-guias-existentes TRUE)(script-fu-guides-remove image drawable))
    
      (if (= unidade-margem-externa 0) (set! unidade-margem-externa (+ unidade-margem-interna 1)))
      
      (if (= unidade-margem-externa 2) (begin
        (set! margem-externa-superior (cm2pixels margem-externa-superior dpi-y))
        (set! margem-externa-esquerda (cm2pixels margem-externa-esquerda dpi-x))
        (set! margem-externa-direita  (cm2pixels margem-externa-direita  dpi-y))
        (set! margem-externa-inferior (cm2pixels margem-externa-inferior dpi-x))
      ))
      
      (if (= unidade-margem-externa 3) (begin
        (set! margem-externa-superior (cm2pixels (/ margem-externa-superior 10) dpi-y))
        (set! margem-externa-esquerda (cm2pixels (/ margem-externa-esquerda 10) dpi-x))
        (set! margem-externa-direita  (cm2pixels (/ margem-externa-direita  10) dpi-y))
        (set! margem-externa-inferior (cm2pixels (/ margem-externa-inferior 10) dpi-x))
      ))
      
      (if (= unidade-margem-externa 4) (begin
        (set! margem-externa-superior (cm2pixels (* margem-externa-superior 2.54) dpi-y))
        (set! margem-externa-esquerda (cm2pixels (* margem-externa-esquerda 2.54) dpi-x))
        (set! margem-externa-direita  (cm2pixels (* margem-externa-direita  2.54) dpi-y))
        (set! margem-externa-inferior (cm2pixels (* margem-externa-inferior 2.54) dpi-x))
      ))
      
      (if (= unidade-margem-externa 5) (begin
        (set! margem-externa-superior (point2pixels margem-externa-superior dpi-y))
        (set! margem-externa-esquerda (point2pixels margem-externa-esquerda dpi-x))
        (set! margem-externa-direita  (point2pixels margem-externa-direita  dpi-y))
        (set! margem-externa-inferior (point2pixels margem-externa-inferior dpi-x))
      ))
      
      
      
      (guides-set-margin image drawable margem-externa-superior
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
    (set! box-height (/ height linhas))
    
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
    
    (if (< 0 margem-externa-superior) (gimp-image-add-hguide image margem-externa-superior))
    (if (< 0 margem-externa-esquerda) (gimp-image-add-vguide image margem-externa-esquerda))
    
    (if (< 0 margem-externa-inferior) (gimp-image-add-hguide image (- (car (gimp-image-height image)) margem-externa-inferior)))
    (if (< 0 margem-externa-direita)  (gimp-image-add-vguide image (- (car (gimp-image-width  image)) margem-externa-direita)))

    ;---------------------------------------------------------------------
    
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "guides-guide-layout"
  _"Layout de guias"
  _"Divide a imagem em linhas e colunas, opcionalmente adicionando margens e delimitando a imagem"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
  SF-ADJUSTMENT "Linhas" (list 3 1 5000 1 10 0 SF-SPINNER)
  SF-ADJUSTMENT "Colunas" (list 3 1 5000 1 10 0 SF-SPINNER)  
  SF-ADJUSTMENT "Margem interna Horizontal"  (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Margem interna Vertical" (list 3 0 5000 1 10 2 SF-SPINNER)
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
                                            
  SF-TOGGLE    "Delimitar imagem"               TRUE
  SF-TOGGLE    "Remover guias existentes"       TRUE
)

(script-fu-menu-register "guides-guide-layout"
                         "<Image>/Image/Guides")
