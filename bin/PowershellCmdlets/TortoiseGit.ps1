function Get-TortoiseGitProc {
    "C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe"
}

function Get-QuotedTortoiseGitRemainingArgs {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [object[]] $Arguments
    )
    # TODO: Newlines break this
    $Arguments | ForEach-Object {
        if ($_ -match "(/.*?):(.*)$") {
            "$($Matches[1]):`"$($Matches[2])`""
        }
    }
}

function Show-TortoiseGitLog {
    <#
        .SYNOPSIS
        Open the TortoiseGit log dialog in the current directory.

        .PARAMETER Commitish
        The commit, branch name, or range to view logs of.

        .PARAMETER RemainingArgs
        Remaining arguments compatible with TortoiseGit.
    #>
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Commitish,

        [Parameter(ValueFromRemainingArguments=$true)]
        [object[]] $RemainingArgs
    )

    &(Get-TortoiseGitProc) /command:log /range:$Commitish (Get-QuotedTortoiseGitRemainingArgs $RemainingArgs)
}

function Show-TortoiseGitCommit {
    <#
        .SYNOPSIS
        Open the TortoiseGit commit dialog in the current directory.

        .PARAMETER RemainingArgs
        Remaining arguments compatible with TortoiseGit.
    #>
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [object[]] $RemainingArgs
    )
    &(Get-TortoiseGitProc) /command:commit (Get-QuotedTortoiseGitRemainingArgs $RemainingArgs)
}

#TODO: Rewrite tgb, tgdiff, tgm, tgr