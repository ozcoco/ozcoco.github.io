#! /bin/bash

echo "请输入yes或者no"

read YN

case "$YN" in 
YES|Y|y|yes)
	echo "$YN,contine";;
[nN]*)
	echo "$YN,exit";
	exit 0;;
*)
	echo "$YN ,未知操作";
	exit 1;;
esac
exit 0

