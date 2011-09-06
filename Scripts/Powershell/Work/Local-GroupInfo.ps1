$strComputer = "."

$colItems = get-wmiobject -class "Win32_Group" -namespace "root\CIMV2" `
-computername $strComputer -filter "LocalAccount = True"

foreach ($objItem in $colItems) {
      write-host "Caption: " $objItem.Caption
      write-host "Description: " $objItem.Description
      write-host "Domain: " $objItem.Domain
      write-host "Installation Date: " $objItem.InstallDate
      write-host "Local Account: " $objItem.LocalAccount
      write-host "Name: " $objItem.Name
      write-host "SID: " $objItem.SID
      write-host "SID Type: " $objItem.SIDType
      write-host "Status: " $objItem.Status
      write-host
}
# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUPrgmWt6offtNzSLNI1xi7LXU
# Es+gggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
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
# FgQUUJPBvpmLStKnNaMYkhb3CuZmni4wDQYJKoZIhvcNAQEBBQAEgYBy/WJ0o7CD
# fU4ZH80LcKHtJurvtLZBJb0568wMKeS7bQU8Uo9Vqtgcx1MeP0LAd7hjBpu25lRr
# C2no1KDFTnLcXIdPgN9qar5gCSlbnarTJ9hUTiUvX9edk045YxTpUtfRE+q5GhMn
# EYkjxR9nsBk6GVVjCdGLHDBNM4T1iEd3Mg==
# SIG # End signature block
