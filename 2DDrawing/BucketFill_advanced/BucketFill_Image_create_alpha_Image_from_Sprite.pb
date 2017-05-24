XIncludeFile("./BucketFill_advanced.pbi")

; - Demo - Create a image with alpha channel from a sprite -

UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageDecoder()
CompilerIf #PB_Compiler_Version=>560
 UseGIFImageDecoder()
CompilerEndIf

EnableExplicit

Define path$=OpenFileRequester("Select a picture", "", "", 0)
If path$="" : End : EndIf

Define image_ID=LoadImage(#PB_Any, path$)

Define percent_color_distance=26 ; Set here a color distance for deleting mask artifacts

Define result=CreateAlphaImage_from_Sprite_BF(image_ID, percent_color_distance)
ErrorCheck_BF(result)

SaveImage(result, GetPathPart(path$)+GetFilePart(path$, #PB_FileSystem_NoExtension)+".png", #PB_ImagePlugin_PNG)


