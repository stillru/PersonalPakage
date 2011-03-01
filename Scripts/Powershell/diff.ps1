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
# NDigggI/MIICOzCCAaigAwIBAgIQDdu47s6KwahLMy9x/eoQPDAJBgUrDgMCHQUA
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
# FgQUlANQbQCiLawYLqeUvzlsWq4nycowDQYJKoZIhvcNAQEBBQAEgYAsm5hIPdvH
# JxW0O486cPO/jxp/R5OKXk35AhFzw5aDiZq4B7A/euUoqqyXsgzfVmWR0vxOI5Gd
# 9tQCRBJKBNXia/K7tf2Oow3k/pY27r3y57hxXlZk74uRiSzxf2GSaPwAM1yESJ1b
# BGLdFkzZjwYSRQ+r2fA1514v7CkY/J2WuQ==
# SIG # End signature block
