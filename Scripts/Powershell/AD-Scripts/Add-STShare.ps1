##################################################################################
#
#
#  Script name: Add-STShare.ps1
#  Author:      goude@powershell.nu
#  Homepage:    www.powershell.nu
#
#
##################################################################################

param([string]$Share, [string]$ShareName)

function GetHelp() {

$HelpText = @"

ОПИСАНИЕ:

ИМЯ: Add-STShare.ps1
Creates a Share on the Server.

ПАРАМЕТРЫ: 

-Share           Путь до расшаренной папки (Обязательно)
-ShareName       Имя расшаренной папки (Обязательно)
-help            Вывод справки (Опционально)

СИНТАКСИС:

Add-STShare.ps1 -Share C:\Share -ShareName "StarTrek User Share"

Создаёт расшаренную папку. 

Add-STShare.ps1 -help

Показывает справку по этому скрипту (этот текст)

"@
$HelpText
}

function Create-Share ([string]$Share, [string]$ShareName) {

	# Check if Share Already Exists

	if ((gwmi Win32_Share | Where { $_.Path -eq $Share}).Path -eq $Share ) {

	Write-Host "Share: $ShareName already exists." -ForeGroundColor Red

	} else {

		# Set up Variables

		[int]$Type = 0

		# Check if Folder doesn't exist

		if (!(Test-Path $Share)) {
			New-Item -Path $Share -type directory | Out-Null
		}

		# Create Share through Wmi
	
		$CreateShare = [wmiclass]"Win32_Share"
		$CreateShare.Create($Share,$ShareName,$Type) | Out-Null

		Write-Host "Share: $ShareName Created." -ForeGroundColor Green
	}
}

if ($help) { GetHelp }

if ($Share -AND $ShareName) { Create-Share -Share $Share -ShareName $ShareName }
