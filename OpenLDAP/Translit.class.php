<?php

#
# Translit PHP class by Avram, avramyu@gmail.com
# Dedicated to my early died brother Filip
# Credit is due
#

class Translit {

	var $html_aware = false;
	var $case_sensitive = false;
	var $cirilica = array("љ", "њ", "е", "р", "т", "з", "у", "и", "о", "п", "ш", "ђ", "ж", "а", "с", "д", "ф", "г", "х", "ј", "к", "л", "ч", "ћ", "џ", "ц", "в", "б", "н", "м", "Љ", "Њ", "Е", "Р", "Т", "З", "У", "И", "О", "П", "Ш", "Ђ", "Ж", "А", "С", "Д", "Ф", "Г", "Х", "Ј", "К", "Л", "Ч", "Ћ", "Џ", "Ц", "В", "Б", "Н", "М");
	var $latinica = array("lj", "nj", "e", "r", "t", "z", "u", "i", "o", "p", "š", "đ", "ž", "a", "s", "d", "f", "g", "h", "j", "k", "l", "č", "ć", "dž", "c", "v", "b", "n", "m", "Lj", "Nj", "E", "R", "T", "Z", "U", "I", "O", "P", "Š", "Đ", "Ž", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Č", "Đ", "DŽ", "C", "V", "B", "N", "M");


  function tagsafe_replace($search, $replace, $subject, $casesensitive = false)  {
    $subject = '>' . $subject . '<';
    $search = preg_quote($search);
    
    $cs = !$casesensitive ? 'i' : '';
    
    preg_match_all('/>[^<]*(' . $search . ')[^<]*</i', $subject, $matches, PREG_PATTERN_ORDER);
    
    foreach($matches[0] as $match)
    {
        $tmp     = preg_replace("/($search)/", $replace, $match);
        $subject = str_replace($match, $tmp, $subject);
    }

    return substr($subject, 1, -1);
  } 


  function Transliterate($cyrilic) {
    if ($this->html_aware) {
      for ($i=0;$i<count($this->cirilica);$i++) {
        $cyrilic = $this->tagsafe_replace($this->cirilica[$i],$this->latinica[$i],$cyrilic,$this->case_sensitive);
      }
      return $cyrilic;
    } else {
      return str_replace($this->cirilica, $this->latinica, $cyrilic);  
    }
  }

}

?>
