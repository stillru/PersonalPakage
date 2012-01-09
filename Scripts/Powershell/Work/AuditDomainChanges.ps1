Clear-Host
$log_path = "c:\Temp\"
$computer = gc env:computername
$result = "AD-Changes_" + (get-date (get-date).AddDays(-1) -uFormat "%Y-%m-%d") + "_" + $computer + ".log"

get-eventlog -LogName Security -After (get-date).adddays(-1) -EntryType SuccessAudit `
| where {($_.eventid -eq "5141") -or (($_.eventid -eq "5136") -and ($_.message.Contains("groupPolicyContainer"))) -or ($_.eventid -eq "4720") -or ($_.eventid -eq "4738") -or ($_.eventid -eq "4728") -or ($_.eventid -eq "4729")} `
| Foreach-Object {    ($_.timegenerated).tostring() + ";" + `
                    ($_.eventid).tostring() + ";" + `
                    ((($_.message -replace "`n", ";") -replace ";`t","") -replace "`r",";")}`
| Out-File -FilePath ($log_path + $result) -encoding ASCII -append -Width 1000

# Upload using ftp the log results
$file = ($log_path + $result)
$filenewname = $result

$FtpUploadCommand = "PUT `"" + $file + "`"";
$FtpCommandFilePath = [System.IO.Path]::GetFullPath("FTPCommand.tmp");
$FtpCommands = @( "user", "password", "bin", "cd Downloads/EventLogs","quote pasv", $FtpUploadCommand, "quit" ); #Change User and Password to your's
$FtpCommand = [String]::Join( "`r`n", $FtpCommands );
set-content $FtpCommandFilePath $FtpCommand;
ftp "-s:$FtpCommandFilePath" XXX.XXX.XXX.XXX; # Change to ftp server IP 
remove-item $FtpCommandFilePath;

# Downloaded files removal
Remove-Item ($log_path + "*.log")

