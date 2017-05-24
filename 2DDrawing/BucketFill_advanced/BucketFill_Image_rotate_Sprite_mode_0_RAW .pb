XIncludeFile("./BucketFill_advanced.pbi")

;- Rotating demo - Rotating mode 0 -

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
canvas_width=600
canvas_height=400

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)

HideWindow(window_ID, 0)

path$=Rose$
Define texture_1_ID=LoadImage(#PB_Any, path$)

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

SetColorDistanceSpriteMask_BF(25)

NoCaching_BF(1) ; Rotating sprite change immediately the used texture, for significant speed up you can here deactivate the BF texture cache

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Free_animation_buffers_image_BF() ; Free animation buffers
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 20) ; Timer 0 - 100 timer available 0 - 99 - you can change
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    ; - Rotate sprite #1 -
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
    
    ; - Call function #2 -
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID,
                                0,   
                                0,  
                                150+GetSprite_X_BF(), ; Adjust rotation
                                50+GetSprite_Y_BF(),  ; Adjust rotation
                                ImageWidth(texture_2_ID),
                                ImageHeight(texture_2_ID))
    ErrorCheck_BF(result)
    Free_selected_Texture_BF(texture_2_ID) ; You must give free again the texture with this BF function
    arc+1 : If arc>359 : arc=0 : EndIf
    
  EndIf
  
  ; Get the result
  CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
  
ForEver
