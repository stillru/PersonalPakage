<?php

include "Translit.class.php";

$translit = new Translit();
$translit->html_aware = true; //when this is true, Translit will skip transliterating cyrilic within html tags
$translit->case_sensitive = false; //this applies only if html_aware is set to true
echo $translit->Transliterate('<a href="http://hidrogeologija.avramovic.org/?home=тест ћирилице">Филипов сајт</a>');

?>
