#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#HotkeyInterval 10000; Standardwert (Millisekunden).
#MaxHotkeysPerInterval 3000

IfNotExist, bin/defaultEditor.txt
{
	customEditorEnable = false
}
else
{
	FileRead, customEditorVar, bin/defaultEditor.txt
	if customEditorVar = 1
	{
		customEditorEnable = false
	}
	else if customEditorVar = 2
	{
		customEditorEnable = true
	}
	else
	{
		customEditorEnable = false
	}
}

;Name des Editors
customEditorName = notepad++.exe

; ----------- Intercept Starten ---------- ;
Process, Exist, intercept.exe
If (ErrorLevel = 0)
	{
		Run, intercept_hidden.vbs
	}

; ----------- System Tray Menu ----------- ;
Menu, Tray, NoStandard
Menu, Tray, Add, Script Ordner Öffnen, OpenWorkDir
Menu, Tray, Add, Script Bearbeiten, EditScript
Menu, Tray, Add, Hotkeys Bearbeiten, EditHotkeys
Menu, Tray, Add, ------------------, null
Menu, Tray, Add, Intercept Starten, InterceptStart
Menu, Tray, Add, Intercept Beenden, InterceptExit
Menu, Tray, Add, Intercept Restart, InterceptRestart
Menu, Tray, Add, -------------------, null
Menu, Tray, Add, Setup Helper, setupHelper
IfExist, bin/HotkeyGuide.pdf
{
Menu, Tray, Add, Hotkey Guide Öffnen, setupHelperHotkeys
}
Menu, Tray, Add, --------------------, null
Menu, Tray, Add, Änderungen Übernehmen, appCompile
Menu, Tray, Add, Neustarten, appRestart
Menu, Tray, Add, Beenden, appExit

; ---------- Abfrage ob das Script Kompiliert werden soll ---------- ;
StringTrimRight, ScriptNameRaw, A_ScriptName, 4
if A_ScriptName = %ScriptNameRaw%.ahk
{
	MsgBox, 4, Script Kompilieren, Das Script ist noch nicht kompiliert. `nJetzt Kompilieren?
	IfMsgBox Yes
	{
		GoTo, appCompile
		return
	}
	else
	{
		return
	}
}
return

; ------------------------- HOTKEYS --------------------------- ;

#if (getKeyState("F23", "P"))
F23::return

#include hotkeys.ahk

#if

; ----------------------- MENU PUNKTE ------------------------- ;

OpenWorkDir:
Run, %A_ScriptDir%
return

EditHotkeys:
if customEditorEnable = true
{
	Run, %customEditorName% %A_ScriptDir%\hotkeys.ahk
}
else
{
	Run, Edit hotkeys.ahk
}
return

EditScript:
StringTrimRight, ScriptName, A_ScriptName, 4
if customEditorEnable = true
{
	Run, %customEditorName% %A_ScriptDir%\%ScriptName%.ahk
}
else
{
	Run, Edit %ScriptName%.ahk
}
return

setupHelper:
run, Setup Helper.ahk
return

setupHelperHotkeys:
run, bin\HotkeyGuide.pdf
return

InterceptStart: 
Loop {
	Process, Exist, intercept.exe
	If (ErrorLevel = 0)
	{
		Run, intercept_hidden.vbs
		Sleep, 600
	}
	else 
	{
		break
	}
}
return

InterceptExit: 
Loop {
	Process, Exist, intercept.exe
	If (ErrorLevel = 0)
	{
		break
	}
	else 
	{
		Process, Close, intercept.exe
	}
}
return

InterceptRestart:
Loop {
	Process, Exist, intercept.exe
	If (ErrorLevel = 0)
	{
		Run, intercept_hidden.vbs
		break
	}
	else 
	{
		Process, Close, intercept.exe
	}
}
return

appCompile:
StringTrimRight, ScriptName, A_ScriptName, 4
Run, bin\compile.ahk %ScriptName%
ExitApp
return

appRestart:
Loop {
	Process, Exist, intercept.exe
	If (ErrorLevel = 0)
	{
		break
	}
	else 
	{
		Process, Close, intercept.exe
	}
}
Reload
return

appExit:
Loop {
	Process, Exist, intercept.exe
	If (ErrorLevel = 0)
	{
		break
	}
	else 
	{
		Process, Close, intercept.exe
	}
}
ExitApp
return

null:
return
