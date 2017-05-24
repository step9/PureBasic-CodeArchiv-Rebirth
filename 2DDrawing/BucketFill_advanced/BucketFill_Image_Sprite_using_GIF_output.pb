XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Use a GIF with mask or without mask as sprite - BF Sprite CSS sheet function used

; This function can output directly all GIF as sprites

; - Looking in the code for the needed settings

; What can do this code ?
; Simple handling double buffering for flicker free animation output directly on images and canvas - Similar PB FlipBuffers
; This is a important simplification and extension for all things with a needed animation !
; A nice gimmick is, this function works not only for sprites, this function works for any outputs on images and canvas

; Can output animated GIF directly on canvas and images
; Simple output same a sprite on each backgrounds
; Automatic GIF delay handling
; Frame output resizable
; Also multiple tilles output available
; Clipping inside the GIF frames available - You can clip gif frames how ever you want
; Output for GIF with and without a invisible color
; You can self define the invisible color
; Output with alpha blending available
; You can draw directly in the background
; You can draw directly in the animation buffer

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

Define alpha=1 ; Here you can set alpha blending - BF set 1 for full visible, 256 for full transparence (BF specific)

Define x=40 ; Output start point x
Define y=40 ; Output start point y

Define output_width=0  ; Output width  - For original sprite width set width = 0
Define output_height=0 ; Output height - For original sprite height set height = 0

Define image_get_color_x=0 ; Get the invisible color from pos x
Define image_get_color_y=0 ; Get the invisible color from pos y
                           ; The code use to time a presetted invisible color - looking below for SetInvisibleColor_BF(sprite_mask_color)

Define texture_width=0  ; Endposition texture output - Preset 0 = Clipping is automatic to output width 
Define texture_height=0 ; Endposition texture output - Preset 0 = Clipping is automatic to output height
                        ; You can set this larger as the frame, then you become tilles, set it smaller clip the output !

Define texture_clip_x=0 ; Startposition inside the texture - Preset 0
Define texture_clip_y=0 ; Startposition inside the texture - Preset 0
                        ; Frame clipping

Define texture_clip_width=0  ; Endposition inside the texture - Preset 0 = full texture width
Define texture_clip_height=0 ; Endposition inside the texture - Preset 0 = full texture height
                             ; Frame clipping

Define image_width=ImageWidth(gif_ID)
Define image_height=ImageHeight(gif_ID)

Define temporary_frame_ID=CreateImage(#PB_Any, image_width, image_height) ; Create a temporary frame

image_width=frame_width+x*2 : image_height=frame_height+y*2

If output_width>0 : image_width=output_width+x*2 : EndIf
If output_height>0 : image_height=output_height+y*2 : EndIf

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images - Canvas output demo for GIF",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

; - Call function #1 -
result=BF(-2, background_ID, texture_ID) ; Create a background
ErrorCheck_BF(result)

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID)) ; Create a canvas for output the result

Create_animation_buffers_image_BF(background_ID) ; Init animation buffers - Double buffering - Flicker free animation

; invisible_color=$A7A8A9 ; You can preset here a invisible color - Define not the same as the GIF content color or you become "Holes"

invisible_color=Create_invisible_GIF_color(gif_ID) ; This create automatic a new and common invisible color for the GIF output as sprite
If invisible_color<1 : invisible_color=Random($FFFFFE, 1) : EndIf ; Fuse - Error handling for automatic invisible color generating

NoCaching_BF(1) ; For immediately changed textures you can deactivate the BF texture caching

HideWindow(window_ID, 0)

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    FreeImage(temporary_frame_ID) ; Free temporary image
    Free_animation_buffers_image_BF() ; Free animation buffers
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0 - 100 timer available 0 - 99 - you can change - Animation Refresh
    SetImageFrame(gif_ID, frame)       ; Set the GIF frame for processing
    frame_delay=GetImageFrameDelay(gif_ID) ; Get the GIF frame delay
    If Not frame_delay : frame_delay=100 : EndIf ; Delay 0 works not, so as a standard, delay 0 = delay 100
    SetInvisibleColor_BF(invisible_color) ; Set the invisible color for each frame (Sprite)
    StartDrawing(ImageOutput(temporary_frame_ID))           ; Draw in the temporary frame buffer
    Box(0, 0, frame_width, frame_height, invisible_color)   ; Draw the invisible color
    DrawingMode(#PB_2DDrawing_AlphaBlend)                   ; Enable GIF transparence color output
    DrawImage(ImageID(gif_ID),0 , 0)                        ; Draw the GIF frame in the temporary frame buffer
    StopDrawing()
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
    ; - Call function #2 - GIF frame output
    result=Sprite_CSS_sheet_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                               image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                               image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                               x,                   ; Output position x
                               y,                   ; Output position y
                               1,                   ; Numbers of frames
                               0,                   ; Selected frame - For PB GIF compatibility the first frame is 0
                               frame_width,         ; Frame width
                               frame_height,        ; Frame height
                               1,                   ; Frames in a row - Preset 0, then BF calculate self
                               output_width,        ; Output width - Resizing          - Preset 0 = Is the full texture width
                               output_height,       ; Output height - Resizing         - Preset 0 = Is the full texture width
                               texture_width,       ; Endposition texture output       - Preset 0 = Clipping is automatic to output width 
                               texture_height,      ; Endposition texture output       - Preset 0 = Clipping is automatic to output height 
                               texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                               texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                               texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                               texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    
    ErrorCheck_BF(result)
    
    ; ; Demonstrate the background buffering
    ; StartDrawing(ImageOutput(Get_animation_buffer_background_ID_image_BF())) ; Draw in the background animation buffer
    ; Box(0, 200, image_width, 100, $FF)
    ; StopDrawing()
    ; StartDrawing(ImageOutput(Get_animation_buffer_hidden_ID_image_BF())) ; Draw in the hidden animation buffer
    ; Box(100, 250, 100, 100, $FFFF)
    ; StopDrawing()
    
    ; Frame delay - Using timer 1
    If delay : delay=0 : frame+1 : If frame=>frames : frame=0 : EndIf : Else : delay+Delay_BF(1, frame_delay) : EndIf
    
    ; Get the result
    CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
  
ForEver
