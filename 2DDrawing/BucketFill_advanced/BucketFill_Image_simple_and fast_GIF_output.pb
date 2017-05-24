XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Use a GIF with mask or without mask as sprite - BF Sprite CSS sheet simple function used - Fast

; You can set self the used invisible color

; This function is not based on the BF core function, it's based on PB CustomFilterCallback and works so a litle other

; Looking in the code for the needed settings

UseGIFImageDecoder()

EnableExplicit

Define window_ID, win_event, texture_ID, gif_ID, background_ID, result
Define image_width, image_height, frame, delay, frame_delay, i, invisible_color
Define path$

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

path$=OpenFileRequester("Select a GIF", "", "", 0)
If path$="" Or UCase(GetExtensionPart(path$))<>"GIF": End : EndIf

gif_ID=LoadImage(#PB_Any, path$)

texture_ID=CreateImage(#PB_Any, 100, 100) ; Create a texture for the background
StartDrawing(ImageOutput(texture_ID))
For i=1 To ImageWidth(texture_ID)-1 Step 7
  LineXY(i, 0, i, ImageHeight(texture_ID), $DCDCDC)
Next i
For i=1 To ImageHeight(texture_ID)-1 Step 7
  LineXY(0, i, ImageWidth(texture_ID), i, $DCDCDC)
Next i
StopDrawing()

; Presets
Define frames=ImageFrameCount(gif_ID)   ; Count frames
Define frame_width=ImageWidth(gif_ID)   ; Frame width
Define frame_height=ImageHeight(gif_ID) ; Frame height

Define x=40 ; Output start point x
Define y=40 ; Output start point y

Define output_width=0  ; Output width  - For original sprite width set width = 0
Define output_height=0 ; Output height - For original sprite height set height = 0

Define texture_clip_x=0 ; Startposition inside the texture - Preset 0
Define texture_clip_y=0 ; Startposition inside the texture - Preset 0

Define texture_clip_width=0  ; Offset endposition inside the texture - Preset 0 = full texture width
Define texture_clip_height=0 ; Offset endposition inside the texture - Preset 0 = full texture height

If output_width ; --- Calculate the needed output window and temporary image ---
  image_width=output_width+x*2
Else
  If texture_clip_width
    image_width=frame_width-texture_clip_x-(frame_width-texture_clip_width)+x*2
  Else
    image_width=frame_width-texture_clip_x-texture_clip_width+x*2
  EndIf
EndIf
If output_height
  image_height=output_height+y*2
Else
  If texture_clip_height
    image_height=frame_height-texture_clip_y-(frame_height-texture_clip_height)+y*2
  Else
    image_height=frame_height-texture_clip_y-texture_clip_height+y*2
  EndIf
EndIf
; ------------------------------------------------------------------------------

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images - Canvas output demo for GIF",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

; - Call function #1 -
result=BF(-2, background_ID, texture_ID) ; Create a background
ErrorCheck_BF(result)


Define temporary_frame_ID=CreateImage(#PB_Any, frame_width, frame_height) ; Create a temporary frame

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID)) ; Create a canvas for output the result

Create_animation_buffers_image_BF(background_ID) ; Init animation buffers - Double buffering - Flicker free animation

; invisible_color=$A7A8A9 ; You can preset here a invisible color - Define not the same as the GIF content color or you become "Holes"

invisible_color=Create_invisible_GIF_color(gif_ID) ; This create automatic a new and common invisible color for the GIF output as sprite
If invisible_color<1 : invisible_color=Random($FFFFFE, 1) : EndIf ; Fuse - Error handling for automatic invisible color generating

Define image_get_color_x=-1 ; Grab transparence color from sprite pos x - For preset set ..x=-1                     
Define image_get_color_y=invisible_color ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF  

Define mode=1
; mode 0 = Without invisible color
; mode 1 > 256 = With invisible color and with alpha blending
; mode -1 > -256 = Without invisible color and with alpha blending
; This function is very fast - mode 0 is the fastest mode, faster as the same inside BF for canvas

SetColorDistanceSpriteMask_BF(0) ; 0=deactivated - Hint: For nice effects with a pre defined invisible color - Test this also with pictures without a mask
; Use this not with a automatic defined invisible color

NoCaching_BF(1) ; For immediately changed textures you can deactivate the BF texture caching

HideWindow(window_ID, 0)

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    FreeImage(temporary_frame_ID) ; Free temporary image
    Free_animation_buffers_image_BF() ; Free animation buffers
    FreeTextures_BF()                 ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0 - 100 timer available 0 - 99 - you can change - Animation Refresh
    SetImageFrame(gif_ID, frame)       ; Set the GIF frame for processing
    frame_delay=GetImageFrameDelay(gif_ID) ; Get the GIF frame delay
    If Not frame_delay : frame_delay=100 : EndIf ; Delay 0 works not, so as a standard, delay 0 = delay 100
    StartDrawing(ImageOutput(temporary_frame_ID)); Draw in the temporary frame buffer
    Box(0, 0, frame_width, frame_height, invisible_color) ; Draw the invisible color
    DrawingMode(#PB_2DDrawing_AlphaBlend)                 ; Enable GIF transparence color output
    DrawImage(ImageID(gif_ID),0 , 0)                      ; Draw the GIF frame in the temporary frame buffer
    StopDrawing()
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    ; - Call function #2 - GIF frame output
    result=SpriteSimple_fast_BF(mode, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                                 image_get_color_x,   ; Grab transparence color from sprite pos x - For preset set ..x=-1                      
                                 image_get_color_y,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF  
                                 x,                   ; Output position x
                                 y,                   ; Output position y
                                 output_width,        ; Resizing - Define the output width - Preset zero = without resizing 
                                 output_height,       ; Resizing - Define the output height
                                 texture_clip_x,      ; Startposition inside the texture - Preset 0
                                 texture_clip_y,      ; Startposition inside the texture - Preset 0
                                 texture_clip_width,  ; Endposition inside the texture - Preset 0 = full texture width
                                 texture_clip_height) ; Endposition inside the texture - Preset 0 = full texture height
    ErrorCheck_BF(result)
    
    ; Frame delay - Using timer 1
    If delay : delay=0 : frame+1 : If frame=>frames : frame=0 : EndIf : Else : delay+Delay_BF(1, frame_delay) : EndIf
    
    ; Get the result
    CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
  
ForEver
