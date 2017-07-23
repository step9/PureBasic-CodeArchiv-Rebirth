﻿; This code is just a sample to show auto-indention with (Ctrl)-I

; To inject the indentation-information for the 'DynamicDialogs_suffixed' functions, please use the 'DynamicDialogs_Suffix Indentation-Injector.pb'

XIncludeFile "DynamicDialogs_suffixed.pbi"

UseModule	DynamicDialogs

Panel()
Tab("Tab 1")
Splitter(#PB_Ignore, "", 100,200,#PB_Splitter_Vertical,0,0,0,"0")
Button(2545)
Editor(4444)
EndSplitter()
EndTab()				
Tab("Tab 3","2")
Splitter(#PB_Ignore,"",200,100, #PB_Splitter_Vertical)
Button(25345)
Editor(424)
EndSplitter()
EndTab()
EndPanel()

UnuseModule	DynamicDialogs

; The following code is also auto-indented with (Ctrl)-I, but it was indented right, because the indentation-Information has been injected

UseModule	DynamicDialogs_suffixed	

Panel__()
	Tab__("Tab 1")
		Splitter__(#PB_Ignore, "", 100,200,#PB_Splitter_Vertical,0,0,0,"0")
			Button__(2545)
			Editor__(4444)
		EndSplitter__()
	EndTab__()				
	Tab__("Tab 3","2")
		Splitter__(#PB_Ignore,"",200,100, #PB_Splitter_Vertical)
			Button__(25345)
			Editor__(424)
		EndSplitter__()
	EndTab__()
EndPanel__()

UnuseModule	DynamicDialogs_suffixed


