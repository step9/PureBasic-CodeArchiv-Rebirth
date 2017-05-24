XIncludeFile("./BucketFill_advanced.pbi")

;- Demo - Seamless photos -

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

Define window_0, win_event, canvas_ID, window_ID, texture_ID, result
Define canvas_x, canvas_y, canvas_width, canvas_height, point, i
Define path$, path_1$

Define SoilWall$="./BucketFill_Image_Set/soil_wall.jpg"

; Presets
canvas_x=50
canvas_y=50
canvas_width=1100
canvas_height=750

path$=OpenFileRequester("Select a picture", "", "", 0)
If path$="" : End : EndIf

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)

StartDrawing(CanvasOutput(canvas_ID))
Box(0, 0, canvas_width, canvas_height, 0) ; Black preset for the canvas
StopDrawing()

path_1$=SoilWall$
texture_ID=LoadImage(#PB_Any, path_1$)
; - Call function #1 
result=BF(-2, canvas_ID, texture_ID)
ErrorCheck_BF(result)

StartDrawing(CanvasOutput(canvas_ID))
DrawingMode(#PB_2DDrawing_Transparent)
DrawText(20, 5, "A VERY COOL FUNCTION", -1)
DrawText(20, 25, "BUCKET FILL ADVANCED", -1)
DrawText(20, 45, "WITH FLOOD FILL FUNCTION", -1)
DrawText(20, 65, "www.quick-aes-256.de", -1)
DrawText(20, 85, "www.nachtoptik.de", -1)
StopDrawing()

texture_ID=LoadImage(#PB_Any, path$)

NoCaching_BF(1) ; For immediately changed textures you can deactivate the BF texture caching

; - Call function #2 
PhotoBrush_canvas_BF(1, canvas_ID, texture_ID, ; For canvas
                     10,                       ; Output pos x
                     250,                      ; Output pos y
                     250,                      ; Texture or image width
                     220,                      ; Texture or image height
                     50,                       ; Percent visibility
                     50)                       ; Delay for animation)                                 

; - Call function #3
PhotoBrush_canvas_BF(2, canvas_ID, texture_ID,
                     260,                                
                     10,                                
                     300,                               
                     230)                                


; - Call function #4
PhotoBrush_canvas_BF(3, canvas_ID, texture_ID,
                     300,                                 
                     250,                                 
                     300,                               
                     250)

; - Call function #5
PhotoBrush_canvas_BF(3, canvas_ID, texture_ID,
                     600,                                 
                     20,                                 
                     500,                               
                     450,
                     40,
                     50)

; - Call function #6
PhotoBrush_canvas_BF(-1, canvas_ID, texture_ID,
                     20,                                 
                     550,                                 
                     200,                               
                     180) 

; - Call function #7
PhotoBrush_canvas_BF(0, canvas_ID, texture_ID,
                     250,                                 
                     550,                                 
                     200,                               
                     180,
                     40,
                     50)

; - Call function #8
PhotoBrush_canvas_BF(3, canvas_ID, texture_ID,
                     460,                                 
                     550,                                 
                     500,                               
                     200,
                     70,
                     50)

; - Call function #9
; For full visible little images with automatic seamless animation, or seamless, make more repeats, the seamless edge are too wide for little pictures
For i=1 To 5
  PhotoBrush_canvas_BF(1, canvas_ID, texture_ID,
                       1000,                                 
                       580,                                 
                       50,                               
                       50,
                       100,
                       30)
Next i

; - Call function #10
; For full visible little images with automatic seamless animation, or seamless, make more repeats, the seamless edge are too wide for little pictures
For i=1 To 5
  PhotoBrush_canvas_BF(0, canvas_ID, texture_ID,
                       1013,                                 
                       650,                                 
                       30,                               
                       30,
                       100,
                       30)
Next i

; - Call function #11
PhotoBrush_canvas_BF(-1, canvas_ID, texture_ID,
                     1016,                                 
                     700,                                 
                     25,                               
                     25,
                     100)

Repeat
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Break
  EndIf
ForEver

FreeTextures_BF() ; Free grabed textures

; ; - Demo - Native using BF For seamless photos -
; 
; UsePNGImageDecoder() : UseJPEGImageDecoder()
; 
; EnableExplicit
; 
; Define window_ID, win_event, image_ID, texture_ID, result, i, ii
; Define path_0$, path_1$
; 
; image_ID=CreateImage(#PB_Any, 600, 400)
; path_1$=OpenFileRequester("Select a picture", "", "", 0)
; If path_1$="" : End : EndIf
; path_0$="./BucketFill_Image_Set/soil_wall.jpg"
; 
; window_ID=OpenWindow(#PB_Any, 0, 0,
;                      ImageWidth(image_ID), ImageHeight(image_ID), "Bucket Fill advanced - For Images",
;                      #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
; 
; StartDrawing(ImageOutput(image_ID))
; DrawingMode(#PB_2DDrawing_Transparent)
; DrawText(20, 20, "A VERY COOL FUNCTION !", -1)
; DrawText(20, 40, "BUCKET FILL ADVANCED", -1)
; DrawText(20, 60, "www.quick-aes-256.de", -1)
; DrawText(20, 80, "www.nachtoptik.de", -1)
; DrawText(220, 5, "Sprites simple for Images", 0)
; DrawText(220, 20, "Also FloodFill with texture support", -1)
; StopDrawing()
; 
; ; CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf
; 
; ; ============== Use BucketFill advanced ===============
; 
; ; - Call BF function #1 - Make a background
; texture_ID=LoadImage(#PB_Any, path_0$)
; result=BF(-2, image_ID, texture_ID)
; ErrorCheck_BF(result)
; 
; ; - Call BF function #2 - Embedding a photo in the background
; texture_ID=LoadImage(#PB_Any, path_1$)
; ResizeImage(texture_ID, 400, 320)
; 
; ii=0
; For i=0 To 23
;   Delay(25)
;   result=BF(256-ii, image_ID, texture_ID, ; Sprite mode
;                               -1,         ; Set to -1
;                               -1,         ; 
;                               180+ii,     ; x Startposition texture output
;                               60+ii,      ; y
;                               400-ii-ii,  ; x Endposition texture output
;                               320-ii-ii,  ; y
;                               ii,         ; x Startposition texture output inside the texture
;                               ii,         ; y
;                               400-ii,     ; x Endposition texture output inside the texture
;                               320-ii)     ; y
; ErrorCheck_BF(result)
;   
;   CompilerIf #PB_Compiler_OS=#PB_OS_Windows
;     StartDrawing(WindowOutput(window_ID))
;     DrawImage(ImageID(image_ID), 0, 0)
;     StopDrawing()
;   CompilerElse
;     ImageGadget(0, 0, 0, 600, 400, ImageID(image_ID))
;   CompilerEndIf
;   
;   ii+3
; Next i
; 
; Repeat
;   If WaitWindowEvent()=#PB_Event_CloseWindow : Break : EndIf
; ForEver
