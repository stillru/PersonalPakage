# PowerShell Profile
#
# Editor: Steve Illichevsky 
# Email:  still.ru@gmail.com
# 
# (c) 2010

$TOOLS = 'C:\Program Files\PuTTY'
$CYDWIN = 'C:\CygWIN\bin'
$env:EDITOR = 'nano'

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
Import-Module posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git


# Set up a simple prompt, adding the git prompt parts inside git repos
if(-not (Test-Path Function:\DefaultTabExpansion)) {
    Rename-Item Function:\TabExpansion DefaultTabExpansion
}

# Set up tab expansion and include git expansion
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1]
    
    switch -regex ($lastBlock) {
        # Execute git tab completion for all git-related commands
        'git (.*)' { GitTabExpansion $lastBlock }
        # Fall back on existing tab expansion
        default { DefaultTabExpansion $line $lastWord }
    }
}

# Выведение приветствия
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
   # Git Prompt
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $GitStatus
      
    return "> "
}

#   if ($gitStatus) {
#    Write-Host (" [" + $gitStatus +"]") -nonewline -foregroundcolor Gray
#   }
#   return '> '
#}

if(-not (Test-Path Function:\DefaultTabExpansion)) {
    Rename-Item Function:\TabExpansion DefaultTabExpansion
}


Enable-GitColors

Pop-Location

# Функция добавления переменных к переменной PATH

function script:append-path { 
   if ( -not $env:PATH.contains($args) ) {
      $env:PATH += ';' + $args
   }
}

append-path "$TOOLS"
append-path "$CYDWIN"

# Функции для определения вывода приветствия 

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

# Самоопределённые функции Functions

###############################################################################
#
# Функция Get-Diff
#
###############################################################################
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

######################################################################
#
# Function sudo
#
######################################################################
function elevate-process
{
	$file, [string]$arguments = $args;
	$psi = new-object System.Diagnostics.ProcessStartInfo $file;
	$psi.Arguments = $arguments;
	$psi.Verb = "runas";
	$psi.WorkingDirectory = get-location;
	[System.Diagnostics.Process]::Start($psi);
}

# Определения Alias'ов
function connect-sever { Enter-PSSession -ComputerName:192.168.1.220 -Credential:SEVER\still }
Set-Alias new New-Object
Set-Alias apad 'C:\Program Files\AkelPad\akelpad.exe'
Set-Alias sudo elevate-process
Add-PSSnapin NetCmdlets

# Подпись :-)

# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrzIS7UaJL6vTgL9i7mpnmXiU
# PiGgggI/MIICOzCCAaigAwIBAgIQDdu47s6KwahLMy9x/eoQPDAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTAzMDEwNTQ2MTdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDO0lfK8HOX
# wRcPzrbtB1V9keJVs3Q5UZdmGIKkOPPVirY6ojcUmOI3gAAhjOFmoTlGsuAwfYqq
# f6XJtPxc2GFkn3lTcYL0U/wcA/jwxb8aFPxypd4DWSPAOjmKqqFt/he6PLT1h6HZ
# Hc63Oac5B7CGt7mgBfjf/SYkQXiQPQ4AwQIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBCF4d2MW//nsY6ENKSg2wOdoS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghCKlnQsGN3pk0FY
# 87FvCba2MAkGBSsOAwIdBQADgYEAqyP9Fv7FOinrXvbNMRaFR7HN31ySLPsVwFlN
# J45lEv8EklEI1wsVGNKcrVpK2+VTmI1gth54GXYE3UFOzIaslxa0Cw7sPC7yD2PI
# Pblc7CYZSYEyxfiahz39XoZwRaTYMvviDvFN0krSTMinSoibn2deLDM/tafuBcQk
# zl4xDkExggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQDdu47s6KwahLMy9x/eoQPDAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUwqr1FEmjIyQ3WbHFfASJ3AwzorQwDQYJKoZIhvcNAQEBBQAEgYCevZoIFKhe
# eKUzrgTblPQLLjWPs2QIja6Sox7uQs6/tr/e+HQ4KHKUwL8BM1CZ6J/P09GmxJ3o
# kz/wzwEzjZ5fgEYPCcrSpBAKEWiswwqrLQJ9k/U3arFi1qqGF5uqcgqP5IYkO22m
# 4IoK9mqrkfUeV/ftYXcreOyPneaqP/1qXw==
# SIG # End signature block
