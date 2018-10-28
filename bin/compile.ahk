#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
StringTrimRight, ScriptMainDir, A_ScriptDir, 4
SetWorkingDir %ScriptMainDir%  ; Ensures a consistent starting directory.

; Name des Scriptes, keine Dateinendungen!
myScriptName = % A_Args[1]

; Name des Icons, keine Dateinendungen!
iconName = favicon

if (myScriptName = "")
{
	InputBox, myScriptName, Script Name Definieren, Beim ausführen wurde kein Scriptparameter übergeben. `n `rBitte den richtigen Script Namen OHNE Dateiendungen angeben.
		if ErrorLevel = 1
		{
			ExitApp
		}
	IfNotExist, %myScriptName%.ahk
	{
		Loop {
			InputBox, myScriptName, Script Name Definieren, Das angegebene Script existiert nicht. `n `rBitte den richtigen Script Namen OHNE Dateiendungen angeben.
			if ErrorLevel = 1
			{
				ExitApp
			}
			ifExist, %myScriptName%.ahk
			{
				break
			}
		}
	}
}

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
Loop {
	Process, Exist, %myScriptName%.exe
	If (ErrorLevel = 0)
	{
		break
	}
	else 
	{
		Process, Close, %myScriptName%.exe
	}
}

ifExist %myScriptName%.exe
{
	FileGetTime, FileTime, %myScriptName%.exe
	
	ifExist bin/%iconName%.ico
	{
		Run, Ahk2Exe.exe /in %myScriptName%.ahk /icon bin/%iconName%.ico
	}
	else
	{
		Run, Ahk2Exe.exe /in %myScriptName%.ahk
	}
	
	FileGetTime, FileTimeNew, %myScriptName%.exe
	
	While(%FileTimeNew% == %FileTime%)
	{
		Sleep, 50
		FileGetTime, FileTimeNew, %myScriptName%.exe
		
		if %FileTimeNew% != %FileTime%
		{
			break
		}
	}
	
	Sleep, 250
	Run, %myScriptName%.exe
	
	ExitApp
}
else
{
	ifExist bin/%iconName%.ico
	{
		Run, Ahk2Exe.exe /in %myScriptName%.ahk /icon bin/%iconName%.ico
	}
	else
	{
		Run, Ahk2Exe.exe /in %myScriptName%.ahk
	}
	
	Loop {
		ifExist %myScriptName%.exe
		{
			break
		}
		else 
		{
			Sleep, 50
		}
	}
	
	Sleep, 250
	Run, %myScriptName%.exe
	
	ExitApp
}