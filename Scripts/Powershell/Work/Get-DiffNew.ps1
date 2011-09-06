<#
   .Synopsis
    Get difference beetwin 2 files
   .Description
    Script for finding changes in two files.
   .Example
    Get-Diff.ps1  file1  file2
   .Inputs
    [string]
   .OutPuts
    [string]
   .Notes
    NAME: Windows 7 Resource Kit
    AUTHOR: Rob van der Woude
    LASTEDIT: 16/03/2011
    KEYWORDS: Signing
   .Link
    http://www.robvanderwoude.com
#Requires -Version 2.0
#>
param( [string]$orgfile, [string]$diffile, [string]$switch )

If ( $diffile -eq "" ) {
	Write-Host
	Write-Host "TxtComp.ps1,  Version 1.00"
	Write-Host "Compare 2 text files and display the differences"
	Write-Host
	Write-Host "Usage:  .\TXTCOMP.PS1  file1  file2  [ /ALL ]"
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

# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGOv0PEfSzOXtd1ybzFca+aqq
# waKgggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
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
# FgQUaxv708fCOqX4Unf2Ef8fvZbTQ8swDQYJKoZIhvcNAQEBBQAEgYBedttkhHwz
# /AhPA/KFoWHShyaCytcWmZQO7aqTk6XfkJY7rDFfgg2Cbr0XNPoiSeoBOOlomT6F
# +F3NHIWPKd6YcBEEEqn/doYYknewGjets88QOh7p5GG4AbiwseShaxVAQTUqSzr3
# tWTogoWjnCtIvnw17Rxd9WalTlSY4afHeg==
# SIG # End signature block
