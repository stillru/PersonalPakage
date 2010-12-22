<?php
/**
 *
 * LdapAuth.inc.php, questo file fa parte del pacchetto LdapAuthenicator
 *
 *
 * Questo file contiene una classe PHP per l'autenticazione via LDAP
 * e stato scritto per essere incluso in altre pagine php ed essere usato
 * da quest'utlime
 *
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
 *  LdapStandalonePageProtector.inc.php contiene il codice per mostrare una form di login universale per proteggere una piccola pagina PHP
 *  ovviamente questa puo'essere sotituita ad una propria pagina di login gia' presente in applicazioni piu grandi
 *  che ad esempio usano la SESSION per gestire l'autorizzazione, in questo caso si dorva' fare uso del file  LdapLoginReceiver.inc.php:
 *  e personalizzare il funzionamento di LdapAuth (la classe e' stata studiata per essere il piu flessibile possibile) ecco un esempio:
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
 *    NOTA:
 *
 *
 *    La classe consente solo autenticazioni sicure via LDAPS o TLS over LDAP, quindi e' necessario avere il certificato del server ldap installato nel propi *    o server e linkato da /etc/ldap/ldap.conf altrimenti la connessione SSL fallira' (si puo' anche impostare in ldap.conf l'opzione REQ_CERT NEVER ma cio'
 *    rendera' sensibili le vostre applicazioni ad attacchi di tipo IP Spoofing fatti sul server LDAP per accedere ai vostri contenuti protetti.
 *
 *
 *
 *
 * @author Stefano Gargiulo <stefano.gargiulo@garr.it>
 * @version 1.0
 * @package LdapAuthenticator
 */


function myErrorHandler ($errno, $errstr, $errfile, $errline) {
    #echo $errno ." " .$errstr ." " .$errfile ." " .$errline;
}



/**
 * Classe su cui si basa l'intero package e che consente l'authenticazione LDAP
 * @package LdapAuthenticator
 */
class LdapAuth
{



    /* Configuration section: */
        private $serviceUser="cn=LdapAuthenticator,ou=Groups,dc=mydomain,dc=com";
        private $serviceSecret="serviceUSERpassword";
        /* Tip: a service user is required (keeping enabled anonymous access is a bad thing)
         * and you are supposed do write some ACL to limit the service user to read-only the cn 
         * and the uid attribute in the People tree 
         */
        private $BaseDn="ou=People,dc=mydomain,dc=com"; //where are the users in the tree?
        private $UIDAttributeName="uid"; // what attribute you wanna search for the search & bind login? e.g. "mail" let users to login with their email address and password

        private $ServerList = Array(
            /* Multiple LDAP Servers: for load balancing/ HA redundancy mode, not for multi-ldap auth!!!!
             *  (Server MUST have some user tree synchronization mechanism e.g. OpenLDAP syncrepl ) */
            Array(
                                        "ip"=>"123.123.123.123",
                                        "name"=>"ldap-master",
                                        "sslport"=>636,
                                        "port"=>389
            ),
            Array(
                                        "ip"=>"ldap125.mydomain.com",
                                        "name"=>"ldap-replica",
                                        "sslport"=>636,
                                        "port"=>389
            )
            /* You can add or remove LDAP server entries (But this is not multi-ldap:
             *  servers MUST have the same user tree */
        );

        private $accessLogFile="ldap.access.log"; //file where access will be logged

        /* Optional parametes (keep it to empty or wrong string if you don't want AuhtZ attributes: */

         /*
          * Note: all attribute names MUST be written in lowercase e.g. givenName -> givenname
          */

        /* Optional*/ private $AuthorizativeAttrName="member";  //can be multi-value
        /* Optional*/ private $AuthorizativeJSONAttrName="x-garr-authoritativejsondata";  //single valued JSON String attribute  e.g. {"myappLevel":"admin","yourappLevel":"guest"}

        /*
         * Other configuration options can be set programmatically, check
         * for the setters methods of this class and call it before
         * calling the method authenticate() into a page to protect.
         */
    /* End configuration. */

    private $enforceServer=null;



 
    private $Password="";
    private $Username="";

    private $SessionAttrs=array();
    private $AnonymousSessionAttrs=array();
    private $AuthorizativeAttrs=array();
    private $AuthorizativeActivities=array();
    private $redirectPage="";
    private $redirectErrorPage="";
    private $useLDAPS=true;
    private $useStartTLS=false;
    private $useSessionToken=false;
    private $useCookies=false;
    private $SessionName="LDAPAuthSession";
    private $useSession=false;
    private $useLocalAttrStorage=false;
    private $LocalAttrs=array();
    private $CookieExpire=0;
    private $DTD='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">';



     /**
     *
     * @var integer Costante che rapperesenta lo stato "Autenticazione ancora non tentata"
     * @see LdapAuth::Authenticate()
     */
    public $TO_AUTH = 0;
    /**
    *
    * @var integer Costante che rapperesenta lo stato "Autenticazione fallita"
    * @see LdapAuth::Authenticate()
    */
    public $AUTH_FAILED = 1;
    /**
    *
    * @var integer Costante che rapperesenta lo stato "Autenticazione avvenuta con successo"
    * @see LdapAuth::Authenticate()
    */
    public $AUTH_SUCCESSFULL = 2;

     /**
    * Imposta il DTD da stampare nell'intestazione della pagina (solo se si usa LdapStandalonePageProtector.inc.php) il DTD non va incluso nelle pagine da proteggere
    * @var string $dtd per default e' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
    */
    private function log($log)
    {
        $OLD_ERR_SETTING = error_reporting(0);	//disabilito temporaneamente il print degli errori di PHP
        try{
            $now=date('d/M/Y h:i:s',time());
            if (!file_exists($this->accessLogFile)){
                file_put_contents($this->accessLogFile,"[".$now."]".$log."\n");
            }else{
                file_put_contents($this->accessLogFile,"[".$now."]".$log."\n", FILE_APPEND);
            }
        }catch(Exception $e){
        }
        error_reporting($OLD_ERR_SETTING); //ripristiono il vecchio livello di report degli errori
    }

    /**
    * Imposta il DTD da stampare nell'intestazione della pagina (solo se si usa LdapStandalonePageProtector.inc.php) il DTD non va incluso nelle pagine da proteggere
    * @var string $dtd per default e' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
    */
    public function setDTD($dtd)
    {
        $this->DTD=$dtd;
    }

   /**
     * Forza ad usare un determinato server LDAP (no balancing & HA )
     * @param string $serverName name assegnato al server in $this->$ServerList
     */
    public function enforceServer($serverName)
    {
        foreach ($this->ServerList as $index => $serverObj){
            if ($serverObj["name"]==$serverName){
                $this->enforceServer=$index;
                break;
            }else {
                $this->enforceServer=null;
            }
        }
    }

   /**
     * Permette di settare il metodo di trasmissione dei dati a TLS over LDAP in tal caso verra' aperta una sessione TLS su una normale connessione LDAP sulla porta 389
     * @param boolean $bol true se si vuole usare TLS over LDAP false imposta il metodo alternativo (LDAPS)
     * @see LdapAuth::useLDAPS()
     */
    public function useStartTLS($bol)
    {
        $this->useStartTLS=true;
        $this->useLDAPS(! $bol );
    }

    /**
     * E' l'impostazione di default: LdapAuth usa connessione LDAPS sulla porta 636 come canale dei dati per l'operazione di autenticazione
     * @param boolean $bol true se si vuole usare LDAPS false imposta il metodo alternativo (TLS over LDAP)
     * @see LdapAuth::useStartTLS()
     */
    public function useLDAPS($bol)
    {
        $this->useLDAPS=true;
        $this->useStartTLS(! $bol );
    }


   /**
     * Per consentire una certa flessibilita' di utilizzo (LdapAuth e' un componente pluggabile per altre applicazioni PHP) E'possibile settare la classe affinche' esporti degli attributi LDAP dell'utente  nell'oggetto $_SESSION.
     * Per default, quando useSession e' true, l'unico attributo inserito e' $_SESSION['username'] = username passato dalla form di login (solo in caso di login avvenuto con successo) E' Possibile personalizzare gli attributi con il metodo setSessionAttr
     * @param boolean $bol true se si vuole usare il riempimento dell'oggetto $_SESSION false se non si desidera questa feautre
     * @see LdapAuth::setSessionAttr()
     * @see LdapAuth::setAnonymousSessionAttr()
     */
    public function useSession($bol)
    {
        $this->useSession=$bol;
    }

    /**
     * Usando questo metodo e' possibie memorizzare gli attributi LDAP di un utente loggato in locale oltre che nella session
     * La lista degli attributi da memorizzare e' impostata sempre con setSessionAttr() e setAnonymousSessionAttr(), quindi se si desidera MEMORIZZARE GLI
     * ATTRIBUTI SOLO IN LOCALE, e non nella session, bisogna usare ExportAttr anziche' setSessionAttr
     *
     * $ldap->ExportAttr("nome_completo","gecos");
     * $ldap->useLocalStorage(true);
     *
     * $ldap->Authenticate();
     *
     * $nomereale=$ldap->getLocalAttr("nome_completo");
     *
     * @param boolean $bol true se si vuole usare lo storage locale degli attributi LDAP dell´utente false se non si desidera questa feautre
     * @see LdapAuth::setSessionAttr()
     * @see LdapAuth::getLocalAttr()
     * @see LdapAuth::setAnonymousSessionAttr()
     */
    public function useLocalStorage($bol)
    {
        $this->useLocalAttrStorage=$bol;
    }

  /**
    *   Resituisce un attributo LDAP memorizzato in locale (la lista degli attributi LDAP esportati in locale e' definibile con il metodo setSessionAttr()) e la memorizzazione di quest' ultimi e' abilitata solo se prima dell autenticazione si e' invocato il metodo useLocalStorage(true);
    *    @param string $name nome locale dell'attributo importato da LDAP (sara' disponibile solo ad autenticazione avvenuta)
    *	 @returns string il valore dell'attributo
    *	 @see LdapAuth::setSessionAttr()
    *    @see LdapAuth::ExportAttr()
    *    @see LdapAuth::useLocalStorage()
    */
    public function getLocalAttr($name)
    {
        return $this->LocalAttrs[$name];
    }

 /**
    *   Personalizzato Garr-Direzione: restituisce l array degli attributi di autorizzazione (gruppi)
    *
    *	 @returns array associativo degli attributi di autorizzazione
    */
    public function getAuthorizativeArray()
    {
        return $this->AuthorizativeAttrs;
    }

/**
    *   Personalizzato Garr-Direzione: restituisce l array delle attivita' in cui e' coinvolto l'utente
    *
    *	 @returns array associativo degli attributi di autorizzazione
    */
    public function getActivitiesArray()
    {
        return $this->AuthorizativeActivities;
    }

    /**
    *   Personalizzato Garr-Direzione: controlla se l'utente e' coinvolto in una determinata attivita (usato a scopi autorizzativi)
    *	@param string $actname nome dell attivita
    *	 @returns boolean true se l attivita e presente negli attributi autorizzativi dell utente
    */
    public function isInActivity($actname)
    {
        $res=in_array($actname,$this->AuthorizativeActivities);
        $this->log("[INFO AUTORIZZAZIONE]"."E' stata richiesta una verifica di appartenenza all'attivita' ".$actname." per ".$this->Username ." con esito: ".$res);
        return $res;
    }
    /**
    *   Personalizzato Garr-Direzione: ritorna un attributo autorizzativo
    *	@param string $attrname nome dell attributo
    *	 @returns string il valore dell'attributo
    */
    public function getAuthorizativeAttr($attrname)
    {
        return $this->AuthorizativeAttrs[$attrname];
    }




    /**
     * Imposta il nome da dare alla session php che verra´ creata dopo il login (chiamando questa funzione si assume implicitamente che si vogliano usare le sessioni)
     * @param string $name il nome che si vuole dare alla session
     * @see LdapAuth::useSession()
     */
    public function setSessionName($name)
    {
        $this->SessionName=$name;
        $this->useSession(true);
    }

   /**
    *    Se a priori si usa questo metodo, dopo il login avvenuto con successo, LDAPAuth provera' a creare un attributo nella session chiamandolo $SessionAttrName e prendendo il valore dall'attributo LDAP corrispondente a $LDAPAttrName (chiamando questa funzione si assume implicitamente che si vogliano usare le sessioni) ATTENZIONE: quando useSession e'abilitato, se il login avviene con successo viene comunque creato l'attributo $_SESSION['username'] = $this->Username
    *
    *
    *
    *    @param string $SessionAttrName nome da dare all'attributo della session
    *    @param string $LDAPAttrName nome dell'attributo LDAP da cui prendere il valore ("_parentNode" restituisce il nodo padre)
    *
    *	 esempio:
    *
    *    include('LdapAuth.inc.php');
    *
    *    $ldap=new LdapAuth();
    *
    *    $ldap->setSessionAttr("nome_utente","gecos");
    *
    *    include('LdapStandalonePageProtector.inc.php');
    *
    *    echo $_SESSION['nome_utente'];
    *
    *    in caso di login OK stampera' il campo ldap "gecos" associato all'utente che ha fatto il login
    *
    *    NOTA: e' possibile aggiungere un numero indefinito di attributi, cio' rende LdapAuth molto flessibile
    *    @see LdapAuth::setAnonymousSessionAttr()
    */
    public function setSessionAttr($SessionAttrName, $LDAPAttrName)
    {
        $this->SessionAttrs[$SessionAttrName] = $LDAPAttrName;
        $this->useSession(true);
    }

   /**
    * Equivalente a setSessionAttr, ma da usare quando non si desidera attivare la session
    * @see LdapAuth::getLocalAttr();
    * @see LdapAuth::setSessionAttr();
    */
    public function ExportAttr($SessionAttrName, $LDAPAttrName)
    {
        $this->SessionAttrs[$SessionAttrName] = $LDAPAttrName;
    }


   /**
    *    Se si usa a priori questo metodo, dopo il login fallito, LDAPAuth creera' un attributo nella session chiamandolo $SessionAttrName e prendendo il valore fornito con $value (chiamando questa funzione si assume implicitamente che si vogliano usare le sessioni)
    *
    *    @param string $SessionAttrName nome da dare all'attributo della session
    *    @param string $value valore da dare all'attributo della session
    *
    *	 esempio:
    *
    *
    *    +++nella pagina di login+++
    *
    *    include('LdapAuth.inc.php');
    *
    *    $ldap=new LdapAuth();
    *
    *    $ldap->setAnonymousSessionAttr("nome_utente","Ospite");
    *
    *    $ldap->setRedirectPage("welcome.php");
    *
    *    $ldap->setRedirectErrorPage("welcome.php");
    *
    *    include('LdapLoginReceiver.inc.php');
    *
    *
    *    +++nel file welcome.php+++
    *
    *    echo "Benvenuto " .$_SESSION['nome_utente'];
    *
    *    In caso di login fallito stampera' "Benvenuto Ospite"
    *
    *    NOTA: e' possibile aggiungere un numero indefinito di attributi, cio' rende LdapAuth molto flessibile
    *    @see LdapAuth::setSessionAttr()
    *    @see LdapLoginReceiver.inc.php
    *    @see LdapAuth::setRedirectErrorPage()
    *    @see LdapAuth::setRedirectPage()
    */
    public function setAnonymousSessionAttr($SessionAttrName, $value)
    {
        $this->AnonymousSessionAttrs[$SessionAttrName] = $value;
        $this->useSession(true);
    }

   /**
    *    @deprecated
    *  	 E' possibile fare in modo che LDAPAuth mandi dei cookie al browser dopo il login, in modo tale che non ci sia il bisogno di rifare il login ogni volta che si accede ad una pagina protetta dello stesso sito
    *    @param boolean $bol true= usa cookies false= non usare i cookie (default)
    *    @param integer $mins rappresenta la validita' del cookie in minuti (scadra' dopo $mins minuti)
    *
    *    ATTENZIONE: questo metodo e' altamente sconsigliato, soprattutto su sessioni HTTP (non SSL) in quanto il cookie contiene la password di login in chiaro.
    *
    *
    *
    *    esempio:
    *
    *           include('LdapAuth.inc.php');
    *
    *		$ldap=new LdapAuth();
    *
    *           $ldap->useCookies(true,30);
    *
    *           include('LdapStandalonePageProtector.inc.php');
    *
    *         Il codice soprastante abilita l'utente a navigare tra le pagine protette del sito per 30 minuti.
    *
    *	 Si consiglia di usare il metodo useSessionToken() al posto di useCookies()
    *	 @see LDAPAuth::useSessionToken()
    */
    public function useCookies($bol, $mins)
    {
        $this->useCookies=$bol;
        $this->CookieExpire=time()+60*$mins;
    }



    /**
    *
    *   Carica le credenziali di login da cookie
    *
    *   @deprecated
    *   @param $cookie il cookie dell'utente da cui si vuogliono caricare le credenziali per il login ldap
    *	 @see LdapAuth::useCookies()
    */
    public function loadCredentials($cookie)
    {
        $this->Username=$cookie['user'];
        $this->Password=$cookie['password'];
    }

    /**
    *
    *	 Imposta username e password per il login ldap
    *
    *   @param string $usr username (uid LDAP)
    *	 @param string $pws password
    */
    public function setCredentials($usr,$pwd)
    {
        $this->Username=$usr;
        $this->Password=$pwd;
    }

   /**
    *
    *  Imposta la pagina dove redirigere l'utente in caso di login avvenuto
    *
    *        esempio:
    *		setRedirectPage("welcome.php");
    *
    *    @param string $url indirizzo della pagina
    */
    public function setRedirectPage($url)
    {
        $this->redirectPage=$url;
    }

   /**
    *
    *  Imposta la pagina dove redirigere l'utente in caso di login fallito
    *
    *         esempio:
    *		setRedirectErrorPage("error.php");
    *
    *    @param string $url indirizzo della pagina di errore (puo' essere la stessa del login)
    */
    public function setRedirectErrorPage($url)
    {
        $this->redirectErrorPage=$url;
    }

   /**
    *
    *    Imposta la basedn del server ldap
    *
    *    Esempio/Nota: settando la basedn "ou=Sw Dev,ou=Groups,dc=dir,dc=garr,dc=it" si consentira' il login solo ai membri di Sw Dev
    *
    *    @param string $basedn basedn es. "dc=garr,dc=it"
    */
    public function setBaseDn($basedn)
    {
        $this->BaseDn=$basedn;
    }

    public function getPrintableLDAPAvailability(){
           $old_error_handler = set_error_handler("myErrorHandler");
           $htmlToReturn="<br/>";
           if($enforceServer==null){
                $retry=true;
                $tempArr=$this->ServerList;
                $ServerUp=0;
                $ServerDown=0;
                while ($retry){
                    $serverToUse = rand(0,count($tempArr)-1);
                    $current = array_splice($tempArr, $serverToUse, 1); //array splice estrae uno elemento dall'array (rimuovendolo)
                    try{
                        $this->_checkServer($current[0]);
                        $htmlToReturn .=  $current[0]["name"] ."<span style='color:green;'> [AVAIL] </span><hr/>";
                        $ServerUp++;
                    }catch(Exception $e){
                        $htmlToReturn .=  $current[0]["name"] ."<span style='color:red;'> [FAILED] </span><hr/>";
                        $ServerDown++;
                    }
                    if (count($tempArr)<=0){
                         $retry=false;
                    }
                }
        }else{
            try {
                $this->_checkServer($this->ServerList[$enforceServer]);
                $htmlToReturn .=  $this->ServerList[$enforceServer]["name"] ."<span style='color:green;'> [AVAIL] </span><hr/>";
                $ServerUp++;
            }catch(Exception $e){
                 $htmlToReturn .=  $this->ServerList[$enforceServer]["name"] ."<span style='color:red;'> [FAILED] </span><hr/>";
                 $ServerDown++;
            }
        }
        set_error_handler($old_error_handler);
        return "<br/><div onClick=\"if (document.getElementById('_LdapAuthenticator_ServerStats').style.display==''){ document.getElementById('_LdapAuthenticator_ServerStats').style.display='none'; }else{ document.getElementById('_LdapAuthenticator_ServerStats').style.display='';}\" style=\"background:lightyellow; cursor:pointer;\"> "
                .$ServerUp." LDAP server(s) available
                </div>
                <div id=\"_LdapAuthenticator_ServerStats\" style=\"background:lightyellow; display:none;\">".$htmlToReturn."</div>";
    }

    private function _checkServer($serverObj){
        $toreturn = $this->AUTH_FAILED;
        if ($this->useLDAPS) {
            $server = "ldaps://".$serverObj["ip"];
            $port = $serverObj["sslport"];
        }
        else{
            $server = $serverObj["ip"];
            $port = $serverObj["port"];
        }
        $connect=ldap_connect($server,$port);
        if (!$connect) {
            $this->log($this->Username ." ha effettuato un tentativo di log-in ma c'e' stato un errore nella connessione con il server ldap");
            throw new Exception("Errore nella connessione LDAP");
           // return $this->AUTH_FAILED;
        }
        ldap_set_option($connect,LDAP_OPT_PROTOCOL_VERSION,3);

        if ($this->useStartTLS){
            if(!ldap_start_tls($connect)){
                $this->log($this->Username ." ha tentato il login ma c'e' stato un errore nello start TLS su LDAP");
                throw new Exception("Errore Start TLS");
              //  return $this->AUTH_FAILED;
            }
        }
        // Effettuo bind con l'utente di servizio per effettuare un search dell'username e capire
        // in che punto dell'albero ldap si trova (e' una tecnica standard, anche PAM fa cosi)
        if ($abind = ldap_bind($connect,$this->serviceUser,$this->serviceSecret))
        {

            $sr= ldap_search($connect, $this->BaseDn, "(cn=*)");//test query
            $info = ldap_get_entries($connect, $sr);
            $credentials= $info[0]["dn"];
            //parso il _parentNode:
            preg_match("/^cn=[^,]*,(.*)/",$credentials,$matches);
            $_parentNode=$matches[1];

        } else{
             throw new Exception("Utenza di servizio non valida");
        }
        ldap_unbind($connect);
    }

 /*
    *   Effettua il login LDAP con le credenziali precedentemente impostate e ritorna $LOGIN_SUCCESSFULL in caso di successo e $LOGIN_FAILED in caso di insucesso
    *
    *    @param string $url indirizzo della pagina
    *	 @returns integer AUTH_FAILED in caso di fallimento e AUTH_SUCCESSFULL in caso di login avvenuto
    *	 @see LDAPAuth::setCredentials()
    */
    public function Authenticate(){
        $old_error_handler = set_error_handler("myErrorHandler");
        if($enforceServer == null){
            $retry=true;
            $tempArr=$this->ServerList;
            while ($retry){
                $serverToUse=rand(0,count($tempArr)-1);
                $current = array_splice($tempArr, $serverToUse, 1); //array splice estrae uno elemento dall'array (rimuovendolo)
                try{
                    return $this->_Authenticate($current[0]);
                    $retry=false;
                }catch(Exception $e){
                    if (count($tempArr)<=0){
                        $retry=false;
                        set_error_handler($old_error_handler);
                        throw $e;
                    }
                }
            }
        }else{
            try{
                return $this->_Authenticate($this->ServerList[$enforceServer]);
            }catch(Exception $e){
                    set_error_handler($old_error_handler);
                    throw $e;
            }
        }
        set_error_handler($old_error_handler);

    }


    private function _Authenticate($serverObj)
    {
        if($this->Username == "" || $this->Password == ""){  //non permette autenticazioni anonime
            $this->log("Tentativo di autenticazione vuoto (no user, no password)");
            return $this->AUTH_FAILED;
        }

        $toreturn = $this->AUTH_FAILED;


        if ($this->useLDAPS) {
            $server = "ldaps://".$serverObj["ip"];
            $port = $serverObj["sslport"];
        }
        else{
            $server = $serverObj["ip"];
            $port = $serverObj["port"];
        }
        $usedServerString = $serverObj["name"]." (".$server.":".$port.")";
        $this->log("\n[DEBUG SERVER LDAP]".$this->Username ."  tentativo di autenticazione attraverso il server : " .$usedServerString);

        $connect=ldap_connect($server,$port);
        if (!$connect) {
            $this->log($this->Username ." ha effettuato un tentativo di log-in ma c'e' stato un errore nella connessione con il server ldap");
            throw new Exception("Errore nella connessione LDAP");
           // return $this->AUTH_FAILED;
        }
        ldap_set_option($connect,LDAP_OPT_PROTOCOL_VERSION,3);

        if ($this->useStartTLS){
            if(!ldap_start_tls($connect)){
                $this->log($this->Username ." ha tentato il login ma c'e' stato un errore nello start TLS su LDAP");
                throw new Exception("Errore Start TLS");
              //  return $this->AUTH_FAILED;
            }
        }

        $credentials= "";
        $_parentNode="";
        // Effettuo bind con l'utente di servizio per effettuare un search dell'username e capire
        // in che punto dell'albero ldap si trova (e' una tecnica standard, anche PAM fa cosi)
        if ($abind = ldap_bind($connect,$this->serviceUser,$this->serviceSecret))
        {
            $sr= ldap_search($connect, $this->BaseDn, "(&(".$this->UIDAttributeName."=".$this->Username.")".$this->Filter.")");
            $info = ldap_get_entries($connect, $sr);
            $credentials= $info[0]["dn"];
            //parso il _parentNode:
            preg_match("/^cn=[^,]*,(.*)/",$credentials,$matches);
            $_parentNode=$matches[1];

        } else{
             throw new Exception("Utenza di servizio non valida");
        }
        ldap_unbind($connect);

        if ($credentials==""){
            $this->log($this->Username ." utente non trovato su LDAP");
            return $this->AUTH_FAILED;
        }

        $link=ldap_connect($server,$port);
        if (!$link) {
            set_error_handler($old_error_handler);
            $this->log($this->Username ." ha effettuato un tentativo di log-in ma c'e' stato un errore nella connessione con il server ldap");
            return $this->AUTH_FAILED;
        }

        ldap_set_option($link,LDAP_OPT_PROTOCOL_VERSION,3);
        if ($this->useStartTLS){
            if(!ldap_start_tls($link)){
                set_error_handler($old_error_handler);
                $this->log($this->Username ." ha tentato il login ma c'e' stato un errore nello start TLS su LDAP");
                return $this->AUTH_FAILED;
            }
        }

        try {
            $bind = ldap_bind($link, $credentials ,$this->Password);
        }
        catch( Exception $e ) {

            $bind=false;
        }
        // Una volta ottenuto il dn dell'utente provo a fare il bind
        if ($bind) {
            $this->log($this->Username ." si e' loggato con successo!");
            //il login e' avvenuto:
            $toreturn=$this->AUTH_SUCCESSFULL;

            //faccio una ricerca per ottenere tutti gli attributi dell'utente
            $sr= ldap_search($link, $credentials, "(cn=*)");
            $info = ldap_get_entries($link, $sr);

            //non consiglio l'uso in produzione di questo tipo di cookies
            if ($this->useCookies===true)
            {
                setcookie("LDAPCookie[user]",$this->Username,$this->CookieExpire);
                setcookie("LDAPCookie[password]",$this->Password,$this->CookieExpire);
            }


            $OLD_ERR_SETTING = error_reporting(0);	//disabilito temporaneamente il print degli errori di PHP
            try{  //personalizzato GARR: provo ad ottenere alcuni attributi autorizzativi:
                $this->AuthorizativeActivities=$info[0][$this->AuthorizativeAttrName];
                $this->AuthorizativeAttrs= json_decode($info[0][$this->AuthorizativeJSONAttrName][0],true);
            }catch(Exception $e){
                //in caso di fallimento non fa' nulla poiche questa classe e' general purpose e anziche usabile solo con il server LDAP garr
            }
            error_reporting($OLD_ERR_SETTING); //ripristiono il vecchio livello di report degli errori

            $aString="";
            foreach ($this->AuthorizativeAttrs as $aAttr=>$aValue){
                $aString .= $aAttr."->".$aValue." ";
            }
            $this->log("[INFO AUTORIZZAZIONE]".$this->Username ." al momento dispone dei seguenti attributi autorizzativi: " .$aString);
            $aString="";
            foreach ($this->AuthorizativeActivities as $aAttr){
                $aString .= $aAttr ." ";
            }
            $this->log("[INFO AUTORIZZAZIONE]".$this->Username ."  al momento e' coinvolto nelle seguenti attivita' : " .$aString);

            if ($this->useSession===true)
            {

                session_name($this->SessionName);
                session_start();

                try{ //se ci sono aggiungo nella session gli attributi autorizzativi
                    $_SESSION["LdapAuthenticator_UsedServer"]= $usedServerString;
                    $_SESSION["LdapAuthenticator_AuthorizativeAttrs"]=$this->AuthorizativeAttrs;
                    $_SESSION["LdapAuthenticator_AuthorizativeActivities"]=$this->AuthorizativeActivities;
                    $this->log("[INFO AUTORIZZAZIONE]".$this->Username ." gli attributi autorizzativi sono stati esportati correttamente nella session:\n\t \$_SESSION['LdapAuthenticator_AuthorizativeAttrs'], \$_SESSION['LdapAuthenticator_AuthorizativeAttrs']");
                }catch(Excetion $e){//in caso di fallimento non fa' nulla poiche questa classe e' general purpose e anziche usabile solo con il server LDAP garr
                }
                $_SESSION["username"] = $this->Username;
                foreach ($this->SessionAttrs as $attrname=>$ldapfield){
                    if ($ldapfield=="_parentNode"){
                        $_SESSION[$attrname]=$_parentNode;
                    }
                    else{
                        $_SESSION[$attrname] = $info[0][$ldapfield][0];
                    }
                }
            }
            if ($this->useLocalAttrStorage===true)
            {

                foreach ($this->SessionAttrs as $attrname=>$ldapfield){
                    if ($ldapfield=="_parentNode"){
                       $this->LocalAttrs[$attrname]=$_parentNode;
                    }
                    else{
                        $this->LocalAttrs[$attrname]=$info[0][$ldapfield][0];
                    }
                }

            }
            // se e' impostata una redirect page
            if ($this->redirectPage !="")
            {
                header("Location: ".$this->redirectPage);
            }

            ldap_unbind($link);
        }
        else{
            // echo ldap_error($link);
            $this->log($this->Username ." bind dell'utente fallito (invaid credentials)");
            if ($this->useSession===true)
            {
                session_name($this->SessionName);
                session_start();
                foreach ($this->AnonymousSessionAttrs as $attrname=>$value){
                    $_SESSION[$attrname] = $value;
                }
            }
            if ($this->useLocalAttrStorage===true)
            {
                foreach ($this->AnonymousSessionAttrs as $attrname=>$value){
                    $this->LocalAttrs[$attrname] = $value;
                }

            }

            if ($this->redirectErrorPage !="")
            {
                header("Location: ".$this->redirectErrorPage ."?error=Authentication%20Failed!");
            }
        }



        echo $DTD;

        return $toreturn;

    }

}
?>
