XIncludeFile("./BucketFill_advanced.pbi")

;- Rotating demo - RAW output - only for demonstrating -

; On your applications use the enhanced and fast special BF sprite output functions

; Hint
; You see here, BF can on demand localize the sprite output coordinates without mask
; RotateSprite_BF activate this function automatic
; For other sprite output you can activate this function so : ActivateSpriteArray_BF(2) - Deactivate again so : ActivateSpriteArray_BF(0)

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define window_0, win_event, canvas_ID, window_ID, texture_ID, result
Define canvas_x, canvas_y, canvas_width, canvas_height, point, arc
Define path$

Define SoilWall$="./BucketFill_Image_Set/soil_wall.jpg"
Define Cat_03$="./BucketFill_Image_Set/Cat_03.jpg"
Define Rose$="./BucketFill_Image_Set/Rose.jpg"

; Presets
canvas_x=50
canvas_y=50
canvas_width=830
canvas_height=520

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)

HideWindow(window_ID, 0)

path$=Rose$
Define texture_1_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_1_ID, 180,140)

path$=SoilWall$
Define image_ID=LoadImage(#PB_Any, path$)

Create_animation_buffers_image_BF(canvas_ID) ; Init animation buffers - Double buffering - Flicker free animation

; - Call function - Make a background
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
DrawText(20, 5, "HOW BF SPRITE ROTATION WORKS")
StopDrawing()

SetColorDistanceSpriteMask_BF(25)

NoCaching_BF(1) ; Rotating sprite change immediately the used texture, for significant speed up you can here deactivate the BF texture 

ActivateSpriteArray_BF(2) ; Activate getting sprite coordinates for drawing a white frame

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Free_animation_buffers_image_BF() ; Free animation buffers
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0 - 100 timer available 0 - 99 - you can change
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    ; - Call functions #1 -
    Define texture_2_ID=CopyImage(texture_1_ID, #PB_Any)
    RotateSprite_BF(texture_2_ID,
                                      0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                      0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                                      arc, ; Rotating degree
                                      0,   ; mode=0 create a exactely resized sprite With minimized mask - mode=1 create a quadratic sprite for enhanced on demand rotation 
                                      0,   ; Rotating offset x - Handle with care - Do not make offsets too big - I will give you not a limit
                                      0)   ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50
                                           ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                           ; So you can also simple create masked rotated sprites from all images without mask
                                           ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
    ErrorCheck_BF(result) 
    
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
                                -1,   
                                0,  
                                10, 
                                50, 
                                ImageWidth(texture_2_ID),
                                ImageHeight(texture_2_ID))
    ErrorCheck_BF(result)
    ; Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    FreeImage(texture_2_ID)
    ; You can also give free the texture with FreeImage(texture_2_ID), this is a little faster
    ; Do you this, you must use firstly deactivate the BF texture cache with NoCaching_BF or you become a memory leak
    
    
    ; - Call functions #2 -
    Define texture_2_ID=CopyImage(texture_1_ID, #PB_Any)
    RotateSprite_BF(texture_2_ID,
                                      0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                      0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                                      arc, ; Rotating degree
                                      0,   ; mode=0 create a exactely resized sprite With minimized mask - mode=1 create a quadratic sprite for enhanced on demand rotation 
                                      0,   ; Rotating offset x - Handle with care - Do not make offsets too big - I will give you not a limit
                                      0)   ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50
                                           ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                           ; So you can also simple create masked rotated sprites from all images without mask
                                           ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
    ErrorCheck_BF(result) 
    
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
                                -1,   
                                0,  
                                600+GetSprite_X_BF(), ; Adjust output
                                10+GetSprite_Y_BF(),  ; Adjust output
                                ImageWidth(texture_2_ID),
                                ImageHeight(texture_2_ID))
    ErrorCheck_BF(result)
    ; Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    FreeImage(texture_2_ID)
    ; You can also give free the texture with FreeImage(texture_2_ID), this is a little faster
    ; Do you this, you must use firstly deactivate the BF texture cache with NoCaching_BF or you become a memory leak
    
    ; - Call functions #3 -
    Define texture_2_ID=CopyImage(texture_1_ID, #PB_Any)
    RotateSprite_BF(texture_2_ID,
                                      0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                      0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                                      arc, ; Rotating degree
                                      1,   ; mode=0 create a exactely resized sprite With minimized mask - mode=1 create a quadratic sprite for enhanced on demand rotation 
                                      30,  ; Rotating offset x - Handle with care - Do not make offsets too big - I will give you not a limit
                                      30)  ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50
                                           ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                           ; So you can also simple create masked rotated sprites from all images without mask
                                           ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
    ErrorCheck_BF(result)  
    
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
                                -1,   
                                0,  
                                180+GetSprite_X_BF(),    ; Output x - Adjust output
                                -90+GetSprite_Y_BF(),    ; Output y - Adjust output
                                GetSprite_width_BF()+6,  ; Adjust output
                                GetSprite_height_BF()+6, ; Adjust output
                                GetSprite_X_BF()-3,      ; Adjust output
                                GetSprite_Y_BF()-3)      ; Adjust output
    ErrorCheck_BF(result)
    ; Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    FreeImage(texture_2_ID)
    ; You can also give free the texture with FreeImage(texture_2_ID), this is a little faster
    ; Do you this, you must use firstly deactivate the BF texture cache with NoCaching_BF or you become a memory leak
    
    ; - Call functions #4 -
    Define texture_2_ID=CopyImage(texture_1_ID, #PB_Any)
    RotateSprite_BF(texture_2_ID,
                                      0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                      0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                                      arc, ; Rotating degree
                                      0,   ; mode=0 create a exactely resized sprite With minimized mask - mode=1 create a quadratic sprite for enhanced on demand rotation 
                                      0,   ; Rotating offset x - Handle with care - Do not make offsets too big - I will give you not a limit
                                      0)   ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50  
                                           ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                           ; So you can also simple create masked rotated sprites from all images without mask
                                           ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
    ErrorCheck_BF(result) 
    
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
                                0,   
                                0,  
                                10, 
                                320, 
                                ImageWidth(texture_2_ID),
                                ImageHeight(texture_2_ID))
    ErrorCheck_BF(result)
    ; Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    FreeImage(texture_2_ID)
    ; You can also give free the texture with FreeImage(texture_2_ID), this is a little faster
    ; Do you this, you must use firstly deactivate the BF texture cache with NoCaching_BF or you become a memory leak
    
    ; - Call functions #5 -
    Define texture_2_ID=CopyImage(texture_1_ID, #PB_Any)
    RotateSprite_BF(texture_2_ID,
                                      0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                      0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                                      arc, ; Rotating degree
                                      0,   ; mode=0 create a exactely resized sprite With minimized mask - mode=1 create a quadratic sprite for enhanced on demand rotation 
                                      0,   ; Rotating offset x - For mode 1 - Handle with care - Do not make offsets too big - I will give you not a limit
                                      0)   ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50
                                           ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                           ; So you can also simple create masked rotated sprites from all images without mask
                                           ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
    ErrorCheck_BF(result) 
    
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
                                0,   
                                0,  
                                600+GetSprite_X_BF(), ; Adjust output
                                290+GetSprite_Y_BF(), ; Adjust output
                                ImageWidth(texture_2_ID),
                                ImageHeight(texture_2_ID))
    ErrorCheck_BF(result)
    ; Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    FreeImage(texture_2_ID)
    ; You can also give free the texture with FreeImage(texture_2_ID), this is a little faster
    ; Do you this, you must use firstly deactivate the BF texture cache with NoCaching_BF or you become a memory leak
    
    ; - Call functions #6  -
    Define texture_2_ID=CopyImage(texture_1_ID, #PB_Any)
    RotateSprite_BF(texture_2_ID,
                                      0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                      0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                                      arc, ; Rotating degree
                                      1,   ; mode=0 create a exactely resized sprite With minimized mask - mode=1 create a quadratic sprite for enhanced on demand rotation 
                                      30,  ; Rotating offset x - Handle with care - Do not make offsets too big - I will give you not a limit
                                      30)  ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50   
                                           ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                           ; So you can also simple create masked rotated sprites from all images without mask
                                           ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg compressed sprites this is ever needed - Try ~ 25 > 35 percent 
    ErrorCheck_BF(result) 
    
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
                                0,   
                                0,  
                                180+GetSprite_X_BF(),    ; Output x - Adjust output
                                140+GetSprite_Y_BF(),    ; Output y - Adjust output
                                GetSprite_width_BF()+6,  ; Adjust output
                                GetSprite_height_BF()+6, ; Adjust output
                                GetSprite_X_BF()-3,      ; Adjust output
                                GetSprite_Y_BF()-3)      ; Adjust output
    ErrorCheck_BF(result)
    ; Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    FreeImage(texture_2_ID)
    ; You can also give free the texture with FreeImage(texture_2_ID), this is a little faster
    ; Do you this, you must use firstly deactivate the BF texture cache with NoCaching_BF or you become a memory leak
    
    ; Get the sprite position and make a white frame
    If StartDrawing(ImageOutput(Get_animation_buffer_hidden_ID_image_BF())) ; 
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(GetSprite_X_BF(), GetSprite_Y_BF(), GetSprite_XX_BF()-GetSprite_X_BF()+1, GetSprite_YY_BF()-GetSprite_Y_BF()+1)
    EndIf
    StopDrawing()
    
    arc+1 : If arc>359 : arc=0 : EndIf
    
  EndIf
  
  ; Get the result
  CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
  
ForEver
