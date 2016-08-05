REM Install it all! Overlap of packages between files is fine,
REM chocolately won't install if the version already exists (unless forced).

REM Make sure you're running from an elevated cmd prompt
call install-choco.cmd

call choco-me.cmd
call choco-tools.cmd
call choco-dev.cmd
