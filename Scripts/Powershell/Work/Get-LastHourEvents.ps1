$from = (Get-Date) - (New-Timespan -hour 1) 
 
get-eventlog -List |  
    Select-Object -ExpandProperty Log |  
    Foreach-Object { Write-Progress 'Examining Eventlog' $_; $_} |  
    Foreach-Object {$log = $_;   
    try { Get-EventLog -after $from -LogName $log -ea stop |  
    Add-Member NoteProperty EventLog $log -pass  }  
    catch { Write-Warning "Unable to access $log : $_"} } |  
    Sort-Object TimeGenerated -desc  |  
    Select-Object EventLog, TimeGenerated, EntryType, Source, Message |  
    Format-Table -Auto 