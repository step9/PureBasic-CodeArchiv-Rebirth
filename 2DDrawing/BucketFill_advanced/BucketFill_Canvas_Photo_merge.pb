XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Photo merge -
; - Left mouse key = Brush - Right mouse key = Undo -

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
 UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define win_event, event_type, canvas_ID, window_ID, result, delay, snap
Define x, y, output_x, output_y, output_size_halfe_x, output_size_halfe_y, output_size_x, output_size_y
Define canvas_width, canvas_height, window_width, window_height, time_up, full_replace_color_delay
Define temp_image_ID, temp_image_0_ID, temp_image_1_ID, temp_image_2_ID, temp_image_3_ID, temp_image_4_ID
Define percent_visibility.f
Define path$

delay=20                      ; ms - Drawing repeat speed
full_replace_color_delay=1500 ; ms - Before this time, the function make a fine retouching
percent_visibility=0.1        ; Start value - Visibility starts with this value
output_size_x=35              ; Retouching rectangle size x - Min size x, y is 7 - This can plot one 100% visible point with a little halo
output_size_y=35              ; Retouching rectangle size y
window_width=900
window_height=600

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, window_width, window_height, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, 0, 0, window_width, window_height)

canvas_width=GadgetWidth(canvas_ID) : canvas_height=GadgetHeight(canvas_ID)

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

output_size_halfe_x=output_size_x>>1 : output_size_halfe_y=output_size_y>>1

; gtk warnings on linux (gtk3) you can ignore
path$=OpenFileRequester("Select a picture for embedding a other picture", "", "", 0)
If path$="" : End : EndIf

Delay(200)

temp_image_0_ID=LoadImage(#PB_Any, path$)

ResizeImage(temp_image_0_ID, canvas_width, canvas_height)

StartDrawing(CanvasOutput(canvas_ID))
DrawImage(ImageID(temp_image_0_ID), 0, 0)
StopDrawing()

path$=OpenFileRequester("Select a picture for embedding", "", "", 0)
If path$="" : End : EndIf

temp_image_1_ID=LoadImage(#PB_Any, path$)

ResizeImage(temp_image_1_ID, canvas_width, canvas_height)

temp_image_3_ID=CreateImage(#PB_Any, canvas_width, canvas_height)

StartDrawing(CanvasOutput(canvas_ID))
DrawingMode(#PB_2DDrawing_Transparent)
DrawText(20, 20, "A VERY COOL FUNCTION !", -1)
DrawText(20, 40, "BUCKET FILL ADVANCED", -1)
DrawText(20, 60, "www.quick-aes-256.de", -1)
DrawText(20, 80, "www.nachtoptik.de", -1)
DrawText(20, 100, "Sprites simple for Canvas", -1)
DrawText(20, 130, "Also FloodFill with texture support", -1)
StopDrawing()

; - Call function #1 -
result=BF(-2, temp_image_3_ID, temp_image_1_ID)
ErrorCheck_BF(result) 

temp_image_1_ID=CreateImage(#PB_Any, canvas_width+output_size_x<<1, canvas_height+output_size_y<<1)
temp_image_2_ID=CreateImage(#PB_Any, canvas_width+output_size_x<<1, canvas_height+output_size_y<<1)

StartDrawing(ImageOutput(temp_image_1_ID))
DrawImage(ImageID(temp_image_3_ID), output_size_x, output_size_y)
StopDrawing()

StartDrawing(ImageOutput(temp_image_2_ID))
DrawImage(ImageID(temp_image_0_ID), output_size_x, output_size_y)
StopDrawing()

NoCaching_BF(1) ; For immediately changed textures you can deactivate the BF texture caching

HideWindow(window_ID, 0)

Repeat
  win_event=WindowEvent()
  
  If win_event=#PB_Event_Gadget And EventGadget ()=canvas_ID
    event_type=EventType()
    
    If event_type=#PB_EventType_RightButtonUp
      Delay_BF(0, 0)
      time_up=0
      percent_visibility=0.1
    EndIf
    
    If event_type=#PB_EventType_LeftButtonUp
      Delay_BF(0, 0)
      time_up=0
      percent_visibility=0.1
    EndIf
    
    If event_type=#PB_EventType_LeftButtonDown Or
       (event_type=#PB_EventType_MouseMove And GetGadgetAttribute(canvas_ID, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
      snap=1
    ElseIf event_type=#PB_EventType_RightButtonDown Or
           (event_type=#PB_EventType_MouseMove And GetGadgetAttribute(canvas_ID, #PB_Canvas_Buttons) & #PB_Canvas_RightButton)
      snap=2
      Else : snap=0 : EndIf
    
    x=GetGadgetAttribute(canvas_ID, #PB_Canvas_MouseX) : y=GetGadgetAttribute(canvas_ID, #PB_Canvas_MouseY)
    
    output_x=x-output_size_halfe_x : output_y=y-output_size_halfe_y
    
    If snap And output_x>-output_size_x And output_y>-output_size_y And output_x<canvas_width And output_y<canvas_height
      
      If snap=1
        temp_image_ID=temp_image_1_ID
      Else
        temp_image_ID=temp_image_2_ID
      EndIf
      
      temp_image_4_ID=GrabImage(temp_image_ID, #PB_Any, output_x+output_size_x, output_y+output_size_y, output_size_x, output_size_y)
      
      ; - Call function #2 - 
      result=PhotoBrush_canvas_BF(4, canvas_ID, temp_image_4_ID, ; For canvas
                                  output_x,                      ; Output pos x
                                  output_y,                      ; Output pos y
                                  output_size_x,                 ; Texture or image width
                                  output_size_y,                 ; Texture or image height
                                  percent_visibility)            ; Percent visibility 
      
      ErrorCheck_BF(result)
      
      time_up+Delay_BF(0, full_replace_color_delay)
      
      If time_up>1 : percent_visibility+0.2 : EndIf
      
      FreeImage(temp_image_4_ID)
      
      Repeat : Delay(1) : Until Delay_BF(1, delay)
      
    EndIf 
    
  EndIf
  
Until win_event = #PB_Event_CloseWindow

FreeImage(temp_image_0_ID)
FreeImage(temp_image_1_ID)
FreeImage(temp_image_2_ID) 
FreeImage(temp_image_3_ID)
