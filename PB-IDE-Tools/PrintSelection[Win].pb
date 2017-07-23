﻿;   Description: Print selected source code
;     Parameter: "%FILE" "%SELECTION"
;        Author: hjbremer
;          Date: 2014-03-05
;            OS: Windows
; English-Forum: 
;  French-Forum: 
;  German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27810
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_Windows
  CompilerError "Windows only!"
CompilerEndIf

CompilerIf #PB_Compiler_Debugger
  
  ;zum Testen
  para_dateiname$ = "c:\bremer\kto\kto.pb"
  para_selection$ = "10x2x19x5"
  
CompilerElse
  
  para_dateiname$ = ProgramParameter()
  para_selection$ = ProgramParameter()
  
  ;wurde Datei noch nicht gepeichert, ist %FILE leer und die Parameter
  ;verschieben sich, so das para_selection$ ein Leerstring ist.
  If para_selection$ = ""
    MessageRequester("", "File must be saved!")
    End
  EndIf
  
CompilerEndIf

path$ = GetTemporaryDirectory()
temp_dateiname$ = path$ + "mySelection.txt"
print_dateiname$ = path$ + "mySelection.txt"

row1$ = StringField(para_selection$, 1, "x")
col1$ = StringField(para_selection$, 2, "x")
row2$ = StringField(para_selection$, 3, "x")
col2$ = StringField(para_selection$, 4, "x")

If Bool(row1$ = row2$ And col1$ = col2$)
  selected = #False
Else
  selected = #True
EndIf   

If selected = #True
  
  vonzeile = Val(row1$)
  biszeile = Val(row2$)
  
  dnr = ReadFile(#PB_Any, para_dateiname$)
  znr = CreateFile(#PB_Any, print_dateiname$)
  If dnr
    If znr
      
      WriteStringN(znr, "")
      WriteStringN(znr, #PB_Compiler_Filename + " from line " + row1$ + " to " + row2$)
      WriteStringN(znr, "")
      
      While Eof(dnr) = 0
        x$ = ReadString(dnr)
        ze + 1
        If Bool(ze >= vonzeile And ze <= biszeile)
          WriteStringN(znr, RSet(Str(ze), 5) + " " + x$)
        EndIf           
      Wend
      
      CloseFile(znr)
    EndIf
    CloseFile(dnr)
  EndIf
  
Else
  
  print_dateiname$ = para_dateiname$
  
EndIf

;ShellExecute_(#Null, "open", "notepad", "/P " + print_dateiname$, #Null, #SW_HIDE)
;oder
RunProgram("Notepad", "/P " +Chr(34)+ print_dateiname$+Chr(34), "",#PB_Program_Wait|#PB_Program_Hide)
DeleteFile(temp_dateiname$)

