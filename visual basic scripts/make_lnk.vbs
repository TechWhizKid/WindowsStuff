' make_lnk targetfile.exe shortcut.lnk

If WScript.Arguments.Count <> 2 Then WScript.Quit 1
Set FSO = CreateObject("Scripting.FileSystemObject")
TargetPath = FSO.GetAbsolutePathName(WScript.Arguments(0))
WorkingDirectory = FSO.GetParentFolderName(TargetPath)
Set lnk = CreateObject("WScript.Shell").CreateShortcut(WScript.Arguments(1))
    lnk.TargetPath = TargetPath
    lnk.WorkingDirectory = WorkingDirectory
    lnk.Save
