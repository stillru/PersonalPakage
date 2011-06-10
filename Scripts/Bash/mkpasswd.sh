#!/bin/bash
x=`tr -cd [:alnum:] < /dev/urandom | head -c8`
if [ $1 = ""]; then
	echo "Need some information about Pepole"
else
gpg password.txt.gpg
echo ${x:0:4}-${x:4:4}"	 $1	"	`date` >> password.txt
gpg -c password.txt
echo $x $1 `date`
rm password.txt
fi
