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

Define window_ID, win_event, texture_ID, sheet_ID, background_ID, result
Define image_width, image_height, frame, delay, i

Define path$, path_1$, file

path$=OpenFileRequester("Select a BF CSS sheet - A BF sheet_info file must also exist", "", "", 0)
If path$="" : End : EndIf

file=ReadFile(#PB_Any, GetPathPart(path$)+GetFilePart(path$, #PB_FileSystem_NoExtension)+"_sheet_info_BF.txt")
If Not file : End :EndIf

Define frames=Val(Mid(ReadString(file), 19, 8))           ; Count frames in the sheet
Define frame_width=Val(Mid(ReadString(file), 19, 8))      ; Frame width
Define frame_height=Val(Mid(ReadString(file), 19, 8) )    ; Frame height
ReadString(file)                                          ; Sheet width - unused
ReadString(file)                                          ; Sheet height - unused
Define frames_in_a_row=Val(Mid(ReadString(file), 19, 8) ) ; Frames in a row
Define invisible_color=Val(Mid(ReadString(file), 19, 8))  ; Invisible color

Define Dim frame_delay(frames-1)

While Not Eof(file) And i<frames
  frame_delay(i)=Val(Mid(ReadString(file), 29, 8) ) ; Frame delay
  i+1
Wend

CloseFile(file)

sheet_ID=LoadImage(#PB_Any, path$)

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
Define alpha=1 ; Here you can set alpha blending - BF set 1 for full visible, 256 for full transparence

Define x=40 ; Output point x
Define y=40 ; Output point y

Define output_width=0  ; Output width - For original frame width and height, set width or height = 0
Define output_height=0 ; Output height

Define sheet_width=ImageWidth(sheet_ID)
Define sheet_height=ImageHeight(sheet_ID)

Define image_get_color_x=0 ; Get the invisible color from pos x
Define image_get_color_y=0 ; Get the invisible color from pos y

Define texture_width=0  ; Endposition texture output - Preset 0 = Clipping is automatic to output width 
Define texture_height=0 ; Endposition texture output - Preset 0 = Clipping is automatic to output height 

Define texture_clip_x=0 ; Startposition inside the texture - Preset 0
Define texture_clip_y=0 ; Startposition inside the texture - Preset 0   

Define texture_clip_width=0  ; Endposition inside the texture - Preset 0 = full texture width
Define texture_clip_height=0 ; Endposition inside the texture - Preset 0 = full texture width

image_width=frame_width+x*2 : image_height=frame_height+y*2

If output_width>0 : image_width=output_width+x*2 : EndIf
If output_height>0 : image_height=output_height+y*2 : EndIf

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

; - Call function #1 -
result=BF(-2, background_ID, texture_ID) ; Create a background
ErrorCheck_BF(result)

Create_animation_buffers_image_BF(background_ID) ; Init animation buffers - Double buffering - Flicker free animation

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID))

SetInvisibleColor_BF(invisible_color) ; Set the invisible color from the sheet
                                                        ; This use a QUAD, deactivate again with SetInvisibleColor_BF(-1) - For white set $FFFFFF - This is a globale function
                                                        ; This deactivate "Grab transparence color from the frame pos" x, y
                                                        ; -2 deactivate the invisible color

SetColorDistanceSpriteMask_BF(0) ; percent - With this function you can remove "Halos" on the edges from the GIF content
                                                   ; Is the mask color very different from the GIF content you become halos on the edges
                                                   ; This function can remove this complete - try about 20>30 percent
                                                   ; You can also use this function for nice graphic effect, on movie like GIF, as sample
                                                   ; Or for making invisible more different colors

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
    
    ; - Call function #2 - Frame output
    result=Sprite_CSS_sheet_BF(alpha, Get_animation_buffer_hidden_ID_image_BF(), sheet_ID,
                                                 image_get_color_x,   ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                                 image_get_color_y,   ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                                 x,                   ; Output position x
                                                 y,                   ; Output position y
                                                 frames,              ; Numbers of frames
                                                 frame,               ; Selected frame - For PB GIF compatibility the first frame is 0
                                                 frame_width,         ; Frame width
                                                 frame_height,        ; Frame height
                                                 frames_in_a_row,     ; Frames in a row - Preset 0, then BF calculate self
                                                 output_width,        ; Output width                     - Preset 0 = Is the full texture width
                                                 output_height,       ; Output height                    - Preset 0 = Is the full texture height
                                                 texture_width,       ; Endposition texture output       - Preset 0 = Clipping is automatic to output width 
                                                 texture_height,      ; Endposition texture output       - Preset 0 = Clipping is automatic to output height 
                                                 texture_clip_x,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                                                 texture_clip_y,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                                                 texture_clip_width,  ; Endposition inside the texture   - Preset 0 = full texture width
                                                 texture_clip_height) ; Endposition inside the texture   - Preset 0 = full texture height
                                                                      ; You can also preset a invisible color with "SetInvisibleColor_BF(color)"
                                                                      ; Attention, a setted "SetColorDistanceSpriteMask_BF(percent)" influence the output
    
    ErrorCheck_BF(result)
    
    If delay 
      delay=0
      frame+1 
      If frame=frames : frame=0 : EndIf 
    Else
      delay+Delay_BF(1, frame_delay(frame)) ; Timer 1 - delay 
    EndIf
    
    ; Get the result
    CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
ForEver
