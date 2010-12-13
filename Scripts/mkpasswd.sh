#!/bin/bash
x=`tr -cd [:alnum:] < /dev/urandom | head -c8`
echo ${x:0:4}-${x:4:4}
