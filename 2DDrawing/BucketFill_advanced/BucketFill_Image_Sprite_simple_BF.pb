XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Load a image with mask as sprite
;   This works not with sprites or pictures without mask
;   For some other pictures it is available you must change the color distance for the sprite mask

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define window_ID, win_event, image_ID, texture_ID, background_ID, result
Define image_x, image_y, image_width, image_height, point
Define path$, path_1$

#SoilWall="./BucketFill_Image_Set/soil_wall.jpg"

; Presets
image_width=600 : image_height=475

path_1$=OpenFileRequester("Select a sprite", "", "", 0)
If path_1$="" : End : EndIf

image_ID=LoadImage(#PB_Any, #SoilWall)

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

; - Call function #1 -
path$=#SoilWall
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, background_ID, texture_ID)
ErrorCheck_BF(result)

StartDrawing(ImageOutput(background_ID))
DrawingMode(#PB_2DDrawing_Transparent)
DrawText(180, 25, "A VERY COOL FUNCTION !", -1)
DrawText(380, 45, "BUCKET FILL ADVANCED", -1)
DrawText(380, 65, "www.quick-aes-256.de", -1)
DrawText(380, 85, "www.nachtoptik.de", -1)
DrawText(380, 105, "Sprites simple for Images", -1)
StopDrawing()

Define mode=1                ; Mode 0 deactivate the invisible color- mode 1 activate the invisible color
Define image_get_color_x=0   ; Grab transparence color from sprite pos x  
Define image_get_color_y=0   ; Grab transparence color from sprite pos y 
Define output_pos_x=0        ; Grab transparence color from sprite pos x  
Define output_pos_y=0        ; Grab transparence color from sprite pos y   
Define output_width=0        ; Output width  - For original output width set width = 0
Define output_height=0       ; Output height - For original output height set height = 0
Define alpha=1               ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible (BF specific)
Define texture_width=0       ; Endposition texture output       - Preset 0 = Clipping is automatic To image width 
Define texture_height=0      ; Endposition texture output       - Preset 0 = Clipping is automatic To image height 
Define texture_clip_x=0      ; Startposition inside the texture - Preset 0
Define texture_clip_y=0      ; Startposition inside the texture - Preset 0
Define texture_clip_width=0  ; Endposition inside the texture   - Preset 0 = full texture width
Define texture_clip_height=0 ; Endposition inside the texture   - Preset 0 = full texture height

SetColorDistanceSpriteMask_BF(25) ; percent

; SetInvisibleColor_BF($FF00FF) ; Set the invisible color - Use this with care for sprites without a invisible color, or you can become "holes" in your output frames
                                                          ; This use a QUAD, deactivate again with SetInvisibleColor_BF(-1) - For white set $FFFFFF - This is a globale function
                                                          ; This deactivate "Grab transparence color from the frame pos" x, y
                                                          ; -2 deactivate the invisible color
; - Call function #2 -
texture_ID=LoadImage(#PB_Any, path_1$) ; Sprite mode
ResizeImage(texture_ID, image_width, image_height)

SpriteSimple_BF(mode, background_ID, texture_ID, ; Function for simple using any images as sprites 
                                  image_get_color_x,               ; Grab transparence color from sprite pos x                           
                                  image_get_color_y,               ; Grab transparence color from sprite pos y      
                                  output_pos_x,                    ; Output pos x
                                  output_pos_y,                    ; Output pos y
                                  output_width,                    ; You can here resize the output x
                                  output_height,                   ; You can here resize the output y
                                  alpha,                           ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible (BF specific)
                                  texture_width,                   ; Endposition texture output       - Preset 0 = Clipping is automatic to image width 
                                  texture_height,                  ; Endposition texture output       - Preset 0 = Clipping is automatic to image height 
                                  texture_clip_x,                  ; Startposition inside the texture - Preset 0
                                  texture_clip_y,                  ; Startposition inside the texture - Preset 0
                                  texture_clip_width,              ; Endposition inside the texture   - Preset 0 = full texture width
                                  texture_clip_height)             ; Endposition inside the texture   - Preset 0 = full texture height
                                                                   ; You use clipping, "image_get_color.." get the invisible color from the clipped texture
                                                                   ; For using pictures with alpha channel use mode=2
                                                                   ; For using JPG based masked sprites, pre use SetColorDistanceSpriteMask_BF(percent) 
                                                                   ; Mode 0 deactivate the invisible color- mode 1 activate the invisible color

ErrorCheck_BF(result)

Define canvas_ID=CanvasGadget(#PB_Any, 0, 0, ImageWidth(background_ID), ImageHeight(background_ID))

StartDrawing(CanvasOutput(canvas_ID)) ; Get the result
DrawImage(ImageID(background_ID), 0, 0)
StopDrawing() 

Repeat
  win_event=WaitWindowEvent()
  If win_event=#PB_Event_CloseWindow
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
ForEver
