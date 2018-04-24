function Enter-VirtualEnv {
    <#
        .SYNOPSIS
        Activate the python virtual environment (venv) with the specified name.

        .PARAMETER EnvName
        The name of the python virtual environment to activate.
    #>
    param(
        [Parameter(Position=0)]
        [string] $EnvName,

        [Parameter()]
        [switch] $PassThru
    )

    $envsDir = $env:WORKON_HOME

    if (!(Test-Path $envsDir)){
        Write-Error "WORKON_HOME does not exist."
    }
    elseif ($EnvName){
        $activateScript = Get-Item "$envsDir\$EnvName\Scripts\activate.ps1" -ErrorAction Ignore
        if ($activateScript){
            . $activateScript
            
            if ($?) { 
                Write-Verbose "Virtual environment $EnvName activated. Use 'deactivate' to exit."
            }

            if ($PassThru) {
                $activateScript
            }
        }
        else{
            Write-Error "virtualenv $EnvName does not exist. Create it with `"mkvirtualenv`""
        }
    }
    else{
        Write-Host "Pass a name to activate one of the following virtualenvs:"
        Get-ChildItem $envsDir | Format-Table -Property Name
    }
}

Register-ArgumentCompleter -ParameterName EnvName -CommandName Enter-VirtualEnv -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    
    $envsDir = $env:WORKON_HOME
    if (Test-Path $envsDir) {
        Get-ChildItem $envsDir | ForEach-Object { $_.Name } | Where-Object { 
            $_ -like "${wordToComplete}*" 
        }
    }
}
