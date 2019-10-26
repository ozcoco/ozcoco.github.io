#! /bin/bash


echo "please input:"

read MY_IN

while [ "$MY_IN" != 'while.sh' ];
do
	echo "try";

	read MY_IN
done

cat $MY_IN

unset MY_IN

exit 0
