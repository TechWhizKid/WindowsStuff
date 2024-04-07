' no_window run_this_file.bat

If WScript.Arguments.Count <> 1 Then WScript.Quit 1
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")
TargetFile = FSO.GetAbsolutePathName(WScript.Arguments(0))
WshShell.Run chr(34) & TargetFile & Chr(34), 0
Set WshShell = Nothing
