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
# sqagggI/MIICOzCCAaigAwIBAgIQ84Pm6xEt3IBIvyjAmjsGQzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTAzMDMxNDI0NDdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrVtuT+O+L
# DmYXTlXt0USK7SZHuPj1pghReJWDmKMH+6UYUid1pi6cE5DrjV/s3ZthdSPELe2t
# Y/39+wvfPG/5jFrwTAI/Xe3j0LEkZYDISOV0s0JgvQ2M7kHxwlLzzsooYJOvBBt4
# HJkTL1K/aNjvHmv+DT/YdwH3F0zWjdC4UQIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBCC7/x9BvbiDxGSRLeEaTZ7oS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghD7egqM7x2onEv0
# VoLfF75nMAkGBSsOAwIdBQADgYEAeLNhKp6P+tPSRoM7mBUrYxYxkAsKuqoqS6wA
# yOcYsi6riRpfAjqIsRV0hws9mML34wVXhtj+qsiNxdIv32d8K3+d7fTTeUvZDpU5
# PxoRm/GvR9XrzvJymk8w/TgpNiNV7PdxEhhL+p3rfM9o8fBfq3GTIgvIx3a/rzjB
# ADBbMEgxggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQ84Pm6xEt3IBIvyjAmjsGQzAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUFXIc5RouaJcVnAwRPST68dEoc+IwDQYJKoZIhvcNAQEBBQAEgYAp26KWN822
# eONL3rViwSKfBtDTVtYQoITf1y1ouBbUi635N56pdfVMJx1maJxOFNGonzQbSUwo
# vLiLze+uwogqU2Zj/z81Slch/kcC4zZZxiGLkabxeBscW3UMabaZgPr8lDr7WRDZ
# Xf8GWCxSDWZiygXMb7P9b7WxiS0SB1izAg==
# SIG # End signature block
