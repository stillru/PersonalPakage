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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUdqg6h47nRanKF2Ox2IEyWTpJ
# csegggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
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
# FgQUnQEncSwRW6AYEuKNakJZFZjmsLkwDQYJKoZIhvcNAQEBBQAEgYAimEBlbJYB
# PgDmptrto0Rb67OZZHGFCznkSS9CfCAIeAFFqy81FurObsnozJjdZFPYrXJwOAEm
# zkzCsm1sFuOgzwSc9g3ClKnAGTcTGb9EwJfWQVbOIH9wxPXmB1vfZWwI8ExmPtVc
# 6hwAtY7ZBnQlr5nEed4YAHjvGWRobAHbYQ==
# SIG # End signature block
