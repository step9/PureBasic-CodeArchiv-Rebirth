XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Deflickering and animation demo for output multiple moved sprites - simple

; Hint : This is faster as the RAW version

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define window_0, win_event, canvas_ID, window_ID, texture_ID, texture_1_ID, texture_2_ID, temporary_image_0_ID, temporary_image_1_ID
Define canvas_x, canvas_y, canvas_width, canvas_height, point, arc, result
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
Define x, y, x1, y1, x2, y2

path$=#Geebee ; Get a sprite
texture_ID=LoadImage(#PB_Any, path$)

path$=#Testtexture ; Get a sprite
texture_1_ID=LoadImage(#PB_Any, path$)

path$=#Penguin; Get a sprite
texture_2_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_2_ID, 100, 100)

ResizeImage(texture_ID, 90, 80) ; Resize the sprite

Create_animation_buffers_image_BF(canvas_ID) ; Init animation buffers - Double buffering - Flicker free animation                                                                                                                                                                            

SetColorDistanceSpriteMask_BF(25) ; Remove artifacts from the sprite mask

HideWindow(window_ID, 0)

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Free_animation_buffers_image_BF() ; Free animation buffers
    FreeTextures_BF() ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0, Time 10 ms - 100 timer available 0 - 99 - you can change
    
    FlipBuffers_image_BF() ; This works similar the PB FlipBuffers function 
    
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
    
    SetColorDistanceSpriteMask_BF(30) ; Remove artifacts from the sprite mask
    
    ; - Call function - output sprite #1 -
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x,                           
                                y,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Graphic output #1
    If StartVectorDrawing(ImageVectorOutput(Get_animation_buffer_hidden_ID_image_BF()))
      VectorSourceColor($FFFF0001)
      MovePathCursor (250 , 150)
      AddPathCircle (250 , 150 , 80, 0, arc , #PB_Path_Connected)
      FillPath()
      StopVectorDrawing()
    EndIf
    StopDrawing()
    
    ; - Call function - output sprite #2 -
    result=BF(80, Get_animation_buffer_hidden_ID_image_BF(), texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x1-100,                           
                                y1-20,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #3 -
    result=BF(40, Get_animation_buffer_hidden_ID_image_BF(), texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x2+100,                           
                                y2+20,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #4 -
    result=BF(40, Get_animation_buffer_hidden_ID_image_BF(), texture_ID, ; Sprite mode
                                0,                                   
                                0,                                 
                                x2+100,                           
                                y2+20,                             
                                ImageWidth(texture_ID),                           
                                ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    ; Call function - alphachannel sprite output #1 -
    result=AlphaChannelSprite_BF(Get_animation_buffer_hidden_ID_image_BF(), texture_2_ID, ; Sprite mode
                                                   0,                                   
                                                   200,
                                                   ImageWidth(texture_2_ID)*6,
                                                   ImageHeight(texture_2_ID))                                 
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #5 -
    result=SpriteSimple_BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_ID, ; Sprite simple
                                             0,
                                             0,
                                             x,                           
                                             100,                             
                                             ImageWidth(texture_ID)/2,                           
                                             ImageHeight(texture_ID)/2)
    ErrorCheck_BF(result)
    
    ; Call function - output sprite #6 -
    result=SpriteSimple_BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_ID, ; Sprite simple
                                             0,
                                             0,
                                             250,                           
                                             y,                             
                                             ImageWidth(texture_ID)*1.3,                           
                                             ImageHeight(texture_ID)*1.3)
    ErrorCheck_BF(result)
    
    ; Graphic output #2
    If StartVectorDrawing(ImageVectorOutput(Get_animation_buffer_hidden_ID_image_BF()))
      VectorSourceColor($AAFFFF01)
      MovePathCursor (400 , 200)
      AddPathCircle (400 , 200 , 100, 0, arc , #PB_Path_Connected)
      FillPath()
      StopVectorDrawing()
    EndIf
    StopDrawing()
    
    SetColorDistanceSpriteMask_BF(5) ; Remove artifacts from the sprite mask
    
    ; - Call function - output sprite #7 -
    result=BF(1, Get_animation_buffer_hidden_ID_image_BF(), texture_1_ID, ; Sprite mode
                                5,                                   
                                5,                                 
                                235,                           
                                60,                             
                                ImageWidth(texture_1_ID),                           
                                ImageHeight(texture_1_ID))
    ErrorCheck_BF(result)
    
    ; Get the result
    CopyContent_Image_Canvas_BF(Get_animation_buffer_hidden_ID_image_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
  
ForEver
