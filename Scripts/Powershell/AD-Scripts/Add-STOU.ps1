##################################################################################
#
#
#  Script name: Add-STOU.ps1
#  Author:      goude@powershell.nu
#  Homepage:    www.powershell.nu
#
#
##################################################################################

param([string]$Domain, [string]$Csv)

function GetHelp() {

$HelpText = @"

DESCRIPTION:

NAME: Add-STOU.ps1
Adds OU Structure based on the Star Trek Csv File.

PARAMETERS: 

-Domain      Name of the DOmain (Required)
-Csv         The Csv file Used by the script (Required)
-help        Prints the HelpFile (Optional)

SYNTAX:

Add-STOU.ps1 -Domain powershell.nu -Csv C:\MyFolder\StarTrek.csv

Adds OU Structure based on the Star Trek Csv File.

Add-STOU.ps1 -help

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

	$CsvFile | Select Series, Starship, Location -unique | ForEach {

		Add-OU -Domain $Domain -Series $_.Series -Starship $_.Starship -Location $_.Location
	}
}

function Add-OU ([string]$Domain, [string]$Series, [string]$Starship, [string]$Location) {

	# Check if OU Exists

	$distinguishedName = "OU=" + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

	Check-distinguishedName -Domain $Domain -OU $distinguishedName

	if ($distinguishedNameDoesntExist -eq $True) {

		# Set Up Connection

		$Connection = ($Domain.Replace(".",",DC=")).Insert(0,"LDAP://DC=")

		$AD = [adsi] $Connection

		$OU = $AD.Create("OrganizationalUnit", "ou=$Series")
		$OU.SetInfo()

		$OU.put("l", $Location)
		$OU.put("Description", $Starship)
		$OU.setinfo()

		Write-Host "Added OU: $Series" -ForegroundColor Green

		# Adding Additional Child OU:s to the Structure

		$NewConnection = "LDAP://OU=" + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")
		$NewOU = [adsi]$NewConnection

		# Add Users OU

		$Users = $NewOU.Create("OrganizationalUnit", "ou=Users")
		$Users.SetInfo()

		$Users.put("l", $Location)
		$Users.put("Description", $Starship)
		$Users.setinfo()

		Write-Host "Added OU: Users to $Series" -ForegroundColor Green

		# Add Groups OU

		$Groups = $NewOU.Create("OrganizationalUnit", "ou=Groups")
		$Groups.SetInfo()

		$Groups.put("l", $Location)
		$Groups.put("Description", $Starship)
		$Groups.setinfo()


		Write-Host "Added OU: Groups to $Series" -ForegroundColor Green

		# Add Computers

		$Computers = $NewOU.Create("OrganizationalUnit", "ou=Computers")
		$Computers.SetInfo()

		$Computers.put("l", $Location)
		$Computers.put("Description", $Starship)
		$Computers.setinfo()

		Write-Host "Added OU: Computers to $Series" -ForegroundColor Green


	} else {

		Write-Host "OU: $Series Already Exists" -ForegroundColor Yellow
	}

	# Clear Variables

	$Script:distinguishedNameDoesntExist = $False
}

function Check-distinguishedName ([string]$Domain, [string]$OU) {

	trap {  $Script:distinguishedNameDoesntExist = $True ; continue } .\Get-AD.ps1 -Domain $Domain -OU $OU -Filter distinguishedName | Out-Null
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUVGsjTIA8hGVGs9bXb+q4++GY
# z8agggI/MIICOzCCAaigAwIBAgIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCHQUA
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
# FgQUYlymNH/p0iglmUouHOAOYwQcggowDQYJKoZIhvcNAQEBBQAEgYCi0O2HfKGX
# jFIIBoQjGcVm9vXShvEs+p0zLUBJcBstuwBsfCap66iTykAoiyHIAJkcXvSGSfao
# r9KYOaGa0vC7c8diGq4yvCPrdZc/gU6h3b4V5zlZz6k2KelEvF4OMJ+PKLY7ZfgT
# shbPIFJnJUqnzeQT22KAZom4e/kk0+12JQ==
# SIG # End signature block
