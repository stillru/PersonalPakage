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
# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzYV6T+2cRG082+FJzCcr4ksI
# sqagggI/MIICOzCCAaigAwIBAgIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTA0MTcxMDE3MTdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDNS0UlibCi
# ee8p01vzbsGDrOwycGKHoTTPu4WW2cO5kiZMc9ssT2no5uihGO5/QZi9uLtIFtyk
# AvPj4+WSjOCcvWkh6GRXg3EKxeP31HVyx1tT4p0/hpkQGYbOyHnSr5Rhl/ZsFZqr
# czu3VQWFdNw25+DqFCxAbF4CKXN8oIhFsQIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBDs9tfN4CVX/di6ZfySo+h4oS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghDRk8Je+PxYtkub
# 5OGUg9ziMAkGBSsOAwIdBQADgYEAud9iRB9g/CmubZ5U+lBkpPTyIzuSgoygo35X
# ORewz73XwRMaC7ygSwZTFuBJboVTNUlOZVIDgk4+06JkomqIOeZOkEgYb+Un9Jat
# 1lBlXHAyrYLX/6w9llMFy0zAKQ+iWhdR45/L5mjy3F0qke16tr4Ar7gkQJmy8KCM
# mSL7/eQxggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUFXIc5RouaJcVnAwRPST68dEoc+IwDQYJKoZIhvcNAQEBBQAEgYCWUYpl45V+
# YfPCStK4izHCOv1wqwSmP6eviat/zYA+PhbxMdnWqfhAL2p8cME3h/nB+BFuOgMK
# 36l2IL2aCeKlzubkzIOM4HFRzxPF0HwNhfEOJ1RK/t8c9Cbnj6zZyyZKa057b1zH
# /KY7J3pAGXvUoJ+G3tyQF2D7lmwt/i3L6Q==
# SIG # End signature block
