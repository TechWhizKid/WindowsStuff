@echo off

call :setWindowProperty
goto :main0

:setWindowProperty
    title Alternate Data Streams Creator
    mode con: cols=65 lines=18
    color 0B

goto :eof

:main0
    cls
    echo [32m*****************************************************************[0m
    echo [32m*           [36mWelcome to Alternate Data Stream Creator[0m            [32m*[0m
    echo [32m*   [36mHere You can Build ADS. First time using? get some help!![0m   [32m*[0m
    echo [32m*              [36mPlease choose an option from below[0m               [32m*[0m
    echo [32m*****************************************************************[0m
    echo [32m* [96m[1][0m [32mBuild alternate data stream                               *[0m
    echo [32m* [96m[2][0m [32mExpand alternate data stream                              *[0m
    echo [32m* [96m[3][0m [32mLog History of [1 and 2]                                  *[0m
    echo [32m* [96m[4][0m [32mGet some help                                             *[0m
    echo [32m*****************************************************************[96m

    choice /C 1234 /N /M "Enter your Choice  >>> "
        set "option=%ERRORLEVEL%"
        call :operation %option%
    goto :main

:main
    cls
    if "%messageCode%"=="welcome" (
        call :welcomeMesssage ) else if "%messageCode%"=="pathnotfounderror" (
        call :pathnotfounderror ) else if "%messageCode%"=="success" (
        call :success ) else if "%messageCode%"=="error" (
        call :error ) else (
        call :error
    )
    echo [32m* [96m[1][0m [32mBuild alternate data stream                               *[0m
    echo [32m* [96m[2][0m [32mExpand alternate data stream                              *[0m
    echo [32m* [96m[3][0m [32mLog History of [1 and 2]                                  *[0m
    echo [32m* [96m[4][0m [32mGet some help                                             *[0m
    echo [32m*****************************************************************[96m
    choice /C 1234 /N /M "Enter your Choice  >>> "
        set "option=%ERRORLEVEL%"
        call :operation %option%
    goto :main

:welcomeMesssage
    cls
    echo [32m*****************************************************************[0m
    echo [32m*           [36mWelcome to Alternate Data Stream Creator[0m            [32m*[0m
    echo [32m*   [36mHere You can Build ADS. First time using? get some help!![0m   [32m*[0m
    echo [32m*              [36mPlease choose an option from below[0m               [32m*[0m
    echo [32m*****************************************************************[0m
    goto :eof

:success
    cls
    echo [32m*****************************************************************[0m
    echo [32m*       [96mCongratulations...!![0m                                    [32m*[0m
    echo [32m*       [96mOperation Done Successfully..!![0m                         [32m*[0m
    echo [32m*       [96mPlease choose an option from below[0m                      [32m*[0m
    echo [32m*****************************************************************[0m
    goto :eof

:error
    cls
    echo [32m*****************************************************************[0m
    echo [32m*       [31mSorry...!![0m                                              [32m*[0m
    echo [32m*       [31mChoice is Incorrect..!![0m                                 [32m*[0m
    echo [32m*       [31mPlease choose an option from below[0m                      [32m*[0m
    echo [32m*****************************************************************[0m
    goto :eof

:pathnotfounderror
    cls
    echo [32m*****************************************************************[0m
    echo [32m*       [31mSorry...!![0m                                              [32m*[0m
    echo [32m*       [31mFile/Folder Does not Exists..!![0m                         [32m*[0m
    echo [32m*       [31mPlease choose an option from below[0m                      [32m*[0m
    echo [32m*****************************************************************[0m
    goto :eof

:operation
    if %~1 == 1 (
        call :BuildADS ) else if %~1 == 2 (
        call :ExpandADS ) else if %~1 == 3 (
        call :log ) else if %~1 == 4 (
        call :help ) else (
        set "messageCode=error"
    )
    goto :eof

:BuildADS
    cls
    set /p ADS="Enter name of data stream file to build ADS >>> "
    if %ADS%==esc goto :main0
    if %ADS%==%ADS% goto :BuildADS0
    goto :eof

    :BuildADS0
        set /p ADS0="Enter name of File to put the data stream into >>> "
        if exist "%ADS0%" (
            type "%ADS%" > "%ADS0%":"%ADS%"
            cd %setupPath%
            echo Operation: Build ADS    ^Date^&Time: %date% %time%    ADS: %ADS%    Build into: %ADS0% >> log.txt
            set "messageCode=success"
        ) else (
            set "messageCode=pathnotfounderror"
        )
        goto :eof

:ExpandADS
    cls
    set /p ExpandADS="Enter name of File to expand data from >>> "
    if %ExpandADS%==esc goto :main0
    if %ExpandADS%==%ExpandADS% goto :ExpandADS0
    goto :eof

    :ExpandADS0
        set /p ExpandADS0="Enter name of data stream file to expand ADS >>> "
        if %ExpandADS0%==esc goto :main0
        if %ExpandADS0%==%ExpandADS0% goto :ExpandADS00

        :ExpandADS00
            set /p ExpandADS00="Enter new name for data stream file >>> "
            if %ExpandADS00%==esc goto :main0
            if exist %ExpandADS00% (
            goto :next )
            
                :next
                expand "%ExpandADS%":"%ExpandADS0%" "%ExpandADS00%"
                goto :next0
            
                    :next0
                    if exist "%ExpandADS00%" (
                    cd %setupPath%
                    echo Operation: ExpandADS    ^Date^&Time: %date% %time%    ADS: %ExpandADS%    expanded from: %ExpandADS0% >> log.txt
                    set "messageCode=success"
                    ) else (
                        set "messageCode=pathnotfounderror"
                    )
                    goto :eof

:log
    cd %setupPath%
    if not exist "log.txt" (
        copy NUL "log.txt"
        if not exist "log.txt" (
            type NUL > "log.txt"
            cd. > "log.txt"
        )
    )
    start notepad "log.txt"
    goto :eof

:help
    set "messageCode=welcome"
    cls
    echo: & echo:
    echo [96m                    _/    _/            _/                     [0m
    echo [96m                   _/    _/    _/_/    _/  _/_/_/              [0m
    echo [96m                  _/_/_/_/  _/_/_/_/  _/  _/    _/             [0m
    echo [96m                 _/    _/  _/        _/  _/    _/              [0m
    echo [96m                _/    _/    _/_/_/  _/  _/_/_/                 [0m
    echo [96m                                       _/                      [0m
    echo [96m                                      _/                       [0m
    echo: & echo:
    echo [96m                        Loading help ...                          [0m
    timeout 2 /nobreak > nul
    goto :page1

:page1
    cls
    echo [31m^>^>^> Important Notes ^>^>^>[97m && echo:
    echo 1) This only works with NTFS file system so if you want to use it
    echo  on a USB Drive make sure it has NTFS file system. & echo:
    echo [32m[note: you can change USB drive's file system by formating it to
    echo  other file systems]
    echo:
    echo [97m2) You cannot share file with Alternate Data Streams through Mail
    echo  The file will be sent but the data stream will not be sent.[0m
    echo:
    echo [97m3) Must run the Alternate Data Streams Creator form the same
    echo  folder where all necessary files are. (such as file in which you
    echo  want to ADS to be added to and also the file you want as ADS)
    echo: & echo: & echo: [7m[97m
    choice /C pnm /N /M "Press 'n' for next page, 'p' for previous page and 'm' for menu"
    echo: [0m[32m
        set "move_to=%ERRORLEVEL%"
        if "%move_to%" == "1" (
            goto :main0
        ) else if "%move_to%" == "2" (
            goto :page2
        )
    goto :eof

:page2
    cls
    echo [4m[96m^>^>^> Help for "Build alternate data stream" ^<^<^<[0m & echo:
    echo [40;37mThis will create any type of ADS inside any type of file. & echo:
    echo 1) Firstly you have to input the name of file with its extension
    echo  that you want to copy inside other file then press "Enter"
    echo [32m [Note: Must mention file extension] [Example: 'file.txt']
    echo.[40;37m
    echo 2) Secondly you have to input the name of file in which you
    echo  want to copy the first file's data and the file will be copied.[0m
    echo: & echo: & echo: & echo: & echo: & echo: & echo: [7m[97m
    choice /C pnm /N /M "Press 'n' for next page, 'p' for previous page and 'm' for menu"
    echo: [0m[32m
        set "move_to=%ERRORLEVEL%"
        if "%move_to%" == "1" (
            goto :page1
        ) else if "%move_to%" == "2" (
            goto :page3
        )
    goto :eof

:page3
    cls
    echo [4m[96m^>^>^> Help for "Expand alternate data stream" ^<^<^<[0m & echo:
    echo [40;37mThis will extract any alternate data stream form any file type
    echo only if alternate data stream already exists in that file. & echo:
    echo 1) Firstly you will have to input the name of the file (with
    echo  extension) in which the alternate data stream exists. & echo:
    echo 2) Secondly you need to input the name of the alternate data
    echo  stream which file you want to extract out of the main file. & echo:
    echo 3) And lastly you need to input a new name for the file that
    echo  you want to extract then the file will be extracted with the
    echo  newly specified name.
    echo: & echo:
    echo: [7m[97m
    choice /C pnm /N /M "Press 'n' for next page, 'p' for previous page and 'm' for menu"
    echo: [0m[32m
        set "move_to=%ERRORLEVEL%"
        if "%move_to%" == "1" (
            goto :page2
        ) else if "%move_to%" == "2" (
            goto :page4
        )
    goto :eof

:page4
    cls
    echo [4m[96m^>^>^> Log History ^<^<^<[0m & echo:
    echo [40;37mThis will show you the history of previous tasks unless you have
    echo deleted the "log" file.
    echo: & echo: & echo: & echo: & echo: & echo: & echo: & echo: & echo: & echo: & echo:
    echo: & echo: [7m[97m
    choice /C pnm /N /M "Press 'n' for next page, 'p' for previous page and 'm' for menu"
    echo: [0m[32m
        set "move_to=%ERRORLEVEL%"
        if "%move_to%" == "1" (
            goto :page3
        ) else if "%move_to%" == "2" (
            goto :page5
        )
    goto :eof

:page5
    cls
    echo [4m[96m^>^>^> Extra information ^<^<^<[0m & echo:
    echo [40;37mYou can put multiple file inside one file. & echo:
    echo A file can only be copied in and out of other file which means
    echo onece you build ADS you will always have it inside that file but
    echo you can use nirsoft utility "alternatestreamview" to delete it or
    echo you can cut and paste that file into a FAT32 USB Drive and that
    echo will delete the alternate data stream.
    echo: & echo: & echo: & echo: & echo: & echo: & echo:
    echo: [7m[97m
    choice /C pnm /N /M "Press 'n' for next page, 'p' for previous page and 'm' for menu"
    echo: [0m[32m
        set "move_to=%ERRORLEVEL%"
        if "%move_to%" == "1" (
            goto :page4
        ) else if "%move_to%" == "2" (
            goto :page1
        )
    goto :eof
