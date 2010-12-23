<html>
<head><title>Search result</title>
<meta http-equiv="content-type" content="text/html;charset=UTF-8">
<meta name="description" content="Only personal code">
</head>
<body>

<?php

// specify the LDAP server to connect to
$ldapconfig['host'] = '192.168.1.201';
$ldapconfig['port'] = 389;
$ldapconfig['basedn'] = 'dc=mega-lex,dc=ru';
$password="Keeping-Cooler";
$user='admin';
$dn="cn=". $user .",". $ldapconfig['basedn'];

$ds = ldap_connect($ldapconfig['host'], $ldapconfig['port']) or die("Could not connect to server");  

// bind to the LDAP server specified above 
$r = ldap_bind($ds,$dn,$password) or die("Could not bind to server");     

// create the search string
$query = "(givenName=" . $_POST['name1'] . ")";
// start searching
// specify both the start location and the search criteria
// in this case, start at the top and return all entries $result =
$result=ldap_search($ds,"ou=OFFICE,o=MegaLex,l=Moscow,o=bd,dc=mega-lex,dc=ru", $query) or die ("Error in search query");  

// get entry data as array
$info = ldap_get_entries($ds, $result);

// iterate over array and print data for each entry
echo "<ul>";
for ($i=0; $i<$info["count"]; $i++) 
{
    echo "<li>" . $info[$i]["cn"][0] ." - ".$info[$i]["mail"][0] . "</li>";
} echo "</ul>";

// print number of entries found
echo "Number of entries found: " . ldap_count_entries($ds, $result) .
"<p>";

// all done? clean up
ldap_close($ds);
echo "<a href=index.php>Обратно</a>";
?>
</body>
</html>
