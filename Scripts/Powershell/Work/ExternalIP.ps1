<#
.SYNOPSIS
    This script fetch webpage with external ip from web, prase it and send
	email and jabber message with it to system administrator.
.DESCRIPTION
    This script firsts creates a System.Net.WebClient object and
    download page from web. Then it's prase it to one string - external address.
	Then it send it to administrator with gmail smtp server.
.NOTES
    File Name : ExternalIP.ps1
    Author : Steve Illichevsky - still.ru@gmail.com
    Requires : PowerShell Version 2.0, PoshXmpp Snapin
.LINK
    This script posted to:
		https://github.com/stillru/PersonalPakage/blob/master/Scripts/Powershell/Work/ExternalIP.ps1
	Function Write-EventLog was found at
		http://www.powergui.org/thread.jspa?threadID=12771
		Thanks to SamuelC
	Function Senm was found at
		http://stackoverflow.com/a/2250309
		Thanks to Cristian (http://stackoverflow.com/users/270085/christian)
.EXAMPLE
    Left as an exercise to the reader!
.VERSION
	v 0.2
		+ Add Jabber-Send function. Need PoshXmpp.
	v 0.1
		+ Add sendm function for sending mail thru gmail.
		+ Add event logging. Now without errors.
		+ Create script
.ToDo
		- Implement Error logging
		- Switching between 2 gates
#>

# Some params
$nowd = get-date -uformat "%d.%m.%y %H:%M"				# Date
$url = "http://www.ip-details.com/"						# Url for webpage
$webpagetxt = "C:\Users\$env:username\chek.txt"			# File for temp
$lastchek = "C:\Users\$env:username\lastchek.txt"		# Lockfile
$chek = gc $lastchek									# Last ip chek
$NotifJabber = "XXX@example.ru"							# Jabber ID for notifications
$JabberId = "notifications@somedomain.com"				# Jabber ID for sending message
$JabberPassword = "XXX"									# Password from Jabber

function Jabber-Send () 
{
PoshXmpp\New-Client $JabberId $JabberPassword
PoshXmpp\Send-Message $NotifJabber $Body
$PoshXmppClient.Close()
}
function Sendm () 
{
$SMTPServer = "smtp.gmail.com" 
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("admin", "admin");  # Change to yours
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}
function Write-EventLog
{
param([string]$msg = "Default Message", [string]$type="Information")
$log = New-Object System.Diagnostics.EventLog
$log.set_log("Application")
$log.set_source("PSscript")
$log.WriteEntry($msg,$type)
} 

# Analog wget
$webclient = new-object System.Net.WebClient
$webpage = $webclient.DownloadString($url)
$webpage > "$webpagetxt"
 
# Parsing webpage 
$pattern = Select-String "$webpagetxt" -pattern '<h1 class="title">Your IP Address :'
$pattern = $pattern.get_Line() -replace "\s"," "
$exti = $pattern.Trim('<h1 class="title">Your IP Address : </h1>')
$extip = $exti.Trimend('</h1>')
# Send mail
if ($extip -eq $chek) {
Write-host Nohing to do!
Write-EventLog ("Nothing to do. IP is not changed!")
}else{
$EmailFrom = "notifications@somedomain.com"
$EmailTo = "XXX@example.ru"								# Change to yours 
if ($extip -match "x.x.x.x") {							# Change to yours for home network
	$Subject = "Notification from Home" 
	$Body = "$nowd - $extip - IP from home network."
	Sendm
	Write-EventLog ($Body)
	Jabber-Send ($Body)
} elseif ($extip -ne "x.x.x.x") {						# Change to yours
	$Subject = "Notification from Somewhere" 
	$Body = "$nowd - $extip - IP from Somwhere network."
	Sendm
	Write-EventLog ($Body)
	Jabber-Send ($Body)
	}
}
# Cleraing temp file
rm $webpagetxt
$extip > $lastchek
write-host $lastchek
write-host Clear!
