##################################################################################
#
#  Script name: Bullzip-print.ps1 
#  Author:      Steve Illichevsky
#  Homepage:    stillru.github.com
#
##################################################################################

param([string]$Domain, [string]$Csv)

function GetHelp() {

$HelpText = @"

DESCRIPTION:

NAME: Bullzip-print.ps1 
Print file as PDF.

PARAMETERS: 

-In      Input file
-Out     Output PDF file
-help    Show this help file

SYNTAX:

Bullzip-print.ps1 -In C:\file.txt -Out C:\file.pdf

Convert txt file to pdf

Bullzip-print.ps1 -help

Displays the help topic for the script

Additional Information:

This script requires BullZip PDF Printer to be installed on computer

"@
$HelpText
}

function Get-Csv ([string]$In, [string]$Out) {

[void][System.Reflection.Assembly]::LoadWithPartialName(„Bullzip.PdfWriter“);

# Creates and sets up Word application object
$wordApp = new-object -ComObject word.application
$wordApp.ActivePrinter = „Bullzip PDF Printer“;
$wordApp.Visible = $false;

# Opens word document
$document = $wordApp.Documents.Open($In);

# Setup Bullzip printer
$settings = new-object Bullzip.PdfWriter.PdfSettings;
$settings.PrinterName = „Bullzip PDF Printer“;
$settings.SetValue(„Output“, $Out);
$settings.SetValue(„ShowPDF“, „no“);
$settings.SetValue(„ShowSettings“, „never“);
$settings.SetValue(„ShowSaveAS“, „never“);
$settings.SetValue(„ShowProgress“, „no“);
$settings.SetValue(„ShowProgressFinished“, „no“);
$settings.SetValue(„ConfirmOverwrite“, „no“);
$settings.WriteSettings([Bullzip.PdfWriter.PdfSettingsFileType]::RuneOnce);

# Sends document to spooler
$document.PrintOut();
# Closes document to prevent SaveAs dialog
$document.Close();

# Closes and cleans up Word application
$wordApp.Quit();
$wordApp = $null;
[gc]::collect();
[gc]::WaitForPendingFinalizers();
}

if ($help) {
	GetHelp
} elseif ($In -AND $Out) {
	Get-Csv -In $In -Out $Out
} else {
	GetHelp
}
