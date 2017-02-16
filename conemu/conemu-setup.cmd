@echo off

net session >nul 2>&1
set hasAdmin=%ERRORLEVEL%

if %hasAdmin% neq 0 (
    echo Setup script requires admin rights. Stopping...
    exit /b 1
) else (
    REM Create a symbolic link to our config file.
    set cfgPath="%CMDER_INSTALL_DIR%\vendor\conemu-maximus5\ConEmu.xml"
    if exist "%cfgPath" (
        del "%cfgPath%"
    )
    mkdir "%CMDER_INSTALL_DIR%\vendor\conemu-maximus5"
    mklink "%cfgPath%" "%~dp0\ConEmu.xml"

    REM Copy the background image to where the config file expects it to be.
    set wpDir=%USERPROFILE%\Pictures\Wallpapers
    if not exist "%wpDir%" ( mkdir "%wpDir%" )
    copy conemu-background.jpg "%wpDir%"\conemu-background.jpg
)
