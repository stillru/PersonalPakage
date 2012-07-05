##################################################################################
#
#
#  Script name: Add-STUser.ps1
#  Author:      goude@powershell.nu
#  Modifiy:     Steve Illichevsky (still.ru@gmail.com)
#  Homepage:    www.powershell.nu
#
#
##################################################################################
param ([string]$Domain, [string]$Csv)
function GetHelp() {
$HelpText = @"
ОПИСАНИЕ:
ИМЯ: Add-STUser
Adds Users from the StarTrek Csv File
ПАРАМЕТРЫ: 
-Domain      Имя домена (Обязательно)
-Csv         Файл в формате CVS который используется скриптом (Обязательно)
-help        Вывод справки (Опционально)
СИНТАКСИС:
Add-STUser.ps1 -Domain powershell.nu -Csv C:\MyFOlder\StarTrek.csv
Adds the Users from the Csv file to Active-Directory.
Add-STUser.ps1 -help
Показывает справку по этому скрипту (этот текст)
Дополнительная информация:
CSV-файл построен следующим образом.
Character, Position, Rank, Department, Species, Starship, Class, Registry, Series, Location
Jean-Luc Picard, Commanding Officer, Captain, Main Bridge,  Human, USS Enterprise (NCC-1701-D), Galaxy, NCC-1701-d, Star Trek: The Next Generation, Alpha Quadrant

Версии:
0.1
- Инициация

0.2
+ Добавлена генерация LDIF для импорта в OpenLDAP
+ Добавлена генерация maildirmake файла для генерации maildir
"@
$HelpText
}

function global:TranslitToLAT
{
            param([string]$inString)
			
	$Translit_To_LAT = @{ 
	[char]'а' = "a"
	[char]'А' = "A"
	[char]'б' = "b"
	[char]'Б' = "B"
	[char]'в' = "v"
	[char]'В' = "V"
	[char]'г' = "g"
	[char]'Г' = "G"
	[char]'д' = "d"
	[char]'Д' = "D"
	[char]'е' = "e"
	[char]'Е' = "E"
	[char]'ё' = "yo"
	[char]'Ё' = "Yo"
	[char]'ж' = "zh"
	[char]'Ж' = "Zh"
	[char]'з' = "z"
	[char]'З' = "Z"
	[char]'и' = "i"
	[char]'И' = "I"
	[char]'й' = "j"
	[char]'Й' = "J"
	[char]'к' = "k"
	[char]'К' = "K"
	[char]'л' = "l"
	[char]'Л' = "L"
	[char]'м' = "m"
	[char]'М' = "M"
	[char]'н' = "n"
	[char]'Н' = "N"
	[char]'о' = "o"
	[char]'О' = "O"
	[char]'п' = "p"
	[char]'П' = "P"
	[char]'р' = "r"
	[char]'Р' = "R"
	[char]'с' = "s"
	[char]'С' = "S"
	[char]'т' = "t"
	[char]'Т' = "T"
	[char]'у' = "u"
	[char]'У' = "U"
	[char]'ф' = "f"
	[char]'Ф' = "F"
	[char]'х' = "x"
	[char]'Х' = "X"
	[char]'ц' = "c"
	[char]'Ц' = "C"
	[char]'ч' = "ch"
	[char]'Ч' = "Ch"
	[char]'ш' = "sh"
	[char]'Ш' = "Sh"
	[char]'щ' = "shh"
	[char]'Щ' = "Shh"
	[char]'ъ' = ""		# "``"
	[char]'Ъ' = ""		# "``"
	[char]'ы' = "y"		# "y`"
	[char]'Ы' = "Y"		# "Y`"
	[char]'ь' = ""		# "`"
	[char]'Ь' = ""		# "`"
	[char]'э' = "e"		# "e`"
	[char]'Э' = "E"		# "E`"
	[char]'ю' = "yu"
	[char]'Ю' = "Yu"
	[char]'я' = "ya"
	[char]'Я' = "Ya"
	}
	$outChars=""
	
	foreach ($c in $inChars = $inString.ToCharArray())
	{
		if ($Translit_To_LAT[$c] -cne $Null ) 
		{
			$outChars += $Translit_To_LAT[$c]
		}
		else
		{
			$outChars += $c
		}
	
	}
	
	Write-Output $outChars
 
}
function Get-Csv ([string]$Domain, [string]$Csv) {
	$CsvFile = Import-Csv $Csv
	$CsvFile | ForEach {
		Add-User -Domain $Domain -Character $_.Character -Position $_.Position -Rank $_.Rank -Department $_.Department -Species $_.Species -Starship $_.Starship -Series $_.Series -Location $_.Location
	}
}

function Add-User ([string]$Domain, [string]$Character, [string]$Position, [string]$Rank, [string]$Department, [string]$Species, [string]$Starship, [string]$Series, [string]$Location) {
	# Set up AD Connectionstring
	$Connection = $Series.Insert(0,"LDAP://OU=" + $Department +",OU=Users,OU=") + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")
	# Check Character Name
	$CharacterName = $Character.Split(" ")
	if (($CharacterName.Count) -le 1) {
		# Character Doesn't have a SurName
		[string]$givenName = $CharacterName
		[string]$sn = "Unknown"
		# Check if givenName contains Less than 6 Characters
		if ($givenName.Length -lt 6) {
			$AddNum = 6 - $givenName.Length
			# Build Last Part Of cn
			for ($i = 0; $i -lt ($AddNum -1); $i ++) { $AddTocn += "0" }
			$AddTocn += "1"
			[string]$sAMAccountName = ($givenName).ToLower() + $Addtocn
			$cn = $givenName
			# Set Checker to Null
			$AddTocn = $Null
		} else {
			[string]$sAMAccountName = ($givenName.SubString(0,6)).ToLower()
			$cn = $givenName
		}
	} else {
		[string]$givenName = $CharacterName[0..($CharacterName.Count -2)]
		[string]$sn = $CharacterName[($CharacterName.Count -1)]
		# Check if givenName contains Less than 3 Characters
		if ($givenName.Length -lt 3 -AND $sn.Length -lt 3) {
			$Tempcn = $givenName + $sn
			$AddNum = 3 - $Tempcn.Length
			# Build Last Part Of cn
			for ($i = 0; $i -lt ($AddNum -1); $i ++) { $AddTocn += "0" }
			$AddTocn += "1"
			[string]$sAMAccountName = ($Tempcn).ToLower() + $Addtocn
			$cn = $givenName
			# Set Checker to Null
			$AddTocn = $Null
		} elseif ($givenName.Length -lt 3 -OR $sn.Length -lt 3) {
			$Tempcn = $givenName + $sn
			[string]$sAMAccountName = ($Tempcn.SubString(0,6)).ToLower()
			$cn = $givenName + " " + $sn
		} else {
			[string]$sAMAccountName = ($givenName).ToLower() + "." + ($sn.SubString(0,1)).ToLower()
			$cn = $givenName + " " + $sn
		}
	}
	# Check sAMAccountName
	Check-sAMAccountName -Domain $Domain -User $sAMAccountName
	if ($sAMAccountNameDoesntExist -eq $True) {
	} else {
		While ($Script:sAMAccountNameDoesntExist -eq $False) {
			# Create New sAMAccountName
			$LastChar = $sAMAccountName.SubString($sAMAccountName.Length -1)
			if(1..9 -Contains $LastChar) {
				$sAMAccountName = ($sAMAccountName.TrimEnd([string]$LastChar)) + ([int]$LastChar + 1)
			} else {
				$sAMAccountName = $sAMAccountName + 1
			}
			Check-sAMAccountName -Domain $Domain -User $sAMAccountName
		}
	}
	# Check if User Already Exists
	$distinguishedName = "CN=" + $cn + ",OU=" + $Department + ",OU=Users,OU=" + $Series + ($Domain.Replace(".",",DC=")).Insert(0,",DC=")
	Check-distinguishedName -Domain $Domain -User $distinguishedName
	if ($distinguishedNameDoesntExist -eq $True) {
		# Set Up Variables
		$enCharacter=TranslitToLAT($Character)
		$ensAMAccountName=TranslitToLAT($sAMAccountName)
		$LastChar = $ensAMAccountName.SubString($sAMAccountName.Length -1)
		$engivenName=TranslitToLAT($givenName)
		$ensn=TranslitToLAT($sn)
		$Description = $Position + " (" + $Species + ")"
		$Title = $Rank
		$physicalDeliveryOfficeName = $Starship
		$userPrincipalName = $sAMAccountName + "@OFFICE"
		[string]$mail = ([string]$engivenName) + "." + ([string]$LastChar) + "@mega-lex.ru"
		# Get A Unique Password
		[string]$Password = Generate-Password
		
		# Create User in AD
		$userPrincipalName2=TranslitToLAT($userPrincipalName)
		
		$OU = [adsi] $Connection
		$User = $OU.Create("user", "cn=$cn")
		$User.Put("sAMAccountName", $ensAMAccountName)
		$User.Put("userPrincipalName", $userPrincipalName2)
		$User.Put("DisplayName", $cn)
		$User.Put("givenName", $givenName)
		$User.Put("sn", $sn)
		$User.Put("Description", $Description)
		$User.Put("l", $Starship)
		$User.Put("streetAddress",$Location)
		$User.Put("physicalDeliveryOfficeName", $physicalDeliveryOfficeName)
		$User.Put("Title", $Title)
		$User.Put("Department", $Department)
		$User.Put("Company", $Starship)
		$User.Put("mail", $mail)
		$User.SetInfo()
		# Set Random Pwd and Enable Account
		$User.PsBase.Invoke("SetPassword", $Password)
		$User.PsBase.InvokeSet("AccountDisabled", $false)
		$User.SetInfo()
		# Write Pwd to File
		$FileName = "PasswordList " + (get-date -uformat "%Y-%m-%d") + ".txt"
		"$enCharacter,$userPrincipalName2,$Password" | Add-Content $FileName
		Write-Host "Added User: $Character" -ForegroundColor Green
		$LDIFFile = "mega-lex.ru-" + $ensAMAccountName + ".ldif"
		"dn: cn=" + $cn + ",ou=OFFICE,o=MegaLex,l=Moscow,o=bd,dc=mega-lex,dc=ru" | Add-Content Temp.txt
		"objectClass: top" | Add-Content Temp.txt
		"objectClass: person" | Add-Content Temp.txt
		"objectClass: organizationalPerson" | Add-Content Temp.txt
		"objectClass: inetOrgPerson" | Add-Content Temp.txt
		"objectClass: posixAccount" | Add-Content Temp.txt
		"objectClass: inetLocalMailRecipient" | Add-Content Temp.txt
		"objectClass: OpenLDAPperson" | Add-Content Temp.txt
		"company: MEGALEX_MOS_OFFICE" | Add-Content Temp.txt
		"o: MEGALEX_MOS_OFFICE" | Add-Content Temp.txt
		"homeDirectory: /mail/mega-lex.ru/" + $ensAMAccountName  | Add-Content Temp.txt
		"maildrop: Maildir/" | Add-Content Temp.txt
		"mailAccessValue: OK" | Add-Content Temp.txt
		"uidNumber: 143" | Add-Content Temp.txt
		"gidNumber: 143" | Add-Content Temp.txt
		"mailAliasKey: $mail" | Add-Content Temp.txt
		"cn: $cn" | Add-Content Temp.txt
		"sn: $sn" | Add-Content Temp.txt
		"givenName: $givenName" | Add-Content Temp.txt
		"initials: " + $cn.Substring(0,1) + " " + $sn.Substring(0,1) | Add-Content Temp.txt
		"title: $Title"| Add-Content Temp.txt
		"postalAddress: $Location"| Add-Content Temp.txt
		"ou: $Department"| Add-Content Temp.txt
		"department: $Department"| Add-Content Temp.txt
		"mail: $mail"| Add-Content Temp.txt
		"mailAliasValue: $mail"| Add-Content Temp.txt
		"uid: $mail"| Add-Content Temp.txt
		"sogouid: $ensAMAccountName" | Add-Content Temp.txt
		"mailquota: 1000000000" | Add-Content Temp.txt
		
		$enc = [system.Text.Encoding]::UTF8
		$data1 = $enc.GetBytes($Password) 
		# Create a New SHA1 Crypto Provider 
		$sha = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 
		# Now hash and display results 
		$result1 = $sha.ComputeHash($data1)
		"userPassword: {SHA}" + [System.Convert]::ToBase64String($result1) | Add-Content Temp.txt 
		$mystrings= gc Temp.txt 
		$mystrings[1]=$mystrings[1].Remove(1,3)
		$mystrings | sc Temp.txt 
		[string]::Join( "`n", (gc Temp.txt )) | sc $LDIFFile
		rm Temp.txt
		Write-Host "Ldif Created: mega-lex.ru-$ensAMAccountName.ldif" -ForegroundColor Green
		$Maildirmake = $mail + ".maildirmake"
		"mega-lex.ru	$ensAMAccountName	SSHA	$Password"| Add-Content Temp.txt 
		[string]::Join( "`n", (gc Temp.txt )) | sc $Maildirmake
		rm Temp.txt
		Write-Host "maildirmake file Created: $mail.maildirmake"
	} else {
		Write-Host "User: $Character already exists" -ForegroundColor Yellow
	}
	# Set Check Variable to False
	$Password = $Null
	$Script:sAMAccountNameDoesntExist = $False
	$Script:distinguishedNameDoesntExist = $False
}
function Generate-Password {
	$Random = New-Object System.Random
	# Two Upper Case Characters
	[string]$Password += [char]$Random.Next(49,57)
	[string]$Password += [char]$Random.Next(65,72)
	# Two LowerCase Characters
	[string]$Password += [char]$Random.Next(97,107)
	[string]$Password += [char]$Random.Next(109,122)
	# One Special Char
	[string]$Password += [char]$Random.Next(36,43)
	# Two UpperCase Characters
	[string]$Password += [char]$Random.Next(65,72)
	[string]$Password += [char]$Random.Next(80,91)
	# One LowerCase
	[string]$Password += [char]$Random.Next(97,107)
	$Password
	$Password = $Null
}
function Check-distinguishedName ([string]$Domain, [string]$User) {
	trap {  $Script:distinguishedNameDoesntExist = $True ; continue } .\Get-AD.ps1 -Domain $Domain -User $User -filter distinguishedName | Out-Null
}
function Check-sAMAccountName ([string]$Domain, [string]$User) {
	trap {  $Script:sAMAccountNameDoesntExist = $True ; continue } .\Get-AD.ps1 -Domain $Domain -User $User -Filter sAMAccountName | Out-Null
}
if ($help) { 
	GetHelp 
} elseif ($Domain -AND $Csv) {
	Get-Csv -Domain $Domain -Csv $Csv
} else {
	GetHelp
}
