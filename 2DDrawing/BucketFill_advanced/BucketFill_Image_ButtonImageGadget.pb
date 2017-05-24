XIncludeFile("./BucketFill_advanced.pbi")

; - Demo ButtonImageGadget

; The BF color button works also phantastic with photos and textures
; You can make fine photo embedding, or other effects, all you want, with endless variations

; A new created BF color button change the used texture, this is normal
; For further color buttons with the same included texture use so the original PB ButtonImageGadget

UsePNGImageDecoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define win_event, window_ID, texture_ID, texture_1_ID, result, i, delay, background_color, mode
Define button_width, button_height, button_image_gadget_ID, button_image_gadget_ID_1, seamless_shrink_factor
Define visibility_factor.f

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  Define font_1=LoadFont(1, "Arial", 11)
CompilerEndIf

; Presets
button_width=120
button_height=50
visibility_factor=70      ; Visibility factor - available from 1 to 100
seamless_shrink_factor=10 ; Reduce this value for larger pictures
delay=5                   ; Delay for color animation
mode=2                    ; mode=1, little seamless edges - mode=2 large seamless edges
                          ; The seamless halo reduce the visibility on little buttons,
                          ; so you must use a larger seamless_shrink_factor for little buttons (available from 1 to 50)

texture_ID=CreateImage(#PB_Any, button_width, button_height)

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore , 600, 400, "Bucket Fill Advanced - For Images",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

button_image_gadget_ID=ButtonImageGadget(#PB_Any, 230, 100, button_width, button_height, ImageID(texture_ID))

Delay(500)

; - Call function #1
If StartDrawing(ImageOutput(texture_ID))
  Box(0, 0, button_width, button_height, $00FF00)
  CompilerIf #PB_Compiler_OS=#PB_OS_Linux
    DrawingFont(font_1)
  CompilerEndIf
  CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
    DrawText(24, 18, "  Hello world  ", $00FFFF, $0000FF)
  CompilerElse
    DrawText(15, 17, "  Hello world  ", $00FFFF, $0000FF)
  CompilerEndIf
  StopDrawing() 
EndIf
background_color=$FFF ; Background color
result=ButtonImageGadget_BF(mode, button_image_gadget_ID, texture_ID,
                            background_color,
                            visibility_factor,
                            seamless_shrink_factor,
                            delay)
ErrorCheck_BF(result)

; - Call function #2
; Presets
button_width=180
button_height=60
mode=2                   ; mode=1, little seamless edges - mode=2 large seamless edges
visibility_factor=100    ; Visibility factor - Available from 1 to 100
background_color=$FF     ; Background color
seamless_shrink_factor=3 ; Reduce this value for larger pictures (=>300 max x or y  =1)
                         ; The seamless halo reduce the visibility on little buttons,
                         ; so you must use a larger seamless_shrink_factor for little buttons (available from 1 to 50)

texture_1_ID=CreateImage(#PB_Any, button_width, button_height)

button_image_gadget_ID=ButtonImageGadget(#PB_Any, 200, 180, button_width, button_height, ImageID(texture_1_ID))

If StartDrawing(ImageOutput(texture_1_ID))
  Box(0, 0, button_width, button_height, $FFFF)
  CompilerIf #PB_Compiler_OS=#PB_OS_Linux
    DrawingFont(font_1)
  CompilerEndIf
  CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
    DrawText(53, 22, "Hello  Klick me", 0, $FFFF)
  CompilerElse
    DrawText(45, 22, "Hello  Klick me", 0, $FFFF)
  CompilerEndIf
  StopDrawing() 
EndIf

result=ButtonImageGadget_BF(mode, button_image_gadget_ID, texture_1_ID,
                            background_color, 
                            visibility_factor,
                            seamless_shrink_factor,
                            delay)
ErrorCheck_BF(result)

Repeat
  win_event=WaitWindowEvent()
  If win_event=#PB_Event_CloseWindow
    FreeTextures_BF() ; Free grabed textures
    Break
  ElseIf win_event And EventGadget()=button_image_gadget_ID
    FreeImage(texture_1_ID)
    texture_1_ID=CreateImage(#PB_Any, button_width, button_height)
    i=~i
    If ~i
      ; - Call function #2
      If StartDrawing(ImageOutput(texture_1_ID))
        Box(0, 0, button_width, button_height, $FFFF)
        CompilerIf #PB_Compiler_OS=#PB_OS_Linux
          DrawingFont(font_1)
        CompilerEndIf
        CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
          DrawText(53, 22, "Hello  Klick me", 0, $FFFF)
        CompilerElse
          DrawText(45, 22, "Hello  Klick me", 0, $FFFF)
        CompilerEndIf
        StopDrawing() 
      EndIf
    Else
      If StartDrawing(ImageOutput(texture_1_ID))
        Box(0, 0, button_width, button_height, 0)
        CompilerIf #PB_Compiler_OS=#PB_OS_Linux
          DrawingFont(font_1)
        CompilerEndIf
        CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
          DrawText(53, 22, "Hello  Klick me", -1, 0)
        CompilerElse
          DrawText(45, 22, "Hello  Klick me", -1, 0)
        CompilerEndIf
        StopDrawing() 
      EndIf
    EndIf
    background_color=$FFF ; Background color
    result=ButtonImageGadget_BF(mode, button_image_gadget_ID, texture_1_ID,
                                background_color,
                                visibility_factor,
                                seamless_shrink_factor,
                                delay)
    
  EndIf
  
ForEver
