XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Deflickering and animation demo for output multiple moved sprites and graphic directly on canvas - RAW

; This demo demonstrate rudimentary BF function using

;CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define window_0, win_event, canvas_ID, window_ID, texture_ID, texture_1_ID, texture_2_ID, temporary_image_ID, result
Define canvas_x, canvas_y, canvas_width, canvas_height, point, arc
Define path$

#GeeBee="./BucketFill_Image_Set/Geebee2.bmp"
#SoilWall="./BucketFill_Image_Set/soil_wall.jpg"
#Testtexture="./BucketFill_Image_Set/testtexture_large.png"
#Penguin="./BucketFill_Image_Set/Penguin.png"

; Presets
canvas_x=50
canvas_y=50
canvas_width=600
canvas_height=400

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)

; - Call function #1 -
path$=#SoilWall
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID) ; Make a background texture
ErrorCheck_BF(result)

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1=LoadFont(1, "Arial", 11)
CompilerEndIf

StartDrawing(CanvasOutput(canvas_ID))
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1)
CompilerEndIf
DrawingMode(#PB_2DDrawing_Transparent)
DrawText(20, 5, "A VERY COOL FUNCTION !", $FF00)
DrawText(20, 25, "BUCKET FILL ADVANCED", $FF00)
DrawText(20, 45, "www.quick-aes-256.de", $FF00)
DrawText(20, 65, "www.nachtoptik.de", $FF00)
DrawText(220, 5, "Sprites simple for Canvas", $FFFF)
DrawText(220, 25, "Also FloodFill with texture support", -2)
StopDrawing()

; - Sprite animation #1 -
Define x, y, x1, y1, x2, y2, drawing_buffer_len
Define *drawing_buffer_canvas, *drawing_buffer_image, *drawing_buffer_grabed_canvas

path$=#Geebee ; Get a sprite
texture_ID=LoadImage(#PB_Any, path$)

path$=#Testtexture ; Get a sprite
texture_1_ID=LoadImage(#PB_Any, path$)

path$=#Penguin; Get a sprite
texture_2_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_2_ID, 100, 100)

ResizeImage(texture_ID, 90, 80) ; Resize the sprite

temporary_image_ID=CreateImage(#PB_Any, GadgetWidth(canvas_ID), GadgetHeight(canvas_ID)) ; Create a temporary image for the BF image output

drawing_buffer_len=DrawingBuffer_length_canvas_BF(canvas_ID) ; Get the drawing buffer length
ErrorCheck_BF(drawing_buffer_len)

*drawing_buffer_grabed_canvas=GrabCanvas_BF(canvas_ID) ; Grab the canvas
ErrorCheck_BF(*drawing_buffer_grabed_canvas)

HideWindow(window_ID, 0) ; Show the window, now

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    FreeMemory(*drawing_buffer_grabed_canvas) ; Free grabed canvas
    FreeTextures_BF() ; Free grabed textures
    FreeImage(temporary_image_ID) ; Free temporary image
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0, Time 10 ms - 100 timer available 0 - 99 - you can change
    
    *drawing_buffer_image=DrawingBuffer_image_BF(temporary_image_ID) ; Get the drawing buffer adress from the temporary image
    ErrorCheck_BF(*drawing_buffer_image)         ; Error check
    *drawing_buffer_canvas=DrawingBuffer_canvas_BF(canvas_ID)        ; Get the drawing buffer adress from the canvas gadget
    ErrorCheck_BF(*drawing_buffer_canvas)       ; Error check
                                                                                 ; This functions here working similar the PB FlipBuffers function
                                                                                 ; All things you move on the canvas are now "Ghosts", not a integral part from the based canvas contents
                                                                                 ; For including all "Ghosts" in the canvas base buffer do this :
                                                                                 ; CopyMemory(*drawing_buffer_canvas, *drawing_buffer_grabed_canvas, MemorySize(*drawing_buffer_grabed_canvas))
                                                                                 ; Activate the line above and look what then happens !
                                                                                 ; This works so also with BF for images, only when you want it is the "Ghosts" in the image content taken over
    CopyMemory(*drawing_buffer_grabed_canvas, *drawing_buffer_image, MemorySize(*drawing_buffer_grabed_canvas)) ; Refresh canvas
    
    x+1 : y-1
    If x>GadgetWidth(canvas_ID)+100
      x=-(ImageWidth(texture_ID)+100)
    EndIf
    If y<-(ImageHeight(texture_ID)+20)
      y=GadgetHeight(canvas_ID)+20
    EndIf
    
    x1+2 : y1-1
    If x1>GadgetWidth(canvas_ID)+100
      x1=-(ImageWidth(texture_ID)+100)
    EndIf
    If y1<-(ImageHeight(texture_ID)+20)
      y1=GadgetHeight(canvas_ID)+20
    EndIf
    
    x2+1 : y2-2
    If x2>GadgetWidth(canvas_ID)+100
      x2=-(ImageWidth(texture_ID)+100)
    EndIf
    If y2<-(ImageHeight(texture_ID)+20)
      y2=GadgetHeight(canvas_ID)+20
    EndIf
    
    arc+1
    If arc>360 : arc=-arc : EndIf
    
    SetColorDistanceSpriteMask_BF(25) ; Remove artifacts from the sprite mask
    
    ; - Call function - output sprite #1 -
    result=BF(1, temporary_image_ID, texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x,                           
                                y,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Graphic output #1
    If StartVectorDrawing(ImageVectorOutput(temporary_image_ID))
      VectorSourceColor($FFFF0001)
      MovePathCursor (250 , 150)
      AddPathCircle (250 , 150 , 80, 0, arc , #PB_Path_Connected)
      FillPath()
      StopVectorDrawing()
    EndIf
    StopDrawing()
    
    ; - Call function - output sprite #2 -
    result=BF(80, temporary_image_ID, texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x1-100,                           
                                y1-20,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #3 -
    result=BF(40, temporary_image_ID, texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x2+100,                           
                                y2+20,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #4 -
    result=BF(40, temporary_image_ID, texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x2+100,                           
                                y2+20,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Call function - alphachannel sprite output #1 -
    result=AlphaChannelSprite_BF(temporary_image_ID, texture_2_ID, ; Sprite mode
                                                   0,                                   
                                                   200,
                                                   ImageWidth(texture_2_ID)*6,
                                                   ImageHeight(texture_2_ID))                                 
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #5 -
    result=SpriteSimple_BF(1, temporary_image_ID, texture_ID, ; Sprite simple 
                                             0,
                                             0,
                                             x,                           
                                             100,                             
                                             ImageWidth(texture_ID)/2,                           
                                             ImageHeight(texture_ID)/2)
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #6 -
    result=SpriteSimple_BF(1, temporary_image_ID, texture_ID, ; Sprite simple 
                                             0,
                                             0,
                                             250,                           
                                             y,                             
                                             ImageWidth(texture_ID)*1.3,                           
                                             ImageHeight(texture_ID)*1.3)
    ErrorCheck_BF(result)
    
    ; Graphic output #2
    If StartVectorDrawing(ImageVectorOutput(temporary_image_ID))
      VectorSourceColor($AAFFFF01)
      MovePathCursor (400 , 200)
      AddPathCircle (400 , 200 , 100, 0, arc , #PB_Path_Connected)
      FillPath()
      StopVectorDrawing()
    EndIf
    StopDrawing()
    
    SetColorDistanceSpriteMask_BF(5) ; Remove artifacts from the sprite mask
    
    ; - Call function - output sprite #7 -
    result=BF(1, temporary_image_ID, texture_1_ID, ; Sprite mode
                                5,                                   
                                5,                                 
                                235,                           
                                60,                             
                                ImageWidth(texture_1_ID),                           
                                ImageHeight(texture_1_ID))
    ErrorCheck_BF(result)
    
    ; Get the result
    StartDrawing(CanvasOutput(canvas_ID))
    DrawImage(ImageID(temporary_image_ID), 0, 0)
    StopDrawing()
    
  EndIf
  
ForEver
