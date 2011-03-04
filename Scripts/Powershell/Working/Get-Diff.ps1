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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+wgdnEM6+Qly5Rw5jA+5Nuu9
# NDigggI/MIICOzCCAaigAwIBAgIQ84Pm6xEt3IBIvyjAmjsGQzAJBgUrDgMCHQUA
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
# FgQUlANQbQCiLawYLqeUvzlsWq4nycowDQYJKoZIhvcNAQEBBQAEgYCogKfs1hBy
# 5IphetwU+OWUHUw150msOgo3Qeuj+vPuj5H6bZITUiTKuChzjCLB6/J0f193meX8
# 3GEfwQkhRnPq6KkVUtLoEv+h/dyyK58PgdNQcCnwHvw/LwtZSiFzg7DXWV8Fkhr9
# SoiwaVVHwXVRqmah65pzYiidPcv5RV2zoA==
# SIG # End signature block
