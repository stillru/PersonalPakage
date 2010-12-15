<?php

include "Translit.class.php";

$translit = new Translit();
$translit->html_aware = false; //when this is true, Translit will skip transliterating cyrilic within html tags
$translit->case_sensitive = false; //this applies only if html_aware is set to true

$translit->cirilica[] = 'Я'; //add russian cyrillic letter "Ya" (uppercase)
$translit->latinica[] = 'Ya'; //transliterate it to latin

$translit->cirilica[] = 'я'; //add russian cyrillic letter "ya" (lowercase)
$translit->latinica[] = 'ya'; //transliterate it to latin

echo $translit->Transliterate('Меня зовут Неманя Аврамовић'); //test in bad russian

?>
