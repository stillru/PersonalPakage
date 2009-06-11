<?
$CompanyName = "one tow three foure";
$ValidDate = one;
$auto = two;
$LangRuTC = three;
$do = four;
exec(escapeshellcmd('convert logo.JPG -font /usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif-Bold.ttf -pointsize 16 -draw "gravity north fill black text 0,12 '. $CompanyName .' fill black text 1,11 '. $CompanyName .'" -pointsize 12 -draw "gravity north fill black text -39,32 '. $do .'" -pointsize 12 -draw "gravity north fill black text 66,32 '. $ValidDate .'" -pointsize 12 -draw "gravity north fill black text 0,54 '.$LangRuTC.' fill black text 1,53 '. $LangRuTC .'" -font /usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif-Bold.ttf -pointsize 16 -draw "gravity center fill black text 0,-20 '. $auto .' fill black text 1,-19 '. $auto .'" wmark_text_drawn.jpg'));
#readfile("out.jpg");
?>
