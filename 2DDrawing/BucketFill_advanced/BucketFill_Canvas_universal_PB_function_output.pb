XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Universal output - with alpha blending and textures - directly on images or canvas -
; - This code is for using simplest all PB graphic features which can make a monochrome output
; - And it fix the ugly edge problem with vector drawing output

; mode= 1 - Standard preset texture mode
; mode= 2 > 256 - Texture mode with mode blending - 2=full visible - 256=invisible (BF specific)
; mode=-1   Ignore a texture and use a color - Set as texture_ID a color, as sample $FFFF00 
; mode=-2 > -256 - Ignore a texture and use a color - With mode blending 2=full visible - 256=invisible (BF specific) 

UsePNGImageDecoder()
UseJPEGImageDecoder()

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define win_event, canvas_ID, window_ID, texture_ID
Define canvas_width, canvas_height, point,texture_clip_x, texture_clip_y, texture_clip_xx, texture_clip_yy
Define canvas_x, canvas_y, temporary_image_ID, mode, result
Define texture_x, texture_y, texture_width, texture_height
Define path$

#SoilWall="./BucketFill_Image_Set/soil_wall.jpg"
#RustySteel="./BucketFill_Image_Set/RustySteel.jpg"
#Caisse="./BucketFill_Image_Set/Caisse.png"
#Background="./BucketFill_Image_Set/Background.bmp"
#Clouds="./BucketFill_Image_Set/Clouds.jpg"
#Hubble="./BucketFill_Image_Set/Hubble.jpg"
#Cat="./BucketFill_Image_Set/Cat_02.jpg"

; Presets
canvas_x=50
canvas_y=50
canvas_width=1100
canvas_height=700

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height) ; Create a canvas for output

; ===========================================================================================  
; Call function #1 - Make a Background with BF advanced
; ===========================================================================================  
path$=#Background
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID) ; Make a Background texture
ErrorCheck_BF(result)

; ===========================================================================================  
; Advertisement
; ===========================================================================================
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_0_ID=LoadFont(0, "Arial", 11)
CompilerEndIf
StartDrawing(CanvasOutput(canvas_ID))
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_0_ID)
CompilerEndIf
DrawingMode(#PB_2DDrawing_Transparent)
DrawText(20, 5, "A VERY COOL FUNCTION !", -1)
DrawText(20, 25, "BUCKET FILL ADVANCED", -1)
DrawText(20, 45, "www.quick-aes-256.de", -1)
DrawText(20, 65, "www.nachtoptik.de", -1)
DrawText(220, 5, "Sprites simple for images and canvas", -1)
DrawText(220, 25, "Also FloodFill with texture support", -1)
DrawText(220, 45, "Alpha blending for canvas", -1)
DrawText(500, 5, "Flicker free animations for canvas"+Space(7)+"This is a output directly on canvas !", -1)
DrawText(20, 680, "A phantastic feature - BucketFill advanced can output all PB graphic functions, with textures, images, photos - On images and canvas - with alpha blending", -1)
StopDrawing()

; ===========================================================================================  
; Needed macros
; =========================================================================================== 

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
  ; If mode>0 : mask_color=SearchUnusedColor_BF(texture_ID, 0, 0, ImageWidth(texture_ID)-1, ImageHeight(texture_ID)-1, 5) : EndIf
  ; If mask_color<1 : mask_color=Random($FFFFFE, 1) : EndIf ; Fuse - Error handling for automatic mask color generating
  
  Protected temporary_color=mask_color+1 ; Change this line not
  Protected temporary_image_ID=CreateImage(#PB_Any, GadgetWidth(canvas_ID), GadgetHeight(canvas_ID), 24, mask_color) ; Create a temporary image
EndMacro

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

; ===========================================================================================  
; AddPathEllipse canvas - output- Procedure
; ===========================================================================================  
Procedure AddPathEllipse_Canvas_BF(mode, canvas_ID, texture_ID,
                                   x.d,              ; Output x
                                   y.d,              ; Output y
                                   radius_x.d,       ; Radius x
                                   radius_y.d,       ; Radius y
                                   starting_angle.d, ; Starting angle
                                   end_angle.d,      ; End angle
                                   rotate_angle,     ; Rotate angle
                                   
  common_before_BF
  
  StartVectorDrawing(ImageVectorOutput(temporary_image_ID)) ; Set here the PB graphic function for using - Set ever this defined color
  VectorSourceColor(temporary_color|$FF000000)
  MovePathCursor(x , y)
  RotateCoordinates (x, y, rotate_angle)
  AddPathEllipse(x , y , radius_x, radius_y, starting_angle, end_angle , #PB_Path_Connected)
  FillPath()
  StopVectorDrawing()
  
  common_after_BF
EndProcedure

; ===========================================================================================  
; AddPathCircle canvas - output- Procedure
; ===========================================================================================  
Procedure AddPathCircle_Canvas_BF(mode, canvas_ID, texture_ID,
                                  x.d,              ; Output x
                                  y.d,              ; Output y
                                  radius.d,         ; Radius
                                  starting_angle.d, ; Starting angle
                                  end_angle.d,      ; End angle
                                  
  common_before_BF
  
  StartVectorDrawing(ImageVectorOutput(temporary_image_ID)) ; Set here the PB graphic function for using - Set ever this defined color
  VectorSourceColor(temporary_color|$FF000000)
  MovePathCursor(x , y)
  AddPathCircle(x , y , radius, starting_angle, end_angle , #PB_Path_Connected)
  FillPath()
  StopVectorDrawing()
  
  common_after_BF
EndProcedure

; ===========================================================================================  
; Ellipse - Image output - Procedure
; =========================================================================================== 
Procedure Ellipse_Canvas_BF(mode, canvas_ID, texture_ID,
                            x,        ; Output x
                            y,        ; Output y
                            radius_x, ; Radius x
                            radius_y, ; Radius y
                            
  common_before_BF
  
  StartDrawing(ImageOutput(temporary_image_ID)) ; Set here the PB graphic function for using - Set ever this defined color
  Ellipse(x, y, radius_x, radius_y, temporary_color)
  StopDrawing()
  
  common_after_BF
EndProcedure

; ===========================================================================================  
; RoundBox - Image output - Procedure
; =========================================================================================== 
Procedure RoundBox_Canvas_BF(mode, canvas_ID, texture_ID,
                             x,       ; Output x
                             y,       ; Output y
                             width,   ; Width
                             height,  ; Height
                             curve_x, ; curve_x
                             curve_y, ; curve_y 
                             
  common_before_BF
  
  StartDrawing(ImageOutput(temporary_image_ID)) ; Set here the PB graphic function for using - Set ever this defined color
  RoundBox(x, y, width, height, curve_x, curve_y, temporary_color)
  StopDrawing()
  
  common_after_BF
EndProcedure

; ===========================================================================================  
; Box - Image output - Procedure
; =========================================================================================== 
Procedure Box_Canvas_BF(mode, canvas_ID, texture_ID,
                        x,      ; Output x
                        y,      ; Output y
                        width,  ; Width
                        height, ; Height
                        
  common_before_BF
  
  StartDrawing(ImageOutput(temporary_image_ID)) ; Set here the PB graphic function for using - Set ever this defined color
  Box(x, y, width, height, temporary_color)
  StopDrawing()
  
  common_after_BF
EndProcedure

; ===========================================================================================  
; DrawRotatedText - Image output - Procedure
; =========================================================================================== 
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

; ########################################################################################### 
; Call the created BF functions, now
; ###########################################################################################

; ===========================================================================================  
; AddPathEllipse - Call
; ===========================================================================================  
Define path$=#Clouds
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=80

result=AddPathEllipse_Canvas_BF(mode, canvas_ID, texture_ID,
                                820,             ; Output x
                                115,             ; Output y
                                350,             ; Radius x
                                75,              ; Radius y
                                0,               ; Starting angle
                                270,             ; End angle
                                0,               ; Rotate angle
                                texture_x,       ; Startposition texture output x   - Preset 0
                                texture_y,       ; Startposition texture output y   - Preset 0
                                texture_width,   ; Endposition texture output xx    - Preset 0 = Full available width
                                texture_height,  ; Endposition texture output yy    - Preset 0 = Full available height
                                texture_clip_x,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                                texture_clip_y,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                                texture_clip_xx, ; Endposition inside the texture   - Preset 0 (Texture clipping)
                                texture_clip_yy) ; Endposition inside the texture   - Preset 0 (Texture clipping)
ErrorCheck_BF(result)

; ===========================================================================================  
; AddPathCircle - Call
; ===========================================================================================  
Define path$=#Hubble
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=120

result=AddPathCircle_Canvas_BF(mode, canvas_ID, texture_ID,
                               690,             ; Output x
                               350,             ; Output y
                               320,             ; Radius
                               0,               ; Starting angle
                               235,             ; End angle
                               texture_x,       ; Startposition texture output x   - Preset 0
                               texture_y,       ; Startposition texture output y   - Preset 0
                               texture_width,   ; Endposition texture output xx    - Preset 0 = Full available width
                               texture_height,  ; Endposition texture output yy    - Preset 0 = Full available height
                               texture_clip_x,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                               texture_clip_y,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                               texture_clip_xx, ; Endposition inside the texture   - Preset 0 (Texture clipping)
                               texture_clip_yy) ; Endposition inside the texture   - Preset 0 (Texture clipping)
ErrorCheck_BF(result)

; ===========================================================================================  
; AddPathCircle - Call
; ===========================================================================================  
Define texture_ID=$FF0000
Define mode=-150

result=AddPathCircle_Canvas_BF(mode, canvas_ID, texture_ID,
                               980,             ; Output x
                               640,             ; Output y
                               150,             ; Radius
                               250,             ; Starting angle
                               25,              ; End angle
                               texture_x,       ; Startposition texture output x   - Preset 0
                               texture_y,       ; Startposition texture output y   - Preset 0
                               texture_width,   ; Endposition texture output xx    - Preset 0 = Full available width
                               texture_height,  ; Endposition texture output yy    - Preset 0 = Full available height
                               texture_clip_x,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                               texture_clip_y,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                               texture_clip_xx, ; Endposition inside the texture   - Preset 0 (Texture clipping)
                               texture_clip_yy) ; Endposition inside the texture   - Preset 0 (Texture clipping)
ErrorCheck_BF(result)

; ===========================================================================================  
; Ellipse - Call
; ===========================================================================================  
Define path$=#Hubble
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=1

result=Ellipse_Canvas_BF(mode, canvas_ID, texture_ID,
                         270,             ; Output x
                         370,             ; Output y
                         240,             ; Radius x
                         305,             ; Radius y
                         texture_x,       ; Startposition texture output x   - Preset 0
                         texture_y,       ; Startposition texture output y   - Preset 0
                         texture_width,   ; Endposition texture output xx    - Preset 0 = Full available width
                         texture_height,  ; Endposition texture output yy    - Preset 0 = Full available height
                         texture_clip_x,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                         texture_clip_y,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                         texture_clip_xx, ; Endposition inside the texture   - Preset 0 (Texture clipping)
                         texture_clip_yy) ; Endposition inside the texture   - Preset 0 (Texture clipping)
ErrorCheck_BF(result)

; ===========================================================================================  
; RoundBox - Call
; ===========================================================================================  
Define path$=#Cat
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=1

result=RoundBox_Canvas_BF(mode, canvas_ID, texture_ID,
                          760,             ; Output x
                          200,             ; Output y
                          309,             ; Width
                          230,             ; Height
                          15,              ; Curve x
                          15,              ; Curve y
                          587,             ; Startposition texture output x   - Preset 0
                          -10,             ; Startposition texture output y   - Preset 0
                          texture_width,   ; Endposition texture output xx    - Preset 0 = Full available width
                          texture_height,  ; Endposition texture output yy    - Preset 0 = Full available height
                          texture_clip_x,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                          texture_clip_y,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                          texture_clip_xx, ; Endposition inside the texture   - Preset 0 (Texture clipping)
                          texture_clip_yy) ; Endposition inside the texture   - Preset 0 (Texture clipping)
ErrorCheck_BF(result)

; ===========================================================================================  
; RoundBox - Call
; ===========================================================================================  
Define path$=#Hubble
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=80

result=RoundBox_Canvas_BF(mode, canvas_ID, texture_ID,
                          -100,            ; Output x
                          450,             ; Output y
                          320,             ; Width
                          200,             ; Height
                          15,              ; Curve x
                          15,              ; Curve y
                          -360,            ; Startposition texture output x   - Preset 0
                          310,             ; Startposition texture output y   - Preset 0
                          texture_width,   ; Endposition texture output xx    - Preset 0 = Full available width
                          texture_height,  ; Endposition texture output yy    - Preset 0 = Full available height
                          texture_clip_x,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                          texture_clip_y,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                          texture_clip_xx, ; Endposition inside the texture   - Preset 0 (Texture clipping)
                          texture_clip_yy) ; Endposition inside the texture   - Preset 0 (Texture clipping)
ErrorCheck_BF(result)

; ===========================================================================================  
; Box - Call
; ===========================================================================================  
Define path$=#Cat
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=80
ResizeImage(texture_ID, ImageWidth(texture_ID)/5, ImageHeight(texture_ID)/5)

result=Box_Canvas_BF(mode, canvas_ID, texture_ID,
                     20,              ; Output x
                     80,              ; Output y
                     140,             ; Width
                     230,             ; Height
                     0,               ; Startposition texture output x   - Preset 0
                     97,              ; Startposition texture output y   - Preset 0
                     texture_width,   ; Endposition texture output xx    - Preset 0 = Full available width
                     400,             ; Endposition texture output yy    - Preset 0 = Full available height
                     texture_clip_x,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                     texture_clip_y,  ; Startposition inside the texture - Preset 0 (Texture clipping)
                     texture_clip_xx, ; Endposition inside the texture   - Preset 0 (Texture clipping)
                     texture_clip_yy) ; Endposition inside the texture   - Preset 0 (Texture clipping)
ErrorCheck_BF(result)

; ===========================================================================================  
; DrawRotatedText - Call
; ===========================================================================================  
Define path$=#Caisse
Define texture_ID=LoadImage(#PB_Any, path$)
Define mode=1
Define font_ID=LoadFont(1, "Arial",  200)

result=DrawRotatedText_Canvas_BF(mode, canvas_ID, texture_ID, font_ID,
                                 465,            ; Output x
                                 -25,            ; Output y
                                 "Hello",        ; Text
                                 0,              ; Arc
                                 texture_x,      ; Startposition texture output x   - Preset 0
                                 texture_y,      ; Startposition texture output y   - Preset 0
                                 texture_width,  ; Endposition texture output xx    - Preset 0 = Full available width
                                 texture_height, ; Endposition texture output yy    - Preset 0 = Full available height
                                 15,             ; Startposition inside the texture - Preset 0 (Texture clipping)
                                 15,             ; Startposition inside the texture - Preset 0 (Texture clipping)
                                 15,             ; Endposition inside the texture   - Preset 0 (Texture clipping)
                                 15)             ; Endposition inside the texture   - Preset 0 (Texture clipping)
                                                 ; Ignore font = -1
ErrorCheck_BF(result)

; ===========================================================================================  
; Output the result
; ===========================================================================================  

HideWindow(window_ID, 0) ; Show the window, now

Repeat
  win_event=WaitWindowEvent()
  If win_event=#PB_Event_CloseWindow
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
ForEver
