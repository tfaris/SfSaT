function Get-JavaVersions {
    <#
    .SYNOPSIS
    Get all versions of Java that can be found installed 
    under program files directories.
    #>
    [CmdletBinding()]
    param()

    process {
        $allJava = Get-ChildItem -R "C:\Program Files\*java*\**java.exe","C:\Program Files (x86)\*java*\**java.exe"
        foreach ($j in $allJava) {
             $output = &$j -version 2>&1
             if ($output[0].ToString() -match "java version ""(.*)"""){
                [PsCustomObject]@{
                    File=$j
                    Version=$matches[1]
                }
             }
        }
    }
}
