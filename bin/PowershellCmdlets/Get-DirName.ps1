function Get-DirName{
    <#
    .SYNOPSIS
    Get the directory that contains the specified file object.
    
    .PARAMETER File
    The file or directory to get the containing directory of.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        $File
    )

    process {
        $fileObj = $File

        if ($fileObj -is [String]){
            if (Test-Path -Path $fileObj -PathType Leaf){
                $fileObj = New-Object System.IO.FileInfo $fileObj
            }
            else{
                $fileObj = New-Object System.IO.DirectoryInfo $fileObj
            }
        }

        if ($fileObj -is [System.IO.FileInfo]){
            $fileObj.Directory.FullName
        }
        elseif ($fileObj -is [System.IO.DirectoryInfo]){
            $fileObj.Parent.FullName
        }
    }
}
