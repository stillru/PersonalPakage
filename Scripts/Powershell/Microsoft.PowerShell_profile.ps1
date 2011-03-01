$TOOLS = 'C:\Program Files\PuTTY'
$CYDWIN = 'C:\CygWIN\bin'
Set-Alias apad 'C:\Program Files\AkelPad\akelpad.exe'
$env:EDITOR = 'nano'
#
# set path to include my usual directories
# and configure dev environment
#
function script:append-path { 
   if ( -not $env:PATH.contains($args) ) {
      $env:PATH += ';' + $args
   }
}


append-path "$TOOLS"
append-path "$CYDWIN"
#
# Define our prompt. Show '~' instead of $HOME
#
function shorten-path([string] $path) {
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

function get-adminuser() {
   $id = [Security.Principal.WindowsIdentity]::GetCurrent()
   $p = New-Object Security.Principal.WindowsPrincipal($id)
   return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function prompt {
   # our theme
   $cdelim = [ConsoleColor]::DarkCyan
   if ( get-adminuser ) {
      $chost = [ConsoleColor]::Red
   } else {
      $chost = [ConsoleColor]::Green
   }
   $cpref = [ConsoleColor]::Cyan
   $cloc = [ConsoleColor]::Magenta

   write-host $env:username@([net.dns]::GetHostName().ToLower()) -n -f $chost
   write-host '{' -n -f $cdelim
   write-host (shorten-path (pwd).Path) -n -f $cloc
   write-host '}' -n -f $cdelim
   return ' '
}

	#"$env:username@$env:computername $(get-location):"

# SSH alias

# Functions
function Get-Diff {
param( [string]$orgfile, [string]$diffile, [string]$switch )

If ( $diffile -eq "" ) {
        Write-Host
        Write-Host "Get-Diff,  Version 1.00"
        Write-Host "Compare 2 text files and display the differences"
        Write-Host
        Write-Host "Usage:  Get-Diff  file1  file2  [ /ALL ]"
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
}

#function connect ($hname){ 
#   $session = new-pssession -computername $hname -Credential still
#   icm -session $session -scriptblock{ 
#   #remote profile script
#
#       function prompt 
#       { 
#           Write-Host $(Get-Date -Format [HH:mm:ss])  -NoNewline -ForegroundColor Blue 
#           write-host $(get-location) -nonewline -foregroundcolor green 
#           return ">" 
#       }	function script:append-path {
#	   if ( -not $env:PATH.contains($args) ) {
#      		$env:PATH += ';' + $args
#   		}
#	}
#	
#	$CYDWIN = 'C:\CygWIN\bin'
#	$env:EDITOR = 'nano'
#   	
#	append-path = 'CYDWIN'
#	} 
#    enter-pssession $session -Credential:still 
#}

# Alias
function connect-sever { Enter-PSSession -ComputerName:192.168.1.220 -Credential:SEVER\still }

Set-Alias new New-Object
Set-Alias cmdSever connect-sever
