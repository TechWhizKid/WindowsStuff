@echo off
title %~n0

if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto :UACPrompt
) else (
    goto :gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

    if not exist "%appdata%\%~n0\backup\hosts" (
        mkdir "%appdata%\%~n0\backup\"
        cls
        echo. =========================================
        echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
        echo. =========================================
        echo.
        echo. WARNING: DO NOT RENAME THE FILE.
        echo.
        echo. Keep the filename "%~nx0" unchanged to ensure functionality.
        echo. Renaming this file will disable the ability to unblock links.
        echo.
        echo. Press any key to proceed...
        echo. Or press `CTRL + C` to exit...
        pause >nul
        copy "C:\Windows\System32\drivers\etc\hosts" "%appdata%\%~n0\backup\"
    )
    copy "C:\Windows\System32\drivers\etc\hosts" "%appdata%\%~n0\"
    cls
    echo. =========================================
    echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
    echo. =========================================
    echo.
    echo. [1] Block Link
    echo. [2] Unblock Link
    echo. [3] Restore Defaults
    echo.
    choice /c:123 /m "~Select "
    if errorlevel == 3 goto :UnblockAll
    if errorlevel == 2 goto :UnblockLink
    if errorlevel == 1 goto :BlockLink

:BlockLink
    cls
    echo. =========================================
    echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
    echo. =========================================
    echo.
    echo. [1] Use Block List File
    echo. [2] Block Single Link
    echo.
    choice /c:12 /m "~Select "
    if errorlevel == 2 goto :BlockSingleLink
    if errorlevel == 1 goto :UseBlockListFile
    goto :BlockLink

    :UseBlockListFile
        cls
        echo. =========================================
        echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
        echo. =========================================
        echo.
        echo. Example - D:\Documents\BlockList.txt
        echo.
        set /p "ListFile=~File path: "
        if not exist "%ListFile%" (
            echo.
            echo. Sorry, The File was not found.
            echo. Press any key to continue...
            pause >nul
            goto :UseBlockListFile
        ) else (
            set "UsedLinkFile=1"
            for /f "delims=" %%L in ( %ListFile% ) do (
                echo 127.0.0.1 %%L>>"%appdata%\%~n0\hosts"
                echo %%L>>"%appdata%\%~n0\BlockList"
                set "DirectLink=%%L"
            )
        )
        goto :replacer

    :BlockSingleLink
        cls
        echo. =========================================
        echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
        echo. =========================================
        echo.
        echo. Example - www.facebook.com
        echo.
        set /p "DirectLink=~Domain Link: "
        echo 127.0.0.1 %DirectLink%>>"%appdata%\%~n0\hosts"
        echo. %DirectLink%>>"%appdata%\%~n0\BlockList"
        set "UsedLinkFile=0"
        goto :replacer

    :replacer
        copy /y "%appdata%\%~n0\hosts" "C:\Windows\System32\drivers\etc" >nul

    :success
        echo.
        >nul find "%DirectLink%" C:\Windows\System32\drivers\etc\hosts && (
            echo. Successfully replaced hosts file.
            if "%UsedLinkFile%" == "1" (
                for /f "delims=" %%L in ( %ListFile% ) do echo. Blocked: %%L
            ) else (
                echo. Blocked: %DirectLink%
            )
            echo. Press any key to continue...
            pause >nul
        ) || (
            echo. Couldn't replace hosts file...
            echo. Try running %~nx0 from a different directory.
            echo. Press any key to continue...
            pause >nul
        )
        goto :gotAdmin

:UnblockLink
    cls
    echo. =========================================
    echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
    echo. =========================================
    echo.
    echo. [1] Use Unblock List File
    echo. [2] Unblock Single Link
    echo.
    choice /c:12 /m "~Select "
    if errorlevel == 2 goto :UnBlockSingleLink
    if errorlevel == 1 goto :UseUnBlockListFile
    goto :UnblockLink

    :UseUnBlockListFile
        cls
        echo. =========================================
        echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
        echo. =========================================
        echo.
        echo. Example - D:\Documents\UnBlockList.txt
        echo.
        set /p "ListFile=~File path: "
        if not exist "%ListFile%" (
            echo.
            echo. Sorry, The File was not found.
            echo. Press any key to continue...
            pause >nul
            goto :UseUnBlockListFile
        ) else (
            set "UsedLinkFile=1"
            for /f "delims=" %%L in ( %ListFile% ) do (
                findstr /v "%%L" "%appdata%\%~n0\hosts">"%appdata%\%~n0\hosts_1"
                findstr /v "%%L" "%appdata%\%~n0\BlockList">"%appdata%\%~n0\BlockList_1"
                del "%appdata%\%~n0\hosts" && ren "%appdata%\%~n0\hosts_1" "hosts"
                del "%appdata%\%~n0\BlockList" && ren "%appdata%\%~n0\BlockList_1" "BlockList"
                set "DirectLink=%%L"
            )
        )
        goto :replacer_rm

        :UnBlockSingleLink
            cls
            echo. =========================================
            echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
            echo. =========================================
            echo.
            if not exist "%appdata%\%~n0\BlockList" (
                echo. Sorry, The BlockList File was not found.
                echo. Please Select "Restore Defaults" And Block Links Again.
                echo. Press any key to continue...
                pause >nul
                goto :gotAdmin
            ) else (
                set "UsedLinkFile=0"
                echo.
                echo. All blocked links are:
                echo.
                type "%appdata%\%~n0\BlockList"
                echo.
                set /p "DirectLink=~Domain Link: "
                findstr /v "%DirectLink%" "%appdata%\%~n0\hosts">"%appdata%\%~n0\hosts_1"
                findstr /v "%DirectLink%" "%appdata%\%~n0\BlockList">"%appdata%\%~n0\BlockList_1"
                del "%appdata%\%~n0\hosts" && ren "%appdata%\%~n0\hosts_1" "hosts"
                del "%appdata%\%~n0\BlockList" && ren "%appdata%\%~n0\BlockList_1" "BlockList"
            )
            goto :replacer_rm

        :replacer_rm
            copy /y "%appdata%\%~n0\hosts" "C:\Windows\System32\drivers\etc" >nul

        :success_rm
            echo.
            >nul find "%DirectLink%" C:\Windows\System32\drivers\etc\hosts && (
                echo. Couldn't replace hosts file...
                echo. Try running %~nx0 from a different directory.
                echo. Press any key to continue...
                pause >nul
            ) || (
                echo. Successfully replaced hosts file.
                if "%UsedLinkFile%" == "1" (
                    for /f "delims=" %%L in ( %ListFile% ) do echo. Unblocked: %%L
                ) else (
                    echo. Unblocked: %DirectLink%
                )
                echo. Press any key to continue...
                pause >nul
            )
            goto :gotAdmin

:UnblockAll
    cls
    copy /y "%appdata%\%~n0\backup\hosts" "C:\Windows\System32\drivers\etc" >nul
    certutil -hashfile "%appdata%\%~n0\backup\hosts" md5 | findstr /v :>"%appdata%\%~n0\backup\md5_hash_1"
    certutil -hashfile "C:\Windows\System32\drivers\etc\hosts" md5 | findstr /v :>"%appdata%\%~n0\backup\md5_hash_2"
    for /f "delims=" %%p in ( "%appdata%\%~n0\backup\md5_hash_1" ) do set "md5_hash_1=%%p" >nul
    for /f "delims=" %%p in ( "%appdata%\%~n0\backup\md5_hash_2" ) do set "md5_hash_2=%%p" >nul
    if "%md5_hash_1%" == "%md5_hash_2%" (
        cls
        echo. =========================================
        echo. ^|       ^>^>^> Block from hosts ^<^<^<        ^|
        echo. =========================================
        echo.
        echo. Successfully replaced hosts file.
        echo. Press any key to continue...
        pause >nul
        del "%appdata%\%~n0\hosts" && del "%appdata%\%~n0\BlockList"
    )
    goto :gotAdmin
goto :eof
