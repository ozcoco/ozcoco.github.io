#! /bin/bash

read MY_FILE

if [ -f "$MY_FILE" ];
then 
 cat "$MY_FILE";
elif [ "$MY_FILE" != '' ];
then
 echo "The input is chars";
else
 echo "The input is some";
fi 

exit 0
