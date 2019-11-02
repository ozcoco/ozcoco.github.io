#! /bin/bash

rsync -avu ./ ../github.io/ozcoco.github.io/

if [ $? ];
then
    echo "同步完成";
else
    echo "同步失败！";
    exit 1;
fi

exit 0
