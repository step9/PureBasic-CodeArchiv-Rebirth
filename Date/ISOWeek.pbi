;   Description: Adds a function to get the week number (ISO 8601)
;        Author: TI-994A (Variables set as protected by Sicro)
;          Date: 2013-08-11
;            OS: Windows, Linux, Mac
; English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=420707#p420707
;  French-Forum: 
;  German-Forum: 
; -----------------------------------------------------------------------------

Procedure.i ISOWeek(date)
  
  Protected year, firstDay, ISOday, ISOwk
  
  year = Year(date)
  firstDay = DayOfWeek(Date(year, 1, 1, 0, 0, 0))
  If firstDay = 0
    firstDay = 7
  EndIf
  If firstDay <= 4
    ISOday = DayOfYear(date) + (firstDay - 1)
  Else
    ISOday = DayOfYear(date) - (8 - firstDay)
  EndIf
  ISOwk = Round(ISOday / 7, #PB_Round_Up)
  If Not ISOwk
    ISOwk = ISOWeek(Date(year - 1, 12, 31, 0, 0, 0))
  EndIf
  ;------
  If ISOwk = 53 And Month(date) = 12 And
     DayOfWeek(Date(year + 1, 1, 1, 0, 0, 0)) <= 4
    ISOwk = 1
  EndIf
  ;------
  ProcedureReturn ISOwk
  
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  Debug ISOWeek(Date())
  Debug ISOWeek(Date(1997, 12, 29, 0, 0, 0)) ;week #1
  Debug ISOWeek(Date(2012, 12, 31, 0, 0, 0)) ;week #1
  Debug ISOWeek(Date(2012, 1, 1, 0, 0, 0))   ;week #52
  Debug ISOWeek(Date(2016, 1, 1, 0, 0, 0))   ;week #53
  
CompilerEndIf
