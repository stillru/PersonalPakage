# PowerShell Profile
#
# Editor: Steve Illichevsky 
# Email:  still.ru@gmail.com
# 
# (c) 2010

$TOOLS = 'C:\Program Files\PuTTY'
$CYDWIN = 'C:\CygWIN\bin'
$env:EDITOR = 'nano'

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

function Get-GitBranchNameWithStatusIndicator {
  $statusOutput = Invoke-Expression 'git status 2>$null'  #1
  if (!$statusOutput) { return } #2
  $branch = $statusOutput[0] #3
  if ($branch -eq "# Not currently on any branch.") {
    $branch = "No branch"
  } else {
    $branch =  $branch.SubString("# On branch ".Length) 
  }
  $statusSummary = $statusOutput[-1] #4
  if ($statusSummary -eq "nothing to commit (working directory clean)") { #5
    $statusIndicator = "" 
  } else {
    $statusIndicator = "*"
  }
  return $branch + $statusIndicator
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
   if ($gitStatus) {
    Write-Host (" [" + $gitStatus +"]") -nonewline -foregroundcolor Gray
   }
   return ' '
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
function Sudo ()
{
	if ($args.Length -eq 1)
	{
		start-process $args[0] -verb "runAs"
	}
	if ($args.Length -gt 1)
	{	
		start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
	}
}

# Определения Alias'ов
function connect-sever { Enter-PSSession -ComputerName:192.168.1.220 -Credential:SEVER\still }
Set-Alias new New-Object
Set-Alias cmdSever connect-sever
Set-Alias apad 'C:\Program Files\AkelPad\akelpad.exe'

# Подпись :-)


# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUj9fxK1nExhQGgNPMJtxrF3Sb
# DBagggI/MIICOzCCAaigAwIBAgIQDdu47s6KwahLMy9x/eoQPDAJBgUrDgMCHQUA
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
# FgQU4khhoBfG6A4nYH1qdtRGNCfzdpAwDQYJKoZIhvcNAQEBBQAEgYBNCweKXdWk
# bLHou+/R1wq9/rR4e+AKnErj79BrfX37F5NmiRC8gechaUjOkqZiswd+ALOxAGAE
# uFs54Y69Ex9KF7rvyMUV5s3RhSn0ehGKcTTRTolVLjseroli+OJPwYuYD09BL0nj
# FXqrBUN4NBhj0Jwjmqpo8ONRHP5aU6CbiQ==
# SIG # End signature block
