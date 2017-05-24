XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Load a image with alpha channel as sprite - Also GIF supported
;   This works not with sprites or pictures with mask

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

path_1$=OpenFileRequester("Select a picture with alpha channel", "", "", 0)
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

; - Call function #2 -
texture_ID=LoadImage(#PB_Any, path_1$) ; Sprite mode
ResizeImage(texture_ID, image_width, image_height)

result=AlphaChannelSprite_BF(background_ID, texture_ID, ; Function for using any images with alpha channel as sprites
                             0,                         ;  Use this function only for pictures with alpha channel, or you see nothing
                             0)
;                                              texture_width,
;                                              texture_height,
;                                              texture_clip_x,
;                                              texture_clip_y,
;                                              texture_clip_width,
;                                              texture_clip_height)

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
