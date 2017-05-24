XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Clean a sprite mask - Also for sprite sheets
; This is a special function for cleaning the sprite mask or creating special effects
; You can fine use this, but you must exactely understand what you do herewith
; Set the color distance function on a value before you become "Holes", this clean the sprite mask perfect
; Also you can set this value larger for making more colors transparence

UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
  UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define path$=OpenFileRequester("Select a sprite or CSS sprite sheet", "", "", 0)
If path$="" : End : EndIf

Define image_ID=LoadImage(#PB_Any, path$)

Define percent_color_distance=30 ; Set here the color distance for the sprite mask

Define x=0 ; Get the mask color from this sprite coordinates
Define y=0

Define mask_color=GetImageColor_BF(image_ID, x, y)

; SetColor_BF($FF00FF) ; You can here also preset the sprite mask color

SetColorDistanceFill_BF(percent_color_distance)
Define result=BF(-1, image_ID, mask_color)
ErrorCheck_BF(result)

SaveImage(image_ID, GetPathPart(path$)+GetFilePart(path$, #PB_FileSystem_NoExtension)+"_.png", #PB_ImagePlugin_PNG)


