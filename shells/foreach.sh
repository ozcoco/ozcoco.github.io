#! /bin/bash

for E in a b c d e;
do
	echo "$E";
done


touch file0 file1 file2

for FN in file?;
do
	echo "$FN";
done



for FN in `ls file?`;
do
	echo "--> $FN";
done


for FN in $(ls file?);
do
	echo "**-> $FN";
done

rm file?

exit 0
