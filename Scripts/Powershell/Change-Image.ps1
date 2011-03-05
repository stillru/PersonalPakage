#
# Change-Image.ps1
#   Script for converting any picture to jpeg
#   Author: Steve Illichevsky (still.ru@gmail.com)
#   Dependensies:
#       ImageMagic - free tool for converting any picture to any picture
#
#######################
# Functions
#######################
param ([string]$InputFolder , [string]$TempFolder , [string]$OutputFolder )

function Help
{param ()
    Write-Host
    Write-Host "Change-Image psevdo Deamon on PowerShell"
    Write-Host "This script is didtributed AS-IS"
	Write-Host "Usage:  .\Change-Image.ps1  InputFolder  OutputFolder "
	Write-Host
	Write-Host "Written by Steve Illichevsky"
	Write-Host "http://stillru.github.com"
	Write-Host
}
function MoveFilesToTemp
{param ([string]$InputFolder , [string]$TempFolder)
    if ($TempFolder -eq "") {
		if ($TempFolder = Test-Path "C:\Temp\Img"){
		Echo "Temp Folder is $TempFolder"
        cp $InputFolder -Destination $TempFolder -Recurse
		Echo "Copy to Temp"}
    } elseif (-not ($TempFolder -eq "")) {
		mkdir "C:\Temp\Img"
		Echo "Create Folder"
        cp $InputFolder -Destination $TempFolder -Recurse
		echo "Copy Files"
    } else {
	Help
	}
}

#######################
# Main
#######################
function Main {
param ([string]$InputFolder , [string]$OutputFolder , [string]$TempFolder)
	Echo "Start Main Block..."
    MoveFilesToTemp
}
Main