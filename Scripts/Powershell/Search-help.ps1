#############################################################################
#
# Search-Help.ps1
#
# Search for PowerShell help documentation for a given keyword or reg-exp
#
# Example:
#  Search-help hashtable
#  Search-help "(datetime|ticks)"
#############################################################################

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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUftd2DWWQuvJgMbh7vIYQss57
# Br6gggI/MIICOzCCAaigAwIBAgIQDdu47s6KwahLMy9x/eoQPDAJBgUrDgMCHQUA
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
# FgQUX5NXULT7p+B1d25+2Npl4cJkpGkwDQYJKoZIhvcNAQEBBQAEgYA7dnHyMoN9
# 8NijePaw3kA6DnCfHfFjl7FvWmjqCXV//sPm0DQAoxHszicciRGt17BD+B7mqWCZ
# U3rMxijCAdkSjJUsy7gNqcmGP2JZDp7ww1DnEGxgzUGOfzQ+SvIHgvD1RBqLIfyY
# 7op3qmK3ZkSsmdcVLO+drNLyHefheBgNPw==
# SIG # End signature block
