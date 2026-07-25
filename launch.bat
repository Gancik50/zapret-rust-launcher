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

set "L1=  [1]  Запустить запрет"
if defined CURRENT_GEN set "L1=  [1]  Запустить [!CURRENT_GEN!]"
set "L1= !L1!                                                 "
set "L1=!L1:~0,49!"

set "L4=  [4]  Обновить запрет"
if "!HAS_ZAPRET!"=="0" set "L4=  [4]  Установить запрет"
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
echo.    *   [2]  Выбрать конфигурацию                     *
echo.    *                                                 *
echo.    *   [3]  Настроить [zapret]                        *
echo.    *                                                 *
echo.    *!L4!*
echo.    *                                                 *
echo.    *   [5]  Информация                               *
echo.    *                                                 *
echo.    ***************************************************
echo.    *                                                 *
echo.    *   [0]  Выйти                                    *
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
echo.    *   [!] Неверный выбор                            *
timeout /t 2 >nul
goto :menu

:run
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * ЗАПУСК ЗАПРЕТА ДЛЯ RUST                         *
echo.    *                                                 *
echo.    ***************************************************
echo.
call :stop_windivert
call :load_files

set "SAVED_CHOICE=0"
if exist "%CHOICE_FILE%" set /p SAVED_CHOICE=<"%CHOICE_FILE%"

set "VALID_CHOICE=0"
if !SAVED_CHOICE! gtr 0 if !SAVED_CHOICE! leq !COUNT! set "VALID_CHOICE=1"

if !VALID_CHOICE!==0 (
    echo.
    echo.    [!] Сначала выберите конфигурацию
    echo.
    echo    ---------------------------------------------------
    set /p "NEW_CHOICE=    ^> "
    echo    ---------------------------------------------------
    set "VALID_CHOICE=0"
    if !NEW_CHOICE! gtr 0 if !NEW_CHOICE! leq !COUNT! set "VALID_CHOICE=1"
    if !VALID_CHOICE!==0 (
        echo.
        echo.    [!] Неверный выбор!
        pause
        goto :menu
    )
    echo !NEW_CHOICE!>"%CHOICE_FILE%"
    set "SAVED_CHOICE=!NEW_CHOICE!"
)

set "SELECTED=!FILE_%SAVED_CHOICE%!"
echo.
echo.    Запуск: !SELECTED!
echo.
echo.    ***************************************************
echo.
call "!SELECTED!"
pause
goto :menu

:choose
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * ВЫБОР КОНФИГУРАЦИИ ЗАПРЕТА                      *
echo.    *                                                 *
echo.    ***************************************************
echo.
call :stop_windivert
call :load_files

if !COUNT!==0 (
    echo.
    echo.    [!] Конфигурации не найдены!
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
    echo.    Текущий: !SELECTED!
    echo.
)
echo    ---------------------------------------------------
set /p "NEW_CHOICE=    ^> "
echo    ---------------------------------------------------

set "VALID_CHOICE=0"
if !NEW_CHOICE! gtr 0 if !NEW_CHOICE! leq !COUNT! set "VALID_CHOICE=1"

if !VALID_CHOICE!==0 (
    echo.
    echo.    [!] Неверный выбор!
    echo.
    pause
    goto :menu
)

set "SELECTED=!FILE_%NEW_CHOICE%!"
echo !NEW_CHOICE!>"%CHOICE_FILE%"

echo.
echo.    Сохранено: !SELECTED!
echo.
echo.    ***************************************************
echo.
call "!SELECTED!"
pause
goto :menu

:update
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * ЗАГРУЗКА ЗАПРЕТА                                *
echo.    *                                                 *
echo.    ***************************************************
echo.
call :check_update
echo.
echo.    ***************************************************
echo.

if not exist "%ZAPRET_DIR%" (
    echo.
    echo.    [!] Ошибка установки!
    pause
    goto :menu
)

call :load_files

if !COUNT!==0 (
    echo.
    echo.    [!] Конфигурации не найдены!
    pause
    goto :menu
)

echo.
echo.    ***************************************************
echo.
echo.    Выберите конфигурацию по умолчанию:
echo.
echo    ---------------------------------------------------
set /p "NEW_CHOICE=    ^> "
echo    ---------------------------------------------------

set "VALID_CHOICE=0"
if !NEW_CHOICE! gtr 0 if !NEW_CHOICE! leq !COUNT! set "VALID_CHOICE=1"

if !VALID_CHOICE!==0 (
    echo.
    echo.    [!] Неверный выбор!
    pause
    goto :menu
)

echo !NEW_CHOICE!>"%CHOICE_FILE%"
set "SELECTED=!FILE_%NEW_CHOICE%!"
echo.
echo.    Сохранено: !SELECTED!
echo.
echo.    ***************************************************
echo.

echo.
echo.    ---------------------------------------------------
echo.    ВАЖНО: Теперь откройте [3] Настроить [zapret]
echo.    и выберите "Update IPSet List" для установки WireSock
echo.    ---------------------------------------------------
echo.
pause
goto :menu

:settings
cls
echo.
echo.    ***************************************************
echo.    *                                                 *
echo.    * НАСТРОЙКА [zapret]                              *
echo.    *                                                 *
echo.    ***************************************************
echo.
if not exist "%ZAPRET_DIR%\service.bat" (
    echo.
    echo.    [!] service.bat не найден!
    echo.
    pause
    goto :menu
)
echo.    Запуск service.bat...
echo.
echo.    ***************************************************
echo.
echo.    ---------------------------------------------------
echo.    Выберите "Update IPSet List" для установки WireSock
echo.    WireSock заменяет winws.exe и работает с EAC
echo.    ---------------------------------------------------
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
echo.    * ИНФОРМАЦИЯ                                      *
echo.    *                                                 *
echo.    ***************************************************
echo.
echo.
echo.    Zapret Rust Launcher v1.1
echo.
echo.
echo.    ***************************************************
echo.
echo.    ВАЖНО:
echo.
echo.
echo.    Запускать перед открытием игры.
echo.    После установки настройте WireSock через service.bat
echo.
echo.
echo.    ***************************************************
echo.
echo.    Программа для:
echo.
echo.
echo.    Античит Easy Anti-Cheat (EAC) в Rust блокирует и закрывает
echo.    процесс winws.exe (Zapret), так как считает его метод
echo.    перехвата трафика (драйвер WinDivert) уязвимостью или читом.
echo.
echo.
echo.    Решение: WireSock вместо WinDivert.
echo.    Откройте [3] Настроить и выберите "Update IPSet List"
echo.
echo.
echo.    ***************************************************
echo.
echo.    Автор: Gancik
echo.
echo.    ***************************************************
echo.
echo.    Требования:
echo.
echo.
echo.      - Права администратора
echo.      - Интернет для обновлений
echo.
echo.
echo.    ***************************************************
echo.
echo.    Исходный проект:
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
echo.    * До новых встреч!                                *
echo.    *                                                 *
echo.    * Удачной игры в Rust!                             *
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
echo.    Проверка обновлений...
echo.
set "NEW_VERSION="
for /f "delims=" %%i in ('powershell -Command "(Invoke-WebRequest -Uri 'https://api.github.com/repos/%REPO%/releases/latest' -UseBasicParsing).Content ^| ConvertFrom-Json ^| Select-Object -ExpandProperty tag_name"') do set "NEW_VERSION=%%i"
if "!NEW_VERSION!"=="" (
    echo.    [!] Не удалось проверить обновления
    goto :eof
)
set "CURRENT_VERSION="
if exist "%VERSION_FILE%" set /p CURRENT_VERSION=<"%VERSION_FILE%"
if "!CURRENT_VERSION!"=="!NEW_VERSION!" (
    echo.    [OK] Актуальная версия !NEW_VERSION!
    goto :eof
)
echo.    Доступно обновление: !NEW_VERSION!
echo.
echo.    Скачивание...
echo.
if exist "%ZAPRET_DIR%" rmdir /s /q "%ZAPRET_DIR%"
set "ZIP_FILE=%~dp0zapret.zip"
powershell -Command "$r=(Invoke-WebRequest -Uri 'https://api.github.com/repos/%REPO%/releases/latest' -UseBasicParsing).Content|ConvertFrom-Json;$a=$r.assets|Where-Object{$_.name -like '*.zip'}|Select-Object -First 1;if($a){Invoke-WebRequest -Uri $a.browser_download_url -OutFile '%ZIP_FILE%'}else{exit 1}"
if %errorlevel% neq 0 (
    echo.
    echo.    [!] Ошибка скачивания!
    goto :eof
)
echo.    Распаковка...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%~dp0' -Force"
del "%ZIP_FILE%" 2>nul
for /d %%d in ("%~dp0zapret-discord-youtube*") do (
    if "%%d" neq "%ZAPRET_DIR%" rename "%%d" "zapret"
)
echo !NEW_VERSION!>"%VERSION_FILE%"
echo.
echo.    [OK] Обновлено до версии !NEW_VERSION!
goto :eof

:stop_windivert
sc stop windivert >nul 2>&1
sc delete windivert >nul 2>&1
goto :eof