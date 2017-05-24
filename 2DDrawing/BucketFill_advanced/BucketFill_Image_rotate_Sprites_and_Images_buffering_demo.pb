XIncludeFile("./BucketFill_advanced.pbi")

;- Rotating demo - Rotate sprites and images - Double buffering demo

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define window_0, win_event, canvas_ID, window_ID, texture_ID, result, x=-100, xx=-100
Define canvas_x, canvas_y, canvas_width, canvas_height, point, arc
Define path$

Define SoilWall$="./BucketFill_Image_Set/soil_wall.jpg"
Define Cat_03$="./BucketFill_Image_Set/Cat_03.jpg"
Define Rose$="./BucketFill_Image_Set/Rose.jpg"

; Presets
canvas_x=50
canvas_y=50
canvas_width=600
canvas_height=400

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)

HideWindow(window_ID, 0)

path$=Rose$
Define texture_ID=LoadImage(#PB_Any, path$)

path$=SoilWall$
Define image_ID=LoadImage(#PB_Any, path$)

Create_animation_buffers_image_BF(canvas_ID) ; Init animation buffers - Double buffering - Flicker free animation

; - Call function #1 -
result=BF(-2, Get_animation_buffer_background_ID_image_BF(), image_ID)
ErrorCheck_BF(result) 

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1_ID=LoadFont(1, "Arial", 11)
CompilerEndIf

StartDrawing(ImageOutput(Get_animation_buffer_background_ID_image_BF()))
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1_ID)
CompilerEndIf
DrawText(20, 5, "A VERY COOL FUNCTION", -1)
DrawText(20, 25, "BUCKET FILL ADVANCED", -1)
DrawText(20, 45, "WITH FLOOD FILL FUNCTION", -1)
DrawText(20, 65, "www.quick-aes-256.de", -1)
DrawText(20, 85, "www.nachtoptik.de", -1)
StopDrawing()

Define mode=1               ; mode=1 create a exactely resized sprite with minimized mask - Centered with offsets - Do not make offsets too big - Bigger = slower
                            ; mode=2 create a exactely resized sprite with minimized mask - Centered
                            ; mode=3 create a exactely resized sprite with minimized mask - Left-aligned
Define image_get_color_x=0  ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
Define image_get_color_y=0  ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF     
Define output_pos_x=-20     ; Output pos x
Define output_pos_y=-50     ; Output pos y
Define arc                  ; Rotating degree
Define alpha=30             ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible (BF specific)
Define output_width=230     ; You can here resize the output x
Define output_height=160    ; You can here resize the output y
Define rotating_offset_x=60 ; Rotating offset x - For mode 1 - Handle with care - Do not make offsets too big - I will give you not a limit
Define rotating_offset_y=0  ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50

SetColorDistanceSpriteMask_BF(25)

NoCaching_BF(1) ; Rotating sprite change immediately the used texture, for significant speed up you can here deactivate the BF texture cache

ActivateSpriteArray_BF(2) ; Activate getting sprite coordinates for drawing a white frame

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Free_animation_buffers_image_BF() ; Free animation buffers
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 20) ; Timer 0 - 100 timer available 0 - 99 - you can change
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    result=RotateSprite_simple_BF(mode, Get_animation_buffer_hidden_ID_image_BF(), texture_ID,                              
                                                    image_get_color_x, ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                                    image_get_color_y, ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF     
                                                    output_pos_x,      ; Output pos x
                                                    output_pos_y,      ; Output pos y
                                                    arc,               ; Rotating degree
                                                    alpha,             ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible (BF specific)
                                                    output_width,      ; You can here resize the output x
                                                    output_height,     ; You can here resize the output y
                                                    rotating_offset_x, ; Rotating offset x - For mode 1 - Handle with care - Do not make offsets too big - I will give you not a limit
                                                    rotating_offset_y) ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50   
                                                                       ; mode=1 create a exactely resized sprite with minimized mask - Centered with offsets - Do not make offsets too big - Bigger = slower
                                                                       ; mode=2 create a exactely resized sprite with minimized mask - Centered
                                                                       ; mode=3 create a exactely resized sprite with minimized mask - Left-aligned
                                                                       ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                                                       ; So you can also simple create masked rotated sprites from all images without mask
                                                                       ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
                                                                       ; For images set image_get_color_x=-1 and image_get_color_y to a unused image color, best similar the background color
                                                                       ; Reduce for Images SetColorDistanceSpriteMask_BF or you can become "holes", but also nice effects
    ErrorCheck_BF(result)
    
    ; Get the sprite position and make a white frame
    If StartDrawing(ImageOutput(Get_animation_buffer_hidden_ID_image_BF())) ; 
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(GetSprite_X_BF(), GetSprite_Y_BF(), GetSprite_XX_BF()-GetSprite_X_BF()+1, GetSprite_YY_BF()-GetSprite_Y_BF()+1)
    EndIf
    StopDrawing()
    
    arc+1 : If arc>359 : arc=0 : EndIf
        
    ; Demonstrating the background buffering
    ; With CopyContent you can move contents from one buffer to a other - This sample call moves the complete output permanently in the background buffer - Use here not immediately
    ; This works more flexible as hardware sprites, you found ever in canvas_ID the complete output inclusive sprites for further processing, as sample printing
    ; CopyContent_BF(canvas_ID, Get_animation_buffer_background_ID_BF())
    
    ; As sample you can also written in the background buffer with #PB_2DDrawing_AlphaBlend , then copy the result in your output canvas
    ; So you have simple alpha blending for all PB 2D commands directly on canvas
    
    x+1 : xx+2
    If x>ImageWidth(image_ID)+100 : x=-100  : EndIf
    If xx>ImageWidth(image_ID)+100 : xx=-100 : EndIf
    StartDrawing(ImageOutput(Get_animation_buffer_background_ID_image_BF())) ; Draw in the background animation buffer
    Box(x, 120, 100 , 100, $FF+x)
    StopDrawing()
    StartDrawing(ImageOutput(Get_animation_buffer_hidden_ID_image_BF())) ; Draw in the hidden animation buffer
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    Box(xx, 200, 100, 100, $FFFF|$AA000000+xx)
    StopDrawing()
    ; This sample call moves the sprites permanently in the background buffer 
    ; CopyContent_BF(Get_animation_buffer_hidden_ID_BF(), Get_animation_buffer_background_ID_BF())
    
  EndIf
  
  ; Get the result
  CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
  
ForEver
