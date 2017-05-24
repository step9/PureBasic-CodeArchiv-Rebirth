;   Description: Adds a function to get the number of days in a month
;        Author: Sicro
;          Date: 2017-04-15
;            OS: Windows, Linux, Mac
; English-Forum: Not in the forum
;  French-Forum: Not in the forum
;  German-Forum: Not in the forum
; -----------------------------------------------------------------------------

Procedure.i DaysInMonth(Month, Year)
  
  Protected Date
  
  Date = Date(Year, Month, 1, 0, 0, 0)
  Date = AddDate(Date, #PB_Date_Month, 1)
  Date = AddDate(Date, #PB_Date_Day, -1)
  
  ProcedureReturn Day(Date)
  
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  Define i
  For i = 1 To 12
    Debug DaysInMonth(i, 2017)
  Next
  
CompilerEndIf
