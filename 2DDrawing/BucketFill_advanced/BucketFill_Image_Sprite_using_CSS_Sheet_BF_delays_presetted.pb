XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Use a CSS sprite sheet with mask or without mask as sprite - BF Sprite CSS sheet Function used

; This function is created for simple using sheets with a symmetric frame arrangement
; As sample, for sheets created with the BF sheet creating tool for GIF pictures 

; - For using lossly formats, you must output the sheets with the BF color distance function for cleaning the sprite mask
; - For best results use PNG format and a color distance mostly from 20 percent
; - Looking in the code for the needed settings

UsePNGImageDecoder()
UseJPEGImageDecoder()

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define window_ID, win_event, image_ID, texture_ID, background_ID, result
Define image_width, image_height, frame, delay

Define path$, path_1$

#Background="./BucketFill_Image_Set/Background.bmp"
#Sheet="./BucketFill_Image_Set/Kid_1.png"

; Presets
image_width=600 : image_height=475

image_ID=LoadImage(#PB_Any, #Background)

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1=LoadFont(1, "Arial", 11)
CompilerEndIf

; - Call function #1 -
path$=#Background
texture_ID=LoadImage(#PB_Any, path$)

result=BF(-2, background_ID, texture_ID)
ErrorCheck_BF(result)

path_1$=#Sheet
texture_ID=LoadImage(#PB_Any, path_1$)

Define alpha=1 ; Here you can set alpha blending - BF set 1 for full visible, 256 for full transparence

Define frame_width=106  ; Frame width
Define frame_height=126 ; Frame height

Define frames=8 ; Count frames in the sheet

Define x=180 ; Animation start point
Define y=80

Define output_width=300  ; Output width  - For original frame width set width = 0
Define output_height=300 ; Output height - For original frame height set height = 0

Define image_get_color_x=0
Define image_get_color_y=0

Define frames_in_a_row=3

Define texture_clip_x=0
Define texture_clip_y=0

Define texture_clip_xx=0
Define texture_clip_yy=0

Define sheet_width=ImageWidth(texture_ID)
Define sheet_height=ImageHeight(texture_ID)

StartDrawing(ImageOutput(background_ID))
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1)
CompilerEndIf
DrawText(210, 25, "A VERY COOL FUNCTION !", -1)
DrawText(380, 45, "BUCKET FILL ADVANCED", -1)
DrawText(380, 65, "www.quick-aes-256.de", -1)
DrawText(380, 85, "www.nachtoptik.de", -1)
DrawText(380, 105, "CSS sprite sheet demo", -1)
DrawText(10, 400, "CSS sprite sheet using with BucketFill advanced", -1)
DrawText(10, 420, "You can also create CSS sprite sheets from GIF images, the same is used here", -1)
DrawText(10, 440, "Code for CSS sprite sheet creating from GIF you found in the BF advanced code packet", -1)
StopDrawing()

Create_animation_buffers_image_BF(background_ID) ; Init animation buffers - Double buffering - Flicker free animation

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID)) ; Create a canvas for output the result

; Needed for removing mask artifacts, this is important, use this your sprites have a colored halo - Try about 20>30 percent
; You can also use this for creating graphic effects, make simple a try
SetColorDistanceSpriteMask_BF(0) ; percent   

NoCaching_BF(1) ; For immediately changed textures you can deactivate the BF texture caching

HideWindow(window_ID, 0)

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Free_animation_buffers_image_BF() ; Free animation buffers
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0 - 100 timer available 0 - 99 - you can change - Animation Refresh
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    ; - Call function #2 -
    result=Sprite_CSS_sheet_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), texture_ID,
                                                 image_get_color_x, ; Grab transparence color from the frame x - Set to -1 for output without invisible color 
                                                 image_get_color_y, ; Grab transparence color from the frame y - You can set x or y, or both parameters to -1 
                                                 x,                 ; Output position x
                                                 y,                 ; Output position y
                                                 frames,            ; Numbers of frames
                                                 frame,             ; Selected frame - For GIF compatibility the first frame is 0
                                                 frame_width,       ; Frame width
                                                 frame_height,      ; Frame height
                                                 frames_in_a_row,   ; Frames in a row - Preset 0, then BF calculate self
                                                 output_width,      ; Output width                     - Preset 0 = Is the full texture width
                                                 output_height,     ; Output height                    - Preset 0 = Is the full texture height
                                                 texture_clip_x,    ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                                 texture_clip_y,    ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                                 texture_clip_xx,   ; Endposition inside the texture   - Preset 0 = full texture width
                                                 texture_clip_yy)   ; Endposition inside the texture   - Preset 0 = full texture height
    
    ErrorCheck_BF(result)
    
    ; This is a demo for presetted delays
    ; You can also read the delay table from the CSS sheet for automatic using delays on the same way, as sample with a array
    
    Select frame ; Frame delay - A BF timer starts ever with the first call, its all ok, then he returns 1 directly
      Case 0
        delay+Delay_BF(1, 2000) ; Timer 1 - delay 2000 ms
      Case 1, 3, 4, 6, 7
        delay+Delay_BF(1, 100)
      Case 5
        delay+Delay_BF(1, 800)
      Case 2
        delay+Delay_BF(1, 200)
    EndSelect
    
    If delay : delay=0 : frame+1 : EndIf
    
    If frame=>frames : frame=0 : EndIf
    
    ; Get the result
    CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
  
ForEver
