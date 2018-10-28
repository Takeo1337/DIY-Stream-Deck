Set WshShell = CreateObject("WScript.Shell" )
WshShell.Run "intercept.exe /apply", 0
Set WshShell = Nothing