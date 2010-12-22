
<html><!-- DO NOT EDIT YOUR FORM HERE, PLEASE LOG IN AND EDIT AT FREEDBACK.COM -->
<?php
$ldapconfig['host'] = '192.168.1.201';
$ldapconfig['port'] = 389;
$ldapconfig['basedn'] = 'dc=mega-lex,dc=ru';
$username=admin;
$ds=ldap_connect($ldapconfig['host'], $ldapconfig['port']);

$dn="uid=".$username.",ou=people,".$ldapconfig['basedn'];

if ($bind=ldap_bind($ds, $dn, $password)) {
  echo("Login correct");
} else {

  echo("Unable to bind to server.</br>");

  echo("msg:'".ldap_error($ds)."'</br>");#check if the message isn't: Can't contact LDAP server :)
  #if it say something about a cn or user then you are trying with the wrong $dn pattern i found this by looking at OpenLDAP source code :)
  #we can figure out the right pattern by searching the user tree
  #remember to turn on the anonymous search on the ldap server
  if ($bind=ldap_bind($ds)) {

    $filter = "(cn=*)";

    if (!($search=@ldap_search($ds, $ldapconfig['basedn'], $filter))) {
      echo("Unable to search ldap server<br>");
      echo("msg:'".ldap_error($ds)."'</br>");#check the message again
    } else {
      $number_returned = ldap_count_entries($ds,$search);
      $info = ldap_get_entries($ds, $search);
      echo "The number of entries returned is ". $number_returned."<p>";
      for ($i=0; $i<$info["count"]; $i++) {

        var_dump($info[$i]);#look for your user account in this pile of junk and apply the whole pattern where you build $dn to match exactly the ldap tree entry
      }
    }
  } else {
    echo("Unable to bind anonymously<br>");
    echo("msg:".ldap_error($ds)."<br>");
  }
}

// LDAP variables
//$ldaphost = "192.168.1.201";  // your ldap servers
//$ldapport = 389;                 // your ldap server's port number

// Connecting to LDAP
//$ldapconn = ldap_connect($ldaphost, $ldapport)
//          or die("Could not connect to $ldaphost");
?>
<form method="post" action="form2.php">
	<table cellspacing="5" cellpadding="5" border="0">
		<tr>
			<td valign="top">
				<strong>Имя:</strong>
			</td>
			<td valign="top">
				<input type="text" name="name" id="name" size="40" value="" />
				
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Фамилия</strong>
			</td>
			<td valign="top">
				<input type="text" name="second" id="second" size="40" value="" />
				
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Отчество</strong>
			</td>
			<td valign="top">
				<input type="text" name="last" id="last" size="40" value="" />
				
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Организация</strong>
			</td>
			<td valign="top">
				<input type="text" name="org" id="org" size="40" value="Мегалекс" />
				
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Внутренний номер</strong>
			</td>
			<td valign="top">
				<input type="text" name="tel" id="tel" size="40" value="" />
				
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Почтовый адрес</strong>
			</td>
			<td valign="top">
				<input type="text" name="mail2" id="mail2" size="40" value="" />
				
			</td>
		</tr>
		<tr>
                        <td valign="top">
                                <strong>Подразделение</strong>
                        </td>
                        <td valign="top">
                                <input type="text" name="dep" id="dep" size="40" value="" />

                        </td>
                </tr>
                <tr>
                        <td valign="top">
                                <strong>Название должности</strong>
                        </td>
                        <td valign="top">
                                <input type="text" name="title" id="title" size="40" value="" />

                        </td>
                </tr>

		<tr>
                        <td valign="top">
                                <strong>Адрес</strong>
                        </td>
                        <td valign="top">
                                <input type="text" name="addres" id="addres" size="40" value="Сибирский проезд 2 корп.9" />

                        </td>
                </tr>
		<tr>
                        <td valign="top">
                                <strong>Пароль:</strong>
                        </td>
                        <td valign="top">
                                <input type="password" name="pass" id="pass" size="40" value="" />

                        </td>
                </tr>

		<tr>
			<td colspan="2" align="center">
				<input type="submit" value=" Submit Form " />
			</td>
		</tr>
	</table>
</form>
<br><center><font face="Arial, Helvetica" size="1"><b>
</b></font></center>
</html><!-- End Freedback Form -->
