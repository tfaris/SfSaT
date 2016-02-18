@echo off
REM Produces a graph of a git repos branches.
REM Requires Graphviz2.38 installed at the path below.
REM https://github.com/esc/git-big-picture
REM Author: ta.faris@gmail.com 07.06.2015
@setlocal
SET CURDIR=%CD%
IF "%1" == "" (
    SET GBPREPO=%CD%
) ELSE (
    SET GBPREPO=%1
)
SET PATH=%PATH%;C:\Program Files (x86)\Graphviz2.38\bin;
PUSHD %CD%
CD "c:\src\00 - 3rd Party Src\git-big-picture"
SET output=%CURDIR%\gbp-%RANDOM%.png
python git-big-picture -o "%output%" -f png "%GBPREPO%"
CALL "%output%"
PAUSE
RM "%output%"
POPD
@endlocal