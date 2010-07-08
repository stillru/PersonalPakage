<?php
 
function PostToHost($host, $port, $username, $password, $data_to_send)
{
    $dc = 0;
   $bo ="-----------------------------305242850528394";
 
    $fp = fsockopen($host, $port, $errno, $errstr);
    if (!$fp) {
        echo "errno: $errno \n";
        echo "errstr: $errstr\n";
        return $result;
    }
 
    fputs($fp, "POST / HTTP/1.1\r\n");
    if ($username != "") {
       $auth = $username . ":" . $password;
       echo "auth: $auth\n";
       $auth = base64_encode($auth);
       echo "auth: $auth\n";
       fwrite($fp, "Authorization: Basic " . $auth . "\r\n");
    }
    fputs($fp, "User-Agent: NowSMS PHP Script\r\n");
    fputs($fp, "Accept: */*\r\n");
    fputs($fp, "Content-type: multipart/form-data; boundary=$bo\r\n");
 	
    foreach($data_to_send as $key=>$val) {
        $ds =sprintf("%s\r\nContent-Disposition: form-data; name=\"%s\"\r\n%s\r\n",$bo,$key,$val);
        $dc += strlen($ds);
        
    }
    $dc += strlen($bo)+3;
    fputs($fp, "Content-length: $dc\r\n");
    fputs($fp, "\r\n");
    fputs($fp, "This is a MIME message\r\n\r\n");

    foreach($data_to_send as $key=>$val) {
        $ds =sprintf("%s\r\nContent-Disposition: form-data; name=\"%s\"\r\n%s\r\n",$bo,$key,$val);
        fputs($fp, $ds );
    }
    $ds = $bo."--\r\n" ;
    fputs($fp, $ds);

    $res = "";
 
    while(!feof($fp)) {
        $res .= fread($fp,1);
    }
    fclose($fp);
    
 
    return $res;
}



$file1="C:\\TEMP\\logo.gif";
$contenttype1 = "image/gif";
 
$fa = @file($file1);
$xf ="Content-Type: ".$contenttype1."\r\n\r\n".implode("",$fa);
$data["MMSFile\"; filename=\"$file1"]   = $xf;

$file2="C:\\TEMP\\test.smil";
$contenttype2 = "application/smil";

$fa = @file($file2);
$xf="Content-Type: ".$contenttype2."\r\n\r\n".implode("",$fa);
$data["MMSFile\"; filename=\"$file2"]   = $xf;

/* Repeat this sequence for additional parts
$file3="C:\\TEMP\\?????.???";
$contenttype3 = "?????";

$fa = @file($file3);
$xf="Content-Type: ".$contenttype3."\r\n\r\n".implode("",$fa);
$data["MMSFile\"; filename=\"$file3"]   = $xf;
*/


/* A quirk of this script is that you must start all non-file parameters with \r\n */
$data["MMSFrom"]     = "\r\n" . "sender@domain.com";
$data["PhoneNumber"] = "\r\n" . "+44999999999";
$data["MMSSubject"]  = "\r\n" . "Subject of message" ; 

/* The MMSText field is optional */
$data["MMSText" ]    = "\r\n" . "Hello!" ; 


 
$x   = PostToHost("127.0.0.1", 81, "test", "test", $data);
echo $x;



		



 
?>

