XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Use a CSS sprite sheet with mask or without mask as sprite - BF Sprite CSS sheet Function used

; This function is created for simple using sheets with a symmetric frame arrangement
; As sample, for sheets created with the BF sheet creating tool for GIF pictures 
; For all other sheets use the method demonstrated in the demo code for RAW handling sprite sheets

; - For using lossly formats, you must output the sheets with the BF color distance function for cleaning the sprite mask
; - For best results use PNG format and a color distance mostly from 20 percent
; - Looking in the code for the needed settings

UsePNGImageDecoder()
UseJPEGImageDecoder()

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define window_ID, win_event, image_ID, texture_ID, background_ID, result
Define image_width, image_height, frame
Define path$, path_1$

#Background="./BucketFill_Image_Set/Background.bmp"
#Sheet="./BucketFill_Image_Set/Hound_1.png"

; Presets
image_width=600 : image_height=475

image_ID=LoadImage(#PB_Any, #Background)

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define fsont_1=LoadFont(1, "Arial", 11)
CompilerEndIf

; - Call function #1 -
path$=#Background
texture_ID=LoadImage(#PB_Any, path$)

result=BF(-2, background_ID, texture_ID) ; Create a background
ErrorCheck_BF(result)

Define alpha=1 ; Here you can set alpha blending - BF set 1 for full visible, 256 for full transparence

path_1$=#Sheet
texture_ID=LoadImage(#PB_Any, path_1$)

Define frame_width=145 ; Frame width
Define frame_height=72 ; Frame height

Define frames=7 ; Count frames in the sheet

Define x=10 ; Animation start point
Define y=250

Define output_width=220  ; Output width  - For original frame width set width = 0
Define output_height=120 ; Output height - For original frame height set height = 0

Define sheet_width=ImageWidth(texture_ID)
Define sheet_height=ImageHeight(texture_ID)

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1=LoadFont(1, "Arial", 11)
CompilerEndIf

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

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID)) ; Create a canvas for output the result

Define image_get_color_x=0
Define image_get_color_y=0
Define frames_in_a_row=3
Define texture_clip_x=0
Define texture_clip_y=0
Define texture_clip_xx=0
Define texture_clip_yy=0

Create_animation_buffers_image_BF(background_ID) ; Init animation buffers - Double buffering - Flicker free animation

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
  
  If Delay_BF(0, 100) ; Timer 0 - 100 timer available 0 - 99 - you can change - Animation Refresh
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    x+5 : y-3
    If x>ImageWidth(background_ID) : x=-frame_width : EndIf
    If y<-frame_height : y=ImageHeight(background_ID) : EndIf
    
    ; - Call function #2 -
    result=Sprite_CSS_sheet_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), texture_ID,
                                                 image_get_color_x, ; Grab transparence color from sheet pos x - Set to -1 for output without invisible color 
                                                 image_get_color_y, ; Grab transparence color from sheet pos y - You can set x or y, or both parameters to -1 
                                                 x,                 ; Output position x
                                                 y,                 ; Output position y
                                                 frames,            ; Numbers of frames
                                                 frame,             ; Selected frame - For PB GIF compatibility the first frame is 0
                                                 frame_width,       ; Frame width
                                                 frame_height,      ; Frame height
                                                 frames_in_a_row,   ; Frames in a row
                                                 output_width,      ; Output width  - Resizing         - Preset 0 = Is the full texture width
                                                 output_height,     ; Output height - Resizing         - Preset 0 = Is the full texture height
                                                 texture_clip_x,    ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                                 texture_clip_y,    ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                                 texture_clip_xx,   ; Endposition inside the texture   - Preset 0 = full texture width
                                                 texture_clip_yy)   ; Endposition inside the texture   - Preset 0 = full texture height
    
    ErrorCheck_BF(result)
    
    frame+1 : If frame=>frames : frame=0 : EndIf
    
    ; Get the result
    CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
  
ForEver
