##################################################################################
#
#
#  Script name: Add-STMember.ps1
#  Author:      goude@powershell.nu
#  Homepage:    www.powershell.nu
#
#
##################################################################################

param([string]$Domain, [string]$Csv)

function GetHelp() {

$HelpText = @"

DESCRIPTION:

NAME: Add-STMember.ps1
Adds Groups Based on a Star Trek Csv File.

PARAMETERS: 

-Domain      Name of the DOmain (Required)
-Csv         Файл в формате CSV (Обязателен)
-help        Выводит Help по данному скрипту

SYNTAX:

Add-STMember.ps1 -Domain powershell.nu -Csv C:\MyFOlder\StarTrek.csv

Adds Users to Groups based on the StarTrek Csv file.

Add-STMember.ps1 -help

Выводит Help по данному скрипту

Additional Information:

CSV файл содержит следующие поля:

Character, Position, Rank, Department, Species, Starship, Class, Registry, Series, Location
Jean-Luc Picard, Commanding Officer, Captain, Main Bridge,  Human, USS Enterprise (NCC-1701-D), Galaxy, NCC-1701-d, Star Trek: The Next Generation, Alpha Quadrant

"@
$HelpText
}

function Get-Csv ([string]$Domain, [string]$Csv) {

	$CsvFile = Import-Csv $Csv

	$CsvFile | ForEach {

		Add-ADMembership -Domain $Domain -Character $_.Character -Position $_.Position -Series $_.Series
	}
}

function Add-ADMembership ([string]$Domain, [string]$Character, [string]$Position, [string]$Series) {

	# Настройка подключения to Correct OU

	$OU = ./Get-AD.ps1 -Domain $Domain -OU $Series -property distinguishedName
	$DomainConnection = "LDAP://" + [string]$OU.distinguishedName

	$User = ./Get-AD.ps1 -Domain $DomainConnection -User $Character -property distinguishedName, Name
	$UserConnection = "LDAP://" + [string]$User.distinguishedName
	$UserdistinguishedName = [string]$User.distinguishedName
	$UserName = [string]$User.Name

	$Group = ./Get-AD.ps1 -Domain $DomainConnection -Group $Position -ToObject
	$GroupName = [string]$Group.Name

	if ($Group.member -Contains $UserdistinguishedName) {
		Write-Host "User: $UserName is already member of: $GroupName" -ForeGroundColor Yellow
	} else {
		$Group.Add($UserConnection)
		Write-Host "Added User: $UserName to: $GroupName" -ForeGroundColor Green
	}
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUd/nFecCP3lnlbtnq1Tghemrc
# R7ugggI/MIICOzCCAaigAwIBAgIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCHQUA
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
# FgQU5Ru17a8lmG4QHvLJaIqmCXXskkQwDQYJKoZIhvcNAQEBBQAEgYAPpKNBnFgg
# U7DVxGp0sFSVauEdFNFlCa+ZmHHe/gIxtdGS5OE0gcZnveaDXjAnWxMDUyEyG37c
# VcdYvb6ZkUCNoIRktCC4nHmb/Vji8gzvF2Ub2c1AMUtLsoOxUOZRRIASnO47nCMH
# xqyyrcwJOgMWPv0MdEevC+mi/nW4LNOb2Q==
# SIG # End signature block
