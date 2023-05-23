@ECHO off
cls

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

        pause
    
        EXIT /B 1
    )

@REM Check IF Chocolatey is installed...

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
        ECHO;
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

    IF '%choice%'=='1'  GOTO txt 
    IF '%choice%'=='2'  GOTO cli
    ECHO "%choice%" is not a valid option.. TRY AGAIN!!
    ECHO;
    ECHO;  
    GOTO again


@REM Read software package names from the input file and execute installation
    :txt
    set /p inputFile=Enter the full file location (C:\Dir\Name\filename.txt):
    
    for /f "usebackq delims=" %%A in ("%inputFile%") do (
        ECHO Installing %%A...
        choco install %%A -y
        ECHO;
        IF %ERRORLEVEL% EQU 0 (
            ECHO %%A Installation Failed!!
            ECHO Please recheck the package name!
            ECHO;
        ) ELSE (
            ECHO %%A Installation Completed Successfully.
            ECHO;
        )
    )


@REM Split the software package names and execute installation
    :cli
    setlocal enabledelayedexpansion

    set /p softwareNames=Enter the software package names (separated by spaces): 

    FOR %%A in (%softwareNames%) do (
        ECHO Installing %%A...
        choco install %%A -y
        IF !ERRORLEVEL! EQU 0 (
            ECHO %%A Installation Failed!!
            ECHO Please recheck the package name!
            ECHO;
        ) ELSE (
            ECHO %%A Installation Completed Successfully.
            ECHO;
        )
    )
    endlocal
 

@REM Updating && Upgrading
    ECHO Updating && Upgrading Pkgs...
    ECHO;
    ECHO choco outdated | choco upgrade all -y

pause
