<#
   .Synopsis
    Search for PowerShell help documentation for a given keyword or reg-exp
   .Description
    Search for PowerShell help documentation for a given keyword or reg-exp
   .Example
    Search-help hashtable
   .Inputs
    [string]
   .OutPuts
    [string]
   .Notes
    NAME: Windows 7 Resource Kit
    AUTHOR: Steve Illichevsky
    LASTEDIT: 16/03/2011
    KEYWORDS: Signing
   .Link
    http://stillru.github.com
#Requires -Version 2.0
#>
param($pattern = $(throw "Please enter content to search for"))

$helpNames = $(Get-Help * | Where-Object { $_.category -ne "Alias" })

foreach ($helpTopic in $helpNames)
{
    $content = Get-Help -Full $helpTopic.Name | Out-String
    if($content -match $pattern)
        {
            $helpTopic | Select-Object Name,Synopsis
        }
}

# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfvvGlvqxJsNI+3HrAG7DFq3M
# ZRygggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
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
# FgQUkJCleiJiygCBRD7oNUYM6mYJ64owDQYJKoZIhvcNAQEBBQAEgYCGn414Oce6
# vZjb+aonI66pHF2JL69+TLnPOgUm6piDD+oLVZ0FVMFNwfjDE1Pd5yg7CtEHgxIY
# 0F0+tHDfzOoamx6cw176TDcTWYoEYbx5Sh8xd+wUwLIw01xia8Hwi8liSKya05Pr
# pSOSYSDEjT1tSb226lxg0p52DZXPWlnohQ==
# SIG # End signature block
