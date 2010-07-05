<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title></title>
<meta name="generator" content="Bluefish 1.0.7">
<meta name="author" content="still">
<meta name="date" content="2010-07-05T14:26:44+0400">
<meta name="copyright" content="still.ru@gmail.com">
<meta name="keywords" content="">
<meta name="description" content="">
<meta name="ROBOTS" content="NOINDEX, NOFOLLOW">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8">
<meta http-equiv="content-style-type" content="text/css">
<meta http-equiv="expires" content="0">
<meta >
</head>
<body>
<?
if ($_SERVER['REQUEST_METHOD']=='POST') {
  //обрабатываем полученные переменные.
  foreach($_POST as $key => $value) {
    //сначала делаем обработку, которая не испортит данные,
    //если их придется выводить в форму снова, при ошибке
    $value=trim($value); // убираем пробелы в начале и в конце переменной.
    if (get_magic_quotes_gpc()) $value = stripslashes($value); //убираем слеши, если надо
    $value=htmlspecialchars($value,ENT_QUOTES); //заменяем служебные символы HTML на эквиваленты
    $_POST[$key]=$value; //все изменения записываем в массив $_POST
    //дальше делаем изменения, которые пойдут только в файл,
    //а в форму их выводить не нужно.
    $value=str_replace("\r","",$value); // заменяем все переводы строк
    $value=str_replace("\n","<br>",$value); //на <br>
    $msg[$key]=$value; //и присваиваем новые значения элементам массива $msg.
  }
  //дальше делаем разнообразные проверки. Они здесь для
  //примера, вы можете добавлять, какие захотите
  //главное то, что при любых ошибках переменная $err становится не пустой.
  //то есть, она одновременно является и флагом ошибки и
  //содержит все сообщения об ошибках.
  $err='';
  if (!$name) $err.="Вы забыли написать свое имя<br>";
  if (!$notes) $err.="Вы забыли написать сам отзыв!<br>";
  if (strlen($name) > 30) $err.="Длина имени не может превышать 30 символов<br>";
  if (strlen($notes) > 1000) $err.="Длина отзыва не может превышать 1000 символов<br>";
  if (strlen($email) > 50) $err.="емейл длинноват...<br>";
  if (preg_match("/[0-9a-zA-Zа-яА-ЯЁё]{30,}/",$notes,$matches)) {
    $err.="В отзыве присутствует слишком длинное слово ".$matches[0].". Cократите или разбейте его, пожалуйста.";
  }
  $email_ok=eregi("^([_\.0-9a-z-]+@)([0-9a-z][0-9a-z-]+\.)+([a-z]{2,4})$", $email);
  if (!$email_ok && $email) $err.="Ошибка в емейле. Если не хотите, то просто не пишите!<br>";
  //если ошибок нет, то пишем в файл
  if (!$err) {
    $s=$msg['name']."|".$msg['email']."|".$msg['notes']."|".time()."\n";
    $fp=fopen("gbook.txt","a");
    fwrite($fp,$s);
    fclose($fp);
    //после записи перенаправляем браузер на страницу,
    //которая отображает сообщения
    Header("Location: ".$_SERVER['PHP_SELF']);
    //и обязательно завершаем работу скрипта
    exit;
  }
  //если у нас были ошибки при заполнении формы, то в файл
  //ничего не запишется, скрипт не завершится, а выведется
  //форма, с заполненными полями и сообщения об ошибках
} else {
  //если это не пост, то присваиваем переменным, выводимым
  //в форме пустую строку
  $_POST['name'] = $_POST['email'] = $_POST['notes'] ='';
}
?>
<? if ($err) echo '<font color=red><b>'.$err.'</b></font>'; ?>
<form action="<? echo $_SERVER['PHP_SELF'] ?>" method="POST"><br>
Name: <input type="text" name="name" value="<? echo $_POST['name'] ?>"><br>
Email: <input type="text" name="email" value="<? echo $_POST['email'] ?>"><br>
Notes: <textarea rows="3" cols="30" name="notes"><? echo $_POST['notes'] ?></textarea><br>
<input type="submit" name="submit">
</form>
</body>
</html> 
</body>
</html>
