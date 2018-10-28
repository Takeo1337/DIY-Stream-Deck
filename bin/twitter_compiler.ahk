#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
StringTrimRight, ScriptMainDir, A_ScriptDir, 4
SetWorkingDir %ScriptMainDir%  ; Ensures a consistent starting directory.

myScriptName = % A_Args[1]

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

IfExist %myScriptName%.exe
{
	FileGetTime, FileTime, %myScriptName%.exe
	filetime = true
}

Run, Ahk2Exe.exe /in %myScriptName%.ahk /icon bin/twitterIcon.ico

If (%filetime% = true)
{
	FileGetTime, FileTimeNew, %myScriptName%.exe

	While(%FileTimeNew% == %FileTime%)
	{
		Sleep, 50
		FileGetTime, FileTimeNew, %myScriptName%.exe
	}
}

Sleep, 250
Run, %myScriptName%.exe

FileDelete, bin/twitterTemp.ahk
FileAppend,, bin/twitterTemp.ahk
	
ExitApp
