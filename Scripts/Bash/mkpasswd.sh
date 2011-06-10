#!/bin/bash
x=`tr -cd [:alnum:] < /dev/urandom | head -c8`
if [ $1 = ""]; then
	echo "Need some information about Pepole"
elif [ $2 ="" ]; then
	echo "Need token Serial Number"
else
gpg password.txt.gpg
echo ${x:0:4}-${x:4:4}"	 $1 $2	"	`date` >> password.txt
gpg -c password.txt
echo $x $1 `date`
rm password.txt
fi
