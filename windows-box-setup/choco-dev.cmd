REM Development tools

REM Make sure you're running from an elevated cmd prompt
call install-choco.cmd

REM Tools
choco install VisualStudioCode -y
choco install git.install -y
choco install tortoisegit -y
choco install jdk8 -y
choco install python2 -y
choco install NuGet.CommandLine -y

REM IDE
choco install visualstudio2015community -y
choco install pycharm-community -y
REM choco install netbeans -y
