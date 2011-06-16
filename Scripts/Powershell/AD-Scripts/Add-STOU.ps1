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

	$CsvFile | Select Series, Starship, Location , Department -unique | ForEach {

		Add-OU -Domain $Domain -Series $_.Series -Starship $_.Starship -Location $_.Location -Department $_.Department
		Add-OU2 -Domain $Domain -Series -Department $_.Department
	}
}

function Add-OU ([string]$Domain, [string]$Series, [string]$Starship, [string]$Location, [string]$Department) {

	# Check if OU Exists

	$distinguishedName = "OU="+ $Department + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

	Check-distinguishedName -Domain $Domain -OU $distinguishedName

	if ($distinguishedNameDoesntExist -eq $True) {

		# Set Up Connection

		$Connection = ($Domain.Replace(".",",DC=")).Insert(0,"LDAP://DC=")

		$AD = [adsi]$Connection

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

function Add-OU2 ([string]$Domain, [string]$Series, [string]$Location, [string]$Department) {
		# Another connection
		$NewConnection2 = "LDAP://OU=Users,OU=" + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")
		$NewOU2 = [adsi]$NewConnection2
		$Dep = $NewOU2.Create("OrganizationalUnit", "ou=$Department")
		$Dep.SetInfo()

		$Dep.put("l", $Location)
		$Dep.put("Description", $Department)
		$Dep.setinfo()
		}


		Write-Host "Added OU: $Department to Users in $Series" -ForegroundColor Green

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
