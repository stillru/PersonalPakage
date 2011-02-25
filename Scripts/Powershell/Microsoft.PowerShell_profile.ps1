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

#SSH alias

Set-alias ssh_vlad 'plink.exe -pw weare still@95.66.157.198'
Set-alias ssh_outgate '$TOOLS\plink -pw weare still@78.24.177.69'
Set-alias ssh_gate '$TOOLS\plink -pw weare still@192.168.1.201'
Set-alias ssh_help '$TOOLS\plink -pw weare still@192.168.1.101'
Set-alias ssh_admin '$TOOLS\plink -pw weare still@192.168.1.127'

# Alias
function connect-sever { Enter-PSSession -ComputerName:192.168.1.220 -Credential:SEVER\still }

Set-Alias new New-Object
Set-Alias cmdSever connect-sever
