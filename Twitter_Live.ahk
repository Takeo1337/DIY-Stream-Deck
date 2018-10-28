#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
StringTrimRight, ScriptName, A_ScriptName, 4

if A_ScriptName = %ScriptName%.exe
{
	#include bin/twitterTemp.ahk
}
else
{
	if A_ScriptName = %ScriptName%.ahk
	{
		goto, Login
	}
}

IfNotExist, bin/twitterLink.txt
{
	FileAppend,,bin/twitterLink.txt
}
FileRead, twitchlink, bin/twitterLink.txt

IfExist, bin/formerMsg.txt
{
	FileRead, formerMsg, bin/formerMsg.txt
	FileDelete, bin/formerMsg.txt
}


Gui, 1: Font, Arial s13.4 w1000 q5 c1da1f2
Gui, 1: Add, Text, x15 y10, Twitter Nachricht:
Gui, 1: Font, Arial s13 norm c14171a
Gui, 1: Add, Edit, -WantReturn Limit280 R6 vmessageTwitter x15 y+5 w320, %formerMsg%

Gui, 1: Font, Arial s13.4 w1000 q5 c1da1f2
Gui, 1: Add, Text, x15, Livestream Link:
Gui, 1: Font, Arial s13 norm c14171a
Gui, 1: Add, Edit, x15 y+5 w320 vtwitchlink, %twitchlink%
Gui, 1: Font, s11 norm c1da1f2
Gui, 1: Add, Button, x14 y+5 w180 h20 gChangeLink, Link änderung übernehmen

Gui, 1: Font, s13 norm c1da1f2
Gui, 1: Add, Button, default x25 y+20 w300 h40 gTwitterPosten, Twittern [Enter]
Gui, 1: Add, Button, x25 y+15 w148 h30  gJumpLogin, Einstellungen
Gui, 1: Add, Button, x50 x+4 y+-30 w148 h30 gExit_Button, Abbrechen [Esc]

Gui, 1: +AlwaysOnTop
Gui, 1: Show, h380 , Twitter Live
Gui, 1: Color, e1e8ed
return

Login:   
Gui, 2: Font, s15 norm
Gui, 2: Add, Text, x70 y10, Twitter Login
Gui, 2: Font, s13 norm
Gui, 2: Add, Text, x30 y+20, E-Mail oder Username
Gui, 2: Add, Edit, x30 y+5 w190 vemailT, %twitteremail%
Gui, 2: Add, Text, x30 y+15, Password
Gui, 2: Add, Edit, Password x30 y+5 w190 vpwT, %twitterpw%
Gui, 2: Add, Text, x30 y+15, Standart Link
Gui, 2: Add, Edit, x30 y+5 w190 vlinkT, %twitchlink%
Gui, 2: Add, Button, default x30 y+20 w190 h40 gSubmit_Login, Annehmen [Enter]

Gui, 2: +AlwaysOnTop
Gui, 2: show, w250 h330, Einstellungen
return
   
LoginNew:   
Gui, 3: Font, s15 norm
Gui, 3: Add, Text, x70 y10, Twitter Login
Gui, 3: Font, s13 norm
Gui, 3: Add, Text, x30 y+20, E-Mail oder Username
Gui, 3: Add, Edit, x30 y+5 w190 vemailT, %twitteremail%
Gui, 3: Add, Text, x30 y+15, Password
Gui, 3: Add, Edit, Password x30 y+5 w190 vpwT, %twitterpw%
Gui, 3: Add, Button, Default x30 y+20 w190 h30 gCompile, Login Daten Ändern

Gui, 3: +AlwaysOnTop
Gui, 3: show, w250 h255, Einstellungen
return

ChangeLink:
Gui, 1: Submit, NoHide
FileDelete, bin/twitterLink.txt
FileAppend, %twitchlink%, bin/twitterLink.txt
FileRead, twitchlink, bin/twitterLink.txt
GuiControl,, twitchlink, %twitchlink%
return
   
Compile:
Gui, 3: Submit
FileDelete, bin/twitterTemp.ahk
FileAppend, twitteremail = %emailT%`ntwitterpw = %pwT%, bin/twitterTemp.ahk, UTF-8-RAW
Run, bin\twitter_compiler.ahk %ScriptName%
ExitApp
return
   
2GuiClose:
ExitApp
return

3GuiClose:
Gui, 3: Destroy
return

GuiClose:
ExitApp
return

Submit_Login:
Gui, 2: Submit
FileDelete,bin/twitterTemp.ahk
FileAppend, twitteremail = %emailT%`ntwitterpw = %pwT%, bin/twitterTemp.ahk, UTF-8-RAW
FileDelete,bin/twitterLink.txt
FileAppend,%linkT%, bin/twitterLink.txt
Run, bin\twitter_compiler.ahk %ScriptName%
ExitApp
return
   
JumpLogin:
goto, LoginNew
return

#if WinActive("Twitter Live")
{
	^BS::
	send, ^+{left}{delete}
	return
	
	+Enter::
	send, ^{enter}
	return
	
	ESC::
	ExitApp
	return
}
return

goGui1:
Gui, 1: Show
return

Exit_Button:
ExitApp


;---------------- Twitter Stuff ---------------;
TwitterPosten:
Gui, 1: Submit
Gui, 1: Destroy

livePost = 
(
%messageTwitter%
%twitchlink%
)

if StrLen(livePost) > 280
{
	charOver = % StrLen(livePost) - 280
	msgbox, Fehler!`n%charOver% Zeichen zu viel.
	FileAppend, %messageTwitter%, bin/formerMsg.txt, UTF-8-RAW
	Reload 
}

;msgbox, % StrLen(livePost)

ie := WBGet()
ie := ComObjCreate("InternetExplorer.Application")
ie.Visible := false
ie.Navigate("https://twitter.com/intent/tweet?via")

while ie.busy or ie.ReadyState != 4
		Sleep 100
		
ie.document.GetElementsByName("session[username_or_email]")[0].Value := twitteremail
ie.document.GetElementsByName("session[password]")[0].Value := twitterpw
ie.document.GetElementsByName("remember_me")[0].checked :=0
ie.document.getElementById("status").Value := livePost
ie.document.getElementsByClassName("button selected submit")[0].click()
while ie.busy or ie.ReadyState != 4
		Sleep 100
		
WinClose, ahk_class IEFrame ahk_exe iexplore.exe
Process, close, iexplore.exe
Process, close, ielowutil.exe
msgBox, Gesendet
ExitApp

;************Pointer to Open IE Window******************
WBGet(WinTitle="ahk_class IEFrame", Svr#=1) {               ;// based on ComObjQuery docs
   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
        , IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
;//     , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
 
   if (ErrorLevel != "FAIL") {
      lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
      if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
         DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
         return ComObj(9,ComObjQuery(pdoc,IID,IID),1), ObjRelease(pdoc)
      }
   }
}