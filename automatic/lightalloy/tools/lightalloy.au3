#region --- Internal functions Au3Recorder Start ---
Func _Au3RecordSetup()
	Opt('WinWaitDelay',100)
	Opt('WinDetectHiddenText',1)
	Opt('MouseCoordMode',0)
EndFunc

Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc

_AU3RecordSetup()

#endregion --- Internal functions Au3Recorder End ---



Run($CmdLine[1])

# Deactivate 'open website', 'associate player with video files', and 'add desktop icon'
_WinWaitActivate("Light Alloy installer","Visit Light Alloy")
Send("{SPACE}{SHIFTDOWN}{TAB}{SHIFTUP}{SPACE}{SHIFTDOWN}{TAB}{SHIFTUP}{SPACE}{SHIFTDOWN}{TAB}{TAB}{SHIFTUP}{SPACE}{ENTER}")

# Choose to use internal codecs (recommended)
_WinWaitActivate("Basic options","What kind of codecs")
Send("{TAB}{TAB}{TAB}{ENTER}")

# Player auto-starts - shutdown
_WinWaitActivate("Light Alloy","")
Send("{ALTDOWN}{F4}{ALTUP}")

Exit
