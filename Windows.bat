@echo off

REM Check for Admin

NET SESSION >nul 2>&1

IF %ERRORLEVEL% EQU 0 (
    echo;
) ELSE (
    echo;--------------------------------------------------------------
    echo  ERROR: THIS INSTANCE DOES NOT HAVE ADMINISTRATOR PRIVILEGES.
    echo;--------------------------------------------------------------
    echo;
    echo;You don't have Admin Privileges!
    echo;
    echo;You need to restart this script with Admin Privileges by right-clicking and selecting "Run As Administrator"!!
    echo;

    pause
   
    EXIT /B 1
)

REM Check if Chocolatey is installed...

echo Checking Chocolatey...
echo;

choco -v >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo Chocolatey is not installed. 
    echo Installing...
    echo;
    @powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
    choco feature enable -n=allowGlobalConfirmation
    echo Chocolatey installation completed.
    echo;
) else (
    echo Chocolatey is already installed.
    echo;
)

setlocal enabledelayedexpansion
set /p softwareNames=Enter the software package names (separated by spaces): 

REM Split the software package names and execute installation

FOR %%A in (%softwareNames%) do (
    echo Installing %%A...
    choco install %%A -y
    IF %ERRORLEVEL% EQU 0 (
        echo %%A installation Failed!!
        echo Please recheck the package-name!
    ) else (
    echo %%A Installation Completed Successfully.
    echo;
    )
)
    REM Updating && Upgrading
    echo choco outdated  | choco upgrade all -y

pause
