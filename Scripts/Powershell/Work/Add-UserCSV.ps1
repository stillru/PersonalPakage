import-csv ".\userlist2.csv" | foreach-object {
[string]$ConnectionString = "WinNT://SEVER,computer" 
        $ADSI = [adsi]$ConnecionString 
        $User = $ADSI.Create("user",$_.Name) 
        $User.SetPassword($_.Password) 
        $User.put("description",$_.Description)
        $User.SetInfo()
        $User.put("fullname",$_.Full_Name)
        $User.SetInfo()

[string]$group1 = $_.Main_Group
        write-host $_.Name "created..."
        $name = $_.Name
        write-host $group1 "selected..."
        sleep 10
        $objOU = [ADSI]"WinNT://SEVER/$group1,group"
        $objOU.add("WinNT://SEVER/$name")
[string]$group2 = $_.Secondary_Group
        write-host $group2 "selected..."
        sleep 10
        $objOU = [ADSI]"WinNT://SEVER/$group2,group"
        $objOU.add("WinNT://SEVER/$name")
        write-host "User created and add to groups."
}
