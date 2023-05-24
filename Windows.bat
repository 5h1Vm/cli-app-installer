@ECHO off
    cls
    :Start

@REM Check for Admin
    NET SESSION >nul 2>&1
    IF %ERRORLEVEL% EQU 0 (
        ECHO;
    ) ELSE (
        ECHO;--------------------------------------------------------------
        ECHO  ERROR: THIS INSTANCE DOES NOT HAVE ADMINISTRATOR PRIVILEGES.
        ECHO;--------------------------------------------------------------
        ECHO;
        ECHO;You don't have Admin Privileges!
        ECHO;
        ECHO;You need to restart this script with Admin Privileges by right-clicking and selecting "Run As Administrator"!!
        ECHO;

        @GOTO END
    )

@REM Choice to use Chocolatey or Winget
    ECHO Choose between Winget and Chocolatey
    ECHO Winget for MS Store Applications and Chocolatey as it has largest Registry basically everything else... 
    ECHO;
    :re

    ECHO 1. for Using Winget
    ECHO 2. for Using Chocolatey

    set /p option=Enter your choice: 

    IF '%option%'=='1'  GOTO Winget
    IF '%option%'=='2'  GOTO Chocolatey
    ECHO "%option%" is not a valid option.. TRY AGAIN!!
    ECHO;
    GOTO re



:Winget
@REM Check if Winget is installed
    ECHO Checking Winget...
    ECHO;
    
    winget -v >nul 2>&1
    
    IF %ERRORLEVEL% NEQ 0 (
        ECHO Chocolatey is not installed. 
        ECHO Installing...
        ECHO;
        curl.exe -o AppInstaller.exe -L https://aka.ms/winappdeploy/AppInstaller
        .\AppInstaller.exe
        del AppInstaller.exe
        ECHO Winget installation completed.
        ECHO;
    ) ELSE (
        ECHO Winget is already installed.
        ECHO;
    )

@REM Choice to use Txt file or Type

    ECHO Choose between a txt file full of apps or manually typing apps in here...

    :go

    ECHO 1. for Using a Txt file
    ECHO 2. for using the CLI

    set /p choose=Enter your choice: 

    IF '%choose%'=='1'  GOTO wtxt 
    IF '%choose%'=='2'  GOTO wcli
    ECHO "%choose%" is not a valid option.. TRY AGAIN!!
    ECHO;
    GOTO go

@REM Read application names from the input file and execute installation
    :wtxt
    set /p File=Enter the full file location (C:\Dir\Name\filename.txt):
    
    for /f "usebackq delims=" %%A in ("%File%") do (
        ECHO Installing %%A...
         winget install -e --id=%%A
        ECHO;
        IF %ERRORLEVEL% EQU 0 (
            ECHO %%A Installation Failed!!
            ECHO Please recheck the app name!
            ECHO;
            @GOTO END
        ) ELSE (
            ECHO %%A Installation Completed Successfully.
            ECHO;
            @GOTO wupnug
        )
    )


@REM Split the application names and execute installation
    :wcli
    setlocal enabledelayedexpansion

    set /p appNames=Enter the software package names (separated by spaces): 

    FOR %%A in (%appNames%) do (
        ECHO Installing %%A...
         winget install -e --id=%%A
        IF !ERRORLEVEL! EQU 0 (
            ECHO %%A Installation Failed!!
            ECHO Please recheck the app name!
            ECHO;
            @GOTO END
        ) ELSE (
            ECHO %%A Installation Completed Successfully.
            ECHO;
            @GOTO wupnug
        )
    )
    endlocal
 

@REM Updating && Upgrading
    :wupnug
    ECHO Updating && Upgrading Applications...
    ECHO;
    ECHO winget upgrade --all
    ECHO;
    ECHO winget upgrade --all --accept-source=winget
    @GOTO END

:Chocolatey
@REM Check if Chocolatey is installed...

    ECHO Checking Chocolatey...
    ECHO;
    
    choco -v >nul 2>&1
    
    IF %ERRORLEVEL% NEQ 0 (
        ECHO Chocolatey is not installed. 
        ECHO Installing...
        ECHO;
        @powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
        choco feature enable -n=allowGlobalConfirmation
        ECHO Chocolatey installation completed.
        ECHO:
    ) ELSE (
        ECHO Chocolatey is already installed.
        ECHO;
    )

@REM Choice to use Txt file or Type

    ECHO Choose between a txt file full of pkgs or manually typing pkgs in here...

    :again

    ECHO 1. for Using a Txt file
    ECHO 2. for using the CLI

    set /p choice=Enter your choice: 

    IF '%choice%'=='1'  GOTO ctxt 
    IF '%choice%'=='2'  GOTO ccli
    ECHO "%choice%" is not a valid option.. TRY AGAIN!!
    ECHO;
    GOTO again


@REM Read package names from the input file and execute installation
    :ctxt
    set /p inputFile=Enter the full file location (C:\Dir\Name\filename.txt):
    
    for /f "usebackq delims=" %%A in ("%inputFile%") do (
        ECHO Installing %%A...
        choco install %%A -y
        ECHO;
        IF %ERRORLEVEL% EQU 0 (
            ECHO %%A Installation Failed!!
            ECHO Please recheck the package name!
            ECHO;
            @GOTO END
        ) ELSE (
            ECHO %%A Installation Completed Successfully.
            ECHO;
            @GOTO cupnug
        )
    )


@REM Split the package names and execute installation
    :ccli
    setlocal enabledelayedexpansion

    set /p softwareNames=Enter the software package names (separated by spaces): 

    FOR %%A in (%softwareNames%) do (
        ECHO Installing %%A...
        choco install %%A -y
        IF !ERRORLEVEL! EQU 0 (
            ECHO %%A Installation Failed!!
            ECHO Please recheck the package name!
            ECHO;
            @GOTO END
        ) ELSE (
            ECHO %%A Installation Completed Successfully.
            ECHO;
            @GOTO cupnug
        )
    )
    endlocal
 

@REM Updating && Upgrading
    cupnug
    ECHO Updating && Upgrading Pkgs...
    ECHO;
    ECHO choco outdated | choco upgrade all -y
    @GOTO END

:END
    pause
