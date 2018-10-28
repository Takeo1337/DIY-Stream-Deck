#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
StringTrimRight, ScriptMainDir, A_ScriptDir, 4
SetWorkingDir %ScriptMainDir%  ; Ensures a consistent starting directory.

IfNotExist hotkeys.ahk
{
	FileAppend,,hotkeys.ahk, UTF-8-RAW
	Loop {
		IfExist hotkeys.ahk
		{
			break
		}
	}
}

usrKB = % A_Args[1]
if (usrKB = "")
{
	MsgBox, Fehler!`nKeine Keyboard ID angegeben!
	Run, Setup Helper.ahk
	ExitApp
}

keyArr:=[]
Loop
{
    FileReadLine, fileKey, bin\keysTemp.txt, %A_Index%
    if ErrorLevel
	{
        break
	}
	else
	{	
		keyArr.Push(fileKey)
	}
}


	
While(counter <= keyArr.length())
{
	#include bin/id_and_hotkey_ifelse.ahk
}
	
doesExistIntercept(keyVal)
{	
	Loop, read, keyremap.ini
	{
		Loop, parse, A_LoopReadLine, %A_Tab%
		{
			;msgbox, [%keyVal%]
			If A_LoopReadLine = [%keyVal%]
			{
				return true
			}	
		}
	}
}

doesExistHotkey(keyVal)
{
	Loop, read, hotkeys.ahk
	{
		Loop, parse, A_LoopReadLine, %A_Tab%
		{
			If A_LoopReadLine = %keyVal%::
			{
				return true
			}	
		}
	}
}


CreateUserFiles(kbkey, hextrigger, kbkey2:="", doublekey="")
{	
	global usrKB
	
	if doesExistIntercept(kbkey) != true
	{
		if (kbkey2 = "fuckyoukey")
		{
			FileAppend,
			(
[%kbkey%]
device=%usrKB%
trigger=1d,0,4
combo=6e,0,0|1d,0,4|45,0,0|1d,0,5|45,0,1|6e,0,1`n
			), keyremap.ini
		}
		else if (kbkey2 = "doubleKey" || doublekey = "doubleKey")
		{
			FileAppend,
			(
[%kbkey%]
device=%usrKB%
trigger=%hextrigger%,0,2
combo=6e,0,0|%hextrigger%,0,2|%hextrigger%,0,3|6e,0,1`n
			), keyremap.ini
		}
		else
		{
			FileAppend,
			(
[%kbkey%]
device=%usrKB%
trigger=%hextrigger%,0,0
combo=6e,0,0|%hextrigger%,0,0|%hextrigger%,0,1|6e,0,1`n
			), keyremap.ini
		}
	}
	
	if doesExistHotkey(kbkey) != true
	{
		if (kbkey2 != "" && kbkey2 != "doubleKey" && kbkey2 != "fuckyoukey")
		{
		FileAppend,
		(
%kbkey%::
%kbkey2%::`n`n`n
		), hotkeys.ahk
		}
		else
		{
		FileAppend,
		(
%kbkey%::`n`n`n
		), hotkeys.ahk
		}
	}
}


MsgBox, 4, Daten erstellt, Daten sind erstellt. Hotkeys jetzt bearbeiten? 
IfMsgBox, Yes 
{
	FileRead, editorVar,bin/defaultEditor.txt
	if editorVar = 1
	{
		Run, Edit hotkeys.ahk
	}
	else if editorVar = 2
	{
		Run, notepad++.exe hotkeys.ahk
	}
	else
	{
		msgbox, %editorVar%
		Run, Edit hotkeys.ahk
	}
}
