# Install it all! Overlap of packages between files is fine,
# chocolately won't install if the version already exists (unless forced).

# Make sure you're running from an elevated cmd prompt
.\install-choco.ps1

Get-ChildItems choco-*.ps1 | ForEach-Object {
	. $_
}
