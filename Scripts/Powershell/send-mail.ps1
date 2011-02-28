#* ======================
#* Get Logged Users Function
#* ======================
function Get-MyLoggedOnUsers
{
 param([string]$Computer)
 Get-WmiObject Win32_LoggedOnUser -ComputerName $Computer | Select Antecedent -Unique | %{'{0}\{1}<br>' -f $_.Antecedent.ToString().Split('""')[1], $_.Antecedent.ToString().Split('""')[3]}
}
$Logged = Get-MyLoggedOnUsers SEVER
#* ======================
#* Uptime Function
#* ======================
function GLOBAL:Get-SystemUptimeFormatted([String]$computer="localhost") { 
      $wmiPerfOsSystem = Get-WmiObject -computer $computer -class Win32_PerfFormattedData_PerfOS_System 
      [TimeSpan] $systemUptime = New-TimeSpan -seconds $wmiPerfOsSystem.SystemUpTIme 
      [String]::Format("{0:G}", $systemUptime) 
} 
$uptime = Get-SystemUptimeFormatted
#* ======================
#* Sendmail Function
#* ======================
function sendEmail {
#* Create new .NET object and assign to variable
$mail = New-Object System.Net.Mail.MailMessage
#* Sender Address
$mail.From = New-Object System.Net.Mail.MailAddress("robot@nosto.ru");
#* Recipient Address
$mail.To.Add("still.ru@gmail.com");
#* Message Subject
$mail.Subject = "$ALERT SEVER REPORT";
#* Message Body
$mail.IsBodyHtml = $True
$mail.Body = "System uptime is $uptime <br>Status of Printing spooler is $File. $Doing <br> <br> Logged users on SEVER:<br> $Logged " ;
#  $mail.Body += $_.msg+”`n”
#* Connect to your mail server
$smtp = New-Object System.Net.Mail.SmtpClient("192.168.1.201");
#* Uncomment line below if authentication is required
$smtp.Credentials = New-Object System.Net.NetworkCredential("robot@nosto.ru", "xe9Shijoo");
#* Send Email
$smtp.Send($mail);
}
#* =====================
#* Script Body
#* =====================
#* Connect to file. You can connect to a local file or a remote file via UNC.
#* In this example I connect to a remote share
$File = ((Get-Process spoolsv).responding)
$Doing = "Nothing to do."
$ALERT = ""
#* Check File size and take action based on condition.
if ($File)
#* If condition is TRUE call sendEmail function
{sendEmail}
#* If condition is FALSE script does nothing
else {Stop-Process spoolsv ; Start-Process spoolsv;$ALERT = "[WARNING]"; $Doing = "Restarting process"} 