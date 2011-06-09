##################################################################################
#
#
#  Script name: Add-STUser.ps1
#  Author:      goude@powershell.nu
#  Homepage:    www.powershell.nu
#
#
##################################################################################

param ([string]$Domain, [string]$Csv)

function GetHelp() {

$HelpText = @"

DESCRIPTION:

NAME: Add-STUser
Adds Users from the StarTrek Csv File

PARAMETERS: 

-Domain      Name of the DOmain (Required)
-Csv         The Csv file Used by the script (Required)
-help        Prints the HelpFile (Optional)

SYNTAX:

Add-STUser.ps1 -Domain powershell.nu -Csv C:\MyFOlder\StarTrek.csv

Adds the Users from the Csv file to Active-Directory.

Add-STUser.ps1 -help

Displays the help topic for the script

Additional Information:

The Csv File is built up in the following way:

Character, Position, Rank, Department, Species, Starship, Class, Registry, Series, Location
Jean-Luc Picard, Commanding Officer, Captain, Main Bridge,  Human, USS Enterprise (NCC-1701-D), Galaxy, NCC-1701-d, Star Trek: The Next Generation, Alpha Quadrant

"@
$HelpText
}

function Get-Csv ([string]$Domain, [string]$Csv) {

	$CsvFile = Import-Csv $Csv

	$CsvFile | ForEach {

		Add-User -Domain $Domain -Character $_.Character -Position $_.Position -Rank $_.Rank -Department $_.Department -Species $_.Species -Starship $_.Starship -Series $_.Series -Location $_.Location
	}
}


function Add-User ([string]$Domain, [string]$Character, [string]$Position, [string]$Rank, [string]$Department, [string]$Species, [string]$Starship, [string]$Series, [string]$Location) {

	# Set up AD Connectionstring

	$Connection = $Series.Insert(0,"LDAP://OU=Users,OU=") + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

	# Check Character Name

	$CharacterName = $Character.Split(" ")

	if (($CharacterName.Count) -le 1) {

		# Character Doesn't have a SurName

		[string]$givenName = $CharacterName
		[string]$sn = "Unknown"

		# Check if givenName contains Less than 6 Characters

		if ($givenName.Length -lt 6) {

			$AddNum = 6 - $givenName.Length

			# Build Last Part Of cn

			for ($i = 0; $i -lt ($AddNum -1); $i ++) { $AddTocn += "0" }
			$AddTocn += "1"

			[string]$sAMAccountName = ($givenName).ToLower() + $Addtocn
			$cn = $givenName

			# Set Checker to Null

			$AddTocn = $Null

		} else {

			[string]$sAMAccountName = ($givenName.SubString(0,6)).ToLower()
			$cn = $givenName
		}

	} else {

		[string]$givenName = $CharacterName[0..($CharacterName.Count -2)]
		[string]$sn = $CharacterName[($CharacterName.Count -1)]

		# Check if givenName contains Less than 3 Characters

		if ($givenName.Length -lt 3 -AND $sn.Length -lt 3) {

			$Tempcn = $givenName + $sn

			$AddNum = 3 - $Tempcn.Length

			# Build Last Part Of cn

			for ($i = 0; $i -lt ($AddNum -1); $i ++) { $AddTocn += "0" }
			$AddTocn += "1"

			[string]$sAMAccountName = ($Tempcn).ToLower() + $Addtocn
			$cn = $givenName

			# Set Checker to Null

			$AddTocn = $Null

		} elseif ($givenName.Length -lt 3 -OR $sn.Length -lt 3) {

			$Tempcn = $givenName + $sn

			[string]$sAMAccountName = ($Tempcn.SubString(0,6)).ToLower()
			$cn = $givenName + " " + $sn

		} else {

			[string]$sAMAccountName = ($givenName.SubString(0,3)).ToLower() + ($sn.SubString(0,3)).ToLower()
			$cn = $givenName + " " + $sn

		}
	}

	# Check sAMAccountName

	Check-sAMAccountName -Domain $Domain -User $sAMAccountName

	if ($sAMAccountNameDoesntExist -eq $True) {

	} else {

		While ($Script:sAMAccountNameDoesntExist -eq $False) {

			# Create New sAMAccountName

			$LastChar = $sAMAccountName.SubString($sAMAccountName.Length -1)

			if(1..9 -Contains $LastChar) {

				$sAMAccountName = ($sAMAccountName.TrimEnd([string]$LastChar)) + ([int]$LastChar + 1)
			} else {

				$sAMAccountName = $sAMAccountName + 1
			}

			Check-sAMAccountName -Domain $Domain -User $sAMAccountName
		}
	}

	# Check if User Already Exists

	$distinguishedName = "CN=" + $cn + ",OU=Users,OU=" + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

	Check-distinguishedName -Domain $Domain -User $distinguishedName

	if ($distinguishedNameDoesntExist -eq $True) {

		# Set Up Variables

		$Description = $Position + " (" + $Species + ")"
		$Title = $Rank
		$physicalDeliveryOfficeName = $Starship
		$userPrincipalName = $sAMAccountName + "@" + $Domain
		[string]$mail = ([string]$Character).Replace(" ",".") + "@" + $Domain

		# Get A Unique Password

		[string]$Password = Generate-Password
		
		# Create User in AD

		$OU = [adsi] $Connection
		$User = $OU.Create("user", "cn=$cn")
		$User.Put("sAMAccountName", $sAMAccountName)
		$User.Put("userPrincipalName", $userPrincipalName)
		$User.Put("DisplayName", $cn)
		$User.Put("givenName", $givenName)
		$User.Put("sn", $sn)
		$User.Put("Description", $Description)
		$User.Put("l", $Starship)
		$User.Put("streetAddress",$Location)
		$User.Put("physicalDeliveryOfficeName", $physicalDeliveryOfficeName)
		$User.Put("Title", $Title)
		$User.Put("Department", $Department)
		$User.Put("Company", $Starship)
		$User.Put("mail", $mail)
		$User.SetInfo()

		# Set Random Pwd and Enable Account

		$User.PsBase.Invoke("SetPassword", $Password)
		$User.PsBase.InvokeSet("AccountDisabled", $false)
		$User.SetInfo()

		# Write Pwd to File

		$FileName = "PasswordList " + (get-date -uformat "%Y-%m-%d") + ".txt"

		"$sAMAccountName,$cn,$Password" | Add-Content $FileName

		Write-Host "Added User: $Character" -ForegroundColor Green

	} else {

		Write-Host "User: $Character already exists" -ForegroundColor Yellow
	}

	# Set Check Variable to False

	$Password = $Null
	$Script:sAMAccountNameDoesntExist = $False
	$Script:distinguishedNameDoesntExist = $False
}

function Generate-Password {

	$Random = New-Object System.Random

	# Two Upper Case Characters

	[string]$Password += [char]$Random.Next(49,57)
	[string]$Password += [char]$Random.Next(65,72)

	# Two LowerCase Characters

	[string]$Password += [char]$Random.Next(97,107)
	[string]$Password += [char]$Random.Next(109,122)

	# One Special Char

	[string]$Password += [char]$Random.Next(36,43)

	# Two UpperCase Characters

	[string]$Password += [char]$Random.Next(65,72)
	[string]$Password += [char]$Random.Next(80,91)

	# One LowerCase

	[string]$Password += [char]$Random.Next(97,107)

	$Password
	$Password = $Null
}

function Check-distinguishedName ([string]$Domain, [string]$User) {

	trap {  $Script:distinguishedNameDoesntExist = $True ; continue } .\Get-AD.ps1 -Domain $Domain -User $User -filter distinguishedName | Out-Null
}

function Check-sAMAccountName ([string]$Domain, [string]$User) {

	trap {  $Script:sAMAccountNameDoesntExist = $True ; continue } .\Get-AD.ps1 -Domain $Domain -User $User -Filter sAMAccountName | Out-Null
}

if ($help) { 
	GetHelp 
} elseif ($Domain -AND $Csv) {
	Get-Csv -Domain $Domain -Csv $Csv
} else {
	GetHelp
}

# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU14KBUby+acyZgON4B7EPqXj2
# XH6gggI/MIICOzCCAaigAwIBAgIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCHQUA
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
# FgQU8nNlspw/rHOOSVxYXeent7HQNsIwDQYJKoZIhvcNAQEBBQAEgYA/o6X4k9oc
# BYUKOY4mJVlMo6SbbESvPS+D8cGXuoHQ5avNZomEK6ikJf9RXri+fQ+ow4QWAd+8
# Ta5bl1Wd2zidf8GdUgSmkrEMu4AGIq73nB0//HtNZekYAKuluCotyfKremBreKV1
# nNFADrMpxNnLKMlMCUBlrCc42qM9lsjNsw==
# SIG # End signature block
