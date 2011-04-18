# Microsoft PowerShell create share script
# Author: Guy Thomas 
## Version 1.5 February 2010 tested on PowerShell v 2.0 

$FolderPath = "C:\Temp"
$ShareName = "ChangeMe"
$Type = 0
$objWMI = [wmiClass] 'Win32_share'
$objWMI.create($FolderPath, $ShareName, $Type)