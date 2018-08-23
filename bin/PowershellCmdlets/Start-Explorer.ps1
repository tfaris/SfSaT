function Start-Explorer {
    <#
    .SYNOPSIS
    Opens Windows Explorer to the directory of the specified file. If the specified
    file IS a directory, then that directory is opened.
    
    .PARAMETER FileToExplore
    The file or directory to explore to.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        $FileToExplore
    )

    process {

        $fileObj = $FileToExplore

        if ($fileObj -is [System.Management.Automation.ApplicationInfo])
        {
            $fileObj = New-Object System.IO.FileInfo $fileObj.Path
        }
        elseif ($fileObj -is [String])
        {
            $fileObj = Get-Item $fileObj
        }

        $procArgs = New-Object System.Collections.ArrayList
        if ($fileObj -is [System.IO.FileInfo])
        {
            $procArgs.Add("/select,$($fileObj.FullName)") | Out-Null
        }
        elseif ($fileObj -is [System.IO.DirectoryInfo])
        {
            $procArgs.Insert(0, $fileObj.FullName) | Out-Null
        }

        Write-Verbose "explorer.exe $($procArgs -Join " ")"
        Start-Process explorer.exe -ArgumentList $procArgs | Out-Null
    }
}