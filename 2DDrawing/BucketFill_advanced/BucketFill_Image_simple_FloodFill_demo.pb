XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - FloodFill demo - simple - This function can output directly on images or canvas

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
 UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define window_ID, win_event, image_ID, texture_ID, background_ID, result
Define image_x, image_y, image_width, image_height, point
Define path$

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  #GeeBee="./BucketFill_Image_Set/Geebee2.bmp"
  #Clouds="./BucketFill_Image_Set/Clouds.jpg"
  #SoilWall="./BucketFill_Image_Set/soil_wall.jpg"
  #RustySteel="./BucketFill_Image_Set/RustySteel.jpg"
  #Caisse="./BucketFill_Image_Set/Caisse.png"
  #Dirt="./BucketFill_Image_Set/Dirt.jpg"
  #Background="./BucketFill_Image_Set/Background.bmp"
CompilerElse
  ; Linux/Mac can not load examples from the Compiler_Home path
  #GeeBee=#PB_Compiler_Home+"Examples/Sources/Data/Geebee2.bmp"
  #Clouds=#PB_Compiler_Home+"Examples/3D/Data/Textures/Clouds.jpg"
  #SoilWall=#PB_Compiler_Home+"Examples/3D/Data/Textures/soil_wall.jpg"
  #RustySteel=#PB_Compiler_Home+"Examples/3D/Data/Textures/RustySteel.jpg"
  #Caisse=#PB_Compiler_Home+"Examples/3D/Data/Textures/Caisse.png"
  #Dirt=#PB_Compiler_Home+"Examples/3D/Data/Textures/Dirt.jpg"
  #Background=#PB_Compiler_Home+"Examples/Sources/Data/Background.bmp"
CompilerEndIf

; Presets
image_width=600 : image_height=475

image_ID=LoadImage(#PB_Any, #SoilWall)

background_ID=CreateImage(#PB_Any, image_width, image_height)

window_ID=OpenWindow(#PB_Any, 0, 0,
                     image_width, image_height, "Bucket Fill advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

StartDrawing(ImageOutput(background_ID))
Box (40, 10, 128 , 400, $AAA1)
RoundBox (185, 80, 133 , 250 , 20, 20, $AAAAA2)
Box (300, 280, 150 , 150, $AAA3)
Circle(460, 260, 125, $AAAAA4)
StopDrawing()

; - Call function #1 -
path$=#SoilWall
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(-2, background_ID, texture_ID,
                                   0, ; Startpoint for FloodFill x
                                   0) ; y
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
path$=#Caisse
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(-100, background_ID, texture_ID,
                                   40,
                                   10)
ErrorCheck_BF(result)

; - Call function #3 -
path$=#GeeBee
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(-2, background_ID, texture_ID,
                                   185,
                                   100,
                                   60, ; Startposition texture output x
                                   80) ; y
ErrorCheck_BF(result)

; - Call function #4 -
path$=#Clouds
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(-2, background_ID, texture_ID,
                                   185, ; Output x
                                   100) ; Output y
ErrorCheck_BF(result)

; - Call function #5 -
path$=#Caisse
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(-2, background_ID, texture_ID,
                                   300,
                                   280,
                                   0,
                                   0,
                                   0,
                                   0,
                                   0,
                                   0,
                                   30,
                                   30)
ErrorCheck_BF(result)

; - Call function #6 -
path$="./BucketFill_Image_Set/Cat_01.jpg"
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 300, 260)
result=FloodFill_BF(-2, background_ID, texture_ID,
                                   450,
                                   250,
                                   0,
                                   135) ; Adjust photo
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
