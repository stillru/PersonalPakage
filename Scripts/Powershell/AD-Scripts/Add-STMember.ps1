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

ОПИСАНИЕ:

ИМЯ: Add-STMember.ps1
Adds Groups Based on a Star Trek Csv File.

ПАРАМЕТРЫ: 

-Domain      Имя домена (Обязательно)
-Csv         Файл в формате CVS который используется скриптом (Обязательно)
-help        Вывод справки (Опционально)

СИНТАКСИС:

Add-STMember.ps1 -Domain powershell.nu -Csv C:\MyFOlder\StarTrek.csv

Добавляет пользователей в существующие группы из csv-файла.
Add-STMember.ps1 -help

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

	$CsvFile | ForEach {

		Add-ADMembership -Domain $Domain -Character $_.Character -Position $_.Position -Series $_.Series
	}
}

function Add-ADMembership ([string]$Domain, [string]$Character, [string]$Position, [string]$Series) {

	# Set up Connection to Correct OU

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
