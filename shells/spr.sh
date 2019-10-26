#! /bin/bash

echo $0
echo "1:$1"
echo "2:$2"
echo "3:$3"
echo "4:$4"
echo "len:$#"

echo "@list:$@"
echo "*list:$*"

for MY_IN in "$@";
do
	echo "$MY_IN";
done

echo "$?"

echo "pid:$$"

shift
echo "1:$1"

exit 0
