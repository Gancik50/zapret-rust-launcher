@echo off
chcp 866 >nul
setlocal enabledelayedexpansion

set "REPO=Flowseal/zapret-discord-youtube"
set "ZAPRET_DIR=%~dp0zapret"
set "VERSION_FILE=%~dp0version.txt"
set "CHOICE_FILE=%~dp0choice.txt"

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title Zapret Rust Launcher
mode con: cols=62 lines=44
color 0B

:menu
cls
set "CURRENT_GEN="
set "SAVED_CHOICE=0"
if exist "%CHOICE_FILE%" set /p SAVED_CHOICE=<"%CHOICE_FILE%"
set "HAS_ZAPRET=0"
if exist "%ZAPRET_DIR%" set "HAS_ZAPRET=1"

set "GEN_COUNT=0"
for %%f in ("%ZAPRET_DIR%\general*.bat") do (
    set /a GEN_COUNT+=1
    if !GEN_COUNT!==!SAVED_CHOICE! set "CURRENT_GEN=%%~nxf"
)

if "!HAS_ZAPRET!"=="0" (
    set "SAVED_CHOICE=0"
    set "CURRENT_GEN="
)

set "L1=  [1]  �������� �����"
if defined CURRENT_GEN set "L1=  [1]  �������� [!CURRENT_GEN!]"
set "L1= !L1!                                                 "
set "L1=!L1:~0,49!"

set "L4=  [4]  �������� �����"
if "!HAS_ZAPRET!"=="0" set "L4=  [4]  ��⠭����� �����"
set "L4= !L4!                                                 "
set "L4=!L4:~0,49!"

cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * [Z A P R E T]   R U S T                         *
echo.    *                                                 *
echo.    ***************************************************
echo.    *                                                 *
echo.    *!L1!*
echo.    *                                                 *
echo.    *   [2]  ����� ���䨣����                     *
echo.    *                                                 *
echo.    *   [3]  ����ந�� [zapret]                        *
echo.    *                                                 *
echo.    *!L4!*
echo.    *                                                 *
echo.    *   [5]  ���ଠ��                               *
echo.    *                                                 *
echo.    ***************************************************
echo.    *                                                 *
echo.    *   [0]  ���                                    *
echo.    *                                                 *
echo.    ***************************************************
echo.
echo    ---------------------------------------------------
set /p "MENU_CHOICE=    ^> "
echo    ---------------------------------------------------
echo.

if "%MENU_CHOICE%"=="1" goto :run
if "%MENU_CHOICE%"=="2" goto :choose
if "%MENU_CHOICE%"=="3" goto :settings
if "%MENU_CHOICE%"=="4" goto :update
if "%MENU_CHOICE%"=="5" goto :info
if "%MENU_CHOICE%"=="0" goto :exit
echo    ---------------------------------------------------
echo.    [!] Nevernyy vybor
timeout /t 2 >nul
goto :menu
:run
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * ������ ������� ��� RUST                         *
echo.    *                                                 *
echo.    ***************************************************
echo.
echo.    ��⠭���� WinDivert...
echo.
sc stop windivert
sc stop windivert
sc stop windivert
echo.
echo.    �������� WinDivert...
echo.
sc delete windivert
sc delete windivert
sc delete windivert
echo.
echo.    ����㧪� ���䨣��権...
echo.
call :load_files

set "SAVED_CHOICE=0"
if exist "%CHOICE_FILE%" set /p SAVED_CHOICE=<"%CHOICE_FILE%"

set "VALID_CHOICE=0"
if !SAVED_CHOICE! gtr 0 if !SAVED_CHOICE! leq !COUNT! set "VALID_CHOICE=1"

if !VALID_CHOICE!==0 (
    echo.
    echo.    [!] ���砫� �롥�� ���䨣����
    echo.
    echo    ---------------------------------------------------
    set /p "NEW_CHOICE=    ^> "
    echo    ---------------------------------------------------
    set "VALID_CHOICE=0"
    if !NEW_CHOICE! gtr 0 if !NEW_CHOICE! leq !COUNT! set "VALID_CHOICE=1"
    if !VALID_CHOICE!==0 (
        echo.
        echo.    [!] ������ �롮�!
        pause
        goto :menu
    )
    echo !NEW_CHOICE!>"%CHOICE_FILE%"
    set "SAVED_CHOICE=!NEW_CHOICE!"
)

set "SELECTED=!FILE_%SAVED_CHOICE%!"
echo.
echo.    �����: !SELECTED!
echo.
echo.    ***************************************************
echo.
call "!SELECTED!"
exit

:choose
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * ����� ������������ �������                      *
echo.    *                                                 *
echo.    ***************************************************
echo.
echo.    ��⠭���� WinDivert...
sc stop windivert >nul 2>&1
sc stop windivert >nul 2>&1
sc stop windivert >nul 2>&1
sc delete windivert >nul 2>&1
sc delete windivert >nul 2>&1
sc delete windivert >nul 2>&1
echo.
call :load_files

if !COUNT!==0 (
    echo.
    echo.    [!] ���䨣��樨 �� �������!
    echo.
    pause
    goto :menu
)

echo.    ***************************************************
echo.

set "SAVED_CHOICE=0"
if exist "%CHOICE_FILE%" set /p SAVED_CHOICE=<"%CHOICE_FILE%"
if !SAVED_CHOICE! gtr 0 if !SAVED_CHOICE! leq !COUNT! (
    set "SELECTED=!FILE_%SAVED_CHOICE%!"
    echo.    ����騩: !SELECTED!
    echo.
)
echo    ---------------------------------------------------
set /p "NEW_CHOICE=    ^> "
echo    ---------------------------------------------------

set "VALID_CHOICE=0"
if !NEW_CHOICE! gtr 0 if !NEW_CHOICE! leq !COUNT! set "VALID_CHOICE=1"

if !VALID_CHOICE!==0 (
    echo.
    echo.    [!] ������ �롮�!
    echo.
    pause
    goto :menu
)

set "SELECTED=!FILE_%NEW_CHOICE%!"
echo !NEW_CHOICE!>"%CHOICE_FILE%"

echo.
echo.    ���࠭���: !SELECTED!
echo.
echo.    ***************************************************
echo.
pause
goto :menu

:update
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * �������� �������                                *
echo.    *                                                 *
echo.    ***************************************************
echo.
call :check_update
echo.
echo.    ***************************************************
echo.

if not exist "%ZAPRET_DIR%" (
    echo.
    echo.    [!] �訡�� ��⠭����!
    pause
    goto :menu
)

call :load_files

if !COUNT!==0 (
    echo.
    echo.    [!] ���䨣��樨 �� �������!
    pause
    goto :menu
)

echo.
echo.    ***************************************************
echo.
echo.    �롥�� ���䨣���� �� 㬮�砭��:
echo.
echo    ---------------------------------------------------
set /p "NEW_CHOICE=    ^> "
echo    ---------------------------------------------------

set "VALID_CHOICE=0"
if !NEW_CHOICE! gtr 0 if !NEW_CHOICE! leq !COUNT! set "VALID_CHOICE=1"

if !VALID_CHOICE!==0 (
    echo.
    echo.    [!] ������ �롮�!
    pause
    goto :menu
)

echo !NEW_CHOICE!>"%CHOICE_FILE%"
set "SELECTED=!FILE_%NEW_CHOICE%!"
echo.
echo.    ���࠭���: !SELECTED!
echo.
echo.    ***************************************************
echo.
pause
goto :menu

:settings
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * ��������� [zapret]                              *
echo.    *                                                 *
echo.    ***************************************************
echo.
if not exist "%ZAPRET_DIR%\service.bat" (
    echo.
    echo.    [!] service.bat �� ������!
    echo.
    pause
    goto :menu
)
echo.    ����� service.bat...
echo.
echo.    ***************************************************
echo.
call "%ZAPRET_DIR%\service.bat"
echo.
echo.    ***************************************************
echo.
pause
goto :menu

:info
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * ����������                                      *
echo.    *                                                 *
echo.    ***************************************************
echo.
echo.
echo.    Zapret Rust Launcher v1.1
echo.
echo.
echo.    ***************************************************
echo.
echo.    �����:
echo.
echo.
echo.    ����᪠�� ��। ����⨥� ����
echo.
echo.
echo.    ***************************************************
echo.
echo.    �ணࠬ�� ���:
echo.
echo.
echo.    ����� Easy Anti-Cheat (EAC) � Rust �������� � ����뢠��
echo.    ����� winws.exe (Zapret), ⠪ ��� ��⠥� ��� ��⮤
echo.    ���墠� ��䨪� (�ࠩ��� WinDivert) �梨������� ��� �⮬.
echo.
echo.
echo.    � �� �ணࠬ�� �������� �� ��室���.
echo.
echo.
echo.    ***************************************************
echo.
echo.    ����: Gancik
echo.
echo.    ***************************************************
echo.
echo.    �ॡ������:
echo.
echo.
echo.      - �ࠢ� �����������
echo.      - ���୥� ��� ����������
echo.
echo.
echo.    ***************************************************
echo.
echo.    ��室�� �஥��:
echo.    Flowseal/zapret-discord-youtube
echo.    https://github.com/Flowseal/zapret-discord-youtube
echo.
echo.
echo.    ***************************************************
echo.
pause
goto :menu

:exit
cls
echo.
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * �� ����� �����!                                *
echo.    *                                                 *
echo.    * ���筮� ���� � Rust!                             *
echo.    *                                                 *
echo.    ***************************************************
echo.
echo.
timeout /t 3 >nul
exit

:load_files
set "COUNT=0"
for %%f in ("%ZAPRET_DIR%\general*.bat") do (
    set /a COUNT+=1
    set "FILE_!COUNT!=%%f"
    echo.    [!COUNT!] %%~nxf
)
if !COUNT!==0 (
    for %%f in ("%ZAPRET_DIR%\*.bat") do (
        set /a COUNT+=1
        set "FILE_!COUNT!=%%f"
        echo.    [!COUNT!] %%~nxf
    )
)
goto :eof

:check_update
echo.    �஢�ઠ ����������...
echo.
set "NEW_VERSION="
for /f "delims=" %%i in ('powershell -Command "(Invoke-WebRequest -Uri 'https://api.github.com/repos/%REPO%/releases/latest' -UseBasicParsing).Content ^| ConvertFrom-Json ^| Select-Object -ExpandProperty tag_name"') do set "NEW_VERSION=%%i"
if "!NEW_VERSION!"=="" (
    echo.    [!] �� 㤠���� �஢���� ����������
    goto :eof
)
set "CURRENT_VERSION="
if exist "%VERSION_FILE%" set /p CURRENT_VERSION=<"%VERSION_FILE%"
if "!CURRENT_VERSION!"=="!NEW_VERSION!" (
    echo.    [OK] ���㠫쭠� ����� !NEW_VERSION!
    goto :eof
)
echo.    ����㯭� ����������: !NEW_VERSION!
echo.
echo.    ���稢����...
echo.
if exist "%ZAPRET_DIR%" rmdir /s /q "%ZAPRET_DIR%"
set "ZIP_FILE=%~dp0zapret.zip"
powershell -Command "$r=(Invoke-WebRequest -Uri 'https://api.github.com/repos/%REPO%/releases/latest' -UseBasicParsing).Content|ConvertFrom-Json;$a=$r.assets|Where-Object{$_.name -like '*.zip'}|Select-Object -First 1;if($a){Invoke-WebRequest -Uri $a.browser_download_url -OutFile '%ZIP_FILE%'}else{exit 1}"
if %errorlevel% neq 0 (
    echo.
    echo.    [!] �訡�� ᪠稢����!
    goto :eof
)
echo.    ��ᯠ�����...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%~dp0' -Force"
del "%ZIP_FILE%" 2>nul
for /d %%d in ("%~dp0zapret-discord-youtube*") do (
    if "%%d" neq "%ZAPRET_DIR%" rename "%%d" "zapret"
)
echo !NEW_VERSION!>"%VERSION_FILE%"
echo.
echo.    [OK] ��������� �� ���ᨨ !NEW_VERSION!
goto :eof