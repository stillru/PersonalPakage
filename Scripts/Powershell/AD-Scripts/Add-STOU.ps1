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

ОПИСАНИЕ:

ИМЯ: Add-STOU.ps1
Adds OU Structure based on the Star Trek Csv File.

ПАРАМЕТРЫ: 

-Domain      Имя домена (Обязательно)
-Csv         Файл в формате CVS который используется скриптом (Обязательно)
-help        Вывод справки (Опционально)

СИНТАКСИС:

Add-STOU.ps1 -Domain powershell.nu -Csv C:\MyFolder\StarTrek.csv

Добавляет в заданный домен структуру из файла.

Add-STOU.ps1 -help

Показывает справку по этому скрипту (этот текст)

Дополнительная информация:

CSV-файл построен следующим образом.

Character, Position, Rank, Department, Species, Starship, Class, Registry, Series, Location
Jean-Luc Picard, Commanding Officer, Captain, Main Bridge,  Human, USS Enterprise (NCC-1701-D), Galaxy, NCC-1701-d, Star Trek: The Next Generation, Alpha Quadrant

"@
$HelpText
}

function Get-Csv ([string]$Domain, [string]$Csv) {

	$CsvFile = Import-Csv $Csv

	$CsvFile | Select Series, Starship, Location , Department -unique | ForEach {

		Add-OU -Domain $Domain -Series $_.Series -Starship $_.Starship -Location $_.Location
		Add-OU2 -Domain $Domain -Series $_.Series -Department $_.Department -Location $_.Location
	}
}

function Add-OU ([string]$Domain, [string]$Series, [string]$Starship, [string]$Location, [string]$Department) {

	# Check if OU Exists

	$distinguishedName = "OU="+ $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

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
		$distinguishedName = "OU="+ $Department + ",OU=Users,OU="+ $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")

		Check-distinguishedName -Domain $Domain -OU $distinguishedName

	if ($distinguishedNameDoesntExist -eq $True){
		
		# Another connection
		$NewConnection2 = "LDAP://OU=Users,OU=" + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")
		$NewOU2 = [adsi]$NewConnection2
		$Dep = $NewOU2.Create("OrganizationalUnit", "ou=$Department")
		$Dep.SetInfo()

		$Dep.put("l", $Location)
		$Dep.put("Description", $Department)
		$Dep.setinfo()
		


		Write-Host "Added OU: $Department to Users in $Series" -ForegroundColor Green
} else {

		Write-Host "OU: $Department in Users at $Series Already Exists" -ForegroundColor Yellow
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
