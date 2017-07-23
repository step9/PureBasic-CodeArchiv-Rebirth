﻿;   Description: Enable scrolling before the cursor reach the border
;        Author: GPI
;          Date: 2015-10-04
;            OS: Windows
; English-Forum: 
;  French-Forum: 
;  German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29179
;-----------------------------------------------------------------------------
;Select as "Event to trigger the tool": "Sourcecode loaded" and "New Sourcecode created"

CompilerIf #PB_Compiler_OS<>#PB_OS_Windows
  CompilerError "Windows Only!"
CompilerEndIf

;MessageRequester("test",GetEnvironmentVariable("PB_TOOL_Scintilla" ))
handle=Val(GetEnvironmentVariable("PB_TOOL_Scintilla" ))
If handle
  SendMessage_(handle,#SCI_SETXCARETPOLICY,#CARET_SLOP|#CARET_EVEN|#CARET_STRICT    ,100);100 Pixel in x-Richtung
  SendMessage_(handle,#SCI_SETYCARETPOLICY,#CARET_SLOP|#CARET_EVEN|#CARET_STRICT    ,3)  ;3 Zeilen
EndIf
