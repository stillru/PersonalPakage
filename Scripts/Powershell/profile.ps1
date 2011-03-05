# PowerShell Profile
#
# Editor: Steve Illichevsky
# Email:  still.ru@gmail.com
#
# (c) 2010

$TOOLS = 'C:\Program Files\PuTTY'
$CYDWIN = 'C:\CygWIN\bin'
$env:EDITOR = 'npp'

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
Set-Alias new New-Object
Set-Alias apad 'C:\Program Files\AkelPad\akelpad.exe'
Set-Alias npp 'C:\Program Files\Notepad++\Notepad++.exe'
Set-Alias sudo elevate-process
function Conf-Remote {
	param( [string]$Server , [string]$Name )
	New-PSSession -ComputerName $Server -Credential SEVER\Still -Name $Name
}
Function Connect-Remote {
	param( [string]$Name )
	Enter-PSSession -Name $Name
}

# Подпись :-)

# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0TIMULYr8bszR2tGGDWyjy3N
# u1qgggI/MIICOzCCAaigAwIBAgIQ84Pm6xEt3IBIvyjAmjsGQzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTAzMDMxNDI0NDdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrVtuT+O+L
# DmYXTlXt0USK7SZHuPj1pghReJWDmKMH+6UYUid1pi6cE5DrjV/s3ZthdSPELe2t
# Y/39+wvfPG/5jFrwTAI/Xe3j0LEkZYDISOV0s0JgvQ2M7kHxwlLzzsooYJOvBBt4
# HJkTL1K/aNjvHmv+DT/YdwH3F0zWjdC4UQIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBCC7/x9BvbiDxGSRLeEaTZ7oS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghD7egqM7x2onEv0
# VoLfF75nMAkGBSsOAwIdBQADgYEAeLNhKp6P+tPSRoM7mBUrYxYxkAsKuqoqS6wA
# yOcYsi6riRpfAjqIsRV0hws9mML34wVXhtj+qsiNxdIv32d8K3+d7fTTeUvZDpU5
# PxoRm/GvR9XrzvJymk8w/TgpNiNV7PdxEhhL+p3rfM9o8fBfq3GTIgvIx3a/rzjB
# ADBbMEgxggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQ84Pm6xEt3IBIvyjAmjsGQzAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUUb4OFP7hCw1yWhcdq9E/J1U1IOYwDQYJKoZIhvcNAQEBBQAEgYCD3UiV/G5I
# 4MOKdoT8r3YF39aMHAxdThHsOP6N5rkpm++/fiIWBYe3pQVrNhyYslw3yxKhIpBu
# YvC0NBDFxwwL5jUvzveX6qWVmOuT45SpN3lut6PnLs9RsgOX2HObaBZz6VFsMdvf
# LTar1t53BayKxyJ1IjtgEWzRze1r4V5PiQ==
# SIG # End signature block
