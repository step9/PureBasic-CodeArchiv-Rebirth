XIncludeFile("./BucketFill_advanced.pbi")

; - Demo BF canvas -

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define window_0, win_event, canvas_ID, texture_ID, result
Define canvas_x, canvas_y, canvas_width, canvas_height, point
Define path$

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1=LoadFont(1, "Arial", 11)
CompilerEndIf
#GeeBee="./BucketFill_Image_Set/Geebee2.bmp"
#Clouds="./BucketFill_Image_Set/Clouds.jpg"
#SoilWall="./BucketFill_Image_Set/soil_wall.jpg"
#RustySteel="./BucketFill_Image_Set/RustySteel.jpg"
#Caisse="./BucketFill_Image_Set/Caisse.png"
#Background="./BucketFill_Image_Set/Background.bmp"
#Hound="./BucketFill_Image_Set/Hound_1.png"
#Kid="./BucketFill_Image_Set/Kid_1.gif"

; Presets
canvas_x=50
canvas_y=50
canvas_width=700
canvas_height=400 

Define window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill advanced - For Canvas",
                            #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)

StartDrawing(CanvasOutput(canvas_ID))
Box(0, 0, canvas_width, canvas_height, 0) ; Black preset for the canvas
Circle(100, 100, 125, $AA)
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1)
CompilerEndIf
DrawText(20, 20, "A VERY COOL FUNCTION !", $FF00)
DrawText(20, 40, "BUCKET FILL ADVANCED", $FF00)
DrawText(20, 60, "www.quick-aes-256.de", $FF00)
DrawText(20, 80, "www.nachtoptik.de", $FF00)
DrawText(220, 5, "Sprites simple for Canvas", $FFFF)
DrawText(220, 25, "Also FloodFill with texture support", -1)
RoundBox (185, 80, 100 , 290 , 20, 20, $A2AAAA)
Box (30, 200, 128 , 128, $A3AAAA)
Circle(580, 110, 125, $A4AAAA)
Circle(590, 158, 100, $FE)
DrawText(469, 230, "Texture FLOODFILL")
StopDrawing()

If StartVectorDrawing(CanvasVectorOutput(canvas_ID))
  VectorSourceColor($FF000001)
  MovePathCursor (470 , 250)
  AddPathCircle (470 , 250 , 160, 0, 235 , #PB_Path_Connected)
  FillPath()
  StopVectorDrawing()
EndIf
StopDrawing()

ActivateBucketArray_BF(1)
ActivateFloodArray_BF(1)

; - Call function #1 -
path$=#SoilWall
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID)
ErrorCheck_BF(result)

; - Call function #2 -
path$=#RustySteel
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          0,
          35)
ErrorCheck_BF(result)

; - Call function #3 -
path$=#Caisse
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          185,
          210,
          185,
          80,
          0,
          0,
          15,
          10,
          55,
          50)
ErrorCheck_BF(result)

; - Call function #4 -
path$=#Background
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          376,
          121)
ErrorCheck_BF(result)

; - Manipulate the BucketFill output color -
Define x, y, color, new_color
StartDrawing(CanvasOutput(canvas_ID))
color=Point(0, 180) ; As sample - This point you can get how ever you want
new_color=$0FFF00   ; As sample
For y=GetBucket_Y_BF() To GetBucket_YY_BF()-102
  For x=GetBucket_X_BF() To GetBucket_XX_BF()
    If GetBucketArray_Point_BF(x, y) ; Read the array
      point=Point(x, y)
      If ColorDistance_BF(point, color)<30 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, new_color, 50)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

; - Call function #5 -
path$=#Clouds
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          30,
          202,
          30,
          200)
ErrorCheck_BF(result)

; - Call function #6 -
path$=#SoilWall
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          462,
          11)
ErrorCheck_BF(result)

SetColorDistanceSpriteMask_BF(20) ; Enable color distance

; - Call function #7 -
path$=#Geebee
texture_ID=LoadImage(#PB_Any, path$)
RotateImage_BF(90, texture_ID)
result=BF(1, canvas_ID, texture_ID,
          0,
          0,
          30,
          200,
          128,
          128)
ErrorCheck_BF(result)

; - Call function #8 -
path$=#GeeBee
texture_ID=LoadImage(#PB_Any, path$)
RotateSprite_BF(texture_ID,
                0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1                        
                0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                -15) ; Rotating degree

result=BF(1, canvas_ID, texture_ID,
          0, 
          0,   
          310, 
          40,  
          ImageWidth(texture_ID),
          ImageHeight(texture_ID))
ErrorCheck_BF(result)

; - Call function #09 -
path$=#Geebee
texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
ResizeImage(texture_ID, 80, 60)
result=BF(150, canvas_ID, texture_ID,
          0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
          0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
          60,  ; x  coordinate sprite output
          110, ; y  coordinate sprite output
          80,  ; xx coordinate sprite output - More results more sprites in a row - horizontal
          60)  ; yy coordinate sprite output - More results more sprites in a row - vertical
ErrorCheck_BF(result)

; - Call function #10 -
path$=#Geebee
texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
RotateSprite_BF(texture_ID,
                0,  ; Grab transparence color from sprite pos x - For preset set ..x=-1                     
                0,  ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF                 
                30) ; Rotating degree

ResizeImage(texture_ID, 50, 50)
result=BF(1, canvas_ID, texture_ID,
          0,                                   
          0,                                 
          340,                           
          250,                             
          250,                           
          150)
ErrorCheck_BF(result)

; - Call function #11 -
path$=#Geebee
texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
ResizeImage(texture_ID, 30, 30)
result=BF(1, canvas_ID, texture_ID,
          0,                                   
          0,                                 
          20,                           
          372,                             
          300,                           
          30)
ErrorCheck_BF(result)

SetColorDistanceSpriteMask_BF(0) ; Disable color distance

; - Call function #12 -
path$=#Geebee
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 30, 30)
result=BF(-2, canvas_ID, texture_ID,
          500, ; Get the color for repalcing with a texture x                               
          50,  ; Get the color for repalcing with a texture y                            
          425, ; Startposition texture output x                     
          0,   ; Startposition texture output y                    
          300, ; Endposition texture output xx                    
          250) ; Endposition texture output yy
ErrorCheck_BF(result)

SetColorDistanceFill_BF(23) ; Enable color distance

; - Call function #13 -
path$=#Clouds
texture_ID=LoadImage(#PB_Any, path$)
result=BF(-2, canvas_ID, texture_ID,
          590,                                   
          30,                                 
          440)
ErrorCheck_BF(result)

SetColorDistanceSpriteMask_BF(0) ; Disable color distance

; - FloodFill #1 -
path$=#Caisse
texture_ID=LoadImage(#PB_Any, path$)
result=FloodFill_BF(-2, canvas_ID, texture_ID,
                    550, ; x pos
                    180, ; y pos
                    10,  ; Startposition texture output x
                    10,  ; Startposition texture output y
                    0,   ; Endposition texture output xx
                    0,   ; Endposition texture output yy
                    0,   ; Startposition inside the texture x
                    0,   ; Startposition inside the texture y
                    30,  ; Endposition inside the texture xx
                    30)  ; Endposition inside the texture yy
                         ;  For using FloodFill without a texture set mode to -1
                         ;  and use the texture_ID parameter as color,
                         ;  as sample so - texture_ID=$FFFF
ErrorCheck_BF(result)

; - Manipulate the FloodFill output color -
Define x, y, color, new_color
StartDrawing(CanvasOutput(canvas_ID))
color=Point(73, 180) ; As sample - This point you can get how ever you want
new_color=$0FFF00    ; As sample
For y=GetFlood_Y_BF() To GetFlood_YY_BF()-120
  For x=GetFlood_X_BF() To GetFlood_XX_BF()
    If GetFloodArray_Point_BF(x, y) ; Read the array
      point=Point(x, y)
      If ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, new_color, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
For y=GetFlood_Y_BF()+80 To GetFlood_YY_BF()
  For x=GetFlood_X_BF()+120 To GetFlood_XX_BF()
    If GetFloodArray_Point_BF(x, y) ; Read the array
      point=Point(x, y)
      If ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, $008CFF, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
For y=GetFlood_Y_BF()+50 To GetFlood_YY_BF()-60
  For x=GetFlood_X_BF() To GetFlood_XX_BF()
    If GetFloodArray_Point_BF(x, y) ; Read the array
      point=Point(x, y)
      If ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, AlphaBlend_BF(point, $FFFF, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

; - Sprite animation -
Define x, y, x1, y1, arc

path$=#GeeBee
texture_ID=LoadImage(#PB_Any, path$)

CompilerIf #PB_Compiler_Version=>560 ; GIF settings
  path$=#Kid
  Define gif_ID=LoadImage(#PB_Any, path$)
  Define frame_width=(ImageWidth(gif_ID))
  Define frame_height=(ImageHeight(gif_ID))
  Define frames=ImageFrameCount(gif_ID)
  Define invisible_color=$34dfe4, delay
  Define frame_1
  Define temporary_frame_ID=(CreateImage(#PB_Any, frame_width, frame_height))
CompilerEndIf

ResizeImage(texture_ID, 100, 100)

path$=#Hound
Define sheet_ID=LoadImage(#PB_Any, path$)

Create_animation_buffers_canvas_BF(canvas_ID) ; Init animation buffers - Double buffering - Flicker free animation

HideWindow(window_ID, 0)

Repeat
  
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    Free_animation_buffers_canvas_BF() ; Free animation buffers
    FreeTextures_BF()                  ; Free grabed textures
    Break
  EndIf
  
  If Delay_BF(0, 10) ; Timer 0, Time 10 ms - 100 timer available 0 - 99 - you can change
    
    FlipBuffers_canvas_BF() ; This works similar the PB FlipBuffers function 
    
    x+1 : y-1
    If x>GadgetWidth(canvas_ID)
      x=-ImageWidth(texture_ID)
    EndIf
    If y<-ImageHeight(texture_ID)
      y=GadgetHeight(canvas_ID)
    EndIf
    
    SetColorDistanceSpriteMask_BF(30)
    
    ; - Call function #1 -
    result=BF(80, Get_animation_buffer_hidden_ID_canvas_BF(), texture_ID, ; Sprite mode
              0,                                   
              0,                                 
              x,                           
              y,                             
              ImageWidth(texture_ID),                           
              ImageHeight(texture_ID))
    ErrorCheck_BF(result)
    
    SetColorDistanceSpriteMask_BF(0)
    
    ; - Call sprite sheet #1 -
    Define frame
    result=Sprite_CSS_sheet_BF(1, Get_animation_buffer_hidden_ID_canvas_BF(), sheet_ID,
                               0,     ; Grab transparence color from sheet pos x - Set to -1 for output without invisible color 
                               0,     ; Grab transparence color from sheet pos y - You can set x or y, or both parameters to -1 
                               x,     ; Output position x
                               160,   ; Output position y
                               7,     ; Numbers of frames
                               frame, ; Selected frame
                               145,   ; Frame width
                               72,    ; Frame height
                               3)     ; Frames in a row  
    
    ErrorCheck_BF(result)
    If Delay_BF(1, 70) ; Background refresh delay - Timer 0, Time 10 ms - 100 timer available 0 - 99 - you can change
      frame+1 : If frame=7 : frame=0 : EndIf 
    EndIf
    
    ; Graphic output #1
    If arc>360 : arc=0 : EndIf
    x1-1 :y1+1 : arc+1
    If x1<-ImageWidth(texture_ID)+20
      x1=GadgetWidth(canvas_ID)+20
    EndIf
    If y1>GadgetHeight(canvas_ID)+20
      y1=-ImageHeight(texture_ID)-20
    EndIf
    
    If StartVectorDrawing(CanvasVectorOutput(Get_animation_buffer_hidden_ID_canvas_BF()))
      VectorSourceColor($FF20A5DA)
      MovePathCursor (x1 , y1)
      AddPathCircle (x1 , y1 , 30, 270, arc , #PB_Path_Connected)
      FillPath()
      StopVectorDrawing()
    EndIf
    
    CompilerIf #PB_Compiler_Version=>560
      SetImageFrame(gif_ID, frame_1) ; Set the GIF frame for processing
      Define frame_delay=GetImageFrameDelay(gif_ID) ; Get the GIF frame delay
      If Not frame_delay : frame_delay=100 : EndIf  ; Delay 0 works not, so as a standard, delay 0 = delay 100
      StartDrawing(ImageOutput(temporary_frame_ID)) ; Draw in the temporary frame buffer
      Box(0, 0, frame_width, frame_height, invisible_color) ; Draw the invisible color
      DrawingMode(#PB_2DDrawing_AlphaBlend)                 ; Enable GIF transparence color output
      DrawImage(ImageID(gif_ID),0 , 0)                      ; Draw the GIF frame in the temporary frame buffer
      StopDrawing()
      
      SetColorDistanceSpriteMask_BF(10)
      
      ; - GIF frame output
      result=Sprite_CSS_sheet_BF(1, Get_animation_buffer_hidden_ID_canvas_BF(), temporary_frame_ID,                                     
                                 0,            ; Grab transparence color from sprite pos x - For preset set ..x=-1                      
                                 0,            ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF  
                                 315,          ; Output position x
                                 155,          ; Output position y
                                 1,            ; Numbers of frames
                                 0,            ; Selected frame - For PB GIF compatibility the first frame is 0
                                 frame_width,  ; Frame width
                                 frame_height, ; Frame height
                                 1,            ; Frames in a row
                                 50,           ; New size x
                                 50,           ; New size y
                                 150,          ; Output width
                                 92,           ; Output height
                                 10,           ; Clip x
                                 4)            ; Clip y
      
      MirrorImage_BF(1, temporary_frame_ID)
      
      ; - GIF frame output
      result=Sprite_CSS_sheet_simple_BF(80, Get_animation_buffer_hidden_ID_canvas_BF(), temporary_frame_ID,                                     
                                        0,            ; Grab transparence color from sprite pos x - For preset set ..x=-1                      
                                        0,            ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF  
                                        600,          ; Output position x
                                        272,          ; Output position y
                                        1,            ; Numbers of frames
                                        0,            ; Selected frame - For PB GIF compatibility the first frame is 0
                                        frame_width,  ; Frame width
                                        frame_height, ; Frame height
                                        1)            ; Frames in a row
      
      ErrorCheck_BF(result)
      
      ; - GIF frame output rotated
      RotateSprite_simple_BF(1, Get_animation_buffer_hidden_ID_canvas_BF(), temporary_frame_ID,
                             0,   ; Grab transparence color from sprite pos x - For preset set ..x=-1                        
                             0,   ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF
                             436,
                             -95,
                             arc,
                             1,
                             80,
                             100,
                             -5,
                             44) ; Rotating degree
      
      ErrorCheck_BF(result)
      
      ; Frame delay - Using timer 1
      If delay : delay=0 : frame_1+1 : If frame_1=>frames : frame_1=0 : EndIf : Else : delay+Delay_BF(2, frame_delay) : EndIf
    CompilerEndIf
    
    ; Get the result
    CopyContent_Canvas_Canvas_BF(Get_animation_buffer_hidden_ID_canvas_BF(), canvas_ID) ; Put the hidden animation buffer in the canvas
    
  EndIf
  
ForEver
