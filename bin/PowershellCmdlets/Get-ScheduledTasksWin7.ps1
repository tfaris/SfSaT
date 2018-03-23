function Get-ScheduledTasksWin7 {
    param(
      [string]
      $TaskName
    )
    foreach ($line in &"schtasks" "/V") {
        if ($line.StartsWith("Folder")) {
            $folder = $line.split(':')[-1].Trim()
        }
        elseif ($line.StartsWith("INFO:")){
            Write-Warning "Task folder `"$folder`". $line"
        }
        elseif ($line -eq "") {
        }
        elseif ($line.StartsWith("=")) {
            $columns = $line.Split(" ")
            $headers = New-Object System.Collections.ArrayList
            $hIndex = 0
            foreach ($col in $columns) {
                $strLen = $col.Length
                if ($hIndex + $strLen -ge $prevLine.Length){
                    $strLen = $prevLine.Length - $hIndex
                }
                $headerTitle = $prevLine.SubString($hIndex, $strLen).Trim()
                $headers.Add($(New-Object PSObject -Property @{
                    Title=$headerTitle
                    Index=$hIndex
                    Length=$strLen
                })) | Out-Null
                $hIndex += $col.Length + 1
            }
        }
        elseif ($headers) {
            $taskProperties = @{TaskPath=$folder}
            foreach ($header in $headers){
                $strLen = $header.Length
                if ($header.Index + $strLen -ge $line.Length){
                    $strLen = $line.Length - $header.Index
                }
                $value = $line.SubString($header.Index, $strLen).Trim()
                if (@("Start Time", "Start Date", "End Date", "Last Run Time") -contains $header.Title){
                    try{
                        $value = [System.DateTime]::Parse($value)
                    }
                    catch{
                        
                    }
                }
                $taskProperties.Add(
                    $header.Title,
                    $value
                )
            }
            New-Object PSObject -Property $taskProperties
        }
        $prevLine = $line
    }
}