<?php
/**
 *
 * LdapLoginReceiver.inc.php, questo file fa parte del pacchetto LdapAuthenicator, questo file non protegge alcuna pagina di perse': non fa altro che ricevere la richiesta di login con i parametri POST username e password ed inoltrarli ad LdapAuth, e'da usare nei casi in cui gia' si dispone di una pagina di login personalizzata e si vuol far uso di ldap 
 *
 *   ATTENZIONE: dovranno essere usate le session per proteggere le altre pagine del sito (vedi esempio)
 *
 *   ecco un esempio di utilizzo:
 *
 *   siamo nella nostra pagina di login gia' esistente:
 *
 *   <?
 *
 *   include("LdapAuth.inc.php");
 *
 *   $ldap=newLdapAuth(); //<- obbligatorio
 *
 *   //inizio customizzazione:
 *
 *   $ldap->setSessionAttr("username","uid");  // verra' creato un attributo $_SESSION["username"] che conterra' il campo uid preso da LDAP
 *
 *   $ldap->setSessionAttr("group","ou");      // verra' creato un attributo $_SESSION["group"] che conterra' il campo ou preso da LDAP
 *
 *   $ldap->setRedirectPage("welcome.php");    // la pagina verso la quale vogliamo far redirigere l'utente che effettua il login con successo (pagina che ovviamente si protegge controllando la session)
 *
 *   $ldap->setErrorPage($_SERVER['SCRIPT_NAME']); //pagina di errore da mostrare in caso di login fallito (in questo caso se stessa, questa pagina ricevera'un parametro ?error=<errore login> in modo tale da dare la possibilita'di stampare un messaggio di errore )
 *
 *   include("LdapLoginReceiver.inc.php"); // riceve la richiesta di login
 *
 *   <html>
 *
 *   <form action='$_SERVER["SCRIPT_NAME"]' method="POST">
 *
 *   <input name="username" ..
 *
 *   <input name="password" ..
 *
 *   </form> 
 *
 *    e' importante che la form usi questi names per i parametri e che punti a $_SERVER["script_name"]
 *
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

    if (isset($HTTP_COOKIE_VARS['LDAPCookie'])) {                        
        $ldap->loadCredentials($HTTP_COOKIE_VARS['LDAPCookie']);
        $ldap->Authenticate();
    }
    else {
    		if ((isset($_POST['username'])) && (isset($_POST['password']))) {
        		$ldap->setCredentials($_POST['username'],$_POST['password']);
	    		$ldap->useCookies(false,0);
            		$ldap->Authenticate();
        	}
    }

