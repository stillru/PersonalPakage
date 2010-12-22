<html>
<head><title>LDAP Create LDIF</title>
<meta http-equiv="content-type" content="text/html;charset=UTF-8">
<meta name="description" content="Only personal code">
</head>
<body>

<?php
$ldapconfig['host'] = '192.168.1.201';
$ldapconfig['port'] = 389;
$ldapconfig['basedn'] = 'dc=mega-lex,dc=ru';
$password="Keeping-Cooler";
$user=admin;
$ds=ldap_connect($ldapconfig['host'], $ldapconfig['port']);
$dn="cn=". $user .",". $ldapconfig['basedn'];
if ($bind=ldap_bind($ds,$dn,$password)) {
  echo("Login correct");
} else {

  echo("Unable to bind to server.</br>");

  echo("msg:'".ldap_error($ds)."'</br>");
	//check if the message isn't: Can't contact LDAP server :)
  	//if it say something about a cn or user then you are trying with the wrong $dn pattern i found this by looking at OpenLDAP source code :)
  	//we can figure out the right pattern by searching the user tree
  	//remember to turn on the anonymous search on the ldap server
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

        var_dump($info[$i]);//look for your user account in this pile of junk and apply the whole pattern where you build $dn to match exactly the ldap tree entry
      }
    }
  } else {
    echo("Unable to bind anonymously<br>");
    echo("msg:".ldap_error($ds)."<br>");
  }
}
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
                                <strong>Сотовый номер</strong>
                        </td>
                        <td valign="top">
                                <input type="text" name="cellar" id="cellar" size="40" value="" />
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
</body></html>
