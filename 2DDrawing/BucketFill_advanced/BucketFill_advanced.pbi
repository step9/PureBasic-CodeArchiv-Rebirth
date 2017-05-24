; --- BucketFill_advanced GFX multi tool for PureBasic - www.nachtoptik.de - Author W. Albus © ---

DeclareModule BucketFill_advanced
  Declare ColorDistance_BF(color_1, color_2) ; Rudimentary - Changeable from integer to float result
  
  Declare ErrorCheck_BF(result_) ; Rudimentary error checks
  
  Declare Delay_BF(timer, time, internal=0) ; 100 delay timer available - 0 to 99 - Internal are 5 Timers = 100 to 104, use this five timers never for external (Protected with internal flag)
  
  Declare GetFloodArray_Adress_BF() ; The arrays are free manipulable - Manipulation do not damage things
  
  Declare GetBucketArray_Adress_BF()
  
  Declare GetSpriteArray_Adress_BF()
  
  Declare GetFloodArray_State_BF() ;  The array length is ever ImageWidth*ImageHeight*8 
  
  Declare GetBucketArray_State_BF() ; So you can test the BF arrays state before you use a BF array
  
  Declare GetSpriteArray_State_BF()
  
  Declare GetFloodArray_Point_BF(x, y) ; Get a point - -1=used - 0=unused - The arrays use quads
  
  Declare GetBucketArray_Point_BF(x, y)
  
  Declare GetSpriteArray_Point_BF(x, y)
  
  Declare PutFloodArray_Point_BF(point, x, y) ; Write in the arrays
  
  Declare PutBucketArray_Point_BF(point, x, y)
  
  Declare PutSpriteArray_Point_BF(point, x, y)
  
  Declare GetFlood_X_BF() ; Min output coordinate FloodFill
  
  Declare GetFlood_Y_BF()
  
  Declare GetFlood_XX_BF() ; Max
  
  Declare GetFlood_YY_BF()
  
  Declare GetBucket_X_BF() ; Min output coordinate BucketFill
  
  Declare GetBucket_Y_BF()
  
  Declare GetBucket_XX_BF() ; Max
  
  Declare GetBucket_YY_BF()
  
  Declare GetSprite_X_BF() ; Min output coordinate Sprite
  
  Declare GetSprite_Y_BF()
  
  Declare GetSprite_XX_BF() ; Max
  
  Declare GetSprite_YY_BF()
  
  Declare GetSprite_width_BF() ; Without mask - Before using you must activate the sprite array - Free rotate sprite activate the sprite array automatically - Points
  
  Declare GetSprite_height_BF() ; Points
  
  Declare GetFloodArray_length_BF() ; Array length - bytes
  
  Declare GetBucketArray_length_BF()
  
  Declare GetSpriteArray_length_BF()
  
  Declare GetFloodArray_width_BF() ; Array width - bytes
  
  Declare GetFloodArray_height_BF() ; Array height - bytes
  
  Declare GetBucketArray_width_BF()
  
  Declare GetBucketArray_height_BF()
  
  Declare GetSpriteArray_width_BF()
  
  Declare GetSpriteArray_height_BF()
  
  Declare GetImageColor_BF(image_ID, x, y) ; Get a color from a image or a texture
  
  Declare GetCanvasColor_BF(canvas_ID, x, y) ; Get a color from a canvas gadget
  
  Declare.q GetColor_BF() ; Get a placed color for replacing with a BucketFill texture
  
  Declare SetColor_BF(color.q) ; Set a color for replacing with a BucketFill texture
                               ; You must deactivate this again with -1 - For white set $FFFFFF
                               ; For using this presetted color set in each BucketFill call 
                               ; the parameter(s) .._get_color_x Or .._get_color_y to -1
  
  Declare ActivateSpriteArray_BF(activate) ; Activate and deactivate the BF sprite array - 1=activated - 2=get only the sprite output coordinates, without mask - You must deactivate again
  
  Declare ActivateFloodArray_BF(activate) ; Activate the min max output coordinates - 1=activated - The primary flood array is ever active - You must deactivate again
  
  Declare ActivateBucketArray_BF(activate) ; Activate and deactivate the BF BucketFill array - 1=activated - 2=get only min max output coordinates - You must deactivate again
  
  Declare SearchUnusedColor_BF(output_ID, x, y, xx, yy, delay=5) ; 0 and $FFFFFF is ignored - delay in seconds before search breaks                                                                          
  
  Declare SearchUsedColor_BF(output_ID, x, y, xx, yy, search_color) ; Usable for images and textures - Give back 0 or 1
  
  Declare SetColorDistanceFill_BF(percent_.f) ; Set color distance for all fill functions - This function influence borders from BucketFill and FloodFill
  
  Declare SetColorDistanceSpriteMask_BF(percent_.f) ; Set color distance for all functions with sprite output - This function influence ALL used textures
  
  Declare SetInvisibleColor_BF(color.q) ; Set the invisible color - Use this with care for sheets without a invisible color, or you can become "holes" in your output frames
                                        ; This use a QUAD, deactivate again with SetInvisibleColor_BF(-1) - For white set $FFFFFF - This is a globale function
                                        ; This deactivate "Grab transparence color from sheet pos" x, y
                                        ; -2 deactivate the invisible color
  
  Declare SetReplacingColor_BF(color.q) ; Set the color for replacing with BucketFill - This is a quad - It is presetted deactivated with -1 - Set it for white so $FFFFF
  
  Declare.f GetColorDistanceFill_BF() ; Get placed color distance for all fill functions
  
  Declare.f GetColorDistanceSpriteMask_BF() ; Get placed color distance for sprite mask
  
  Declare.q GetInvisibleColor_BF() ; Get the used invisible color
  
  Declare.q GetReplacingColor_BF() ; Get the color for replacing with BucketFill
  
  Declare AlphaBlend_BF(color_1, color_2, alpha) ; Rudimentary
  
  Declare.q FreeTextures_BF(mode=0) ; BF cache all used textures for highspeed sprite output
                                    ; Give free before you terminate your app or you become a memory leak
                                    ; 0=give all free - 1=Get amount cached textures- 2=Get required size for caching all textures in bytes
                                    ; This refresh also the cache and can so primary fix for your eyes strange animation problems
                                    ; Temporary used textures free selective with the function Free_selected_Texture_BF, this is the recommended way
  
  Declare Free_selected_Texture_BF(texture_ID, free_image=1) ; Delete a selected texture from texture cache and give free
                                                             ; Presetted is a included PB FreeImage call
                                                             ; free_image=0 = only remove from BF cache - free_image=1 = remove from BF cache and give the image free
                                                             ; Ever a texture is used from a BF function, BF cache the texture automatic
                                                             ; Sucks a animation, you must remove the image from the BF cache
                                                             ; Change you a texture content, you must remove the old unchanged texture from the cache
                                                             ; Is a texture not used from a BF function, you can give free with the PB FreeImage function
  
  Declare.q GrabImage_BF(image_ID) ; Create a buffer and grab - You become a pointer, give free again this memory
  
  Declare.q GrabCanvas_BF(canvas_ID) ; Create a buffer and grab - You become a pointer, give free again this memory
  
  Declare.q DrawingBuffer_image_BF(image_ID) ; Get the drawing buffer adress
  
  Declare.q DrawingBuffer_canvas_BF(canvas_ID) ; Get the drawing buffer adress
  
  Declare DrawingBuffer_length_image_BF(image_ID) ; Get the drawing buffer length
  
  Declare DrawingBuffer_pitch_image_BF(image_ID) ; Get the drawing buffer pitch
  
  Declare DrawingBuffer_length_canvas_BF(canvas_ID) ; Get the drawing buffer length
  
  Declare DrawingBuffer_pitch_canvas_BF(canvas_ID) ; Get the drawing buffer pitch
  
  Declare CopyContent_BF(source_ID, destination_ID) ; Move a content from image to image,  canvas to canvas, canvas to image, image to canvas (same sized)
                                                    ; This is a special function, primary for very simple temporary buffering backgrounds on animations
                                                    ; Using static ID with the same ID for source and destination works not
                                                    ; Use #PB_Any for ID generating or different Static ID for source and destination
                                                    ; This function is very easy but not very fast
  
  Declare CopyContent_Image_Image_BF(source_ID, destination_ID) ; Move a content from image to image
  
  Declare CopyContent_Canvas_Canvas_BF(source_ID, destination_ID) ; Move a content from canvas to canvas
  
  Declare CopyContent_Image_Canvas_BF(source_ID, destination_ID) ; Move a content from image to canvas
  
  Declare CopyContent_Canvas_Image_BF(source_ID, destination_ID) ; Move a content from canvas to image
  
  Declare FloodFill_BF(mode, output_ID, texture_ID,
                       x, ; Output coordinate x
                       y, ; Output coordinate y
                       texture_x=0, ; Further down you find the description for all texture parameters
                       texture_y=0, 
                       texture_width=0,
                       texture_height=0,
                       texture_clip_x=0,
                       texture_clip_y=0,
                       texture_clip_width=0,
                       texture_clip_height=0)
  ; mode = 0         - Set only a positioning marker
  ;       -1         - Ignore a texture and use a color - Set as texture_ID a color, as sample $FFFF00
  ;       -2         - Standard preset texture mode
  ;       -3 to -256 - Texture mode with alpha blending
  ; For compatibility with BucketFill this function use negative mode values, but it works at the same also with positive values
  
  ; Main (core) function
  Declare BF(mode, output_ID, texture_ID,
             output_get_color_x=0,  ; Get a color from this x coordinate for replacing with a texture (-1 = ignore the mask)
             output_get_color_y=0,  ; Get a color from this y coordinate for replacing with a texture (-1 = ignore the mask)
             texture_x=0,           ; Startposition texture output x - Preset 0
             texture_y=0,           ; Startposition texture output y   - Preset 0
             texture_width=0,       ; Endposition texture output       - Preset 0 = Clipping is automatic To canvas width 
             texture_height=0,      ; Endposition texture output       - Preset 0 = Clipping is automatic To canvas height 
             texture_clip_x=0,      ; Startposition inside the texture x - Preset 0
             texture_clip_y=0,      ; Startposition inside the texture y - Preset 0
             texture_clip_width=0,  ; Endposition inside the texture   - Preset 0 = full texture width
             texture_clip_height=0) ; Endposition inside the texture   - Preset 0 = full texture height
                                    ; mode = 0 - BucketFill  - Enable the little color positioning helper marker for texture mode
                                    ;        1 = Sprite mode - Without alpha blending - Standard preset sprite mode
                                    ;        2 to 256        - Sprite mode - With alpha blending
                                    ;       -1 = BucketFill  - Ignore a texture and use a color - Set as texture_ID a color, as sample $FFFF00
                                    ;       -2 = BucketFill  - Standard preset texture mode
                                    ;       -3 to -256       - BucketFill - Texture mode with alpha blending
                                    ; BF set the parameter for transparence (alpha) so : 1 = without transparence - 256 = full transparence (BF specific)
  
  ; This function grab the min x,y and the max x,y coordinates from a masked sprite, without mask and put the coordinates in the sprite real coordinate variables
  Declare GrabSpriteOffsets_BF(sprite_ID)
  ; GetSprite_X_BF() ; Min output coordinate Sprite 
  ; GetSprite_Y_BF()
  ; GetSprite_XX_BF() ; Max
  ; GetSprite_YY_BF()
  
  ; Function for using any images with alpha channel as sprites
  ; Use this function only for pictures with alpha channel, or you see nothing
  Declare AlphaChannelSprite_BF(output_ID, texture_ID,
                                texture_x,
                                texture_y,
                                texture_width=0,
                                texture_height=0,
                                texture_clip_x=0,
                                texture_clip_y=0,
                                texture_clip_width=0,
                                texture_clip_height=0)
  
  ; Function for simple using any images as sprites
  Declare SpriteSimple_BF(mode, output_ID, texture_ID,
                          image_get_color_x,     ; Grab transparence color from sprite pos x
                          image_get_color_y,     ; Grab transparence color from sprite pos y
                          output_pos_x,          ; Output pos x
                          output_pos_y,          ; Output pos y
                          output_width=0,        ; You can here resize the output x
                          output_height=0,       ; You can here resize the output y
                          alpha=1,               ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible (BF specific)
                          texture_width=0,       ; Endposition texture output       - Preset 0 = Clipping is automatic to output width
                          texture_height=0,      ; Endposition texture output       - Preset 0 = Clipping is automatic to output height
                          texture_clip_x=0,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                          texture_clip_y=0,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                          texture_clip_width=0,  ; Endposition inside the texture   - Preset 0 = full texture width
                          texture_clip_height=0) ; Endposition inside the texture   - Preset 0 = full texture height
                                                 ; You use clipping, "image_get_color.." get the invisible color from the clipped texture
                                                 ; For using pictures with alpha channel use mode=2
                                                 ; For using JPG based masked sprites, pre use SetColorDistanceSpriteMask_BF(percent) 
                                                 ; Mode 0 deactivate the invisible color- mode 1 activate the invisible color
                                                 ; Resizing can change the colors a little,
                                                 ; so it is available a presetted invisible color works after resizing not longer correct
  
  Declare Sprite_CSS_sheet_BF(alpha, output_ID, texture_ID, 
                              image_get_color_x,     ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                              image_get_color_y,     ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                              output_pos_x,          ; Output position x
                              output_pos_y,          ; Output position y
                              frames,                ; Numbers of frames
                              frame,                 ; Selected frame - For GIF compatibility the first frame is frame 0
                              frame_width,           ; Frame width
                              frame_height,          ; Frame height
                              frames_in_a_row=0,     ; Frames in a row - Preset 0, then BF calculate self
                              output_width=0,        ; Resizing - Define the output width - Preset zero = without resizing    - Presetted deactivated with  0
                              output_height=0,       ; Resizing - Define the output height   - Presetted deactivated with  0
                              texture_width=0,       ; Endposition texture output       - Preset 0 = Clipping is automatic to output width 
                              texture_height=0,      ; Endposition texture output       - Preset 0 = Clipping is automatic to output height 
                              texture_clip_x=0,      ; Startposition inside the texture - Preset 0 = The output starts with the texture x coordinate 0
                              texture_clip_y=0,      ; Startposition inside the texture - Preset 0 = The output starts with the texture y coordinate 0
                              texture_clip_width=0,  ; Endposition inside the texture   - Preset 0 = full texture width
                              texture_clip_height=0) ; Endposition inside the texture   - Preset 0 = full texture height
                                                     ; Set alpha for alpha blending from 1 > 256 - 1=full visible - 256=invisible (BF specific)
                                                     ; You use clipping, "image_get_color.." get the invisible color from the clipped texture
                                                     ; Resizing can change the colors a little,
                                                     ; so it is available a presetted invisible color works after resizing not longer correct
  
  Declare Sprite_CSS_sheet_simple_BF(mode, output_ID, texture_ID,
                                     image_get_color_x,     ; Grab transparence color from sprite pos x - For preset set ..x=-1                         
                                     image_get_color_y,     ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF  
                                     output_pos_x,          ; Output position x
                                     output_pos_y,          ; Output position y
                                     frames,                ; Numbers of frames
                                     frame,                 ; Selected frame - For GIF compatibility the first frame is 0
                                     frame_width,           ; Frame width
                                     frame_height,          ; Frame height
                                     frames_in_a_row=0,     ; Frames in a row - Preset 0, then BF calculate self
                                     output_width=0,        ; Resizing - Define the output width - Preset zero = without resizing 
                                     output_height=0,       ; Resizing - Define the output height
                                     texture_clip_x=0,      ; Startposition inside the texture - Preset 0
                                     texture_clip_y=0,      ; Startposition inside the texture - Preset 0
                                     texture_clip_width=0,  ; Endposition inside the texture - Preset 0 = full texture width
                                     texture_clip_height=0) ; Endposition inside the texture - Preset 0 = full texture height
                                                            ; mode 0 = Without invisible color
                                                            ; mode 1 > 256 = With invisible color and with alpha blending
                                                            ; mode -1 > -256 = Without invisible color and with alpha blending
                                                            ; This is a special function for very fast CSS sheet output- mode 0 is the fastest mode - Image output is a little faster as canvas output
                                                            ; The function is not based on the BF BucketFill core function, can so not output multiple pattern and works not with the BF sprite array
  
  Declare SpriteSimple_fast_BF(mode, output_ID, texture_ID,
                               image_get_color_x,     ; Grab transparence color from sprite pos x - For preset set ..x=-1                         
                               image_get_color_y,     ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF  
                               output_pos_x,          ; Output position x
                               output_pos_y,          ; Output position y
                               output_width=0,        ; Resizing - Define the output width - Preset zero = without resizing 
                               output_height=0,       ; Resizing - Define the output height
                               texture_clip_x=0,      ; Startposition inside the texture - Preset 0
                               texture_clip_y=0,      ; Startposition inside the texture - Preset 0
                               texture_clip_width=0,  ; Endposition inside the texture - Preset 0 = full texture width
                               texture_clip_height=0) ; Endposition inside the texture - Preset 0 = full texture height
                                                      ; mode 0 = Without invisible color
                                                      ; mode 1 > 256 = With invisible color and with alpha blending
                                                      ; mode -1 > -256 = Without invisible color and with alpha blending
                                                      ; This is a special function for very fast sprite or GIF output- mode 0 is the fastest mode - Image output is a little faster as canvas output
                                                      ; The function is not based on the BF BucketFill core function, can so not output multiple pattern and works not with the BF sprite array
  
  Declare CreateSprite_from_AlphaImage_BF(image_ID,
                                          mask_color, ; Set here a suitable color for the sprite mask (Different from the picture content color)
                                          percent_color_distance.f) ; You can set a color distance for the mask color in percent
  
  Declare CreateAlphaImage_from_Sprite_BF(image_ID,
                                          percent_color_distance.f) ; You can set a color distance for the mask color in percent
  
  Declare PhotoBrush_image_BF(mode, image_ID, texture_ID, 
                              x, ; Output coordinates
                              y,
                              texture_width,
                              texture_height,
                              percent_visibility.f=100)
  ; mode=-1 and 0  - Without seamless embedding - Fast
  ; mode=0         - Without seamless embedding - Fast (mode -1 and mode 0 equal for parameter compatibility to BF canvas)
  ; mode=1 to 3    - With seamless embedding
  ; percent_visibility - Visibility in percent
  
  Declare PhotoBrush_canvas_BF(mode, canvas_ID, photo_ID,
                               x, ; Output coordinates
                               y,
                               texture_width,
                               texture_height,
                               percent_visibility.f=100,
                               delay=0)
  ; mode=-1            - Without seamless embedding - Delay not available - Fast
  ; mode=0             - Without seamless embedding - Delay available - As sample for dia shows
  ; mode=1 to 3        - With seamless embedding    - Delay available
  ; mode=4             - Quick retouch mode         - Delay not available - Special seamless mode for picture retouching and embedding
  ; percent_visibility - Visibility in percent
  ; delay              - Delay for animation - ms
  ; A setted delay fire WindowEvent calls for refreshing the internal created seamless animation immediately,
  ;  so you become not all actually window events directly back after a animation output !
  ; Retouching rectangle size x, y is 7 - This can plot one 100% visible point with a little halo
  
  Declare ButtonImageGadget_BF(mode, ButtonImageGadget_ID, texture_ID,
                               background_color,
                               visibility_factor.f=100,  ; Visibility factor - Available from 1 to 100
                               seamless_invisibility=10, ; Reduce this value for larger pictures (=>300 max x or y =1)
                               delay=5)                  ; Delay for color animation -  availale from 1 to 100
                                                         ; mode=1, little seamless edges - mode=2 large seamless edges
                                                         ;  The seamless halo reduce the visibility on little buttons,
                                                         ;  so you must use a larger seamless invisibility factor for little buttons (available from 1 to 50)
  
  Declare RotateImage_BF(degree, image_ID,
                         create_new_image=0)  ; Set this parameter for creating a new rotated image
                                              ; degree = -90 (270) - 90 - 180
  
  ; Free rotating a sprite
  Declare RotateSprite_BF(texture_ID, 
                          image_get_color_x=0, ; Grab transparence color from sprite pos x - For preset set ..x=-1
                          image_get_color_y=0, ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF
                          degree=0,            ; Rotating degree - The sprite rotates around its center point - With the rotating_offsets you can relocate this point
                          mode=0,              ; mode=0 create a exactely resized sprite with minimized mask - mode=1 create a quadratic sprite for on demand rotation 
                          rotating_offset_x=0, ; Rotating offset x - For mode 1 - Do not make offsets too big - Bigger = slower, but I will give you not a limit
                          rotating_offset_y=0, ; Rotating offset y - You can also set negative values for the rotating offsets - As sample x=50 - y=-50 - This works very easy and simple
                          create_new_image=0)  ; Set this parameter for immediately creating a new rotated image - This is recommended for on demand rotation
                                               ; After using create_new_image you must give free again with FreeImage or you become a memory leak - Then the function give back the new created image ID
                                               ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                               ; So you can also simple create masked rotated sprites from all images without a included mask
                                               ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg (lossly) compressed sprites this is ever needed - Try ~ 25 > 35 percent 
  
  Declare RotateSprite_simple_BF(mode, output_ID, texture_ID,                              
                                 image_get_color_x=0, ; Grab transparence color from sprite pos x - For preset set ..x=-1
                                 image_get_color_y=0, ; Grab transparence color from sprite pos y - For preset set ..y= the color you want - as sample $FF00FF
                                 output_pos_x=0,      ; Output pos x
                                 output_pos_y=0,      ; Output pos y
                                 arc=0,               ; Rotating degree - On demand
                                 alpha=1,             ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible (BF specific) - On demand
                                 output_width=0,      ; You can here resize the output x - On demand
                                 output_height=0,     ; You can here resize the output y - On demand
                                 rotating_offset_x=0, ; Rotating offset x - For mode 1 - Do not make offsets too big - Bigger=slower, but I will give you not a limit
                                 rotating_offset_y=0) ; Rotating offset y - You can also set negative values for the rotating offsets - As sample x=50 - y=-50 - This works very easy and simple  
                                                      ; mode=1 create a exactely resized sprite with minimized mask - Centered with offsets
                                                      ; mode=2 create a exactely resized sprite with minimized mask - Centered
                                                      ; mode=3 create a exactely resized sprite with minimized mask - Left-aligned
                                                      ; The function can create and handle sprite masks automatically or manual, from textures, images or photos
                                                      ; So you can also simple create masked rotated sprites from all images without a included mask
                                                      ; You see mask artifacts, set ColorDistanceSpriteMask - For jpg (lossly) compressed sprites this is ever needed - Try ~ 25 > 35 percent 
                                                      ; For images set image_get_color_x=-1 and image_get_color_y to a unused image color, best similar the background color
                                                      ; Reduce for Images SetColorDistanceSpriteMask_BF or you can become "holes", but also nice effects
  
  Declare MirrorImage_BF(mode, image_ID,
                         create_new_image=0) ; Set this parameter for creating a new mirrored image -  Then the function give back the new created image ID
                                             ; mode=1 = horizontal - mode=2 = vertical
  
  Declare Texture_universal_output_BF(mode, output_ID, temporary_image_ID, texture_ID, temporary_color,
                                      texture_x=0,       ; Startposition texture output x   - Preset 0
                                      texture_y=0,       ; Startposition texture output y   - Preset 0
                                      texture_width=0,   ; Endposition texture output xx    - Preset 0 = Full available width
                                      texture_height=0,  ; Endposition texture output yy    - Preset 0 = Full available height
                                      texture_clip_x=0,  ; Startposition inside the texture - Preset 0   (Texture clipping)
                                      texture_clip_y=0,  ; Startposition inside the texture - Preset 0   (Texture clipping)
                                      texture_clip_xx=0, ; Endposition inside the texture   - Preset 0   (Texture clipping)
                                      texture_clip_yy=0) ; Endposition inside the texture   - Preset 0   (Texture clipping)
                                                         ; mode= 1 - Standard preset texture mode
                                                         ; mode= 2 > 256 - Texture mode with mode blending - 2=full visible - 256=invisible (BF specific)
                                                         ; mode=-1   Ignore a texture and use a color - Set as texture_ID a color, as sample $FFFF00 
                                                         ; mode=-2 > -256 - Ignore a texture and use a color - With mode blending 2=full visible - 256=invisible (BF specific)
                                                         ; This function with image output is faster as with canvas output
  
  Declare Create_animation_buffers_image_BF(output_ID) ; Create buffers for the animation
  
  Declare Create_animation_buffers_canvas_BF(output_ID) ; Create buffers for the animation
  
  Declare FlipBuffers_image_BF() ; Flip the animation buffers
                                 ; This works similar the PB FlipBuffers function, but it is more flexible
                                 ; You have three separately buffers - you can read and write ever each buffer
  
  Declare Free_animation_buffers_image_BF() ; Free animation buffers
  
  Declare Get_animation_buffer_background_ID_image_BF() ; Get the animation buffer image ID for the background
  
  Declare Get_animation_buffer_hidden_ID_image_BF() ; Get the animation buffer image ID for the temporary hidden drawing (Sprite Buffer)
  
  Declare FlipBuffers_canvas_BF() ; Flip the animation buffers
  
  Declare Free_animation_buffers_canvas_BF() ; Free animation buffers
  
  Declare Get_animation_buffer_background_ID_canvas_BF() ; Get the animation buffer image ID for the background
  
  Declare Get_animation_buffer_hidden_ID_canvas_BF() ; Get the animation buffer image ID for the temporary hidden drawing
  
  Declare NoCaching_BF(caching) ; Deactivate texture caching - You must activate again - Activated is presetted - This is a globale function
  
  Declare Get_caching_state_BF() ; Check is BF caching on or off
  
  Declare SetPosMarker_BF(output_ID, x, y) ; Set a positioning help marker
  
  Declare Create_invisible_GIF_color(gif_ID) ; This function create a new invisible color for a defined GIF- This change not the GIF self
                                             ; A created invisible color is never black or white
  
EndDeclareModule

Module BucketFill_advanced
  ; BucketFill advanced for PureBasic
  ; Author : W. Albus © 2016 - 2017 - www.nachtoptik.de - www.quick-aes-256.de
  ; All rights reserved.
  ; Redistribution and use in source and binary forms, with or without
  ; modification, are permitted provided that the following conditions
  ; are met:
  ; 1. Redistributions of source code must retain the above copyright
  ;    notice, this List of conditions and the following disclaimer.
  ; 2. Redistributions in binary form must reproduce the above copyright
  ;    notice, this List of conditions and the following disclaimer in the
  ;    documentation and/or other materials provided with the distribution.
  
  ; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS'
  ; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  ; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  ; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  ; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  ; SUBSTITUTE GOODS Or SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  ; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  ; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  ; POSSIBILITY OF SUCH DAMAGE.
  
  EnableExplicit
  
  Structure textures
    texture_ID.i
    *texture_buffer
    texture_clip_width.i
    texture_clip_height.i
    texture_percent_transparent.f
  EndStructure
  
  Global NewList textures.textures(), Dim picture_0.q(0, 0), Dim picture_1.q(0, 0), Dim picture_2.q(0, 0)
  Global texture_get_color.q=-1, old_texture_get_color.q=-1, new_color, invisible_color.q=-1, replacing_color.q=-1
  Global min_x_0, min_y_0, max_x_0, max_y_0, min_x_1, min_y_1, max_x_1, max_y_1, min_x_2, min_y_2, max_x_2, max_y_2, alpha_sprite
  Global activate_flood_array, activate_bucket_array, activate_sprite_array, flood_array_length, bucket_array_length, sprite_array_length
  Global flood_array_width, flood_array_height, bucket_array_width, bucket_array_height, sprite_array_width, sprite_array_height
  Global temporary_image_0_ID_BF, temporary_image_1_ID_BF, temporary_canvas_ID_BF, alpha_1, no_caching
  Global percent.f, percent_1.f 
  
  Procedure ColorDistance_BF(color_1, color_2)
    If color_1<>color_2
      ; Protected r1=color_1&$FFFFFF>>16, g1=(color_1&$FFFF)>>8, b1=color_1>>16
      ; Protected r2=color_2&$FFFFFF>>16, g2=(color_2&$FFFF)>>8, b2=color_2>>16
      ; Protected diff_red=Abs(r1-r2), diff_green=Abs(g1-g2), diff_blue=Abs(b1-b2)
      ; Protected r.f=diff_red/256, g.f=diff_green/256, b.f=diff_blue/256
      ; ProcedureReturn (r+g+b)/3*100
      !movd xmm0, [p.v_color_1] ; SSE2 - By Wilbert
      !movd xmm1, [p.v_color_2]
      !pslld xmm0, 8
      !pslld xmm1, 8
      !psadbw xmm0, xmm1
      !movd eax, xmm0 ; eax range [0, 765]
      !imul eax, 0x2176cc ; div by 7.65
      !add eax, 0x800000
      !shr eax, 24
      ProcedureReturn
    Else
      ProcedureReturn 0
    EndIf
  EndProcedure
  
    Procedure ColorDistance_(color_1, color_2)
      ; Protected r1=color_1&$FFFFFF>>16, g1=(color_1&$FFFF)>>8, b1=color_1>>16
      ; Protected r2=color_2&$FFFFFF>>16, g2=(color_2&$FFFF)>>8, b2=color_2>>16
      ; Protected diff_red=Abs(r1-r2), diff_green=Abs(g1-g2), diff_blue=Abs(b1-b2)
      ; Protected r.f=diff_red/256, g.f=diff_green/256, b.f=diff_blue/256
      ; ProcedureReturn (r+g+b)/3*100
      !movd xmm0, [p.v_color_1] ; SSE2 - By Wilbert
      !movd xmm1, [p.v_color_2]
      !pslld xmm0, 8
      !pslld xmm1, 8
      !psadbw xmm0, xmm1
      !movd eax, xmm0 ; eax range [0, 765]
      !imul eax, 0x2176cc ; div by 7.65
      !add eax, 0x800000
      !shr eax, 24
      ProcedureReturn
  EndProcedure
  
  ; Macro RGB(red, green, blue) : (((blue<<8+green)<<8)+red) : EndMacro ; Macro by eesau
  ; Macro Red(color)   : (color&$FFFFFF>>16) : EndMacro
  ; Macro Green(color) : (color&$FFFF)>>8    : EndMacro
  ; Macro Blue(color)  : (color>>16)         : EndMacro
  ; Macro AlphaBlend(color_1, color_2, alpha)
  ;   RGB(((Red(color_2)*alpha+Red(color_1)*(256-alpha))>>8),
  ;       ((Green(color_2)*alpha+Green(color_1)*(256-alpha))>>8),
  ;       ((Blue(color_2)*alpha+Blue(color_1)*(256-alpha))>>8))
  ; EndMacro
  
  Procedure AlphaBlend_(color_1, color_2, mix); mix [0, 255] ; By wilbert
    mix-1                                     ; BF like
    !movd xmm0, [p.v_color_1]
    !movd xmm1, [p.v_color_2]
    !movd xmm2, [p.v_mix]
    !punpcklbw xmm0, xmm0
    !punpcklbw xmm1, xmm1
    !punpcklbw xmm2, xmm2
    !pcmpeqw xmm3, xmm3
    !pshuflw xmm2, xmm2, 0
    !pxor xmm3, xmm2
    !pmulhuw xmm1, xmm2
    !pmulhuw xmm0, xmm3
    !paddw xmm0, xmm1
    !psrlw xmm0, 8
    !packuswb xmm0, xmm0
    !movd eax, xmm0
    ProcedureReturn
  EndProcedure
  Macro AlphaBlend(color_1, color_2, alpha)
    AlphaBlend_(color_1, color_2, alpha)
  EndMacro 
  
  Macro error_message
    "The function is terminated !"+#LF$+#LF$+"##"+RSet(Str(Abs(result_)), 2, "0")
  EndMacro
  
  Global to_filtering.l                                            
  Macro filter(callback, lParam=0)                           
    to_filtering=lParam                                      
    CustomFilterCallback(callback)                                  
  EndMacro                                                           
  
  Procedure filter_callback_1(x, y, source_color, destination_color)
    If source_color=to_filtering
      ProcedureReturn destination_color
    EndIf
    If percent
      If ColorDistance_(source_color, to_filtering)<=percent
        If alpha_1>1 
          source_color=AlphaBlend(source_color, destination_color, alpha_1)
        EndIf 
        ProcedureReturn destination_color                                                                    
      EndIf
    EndIf
    If alpha_1>1
      source_color=AlphaBlend(source_color, destination_color, alpha_1)
    EndIf 
    ProcedureReturn source_color
  EndProcedure
  
  Procedure filter_callback_2(x, y, source_color, destination_color)
    source_color&$FFFFFF 
    If source_color=to_filtering
      ProcedureReturn destination_color
    EndIf 
    If percent
      If ColorDistance_(source_color, to_filtering)<=percent
        If alpha_1>1
          destination_color&$FFFFFF 
          source_color=AlphaBlend(source_color, destination_color, alpha_1)
        EndIf 
        ProcedureReturn destination_color                                                                    
      EndIf
    EndIf
    If alpha_1>1
      destination_color&$FFFFFF 
      source_color=AlphaBlend(source_color, destination_color, alpha_1)
    EndIf 
    ProcedureReturn source_color
  EndProcedure 
  
  Procedure filter_callback_3(x, y, source_color, destination_color)    
    source_color=AlphaBlend(source_color, destination_color, alpha_1) 
    If ColorDistance_BF(source_color, to_filtering)<=percent
      ProcedureReturn destination_color                                                                     
    EndIf
    ProcedureReturn source_color
  EndProcedure 
  
  Procedure ErrorCheck_BF(result_)
    Protected result
    Protected bf_type$="BucketFill advanced"
    Protected error$="  ERROR"
    Select result_
      Case -1
        MessageRequester(error$, bf_type$+" - Canvas not found"+#LF$+#LF$+error_message)                           
      Case -2
        MessageRequester(error$, bf_type$+" - Texture not found"+#LF$+#LF$+error_message)
      Case -3
        MessageRequester(error$, bf_type$+" - Output start drawing fail"+#LF$+#LF$+error_message)
      Case -4
        MessageRequester(error$, bf_type$+" - Texture - Start drawing fail"+#LF$+#LF$+error_message)
      Case -5
        MessageRequester(error$, bf_type$+" - Canvas - Start drawing fail"+#LF$+#LF$+error_message)
      Case -6
        MessageRequester(error$, bf_type$+" - Creating image fail"+#LF$+#LF$+error_message)
      Case -7
        MessageRequester(error$, bf_type$+" - Creating canvas fail"+#LF$+#LF$+error_message)
      Case -8
        MessageRequester(error$, bf_type$+" - Parameter wrong"+#LF$+#LF$+error_message)
      Case -9
        MessageRequester(error$, bf_type$+" - Function result fails"+#LF$+#LF$+error_message)
      Case -10
        MessageRequester(error$, bf_type$+" - Image not found"+#LF$+#LF$+error_message)
      Case -11
        MessageRequester(error$, bf_type$+" - Output not found"+#LF$+#LF$+error_message)
      Case -12
        MessageRequester(error$, bf_type$+" - Grab output - Start drawing fail"+#LF$+#LF$+error_message)
      Case -13
        MessageRequester(error$, bf_type$+" - Grab output - Allocate memory fail"+#LF$+#LF$+error_message)
      Case -14
        MessageRequester(error$, bf_type$+" - Drawing buffer - Start drawing fail"+#LF$+#LF$+error_message)
      Case -15
        MessageRequester(error$, bf_type$+" - Drawing buffer - Drawing buffer fail"+#LF$+#LF$+error_message)
      Default
        result=1
    EndSelect
    ; ProcedureReturn result ; Handle errors how you want
    ; The messages are a little helpfull on development - Run your programm you should never seen any again
    If Not result : End : EndIf
  EndProcedure
  
  Procedure Delay_BF(timer, time, internal=0) ; A first call results directly 1 - Disable a counter, as sample counter 0 with (0, 0)
    If Not time Or (timer>99 And Not internal) : ProcedureReturn 1 : EndIf
    Static Dim time_1.q(104) ; 100 delay timer available - 0 to 99 - Internal are 5 Timers = 100 to 104, use this five timers never for external (Protected with internal flag)
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86 ; Based on x86 timer code by Danilo
      Static ElapsedMilliseconds_64_oldValue.q=0
      Static ElapsedMilliseconds_64_overflow.q=0
      Static time_result.q
      Protected current_ms.q=ElapsedMilliseconds()&$FFFFFFFF
      If ElapsedMilliseconds_64_oldValue>current_ms
        ElapsedMilliseconds_64_overflow+1
      EndIf  
      ElapsedMilliseconds_64_oldValue=current_ms
      time_result=current_ms+ElapsedMilliseconds_64_overflow*$FFFFFFFF
      If time_result>time_1(timer)+time
        time_1(timer)=time_result
        ProcedureReturn 1
      Else
        ProcedureReturn 0
      EndIf
    CompilerElse
      If ElapsedMilliseconds()>time_1(timer)+time
        time_1(timer)=ElapsedMilliseconds()
        ProcedureReturn 1
      Else
        ProcedureReturn 0
      EndIf
    CompilerEndIf
  EndProcedure
  
  Procedure AlphaBlend_BF(color_1, color_2, alpha)
    ProcedureReturn AlphaBlend(color_1, color_2, alpha)
  EndProcedure
  
  Procedure.q FreeTextures_BF(mode=0)
    Protected needed_size.q
    If Not mode
      ForEach(textures())
        FreeMemory(textures()\texture_buffer)
      Next
      ClearList(textures())
      ProcedureReturn 1
    ElseIf mode=1
      ProcedureReturn ListSize(textures())
    ElseIf mode=2
      ForEach(textures())
        needed_size+MemorySize(textures()\texture_buffer)
      Next
      ProcedureReturn needed_size
    EndIf
  EndProcedure
  
  Procedure Free_selected_Texture_BF(texture_ID, free_image=1)
    Protected i
    If free_image And IsImage(texture_ID)
      FreeImage(texture_ID)
    EndIf
    While i<ListSize(textures())-1
      SelectElement(textures(), i)
      While NextElement(textures())
        If textures()\texture_ID=texture_ID ; Delete all found
          FreeMemory(textures()\texture_buffer)
          DeleteElement(textures())
        EndIf
      Wend
      i+1
    Wend
  EndProcedure
  
  Procedure GetFloodArray_Adress_BF()
    ProcedureReturn @picture_0()
  EndProcedure
  
  Procedure GetBucketArray_Adress_BF()
    ProcedureReturn @picture_1()
  EndProcedure
  
  Procedure GetSpriteArray_Adress_BF()
    ProcedureReturn @picture_2()
  EndProcedure
  
  Procedure GetFloodArray_State_BF()
    ProcedureReturn activate_flood_array
  EndProcedure
  
  Procedure GetBucketArray_State_BF()
    ProcedureReturn activate_bucket_array
  EndProcedure
  
  Procedure GetSpriteArray_State_BF()
    ProcedureReturn activate_sprite_array
  EndProcedure
  
  Procedure GetFloodArray_Point_BF(x, y)
    ProcedureReturn picture_0(x, y)
  EndProcedure
  
  Procedure GetBucketArray_Point_BF(x, y)
    ProcedureReturn picture_1(x, y)
  EndProcedure
  
  Procedure GetSpriteArray_Point_BF(x, y)
    ProcedureReturn picture_2(x, y)
  EndProcedure
  
  Procedure PutFloodArray_Point_BF(point, x, y)
    picture_0(x, y)=point
  EndProcedure
  
  Procedure PutBucketArray_Point_BF(point, x, y)
    picture_1(x, y)=point
  EndProcedure
  
  Procedure PutSpriteArray_Point_BF(point, x, y)
    picture_2(x, y)=point
  EndProcedure
  
  Procedure GetFlood_X_BF()
    ProcedureReturn min_x_0
  EndProcedure
  
  Procedure GetFlood_Y_BF()
    ProcedureReturn min_y_0
  EndProcedure
  
  Procedure GetFlood_XX_BF()
    ProcedureReturn max_x_0
  EndProcedure
  
  Procedure GetFlood_YY_BF()
    ProcedureReturn max_y_0
  EndProcedure
  
  Procedure GetBucket_X_BF()
    ProcedureReturn min_x_1
  EndProcedure
  
  Procedure GetBucket_Y_BF()
    ProcedureReturn min_y_1
  EndProcedure
  
  Procedure GetBucket_XX_BF()
    ProcedureReturn max_x_1
  EndProcedure
  
  Procedure GetBucket_YY_BF()
    ProcedureReturn max_y_1
  EndProcedure
  
  Procedure GetSprite_X_BF()
    ProcedureReturn min_x_2
  EndProcedure
  
  Procedure GetSprite_Y_BF()
    ProcedureReturn min_y_2
  EndProcedure
  
  Procedure GetSprite_XX_BF()
    ProcedureReturn max_x_2
  EndProcedure
  
  Procedure GetSprite_YY_BF()
    ProcedureReturn max_y_2
  EndProcedure
  
  Procedure GetSprite_width_BF()
    ProcedureReturn max_x_2-min_x_2
  EndProcedure
  
  Procedure GetSprite_height_BF()
    ProcedureReturn max_y_2-min_y_2
  EndProcedure
  
  Procedure GetFloodArray_length_BF()
    ProcedureReturn flood_array_length
  EndProcedure 
  
  Procedure GetBucketArray_length_BF()
    ProcedureReturn bucket_array_length
  EndProcedure
  
  Procedure GetSpriteArray_length_BF()
    ProcedureReturn sprite_array_length
  EndProcedure 
  
  Procedure GetFloodArray_width_BF()
    ProcedureReturn flood_array_width
  EndProcedure 
  
  Procedure GetFloodArray_height_BF()
    ProcedureReturn flood_array_height
  EndProcedure 
  
  Procedure GetBucketArray_width_BF()
    ProcedureReturn bucket_array_width
  EndProcedure 
  
  Procedure GetBucketArray_height_BF()
    ProcedureReturn bucket_array_height
  EndProcedure 
  
  Procedure GetSpriteArray_width_BF()
    ProcedureReturn sprite_array_width
  EndProcedure 
  
  Procedure GetSpriteArray_height_BF()
    ProcedureReturn sprite_array_height
  EndProcedure 
  
  Procedure GetImageColor_BF(image_ID, x, y)
    Protected point
    If Not IsImage(image_ID) : ProcedureReturn -10 : EndIf
    If StartDrawing(ImageOutput(image_ID))
      If x>-1 And x<ImageWidth(image_ID) And y>-1 And y<ImageHeight(image_ID)
        point=Point(x, y)
      EndIf
      StopDrawing()
    Else
      ProcedureReturn -4
    EndIf
    ProcedureReturn point
  EndProcedure
  
  Procedure GetCanvasColor_BF(canvas_ID, x, y)
    Protected point
    If Not IsGadget(canvas_ID) : ProcedureReturn -1 : EndIf
    If StartDrawing(CanvasOutput(canvas_ID))
      If x>-1 And x<GadgetWidth(canvas_ID) And y>-1 And y<GadgetHeight(canvas_ID)
        point=Point(x, y)
      EndIf
      StopDrawing()
    Else
      ProcedureReturn -4
    EndIf
    ProcedureReturn point
  EndProcedure 
  
  Procedure.q GetColor_BF()
    ProcedureReturn texture_get_color
  EndProcedure
  
  Procedure SetColor_BF(color.q)
    texture_get_color=color
  EndProcedure
  
  Procedure SetColorDistanceFill_BF(percent_.f)
    percent_1=percent_
  EndProcedure
  
  Procedure SetColorDistanceSpriteMask_BF(percent_.f)
    percent=percent_
  EndProcedure
  
  Procedure SetInvisibleColor_BF(color.q)
    invisible_color=color
  EndProcedure
  
  Procedure SetReplacingColor_BF(color.q)
    replacing_color=color
  EndProcedure
  
  Procedure.f GetColorDistanceFill_BF()
    ProcedureReturn percent_1
  EndProcedure
  
  Procedure.f GetColorDistanceSpriteMask_BF()
    ProcedureReturn percent
  EndProcedure
  
  Procedure.q GetInvisibleColor_BF()
    ProcedureReturn invisible_color
  EndProcedure
  
  Procedure.q GetReplacingColor_BF()
    ProcedureReturn replacing_color
  EndProcedure
  
  Procedure ActivateFloodArray_BF(activate)
    If activate
      activate_flood_array=1
    Else
      activate_flood_array=0
    EndIf
  EndProcedure
  
  Procedure ActivateBucketArray_BF(activate)
    If activate
      activate_bucket_array=1
    Else
      activate_bucket_array=0
    EndIf
  EndProcedure
  
  Procedure ActivateSpriteArray_BF(activate)
    If activate
      activate_sprite_array=1
    Else
      activate_sprite_array=0
    EndIf
  EndProcedure
  
  Procedure SearchUnusedColor_BF(output_ID, x, y, xx, yy, delay=5)  
    Protected test_color.q, i, ii, result, delay_1
    
    If Not IsImage(output_ID)
      If IsGadget(output_ID) ; Check for canvas
        Protected canvas=1
      Else
        ProcedureReturn -11
      EndIf
    EndIf
    
    If canvas
      Protected output_width=GadgetWidth(output_ID)-1
      Protected output_height=GadgetHeight(output_ID)-1
    Else
      output_width=ImageWidth(output_ID)-1
      output_height=ImageHeight(output_ID)-1
    EndIf
    
    If x<0 : x=0 : EndIf
    If y<0 : y=0 : EndIf
    If x>output_width : x=output_width : EndIf
    If y>output_height : y=output_height : EndIf
    If xx>output_width : xx=output_width : EndIf
    If yy>output_height : yy=output_height : EndIf
    If x>xx : x=xx : EndIf
    If y>yy : y=yy : EndIf
    
    Delay_BF(100, 0, 1) ; Init internal counter
    
    If canvas
      result=StartDrawing(CanvasOutput(output_ID))
    Else
      result=StartDrawing(ImageOutput(output_ID))
    EndIf
    
    If result
      search_again:
      delay_1+Delay_BF(100, 1000)
      If delay_1>delay
        StopDrawing()
        ProcedureReturn 0
      EndIf    
      test_color=Random($FFFFFE, 1) ; Ignore 0 and $FFFFFF
      For i=y To yy
        For ii=x To xx
          If test_color=Point(ii, i)
            Goto search_again 
          EndIf
        Next ii
      Next i
      StopDrawing()
      ProcedureReturn test_color
    Else
      ProcedureReturn -11
    EndIf
  EndProcedure
  
  Procedure SearchUsedColor_BF(output_ID, x, y, xx, yy, search_color)
    Protected i, ii, result
    
    If Not IsImage(output_ID)
      If IsGadget(output_ID) ; Check for canvas
        Protected canvas=1
      Else
        ProcedureReturn -11
      EndIf
    EndIf
    
    If canvas
      Protected output_width=GadgetWidth(output_ID)-1
      Protected output_height=GadgetHeight(output_ID)-1
    Else
      output_width=ImageWidth(output_ID)-1
      output_height=ImageHeight(output_ID)-1
    EndIf
    
    If x<0 : x=0 : EndIf
    If y<0 : y=0 : EndIf
    If x>output_width : x=output_width : EndIf
    If y>output_height : y=output_height : EndIf
    If xx>output_width : xx=output_width : EndIf
    If yy>output_height : yy=output_height : EndIf
    If x>xx : x=xx : EndIf
    If y>yy : y=yy : EndIf
    
    If canvas
      result=StartDrawing(CanvasOutput(output_ID))
    Else
      result=StartDrawing(ImageOutput(output_ID))
    EndIf
    
    If result
      For i=y To yy
        For ii=x To xx
          If search_color=Point(ii, i)
            StopDrawing()
            ProcedureReturn 1
          EndIf
        Next ii
      Next i
      StopDrawing()
    Else
      ProcedureReturn -11
    EndIf
    ProcedureReturn 0
  EndProcedure
  
  Procedure.q GrabImage_BF(image_ID)
    Protected *drawing_buffer_grabed_image, drawing_buffer_len
    If Not IsImage(image_ID) : ProcedureReturn -10 : EndIf
    If Not StartDrawing(ImageOutput(image_ID))
      ProcedureReturn -12
    EndIf
    drawing_buffer_len=DrawingBufferPitch()*OutputHeight()
    *drawing_buffer_grabed_image=AllocateMemory(drawing_buffer_len, #PB_Memory_NoClear)
    If Not *drawing_buffer_grabed_image
      StopDrawing()
      ProcedureReturn -13
    EndIf
    CopyMemory(DrawingBuffer(), *drawing_buffer_grabed_image, drawing_buffer_len)
    StopDrawing()
    ProcedureReturn *drawing_buffer_grabed_image
  EndProcedure
  
  Procedure.q GrabCanvas_BF(canvas_ID)
    Protected *drawing_buffer_grabed_canvas, drawing_buffer_len
    If Not IsGadget(canvas_ID) : ProcedureReturn -1 : EndIf
    If Not StartDrawing(CanvasOutput(canvas_ID))
      ProcedureReturn -12
    EndIf
    drawing_buffer_len=DrawingBufferPitch()*OutputHeight()
    *drawing_buffer_grabed_canvas=AllocateMemory(drawing_buffer_len, #PB_Memory_NoClear)
    If Not *drawing_buffer_grabed_canvas
      StopDrawing()
      ProcedureReturn -13
    EndIf
    CopyMemory(DrawingBuffer(), *drawing_buffer_grabed_canvas, drawing_buffer_len)
    StopDrawing()
    ProcedureReturn *drawing_buffer_grabed_canvas
  EndProcedure
  
  Procedure.q DrawingBuffer_image_BF(image_ID)
    Protected *drawing_buffer
    If Not IsImage(image_ID) : ProcedureReturn -10 : EndIf
    If Not StartDrawing(ImageOutput(image_ID))
      ProcedureReturn -14
    EndIf
    *drawing_buffer=DrawingBuffer()
    If Not *drawing_buffer
      StopDrawing()
      ProcedureReturn -15
    EndIf
    StopDrawing()
    ProcedureReturn *drawing_buffer
  EndProcedure
  
  Procedure.q DrawingBuffer_canvas_BF(canvas_ID)
    Protected *drawing_buffer
    If Not IsGadget(canvas_ID) : ProcedureReturn -1 : EndIf
    If Not StartDrawing(CanvasOutput(canvas_ID))
      ProcedureReturn -14
    EndIf
    *drawing_buffer=DrawingBuffer()
    If Not *drawing_buffer
      StopDrawing()
      ProcedureReturn -15
    EndIf
    StopDrawing()
    ProcedureReturn *drawing_buffer
  EndProcedure
  
  Procedure BF(mode, output_ID, texture_ID,
               output_get_color_x=0,
               output_get_color_y=0,
               texture_x=0,
               texture_y=0, 
               texture_width=0,
               texture_height=0,
               texture_clip_x=0,
               texture_clip_y=0,
               texture_clip_width=0,
               texture_clip_height=0)
    
    Protected temp_pos_s_x, temp_pos_s_y, temp_s_y, i, ii, mode_1, break_height
    Protected image_width, image_height, image_width_1, image_height_1, texture_height_offset
    Protected texture_width_, texture_height_, point, refresh_texture, texture_point, result, canvas
    Protected used_image_color.q
    Protected *texture_buffer
    
    If Not IsImage(output_ID)
      If IsGadget(output_ID) ; Check for canvas
        canvas=1
      Else
        ProcedureReturn -11
      EndIf
    EndIf
    
    If Not IsImage(texture_ID) And mode<>-1
      ProcedureReturn -2
    EndIf
    
    If mode<-256 Or mode>256
      mode=0
    EndIf
    
    If mode=-1
      texture_width_=0
      texture_height_=0
    Else
      texture_width_=ImageWidth(texture_ID)-1
      texture_height_=ImageHeight(texture_ID)-1
    EndIf
    
    If Not canvas
      image_width_1=ImageWidth(output_ID)
      image_height_1=ImageHeight(output_ID)
      If texture_width>image_width_1-texture_x Or texture_width<1
        texture_width=image_width_1-texture_x
      EndIf
      If texture_height>image_height_1-texture_y Or texture_height<1
        texture_height=image_height_1-texture_y
      EndIf
    Else
      image_width_1=GadgetWidth(output_ID)
      image_height_1=GadgetHeight(output_ID)
      If texture_width>image_width_1-texture_x Or texture_width<1
        texture_width=image_width_1-texture_x
      EndIf
      If texture_height>image_height_1-texture_y Or texture_height<1
        texture_height=image_height_1-texture_y
      EndIf
    EndIf
    
    image_width=image_width_1-1
    image_height=image_height_1-1
    
    If activate_bucket_array And mode<1     
      max_x_1=0
      max_y_1=0
      min_x_1=image_width
      min_y_1=image_height
      If activate_bucket_array<2
        Dim picture_1(image_width , image_height)
        bucket_array_length=(image_width_1*image_height_1)<<3
        bucket_array_width=image_width_1
        bucket_array_height=image_height_1
      EndIf
    EndIf
    
    If activate_sprite_array
      max_x_2=0
      max_y_2=0
      min_x_2=image_width
      min_y_2=image_height
      If activate_sprite_array<2
        Dim picture_2(image_width , image_height)
        sprite_array_length=(image_width_1*image_height_1)<<3
        sprite_array_width=image_width_1
        sprite_array_height=image_height_1
      EndIf
    EndIf
    
    texture_clip_width-1
    texture_clip_height-1
    
    If texture_clip_width>texture_width_ Or texture_clip_width<0
      texture_clip_width=texture_width_
    EndIf
    If texture_clip_height>texture_height_ Or texture_clip_height<1
      texture_clip_height=texture_height_
    EndIf
    
    If texture_clip_x<0 Or texture_clip_x>texture_clip_width
      texture_clip_x=0
    EndIf
    If texture_clip_y<0 Or texture_clip_y>texture_clip_height
      texture_clip_y=0
    EndIf
    
    If output_get_color_x<0 Or output_get_color_y<0
      output_get_color_x=-1
      output_get_color_y=-1
    EndIf
    
    If mode>0  
      If output_get_color_x>texture_clip_width-texture_clip_x
        output_get_color_x=0
      EndIf
      If output_get_color_y>texture_clip_height-texture_clip_y
        output_get_color_y=0
      EndIf
    Else
      If output_get_color_x>image_width
        output_get_color_x=0
      EndIf
      If output_get_color_y>image_height
        output_get_color_y=0
      EndIf
    EndIf
    
    texture_clip_width-texture_clip_x
    texture_clip_height-texture_clip_y
    
    Protected Dim texture(texture_clip_width, texture_clip_height)
    
    If  mode>0 And output_get_color_x>-1
      If StartDrawing(ImageOutput(texture_ID))
        used_image_color=Point(output_get_color_x+texture_clip_x, output_get_color_y+texture_clip_y)
        StopDrawing()
      Else
        ProcedureReturn -4
      EndIf
    Else
      If texture_get_color<>-1
        used_image_color=texture_get_color
        If old_texture_get_color<>texture_get_color
          old_texture_get_color=texture_get_color
          refresh_texture=1
        EndIf
        used_image_color=texture_get_color
      EndIf
    EndIf
    
    Macro get_texture
      If StartDrawing(ImageOutput(texture_ID))
        If alpha_sprite
          DrawingMode(#PB_2DDrawing_AlphaBlend)
        EndIf
        
        If output_get_color_x>-1
          If percent>0 And Not alpha_sprite
            
            For i=0 To texture_clip_height
              For ii=0 To texture_clip_width
                point=Point(ii+texture_clip_x, i+texture_clip_y)
                If ColorDistance_BF(point, used_image_color)<=percent
                  texture(ii, i)=used_image_color
                Else
                  texture(ii, i)=point
                EndIf
              Next ii
            Next i
          Else
            For i=0 To texture_clip_height
              For ii=0 To texture_clip_width
                point=Point(ii+texture_clip_x, i+texture_clip_y)
                If point=used_image_color
                  texture(ii, i)=used_image_color
                Else
                  texture(ii, i)=point
                EndIf
              Next ii
            Next i
          EndIf 
        Else
          For i=0 To texture_clip_height
            For ii=0 To texture_clip_width
              texture(ii, i)=Point(ii+texture_clip_x, i+texture_clip_y)
            Next ii
          Next i
        EndIf
      Else
        ProcedureReturn -4
      EndIf
      StopDrawing()
    EndMacro
    
    Macro add_element
      get_texture
      *texture_buffer=AllocateMemory((texture_clip_width+1)*(texture_clip_height+1)*SizeOf(integer), #PB_Memory_NoClear)
      CopyMemory(@texture(), *texture_buffer, MemorySize(*texture_buffer))
      AddElement(textures())
      textures()\texture_ID=texture_ID
      textures()\texture_buffer=*texture_buffer
      textures()\texture_clip_width=texture_clip_width
      textures()\texture_clip_height=texture_clip_height
      textures()\texture_percent_transparent=percent
    EndMacro
    
    If mode=-1
      texture(0, 0)=texture_ID
    Else
      
      If no_caching : get_texture : Goto jump_in_1 : EndIf
      
      If Not ListSize(textures())
        add_element
      Else
        i=0
        ForEach(textures())
          If textures()\texture_ID=texture_ID
            If textures()\texture_clip_width<>texture_clip_width Or
               textures()\texture_clip_height<>texture_clip_height Or
               textures()\texture_percent_transparent<>percent Or
               refresh_texture
              textures()\texture_clip_width=texture_clip_width
              textures()\texture_clip_height=texture_clip_height
              textures()\texture_percent_transparent=percent
              FreeMemory(textures()\texture_buffer)
              Dim texture(texture_clip_width, texture_clip_height)
              get_texture
              *texture_buffer=AllocateMemory((texture_clip_width+1)*(texture_clip_height+1)*SizeOf(integer), #PB_Memory_NoClear)
              textures()\texture_buffer=*texture_buffer
              CopyMemory(@texture(), *texture_buffer, MemorySize(*texture_buffer))
            Else
              *texture_buffer=textures()\texture_buffer
              CopyMemory(*texture_buffer, @texture(), MemorySize(*texture_buffer))
            EndIf
            i=1
            Break
          EndIf
        Next
      EndIf
      refresh_texture=0
      If Not i
        add_element
      EndIf
    EndIf
    
    jump_in_1:
    
    texture_width+texture_x
    temp_pos_s_x=texture_x
    temp_pos_s_y=texture_y
    texture_height_offset=texture_height+texture_y-1
    
    If Not canvas
      result=StartDrawing(ImageOutput(output_ID))
    Else
      result=StartDrawing(CanvasOutput(output_ID))
    EndIf
    
    If result
      If alpha_sprite
        DrawingMode(#PB_2DDrawing_AlphaBlend)
      EndIf
      
      If output_get_color_x>-1
        If mode>0 ; Get a color
          If invisible_color=-1
            used_image_color=texture(output_get_color_x, output_get_color_y)
          Else
            used_image_color=invisible_color
          EndIf
        Else
          If replacing_color=-1
            used_image_color=Point(output_get_color_x, output_get_color_y)
          Else
            used_image_color=replacing_color
          EndIf
        EndIf
      EndIf 
      
      Macro use_sprite_array
        If activate_sprite_array
          If activate_sprite_array<2 : picture_2(temp_pos_s_x, temp_pos_s_y)=-1 : EndIf
          If temp_pos_s_x<min_x_2 : min_x_2=temp_pos_s_x : EndIf
          If temp_pos_s_y<min_y_2 : min_y_2=temp_pos_s_y : EndIf
          If temp_pos_s_x>max_x_2 : max_x_2=temp_pos_s_x : EndIf
          If temp_pos_s_y>max_y_2 : max_y_2=temp_pos_s_y : EndIf
        EndIf
      EndMacro
      
      Macro use_bucket_array
        If activate_bucket_array
          If activate_bucket_array<2 : picture_1(temp_pos_s_x, temp_pos_s_y)=-1 : EndIf
          If temp_pos_s_x<min_x_1 : min_x_1=temp_pos_s_x : EndIf
          If temp_pos_s_y<min_y_1 : min_y_1=temp_pos_s_y : EndIf
          If temp_pos_s_x>max_x_1 : max_x_1=temp_pos_s_x : EndIf
          If temp_pos_s_y>max_y_1 : max_y_1=temp_pos_s_y : EndIf
        EndIf
      EndMacro
      
      If image_height<=texture_height_offset
        break_height=image_height_1
      Else
        break_height=texture_height_offset+1
      EndIf
      
      i=0 : ii=0 : mode_1=-mode
      If texture_y<=image_height And texture_x<=image_width And texture_width>-1 And texture_height>-1
        If mode>0 And (output_get_color_x<0 Or replacing_color=-2) : used_image_color=-1 : EndIf
        While temp_pos_s_y<break_height
          If temp_pos_s_x<texture_width
            If temp_pos_s_x>-1 And temp_pos_s_y>-1
              If mode=1
                texture_point=texture(i, ii)
                If texture_point<>used_image_color
                  Plot(temp_pos_s_x, temp_pos_s_y, texture_point)
                  use_sprite_array
                EndIf
              ElseIf mode>1
                texture_point=texture(i, ii)
                If texture_point<>used_image_color
                  Plot(temp_pos_s_x, temp_pos_s_y, AlphaBlend(texture_point, Point(temp_pos_s_x, temp_pos_s_y), mode))
                  use_sprite_array
                EndIf
              ElseIf mode<-2
                point=Point(temp_pos_s_x, temp_pos_s_y)
                If percent_1>0
                  If ColorDistance_BF(point, used_image_color)<=percent_1
                    Plot(temp_pos_s_x, temp_pos_s_y, AlphaBlend(texture(i, ii), point, mode_1))
                    use_bucket_array
                  EndIf
                Else
                  If point=used_image_color
                    Plot(temp_pos_s_x, temp_pos_s_y, AlphaBlend(texture(i, ii), point, mode_1))
                    use_bucket_array
                  EndIf
                EndIf
              Else ; not mode or mode=-1
                point=Point(temp_pos_s_x, temp_pos_s_y)
                If percent_1>0
                  If ColorDistance_BF(point, used_image_color)<=percent_1
                    Plot(temp_pos_s_x, temp_pos_s_y, texture(i, ii))
                    use_bucket_array
                  EndIf
                Else
                  If point=used_image_color
                    Plot(temp_pos_s_x, temp_pos_s_y, texture(i, ii))
                    use_bucket_array
                  EndIf
                EndIf
              EndIf
            EndIf
            temp_pos_s_x+1
          Else
            temp_pos_s_y+1
            ii+1 : If ii>texture_clip_height : ii=0 : EndIf
            temp_pos_s_x=texture_x : i+texture_clip_width
          EndIf
          i+1 : If i>texture_clip_width : i=0 : EndIf
        Wend 
      EndIf
    Else
      ProcedureReturn -3
    EndIf
    
    If Not mode ; Positioning marker
      Circle(output_get_color_x, output_get_color_y, 8, 0)
      Circle(output_get_color_x, output_get_color_y, 6, $FFFF00)
      Circle(output_get_color_x, output_get_color_y, 4, -1)
      Circle(output_get_color_x, output_get_color_y, 1, $FF)
    EndIf
    
    StopDrawing()
    ProcedureReturn 1
  EndProcedure
  
  Procedure GrabSpriteOffsets_BF(sprite_ID) 
    Protected i, ii
    Protected texture_width=ImageWidth(sprite_ID)
    Protected texture_height=ImageHeight(sprite_ID)
    Protected texture_width_1=texture_width-1
    Protected texture_height_1=texture_height-1
    Protected used_image_color.q
    
    If StartDrawing(ImageOutput(sprite_ID))
      used_image_color=Point(0, 0)
    Else
      ProcedureReturn -4
    EndIf
    
    max_x_2=0
    max_y_2=0
    min_x_2=texture_width_1
    min_y_2=texture_height_1
    
    Macro get_min_max_sprite_pos_1
      If i<min_x_2  : min_x_2=i  : EndIf
      If ii<min_y_2 : min_y_2=ii : EndIf
      If i>max_x_2  : max_x_2=i  : EndIf
      If ii>max_y_2 : max_y_2=ii : EndIf
    EndMacro
    
    If percent>0
      For i=0 To texture_width_1
        For ii=0 To texture_height_1
          If ColorDistance_BF(Point(i, ii), used_image_color)>percent
            get_min_max_sprite_pos_1
          EndIf
        Next ii
      Next i
    Else
      For i=0 To texture_width_1
        For ii=0 To texture_height_1 
          If Point(i, ii)<>used_image_color
            get_min_max_sprite_pos_1
          EndIf
        Next ii
      Next i
    EndIf
    
    StopDrawing()
    ProcedureReturn 1
  EndProcedure 
  
  Procedure AlphaChannelSprite_BF(output_ID, texture_ID,
                                  texture_x,
                                  texture_y, 
                                  texture_width=0,
                                  texture_height=0,
                                  texture_clip_x=0,
                                  texture_clip_y=0,
                                  texture_clip_width=0,
                                  texture_clip_height=0)
    
    If Not IsImage(output_ID)
      If Not IsGadget(output_ID) ; Check for canvas
        ProcedureReturn -11
      EndIf
    EndIf
    
    If texture_width<1
      texture_width=ImageWidth(texture_ID)
    EndIf
    If texture_height<1
      texture_height=ImageHeight(texture_ID)
    EndIf
    
    alpha_sprite=1
    
    Protected result=BF(1, output_ID, texture_ID,
                        0,
                        0,
                        texture_x,
                        texture_y, 
                        texture_width,
                        texture_height,
                        texture_clip_x,
                        texture_clip_y,
                        texture_clip_width,
                        texture_clip_height)
    
    alpha_sprite=0
    ProcedureReturn result
  EndProcedure
  
  Procedure SpriteSimple_BF(mode, output_ID, texture_ID,
                            image_get_color_x,
                            image_get_color_y,
                            output_pos_x,
                            output_pos_y,
                            output_width=0,
                            output_height=0,
                            alpha=1,
                            texture_width=0,
                            texture_height=0,
                            texture_clip_x=0,
                            texture_clip_y=0,
                            texture_clip_width=0,
                            texture_clip_height=0)
    
    If Not IsImage(output_ID)
      If Not IsGadget(output_ID) ; Check for canvas
        ProcedureReturn -11
      EndIf
    EndIf
    
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    Protected result, temporary_texture_ID, texture_size_changed
    Protected image_width=ImageWidth(texture_ID)
    Protected image_height=ImageHeight(texture_ID)
    
    StartDrawing(ImageOutput(texture_ID))
    If image_get_color_x<image_width And image_get_color_x>-1 And image_get_color_y<image_height And image_get_color_y>-1
      Protected point=Point(image_get_color_x, image_get_color_y)
    EndIf
    StopDrawing()
    
    If alpha<1 : alpha=1 : EndIf
    
    If mode<0 Or mode>2 : mode=0 : EndIf
    
    If Not mode : image_get_color_x=-1 : EndIf
    
    If output_width<1
      output_width=image_width
    EndIf
    If output_height<1
      output_height=image_height
    EndIf
    
    If output_width<>image_width Or output_height<>image_height
      temporary_texture_ID=CopyImage(texture_ID, #PB_Any)
      If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
      
      If Not ResizeImage(temporary_texture_ID, output_width, output_height) ;, #PB_Image_Raw)
        FreeImage(temporary_texture_ID)
        ProcedureReturn -6
      EndIf
      
      texture_ID=temporary_texture_ID
      texture_size_changed=1
    EndIf
    
    If mode=2 : alpha_sprite=1 : alpha=1 : EndIf
    
    If texture_width<1 : texture_width=output_width : EndIf
    If texture_height<1 : texture_height=output_height : EndIf
    
    result=BF(alpha, output_ID, texture_ID,
              image_get_color_x,
              image_get_color_y,
              output_pos_x,
              output_pos_y,
              texture_width,
              texture_height,
              texture_clip_x,
              texture_clip_y,
              texture_clip_width,
              texture_clip_height)
    
    If texture_size_changed
      Free_selected_Texture_BF(texture_ID)
    EndIf
    
    alpha_sprite=0
    
    If IsImage(temporary_texture_ID)
      Free_selected_Texture_BF(temporary_texture_ID) ; Not longer needed, you must remove from BF cache and give free the image
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure Sprite_CSS_sheet_BF(alpha, output_ID, texture_ID,
                                image_get_color_x, 
                                image_get_color_y,
                                output_pos_x,
                                output_pos_y,
                                frames,
                                frame,
                                frame_width,
                                frame_height,
                                frames_in_a_row=0,
                                output_width=0,
                                output_height=0,
                                texture_width=0,
                                texture_height=0,
                                texture_clip_x=0,
                                texture_clip_y=0,
                                texture_clip_width=0,
                                texture_clip_height=0)
    
    If Not IsImage(output_ID)
      If Not IsGadget(output_ID) ; Check for canvas
        ProcedureReturn -11
      EndIf
    EndIf
    
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    
    Protected i, result, mode=1, frame_=1
    Protected frame_offset_x, frame_offset_y
    Protected sheet_width=ImageWidth(texture_ID)
    Protected sheet_height=ImageHeight(texture_ID)
    
    frame+1 ; BF internal, the first frame is frame 1 - PB GIF beginns with frame 0, so we get for compatibility the first frame as frame 0
    
    If frames_in_a_row<1 : frames_in_a_row=sheet_width/frame_width : EndIf
    If frame<1 : frame=1 : EndIf
    If alpha<0 Or alpha>256 : alpha=1 : EndIf
    
    If image_get_color_x<0 Or image_get_color_y<0 : mode=0 : EndIf ; Deactivate output with transparence color
    
    Protected line, column    
    
    i=frame%frames_in_a_row
    If frame<=frames_in_a_row
      line=1
      column=frame
    Else
      If i
        line=frame/frames_in_a_row+1
        column=i
      Else
        line=frame/frames_in_a_row
        column=frames_in_a_row
      EndIf
    EndIf
    
    column-1 : line-1
    
    frame_offset_x=column*frame_width : frame_offset_y=line*frame_height
    
    If StartDrawing(ImageOutput(texture_ID))
      Protected temporary_destination_image_ID=GrabDrawingImage(#PB_Any, frame_offset_x, frame_offset_y, frame_width, frame_height) ; Grab frame from sheet
      StopDrawing()
    Else
      ProcedureReturn -4
    EndIf
    
    ; - Call function #1 - Resize the frame output
    result=SpriteSimple_BF(mode, output_ID, temporary_destination_image_ID,
                           image_get_color_x,       
                           image_get_color_y,
                           output_pos_x,
                           output_pos_y,
                           output_width,
                           output_height,
                           alpha,
                           texture_width,
                           texture_height,
                           texture_clip_x,
                           texture_clip_y,
                           texture_clip_width,
                           texture_clip_height)
    
    Free_selected_Texture_BF(temporary_destination_image_ID) ; Not longer needed, you must remove from BF cache and give free the image
    ProcedureReturn result
  EndProcedure
  
  Procedure Sprite_CSS_sheet_simple_BF(mode, output_ID, texture_ID,
                                       image_get_color_x,
                                       image_get_color_y,
                                       output_pos_x,
                                       output_pos_y,
                                       frames,
                                       frame,
                                       frame_width,
                                       frame_height,
                                       frames_in_a_row=0,
                                       output_width=0,
                                       output_height=0,
                                       texture_clip_x=0,
                                       texture_clip_y=0,
                                       texture_clip_width=0,
                                       texture_clip_height=0)
    
    Protected canvas, result
    
    If Not IsImage(output_ID)
      If IsGadget(output_ID) ; Check for canvas
        canvas=1
      Else
        ProcedureReturn -11
      EndIf
    EndIf
    
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    
    If texture_clip_width>frame_width : texture_clip_width=frame_width : EndIf
    If texture_clip_height>frame_height : texture_clip_height=frame_height : EndIf
    
    If texture_clip_width<0 : texture_clip_width=0 : EndIf
    If texture_clip_height<0 : texture_clip_height=0 : EndIf
    
    If texture_clip_x>frame_width : texture_clip_x=frame_width : EndIf
    If texture_clip_y>frame_height : texture_clip_y=frame_height : EndIf
    
    If texture_clip_x<0 : texture_clip_x=0 : EndIf
    If texture_clip_y<0 : texture_clip_y=0 : EndIf
    
    If texture_clip_width
      texture_clip_width=frame_width-texture_clip_width
    EndIf
    
    If texture_clip_height
      texture_clip_height=frame_height-texture_clip_height
    EndIf
    
    If Not output_width : output_width=frame_width-texture_clip_x-texture_clip_width : EndIf
    If Not output_height : output_height=frame_height-texture_clip_y-texture_clip_height : EndIf
    
    If output_width<1 : output_width=frame_width : EndIf
    If output_height<1 : output_height=frame_height : EndIf
    
    Protected i, invisible_color_, frame_=1
    Protected frame_offset_x, frame_offset_y
    Protected sheet_width=ImageWidth(texture_ID)
    Protected sheet_height=ImageHeight(texture_ID)
    
    If image_get_color_x<-1 : image_get_color_x=0 : EndIf 
    
    If image_get_color_x=-1 : invisible_color_=image_get_color_y : EndIf
    
    If image_get_color_x>-1 And image_get_color_y<0 : image_get_color_y=0 : EndIf
    
    frame+1 ; BF internal, the first frame is frame 1 - PB GIF beginns with frame 0, so we get for compatibility the first frame as frame 0
    
    If frames_in_a_row<1 : frames_in_a_row=sheet_width/frame_width : EndIf
    If frame<1 : frame=1 : EndIf
    If mode<-256 Or mode>256 Or invisible_color=-2 : mode=0 : EndIf
    
    Protected line, column    
    
    i=frame%frames_in_a_row
    If frame<=frames_in_a_row
      line=1
      column=frame
    Else
      If i
        line=frame/frames_in_a_row+1
        column=i
      Else
        line=frame/frames_in_a_row
        column=frames_in_a_row
      EndIf
    EndIf
    
    column-1 : line-1
    
    frame_offset_x=column*frame_width+texture_clip_x : frame_offset_y=line*frame_height+texture_clip_y
    
    If StartDrawing(ImageOutput(texture_ID))
      If image_get_color_x>-1 And image_get_color_x<frame_width And image_get_color_y>-1 And image_get_color_y<frame_height
        invisible_color_=Point(image_get_color_x, image_get_color_y)
      EndIf
      
      frame_width=frame_width-texture_clip_x-texture_clip_width
      frame_height=frame_height-texture_clip_y-texture_clip_height
      
      If frame_offset_x>-1 And frame_offset_x<sheet_width And frame_offset_y>-1 And frame_offset_y<sheet_height And frame_width>0 And frame_height>0
        Protected temporary_destination_image_ID=GrabDrawingImage(#PB_Any, frame_offset_x, frame_offset_y, frame_width, frame_height) ; Grab frame from sheet
      Else
        StopDrawing()
        ProcedureReturn 0
      EndIf
      StopDrawing()
    Else
      ProcedureReturn -4
    EndIf
    
    If canvas
      result=StartDrawing(CanvasOutput(output_ID))
    Else
      result=StartDrawing(ImageOutput(output_ID))
    EndIf
    
    If result
      If mode>0
        alpha_1=mode
        If invisible_color>-1
          invisible_color_=invisible_color
        EndIf
        DrawingMode(#PB_2DDrawing_CustomFilter)
        If canvas
          filter(@filter_callback_1(), invisible_color_)
        Else
          filter(@filter_callback_2(), invisible_color_)
        EndIf
        DrawImage(ImageID(temporary_destination_image_ID), output_pos_x, output_pos_y, output_width, output_height)
      ElseIf mode<0
        alpha_1=-mode
        If percent
          DrawingMode(#PB_2DDrawing_CustomFilter)      
          CustomFilterCallback(@filter_callback_3())
          DrawImage(ImageID(temporary_destination_image_ID), output_pos_x, output_pos_y, output_width, output_height)
        Else
          DrawingMode(#PB_2DDrawing_AlphaBlend)
          If frame_width<>output_width Or frame_height<>output_height
            ResizeImage(temporary_destination_image_ID, output_width, output_height)
          EndIf
          DrawAlphaImage(ImageID(temporary_destination_image_ID), output_pos_x, output_pos_y, 256-alpha_1)
        EndIf
      Else
        DrawImage(ImageID(temporary_destination_image_ID), output_pos_x, output_pos_y, output_width, output_height)
      EndIf
      StopDrawing()
    Else
      ProcedureReturn -11
    EndIf
    
    FreeImage(temporary_destination_image_ID)
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure SpriteSimple_fast_BF(mode, output_ID, texture_ID,
                                 image_get_color_x,
                                 image_get_color_y,
                                 output_pos_x,
                                 output_pos_y,
                                 output_width=0,
                                 output_height=0,
                                 texture_clip_x=0,
                                 texture_clip_y=0,
                                 texture_clip_width=0,
                                 texture_clip_height=0)
    
    Sprite_CSS_sheet_simple_BF(mode, output_ID, texture_ID,
                               image_get_color_x,
                               image_get_color_y,
                               output_pos_x,
                               output_pos_y,
                               1,
                               0,
                               ImageWidth(texture_ID),
                               ImageHeight(texture_ID),
                               1,
                               output_width,
                               output_height,
                               texture_clip_x,
                               texture_clip_y,
                               texture_clip_width,
                               texture_clip_height)
  EndProcedure
  
  Procedure CreateSprite_from_AlphaImage_BF(image_ID,
                                            mask_color,
                                            percent_color_distance.f)
    If Not IsImage(image_ID) : ProcedureReturn -10 : EndIf
    Protected image_width=ImageWidth(image_ID)-1
    Protected image_height=ImageHeight(image_ID)-1
    Protected image_width_1=image_width+1
    Protected image_height_1=image_height+1
    Protected point_, i, ii, result
    Protected old_percent_color_distance.f
    
    Protected texture_ID=CreateImage(#PB_Any, image_width_1 ,image_height_1, 24, mask_color)
    If Not texture_ID : ProcedureReturn -6 : EndIf
    
    result=AlphaChannelSprite_BF(texture_ID, image_ID,
                                 0,
                                 0, 
                                 image_width_1,
                                 image_height_1)
    
    If StartDrawing(ImageOutput(texture_ID))
      For i=0 To image_height
        For ii=0 To image_width
          point_=Point(ii, i)
          If ColorDistance_BF(point_, mask_color)<=percent_color_distance
            Plot(ii, i, mask_color)
          EndIf
        Next ii
      Next i
      StopDrawing()
    Else
      ProcedureReturn -4
    EndIf   
    ProcedureReturn texture_ID
  EndProcedure
  
  Procedure CreateAlphaImage_from_Sprite_BF(image_ID,
                                            percent_color_distance.f)
    If Not IsImage(image_ID) : ProcedureReturn -10 : EndIf
    Protected image_width=ImageWidth(image_ID)-1
    Protected image_height=ImageHeight(image_ID)-1
    Protected image_width_1=image_width+1
    Protected image_height_1=image_height+1
    Protected point, i, ii, alpha_image_ID
    Protected old_percent_color_distance.f
    
    Dim image.q(image_width, image_height)
    
    If StartDrawing(ImageOutput(image_ID)) ; Put image in array
      
      point=Point(0, 0)
      
      For i=0 To image_height
        For ii=0 To image_width
          If ColorDistance_BF(point, Point(ii,i))<=percent_color_distance 
            image(ii, i)=-1
          Else
            image(ii, i)=Point(ii, i)   
          EndIf
        Next ii
      Next i
    Else
      ProcedureReturn -5
    EndIf
    
    StopDrawing()
    
    alpha_image_ID=CreateImage(#PB_Any, image_width_1, image_height_1, 32, #PB_Image_Transparent)
    If Not alpha_image_ID : ProcedureReturn -10 : EndIf
    
    old_percent_color_distance=percent_1
    percent_1=percent_color_distance
    
    If StartDrawing(ImageOutput(alpha_image_ID)) ; Put array in image
      
      DrawingMode(#PB_2DDrawing_AllChannels)
      For i=0 To image_height
        For ii=0 To image_width
          point=image(ii,i)
          If point<>-1
            Plot(ii, i, RGBA(Red(point), Green(point), Blue(point), $FF))
          EndIf
        Next ii
      Next i
    Else
      ProcedureReturn -5
    EndIf
    
    StopDrawing()
    
    percent_1=old_percent_color_distance
    
    ProcedureReturn alpha_image_ID
  EndProcedure
  
  Procedure CopyContent_BF(source_ID, destination_ID)
    Protected source_image, destination_image
    Protected source_canvas, destination_canvas
    Protected *drawing_buffer_adress_source, *drawing_buffer_adress_destination
    Protected drawing_buffer_length_source, drawing_buffer_length_destination
    
    If IsImage(source_ID)
      If StartDrawing(ImageOutput(source_ID))
        *drawing_buffer_adress_source=DrawingBuffer()
        drawing_buffer_length_source=DrawingBufferPitch()*OutputHeight()
        StopDrawing()
        source_image=1
      Else
        ProcedureReturn -9
      EndIf
    EndIf
    
    If IsImage(destination_ID)
      If StartDrawing(ImageOutput(destination_ID))
        *drawing_buffer_adress_destination=DrawingBuffer()
        drawing_buffer_length_destination=DrawingBufferPitch()*OutputHeight()
        StopDrawing()
        destination_image=1
      Else
        ProcedureReturn -9
      EndIf
    EndIf
    
    If IsGadget(source_ID)
      If StartDrawing(CanvasOutput(source_ID))
        *drawing_buffer_adress_source=DrawingBuffer()
        drawing_buffer_length_source=DrawingBufferPitch()*OutputHeight()
        StopDrawing()
        source_canvas=1
      Else
        ProcedureReturn -9
      EndIf
    EndIf
    
    If IsGadget(destination_ID)
      If StartDrawing(CanvasOutput(destination_ID))
        *drawing_buffer_adress_destination=DrawingBuffer()
        drawing_buffer_length_destination=DrawingBufferPitch()*OutputHeight()
        StopDrawing()
        destination_canvas=1
      Else
        ProcedureReturn -9
      EndIf
    EndIf
    
    If (source_image Or source_canvas) And (destination_image Or destination_canvas) And drawing_buffer_length_source=drawing_buffer_length_destination
      CopyMemory(*drawing_buffer_adress_source, *drawing_buffer_adress_destination, drawing_buffer_length_source) 
      ProcedureReturn 1  
    Else
      ProcedureReturn -9
    EndIf  
  EndProcedure
  
  Procedure CopyContent_Image_Image_BF(source_ID, destination_ID)  
    If Not StartDrawing(ImageOutput(destination_ID)) : ProcedureReturn -9 : EndIf
    DrawImage(ImageID(source_ID), 0, 0)
    StopDrawing()
    ProcedureReturn 1
  EndProcedure
  
  Procedure CopyContent_Canvas_Canvas_BF(source_ID, destination_ID)
    SetGadgetAttribute(destination_ID, #PB_Canvas_Image, GetGadgetAttribute(source_ID, #PB_Canvas_Image))
    ProcedureReturn 1
  EndProcedure
  
  Procedure CopyContent_Image_Canvas_BF(source_ID, destination_ID)
    If Not StartDrawing(CanvasOutput(destination_ID)) : ProcedureReturn -9 : EndIf
    DrawImage(ImageID(source_ID), 0, 0)
    StopDrawing()
    ProcedureReturn 1
  EndProcedure
  
  Procedure CopyContent_Canvas_Image_BF(source_ID, destination_ID)
    If Not StartDrawing(ImageOutput(destination_ID))
      ProcedureReturn -1
    EndIf
    DrawImage(GetGadgetAttribute(source_ID, #PB_Canvas_Image), 0, 0)
    StopDrawing()
    ProcedureReturn 1
  EndProcedure
  
  Procedure DrawingBuffer_length_image_BF(image_ID)
    Protected result=StartDrawing(ImageOutput(image_ID))
    If Not result : ProcedureReturn -10 : EndIf
    result=DrawingBufferPitch()*OutputHeight()
    StopDrawing()
    ProcedureReturn result
  EndProcedure
  
  Procedure DrawingBuffer_pitch_image_BF(image_ID)
    Protected result=StartDrawing(ImageOutput(image_ID))
    If Not result : ProcedureReturn -10 : EndIf
    result=DrawingBufferPitch()
    StopDrawing()
    ProcedureReturn result
  EndProcedure
  
  Procedure DrawingBuffer_length_canvas_BF(canvas_ID)
    Protected result=StartDrawing(CanvasOutput(canvas_ID))
    If Not result : ProcedureReturn -1 : EndIf
    result=DrawingBufferPitch()*OutputHeight()
    StopDrawing()
    ProcedureReturn result
  EndProcedure
  
  Procedure DrawingBuffer_pitch_canvas_BF(canvas_ID)
    Protected result=StartDrawing(CanvasOutput(canvas_ID))
    If Not result : ProcedureReturn -1 : EndIf
    result=DrawingBufferPitch()
    StopDrawing()
    ProcedureReturn result
  EndProcedure
  
  Procedure Texture_FloodFill(x, y, output_ID, texture_ID)
    Protected texture_width_=ImageWidth(texture_ID)-1
    Protected texture_height_=ImageHeight(texture_ID)-1
    Protected canvas, result, output_width, output_height, output_width_1, output_height_1
    Protected texture_width__1=texture_width_+1, texture_height__1=texture_height_+1 
    Protected x1, y1, old_color, point
    Protected r1, g1, b1, r2, g2, b2, diff_red, diff_green, diff_blue
    Protected r.f, g.f, b.f
    
    If Not IsImage(output_ID)
      If IsGadget(output_ID) ; Check for canvas
        canvas=1
      Else
        ProcedureReturn -11
      EndIf 
    EndIf
    
    If canvas
      output_width_1=GadgetWidth(output_ID)
      output_height_1=GadgetHeight(output_ID)
    Else
      output_width_1=ImageWidth(output_ID)
      output_height_1=ImageHeight(output_ID)
    EndIf
    
    output_width=output_width_1-1
    output_height=output_height_1-1 
    
    Dim picture_0(output_width , output_height)
    
    If activate_flood_array
      flood_array_length=(output_width_1*output_height_1)<<3
      flood_array_width=output_width_1
      flood_array_height=output_height_1
    EndIf
    
    Structure point_
      x.i
      y.i
    EndStructure
    
    If x<0 Or x>output_width Or y<0 Or y>output_height
      ProcedureReturn -8
    EndIf
    
    max_x_0=0
    max_y_0=0
    min_x_0=output_width
    min_y_0=output_height
    
    If canvas
      result=StartDrawing(CanvasOutput(output_ID))
    Else
      result=StartDrawing(ImageOutput(output_ID))
    EndIf
    If result
      old_color=Point(x,y)
      NewList stack.point_()
      AddElement(stack()) : stack()\x=x : stack()\y=y
      While(LastElement(stack()))
        x=stack()\x : y=stack()\y
        DeleteElement(stack())
        If x>-1 And x<output_width_1 And y>-1 And y<output_height_1 And Not picture_0(x, y)
          point=Point(x, y)
        Else
          point=-1
          If x<0 : x= 0 : EndIf
        EndIf
        
        Macro add_stack
          picture_0(x, y)=-1
          
          If activate_flood_array
            If x<min_x_0
              min_x_0=x
            EndIf
            If y<min_y_0
              min_y_0=y
            EndIf
            If x>max_x_0
              max_x_0=x
            EndIf
            If y>max_y_0
              max_y_0=y
            EndIf
          EndIf
          
          AddElement(stack()) : stack()\x=x   : stack()\y=y+1
          AddElement(stack()) : stack()\x=x   : stack()\y=y-1
          AddElement(stack()) : stack()\x=x+1 : stack()\y=y
          AddElement(stack()) : stack()\x=x-1 : stack()\y=y
        EndMacro
        
        If point=-1
          If point=old_color
            add_stack
          EndIf
        Else
          If percent_1>0
            If ColorDistance_BF(point, old_color)<=percent_1 
              add_stack
            EndIf
          Else
            If point=old_color
              add_stack
            EndIf
          EndIf
        EndIf
      Wend
      
    Else
      If canvas
        ProcedureReturn -1
      Else
        ProcedureReturn -10 
      EndIf
    EndIf
    StopDrawing()
    
    Protected Dim texture(output_width, output_height)
    
    If StartDrawing(ImageOutput(texture_ID))
      For y=0 To texture_height_
        For x=0 To texture_width_
          If x>-1 And y>-1 And x<output_width_1 And y<output_height_1
            texture(x, y)=Point(x, y)
          EndIf
        Next x
      Next y
    Else
      ProcedureReturn -4
    EndIf
    StopDrawing()
    
    If canvas
      result=StartDrawing(CanvasOutput(output_ID))
    Else
      result=StartDrawing(ImageOutput(output_ID))
    EndIf
    If result
      For y=0 To output_height
        For x=0 To output_width
          If picture_0(x, y)=-1
            Plot(x, y, texture(x, y))
          EndIf
        Next x
      Next y
    Else
      If canvas
        ProcedureReturn -1
      Else
        ProcedureReturn -10 
      EndIf
    EndIf
    StopDrawing()
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure FloodFill_BF(mode, output_ID, texture_ID,
                         x,
                         y,
                         texture_x=0,
                         texture_y=0, 
                         texture_width=0,
                         texture_height=0,
                         texture_clip_x=0,
                         texture_clip_y=0,
                         texture_clip_width=0,
                         texture_clip_height=0)
    
    Protected canvas, result, output_width_1, output_height_1, temporary_texture_ID, color
    
    If Not IsImage(output_ID)
      If IsGadget(output_ID) ; Check for canvas
        canvas=1
      Else
        ProcedureReturn -11
      EndIf 
    EndIf
    
    If canvas
      output_width_1=GadgetWidth(output_ID)
      output_height_1=GadgetHeight(output_ID)
    Else
      output_width_1=ImageWidth(output_ID)
      output_height_1=ImageHeight(output_ID)
    EndIf
    
    If Not mode : SetPosMarker_BF(output_ID, x, y) : ProcedureReturn 1 : EndIf
    
    If mode<0 : mode=-mode : EndIf
    If mode<>1 And Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    
    If canvas
      result=StartDrawing(CanvasOutput(output_ID))
    Else
      result=StartDrawing(ImageOutput(output_ID))
    EndIf
    If result
      If x<0 Or x>output_width_1-1 : x=0 : EndIf
      If y<0 Or y>output_height_1-1 : y=0 : EndIf
      color=Point(x, y)
      StopDrawing()
    Else
      If canvas
        ProcedureReturn -1
      Else
        ProcedureReturn -10 
      EndIf
    EndIf
    
    temporary_texture_ID=CreateImage(#PB_Any, output_width_1, output_height_1) 
    If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
    
    If mode=1 : color=texture_ID : EndIf
    
    If StartDrawing(ImageOutput(temporary_texture_ID))
      Box(0, 0, output_width_1, output_height_1, color)
      StopDrawing()
    Else
      FreeImage(temporary_texture_ID)
      ProcedureReturn -5
    EndIf
    
    If mode<>1
      result=BF(-mode, temporary_texture_ID, texture_ID,
                0,
                0,
                texture_x,
                texture_y, 
                texture_width,
                texture_height,
                texture_clip_x,
                texture_clip_y,
                texture_clip_width,
                texture_clip_height)
      If result<1 : FreeImage(temporary_texture_ID) : ProcedureReturn result : EndIf
    EndIf
    
    result=Texture_FloodFill(x, y, output_ID, temporary_texture_ID)
    
    FreeImage(temporary_texture_ID)
    
    ProcedureReturn result
    
  EndProcedure
  
  Procedure PhotoBrush_image_BF(mode, image_ID, texture_ID,
                                x,
                                y,
                                texture_width,
                                texture_height,
                                percent_visibility.f=100)
    If Not IsImage(image_ID) : ProcedureReturn -10 : EndIf
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    Protected i, ii, result, max_repeats, temporary_texture_ID
    Protected repeats.f, divisor.f=250
    
    If texture_width<2 : texture_width=2 : EndIf
    If texture_height<2 : texture_height=2 : EndIf
    
    If mode>3 : mode=0 : EndIf
    
    If mode<-1 : mode=-1 : EndIf
    
    If percent_visibility<1 : percent_visibility=1 : EndIf
    
    If percent_visibility>100 : percent_visibility=100 : EndIf
    
    If texture_height>texture_width
      max_repeats=texture_width>>1
    Else
      max_repeats=texture_height>>1
    EndIf 
    
    If max_repeats>100 : max_repeats=100 : EndIf
    
    temporary_texture_ID=CopyImage(texture_ID, #PB_Any)
    
    If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
    
    If ImageWidth(temporary_texture_ID)<>texture_width Or
       ImageHeight(temporary_texture_ID)<>texture_height
      If Not ResizeImage(temporary_texture_ID, texture_width, texture_height)
        FreeImage(temporary_texture_ID)
        ProcedureReturn -6
      EndIf
    EndIf
    
    percent_visibility-1
    
    If mode<1
      
      divisor=250-divisor/(65)*percent_visibility
      If divisor<1 : divisor=1 : EndIf
      
      result=BF(divisor, image_ID, temporary_texture_ID,
                -1,
                -1,
                x,
                y,
                texture_width,
                texture_height)
      
    Else
      
      If mode=1
        repeats=max_repeats/(230*mode)*percent_visibility
      ElseIf mode=2
        repeats=max_repeats/(140*mode)*percent_visibility
      ElseIf mode=3
        repeats=max_repeats/(120*mode)*percent_visibility
      EndIf
      
      If repeats>max_repeats : repeats=max_repeats : EndIf
      
      If repeats<1 : repeats=1 : EndIf
      
      For i=0 To repeats
        
        result=BF(250-ii, image_ID, temporary_texture_ID,
                  -1,
                  -1,
                  x+ii,
                  y+ii,
                  texture_width-ii-ii,
                  texture_height-ii-ii,
                  ii,
                  ii,
                  texture_width-ii,
                  texture_height-ii) 
        
        ii+mode
        
      Next i
      
    EndIf
    
    Free_selected_Texture_BF(temporary_texture_ID)
    ProcedureReturn result
  EndProcedure
  
  Procedure PhotoBrush_canvas_BF(mode, canvas_ID, texture_ID,
                                 x,
                                 y,
                                 texture_width,
                                 texture_height,
                                 percent_visibility.f=100,
                                 delay=0)
    If Not IsGadget(canvas_ID) : ProcedureReturn -1 : EndIf
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    Protected i, ii, result, repeats_1, max_repeats, temporary_texture_ID
    Protected repeats.f, divisor.f=250
    
    If mode>0 And mode<4
      If texture_width<7 : texture_width=3 : mode=1 : EndIf
      If texture_height<7 : texture_height=3 : mode=1 : EndIf
    ElseIf mode=4
      If texture_width<7 : texture_width=7 : mode=1 : EndIf
      If texture_height<7 : texture_height=7 : mode=1 : EndIf
    Else
      If texture_width<2 : texture_width=2 : EndIf
      If texture_height<2 : texture_height=2 : EndIf
    EndIf
    
    If mode>4 : mode=0 : EndIf
    
    If mode<-1 : mode=-1 : EndIf
    
    If percent_visibility<0.1 : percent_visibility=0.1 : EndIf
    
    If percent_visibility>100 : percent_visibility=100 : EndIf
    
    If texture_height>texture_width
      max_repeats=texture_width>>1
    Else
      max_repeats=texture_height>>1
    EndIf 
    
    If max_repeats>100 : max_repeats=100 : EndIf
    
    temporary_texture_ID=CopyImage(texture_ID, #PB_Any)
    
    If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
    
    If ImageWidth(temporary_texture_ID)<>texture_width Or
       ImageHeight(temporary_texture_ID)<>texture_height
      If Not ResizeImage(temporary_texture_ID, texture_width, texture_height)
        FreeImage(temporary_texture_ID)
        ProcedureReturn -6
      EndIf
    EndIf
    
    percent_visibility-1
    
    If mode=-1
      
      divisor=250-divisor/(65)*percent_visibility
      If divisor<1 : divisor=1 : EndIf
      
      result=BF(divisor, canvas_ID, temporary_texture_ID,
                -1,
                -1,
                x,
                y,
                texture_width,
                texture_height)
      
    Else
      
      If mode=1
        repeats=max_repeats/(230*mode)*percent_visibility
      ElseIf mode=2
        repeats=max_repeats/(140*mode)*percent_visibility
      ElseIf mode=3
        repeats=max_repeats/(120*mode)*percent_visibility
      ElseIf mode=4
        repeats=max_repeats/(120*mode)*99   
      Else ; not mode
        repeats=percent_visibility/2
      EndIf
      
      If repeats>max_repeats : repeats=max_repeats : EndIf
      
      If repeats<1 : repeats=1 : EndIf
      
      repeats_1=repeats/2
      
      If repeats_1>1 : repeats_1=1 : EndIf
      
      For i=0 To repeats
        
        If Not mode 
          
          result=BF(250-ii, canvas_ID, temporary_texture_ID,
                    -1,
                    -1,
                    x,
                    y,
                    texture_width,
                    texture_height)
          
        Else 
          
          result=BF(250-ii, canvas_ID, temporary_texture_ID,
                    -1,
                    -1,
                    x+ii,
                    y+ii,
                    texture_width-ii-ii,
                    texture_height-ii-ii,
                    ii,
                    ii,
                    texture_width-ii,
                    texture_height-ii)
          
          If mode=4
            If i>repeats_1 Or repeats_1=1
              result=253-(257/100*percent_visibility)
              If result<1 : result=1 : EndIf
              result=BF(result, canvas_ID, temporary_texture_ID,
                        -1,
                        -1,
                        x+ii,
                        y+ii,
                        texture_width-ii-ii,
                        texture_height-ii-ii,
                        ii,
                        ii,
                        texture_width-ii,
                        texture_height-ii)
            EndIf
          EndIf
          
        EndIf
        
        If mode<4 And delay
          While WindowEvent() : Wend
          Delay(delay)
        EndIf 
        
        If Not mode
          ii+1
        Else
          If mode<4 
            ii+mode
          Else
            ii+3
          EndIf
        EndIf
        
      Next i
      
    EndIf
    
    Free_selected_Texture_BF(temporary_texture_ID)
    ProcedureReturn result
  EndProcedure
  
  Procedure ButtonImageGadget_BF(mode, ButtonImageGadget_ID, texture_ID,
                                 background_color,
                                 visibility_factor.f=100,
                                 seamless_shrink_factor=10,
                                 delay=5)
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    If Not IsGadget(ButtonImageGadget_ID) : ProcedureReturn -9 : EndIf
    Protected i, ii, iii, result, max_repeats, temporary_texture_ID, temporary_gadget
    Protected repeats.f, divisor.f=250, temporary_ButtonImageGadget_ID
    Protected texture_width=ImageWidth(texture_ID)
    Protected texture_height=ImageHeight(texture_ID)
    
    If mode<1 Or mode>2 : mode=1 : EndIf
    
    If texture_width<2 : texture_width=2 : EndIf
    If texture_height<2 : texture_height=2 : EndIf
    
    If visibility_factor<1 : visibility_factor=1 : EndIf
    
    If visibility_factor>100 : visibility_factor=100 : EndIf
    
    If delay<0 Or delay>100 : delay=5 : EndIf
    
    If texture_height>texture_width
      max_repeats=texture_width>>1
    Else
      max_repeats=texture_height>>1
    EndIf 
    
    If max_repeats>100 : max_repeats=100 : EndIf
    
    temporary_texture_ID=CopyImage(texture_ID, #PB_Any)
    
    If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
    
    If ImageWidth(temporary_texture_ID)<>texture_width Or
       ImageHeight(temporary_texture_ID)<>texture_height
      If Not ResizeImage(temporary_texture_ID, texture_width, texture_height, #PB_Image_Raw)
        FreeImage(temporary_texture_ID)
        ProcedureReturn -6
      EndIf
    EndIf
    
    visibility_factor-1
    
    repeats=max_repeats/(230)*visibility_factor
    
    If repeats>max_repeats : repeats=max_repeats : EndIf
    
    If repeats<1 : repeats=1 : EndIf
    
    If seamless_shrink_factor<1 : seamless_shrink_factor=1 : EndIf
    
    If seamless_shrink_factor>50 : seamless_shrink_factor=50 : EndIf
    
    StartDrawing(ImageOutput(texture_ID))
    Box(0, 0, texture_width, texture_height, background_color)
    StopDrawing()
    
    For iii=1 To seamless_shrink_factor
      ii=0
      
      For i=0 To repeats
        
        result=BF(250-ii, texture_ID, temporary_texture_ID,
                  -1,
                  -1,
                  ii,
                  ii,
                  texture_width-ii-ii,
                  texture_height-ii-ii,
                  ii,
                  ii,
                  texture_width-ii,
                  texture_height-ii)
        
        If delay
          CompilerIf #PB_Compiler_OS=#PB_OS_Linux
            If IsGadget(temporary_ButtonImageGadget_ID)
              FreeGadget(temporary_ButtonImageGadget_ID)
            EndIf
            temporary_ButtonImageGadget_ID=ButtonImageGadget(#PB_Any, 
                                                             GadgetX(ButtonImageGadget_ID),
                                                             GadgetY(ButtonImageGadget_ID),
                                                             GadgetWidth(ButtonImageGadget_ID),
                                                             GadgetHeight(ButtonImageGadget_ID),
                                                             ImageID(texture_ID)) 
          CompilerElse     
            SetGadgetAttribute(ButtonImageGadget_ID, #PB_Button_Image, ImageID(texture_ID)) 
          CompilerEndIf
          While WindowEvent() : Wend
          Delay(delay)
        EndIf
        
        ii+mode
        
      Next i
      
    Next iii
    
    SetGadgetAttribute(ButtonImageGadget_ID, #PB_Button_Image, ImageID(texture_ID))
    While WindowEvent() : Wend
    If IsGadget(temporary_ButtonImageGadget_ID)
      FreeGadget(temporary_ButtonImageGadget_ID)
    EndIf
    FreeImage(temporary_texture_ID)
    ProcedureReturn result
  EndProcedure
  
  Procedure RotateImage_BF(degree, image_ID,
                           create_new_image=0)
    
    If Not IsImage(image_ID)
      ProcedureReturn -6
    EndIf
    
    Protected Dim points.l(ImageWidth(image_ID), ImageHeight(image_ID))
    Protected image_width=ImageWidth(image_ID)
    Protected image_height=ImageHeight(image_ID)
    Protected i, ii, iii, new_image_ID
    
    If Not StartDrawing(ImageOutput(image_ID))
      ProcedureReturn -4     
    EndIf
    
    For i=0 To ImageWidth(image_ID)-1
      For ii=0 To ImageHeight(image_ID)-1
        points(i, ii)=Point(i,ii)
      Next
    Next
    
    StopDrawing()
    
    If create_new_image
      If Abs(degree)=90 Or degree=270
        new_image_ID=CreateImage(#PB_Any, image_height, image_width)
      EndIf
      new_image_ID=CreateImage(#PB_Any, image_width, image_height)
      If Not new_image_ID
        ProcedureReturn -6
      EndIf
      If Not StartDrawing(ImageOutput(new_image_ID))
        ProcedureReturn -4     
      EndIf 
    Else
      If Abs(degree)=90 Or degree=270
        ResizeImage(image_ID, image_height, image_width)
      EndIf
      If Not StartDrawing(ImageOutput(image_ID))
        ProcedureReturn -4     
      EndIf
    EndIf
    
    Select degree
      Case -90, 270
        iii=image_width-1 ; Rotate 90 degrees left
        For i=0 To image_width-1
          For ii=0 To image_height-1
            Plot(ii, iii, points(i, ii)) 
          Next
          iii-1
        Next
        
      Case 90
        iii=image_height-1 ; Rotate 90 degrees right
        For i=0 To image_width-1
          For ii=0 To image_height-1
            Plot(iii, i, points(i, ii))
            iii-1
          Next
          iii=image_height-1
        Next
        
      Case 180
        iii=image_height-1 ; Rotate 180 degrees
        For i=0 To image_width-1
          For ii=0 To image_height-1
            Plot(i, iii, points(i, ii))
            iii-1 
          Next
          iii=image_height-1
        Next
    EndSelect
    
    StopDrawing ()
    
    If create_new_image
      ProcedureReturn new_image_ID
    EndIf
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure RotateSprite_BF(texture_ID,
                            image_get_color_x=0,                       
                            image_get_color_y=0,                 
                            degree=0,
                            mode=0,
                            rotating_offset_x=0,
                            rotating_offset_y=0,
                            create_new_image=0) 
    
    If Not IsImage(texture_ID)
      ProcedureReturn -2
    EndIf
    
    Protected texture_width=ImageWidth(texture_ID)
    Protected texture_height=ImageHeight(texture_ID)
    
    If texture_width<1 Or texture_height<1
      ProcedureReturn -9
    EndIf
    
    Protected i, ii, iii, temporary_texture_0_ID, temporary_texture_1_ID
    Protected invisible_color_0, result, resulted_x_y
    
    If rotating_offset_x<0 : Protected negative_x=1 : EndIf
    If rotating_offset_y<0 : Protected negative_y=1 : EndIf
    
    rotating_offset_x=Abs(rotating_offset_x)
    rotating_offset_y=Abs(rotating_offset_y)
    
    If (rotating_offset_x Or rotating_offset_y) And mode
      resulted_x_y=Sqr((texture_width+rotating_offset_x*4)*(texture_width+rotating_offset_x*4)+(texture_height+rotating_offset_y*4)*(texture_height+rotating_offset_y*4))+7
    Else
      rotating_offset_x=0 : rotating_offset_y=0
      resulted_x_y=Sqr(texture_width*texture_width+texture_height*texture_height)+7
    EndIf
    
    If image_get_color_x>texture_width-1 Or image_get_color_x<-2: image_get_color_x=0 : EndIf
    
    Protected old_invisible_color.q=invisible_color
    
    invisible_color=-1
    
    If image_get_color_x=-1 
      invisible_color_0=image_get_color_y
    ElseIf image_get_color_x=-2
      invisible_color_0=image_get_color_y
      invisible_color=-2
    ElseIf image_get_color_x>-1
      If StartDrawing(ImageOutput(texture_ID))
        If image_get_color_y<0 Or image_get_color_y>texture_height-1: image_get_color_y=0 : EndIf
        invisible_color_0=Point(image_get_color_x, image_get_color_y)
      Else
        invisible_color=old_invisible_color
        ProcedureReturn -4     
      EndIf
      StopDrawing()
    EndIf
    
    temporary_texture_0_ID=CreateImage(#PB_Any, resulted_x_y, resulted_x_y)
    If Not IsImage(temporary_texture_0_ID)
      invisible_color=old_invisible_color
      ProcedureReturn -6
    EndIf
    
    If Not StartVectorDrawing(ImageVectorOutput(temporary_texture_0_ID))
      FreeImage(temporary_texture_0_ID)
      invisible_color=old_invisible_color
      ProcedureReturn -4     
    EndIf
    VectorSourceColor(invisible_color_0|$FF000000)
    FillVectorOutput()
    If negative_x And negative_y
      RotateCoordinates(VectorOutputWidth()/2-rotating_offset_x, VectorOutputHeight()/2-rotating_offset_y, degree)
    ElseIf Not negative_x And Not negative_y
      RotateCoordinates(VectorOutputWidth()/2+rotating_offset_x, VectorOutputHeight()/2+rotating_offset_y, degree)
    ElseIf negative_x And Not negative_y
      RotateCoordinates(VectorOutputWidth()/2-rotating_offset_x, VectorOutputHeight()/2+rotating_offset_y, degree)
    ElseIf Not negative_x And negative_y
      RotateCoordinates(VectorOutputWidth()/2+rotating_offset_x, VectorOutputHeight()/2-rotating_offset_y, degree)
    EndIf
    MovePathCursor(VectorOutputWidth()/2-ImageWidth(texture_ID)/2,
                   VectorOutputHeight()/2-ImageHeight(texture_ID)/2)
    DrawVectorImage(ImageID(texture_ID))
    StopVectorDrawing()
    
    GrabSpriteOffsets_BF(temporary_texture_0_ID)
    
    invisible_color=old_invisible_color
    
    If mode
      If create_new_image
        ProcedureReturn temporary_texture_0_ID
      EndIf
      ResizeImage(texture_ID, resulted_x_y, resulted_x_y, #PB_Image_Raw)
      CopyContent_Image_Image_BF(temporary_texture_0_ID, texture_ID)
      FreeImage(temporary_texture_0_ID)
    Else
      
      If max_x_2-min_x_2<-4 Or max_y_2-min_y_2<-4 : ProcedureReturn -9 : EndIf
      
      If StartDrawing(ImageOutput(temporary_texture_0_ID))
        temporary_texture_1_ID=GrabDrawingImage(#PB_Any, min_x_2-3, min_y_2-3, max_x_2-min_x_2+6, max_y_2-min_y_2+6)
        StopDrawing()
      Else
        FreeImage(temporary_texture_0_ID)
        ProcedureReturn -4
      EndIf
      
      FreeImage(temporary_texture_0_ID)
      
      If create_new_image
        ProcedureReturn temporary_texture_1_ID
      Else
        ResizeImage(texture_ID, max_x_2-min_x_2+6, max_y_2-min_y_2+6, #PB_Image_Raw)
        CopyContent_Image_Image_BF(temporary_texture_1_ID, texture_ID)
        FreeImage(temporary_texture_1_ID)
      EndIf
      
    EndIf
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure RotateSprite_simple_BF(mode, output_ID, texture_ID,                              
                                   image_get_color_x=0,                     
                                   image_get_color_y=0,   
                                   output_pos_x=0,
                                   output_pos_y=0,
                                   arc=0,
                                   alpha=1,
                                   output_width=0,
                                   output_height=0,
                                   rotating_offset_x=0,
                                   rotating_offset_y=0)
    
    If Not IsImage(output_ID)
      If Not IsGadget(output_ID) ; Check for canvas
        ProcedureReturn -11
      EndIf
    EndIf
    
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    
    Protected texture_1_ID, result, mode_=1
    
    If mode<1 Or mode>3 : mode=3 : EndIf
    
    If mode<>1 : mode_=0 : EndIf
    
    If alpha<1 : alpha=1 : EndIf
    
    ; - Rotate sprite #1 -
    texture_1_ID=CopyImage(texture_ID, #PB_Any)
    
    If output_width>0 And output_height>0
      CompilerIf #PB_Compiler_OS=#PB_OS_Linux
        If output_width<2 : output_width=2 : EndIf
        If output_height<2 : output_height=2 : EndIf
      CompilerEndIf
      ResizeImage(texture_1_ID, output_width, output_height)
    EndIf
    
    result=RotateSprite_BF(texture_1_ID,
                           image_get_color_x,
                           image_get_color_y,
                           arc,
                           mode_,
                           rotating_offset_x,
                           rotating_offset_y)
    
    If result<1 : ProcedureReturn -9 : EndIf
    
    CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
      If (output_width<11 Or output_height<11)
        ; - Call function #1 -
        If mode=1
          result=BF(alpha, output_ID, texture_1_ID,
                    0,   
                    0,  
                    output_pos_x+min_x_2,
                    output_pos_y+min_y_2,
                    max_x_2-min_x_2+6,
                    max_y_2-min_y_2+6,
                    min_x_2-3, 
                    min_y_2-3)
        ElseIf mode=2
          result=BF(alpha, output_ID, texture_1_ID,
                    0,   
                    0,  
                    output_pos_x+min_x_2,
                    output_pos_y+min_y_2,
                    ImageWidth(texture_1_ID),
                    ImageHeight(texture_1_ID))
        Else ; mode=3
          result=BF(alpha, output_ID, texture_1_ID,
                    0,   
                    0,  
                    output_pos_x,
                    output_pos_y,
                    ImageWidth(texture_1_ID),
                    ImageHeight(texture_1_ID)) 
        EndIf
        
      Else
      CompilerEndIf
      
      ; - Call function #1 -
      If mode=1
        Sprite_CSS_sheet_simple_BF(alpha, output_ID, texture_1_ID,
                                   0,
                                   0,
                                   output_pos_x+min_x_2,
                                   output_pos_y+min_y_2,
                                   1,
                                   0,
                                   ImageWidth(texture_1_ID),
                                   ImageHeight(texture_1_ID),
                                   1,
                                   0,
                                   0,
                                   min_x_2-3,
                                   min_y_2-3,
                                   max_x_2+6, 
                                   max_y_2+6)
        
        min_x_2+output_pos_x+3 : min_y_2+output_pos_y+3
        max_x_2+output_pos_x+3 : max_y_2+output_pos_y+3
        
      ElseIf mode=2
        Sprite_CSS_sheet_simple_BF(alpha, output_ID, texture_1_ID,
                                   0,
                                   0,
                                   output_pos_x+min_x_2,
                                   output_pos_y+min_y_2,
                                   1,
                                   0,
                                   ImageWidth(texture_1_ID),
                                   ImageHeight(texture_1_ID))
        
        min_x_2+output_pos_x+3 : min_y_2+output_pos_y+3
        max_x_2+output_pos_x+3 : max_y_2+output_pos_y+3
        
      Else ; mode=3
        Sprite_CSS_sheet_simple_BF(alpha, output_ID, texture_1_ID,
                                   0,
                                   0,
                                   output_pos_x,
                                   output_pos_y,
                                   1,
                                   0,
                                   ImageWidth(texture_1_ID),
                                   ImageHeight(texture_1_ID))
        
        max_x_2=output_pos_x+(max_x_2-min_x_2)+3 : max_y_2=output_pos_y+(max_y_2-min_y_2)+3
        min_x_2=output_pos_x+3 : min_y_2=output_pos_y+3
      EndIf
      
      CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
      EndIf
    CompilerEndIf
    
    Free_selected_Texture_BF(texture_1_ID)
    
    If result<1 : ProcedureReturn -9 : EndIf
    
  EndProcedure
  
  Procedure MirrorImage_BF(mode, image_ID,
                           create_new_image=0)
    
    If Not IsImage(image_ID)
      ProcedureReturn -6
    EndIf
    
    Protected image_width=ImageWidth(image_ID)
    Protected image_height=ImageHeight(image_ID)
    Protected i, ii, iii, new_image_ID
    
    If mode<1 Or mode>2 : ProcedureReturn 0 : EndIf
    
    If Not StartDrawing(ImageOutput(image_ID))
      ProcedureReturn -4     
    EndIf
    
    Protected Dim points.l(image_width, image_height)
    
    For i=0 To image_width-1
      For ii=0 To image_height-1
        points(i, ii)=Point(i,ii)
      Next
    Next
    
    If create_new_image
      StopDrawing()
      new_image_ID=CreateImage(#PB_Any, image_width, image_height)
      If Not new_image_ID
        ProcedureReturn -6
      EndIf
      If Not StartDrawing(ImageOutput(new_image_ID))
        FreeImage(new_image_ID)
        ProcedureReturn -4     
      EndIf
    EndIf
    
    If mode=1
      iii=image_width-1
      For i=0 To image_width-1
        For ii=0 To image_height-1
          Plot(iii, ii, points(i, ii)) 
        Next
        iii-1
      Next
    Else
      iii=image_height-1
      For i=0 To image_width-1
        For ii=0 To image_height-1
          Plot(i, iii, points(i, ii))
          iii-1
        Next
        iii=image_height-1
      Next
    EndIf
    
    StopDrawing ()
    
    If create_new_image
      ProcedureReturn new_image_ID
    EndIf
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure Texture_universal_output_BF(mode, output_ID, temporary_image_ID, texture_ID, temporary_color,
                                        texture_x=0,
                                        texture_y=0,
                                        texture_width=0,
                                        texture_height=0,
                                        texture_clip_x=0,
                                        texture_clip_y=0,
                                        texture_clip_xx=0,
                                        texture_clip_yy=0)
    
    If Not IsImage(output_ID)
      If Not IsGadget(output_ID) ; Check for canvas
        ProcedureReturn -11
      Else
        Protected canvas=1
      EndIf
    EndIf
    
    If Not IsImage(temporary_image_ID) : ProcedureReturn -10 : EndIf
    If mode>-1 And Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    
    Protected mode_1, old_color_bf.q
    
    old_color_bf=GetColor_BF()
    SetColor_BF(temporary_color)
    
    Protected old_bucket_array_state=GetBucketArray_State_BF()
    ActivateBucketArray_BF(1) ; Activate the BucketFill array
    
    If mode<0 : mode_1=-1 : Else : mode_1=-2 : EndIf
    If Not mode Or mode<-256 Or mode>256 : mode=1 : EndIf
    
    ; - Call function #1 -
    Protected result=BF(mode_1, temporary_image_ID, texture_ID,
                        -1,
                        -1,
                        texture_x,
                        texture_y,
                        texture_width,
                        texture_height,
                        texture_clip_x,
                        texture_clip_y,
                        texture_clip_xx,
                        texture_clip_yy)
    
    Protected grab_x=GetBucket_X_BF()
    Protected grab_y=GetBucket_Y_BF()
    Protected grab_xx=GetBucket_XX_BF()
    Protected grab_yy=GetBucket_YY_BF()
    
    ActivateBucketArray_BF(old_bucket_array_state)
    
    SetColor_BF(old_color_bf)
    
    If result<1
      ProcedureReturn result
    EndIf
    
    If grab_xx-grab_x<1 Or grab_yy-grab_y<1 : ProcedureReturn 0 : EndIf
    
    StartDrawing(ImageOutput(temporary_image_ID))
    Protected temporary_texture_ID=GrabDrawingImage(#PB_Any, grab_x, grab_y, grab_xx-grab_x+1, grab_yy-grab_y+1)
    StopDrawing()
    
    Protected old_invisible_color.q=GetInvisibleColor_BF()
    SetInvisibleColor_BF(temporary_color-1)
    
    ; The function is now ready for output
    ; The output is a sprite, created in the picture temporary_texture_ID
    ; The invisible color from this sprite is temporary_color-1
    ; You can make with this sprite how ever you want, as sample rotate, catch for other functions, or other things
    ; Call function #2 is only the output function for the sprite
    
    If canvas
      ; - Call function #2 -
      result=BF(Abs(mode), output_ID, temporary_texture_ID,
                0,
                0,
                grab_x,
                grab_y,
                ImageWidth(temporary_texture_ID),
                ImageHeight(temporary_texture_ID))
    Else
      result=SpriteSimple_fast_BF(Abs(mode), output_ID, temporary_texture_ID,                                     
                                  0,      ; Grab transparence color from the frame pos x - Set to -1 for output without invisible color 
                                  0,      ; Grab transparence color from the frame pos y - You can set x or y, or both parameters to -1 
                                  grab_x, ; Output position x
                                  grab_y) ; Output position y
    EndIf
    
    SetInvisibleColor_BF(old_invisible_color)
    
    Free_selected_Texture_BF(temporary_texture_ID)
    
    ProcedureReturn result
    
  EndProcedure
  
  Procedure Create_animation_buffers_image_BF(output_ID)
    Protected image_width, image_height, result=-9
    If IsImage(temporary_image_0_ID_BF) : Free_selected_Texture_BF(temporary_image_0_ID_BF) : EndIf
    If IsImage(temporary_image_1_ID_BF) : FreeImage(temporary_image_1_ID_BF) : EndIf
    If IsGadget(output_ID)
      image_width=GadgetWidth(output_ID)
      image_height=GadgetHeight(output_ID)
    ElseIf IsImage(output_ID)
      image_width=ImageWidth(output_ID)
      image_height=ImageHeight(output_ID)
    Else
      ProcedureReturn -9
    EndIf
    temporary_image_0_ID_BF=CreateImage(#PB_Any, image_width, image_height) ; Create a temporary image for the BF image output
    temporary_image_1_ID_BF=CreateImage(#PB_Any, image_width, image_height) ; Create a temporary image for the background
    result=CopyContent_BF(output_ID, temporary_image_0_ID_BF)               ; Put the background in the temporary image 0
    result+CopyContent_BF(output_ID, temporary_image_1_ID_BF)               ; Put the background in the temporary image 1
    If result=2 : ProcedureReturn 1 : EndIf
  EndProcedure
  
  Procedure Create_animation_buffers_canvas_BF(output_ID)
    Protected image_width, image_height, result=-9
    If IsGadget(temporary_canvas_ID_BF) : FreeGadget(temporary_canvas_ID_BF) : EndIf
    If IsImage(temporary_image_0_ID_BF) : Free_selected_Texture_BF(temporary_image_0_ID_BF) : EndIf
    If IsGadget(output_ID)
      image_width=GadgetWidth(output_ID)
      image_height=GadgetHeight(output_ID)
    ElseIf IsImage(output_ID)
      image_width=ImageWidth(output_ID)
      image_height=ImageHeight(output_ID)
    Else
      ProcedureReturn -9
    EndIf
    temporary_canvas_ID_BF=CanvasGadget(#PB_Any, -GadgetWidth(output_ID), -GadgetHeight(output_ID),
                                        GadgetWidth(output_ID), GadgetHeight(output_ID)) ; Create a temporary canvas for the BF canvas output
    temporary_image_0_ID_BF=CreateImage(#PB_Any, image_width, image_height)              ; Create a temporary image for the background
    result=CopyContent_BF(output_ID, temporary_canvas_ID_BF)                             ; Put the background in the temporary canvas
    result+CopyContent_BF(output_ID, temporary_image_0_ID_BF)                            ; Put the background in the temporary image 
    If result=2 : ProcedureReturn 1 : EndIf
  EndProcedure
  
  Procedure FlipBuffers_image_BF()
    If Not StartDrawing(ImageOutput(temporary_image_0_ID_BF)) : ProcedureReturn -5 : EndIf
    DrawImage(ImageID(temporary_image_1_ID_BF), 0, 0)
    StopDrawing()
  EndProcedure
  
  Procedure Free_animation_buffers_image_BF()
    If IsImage(temporary_image_0_ID_BF) : Free_selected_Texture_BF(temporary_image_0_ID_BF) : EndIf
    If IsImage(temporary_image_1_ID_BF) : FreeImage(temporary_image_1_ID_BF) : EndIf
  EndProcedure
  
  Procedure Get_animation_buffer_background_ID_image_BF()
    ProcedureReturn temporary_image_1_ID_BF
  EndProcedure
  
  Procedure Get_animation_buffer_hidden_ID_image_BF()
    ProcedureReturn temporary_image_0_ID_BF
  EndProcedure
  
  Procedure FlipBuffers_canvas_BF()
    If Not StartDrawing(CanvasOutput(temporary_canvas_ID_BF)) : ProcedureReturn -5 : EndIf
    DrawImage(ImageID(temporary_image_0_ID_BF), 0, 0)
    StopDrawing()
  EndProcedure
  
  Procedure Free_animation_buffers_canvas_BF()
    If IsGadget(temporary_canvas_ID_BF) : FreeGadget(temporary_canvas_ID_BF) : EndIf
    If IsImage(temporary_image_0_ID_BF) : Free_selected_Texture_BF(temporary_image_0_ID_BF) : EndIf
  EndProcedure
  
  Procedure Get_animation_buffer_background_ID_canvas_BF()
    ProcedureReturn temporary_image_0_ID_BF
  EndProcedure
  
  Procedure Get_animation_buffer_hidden_ID_canvas_BF()
    ProcedureReturn temporary_canvas_ID_BF
  EndProcedure
  
  Procedure NoCaching_BF(caching)
    no_caching=caching
  EndProcedure
  
  Procedure Get_caching_state_BF()
    ProcedureReturn 1-no_caching
  EndProcedure
  
  Procedure SetPosMarker_BF(output_ID, x, y) ; Set a positioning help marker
    Protected canvas, result
    If Not IsImage(output_ID)
      If IsGadget(output_ID) ; Check for canvas
        canvas=1
      Else
        ProcedureReturn -11
      EndIf
    EndIf
    If canvas
      result=StartDrawing(CanvasOutput(output_ID))
    Else
      result=StartDrawing(ImageOutput(output_ID))
    EndIf
    If Not result : ProcedureReturn -3 : EndIf
    Circle(x, y, 8, 0)
    Circle(x, y, 6, $FFFF00)
    Circle(x, y, 4, -1)
    Circle(x, y, 1, $FF)
    StopDrawing()
  EndProcedure
  
  Procedure Create_invisible_GIF_color(gif_ID)
    Protected sheet_ID, i, ii, iii, iiii, file, invisible_color
    Protected gif_width, gif_height, sheet_width, sheet_height, frames, frames_x, frames_y
    
    If Not IsImage(gif_ID) : ProcedureReturn -10 : EndIf
    
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
    
    FreeImage(sheet_ID)
    
    If invisible_color<1 : ProcedureReturn 0 : EndIf
    
    ProcedureReturn invisible_color
    
  EndProcedure
  
EndModule

UseModule BucketFill_advanced
