function Get-TortoiseGitProc {
    "C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe"
}

function ConvertTo-TortoiseGitArgs {
    <#
        .SYNOPSIS
        Convert a hashtable into a collection of option flags that 
        TortoiseGitProc understands.
    #>
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [hashtable] $Arguments
    )
    $Arguments.Keys | ForEach-Object {
        "/$($_):`"$($Arguments[$_])`""
    }
}

function Invoke-TortoiseGitCommand {
    <#
        .SYNOPSIS
        Starts the TortoiseGit command line processor program.

        .PARAMETER Command
        The name of the TortoiseGit command to run.

        .PARAMETER CommandArgs
        A hashtable of arguments for the TortoiseGit command.
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string] $Command,
        [Parameter()]
        [hashtable] $CommandArgs = @{}
    )
    Write-Verbose "$(Get-TortoiseGitProc) /command:$Command $(ConvertTo-TortoiseGitArgs $CommandArgs)"
    &(Get-TortoiseGitProc) /command:$Command (ConvertTo-TortoiseGitArgs $CommandArgs)
}

function Show-TortoiseGitLog {
    <#
        .SYNOPSIS
        Open the TortoiseGit log dialog in the current directory.

        .PARAMETER Commitish
        The commit, branch name, or range to view logs of.
    #>
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Commitish
    )
    Invoke-TortoiseGitCommand -Command "log" -CommandArgs @{range=$Commitish}
}

function Show-TortoiseGitCommit {
    <#
        .SYNOPSIS
        Open the TortoiseGit commit dialog in the current directory.

        .PARAMETER LogMessage
        The message to pre-populate the commit message field with.
    #>
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $LogMessage
    )
    Invoke-TortoiseGitCommand -Command "commit" -CommandArgs @{logmsg=$LogMessage}
}

function Show-TortoiseGitBlame {
    <#
        .SYNOPSIS
        Open the TortoiseGit commit dialog in the current directory.

        .PARAMETER Path
        The path to the file to blame.
    #>
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string] $Path
    )
    Invoke-TortoiseGitCommand -Command "blame" -CommandArgs @{path=(dir -R $Path)}
}

function Show-TortoiseGitDiff {
    param(
        [Parameter(Position=0)]
        [string] $BaseFile,
        [Parameter(Position=1)]
        [string] $CompareFile
    )

    if ($CompareFile) {
        Invoke-TortoiseGitCommand -Command diff -CommandArgs @{path=$CompareFile; path2=$BaseFile}
    }
    else {
        Invoke-TortoiseGitCommand -Command diff -CommandArgs @{path=$BaseFile}
    }
}

function Show-TortoiseGitRepoBrowser {
    param(
        [Parameter(Position=0)]
        [string] $Commitish,

        [Parameter(Position=1)]
        [string] $Path
    )

    if ($Commitish -and $Path) {
        Invoke-TortoiseGitCommand -Command repobrowser -CommandArgs @{rev=$Commitish; path=$Path}
    }
    elseif ($Commitish) {
        Invoke-TortoiseGitCommand -Command repobrowser -CommandArgs @{rev=$Commitish}
    }
    else {
        Invoke-TortoiseGitCommand -Command repobrowser
    }
}

function Show-TortoiseGitMerge {
    Invoke-TortoiseGitCommand -Command merge
}

Set-Alias tg Show-TortoiseGitLog
Set-Alias tgc Show-TortoiseGitCommit
Set-Alias tgb Show-TortoiseGitBlame
Set-Alias tgm Show-TortoiseGitMerge
Set-Alias tgr Show-TortoiseGitRepoBrowser
Set-Alias tgdiff Show-TortoiseGitDiff
