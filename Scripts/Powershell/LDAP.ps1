# modUserNagios.ps1
# Makes an existing user into a nagios contact

# set modify type
name = Testuser
second = TestSecond
last = test
dep = test
mail = test@mega-lex.ru
addr = test
tel = 1234256
title = title
[int] $ADS_PROPERTY_CLEAR       = 1
[int] $ADS_PROPERTY_UPDATE     = 2
[int] $ADS_PROPERTY_APPEND     = 3
[int] $ADS_PROPERTY_DELETE      = 4


    
$objUser = [adsi] "LDAP:192.168.1.201//CN=$name,OU=OFFICE,O=MegaLex,L=Moscow,O=bd,DC=mega-lex,DC=com"

$objUser.PutEx($ADS_PROPERTY_APPEND, "objectClass", @("$objClass"))
$objUser.Put("cn",$name)
$objUser.Put("givenName",$name)
$objUser.Put("sn",$second)
$objUser.Put("objectclass","top")
$objUser.Put("objectclass","person")
$objUser.Put("objectclass","organizationalPerson")
$objUser.Put("objectclass","inetOrgPerson")
$objUser.Put("objectclass","posixAccount")
$objUser.Put("objectclass","inetLocalMailRecipient")
$objUser.Put("objectclass","OpenLDAPperson")
$objUser.Put("company","MEGALEX_MOS_OFFICE")
$objUser.Put("o","MEGALEX_MOS_OFFICE")
$objUser.Put("homeDirectory","/mail/mega-lex.ru/$name")
$objUser.Put("maildrop","Maildir/")
$objUser.Put("mailAccessValue","OK")
$objUser.Put("uidNumber","2000")
$objUser.Put("gidNumber","2000")
$objUser.Put("mailAliasKey","all@mega-lex.ru")
$objUser.Put("cn","$second $name")
$objUser.Put("sn","$_Second")
$objUser.Put("givenName","$name")
$objUser.Put("initials","$last")
$objUser.Put("title","$title")
$objUser.Put("telephoneNumber",$tel)
$objUser.Put("postalAddress",$addr)
$objUser.Put("ou",$dep)
$objUser.Put("department",$dep)
$objUser.Put("mail",$mail)
$objUser.Put("mailAliasValue",$mail)
$objUser.Put("uid",$mail)
$objUser.Put("mailquota","1000000000")
$objUser.Put("userPassword",$userpassword);
$objUser.SetInfo()