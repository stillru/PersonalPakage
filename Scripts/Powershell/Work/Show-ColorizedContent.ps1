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
# W3ugggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTA5MDYwOTE2MjdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCP2GX9CepT
# TosFGyayZCiwGku0xeC+phBn0IJs/VT6AE3psG86Adk8m2eF5udNeXAC4LiCkcvB
# wvzgX0sWeT5TFaY4/GEu7h3MlOzpH8RJxl/tanffPoISepI/SETnhGkSm1tff3iN
# ajMv5jIaD5SJAKGXtBaUPMEEHsgubVKf/QIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBCYGrfsOOE7vOZlQROePY+IoS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghADONQyDz8llUyc
# bN6PIkcUMAkGBSsOAwIdBQADgYEAgy71zdWvr5JJLqPyWQLahrEYPxiyALa3Tkzu
# m6N1Mp9hawya6ZQlWOug+VdPJrQ/TFLpVzpvSl3RjMvAeHYVxC1ZwMS9VdbxqHcE
# Pt6/2ge9Kg1/o6SE83m8YnIKfNZbhxbawS4qASPzOBWjUXcWgzr94tngYBt2XxS4
# LTNXNIIxggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQU0IF/k3bjJ93gR2+S/Nym0F7QGPIwDQYJKoZIhvcNAQEBBQAEgYBtm+pU4JXE
# 3j31vFPI2UwYSwLCKYRm7pujMOCO5yRcjIgedyEa4YhYsuQ/NGGHen5Ly8LyPrFC
# YadusVCEza4g0ZLjZTyCeypCH989wVl/oFnPrjmFa+7ZzKuWmYxyP7SBD/0AUSqC
# +rbuUOEqgtwYW6CYyJHgGvH5GFg/g1fvAQ==
# SIG # End signature block
