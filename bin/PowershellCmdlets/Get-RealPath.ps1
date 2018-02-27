function Get-RealPath {
    <#
    .SYNOPSIS
    Print the resolved absolute file name
    
    .PARAMETER CanonicalizeExisting
    All components of the path must exist

    .PARAMETER CanonicalizeMissing
    No path components need exist or be a directory

    .PARAMETER Physical
    Resolve symlinks as encountered (default)

    .PARAMETER NoSymlinks
    Don't expand symlinks

    .PARAMETER FILE
    The file path to resolve
    #>
    [CmdletBinding()]
    param(
        [Alias("e", "canonicalize-existing")]
        [switch]$CanonicalizeExisting,

        [Alias("m", "canonicalize-missing")]
        [switch]$CanonicalizeMissing,

        [Alias("P")]
        [bool]$Physical = $true,

        [Alias("s", "strip", "no-symlinks")]
        [switch]$NoSymlinks,
        
        [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true)]
        [string]$FILE
    )
    
    if ($CanonicalizeExisting){
        if (!(Test-Path -PathType Any $FILE)){
            throw "$FILE`: No such file or directory"
        }
    }

    if (!$CanonicalizeMissing){
        $tmpPath = $FILE
        do {
            $tmpPath = Split-Path -Parent $tmpPath
            if (!($tmpPath -eq "")){
                Write-Verbose "Testing path $tmpPath"
            }
        } 
        while (!($tmpPath -eq "") -and (Test-Path $tmpPath))

        if (!$tmpPath -eq ""){
            throw "$FILE`: No such file or directory"
        }
    }

    if ($NoSymlinks) {
        $Physical = $false
    }
    if ($Physical){
        $target = Get-Item $FILE -ErrorAction Ignore | Select-Object -ExpandProperty Target -ErrorAction Ignore
        if ($target -and $target.StartsWith("UNC\")){
            $target = "\\" + $target.Substring(4)
            $FILE = $target
        }
    }
    [System.IO.Path]::GetFullPath($FILE)
}