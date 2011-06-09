##################################################################################
#
#
#  Script name: Add-STGroup.ps1
#  Author:      goude@powershell.nu
#  Homepage:    www.powershell.nu
#
#
##################################################################################

param([string]$Domain, [string]$Csv)

function GetHelp() {

$HelpText = @"

DESCRIPTION:

NAME: Add-STGroup.ps1
Adds Groups Based on the Star Trek Csv File.

PARAMETERS: 

-Domain      Name of the DOmain (Required)
-Csv         The Csv file Used by the script (Required)
-help        Prints the HelpFile (Optional)

SYNTAX:

Add-STGroup.ps1 -Domain powershell.nu -Csv C:\MyFOlder\StarTrek.csv

Adds Groups based on the Star Trek Csv file.

Add-STGroup.ps1 -help

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

	$CsvFile | Select Position, Series -unique | ForEach {

		Add-Group -Domain $Domain -Position $_.Position -Series $_.Series
	}
}

function Add-Group([string]$Domain, [string]$Position, [string]$Series) {

	$distinguishedName = "CN=" + $Position + ",OU=Groups,OU=" + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

	Check-distinguishedName -Domain $Domain -Group $distinguishedName

	if ($distinguishedNameDoesntExist -eq $True) {

		# Set Up Connection

		$Connection = "LDAP://OU=Groups" + $Series.Insert(0,",OU=") + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

		$AD = [adsi] $Connection

		$Group = $AD.Create("Group", "CN=$Position")
		$Group.SetInfo()

		$sAMAccountName = ($Position.replace(" ","")).ToUpper()

		if ($sAMAccountName.Length -gt 10) {

		$sAMAccountName = $sAMAccountName.SubString(0,9)

		}

		# Check sAMAccountName

		Check-sAMAccountName -Domain $Domain -Group $sAMAccountName

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

				Check-sAMAccountName -Domain $Domain -Group $sAMAccountName
			}
		}

		# Set Additional Information

		$Group.put("Description", $Position)
		$Group.put("sAMAccountName", $sAMAccountName)
		$Group.setinfo()

		Write-Host "Added Group: $Position" -ForegroundColor Green

	} else {

		Write-Host "Group: $Position already Exists" -ForegroundColor Yellow
	}

	$Script:distinguishedNameDoesntExist = $False
	$Script:sAMAccountNameDoesntExist = $False
}

function Check-distinguishedName ([string]$Domain, [string]$Group) {

	trap {  $Script:distinguishedNameDoesntExist = $True ; continue } .\Get-AD.ps1 -Domain $Domain -Group $Group -filter distinguishedName | Out-Null
}

function Check-sAMAccountName ([string]$Domain, [string]$Group) {

	trap {  $Script:sAMAccountNameDoesntExist = $True ; continue } .\Get-AD.ps1 -Domain $Domain -Group $Group -filter sAMAccountName | Out-Null
}

if ($help) {
	GetHelp
} elseif ($Domain -AND $Csv) {
	Get-Csv -DOmain $Domain -Csv $Csv
} else {
	GetHelp
}

# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6f6GVEMSHIpNM7UFNguqGMXa
# L4ugggI/MIICOzCCAaigAwIBAgIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCHQUA
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
# FgQU0yAQikSQyKRGqseEd3jDOKF84mwwDQYJKoZIhvcNAQEBBQAEgYBhtPB5dSeN
# EjHuHUJR3l9Vpa92/80O5n1rHhAnF69dfubzN4I/6d0GYxC2ayfuugI7O/wSswbR
# ygi+ijbrCQGlOrRQlN1AUItz42ocmOPc0OMJe4dh2SbG2tvMEWmHyBhx6DoUEHqg
# zP7hTCbNOKN5SUcu3MWqCMJmFK8+kKCTFw==
# SIG # End signature block
