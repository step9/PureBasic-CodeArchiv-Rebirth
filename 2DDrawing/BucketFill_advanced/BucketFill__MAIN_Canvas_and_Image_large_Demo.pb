XIncludeFile("./BucketFill_advanced.pbi")

;- Demo - large - with directly canvas and image output

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define win_event, canvas_ID, window_ID, texture_ID, result
Define canvas_x, canvas_y, canvas_width, canvas_height, point, arc
Define path$

Define GeeBee$=     "./BucketFill_Image_Set/Geebee2.bmp"
Define Clouds$=     "./BucketFill_Image_Set/Clouds.jpg"
Define SoilWall$=   "./BucketFill_Image_Set/soil_wall.jpg"
Define RustySteel$= "./BucketFill_Image_Set/RustySteel.jpg"
Define Caisse$=     "./BucketFill_Image_Set/Caisse.png"
Define Dirt$=       "./BucketFill_Image_Set/Dirt.jpg"
Define Background$= "./BucketFill_Image_Set/Background.bmp"
Define Hubble$=     "./BucketFill_Image_Set/Hubble.jpg"
Define Alpha$=      "./BucketFill_Image_Set/Cubes.png"
Define Cat_03$=     "./BucketFill_Image_Set/Cat_03.jpg"
Define Cat_02$=     "./BucketFill_Image_Set/Cat_02.jpg"
Define Hound_1$=    "./BucketFill_Image_Set/Hound_1.png"
Define Rose$=       "./BucketFill_Image_Set/Rose.jpg"
Define Bird$=       "./BucketFill_Image_Set/Bird.png"

; Presets
canvas_x=50
canvas_y=50
canvas_width=900
canvas_height=400

; Used for PB function universal output
Macro common_before_BF
  texture_x=0,     ; Startposition texture output x   - Preset 0
texture_y=0,       ; Startposition texture output y   - Preset 0
texture_width=0,   ; Endposition texture output xx    - Preset 0 = Full available width
texture_height=0,  ; Endposition texture output yy    - Preset 0 = Full available height
texture_clip_x=0,  ; Startposition inside the texture - Preset 0 (Texture clipping)
texture_clip_y=0,  ; Startposition inside the texture - Preset 0 (Texture clipping)
texture_clip_xx=0, ; Endposition inside the texture   - Preset 0 (Texture clipping)
texture_clip_yy=0) ; Endposition inside the texture   - Preset 0 (Texture clipping)
  
  Protected mask_color
  
  ; Mask color preset - Get firstly a unused color from the actual used texture
  ; For best results with vector graphics, use this so, harmonic to the output content colors - This fix ugly edges on vector outputs
  mask_color=10 ; You can set this also for each different colored vector output or background separately
  
  ; This is the automatic standard mask color generating function
  ; If mode>0 : mask_color=SearchUnusedImageColor_BF(texture_ID, 0, 0, ImageWidth(texture_ID)-1, ImageHeight(texture_ID)-1, 5) : EndIf
  ; If mask_color<1 : mask_color=Random($FFFFFE, 1) : EndIf ; Fuse - Error handling for automatic mask color generating
  
  Protected temporary_color=mask_color+1 ; Change this line not
  Protected temporary_image_ID=CreateImage(#PB_Any, GadgetWidth(canvas_ID), GadgetHeight(canvas_ID), 24, mask_color) ; Create a temporary image
EndMacro

; Used for PB function universal output
Macro common_after_BF
  Protected result=Texture_universal_output_BF(mode, canvas_ID, temporary_image_ID, texture_ID, temporary_color,
                                               texture_x,
                                               texture_y,
                                               texture_width,
                                               texture_height,
                                               texture_clip_x,
                                               texture_clip_y,
                                               texture_clip_xx,
                                               texture_clip_yy)
  FreeImage(temporary_image_ID)
  ProcedureReturn result
EndMacro

; Used for PB function universal output
Procedure DrawRotatedText_Canvas_BF(mode, canvas_ID, texture_ID, font_ID,
                                    x,     ; Output x
                                    y,     ; Output y
                                    text$, ; Text
                                    arc,   ; Arc                                     
                                           ; Ignore font = -1
  
  common_before_BF
  
  StartDrawing(ImageOutput(temporary_image_ID)) ; Set here the PB graphic function for using - Set ever this defined color
  If font_ID<>-1
    DrawingFont(font_ID)
  EndIf
  DrawRotatedText(x, y, text$, arc, temporary_color)
  StopDrawing()
  
  common_after_BF
EndProcedure 

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

CompilerIf #PB_Compiler_Version=>560
  canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height, #PB_Canvas_Container)
CompilerElse
  canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)
CompilerEndIf

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1_ID=LoadFont(1, "Arial", 11)
CompilerEndIf

StartDrawing(CanvasOutput(canvas_ID))
Box(0, 0, canvas_width, canvas_height, 0) ; Black preset for the canvas
Circle(100, 100, 125, $AA)
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1_ID)
CompilerEndIf
DrawText(20, 5, "A VERY COOL FUNCTION", $FF00)
DrawText(20, 25, "BUCKET FILL ADVANCED", $FF00)
DrawText(20, 45, "WITH FLOOD FILL FUNCTION", $FF00)
DrawText(20, 65, "www.quick-aes-256.de", $FF00)
DrawText(20, 85, "www.nachtoptik.de", $FF00)
RoundBox (185, 80, 100 , 310 , 20, 20, $A2AAAA)
Box (30, 200, 128 , 128, $A3AAAA)
Circle(780, 80, 160, $A4AAAA)
Circle(880, 200, 80, $FE)
Circle(730, 205, 60, $FFF)
StopDrawing()

If StartVectorDrawing(CanvasVectorOutput(canvas_ID))
  VectorSourceColor($FF000001)
  MovePathCursor (470 , 250)
  AddPathCircle (470 , 250 , 160, 0, 235 , #PB_Path_Connected)
  FillPath()
  StopVectorDrawing()
EndIf
StopDrawing()

ActivateFloodArray_BF(1)

; - Call function #1 -
path$=SoilWall$
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID)
ErrorCheck_BF(result) 

; - Call function #2 -
path$=RustySteel$
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          0,
          35)
ErrorCheck_BF(result)

; - Call function #3 -
path$=Background$
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          376,
          121)
ErrorCheck_BF(result)

; - Manipulate the BucketFill output color -
Define x, y, color, new_color
Define *array=GetBucketArray_Adress_BF() ; - Demo for directly access a arrey
Define gadget_height_1=GadgetHeight(canvas_ID)
StartDrawing(CanvasOutput(canvas_ID)) 
color=Point(370, 120) ; As sample
new_color=$0FFF00     ; As sample
For y=GetBucket_Y_BF() To GetBucket_YY_BF()-123
  For x=GetBucket_X_BF() To GetBucket_XX_BF()
    If PeekI(*array+(gadget_height_1*x+y)*8) ; Read the array - Demo for directly access a arrey
      Point(x, y)
      If ColorDistance_BF(point, color)<30 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, new_color, 50)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

SetColorDistanceFill_BF(20)
SetColor_BF($FF00FF)

; - Call function #4 -
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
RotateImage_BF(90, texture_ID)
result=BF(-2, canvas_ID, texture_ID,
          30,
          200,
          30,
          200,
          128,
          128)
ErrorCheck_BF(result)
SetColorDistanceFill_BF(0)

; - Call function #5 -
path$=Clouds$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 80, 80)
result=BF(-2, canvas_ID, texture_ID,
          30,
          202,
          30,
          200)
ErrorCheck_BF(result)

SetColorDistanceSpriteMask_BF(30)

; - Call function #6 -
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
result=RotateSprite_BF(texture_ID,
                       0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1                        
                       0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                       -15) ; Rotating degree
ErrorCheck_BF(result)

result=BF(1, canvas_ID, texture_ID,
          0,   
          0,  
          450, 
          30, 
          ImageWidth(texture_ID),
          ImageHeight(texture_ID))
ErrorCheck_BF(result)

SetColorDistanceSpriteMask_BF(0)

; - Call function #7 -
path$=SoilWall$
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          462,
          11)
ErrorCheck_BF(result)

; - Call function #8 -
path$=Alpha$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 80) ; Sprite mode
result=BF(1, canvas_ID, texture_ID,
          0,                                   
          0,                                 
          450,                           
          160,                             
          100,                           
          80)
ErrorCheck_BF(result)

; - Call function #09 -
path$=GeeBee$
texture_ID=LoadImage(#PB_Any, path$)
result=RotateSprite_BF(texture_ID,
                       0,  ; Grab transparence color from sprite pos x - For preset set ..x=-1                     
                       0,  ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                       30) ; Rotating degree
ErrorCheck_BF(result)

ResizeImage(texture_ID, 50, 50) ; Sprite mode
SetColorDistanceSpriteMask_BF(30)
result=BF(1, canvas_ID, texture_ID,
          0,                                   
          0,                                 
          340,                           
          230,                             
          200,                           
          150)
ErrorCheck_BF(result)

SetColorDistanceSpriteMask_BF(0)

; - Call function #10 -
path$=Clouds$
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          750,                                   
          302,                                 
          600,                           
          50,                             
          300,                           
          400)
ErrorCheck_BF(result)

; - Call function #11 -
path$=Cat_02$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 470, 700)
result=BF(-2, canvas_ID, texture_ID,
          750,                                   
          10,                                 
          590,                           
          -10,                             
          3000,                           
          3000,
          -120,
          150)
ErrorCheck_BF(result)

StartDrawing(CanvasOutput(canvas_ID))
RoundBox (185, 60, 140 , 290 , 20, 20, $A2AAAA)
RoundBox (800, 250, 100 , 150 , 20, 20, $FF)
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1_ID)
CompilerEndIf
DrawText(630, 124, "All features combinable", 0)
StopDrawing()

; - Call function #12 -
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 280, 330)
result=BF(-2, canvas_ID, texture_ID,
          185,
          200,
          110,
          60)
ErrorCheck_BF(result)

; - Call function #13 -
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 140, 200)
result=BF(-100, canvas_ID, texture_ID,
          800,
          270,
          90,
          40)
ErrorCheck_BF(result)

SetColorDistanceSpriteMask_BF(30)
SetColor_BF($FF00FF)

; - Call function #14 -
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
result=BF(120, canvas_ID, texture_ID,
          0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
          0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
          530, ; x  coordinate sprite output
          120, ; y  coordinate sprite output
          128, ; xx coordinate sprite output - More results more sprites in a row - horizontal
          128) ; yy coordinate sprite output - More results more sprites in a row - vertical
ErrorCheck_BF(result)
SetColorDistanceSpriteMask_BF(0)
SetColor_BF(-1)

; - Call function #15 -
Define texture_1=CreateImage(#PB_Any, 200, 220)
StartDrawing(ImageOutput(texture_1))
RoundBox (0, 0, 100 , 120 , 20, 20, $A2AAAA)
StopDrawing()
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 120)
result=BF(-2, texture_1, texture_ID,
          0,
          100,
          0, 
          0,
          100,
          120)
ErrorCheck_BF(result)

result=BF(100, canvas_ID, texture_1,
          0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
          0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
          590, ; x  coordinate sprite output
          0,   ; y  coordinate sprite output
          100, ; xx coordinate sprite output - More results more sprites in a row - horizontal
          120) ; yy coordinate sprite output - More results more sprites in a row - vertical
ErrorCheck_BF(result)

; - Call function #16 -
Define texture_1=CreateImage(#PB_Any, 200, 220)
StartDrawing(ImageOutput(texture_1))
RoundBox (0, 0, 100 , 140 , 20, 20, $FF00)
StopDrawing()
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 120)
result=BF(-100, texture_1, texture_ID,
          0,
          100,
          0,
          0,
          100,
          120)
ErrorCheck_BF(result)

result=BF(100, canvas_ID, texture_1,
          0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
          0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
          43,  ; x  coordinate sprite output
          105, ; y  coordinate sprite output
          100, ; xx coordinate sprite output - More results more sprites in a row - horizontal
          90)  ; yy coordinate sprite output - More results more sprites in a row - vertical
ErrorCheck_BF(result)
Free_selected_Texture_BF(texture_1)

; - Call function #17 -
Define texture_1=CreateImage(#PB_Any, 100, 120)
StartDrawing(ImageOutput(texture_1))
Box (0, 0, 100 , 120, $FF)
StopDrawing()
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 120)
result=BF(-100, texture_1, texture_ID,
          0,
          100,
          0,
          0,
          100,
          120)
ErrorCheck_BF(result)

result=BF(100, canvas_ID, texture_1,
          0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
          0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
          340, ; x  coordinate sprite output
          10,  ; y  coordinate sprite output
          100, ; xx coordinate sprite output - More results more sprites in a row - horizontal
          120) ; yy coordinate sprite output - More results more sprites in a row - vertical
ErrorCheck_BF(result)
Free_selected_Texture_BF(texture_1)

; - Call function #18 -
Define texture_1=CreateImage(#PB_Any, 80, 160)
StartDrawing(ImageOutput(texture_1))
Box (0, 0, 80 , 160, $00FF00)
StopDrawing()
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 80, 160)
result=BF(-120, texture_1, texture_ID,
          0,
          100,
          0,
          0,
          80,
          160)
ErrorCheck_BF(result)

result=BF(1, canvas_ID, texture_1,
          0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
          0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
          351, ; x  coordinate sprite output
          140, ; y  coordinate sprite output
          80,  ; xx coordinate sprite output - More results more sprites in a row - horizontal
          160) ; yy coordinate sprite output - More results more sprites in a row - vertical
ErrorCheck_BF(result)

StartDrawing(CanvasOutput(canvas_ID))
RoundBox (640, 250, 140 , 150 , 20, 20, $A7AAAA)
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1_ID)
CompilerEndIf
DrawText(250, 0, "THIS IS A OUTPUT DIRECTLY ON CANVAS !", -1)
DrawText(355, 380, "You can combine Sprites, Textures, Flood Fill and Bucket Fill, how ever you want", -1)
DrawText(760, 232, "Texture FLOODFILL")
StopDrawing()

; - Call function #19 -
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 60, 75)
result=BF(-2, canvas_ID, texture_ID,
          640,
          300,
          110,
          25)
ErrorCheck_BF(result)

; - BF DrawRotatedText #1 -
Define path$=Caisse$
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=1
Define font_2_ID=LoadFont(2, "Georgia",  120)

result=DrawRotatedText_Canvas_BF(0, canvas_ID, texture_ID, font_2_ID,
                                 235, ; Output x
                                 -10, ; Output y
                                 "B", ; Text
                                 0,   ; Arc
                                 0,   ; Startposition texture output x   - Preset 0
                                 0,   ; Startposition texture output y   - Preset 0
                                 0,   ; Endposition texture output xx    - Preset 0 = Full available width
                                 0,   ; Endposition texture output yy    - Preset 0 = Full available height
                                 15,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                                 15,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                                 15,  ; Endposition inside the texture   - Preset 0 (Texture clipping)
                                 15)  ; Endposition inside the texture   - Preset 0 (Texture clipping)
                                      ; Ignore font = -1
ErrorCheck_BF(result)

; - BF DrawRotatedText #2 -
Define path$=RustySteel$
Define texture_ID=LoadImage(#PB_Any, path$)
result=DrawRotatedText_Canvas_BF(1, canvas_ID, texture_ID, font_2_ID,
                                 530, ; Output x
                                 235, ; Output y
                                 "F", ; Text
                                 0)   ; Arc
ErrorCheck_BF(result)

; - FloodFill #1 -
path$=Caisse$
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(2, canvas_ID, texture_ID,
                    850, ; x pos
                    180, ; y pos
                    10,  ; Startposition texture output x
                    10,  ; Startposition texture output y
                    0,   ; Endposition texture output xx
                    0,   ; Endposition texture output yy
                    0,   ; Startposition inside the texture x
                    0,   ; Startposition inside the texture y
                    30,  ; Endposition inside the texture xx
                    30)  ; Endposition inside the textur
ErrorCheck_BF(result)

; - Manipulate the FloodFill output color -
Define x, y, color, new_color
Define *array=GetFloodArray_Adress_BF() ; - Demo for directly access a arrey
Define gadget_height_1=GadgetHeight(canvas_ID)
StartDrawing(CanvasOutput(canvas_ID))
color=Point(895, 195) ; As sample
new_color=$FFFF       ; As sample
For y=GetFlood_Y_BF() To GetFlood_YY_BF()
  For x=GetFlood_X_BF() To GetFlood_XX_BF()
    If PeekI(*array+(gadget_height_1*x+y)*8) ; Read the array - Demo for directly access a arrey
      point=Point(x, y)
      If ColorDistance_BF(point, color)<25 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, new_color, 50)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
For y=GetFlood_Y_BF() To GetFlood_YY_BF()-70
  For x=GetFlood_X_BF() To GetFlood_XX_BF() ; Also you can reduce the xx coordinate
    If PeekI(*array+(gadget_height_1*x+y)*8); Read the array
      point=Point(x, y)
      If ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, $FF0000, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

; - FloodFill #2 -
path$=Caisse$
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(2, canvas_ID, texture_ID,
                    730, ; x pos
                    190, ; y pos
                    10,  ; Startposition texture output x
                    10,  ; Startposition texture output y
                    0,   ; Endposition texture output xx
                    0,   ; Endposition texture output yy
                    0,   ; Startposition inside the texture x
                    0,   ; Startposition inside the texture y
                    30,  ; Endposition inside the texture xx
                    30)  ; Endposition inside the textur
ErrorCheck_BF(result)

; - Manipulate the FloodFill output color -
Define x, y, color, new_color
; Define *array=GetFloodArray_Adress_BF() ; - Demo for directly access a arrey
; Define gadget_height_1=GadgetHeight(canvas_ID)
StartDrawing(CanvasOutput(canvas_ID))
color=Point(740, 180) ; As sample
new_color=$0FFF00     ; As sample
For y=GetFlood_Y_BF() To GetFlood_YY_BF()-60
  For x=GetFlood_X_BF() To GetFlood_XX_BF()
    ; If PeekI(*array+(gadget_height_1*x+y)*8) ; Read the array - Demo for directly access a arrey
    If GetFloodArray_Point_BF(x, y) ; Read the array
      point=Point(x, y)
      If ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, new_color, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
For y=GetFlood_Y_BF()+40 To GetFlood_YY_BF()
  For x=GetFlood_X_BF()+70 To GetFlood_XX_BF()
    If GetFloodArray_Point_BF(x, y) ; Read the array
      point=Point(x, y)
      If ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, $008CFF, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

Define xx=301 ; Output x pos ButtonImageGadget
Define yy=276 ; Output y pos ButtonImageGadget

HideWindow(window_ID, 0)

; - Embedding photo #1
path$=Cat_03$
texture_ID=LoadImage(#PB_Any, path$)

; For canvas
result=PhotoBrush_canvas_BF(2, canvas_ID, texture_ID,
                            40,  ; Output pos x
                            330, ; Output pos y
                            120, ; Texture or image width
                            160, ; Texture or image height
                            95,  ; Visibility - percent
                            40)  ; Delay for animation) 
ErrorCheck_BF(result)

; - BF color button #1 -
While WindowEvent() : Wend
CompilerIf #PB_Compiler_Version=>560
  Delay(300)
  Define button_width=190
  Define button_height=55
  Define texture_1_ID=CreateImage(#PB_Any, button_width, button_height)
  Define button_image_gadget_ID=ButtonImageGadget(#PB_Any, xx, yy, button_width, button_height, ImageID(texture_1_ID))
  Define background_color=$FF
  Define delay=7
  Define visibility_factor=100 
  Define seamless_shrink_factor=3
  Define mode=2
  
  If StartDrawing(ImageOutput(texture_1_ID))
    Box(0, 0, button_width, button_height, $FFFF)
    CompilerIf #PB_Compiler_OS=#PB_OS_Linux
      DrawingFont(font_1_ID)
    CompilerEndIf
    CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
      DrawText(53, 22, "BF image button", 0, $FFFF)
    CompilerElse
      DrawText(45, 19, "BF image button", 0, $FFFF)
    CompilerEndIf
    StopDrawing() 
  EndIf
  
  ; Tousends of different animations available
  result=ButtonImageGadget_BF(mode, button_image_gadget_ID, texture_1_ID, ; mode=1, little seamless edges - mode=2 large seamless edges
                              background_color,                           ; Background color 
                              visibility_factor,                          ; Visibility factor - Available from 1 to 100
                              seamless_shrink_factor,                     ; Reduce this value for larger pictures (=>300 max x or y =1)
                              delay)                                      ; Delay for color animation
  ErrorCheck_BF(result)
  
  ;  The seamless halo reduce the visibility on little buttons,
  ;  so you must use a larger seamless_shrink_factor for little buttons (available from 1 to 50) 
CompilerEndIf

; - Sprite animation #1 - CSS sprite sheet demo -
Define x, y, yyy, frame, frame_1, alpha=-256

path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)

path$=Hound_1$
Define sheet_ID=LoadImage(#PB_Any, path$)

path$=Rose$
Define texture_1_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_1_ID, 150, 110)

path$=Bird$
Define bird_ID=LoadImage(#PB_Any, path$)

y=500 : yyy=500

Create_animation_buffers_image_BF(canvas_ID) ; Init animation buffers - Double buffering - Flicker free animation

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Free_animation_buffers_canvas_BF() ; Free animation buffers
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0 - 100 timer available 0 - 99 - you can change
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    SetColorDistanceSpriteMask_BF(25)
    
    ; - Rotate sprite #1 -
    Define texture_2_ID=CopyImage(texture_1_ID, #PB_Any)
    result=RotateSprite_BF(texture_2_ID,
                           0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1                    
                           0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                           arc, ; Rotating degree
                           0,   ; mode=0 create a exactely resized sprite with minimized mask - mode=1 create a quadratic sprite for on demand rotation 
                           0,   ; Rotating offset x - For mode 1 - Handle with care - Do not make offsets too big - I will give you not a limit
                           0)   ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50
                                ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                ; So you can also simple create masked rotated sprites from all images without mask
                                ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
    ErrorCheck_BF(result)
    
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
              0,   
              0,  
              170+GetSprite_X_BF(), ; Get correction rotation x
              yyy+GetSprite_Y_BF(), ; Get correction rotation y
              ImageWidth(texture_2_ID),
              ImageHeight(texture_2_ID))
    ErrorCheck_BF(result)
    Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    yyy-1 : arc+1 : If arc>359 : arc=0 : EndIf
    If yyy<-180
      yyy=GadgetHeight(canvas_ID)
    EndIf
    
    SetColorDistanceSpriteMask_BF(0)
    
    ; - Call CSS #1 -
    result=Sprite_CSS_sheet_BF(1, Get_animation_buffer_hidden_ID_image_BF(), sheet_ID,
                               0,     ; Grab transparence color from sheet pos x - Set to -1 for output without invisible color 
                               0,     ; Grab transparence color from sheet pos y - You can set x or y, or both parameters to -1 
                               x,     ; Output position x
                               y,     ; Output position y
                               7,     ; Numbers of frames
                               frame, ; Selected frame
                               145,   ; Frame width
                               72,    ; Frame height
                               3)     ; Frames in a row  
    ErrorCheck_BF(result)
    
    ; - Call CSS #2 -
    result=Sprite_CSS_sheet_simple_BF(-alpha, Get_animation_buffer_hidden_ID_image_BF(), bird_ID,
                                            0,       ; Grab transparence color from sprite pos x - For preset set ..x=-1   
                                            0,       ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF
                                            443,     ; Output position x
                                            20,      ; Output position y
                                            10,      ; Numbers of frames
                                            frame_1, ; Selected frame
                                            600,     ; Frame width
                                            413,     ; Frame height
                                            3,       ; Frames in a row  
                                            140,     ; Output width
                                            90,      ; Output height
                                            0,       ; Clip x
                                            100,     ; Clip y
                                            550,     ; Clip xx
                                            0)       ; Clip yy
    ErrorCheck_BF(result)
    
    If Delay_BF(1, 70) ; Timer 1 - 100 timer available 0 - 99 - you can change
      frame+1 : If frame=7 : frame=0 : EndIf
      frame_1+1 : If frame_1=10 : frame_1=0 : EndIf 
      x+5 : y-3 : alpha+1
      If alpha>0 : alpha=0 : EndIf
      If x>GadgetWidth(canvas_ID)
        x=-145
      EndIf
      If y<-72
        y=GadgetHeight(canvas_ID)
      EndIf
    EndIf
  EndIf
  
  CompilerIf #PB_Compiler_Version=>560
    CompilerIf #PB_Compiler_OS<>#PB_OS_Linux
      
      If Delay_BF(2, 15) ; Timer 0, Time 50 ms - 100 timer available 0 - 99 - you can change
        
        ResizeGadget(button_image_gadget_ID, xx, yy, #PB_Ignore, #PB_Ignore) ; Move Button Gadget
        
        xx+1
        If xx>GadgetWidth(canvas_ID)
          xx=-GadgetWidth(button_image_gadget_ID)
        EndIf
      EndIf
    CompilerEndIf
  CompilerEndIf
  
  ; Get the result
  CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
  
ForEver
