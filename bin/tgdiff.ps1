# Opens the TortoiseGit diff tool with the specified paths.
param(
    [string]$baseFile,
    [string]$compareFile
)

function Get-FullPath
{
    $fp=Get-Item $args[0]
    if ($fp.GetType().IsArray)
    {
        return $fp[0]
    }
    else
    {
        return $fp
    }
}

$baseFile=Get-FullPath $baseFile
if (![string]::IsNullOrEmpty($compareFile))
{
    $compareFile=Get-FullPath $compareFile
    &"C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:diff /path:`"$baseFile`" /path2:`"$compareFile`"
}
else
{
    &"C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:diff /path:`"$baseFile`"
}
