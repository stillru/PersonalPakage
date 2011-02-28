Добавление некоторых путей в системную переменную Path

$TOOLS = 'C:\Program Files\PuTTY'
$CYDWIN = 'C:\CygWIN\bin'

# Алиас для AkelPad'a

Set-Alias apad 'C:\Program Files\AkelPad\akelpad.exe'

# Определение редактора для консоли

$env:EDITOR = 'nano'

# Определение функции которая добавляет в системную переменную ранее определённые пути.

function script:append-path { 
   if ( -not $env:PATH.contains($args) ) {
      $env:PATH += ';' + $args
   }
}

# Вызов функции и само добавление путей к переменной

append-path "$TOOLS"
append-path "$CYDWIN"

# Несколько функций которые меняют представлене приглашения PowerShell

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

# SSH & Remote alias

# Functions
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
