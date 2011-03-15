<#
   .Synopsis
    Adds a local user to a local group on either a local or remote machine.
   .Description
    This script uses [adsi] type accelerator to use ADSI to create a local group.
    It will throw an error if $group is not present. It uses the WinNT provider to
    connect to local SAM database. This is case sensitive. This script must run with
    ADMIN rights to create local groups.
   .Example
    Add-LocalUserToLocalGroup.ps1 -computer MunichServer -user myUser -group mygroup
    Adds a local user called myUser on a computer named MunichServer to a local group called mygroup
   .Example
    Add-LocalUserToLocalGroup.ps1 -user myUser -group mygroup
    Adds a local user called myUser on local computer to a group called mygroup
   .Inputs
    [string]
   .OutPuts
    [string]
   .Notes
    NAME:  Windows 7 Resource Kit
    AUTHOR: Ed Wilson
    LASTEDIT: 5/20/2009
    KEYWORDS: ADSI
   .Link
     Http://www.ScriptingGuys.com
#Requires -Version 2.0
#>
param(
      $computer=$env:computerName,
      [Parameter(mandatory=$true)]
      $user,
      [Parameter(mandatory=$true)]
      $group
) #end param
# *** Functions
function New-Underline
{
<#
.Synopsis
 Creates an underline the length of the input string
.Example
 New-Underline -strIN "Hello world"
.Example
 New-Underline -strIn "Morgen welt" -char "-" -sColor "blue" -uColor "yellow"
.Example
 "this is a string" | New-Underline
.Notes
 NAME:
 AUTHOR: Ed Wilson
 LASTEDIT: 5/20/2009
 KEYWORDS:
.Link
 Http://www.ScriptingGuys.com
#>
[CmdletBinding()]
param(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [string]
      $strIN,
      [string]
      $char = "=",
      [string]
      $sColor = "Green",
      [string]
      $uColor = "darkGreen",
      [switch]
      $pipe
 ) #end param
 $strLine= $char * $strIn.length
 if(-not $pipe)
  {
   Write-Host -ForegroundColor $sColor $strIN
   Write-Host -ForegroundColor $uColor $strLine
  }
  Else
  {
  $strIn
  $strLine
  }
} #end New-Underline function
 
function Test-IsAdministrator
{
    <#
    .Synopsis
        Tests if the user is an administrator
    .Description
        Returns true if a user is an administrator, false if the user is not an administrator        
    .Example
        Test-IsAdministrator
    #>  
    param()
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $currentUser).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} #end function Test-IsAdministrator

# *** Entry point to script ***

If(-not (Test-IsAdministrator)) { New-Underline "Admin rights are required for this script" ; exit }

if(!$user -or !$group)
      {
       $(Throw 'A value for $user and $group is required.')
        }
    
$OBjOU = [ADSI]"WinNT://$computer/$group,group"
$objOU.add("WinNT://$computer/$user")
