param( [string]$orgfile, [string]$diffile, [string]$switch )

If ( $diffile -eq "" ) {
	Write-Host
	Write-Host "TxtComp.ps1,  Version 1.00"
	Write-Host "Compare 2 text files and display the differences"
	Write-Host
	Write-Host "Usage:  .\TXTCOMP.PS1  file1  file2  [ /ALL ]"
	Write-Host
	Write-Host "Where:  file1 and file2  are the files to be compared"
	Write-Host "        /ALL             display all lines, not just the differences"
	Write-Host
	Write-Host "Written by Rob van der Woude"
	Write-Host "http://www.robvanderwoude.com"
	Write-Host
}
Else {
	If ( $switch -eq "/ALL" ) {
		Compare-Object $( Get-Content $orgfile ) $( Get-Content $diffile ) -IncludeEqual
	}
	Else {
		Compare-Object $( Get-Content $orgfile ) $( Get-Content $diffile )
	}
}
