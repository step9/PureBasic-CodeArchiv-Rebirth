XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Main demo for Sprite and GIF output

; BF can output all GIF as sprites

; This function works for any outputs on image and canvas

; Simple handling double buffering for flicker free animation output directly on images and canvas - Similar PB FlipBuffers
; This is a important simplification and extension for all things with a needed animation !

; Automatic GIF delay handling
; Frame output resizable
; Also multiple tilles output available
; Clipping inside the GIF frames available - You can clip gif frames how ever you want
; Output for GIF with and without a invisible color
; You can self define the invisible color
; Output with alpha blending available
; Color distance function available, very nice effects
; You can draw directly in both animation buffers

UseGIFImageDecoder()

EnableExplicit

Define window_ID, win_event, texture_ID, gif_ID, background_ID, result, arc, size=1, alpha_1, xxxx
Define image_width, image_height, frame, delay, frame_delay, i, invisible_color, temporary_frame_1_ID, mirrored_frame_ID
Define path$

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

path$="./BucketFill_Image_Set/Cogwheel_1.gif"
gif_ID=LoadImage(#PB_Any, path$)

path$="./BucketFill_Image_Set/Background.bmp"
texture_ID=LoadImage(#PB_Any, path$)

; Presets
image_width=ImageWidth(gif_ID)+780 : image_height=ImageHeight(gif_ID)+430

background_ID=CreateImage(#PB_Any, image_width, image_height)

Define frames=ImageFrameCount(gif_ID)   ; Count frames
Define frame_width=ImageWidth(gif_ID)   ; Frame width
Define frame_height=ImageHeight(gif_ID) ; Frame height

Define alpha=1 ; Here you can set alpha blending - BF set 1 for full visible, 256 for full transparence (BF specific)

Define x=50 ; Output start point x
Define y=50 ; Output start point y

Define xxx=-80 ; Output start point x for moving
Define yyy=-80 ; Output start point y for moving

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

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images - Canvas output MAIN demo for animated Sprites, GIF and PB function output",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

; - Call function #1 -
result=BF(-2, background_ID, texture_ID) ; Create a background
ErrorCheck_BF(result)

Define temporary_frame_ID=CreateImage(#PB_Any, frame_width, frame_height) ; Create a temporary frame

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID)) ; Create a canvas for output the result

Create_animation_buffers_image_BF(background_ID) ; Init animation buffers - Double buffering - Flicker free animation

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
    invisible_color=SearchUnusedColor_BF(temporary_frame_ID, 0, 0, frame_width-1, frame_height-1) ; Get a unused color
    SetInvisibleColor_BF(invisible_color)                                                         ; Set the invisible color for each frame (Sprite)
    StartDrawing(ImageOutput(temporary_frame_ID))                                                 ; Draw in the temporary frame buffer
    Box(0, 0, frame_width, frame_height, invisible_color)                                         ; Draw the invisible color
    DrawingMode(#PB_2DDrawing_AlphaBlend)                                                         ; Enable GIF transparence color output
    DrawImage(ImageID(gif_ID),0 , 0)                                                              ; Draw the GIF frame in the temporary frame buffer
    StopDrawing()
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function, but it is more flexible
                           ; You have three separately buffers - you can read and write ever each buffer
    
    ; ----- Demonstrate PB functions output with BF background buffering -----
    ; All things you draw in the background buffer, BF add automatically permanently to the visible output
    ; All things you draw in the hidden buffer (Sprite buffer) behave like sprites, you can simple animate, add or replace
    ; You can as sample save all components how ever you want :
    ; You can save the hidden buffer, this save all sprite like things
    ; You can save the background buffer, this save all things you have permanently added
    ; You can save the output buffer, this save all things inclusive background buffer and hidden buffer contents - This save also also all sprites 
    If xxxx=250 ; Draw a PB function output permanently in the background - With alpha blending
      StartDrawing(ImageOutput(Get_animation_buffer_background_ID_image_BF())) ; Draw in the background animation buffer
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      Box(180, 380, 480, 80, $AAFFAA|$AA000000)
      StopDrawing()
    EndIf
    If xxxx=650 ; Draw a PB function output permanently in the background - Without alpha blending
      StartDrawing(ImageOutput(Get_animation_buffer_background_ID_image_BF())) ; Draw in the background animation buffer
      Box(180, 480, 480, 80, $AAFFFF)
      StopDrawing()
    EndIf
    StartDrawing(ImageOutput(Get_animation_buffer_background_ID_image_BF())) ; Draw in the background animation buffer - Without alpha blending
    Box(0, 200, image_width, 100, $FF)
    StopDrawing()
    StartDrawing(ImageOutput(Get_animation_buffer_hidden_ID_image_BF())) ; Draw in the hidden animation buffer - With alpha blending
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    Box(xxx, 420, 80, 80, $AAFFFFAA)
    StopDrawing()
    ; ------------------------------------------------------------------------
    
    SetInvisibleColor_BF(invisible_color)
    ; - Call function #2 - GIF frame output
    result=SpriteSimple_fast_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                                image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                x,                   ; Output position x
                                y,                   ; Output position y
                                output_width,        ; Output width - Resizing          - Preset 0 = Is the full texture width
                                output_height,       ; Output height - Resizing         - Preset 0 = Is the full texture width
                                texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                                texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    
    SetInvisibleColor_BF(-1)
    
    ; - Call function #3 - GIF frame output rotated - Method #1 - mirrored vertical
    mirrored_frame_ID=MirrorImage_BF(1, temporary_frame_ID, 2)
    temporary_frame_1_ID=RotateSprite_BF(mirrored_frame_ID,
                                         image_get_color_x, ; Grab transparence color from sprite pos x - For preset set ..x=-1
                                         image_get_color_y, ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF
                                         arc,               ; Rotating degree
                                         1,                 ; mode=0 create a exactely resized sprite with minimized mask - mode=1 create a quadratic sprite for on demand rotation 
                                         0,                 ; Rotating offset x - For mode 1 - Handle with care - Do not make offsets too big - I will give you not a limit
                                         10,                ; Rotating offset y - You can also set negative values - As sample x=50 - y=-50
                                         1)                 ; Set this parameter for immediately creating a new rotated sprite
    FreeImage(mirrored_frame_ID)
    
    result=SpriteSimple_fast_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_1_ID,                                     
                                image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                210,                 ; Output position x
                                -20,                 ; Output position y
                                220,                 ; Output width - Resizing          - Preset 0 = Is the full texture width
                                220,                 ; Output height - Resizing         - Preset 0 = Is the full texture width
                                texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                                texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    FreeImage(temporary_frame_1_ID)
    
    ; - Call function #4 - GIF frame output rotated - Method #2
    result=RotateSprite_simple_BF(1, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                              
                                  image_get_color_x, ; Grab transparence color from sprite pos x - For preset set ..x=-1 - For ignore set ..x=-2                         
                                  image_get_color_y, ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF     
                                  390,               ; Output pos x
                                  -50,               ; Output pos y
                                  arc,               ; Rotating degree
                                  alpha_1,           ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible (BF specific)
                                  size,              ; You can here resize the output x
                                  size,              ; You can here resize the output y
                                  10,                ; Rotating offset x
                                  10)                ; Rotating offset y
    
    If size>80
      If StartDrawing(ImageOutput(Get_animation_buffer_hidden_ID_image_BF())) ; 
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(GetSprite_X_BF(), GetSprite_Y_BF(), GetSprite_XX_BF()-GetSprite_X_BF()+1, GetSprite_YY_BF()-GetSprite_Y_BF()+1, $FFFF)
      EndIf
      StopDrawing()
    EndIf
    
    ; - Call function #5 - GIF frame output
    result=SpriteSimple_fast_BF(120, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                                image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                600,                 ; Output position x
                                20,                  ; Output position y
                                300,                 ; Output width - Resizing          - Preset 0 = Is the full texture width
                                300,                 ;o Output height - Resizing         - Preset 0 = Is the full texture width
                                texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                texture_clip_y,      ; Startpsition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                                texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    
    ; - Call function #6 - GIF frame output
    result=SpriteSimple_fast_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                                image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                20,                  ; Output position x
                                200,                 ; Output position y
                                150,                 ; Output width - Resizing          - Preset 0 = Is the full texture width
                                350,                 ; Output height - Resizing         - Preset 0 = Is the full texture width
                                texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                                texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    
    ; - Call function #7 - GIF frame output - mirrored horicontal
    mirrored_frame_ID=MirrorImage_BF(1, temporary_frame_ID, 1)
    result=SpriteSimple_fast_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), mirrored_frame_ID,                                     
                                image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                250,                 ; Output position x
                                200,                 ; Output position y
                                300,                 ; Output width - Resizing          - Preset 0 = Is the full texture width
                                150,                 ; Output height - Resizing         - Preset 0 = Is the full texture width
                                texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                                texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    FreeImage(mirrored_frame_ID)
    
    ; - Call function #8 - GIF frame output
    result=Sprite_CSS_sheet_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                               image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                               image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                               180,                 ; Output position x
                               380,                 ; Output position y
                               1,                   ; Numbers of frames
                               0,                   ; Selected frame - For PB GIF compatibility the first frame is 0
                               frame_width,         ; Frame width
                               frame_height,        ; Frame height
                               1,                   ; Frames in a row
                               output_width+80,     ; Output width - Resizing          - Preset 0 = Is the full texture width
                               output_height+80,    ; Output height - Resizing         - Preset 0 = Is the full texture width
                               480,                 ; Endposition texture output       - Preset 0 = Clipping is automatic to output width 
                               160,                 ; Endposition texture output       - Preset 0 = Clipping is automatic to output height 
                               texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                               texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                               texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                               texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    
    ; - Call function #9 - GIF frame output
    result=SpriteSimple_fast_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                                image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                700,                 ; Output position x
                                330,                 ; Output position y
                                150,                 ; Output width - Resizing          - Preset 0 = Is the full texture width
                                200,                 ; Output height - Resizing         - Preset 0 = Is the full texture width
                                35,                  ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                35,                  ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                110,                 ; Endposition inside the texture   - Preset 0 = Full texture width
                                130)                 ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    
    SetInvisibleColor_BF(-1)
    ; - Call function #10 - GIF frame output
    result=SpriteSimple_fast_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), temporary_frame_ID,                                     
                                image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                xxx,                 ; Output position x
                                yyy,                 ; Output position y
                                output_width,        ; Output width - Resizing          - Preset 0 = Is the full texture width
                                output_height,       ; Output height - Resizing         - Preset 0 = Is the full texture width
                                texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                texture_clip_width,  ; Endposition inside the texture   - Preset 0 = Full texture width
                                texture_clip_height) ; Endposition inside the texture   - Preset 0 = Full texture height
    ErrorCheck_BF(result)
    
    ; ----- Demonstrate PB functions output with BF background buffering -----
    StartDrawing(ImageOutput(Get_animation_buffer_hidden_ID_image_BF())) ; Draw in the hidden animation buffer
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    Box(xxx, 320, 80, 80, $AAFAAFAA)
    StopDrawing()
    ; ------------------------------------------------------------------------
    
    ; Frame delay - Using timer 1
    If delay : delay=0 : frame+1 : If frame=>frames : frame=0 : EndIf : Else : delay+Delay_BF(1, frame_delay) : EndIf
    
    xxxx+1
    xxx+1 : If xxx>image_width : xxx=-frame_width : EndIf ; Animate the output
    yyy+1 : If yyy>image_height : yyy=-frame_height : EndIf ; Animate the output
    
    arc+2 : If arc>359 : arc=0 : EndIf
    
    size+1 : If size>150 : alpha_1+1 : size=150 : EndIf
    
    If alpha_1>255 : size=1 : alpha_1=1 : EndIf
    
    
    ; Get the result
    CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
  
ForEver
