;   Description: Sets access and modification time of file
;        Author: Sicro
;          Date: 2017-04-15
;            OS: Windows, Linux, Mac
; English-Forum: Not in the forum
;  French-Forum: Not in the forum
;  German-Forum: Not in the forum
; -----------------------------------------------------------------------------

Procedure.i TouchFile(FilePath$)
  
  Protected File
  
  Select FileSize(FilePath$)
      
    Case -2 ; Directory
      ProcedureReturn #False
      
    Case -1 ; File doesn't exists
      File = CreateFile(#PB_Any, FilePath$)
      If File
        CloseFile(File)
      EndIf
      ProcedureReturn Bool(File)
      
    Default
      If Not SetFileDate(FilePath$, #PB_Date_Accessed, Date())
        ProcedureReturn #False
      EndIf
      If Not SetFileDate(FilePath$, #PB_Date_Modified, Date())
        ProcedureReturn #False
      EndIf
      ProcedureReturn #True
      
  EndSelect
  
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  ; Run the code more times to see the effect
  
  Define TestFilePath$ = GetTemporaryDirectory() + "TestFile"
  
  Debug TouchFile(TestFilePath$)
  Debug FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", GetFileDate(TestFilePath$, #PB_Date_Accessed))
  Debug FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", GetFileDate(TestFilePath$, #PB_Date_Modified))
  
CompilerEndIf
