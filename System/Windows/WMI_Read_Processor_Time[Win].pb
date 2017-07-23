﻿;   Description: Read processor time with WMI
;        Author: Kiffi
;          Date: 2015-11-02
;            OS: Windows
; English-Forum: 
;  French-Forum: 
;  German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29242
;-----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_Windows
  CompilerError "Windows Only!"
CompilerEndIf
EnableExplicit

Define VbScript.s
Define VBS
Define Xml.s

VbScript = "Set objWMIService = GetObject(''winmgmts:\\localhost\root\CIMV2'')" + #CRLF$ +
           "Set CPUInfo = objWMIService.ExecQuery(''SELECT PercentProcessorTime FROM Win32_PerfFormattedData_PerfOS_Processor'',,48)" + #CRLF$ +
           "Output = ''<list>''" + #CRLF$ +
           "For Each Item in CPUInfo" + #CRLF$ +
           "  Output = Output & ''<element>'' & Item.PercentProcessorTime & ''</element>''" + #CRLF$ +
           "Next" + #CRLF$ +
           "Output = Output & ''</list>''" + #CRLF$ +
           "WScript.StdOut.Writeline Output" + #CRLF$

VbScript = ReplaceString(VbScript, "''", Chr(34))

CreateFile(0, GetTemporaryDirectory() + "cpuinfo.vbs")
WriteString(0, VbScript)
CloseFile(0)

VBS = RunProgram("wscript", GetTemporaryDirectory() + "cpuinfo.vbs", "", #PB_Program_Open | #PB_Program_Read)

If VBS
  Xml = ReadProgramString(VBS)
  CloseProgram(VBS)
Else
  Debug "!RunProgram"
EndIf

If ParseXML(0, Xml) And XMLStatus(0) = #PB_XML_Success
  NewList Value.s()
  ExtractXMLList(MainXMLNode(0), Value())
  FreeXML(0)
  ForEach Value()
    Debug "PercentProcessorTime: " + Value()
  Next
Else
  Debug XMLError(0)
EndIf
