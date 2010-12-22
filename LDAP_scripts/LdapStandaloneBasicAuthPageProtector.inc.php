<?php
/**
 *
 * LdapStandalonePageProtector.inc.php, questo file fa parte del pacchetto LdapAuthenicator 
 *
 * 
 * Questo file offre una form di login gia' configurata per implementare l'autenticazione ldap su una pagina PHP da proteggere
 * esempio:
 *
 *  <?php
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

$skipDie=false;
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

    if (!isset($_SERVER['PHP_AUTH_USER']) || !isset($_SERVER['PHP_AUTH_PW']) || $_SERVER['PHP_AUTH_PW']==NULL ) {
        if ($_SERVER["HTTPS"] == "on"){
        header('WWW-Authenticate: Basic realm="Login LDAP"');
        header('HTTP/1.0 401 Unauthorized');
        echo 'Login failed';
        }else{
             echo '<b>PAY ATTENTION:</b> Doing login over an uncrypted connection is very unsafe: someone can sniff your LDAP credentials, please  <a href="<?php echo secureURL();?>">switch to an SSL connection by clicking here </a>';
        }


    } else {
            $ldap->setCredentials($_SERVER['PHP_AUTH_USER'],$_SERVER['PHP_AUTH_PW']);
            $auth=$ldap->Authenticate();
            if($auth===$ldap->AUTH_SUCCESSFULL) {
              $skipDie=true;
            }else{
                   $skipDie=false;
            }
    }
}
if (!$skipDie){
    die("Unauthorized -- Please clean your browser chache to retry (BasicAuth limit)");
}
?>


