param(
    $FileToExplore
)

if (!$FileToExplore){
    if ($Args.Length -gt 0){
        $FileToExplore = $Args[0]
    }
    else{
        $FileToExplore = $input|Select-Object -First 1
    }
}

if (!$FileToExplore){
    Write-Error "Input file or directory must be specified."
}
else{
    $procArgs = New-Object System.Collections.ArrayList
    if ($(Test-Path -Path $FileToExplore -PathType Leaf)){
        $inFile = New-Object System.IO.FileInfo $FileToExplore
        $procArgs.Add("/select,$($inFile.FullName)") | Out-Null
    }
    else {
        $procArgs.Insert(0, $(New-Object System.IO.DirectoryInfo $FileToExplore).FullName) | Out-Null
    }
    Start-Process explorer.exe -ArgumentList $procArgs
}
