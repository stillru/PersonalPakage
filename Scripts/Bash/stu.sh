#!/bin/sh

user="stillru"
pass="wearepbd"
curl="/usr/bin/curl"

$curl --basic --user "$user:$pass" --data-ascii \
  "status=`echo $@ | tr ' ' '+'`" \
  "http://twitter.com/statuses/update.json"

exit 0
