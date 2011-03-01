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
# sqagggI/MIICOzCCAaigAwIBAgIQDdu47s6KwahLMy9x/eoQPDAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTAzMDEwNTQ2MTdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDO0lfK8HOX
# wRcPzrbtB1V9keJVs3Q5UZdmGIKkOPPVirY6ojcUmOI3gAAhjOFmoTlGsuAwfYqq
# f6XJtPxc2GFkn3lTcYL0U/wcA/jwxb8aFPxypd4DWSPAOjmKqqFt/he6PLT1h6HZ
# Hc63Oac5B7CGt7mgBfjf/SYkQXiQPQ4AwQIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBCF4d2MW//nsY6ENKSg2wOdoS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghCKlnQsGN3pk0FY
# 87FvCba2MAkGBSsOAwIdBQADgYEAqyP9Fv7FOinrXvbNMRaFR7HN31ySLPsVwFlN
# J45lEv8EklEI1wsVGNKcrVpK2+VTmI1gth54GXYE3UFOzIaslxa0Cw7sPC7yD2PI
# Pblc7CYZSYEyxfiahz39XoZwRaTYMvviDvFN0krSTMinSoibn2deLDM/tafuBcQk
# zl4xDkExggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQDdu47s6KwahLMy9x/eoQPDAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUFXIc5RouaJcVnAwRPST68dEoc+IwDQYJKoZIhvcNAQEBBQAEgYAodrrE4ZSf
# mSNJv6VwoudUHDFvnYjte+vWgFfdj5eWOSojLjcYpw56KJ2jSRbPhuwcWl8rIsdB
# aHBHdNCupe6YFq347PPRSJEQ9z+68gZG+DiDZzcG1RZO9k7ENxCDP1p0LBjzEDCm
# DX81GBXt1uxsabb+W8feP6mqixM622e9Qg==
# SIG # End signature block
