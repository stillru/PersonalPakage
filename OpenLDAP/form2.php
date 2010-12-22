<?php
  /**
         * transliterate text
         *
         * @param string $text
         * @return string
         */
        
        function translit($text) {
                $trans = array(
                                        "а" => "a",
                                        "б" => "b",
                                        "в" => "v",
                                        "г" => "g",
                                        "д" => "d",
                                        "е" => "e", 
                                        "ё" => "e",
                                        "ж" => "zh",
                                        "з" => "z",
                                        "и" => "i",
                                        "й" => "y",
                                        "к" => "k",
                                        "л" => "l", 
                                        "м" => "m",
                                        "н" => "n",
                                        "о" => "o",
                                        "п" => "p",
                                        "р" => "r",
                                        "с" => "s",
                                        "т" => "t",
                                        "у" => "u",
                                        "ф" => "f",
                                        "х" => "kh",
                                        "ц" => "ts",
                                        "ч" => "ch",
                                        "ш" => "sh",
                                        "щ" => "she",
                                        "ы" => "y",
                                        "э" => "e",
                                        "ю" => "yu",
                                        "я" => "ya",
                                        "А" => "A",
                                        "Б" => "B",
                                        "В" => "V",
                                        "Г" => "G",
                                        "Д" => "D",
                                        "Е" => "E",
                                        "Ё" => "E",
                                        "Ж" => "Zh",
                                        "З" => "Z",
                                        "И" => "I",
                                        "Й" => "Y",
                                        "К" => "K",
                                        "Л" => "L",
                                        "М" => "M",
                                        "Н" => "N",
                                        "О" => "O",
                                        "П" => "P",
                                        "Р" => "R",
                                        "С" => "S",
                                        "Т" => "T",
                                        "У" => "U",
                                        "Ф" => "F",
                                        "Х" => "Kh",
                                        "Ц" => "Ts",
                                        "Ч" => "Ch",
                                        "Ш" => "Sh",
                                        "Щ" => "She",
                                        "Ы" => "Y",
                                        "Э" => "E",
                                        "Ю" => "Yu",
                                        "Я" => "Ya",
                                        "ь" => "",
                                        "Ь" => "",
                                        "ъ" => "",
                                        "Ъ" => ""
                                );
                if(preg_match("/[а-яА-Я]/", $text)) {
                        return strtr($text, $trans);                    
                }
                else {
                        return $text;
                }
                                
        }

$name = $_POST['name'];
$en_name = translit($name);
$second = $_POST['second'];
$en_second = translit($second);
$last = $_POST['last'];
$dep = $_POST['dep'];
$org = $_POST['org'];
$mail2 = $_POST['mail2'];
$tel = $_POST['tel'];
$addres = $_POST['addres'];
$pass = $_POST['pass'];
$title = $_POST['title'];
###################### Set up the following variables ######################
# #
$filename = "data/mega-lex.ru-$en_second.$en_name[0].ldif"; #CHMOD to 666
$forward = 0; # redirect? 1 : yes || 0 : no
$location = "thankyou.htm"; #set page to redirect to, if 1 is above
# #
##################### No need to edit below this line ######################


## mail message ##

$msg .= "dn: cn=$second $name, ou=OFFICE, o=MegaLex, l=Moscow, o=bd, dc=mega-lex, dc=ru" . "\n";
$msg .= "objectClass: top" . "\n";
$msg .= "objectClass: person" . "\n";
$msg .= "objectClass: organizationalPerson" . "\n";
$msg .= "objectClass: inetOrgPerson" . "\n";
$msg .= "objectClass: posixAccount" . "\n";
$msg .= "objectClass: inetLocalMailRecipient" . "\n";
$msg .= "objectClass: OpenLDAPperson" . "\n";
$msg .= "company: MEGALEX_MOS_OFFICE" . "\n";
$msg .= "o: MEGALEX_MOS_OFFICE" . "\n";
$msg .= "homeDirectory: /mail/mega-lex.ru/$en_second.$en_name[0]" . "\n";
$msg .= "maildrop: Maildir/" . "\n";
$msg .= "mailAccessValue: OK" . "\n";
$msg .= "uidNumber: 2000" . "\n";
$msg .= "gidNumber: 2000" . "\n";
$msg .= "mailAliasKey: all@mega-lex.ru" . "\n";
$msg .= "cn: $second "."$name" . "\n";
$msg .= "sn: $second" . "\n";
$msg .= "givenName: $name" . "\n";
$msg .= "initials: $last" . "\n";
$msg .= "title: $title" . "\n";
$msg .= "telephoneNumber: $tel" . "\n";
$msg .= "postalAddress: $addres" . "\n";
$msg .= "ou: $dep" . "\n";
$msg .= "department: $dep" . "\n";
$msg .= "mail: $en_second.$en_name[0]@mega-lex.ru" . "\n";
$msg .= "mail2: $mail2" . "\n";
$msg .= "mailAliasValue: $en_second.$en_name[0]@mega-lex.ru" . "\n";
$msg .= "uid: $en_second.$en_name[0]@mega-lex.ru" . "\n";
$msg .= "mailquota: 1000000000" . "\n";

$userpassword = "{SHA}" . base64_encode( pack( "H*", sha1( $pass ) ) ); 


$msg .= "userPassword:$userpassword" . "\n";
$msg .= "\n\n";

$fp = fopen ($filename, "a"); # w = write to the file only, create file if it does not exist, discard existing contents
if ($fp) {
fwrite ($fp, $msg);
fclose ($fp);
}
else {
$forward = 2;
}

if ($forward == 1) {
header ("Location:$location");
}
else if ($forward == 0) {
echo ("Thank you for submitting our form. We will get back to you as soon as possible.");
}
else {
"Error processing form. Please contact the webmaster";
};

?>
