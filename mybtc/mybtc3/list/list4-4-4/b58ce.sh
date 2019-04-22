#!/bin/bash
input=`cat -`;
checksum=`echo $input | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -sha256 | cut -c10-17`
echo ${input}${checksum} | python3 ~/work/mywallet/base58encode.py;
