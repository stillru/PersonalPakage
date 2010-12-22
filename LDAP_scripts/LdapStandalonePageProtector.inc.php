<?php
/**
 *
 * LdapStandalonePageProtector.inc.php, questo file fa parte del pacchetto LdapAuthenicator 
 *
 * 
 * Questo file offre una form di login gia' configurata per implementare l'autenticazione ldap su una pagina PHP da proteggere
 * esempio:
 *
 *  <?
 *
 *  include("LdapAuth.inc.php");
 *
 *  $ldap=new LdapAuth(); //<-obbligatorio
 *
 *  // qui puoi customizzare i parametri di LdapAuth (vedi documentazione dei metodi della classe)
 *
 *  include("LdapStandalonePageProtector.inc.php");
 *
 *  ?>
 *
 *  <html>
 *
 *  ..pagina da proteggere
 *
 *  </html>
 *
 *  questo piccolo pezzo di codice messo sopra qualsiasi pagina statica o dinamica sita su server in cui gira PHP (richiede il modulo php-ldap)
 *  implementa la protezione della pagina stessa mostrando una form di login LDAP che consentira' di accedere al contenuto protetto
 *
 *	ATTENZIONE: non inserire il DTD nelle pagine da proteggere con questo file poiche' verra stampato in ogni caso da LdapAuth
 *	usare @see LdapAuth::setDTD() per cambiare il DTD della pagina..
 *
 * @author Stefano Gargiulo <stefano.gargiulo@garr.it>
 * @version 1.0
 * @package LdapAuthenticator
 */

function PageURL() {
 $pageURL = 'http';
 if ($_SERVER["HTTPS"] == "on") {$pageURL .= "s";}
 $pageURL .= "://";
 if ($_SERVER["SERVER_PORT"] != "80") {
  $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
 } else {
  $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
 }
 return $pageURL;
}

function secureURL() {
 $pageURL = 'https';
 $pageURL .= "://";
 if ($_SERVER["SERVER_PORT"] != "80") {
  $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
 } else {
  $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
 }
 return $pageURL;
}

$thisPhp=PageURL();
$auth = $ldap->TO_AUTH;

    if (isset($HTTP_COOKIE_VARS['LDAPCookie'])) { 
        $ldap->loadCredentials($HTTP_COOKIE_VARS['LDAPCookie']);
        $auth=$ldap->Authenticate();
    }
    else {
    		if ((isset($_POST['username'])) && (isset($_POST['password']))) {
        		$ldap->setCredentials($_POST['username'],$_POST['password']);
            		$auth=$ldap->Authenticate();
        	}
    }
    
    if($auth===$ldap->AUTH_SUCCESSFULL) {
       /*    Non fa nulla     */
    }
    else{
       //Mostra la pagina di login e poi fa un die per proteggere la pagina sottostante.. (ricordarsi che questo file va usato come include nelle pagine che si vogliono proteggere prima di ogni altro header)
?>
<html>
<head>
    <title>LDAP Login Page</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="pragma" content="no-cache">
</head>
<?php if($auth === $ldap->AUTH_FAILED) {
	echo "Authentication Failed!";
}
?>
<div align="center">
    <form method="post" action="<?php echo $thisPhp; ?>">
    <div align="center">
    <table width="210" border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td align="center">
    <fieldset>
        <Legend><font face="Verdana,Tahoma,Arial,sans-serif" size="1"
                      color="gray">Enter LDAP Credentials</font></Legend>
        <table border="0" cellspacing="3" cellpadding="0">
        <tr>
        <td align="right" valign="middle"><b><font
            face="Verdana,Tahoma,Arial,sans-
            serif" size="1" color="gray">Username:</font></td>
        <td align="center" valign="middle">
        <input class="clear" type="text" size="15" name="username" />
        </td>
        </tr>
        <tr>
        <td align="right" valign="middle">
        <b><font face="Verdana,Tahoma,Arial,sans-serif" size="1" color="gray">Password:</font>
        </td>
        <td align="center" valign="middle">
        <?php if ($_SERVER["HTTPS"] == "on"){ ?>
            <input class="pass" type="password" size="15"
            name="password" />
            <?php }else{ ?>
              <input title="sending password over plain HTTP is very unsecure" class="pass" disabled="true" type="password" size="15"
              />
            <?php } ?>
        </td>
        </tr>
        </table>
        <?php if ($_SERVER["HTTPS"] == "on") { ?>
           <input  type="submit" value="Login"/>
         <?php } else { ?>
           <input disabled="true"  type="submit"  value="Login"/>
                <p/>
               <b>PAY ATTENTION:</b> Doing login over an unencrypted connection is very unsafe: someone can sniff your LDAP credentials, please  <a href="<?php echo secureURL();?>">switch to an SSL connection by clicking here </a>
       <?php } ?>
        <br/>
        <font
            face="Verdana,Tahoma,Arial,sans-
            serif" size="1" color="gray">
        <?php
             echo $ldap->getPrintableLDAPAvailability();
        ?>
        </font>
       
    </div>
    </td>
    </tr>
</fieldset>
</table>
<br>
<table width="640"><tr><td align="center">
</td></tr>
</table>
</div>
</form>
</div>
</body>
</html>
<?php
    die();
}
?>


