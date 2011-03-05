#requires -version 2.0

param(
    $filename = $(throw "Please specify a filename."),
    $highlightRanges = @(),
    [System.Management.Automation.SwitchParameter] $excludeLineNumbers)

# [Enum]::GetValues($host.UI.RawUI.ForegroundColor.GetType()) | % { Write-Host -Fore $_ "$_" }
$replacementColours = @{ 
    "Command"="Yellow";
    "CommandParameter"="Yellow";
    "Variable"="Green" ;
    "Operator"="DarkCyan";
    "Grouper"="DarkCyan";
    "StatementSeparator"="DarkCyan";
    "String"="Cyan";
    "Number"="Cyan";
    "CommandArgument"="Cyan";
    "Keyword"="Magenta";
    "Attribute"="DarkYellow";
    "Property"="DarkYellow";
    "Member"="DarkYellow";
    "Type"="DarkYellow";
    "Comment"="Red";
}
$highlightColor = "Green"
$highlightCharacter = ">"

## Read the text of the file, and parse it
$file = (Resolve-Path $filename).Path
$content = [IO.File]::ReadAllText($file)
$parsed = [System.Management.Automation.PsParser]::Tokenize($content, [ref] $null) | 
    Sort StartLine,StartColumn

function WriteFormattedLine($formatString, [int] $line)
{
    if($excludeLineNumbers) { return }
    
    $hColor = "Gray"
    $separator = "|"
    if($highlightRanges -contains $line) { $hColor = $highlightColor; $separator = $highlightCharacter }
    Write-Host -NoNewLine -Fore $hColor ($formatString -f $line,$separator)
}

Write-Host

WriteFormattedLine "{0:D3} {1} " 1

$column = 1
foreach($token in $parsed)
{
    $color = "Gray"

    ## Determine the highlighting colour
    $color = $replacementColours[[string]$token.Type]
    if(-not $color) { $color = "Gray" }

    ## Now output the token
    if(($token.Type -eq "NewLine") -or ($token.Type -eq "LineContinuation"))
    {
        $column = 1
        Write-Host

	WriteFormattedLine "{0:D3} {1} " ($token.StartLine + 1)
    }
    else
    {
        ## Do any indenting
        if($column -lt $token.StartColumn)
        {
            Write-Host -NoNewLine (" " * ($token.StartColumn - $column))
        }

        ## See where the token ends
        $tokenEnd = $token.Start + $token.Length - 1

        ## Handle the line numbering for multi-line strings
        if(($token.Type -eq "String") -and ($token.EndLine -gt $token.StartLine))
        {
            $lineCounter = $token.StartLine
            $stringLines = $(-join $content[$token.Start..$tokenEnd] -split "`r`n")
            foreach($stringLine in $stringLines)
            {
                if($lineCounter -gt $token.StartLine)
                {
                    WriteFormattedLine "`n{0:D3} {1}" $lineCounter
                }
                Write-Host -NoNewLine -Fore $color $stringLine
                $lineCounter++
            }
        }
        ## Write out a regular token
        else
        {
            Write-Host -NoNewLine -Fore $color (-join $content[$token.Start..$tokenEnd])
        }

        ## Update our position in the column
        $column = $token.EndColumn
    }
}

Write-Host "`n"
# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWjcjLiWcDlSu71d7BeAeX4Xg
# W3ugggI/MIICOzCCAaigAwIBAgIQ84Pm6xEt3IBIvyjAmjsGQzAJBgUrDgMCHQUA
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
# FgQU0IF/k3bjJ93gR2+S/Nym0F7QGPIwDQYJKoZIhvcNAQEBBQAEgYCVJ9H9Ulyt
# ZvXM+0tK2NzaxKi88tJKmT4pvX4lcnnjiNMFcWNiTH2IURZWJqByGIsb6tZDxbI6
# mng6dcSCA5GcIkkMDV6PTiuiZYX0+Tpwx19eYa2yJMYfPPu44hT6xDLVOXBqOThb
# umpIwtG6MrAsC/3rzWIhP9FmurCefwh6Cw==
# SIG # End signature block
