<html>
<head><title>LDAP Create LDIF</title>
<meta http-equiv="content-type" content="text/html;charset=UTF-8">
<meta name="description" content="Only personal code">
</head>
<body>
<?php
$pageURL = 'http';
if ($_SERVER["HTTPS"] == "on") {        
    $pageURL .= "s";    
}       
$pageURL .= "://";      
if ($_SERVER["SERVER_PORT"] != "80") {  
    $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];    
} else {        
    $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];        
}

session_name('MYAPP');  
session_start();        
if (!isset($_SESSION["user"])) {        
    include("LdapAuth.inc.php");        
    $ldap=new LdapAuth();       
    $ldap->setSessionAttr("user","name");        
    $ldap->setSessionName("MYAPP");     
    $ldap->setRedirectPage($pageURL); //page where we get redirected after login (in this case self)
    include("LdapStandalonePageProtector.inc.php");
}       
else { 
  echo "Logged In As: ".$_SESSION["user"]."</hr>";
  //paste here the old page code (or write the new page to protect)
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
<?php
}
?>
