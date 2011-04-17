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
# h7KgggI/MIICOzCCAaigAwIBAgIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTA0MTcxMDE3MTdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDNS0UlibCi
# ee8p01vzbsGDrOwycGKHoTTPu4WW2cO5kiZMc9ssT2no5uihGO5/QZi9uLtIFtyk
# AvPj4+WSjOCcvWkh6GRXg3EKxeP31HVyx1tT4p0/hpkQGYbOyHnSr5Rhl/ZsFZqr
# czu3VQWFdNw25+DqFCxAbF4CKXN8oIhFsQIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBDs9tfN4CVX/di6ZfySo+h4oS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghDRk8Je+PxYtkub
# 5OGUg9ziMAkGBSsOAwIdBQADgYEAud9iRB9g/CmubZ5U+lBkpPTyIzuSgoygo35X
# ORewz73XwRMaC7ygSwZTFuBJboVTNUlOZVIDgk4+06JkomqIOeZOkEgYb+Un9Jat
# 1lBlXHAyrYLX/6w9llMFy0zAKQ+iWhdR45/L5mjy3F0qke16tr4Ar7gkQJmy8KCM
# mSL7/eQxggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUcqhPO8lqCvE4Tmu4TfSWJiWIThUwDQYJKoZIhvcNAQEBBQAEgYA+IKQrmPox
# JUqiTykh+Qbf9spVknaT8spUgy6HwCF/tXDeyh/A1yJ4R3SWgefO0t4kuL3/69g1
# YrFd6vcWFajf7PGnT7ZnwCoTHP1UUdmKcX8mrm7d8vpwM22Oa3mxMeLJJ/xcSxim
# /ebKuMKbTOAcafBb+pxbASV/tl1ZQOVWSQ==
# SIG # End signature block
