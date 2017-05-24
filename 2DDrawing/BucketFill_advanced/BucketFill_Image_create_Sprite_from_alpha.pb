XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Create a masked sprite from a image with alpha channel - also GIF available -

UseJPEGImageDecoder()
UsePNGImageDecoder()
UseJPEGImageEncoder()
UsePNGImageEncoder()
CompilerIf #PB_Compiler_Version=>560
 UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define mask_color

Define path$=OpenFileRequester("Select a picture with alpha channel", "", "", 0) ; Available gtk warning on linux you can ignore
If path$="" : End : EndIf

Define image_ID=LoadImage(#PB_Any, path$)

; Manual mask color generating - Color distance influence the mask
mask_color=$FF00FF ; Set a color for the sprite mask - different from the picture content -  Best only a little different

; Automatik mask color generating - Color distance influence the mask
; mask_color=SearchUnusedColor_BF(image_ID, 0, 0, ImageWidth(image_ID)-1, ImageHeight(image_ID)-1)
; If mask_color<1 : mask_color=Random($FFFFFE, 1) : EndIf ; Fuse - Error handling for automatic mask color generating

Define percent_color_distance=30; You can set a color distance for the background color in percent

Define result_ID=CreateSprite_from_AlphaImage_BF(image_ID, mask_color, percent_color_distance)
ErrorCheck_BF(result_ID)

;==========================================================================================================
; This is a special part for cleaning the sprite mask or creating special effects, you can ignore or disable
; You can fine use this, but you must exactely understand what you do herewith
; Set the color distance function on a value before you become "Holes", this clean the sheet mask perfect
; Also you can set this value larger for making more colors transparence
SetColor_BF(mask_color)
SetColorDistanceFill_BF(0) ; percent
Define result=BF(-1, result_ID, mask_color)
ErrorCheck_BF(result)
;===========================================================================================================

; SaveImage(result_ID, GetPathPart(path$)+GetFilePart(path$, #PB_FileSystem_NoExtension)+"_.png", #PB_ImagePlugin_PNG, 10, 24)
SaveImage(result_ID, GetPathPart(path$)+GetFilePart(path$, #PB_FileSystem_NoExtension)+".jpg", #PB_ImagePlugin_JPEG, 10, 24)

