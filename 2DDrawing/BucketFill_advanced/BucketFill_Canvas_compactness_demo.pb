; Simple test output for sprites directly on canvas - Compactness demo, without any comments

XIncludeFile("./BucketFill_advanced.pbi")

UsePNGImageDecoder() : UseJPEGImageDecoder()
EnableExplicit

Define image_1_ID=LoadImage(#PB_Any, "./BucketFill_Image_Set/ogrelogo-small.jpg")
Define image_2_ID=LoadImage(#PB_Any, "./BucketFill_Image_Set/grass1.png")
Define image_3_ID=LoadImage(#PB_Any, "./BucketFill_Image_Set/RustySteel.jpg")
Define image_4_ID=LoadImage(#PB_Any, "./BucketFill_Image_Set/soil_wall.jpg")

If OpenWindow(1, 0, 0, 1000, 512, "BF Example", #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget) And CanvasGadget(1, 0, 0, 1000, 512)
  SpriteSimple_BF(1, 1, image_1_ID, -1, 0 ,0 ,0)
  SetColorDistanceFill_BF(25)
  FloodFill_BF(-2, 1, image_4_ID, 0, 0, 0, 0, 530)
  AlphaChannelSprite_BF(1, image_2_ID, 0, 1)
  SetColorDistanceSpriteMask_BF(15)
  SpriteSimple_BF(1, 1, image_1_ID, 0, 0, 550, 0, 400, 200)
  SetColorDistanceSpriteMask_BF(21)
  RotateSprite_simple_BF(1, 1, image_1_ID, 0, 0, 430, 40, 30)
  SetColorDistanceSpriteMask_BF(0)
  SetColorDistanceFill_BF(35)
  FloodFill_BF(-2, 1, image_3_ID, 720, 320)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

