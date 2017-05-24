XIncludeFile("./BucketFill_advanced.pbi")

; Create a CSS sprite sheet from a GIF image PB 5.60 => needed
; This code generate a complete sheet from a GIF and also a separately info file

UsePNGImageDecoder()
UseJPEGImageDecoder()
UseGIFImageDecoder()
UsePNGImageEncoder()

EnableExplicit

Define gif_ID, sheet_ID, i, ii, iii, iiii, file, image_frame_delay, invisible_color
Define gif_width, gif_height, sheet_width, sheet_height, frames, frames_x, frames_y
Define path$

path$=OpenFileRequester("Select a GIF picture", "", "", 0)
If path$="" Or UCase(GetExtensionPart(path$))<>"GIF": End : EndIf

gif_ID=LoadImage(#PB_Any, path$) ; Sprite mode

gif_width=ImageWidth(gif_ID)
gif_height=ImageHeight(gif_ID)
frames=ImageFrameCount(gif_ID)
If gif_height>gif_width And frames>1
  frames_x=Sqr(frames)+1
Else
  frames_x=Sqr(frames)
EndIf
frames_y=frames/frames_x+1
sheet_width=frames_x*gif_width
sheet_height=frames_y*gif_height

For i=0 To frames-1
  iiii=iii : ii+gif_width
  If ii=>sheet_width
    ii=0 : iii+gif_height
  EndIf   
Next i
ii=0 : iii=0

sheet_height=iiii+gif_height

sheet_ID=CreateImage(#PB_Any, sheet_width, sheet_height)

For i=0 To frames-1
  SetImageFrame(gif_ID, i)
  StartDrawing(ImageOutput(sheet_ID))
  DrawImage(ImageID(gif_ID), ii, iii)
  StopDrawing()
  ii+gif_width
  If ii=>sheet_width
    ii=0 : iii+gif_height
  EndIf   
Next i
ii=0 : iii=0

invisible_color=SearchUnusedColor_BF(sheet_ID, 0, 0, sheet_width-1, sheet_height-1)
If invisible_color<1 : invisible_color=Random($FFFFFE, 1) : EndIf ; Fuse - Error handling for automatic mask color generating

; GIF can have different defined invisible colors for different frames
; This code define for the complete generated sheet a new invisible color, only one ! - This works very fine and make a sheet post processing very simple
; A sprite sheet is high flexible, mostly, i think, for using GIF like output inside a app sheet using is many better as GIF using
; BF can handle any sprite sheets very easy and simple, also lossly compressed sheets
; Movie like sheets without a invisible color you can fine compress as JPG files how ever you want
; For sheets with a used invisible color PNG works very fine, but you can compress this files also as JPG image

; For lossly compressed sheets with a used invisible color you must use the PB function SetColorDistanceSpriteMask_BF for clearing the sprite mask from compression artifacts
; For best results with lossly compressed sheets you can simple define also a own invisible color for each sheet
; Best results you become then with a invisible color nearly the color from the sprite content edges - So you can create simple also a nice edge blur for the sprites 

FreeImage(sheet_ID)

sheet_ID=CreateImage(#PB_Any, sheet_width, sheet_height, 24, invisible_color)

file=OpenFile(#PB_Any, GetPathPart(path$)+GetFilePart(path$, #PB_FileSystem_NoExtension)+"_sheet_info_BF.txt")

WriteStringN(file, "          Frames #"+RSet(Str(frames), 8, "0 "), #PB_Ascii)
WriteStringN(file, "     Frame width #"+RSet(Str(gif_width), 8, "0 "), #PB_Ascii)
WriteStringN(file, "    Frame height #"+RSet(Str(gif_height), 8, "0 "), #PB_Ascii)
WriteStringN(file, "     Sheet width #"+RSet(Str(sheet_width), 8, "0 "), #PB_Ascii)
WriteStringN(file, "    Sheet height #"+RSet(Str(sheet_height), 8, "0 "), #PB_Ascii)
WriteStringN(file, " Frames in a row #"+RSet(Str(frames_x), 8, "0 "), #PB_Ascii)
WriteStringN(file, " Invisible color #"+RSet(Str(invisible_color), 8, "0 ")+"   $"+RSet(Hex(invisible_color), 6, "0 "), #PB_Ascii)

For i=0 To frames-1
  SetImageFrame(gif_ID, i)
  image_frame_delay=GetImageFrameDelay(gif_ID)
  If Not image_frame_delay : image_frame_delay=100 ; Delay 0 works not, so as a standard, delay 0 = delay 100
                                                   ; ElseIf image_frame_delay<30 : image_frame_delay=30 ; Browsers can or will mostly not handle a delay <30ms
  EndIf
  WriteStringN(file, "   Frame / delay :"+RSet(Str(i), 8, "0 ")+" *"+RSet(Str(image_frame_delay), 8, "0"), #PB_Ascii)
  StartDrawing(ImageOutput(sheet_ID))
  DrawingMode(#PB_2DDrawing_AlphaBlend)
  DrawImage(ImageID(gif_ID), ii, iii)
  StopDrawing()
  ii+gif_width
  If ii=>sheet_width
    ii=0 : iii+gif_height
  EndIf   
Next i

CloseFile(file)

SaveImage(sheet_ID, GetPathPart(path$)+GetFilePart(path$, #PB_FileSystem_NoExtension)+".png", #PB_ImagePlugin_PNG, 10, 24)
