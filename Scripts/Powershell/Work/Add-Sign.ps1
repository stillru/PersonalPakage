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
# MIIEMwYJKoZIhvcNAQcCoIIEJDCCBCACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzbno5CGau4Y74eI8EJQGbO7h
# 7+qgggI9MIICOTCCAaagAwIBAgIQfXHm82OTkaNDQzwXvfMI5DAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTA0MTEwNjI3MjRaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAzP+/+b9knWIu
# fZK9UNGCerrf2h3w4J4UgSc4dGD/56ESpksQOdwmi2bctS7tlrkZ6Y5pku/nsAmG
# ZqbnUxntJEcgfvKtWv5mA/g1eeufXdsw+oBxqbXNh535958oCudb1WvDIDzz95pu
# 2S+c0RvoKWiEHU8vKplOz5zMHaiPjiUCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQeEOpEWd7Qf5bIJNi2jsFfKEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQpcD6Z9YUkYdPu8sg
# irXtxzAJBgUrDgMCHQUAA4GBAFXqR4un+bezGhvhcZjGaDHCBI3Z5z8ZqZ91Ili2
# o+jd0K1zJTkDcS3517XXtNSnfg8JCtWbtra3aP4YhrTwl/uHG65QntQvrogBb+SP
# 2in5yC3Fn1/03sFIFDdJUlQfiu/3HirlYflkQ09cK+M7M6nX/z/IR/LyhqMwIFiU
# aZPnMYIBYDCCAVwCAQEwQDAsMSowKAYDVQQDEyFQb3dlclNoZWxsIExvY2FsIENl
# cnRpZmljYXRlIFJvb3QCEH1x5vNjk5GjQ0M8F73zCOQwCQYFKw4DAhoFAKB4MBgG
# CisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcC
# AQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYE
# FDQw5v5/l4HUdBRnPhc/DsV2Vju+MA0GCSqGSIb3DQEBAQUABIGALsWf6NzZbw21
# UIMFwtTXDvuWjGHChL7Z9tW7v4mO/UCfVw3KzPW+KQ5PJyjbE1XQfApiasWUqkjJ
# FuMu7uwHYWjkPMI5nKwssC8MwilsWzEmaFUPvQfm6Y+66UJJgmmHjoL7WFL8NOIU
# j/2u29dDT7+Nuy8+oqJHHRpYCCoCwMY=
# SIG # End signature block
