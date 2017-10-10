function which {
    <#
    .SYNOPSIS
    Mimics the GNU "which" command, which (ha-ha) is a utility used to find
    which (ha-ha) executable is executed when entered on the shell prompt.
    
    .PARAMETER what
    Parameter the executable/cmdlet/function name to find.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        $what
    )

    process {
        $cmd = Get-Command $what

        if ($cmd -is [System.Management.Automation.FunctionInfo]){
            Write-Verbose "$cmd is a function."
            $cmd.ScriptBlock.File
        }
        elseif ($cmd -is [System.Management.Automation.CmdletInfo]){
            Write-Verbose "$cmd is a cmdlet."
            $cmd.DLL
        }
        elseif ($cmd -is [System.Management.Automation.AliasInfo]){
            Write-Verbose """$cmd"" is an alias for $($cmd.ReferencedCommand)"
            $cmd.ReferencedCommand.DLL
        }
        elseif ($cmd -is [System.Management.Automation.ApplicationInfo]){
            Write-Verbose "$cmd is an application."
            $cmd.Definition
        }
        elseif ($cmd){
            Write-Verbose "$cmd is $($cmd.GetType())"
            $cmd.Definition
        }
    }
}