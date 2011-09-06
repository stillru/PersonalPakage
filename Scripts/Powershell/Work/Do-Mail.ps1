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
# sqagggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTA5MDYwOTE2MjdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCP2GX9CepT
# TosFGyayZCiwGku0xeC+phBn0IJs/VT6AE3psG86Adk8m2eF5udNeXAC4LiCkcvB
# wvzgX0sWeT5TFaY4/GEu7h3MlOzpH8RJxl/tanffPoISepI/SETnhGkSm1tff3iN
# ajMv5jIaD5SJAKGXtBaUPMEEHsgubVKf/QIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBCYGrfsOOE7vOZlQROePY+IoS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghADONQyDz8llUyc
# bN6PIkcUMAkGBSsOAwIdBQADgYEAgy71zdWvr5JJLqPyWQLahrEYPxiyALa3Tkzu
# m6N1Mp9hawya6ZQlWOug+VdPJrQ/TFLpVzpvSl3RjMvAeHYVxC1ZwMS9VdbxqHcE
# Pt6/2ge9Kg1/o6SE83m8YnIKfNZbhxbawS4qASPzOBWjUXcWgzr94tngYBt2XxS4
# LTNXNIIxggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUFXIc5RouaJcVnAwRPST68dEoc+IwDQYJKoZIhvcNAQEBBQAEgYA41fBTIVNx
# kktFRBZ7hSNzEOlE0XnmXiO09ECDBBqQvWnGRAKvrPTLjg9scKp7N0ET2JK7QDgA
# zkHCH5gKpx05Got2bi15sT+srGa9xxNXuOAQk7uBqJuqocNhAbnkiCwSOK/v3zpG
# jxocxxnPERg0az5RXb9+XA65EYAbEbp8dw==
# SIG # End signature block
