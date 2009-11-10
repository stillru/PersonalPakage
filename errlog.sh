#!/bin/bash
# Simple SHELL script for Linux and UNIX system monitoring with
# ping command
# -------------------------------------------------------------------------
# Copyright (c) 2006 nixCraft project <http://www.cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
# Setup email ID below
# See URL for more info:
# http://www.cyberciti.biz/tips/simple-linux-and-unix-system-monitoring-with-ping-command-and-scripts.html
# -------------------------------------------------------------------------
 
# add ip / hostname separated by white space
HOSTS="patrockl ovidii margo gella master brut burn caesar zerghost sancho pansa 10.10.5.250 10.10.5.251 10.10.5.252 10.10.5.253 10.10.5.245"
 
# no ping request
COUNT=2
 
for myHost in $HOSTS
do
  count=$(ping -c $COUNT -i 1 $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $count -eq 0 ]; then
    # 100% failed
    python /bin/xsend.py still-storm@ya.ru $myHost is down \(ping failed\) at $(date -R);
    else 
    python /bin/xsend.py still-storm@ya.ru "All green at $myHost" ;
  fi
done
