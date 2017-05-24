XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Use a CSS sprite sheet with mask or without mask as sprite - RAW - BF core function used
; - For using lossly formats, you must output the sheets with the BF color distance function for cleaning the sprite mask
; - On Linux use ever PNG format for best results and a color distance mostly from 20 percent
; - Looking in the code for the needed settings

UsePNGImageDecoder()
UseJPEGImageDecoder()

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define window_ID, win_event, image_ID, texture_ID, background_ID, result
Define frame_offset_x, frame_offset_y, frame=1
Define *drawing_buffer_grabed_image, *drawing_buffer
Define image_x, image_y, image_width, image_height, point
Define path$, path_1$

#Background="./BucketFill_Image_Set/Background.bmp"

#Sheet="./BucketFill_Image_Set/Hound_1.png"

; Presets
image_width=600 : image_height=475

image_ID=LoadImage(#PB_Any, #Background)

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1=LoadFont(1, "Arial", 11)
CompilerEndIf

; - Call function #1 -
path$=#Background
texture_ID=LoadImage(#PB_Any, path$)

result=BF(-2, background_ID, texture_ID) ; Create a background
ErrorCheck_BF(result)

Define alpha=1 ; Here you can set alpha blending - BF set 1 for full visible, 256 for full transparence

path_1$=#Sheet
texture_ID=LoadImage(#PB_Any, path_1$)

ResizeImage(texture_ID, ImageWidth(texture_ID)*2, ImageHeight(texture_ID)*2, #PB_Image_Raw) ; Make larger

Define frame_width=145*2 ; Frame width
Define frame_height=72*2 ; Frame height

Define frames=7 ; Count frames in the sheet

Define x=10 ; Animation start point
Define y=250

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

*drawing_buffer_grabed_image=GrabImage_BF(background_ID) ; Grab image
ErrorCheck_BF(*drawing_buffer_grabed_image)

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID)) ; Create a canvas for output the result

; Needed for removing mask artifacts, this is important, use this your sprites have a colored halo - Try about 20>30 percent
; You can also use this for creating graphic effects, make simple a try
SetColorDistanceSpriteMask_BF(3) ; percent

NoCaching_BF(1) ; For immediately changed textures you can deactivate the BF texture caching

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    FreeMemory(*drawing_buffer_grabed_image) ; Free grabed image
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 100) ; Timer 0 - 100 timer available 0 - 99 - you can change - Animation Refresh
  
    *drawing_buffer=DrawingBuffer_image_BF(background_ID)
    ErrorCheck_BF(*drawing_buffer)
    CopyMemory(*drawing_buffer_grabed_image, *drawing_buffer, MemorySize(*drawing_buffer_grabed_image)) ; Refresh image
    
    x+5 : y-3
    If x>ImageWidth(background_ID) : x=-frame_width : EndIf
    If y<-frame_height : y=ImageHeight(background_ID) : EndIf
    
    ; - Call function #2 -
    result=BF(alpha, background_ID, texture_ID,
                                0,              ; Grab transparence color from sprite pos x - Set to -1 for output without invisible color                             
                                0,              ; Grab transparence color from sprite pos y - You can set x or y, or both parameters to -1                       
                                x,              ; Startposition texture output - Preset 0                          
                                y,              ; Start position texture output - Preset 0                         
                                frame_width,    ; Endposition texture output - Preset 0 = Clipping is automatic to image width                   
                                frame_height,   ; Endposition texture output - Preset 0 = Clipping is automatic to image height
                                frame_offset_x, ; Output startposition inside the texture x (clipping) - Preset 0
                                frame_offset_y) ; Output startposition inside the texture y (clipping) - Preset 0
                                                ; frame_offset_xx, ; Output endposition inside the texture x   (clipping) - Preset 0 = full texture width
                                                ; frame_offset_yy) ; Output endposition inside the texture y   (clipping) - Preset 0 = full texture height
                                                ; Attention, a setted "SetColorDistanceSpriteMask_BF(percent)" influence the output
    ErrorCheck_BF(result)
    
    frame+1 : frame_offset_x+frame_width
    If frame_offset_x=>sheet_width : frame_offset_x=0 : frame_offset_y+frame_height : EndIf 
    If frame=>frames : frame_offset_x=0 : frame_offset_y=0 : frame=1 :EndIf
    
    ; Get the result
    StartDrawing(CanvasOutput(canvas_ID))
    DrawImage(ImageID(background_ID), 0, 0)
    StopDrawing() 
    
  EndIf
  
ForEver
