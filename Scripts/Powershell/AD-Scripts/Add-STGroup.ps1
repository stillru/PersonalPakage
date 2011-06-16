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
