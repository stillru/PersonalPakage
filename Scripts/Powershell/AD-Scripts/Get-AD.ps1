##################################################################################
#
#
#  Script name: Get-AD.ps1
#  Author:      goude@powershell.nu
#  Homepage:    www.powershell.nu
#
#
##################################################################################

param ([string]$Domain, [string]$OU, [string]$User, [string]$Group, [string]$Computer, [string]$Filter = ("name"),[string]$CustomFilter, [string]$CustomAll, [string]$Property = ("AllProperties"), [string]$ToCsv, [switch]$ToObject, [int32]$IncreasePageSize = (0), [switch]$help)

function GetHelp() {


$HelpText = @"

ОПИСАНИЕ

ИМЯ: Get-AD.ps1
Gets Information About Objects in Active-Directory

ПАРАМЕТРЫ:
-Domain            Имя домена (Обязательно)
-OU                Имя организационной единицы (Опционально)
-User              Name of the User (Опционально)
-Group             Name of the Group (Опционально)
-Computer          Name of the Computer (Опционально)
-Filter            Filter on Specified Criteria, default is name (Опционально)
-CustomFilter      Create A custom SearchFilter That Searches for One Object (Опционально)
-CustomAll         Create A Custom SerachFilter That Searches For One OR more Objects (Опционально)
-Property          Specify one or more Properties to Return, default set to All Properties (Опционально)
-ToCsv             Saves the Output to a Csv File (Опционально)
-ToObject          Returns a System.DirectoryServices.DirectoryEntry Object (Опционально)
-IncreasePageSize  Exceeds the default limit of 1000 Objects (Опционально)
-help              Вывод справки (Опционально)

СИНТАКСИС:


-Domain Parameter
-------------------------------------------------------------------------------------------------------

The Domain Parameter is the Only parameter that is ((Обязательно)) in the Script.
Specify Which Domain You want to Connect to.

Below are Examples Using the Domain Parameter:


.\Get-AD.ps1 -Domain apa.corp

Returns Information about the Domain.

`$Domain = ./Get-AD.ps1 -Domain apa.corp -ToObject

Returns a System.DirectoryServices.DirectoryEntry Object
and stores it in the variable `$Domain.

.\Get-AD.ps1 -Domain apa.corp -ToCsv C:\MyFolder\MyFile.csv

Stores the Information collected in MyFile.csv

.\Get-AD.ps1 -Domain apa.corp -Property name, distinguishedName

Returns the name and distinguishedName to the Host

.\Get-AD.ps1 -Domain apa.corp -Property name, distinguishedName -ToCsv C:\MyFolder\MyFile.csv

Stores the information from name and distinguishedName
in a Csv file.


-OU Parameter
-------------------------------------------------------------------------------------------------------

The OU Parameter Let's you search for a OrganizationalUnit in the Domain

Below are Examples Using the OU Parameter:


.\Get-AD.ps1 -Domain apa.corp -OU Sites

Returns Information about the OrganizationalUnit Sites

.\Get-AD.ps1 -Domain apa.corp -OU AllOU

Returns Information about all OrganizationalUnits

.\Get-AD.ps1 -Domain apa.corp -OU AllOU -Property distinguishedName,l -ToCsv C:\MyFolder\MyOUFile.csv

Stores distinguishedName and Location in a Csv file

-User Parameter
-------------------------------------------------------------------------------------------------------

The User Parameter Let's you search for a User in the Domain

Below are Examples Using the User Parameter:


.\Get-AD.ps1 -Domain apa.corp -User nigo

Returns information from the first found user called nigo

.\Get-AD.ps1 -Domain apa.corp -User nigo -filter sAMAccountName

Gets the user with the sAMAccountName apa\nigo

.\Get-AD.ps1 -Domain apa.corp -User AllUsers

Returns All Users in Active-Directory

.\Get-AD.ps1 -Domain apa.corp -User AllUsers -Property name,l -IncreasePageSize 1000 -ToCsv C:\MyFolder\MyUsers.csv

Exceeds the default Searchlimit of 1000 and stores name and location for all 
users in MyUsers.csv

`$User = .\Get-AD.ps1 -domain apa.corp -User nigo -Filter sAMAccountName

Returns a System.DirectoryServices.DirectoryEntry Object
and stores it in the variable `$User.

-Group Parameter
-------------------------------------------------------------------------------------------------------

The Group Parameter Let's you search for a Group in the Domain

Below are Examples Using the Group Parameter:


.\Get-AD.ps1 -Domain apa.corp -Group MyGroup

Returns information from the group Called MyGroup

.\Get-AD.ps1 -Domain apa.corp -Group MyGroup -filter sAMAccountName

Gets the user with the sAMAccountName MyGroup

`$Group = .\Get-AD.ps1 -domain apa.corp -Group 268435456 -filter sAMAccountType

Returns a System.DirectoryServices.DirectoryEntry Object where
sAMAccountType equals 268435456 and stores it in the variable `$Group.

.\Get-AD.ps1 -Domain apa.corp -Group AllGroups

Returns All Groups in Active-Directory

.\Get-AD.ps1 -Domain apa.corp -Group AllGroups -Property name, distinguishedName -ToCsv C:\MyFolder\MyGroups.csv

stores name and distinguishedName for the first 1000 groups in MyGroups.csv

-Computer Parameter
-------------------------------------------------------------------------------------------------------

The COmputer Parameter Let's you search for a Computer in the Domain

Below are Examples Using the Computer Parameter:


.\Get-AD.ps1 -Domain apa.corp -Computer Client1

Returns information from Client1

.\Get-AD.ps1 -Domain apa.corp -Computer CLIENT1$ -filter sAMAccountName

Gets the Client with the sAMAccountName CLIENT1$

.\Get-AD.ps1 -Domain apa.corp -Computer AllComputers

Returns All Computers in Active-Directory

.\Get-AD.ps1 -Domain apa.corp -User AllGroups -Property name -ToCsv C:\MyFolder\MyComputers.csv

Stores all ComputerNames in a Csv file Called MyComputers.csv


-Filter Parameter
-------------------------------------------------------------------------------------------------------

The Filter Parameter is used to change the SearchFilter. 
The Default filter for Users is: (&(objectClass=User)(name=UserToSearchFor))

Changing the -Filter parameter to sAMAccountName let's you specify the sAMAccountName instead.
This could be a good idea if you have 2 users with the same name "CN", since the script only retrieves
the first one found.

Say you have 2 users named User1. They are placed in different OU:s.

Their sAMAccountNames are:

User1
User01

If we look at their distinguishedName:

CN=user1,OU=Site1 Users,OU=Site1,OU=Sites,DC=apa,DC=corp
CN=user1,OU=Site2 Users,OU=Site2,OU=Sites,DC=apa,DC=corp

Running the Following Command Would Return User1 in Site1.

.\Get-AD.ps1 -Domain apa.corp -User User1

Bu say i want User2 instead. To achieve this I can use the -Filter Property as shown below:


.\Get-AD.ps1 -Domain apa.corp -User User01 -filter sAMAccountName

Or we can Filter on distinguishedName

.\Get-AD.ps1 -Domain apa.corp -User "CN=user1,OU=Site2 Users,OU=Site2,OU=Sites,DC=apa,DC=corp" -filter distinguishedName

-CustomFilter Parameter
-------------------------------------------------------------------------------------------------------

The -CustomFilter Parameter let's you enter Custom Filters instead of the Default.
The CustomFilter Parameter only Searches for 1 Object, the First one Found

Example:

.\Get-AD.ps1 -Domain apa.corp -CustomFilter "(&(ObjectCategory=group)(whenCreated>=20081201000000.0Z))"


This Returns the First Group Found that meets the Filter criteria

-CustomAll Parameter
-------------------------------------------------------------------------------------------------------

The -CustomAll Parameter let's you Search for One or More Objects.

.\Get-AD.ps1 -Domain apa.corp -CustomAll "(&(ObjectCategory=group)(whenCreated>=20081201000000.0Z))"

Returns All Groups meeting the Criteria

-Property Parameter
-------------------------------------------------------------------------------------------------------

By Default, -Property returns all Properties displayed by PsBase.Properties. If You want to Display
specific Properties you can use this Parameter:

.\Get-AD.ps1 -Domain apa.corp -User User1 -Filter sAMAccountName -Property name, department, wWWHomePage, ipPhone

This returns the Specified Properties from the User Object. If a Property is Not set, the script returns
the Value Unknown.

-ToCsv Parameter
-------------------------------------------------------------------------------------------------------

The -ToCsv Parameter let's you write the information to a Csv File instead of returning it to the Host.
If you want a List of all computers in your domain you can run the following Command:

.\Get-AD.ps1 -Domain apa.corp -User AllGroups -Property name -ToCsv C:\MyFolder\MyComputers.csv

If you want all Users and their Mail Address you can run the Following Command:

.\Get-AD.ps1 -Domain apa.corp -User AllUsers -Property cn, mail

-ToObject Parameter
-------------------------------------------------------------------------------------------------------

The -ToObject Parameter returns a System.DirectoryServices.DirectoryEntry Object that you work with.

`$User1 = .\Get-AD.ps1 -Domain apa.corp -User User1 -ToObject

This returns a System.DirectoryServices.DirectoryEntry Object Based on User1.
You can now Work With the Object.


`$Users = .\Get-AD.ps1 -Domain apa.corp -User AllUsers -ToObject

This returns System.DirectoryServices.DirectoryEntry Objects Based on All Users.
If you want to Access the First User:

`$Users[0]

If you want a specific User in the Object you can get get it through Where-Object CmdLet

`$Users | Where { `$_.sAMAccountName -match "User1" }


-Help Parameter
-------------------------------------------------------------------------------------------------------

./Get-AD.ps1 -help

Показывает справку по этому скрипту (этот текст)

-------------------------------------------------------------------------------------------------------

"@
$HelpText

}

function Get-AD ([string]$Domain, [string]$OU, [string]$User, [string]$Group, [string]$Computer, [string]$Filter, [string]$CustomFilter, [string]$CustomAll, [string]$Property, [string]$ToCsv, [switch]$ToObject, [int32]$IncreasePageSize) {

	# Set up SearchFilter

	if ($CustomFilter) {

		# Set up Control Variable

		[bool]$SearchAll = $False

		$SearchFilter = $CustomFilter

	} elseif ($CustomAll) {

		# Set up Control Variable

		[bool]$SearchAll = $True

		$SearchFilter = $CustomAll

	} elseif ($OU -eq "AllOU" -OR $User -eq "AllUsers" -OR $Group -eq "AllGroups" -OR $Computer -eq "AllComputers") {

		# Set up Control Variable

		[bool]$SearchAll = $True

		if ($OU) {
			$SearchFilter = '(objectClass=OrganizationalUnit)'
		} elseif ($User) {
			$SearchFilter = '(&(objectClass=person)(!(objectClass=Computer)'
		} elseif ($Group) {
			$SearchFilter = '(objectClass=Group)'
		} elseif ($Computer) {
			$SearchFilter = '(objectClass=Computer)'
		} else {
			$SearchFilter = $Null
		}
	} else {

		# Set up Control Variable

		[bool]$SearchAll = $False

		if ($OU) {
			$SearchFilter = "(&(objectClass=OrganizationalUnit)($Filter=$OU))"
		} elseif ($User) {
			$SearchFilter = "(&(objectClass=User)(&($Filter=$User)(!(objectClass=Computer))"
		} elseif ($Group) {
			$SearchFilter = "(&(objectClass=Group)($Filter=$Group))"
		} elseif ($Computer) {
			$SearchFilter = "(&(objectClass=Computer)($Filter=$Computer))"
		} else {
			$SearchFilter = $Null
		}
	}

	# Build up ConnectionString

	$Connection = $Null

	# Check if Path is Correct

	if ($Domain -match "[dc=a-z],[dc=a-z]") {

		# Check if LDAP:// is added

		if ($Domain -match "LDAP://") {

			$Connection = $Domain

		} else {

			$Connection = $Domain.Insert(0,"LDAP://")
		}
	} else {

		$Domain.Split("\.") | ForEach { $Connection += "DC=$_," }
		$Connection = $Connection.TrimEnd(",")
		$Connection = $Connection.Insert(0,"LDAP://")
	}

	# Connect To AD

	$AD = [adsi]$Connection

	# Check Properties Selected

	if ($Property -eq "AllProperties") {

	} else {
		$Properties = $Property.Split(", ")
	}

	# Create Custom Object that Holds Information

	$ADObject = New-Object PsObject

	# Check if only Domain Information is ((Обязательно))

	if($SearchFilter -eq $Null) {

		# Return Information Regarding Domain

		if ($ToObject -eq $True) {

			# Return a System.DirectoryServices.DirectoryEntry Object

			return $AD

		} else {

			# Set up Property Variables

			$DomainProperties = $AD.PsBase.Properties
			$DomainPropertyNames = $AD.PsBase.Properties.PropertyNames

			# Check Properties to Retrieve

			if ($ToCsv) {

				# Write Information Retrieved to a Csv File

				if ($Property -eq "AllProperties") {

					$DomainPropertyNames | ForEach {

						$Name = $_
						$Name = $Name.ToString()

						$Value = $DomainProperties[$Name]
						$Value = $Value.ToString()

						if($Value -eq $Null) {
							$Value = "Unknown"
						}

						$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
					}
					# Export Information To Csv

					$ADObject | Export-Csv $ToCsv -noTypeInformation
				} else {
	
					$Properties | ForEach {

						$Name = $_
	
						if ($DomainProperties[$Name]) {
							$Value = $DomainProperties[$Name]
							$Value = $Value.ToString()
						} else {
							$Value = "Unknown"
						}
						$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
					}
					# Export Information To Csv

					$ADObject | Export-Csv $ToCsv -noTypeInformation
				}
			} else {

				# Return Information to Host

				if ($Property -eq "AllProperties") {

					$DomainPropertyNames | ForEach {

						$Name = $_
						$Name = $Name.ToString()

						$Value = $DomainProperties[$Name]
						$Value = $Value.ToString()

						if($Value -eq $Null) {
							$Value = "Unknown"
						}

						$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
					}
					# Return Information

					return $ADObject
				} else {
	
					$Properties | ForEach {

						$Name = $_
	
						if ($DomainProperties[$Name]) {
							$Value = $DomainProperties[$Name]
							$Value = $Value.ToString()
						} else {
							$Value = "Unknown"
						}
						$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
					}
					# Return Information

					return $ADObject
				}
			}
		}
	} else {

		# Set up DirectorySearcher

		$Searcher = New-Object System.DirectoryServices.DirectorySearcher $AD

		# Check if Search Applies to One or All

		if($SearchAll -eq $True) {

			# Collect Information through DirectorySearcher

			$Searcher.Filter = $SearchFilter
			$Searcher.PageSize = $IncreasePageSize
			$SearchResult = $Searcher.FindAll()

			if ($ToObject) {

				# Return all matching System.DirectoryServices.DirectoryEntry Object

				$SearchResult | ForEach {

					$ObjectConnectionString = ($_.Path).ToString()
					$ObjectConnection = [adsi]$ObjectConnectionString

					return $ObjectConnection
				}
			} else { 

				if ($ToCsv) {

					# Connect to Each Matching Object And Export Information to a Csv file

					$ADObject = $SearchResult | ForEach {

						# Set Up CustomObject
						$AllObjects = $Null
						$AllObjects = New-Object PsObject

						$ObjectConnectionString = ($_.Path).ToString()
						$ObjectConnection = [adsi]$ObjectConnectionString

						$ObjectProperties = $ObjectConnection.PsBase.Properties
						$ObjectPropertyNames = $ObjectConnection.PsBase.Properties.PropertyNames

						if ($Property -eq "AllProperties") {

							$ObjectPropertyNames | ForEach {

								$Name = $_
								$Name = $Name.ToString()

								$Value = $ObjectProperties[$Name]
								$Value = $Value.ToString()

								if($Value -eq $Null) {
									$Value = "Unknown"
								}

								$AllObjects | Add-Member -memberType NoteProperty $Name -Value $Value
							}
							$AllObjects
						} else {
							$Properties | ForEach {

								$Name = $_
	
								if ($ObjectProperties[$Name]) {
									$Value = $ObjectProperties[$Name]
									$Value = $Value.ToString()
								} else {
									$Value = "Unknown"
								}
								$AllObjects | Add-Member -memberType NoteProperty $Name -Value $Value
							}
							$AllObjects
						}
					}
					$ADObject | Export-Csv $ToCsv -noTypeInformation
				} else {
					# Return Objects To Host

					$ADObject = $SearchResult | ForEach {

						# Set Up CustomObject
						$AllObjects = $Null
						$AllObjects = New-Object PsObject

						$ObjectConnectionString = ($_.Path).ToString()
						$ObjectConnection = [adsi]$ObjectConnectionString

						$ObjectProperties = $ObjectConnection.PsBase.Properties
						$ObjectPropertyNames = $ObjectConnection.PsBase.Properties.PropertyNames

						if ($Property -eq "AllProperties") {

							$ObjectPropertyNames | ForEach {

								$Name = $_
								$Name = $Name.ToString()

								$Value = $ObjectProperties[$Name]
								$Value = $Value.ToString()

								if($Value -eq $Null) {
									$Value = "Unknown"
								}

								$AllObjects | Add-Member -memberType NoteProperty $Name -Value $Value
							}
							$AllObjects
						} else {
							$Properties | ForEach {

								$Name = $_
	
								if ($ObjectProperties[$Name]) {
									$Value = $ObjectProperties[$Name]
									$Value = $Value.ToString()
								} else {
									$Value = "Unknown"
								}
								$AllObjects | Add-Member -memberType NoteProperty $Name -Value $Value
							}
							$AllObjects
						}
					}
					$ADObject
				}
			}			
		} else {

			# Collect Information through DirectorySearcher

			$Searcher.Filter = $SearchFilter
			$SearchResult = ($Searcher.FindOne()).GetDirectoryEntry()

			# Searching for all

			if ($ToObject) {

				# Return a System.DirectoryServices.DirectoryEntry Object

				return $SearchResult

			} else {

				# Set Up Properties

				$ObjectProperties = $SearchResult.PsBase.Properties
				$ObjectPropertyNames = $SearchResult.PsBase.Properties.PropertyNames

				if ($ToCsv) {
					# Write Information Retrieved to a Csv File

					if ($Property -eq "AllProperties") {

						$ObjectPropertyNames | ForEach {

							$Name = $_
							$Name = $Name.ToString()

							$Value = $ObjectProperties[$Name]
							$Value = $Value.ToString()

							if($Value -eq $Null) {
								$Value = "Unknown"
							}

							$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
						}

						# Export Information To Csv

						$ADObject | Export-Csv $ToCsv -noTypeInformation
					} else {
	
						$Properties | ForEach {

							$Name = $_
	
							if ($DomainProperties[$Name]) {
								$Value = $DomainProperties[$Name]
								$Value = $Value.ToString()
							} else {
								$Value = "Unknown"
							}
							$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
						}
						# Export Information To Csv
							$ADObject | Export-Csv $ToCsv -noTypeInformation
					}
				} else {
					# Return Information to Host

					if ($Property -eq "AllProperties") {

						$ObjectPropertyNames | ForEach {

							$Name = $_
							$Name = $Name.ToString()

							$Value = $ObjectProperties[$Name]
							$Value = $Value.ToString()

							if($Value -eq $Null) {
								$Value = "Unknown"
							}

							$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
						}
						# Return Information

						return $ADObject
					} else {
	
						$Properties | ForEach {

							$Name = $_
	
							if ($ObjectProperties[$Name]) {
								$Value = $ObjectProperties[$Name]
								$Value = $Value.ToString()
							} else {
								$Value = "Unknown"
							}
							$ADObject | Add-Member -memberType NoteProperty $Name -Value $Value
						}
						# Return Information

						return $ADObject
					}
				}
			}
		}
	}
}

if ($help) { 
	GetHelp 
	Continue
}

if ($Domain) {

	if ($ToCsv -AND $ToObject) {
		Write-Host "Please Select either ToCsv OR ToObject" -ForegroundColor Red
		GetHelp
		Continue
	}
	if ($ToCsv) {

		if ($OU) {
			Get-AD -Domain $Domain -OU $OU -Filter $Filter -Property $Property -ToCsv $ToCsv -IncreasePageSize $IncreasePageSize
		} elseif ($User) {
			Get-AD -Domain $Domain -User $User -Filter $Filter -Property $Property -ToCsv $ToCsv -IncreasePageSize $IncreasePageSize
		} elseif ($Group) {
			Get-AD -Domain $Domain -Group $Group -Filter $Filter -Property $Property -ToCsv $ToCsv -IncreasePageSize $IncreasePageSize
		} elseif ($Computer) {
			Get-AD -Domain $Domain -Computer $Computer -Filter $Filter -Property $Property -ToCsv $ToCsv -IncreasePageSize $IncreasePageSize
		} elseif ($CustomFilter) {
			Get-AD $Domain -CustomFilter $CustomFilter -Property $Property -ToCsv $ToCsv -IncreasePageSize $IncreasePageSize
		} elseif ($CustomAll) {
			Get-AD $Domain -CustomAll $CustomAll -Property $Property -ToCsv $ToCsv -IncreasePageSize $IncreasePageSize
		} else {
			Get-AD -Domain $Domain -Filter $Filter -Property $Property -ToCsv $ToCsv -IncreasePageSize $IncreasePageSize
		}
	} elseif ($ToObject) {
		if ($OU) {
			Get-AD -Domain $Domain -OU $OU -Filter $Filter -ToObject -IncreasePageSize $IncreasePageSize
		} elseif ($User) {
			Get-AD -Domain $Domain -User $User -Filter $Filter -ToObject -IncreasePageSize $IncreasePageSize
		} elseif ($Group) {
			Get-AD -Domain $Domain -Group $Group -Filter $Filter -ToObject -IncreasePageSize $IncreasePageSize
		} elseif ($Computer) {
			Get-AD -Domain $Domain -Computer $Computer -Filter $Filter -ToObject -IncreasePageSize $IncreasePageSize
		} elseif ($CustomFilter) {
			Get-AD $Domain -CustomFilter $CustomFilter -Property $Property -ToObject -IncreasePageSize $IncreasePageSize
		} elseif ($CustomAll) {
			Get-AD $Domain -CustomAll $CustomAll -Property $Property -ToObject -IncreasePageSize $IncreasePageSize
		} else {
			Get-AD -Domain $Domain -Filter $Filter -ToObject -IncreasePageSize $IncreasePageSize
		}
	} else {
		if ($OU) {
			Get-AD -Domain $Domain -OU $OU -Filter $Filter -Property $Property -IncreasePageSize $IncreasePageSize
		} elseif ($User) {
			Get-AD -Domain $Domain -User $User -Filter $Filter -Property $Property -IncreasePageSize $IncreasePageSize
		} elseif ($Group) {
			Get-AD -Domain $Domain -Group $Group -Filter $Filter -Property $Property -IncreasePageSize $IncreasePageSize
		} elseif ($Computer) {
			Get-AD -Domain $Domain -Computer $Computer -Filter $Filter -Property $Property -IncreasePageSize $IncreasePageSize
		} elseif ($CustomFilter) {
			Get-AD $Domain -CustomFilter $CustomFilter -Property $Property -IncreasePageSize $IncreasePageSize
		} elseif ($CustomAll) {
			Get-AD $Domain -CustomAll $CustomAll -Property $Property -IncreasePageSize $IncreasePageSize
		} else {
			Get-AD -Domain $Domain -Filter $Filter -Property $Property -IncreasePageSize $IncreasePageSize
		}
	}
} else { 
	Write-Host "Please Specify Domain" -ForegroundColor Red
	GetHelp
	Continue
}