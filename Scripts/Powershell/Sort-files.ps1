#
# Sort-File.ps1
#
# Helper to sorort files by it's content

# Params
param ([string]$RootFolder, [string]$PathString)
# Functions

#Help
function GetHelp() {

$HelpText = @"

DESCRIPTION:

NAME: Sort-File
Sorting file by extantion and name.

PARAMETERS: 

-RootFolder      Path of Root Folder(Required)
-Path            Path of sorting folder (Required)
-help            Prints the HelpFile (Optional)

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


#Test Root Folder
function TestRoot {
if (!(Test-Path -path $RootFolder))
{
New-Item $RootFolder -type directory | Out-null
write-host "Directory $RootFolder Created!"
} else {
write-host "Do nothing!"
}
}

#Create Files Folders Folder
function TestXLS {
if (!(Test-Path -path $RootFolder\XLS))
{
New-Item $RootFolder\XLS -type directory | Out-null
write-host "Directory $RootFolder\XLS Created!"
} else {
write-host "Copyng file $_"
cp $_ $RootFolder\XLS\$_
}
} 

function TestEXE {
if (!(Test-Path -path $RootFolder\Execution))
{
New-Item $RootFolder\Execution -type directory | Out-null
write-host "Directory $RootFolder\Execution Created!"
} else {
write-host "Copyng file $_"
cp $_ $RootFolder\Execution\$_
}
} 
function TestWin {
if (!(Test-Path -path $RootFolder\Win))
{
New-Item $RootFolder\Win -type directory | Out-null
write-host "Directory $RootFolder\Win Created!"
} else {
write-host "Copyng file $_"
cp $_ $RootFolder\Win\$_
}
} 
#Main Function
function Trigger ([string]$RootFolder, [string]$PathString) {
    TestRoot
	$PathFolder = ls $PathString
	write-host $PathFolder
	$PathFolder | ForEach {
		if (($_ -like "*.xsl" -or $_ -like "*.csv" )) {
        TestXLS
		} elseif (($_ -like "*windows*")){
		TestWin
		} elseif (($_ -like "*.exe")){
		TestEXE
		} elseif (($_ -like "*.txt")){
		write-host TestTXT
		} elseif (($_ -like "*.zip")){
		write-host TestZIP
		} else {
		write-host "Nothing to do with $_ file."
		}
	}
}
# Main body
if ($help) {
        GetHelp
} elseif ($RootFolder -AND $PathString) {
        Trigger -RootFolder $RootFolder -PathString $PathString
} else {
        GetHelp
}
