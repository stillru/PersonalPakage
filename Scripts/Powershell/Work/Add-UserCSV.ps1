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