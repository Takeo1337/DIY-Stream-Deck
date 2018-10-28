#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#InstallKeybdHook
#InstallMouseHook
;KeyHistory
;#KeyHistory 900

Gui 1:New,,Setup Helper
Gui 1:Font, s12, Verdana
Gui 1:Add, Text, w150, Keyboard ID:

Gui 1:Add, Edit, w300 vusrKB
FileRead,FileContentsKB,bin/usrKeyboard.txt
GuiControl,, usrKB, %FileContentsKB%
Gui 1:Margin, 10,20

Gui 1:Add, Text, w150 x170, Tasten:

Gui 1:Add, Button, gHinzufuegen w150 x10 y110, Tasten Hinzufügen
Gui 1:Add, Edit, -Wrap w150 x+10 y110 R13 vMyEdit

FileRead,FileContents,bin/keysTemp.txt
GuiControl,, MyEdit, %FileContents%

Gui 1:Add, Button, glistDelete w150 x10 y+-172, Liste Löschen
Gui 1:Add, Button, gBearbeiten w150, Änderungen übernehmen
Gui 1:Add, Button, gPlanung w150, Windows Aufgabenplanung

Gui 1:Add, GroupBox, w310 r2, Standart Editor
FileRead, checkedVar, bin/defaultEditor.txt
if checkedVar = 1
{
Gui 1:Add, Radio, checked vWinNotepad gRadioButtonWinNote xp+20 yp+35 r1, Windows Notepad
Gui 1:Add, Radio, vNotepadPlus gRadioButtonNotePlus r1, Notepad++
}
else if checkedVar = 2
{
Gui 1:Add, Radio, vWinNotepad gRadioButtonWinNote xp+20 yp+35 r1, Windows Notepad
Gui 1:Add, Radio, checked vNotepadPlus gRadioButtonNotePlus r1, Notepad++
}
else
{
Gui 1:Add, Radio, vWinNotepad gRadioButtonWinNote xp+20 yp+35 r1, Windows Notepad
Gui 1:Add, Radio, vNotepadPlus gRadioButtonNotePlus r1, Notepad++
}

Gui 1:Font, s12, Verdana
Gui 1:Add, Button, w150 gErstellen vMainButton Default w300 h50 x15, Dateien erstellen
Gui 1:Show

FileRead, checkedVar, bin/defaultEditor.txt

if (FileContents = "")
{
	GuiControl, Disable, MainButton
}
else
{
	GuiControl, Enable, MainButton
}
Return

RadioButtonWinNote:
FileDelete, bin/defaultEditor.txt
FileAppend, 1, bin/defaultEditor.txt
return

RadioButtonNotePlus:
FileDelete, bin/defaultEditor.txt
FileAppend, 2, bin/defaultEditor.txt
return

aufgabenPlaner:
Run, taskschd.msc
return

MainButtonEnable:
if (FileContents = "")
{
	GuiControl, Disable, MainButton
}
else
{
	GuiControl, Enable, MainButton
}
return

listDelete:
FileDelete, bin/keysTemp.txt
FileAppend,, bin/keysTemp.txt
FileRead,FileContents,bin/keysTemp.txt
GuiControl,, MyEdit, %FileContents%
GuiControl, Disable, MainButton
return

Bearbeiten:
Gui, Submit , NoHide
FileDelete, bin/usrKeyboard.txt
FileAppend, %usrKB%, bin/usrKeyboard.txt
FileDelete, bin/keysTemp.txt
FileAppend, %MyEdit%, bin/keysTemp.txt
FileRead,FileContents,bin/keysTemp.txt
GuiControl,, MyEdit, %FileContents%
if (FileContents = "")
{
	GuiControl, Disable, MainButton
}
else
{
	GuiControl, Enable, MainButton
}
return

Hinzufuegen:
Gui 2:New,,Keys Hinzufügen
Gui 2:Margin, 20,20
Gui 2:Add, Text, w150, Auf input warten...
Gui 2:Add, Button, gGui2Destroy Default w150 h30, OK
Gui 2:Show

#if WinExist("Keys Hinzufügen")
{
	#include %A_ScriptDir%\bin\keydata.ahk
}
return

Gui2Destroy:
Gui 2: Destroy
return

Planung:
Run, taskschd.msc
return

Erstellen:
Gui, Submit
FileDelete, bin\keysTemp.txt
FileAppend, %MyEdit%, bin/keysTemp.txt

FileDelete, bin\usrKeyboard.txt
FileAppend, %usrKB%, bin/usrKeyboard.txt

Run, %A_ScriptDir%\bin\setuphelperlogic.ahk %usrKB%
ExitApp
return

GuiClose:
Quitter:
ExitApp