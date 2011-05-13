#!/bin/bash
x=`tr -cd [:alnum:] < /dev/urandom | head -c8`
echo ${x:0:4}-${x:4:4}"	 $1	"	`date` >> password.txt
gpg -c password.txt
rm password.txt
