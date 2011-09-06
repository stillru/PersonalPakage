<#
   .Synopsis
    Add signiture for file.
   .Description
    Script for signing any file. 
   .Example
    Add-Sign.ps1 -file SomeScript.ps
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
    Http://stillru.github.com
#Requires -Version 2.0
#>
param([string] $file=$(throw "Please specify a filename."))
$cert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
Set-AuthenticodeSignature $file $cert
# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUgtZXg3OrDIgR5Wk7KNjyuZvr
# h7KgggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
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
# FgQUcqhPO8lqCvE4Tmu4TfSWJiWIThUwDQYJKoZIhvcNAQEBBQAEgYAsZ1ATzDKo
# Y4qnXzlVD3iIxr7PeeXl0HqO8RjUYvhEoMqrspxXRK8u95oVSEZpASi7BpCwyHch
# 51KyroHXFyXAuHM2VWzF6LPq39N0fnFSTfiGUT1te1sUWS8htYKZVpBBqaDScX27
# TmM+3XMM7xm8k3XYk/M3ps/VJWLUeNBBSw==
# SIG # End signature block
