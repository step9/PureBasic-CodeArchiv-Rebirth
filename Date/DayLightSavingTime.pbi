;   Description: Returns the status of whether the current time is daylight saving time
;        Author: Sicro
;          Date: 2017-04-24
;            OS: Windows, Linux, Mac
; English-Forum: Not in the forum
;  French-Forum: Not in the forum
;  German-Forum: Not in the forum
; -----------------------------------------------------------------------------

Procedure.i IsDayLightSavingTime()
  
  CompilerSelect #PB_Compiler_OS
      
    CompilerCase #PB_OS_Windows
      ; https://msdn.microsoft.com/de-de/library/windows/desktop/ms724421(v=vs.85).aspx
      
      Protected.TIME_ZONE_INFORMATION lpTimeZoneInformation
      
      Select GetTimeZoneInformation_(@lpTimeZoneInformation)
        Case 1 : ProcedureReturn #False
        Case 2 : ProcedureReturn #True
        Case 0 : ProcedureReturn -1
      EndSelect
      
    CompilerCase #PB_OS_Linux
      ; https://linux.die.net/man/2/time
      ; https://linux.die.net/man/3/localtime
      
      If Not Defined(tm, #PB_Structure)
        Structure tm Align #PB_Structure_AlignC
          tm_sec.l    ; 0 bis 59 oder bis 60 bei Schaltsekunde
          tm_min.l    ; 0 bis 59
          tm_hour.l   ; 0 bis 23
          tm_mday.l   ; Tag des Monats: 1 bis 31
          tm_mon.l    ; Monat: 0 bis 11 (Monate seit Januar)
          tm_year.l   ; Anzahl der Jahre seit dem Jahr 1900
          tm_wday.l   ; Wochentag: 0 bis 6, 0 = Sonntag
          tm_yday.l   ; Tage seit Jahresanfang: 0 bis 365 (365 ist also 366, da nach 1. Januar gezählt wird)
          tm_isdst.l  ; Ist Sommerzeit? tm_isdst > 0 = Ja
                      ;                             tm_isdst = 0 = Nein
                      ;                             tm_isdst < 0 = Unbekannt
          CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
            tm_gmtoff.l ; Offset von UTC in Sekunden
            *tm_zone    ; Abkürzungsname der Zeitzone
          CompilerElse
            tm_zone.l   ; Platzhalter
            tm_gmtoff.l ; Offset von UTC in Sekunden
            *tm_zone64  ; Abkürzungsname der Zeitzone
          CompilerEndIf    
        EndStructure
      EndIf
      
      Protected.tm *CurrentTime = time_(0)
      Protected.tm *LocalTime   = localtime_(@*CurrentTime)
      
      If *LocalTime\tm_isdst > 0
        ProcedureReturn #True
      ElseIf *LocalTime\tm_isdst = 0
        ProcedureReturn #False
      ElseIf *LocalTime\tm_isdst < 0
        ProcedureReturn -1
      EndIf
      
    CompilerCase #PB_OS_MacOS
      ; http://www.purebasic.fr/english/viewtopic.php?p=410207#p410207
      
      Protected TimeZoneObject = CocoaMessage(0, 0, "NSTimeZone systemTimeZone")
      Protected DaylightSavingTime
      
      CocoaMessage(@DaylightSavingTime, TimeZoneObject, "isDaylightSavingTime")
      
      ProcedureReturn DaylightSavingTime
      
  CompilerEndSelect
  
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  Select IsDayLightSavingTime()
    Case #True  : Debug "Sommerzeit!"
    Case #False : Debug "Winterzeit!"
    Default     : Debug "Unbekannt!"
  EndSelect
  
CompilerEndIf
