import-csv ".\u.csv" | foreach-object {
[string]$ConnectionString = "WinNT://$env:computername,computer" 
        $ADSI = [adsi]$ConnectionString 
        $User = $ADSI.Create("user",$_.Name) 
        $User.SetPassword($_.Password) 
        $User.put("description",$_.Description)
        $User.SetInfo()
        $User.put("fullname",$_.Full_Name)
        $User.SetInfo()
		$User.put("PasswordExpired",1)
        $User.SetInfo()
[string]$fullname = $_.Full_Name
[string]$group1 = $_.Main_Group
        write-host $_.Name "created..."
        $name = $_.Name
        write-host $group1 "selected..."
        sleep 2
        $objOU = [ADSI]"WinNT://$env:computername/$group1,group"
        $objOU.add("WinNT://$env:computername/$name")
[string]$group2 = $_.Secondary_Group
        write-host $group2 "selected..."
        sleep 2
        $objOU = [ADSI]"WinNT://$env:computername/$group2,group"
        $objOU.add("WinNT://$env:computername/$name")
[string]$group3 = $_.Users
        write-host $group3 "selected..."
        sleep 2
        $objOU = [ADSI]"WinNT://$env:computername/$group3,group"
        $objOU.add("WinNT://$env:computername/$name")
        write-host "User $name\$fullname on $env:computername created and add to groups $group1, $group2, $group3."
}
#[System.IO.File]::ReadAllText("C:\Dstrib\Scripts\u.csv") | Out-File "C:\Dstrib\Scripts\u-created.csv" -Append -Encoding Unicode
mv ".\u.csv" ".\u-created.csv[1-100]"
del ".\u.csv"
cp ".\Template.csv" ".\u.csv"
write-host "Job done!"
# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU21SSFSC2ITrRLr6pCZ1a1UPa
# klKgggI/MIICOzCCAaigAwIBAgIQEoPtL4boPrtC3SU2buCv8jAJBgUrDgMCHQUA
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
# FgQUz89nme+6d/STDp9o01VeJyQBNq4wDQYJKoZIhvcNAQEBBQAEgYCzs+qj8AXX
# B0azUgK1kZvMmiVxjYySarppdTXkrnTO56X+0PTUsqCqtBr6sEMNDRTL089183yz
# UkKLl/6UV8JvzS+5T06LGVpCNl5msJeg+OAOGCj3T3Sdtrm/HS7VCG69+wJMfNKA
# wx5DFzqloz2uiIo9Z/KFJ16MEaoNR6bl8A==
# SIG # End signature block
