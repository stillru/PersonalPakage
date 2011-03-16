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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUMIx99VE7SFMHvXJ4u2VfQ/qs
# qYCgggI/MIICOzCCAaigAwIBAgIQ84Pm6xEt3IBIvyjAmjsGQzAJBgUrDgMCHQUA
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
# FgQUJJ8Ol71PwL8PLKw3AKAixGeC9qswDQYJKoZIhvcNAQEBBQAEgYBxtd2OvOXb
# b6Gxg5mRrnsllloAqrqWYCTp0kVzKydhOaqDZS7L+fslJ9iTcoYf6iAnXaQtNuEW
# jHCd0perpYPF+b3zUAGwgzebuX6bUoLn1mdnI5pABAfsIxYO3FLP5/sTxZ8CdPdM
# hc42zqtu6t23zfalLCVxMLqj40qfSLPUAg==
# SIG # End signature block
