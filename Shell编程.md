# Shell编程

------

## 常用命令

### rsync （文件夹同步）

```
rsync -avu --delete "/home/user/A/" "/home/user/B"
```

- `-a` Do the sync preserving all filesystem attributes
- `-v` run verbosely
- `-u` only copy files with a newer modification time (or size difference if the times are equal)
- `--delete` delete the files in target folder that do not exist in the source

```shell
rsync -avu --delete ./ ./github.io/ozcoco.github.io/
```

### ln (软硬连接)

#### 创建软连接

```shell
touch file1 file2 file3 file31 file32 file33
mkdir test
#1
ln -s file1 test/file1
#2
ln -s -t test file2
#3 批量创建
ln -s -t test file3* 
```

#### 创建硬连接

```shell
touch file1 file2 file3 file31 file32 file33
mkdir test
#1
ln file1 test/file1
#or ln -P file1 test/file1
#2
ln -P -t test file2
#3 批量创建
ln -P -t test file3* 
```



## 变量

### 定义变量

shell中所有变量均为string

```shell
var=100	//='100'
export var=1000 //='1000'
var=$[3+6]   //='8'
unset var	//变量设置
```

### 命令代换

```shell
#方式1：
var=$(ls -il)
#方式2：
var=`ls -il`
echo $var //无\n
echo "$var" //有\n
echo $[var] //有\n
echo $[$var] //有\n
echo $(($var)) //有\n
echo $((var))	//有\n
echo '$var'	//打印结果：$var

```

### ‘与“与`

单引号（'）不可扩展，双引号（"）可扩展

```shell
var=$(ls -il)
echo "$var" 

#结果：
 162093 -rwxrwxrwx. 1 ozcomcn ozcomcn     25 Oct 25 14:27 Android编程.md
 162088 -rwxrwxrwx. 1 ozcomcn ozcomcn     21 Oct 25 14:25 C++编程.md
 162091 -rwxrwxrwx. 1 ozcomcn ozcomcn     25 Oct[ -z '1234' ]
echo $? //1 25 14:25 Flutter编程.md
1160559 drwxrwxrwx. 1 ozcomcn ozcomcn      0 Oct 25 15:17 github.io
1164202 drwxrwxrwx. 1 ozcomcn ozcomcn  20480 Oct  8 18:04 images
1164293 drwxrwxrwx. 1 ozcomcn ozcomcn   8192 Oct  8 18:04 images2
1132862 -rwxrwxrwx. 1 ozcomcn ozcomcn  27040 Oct 16 17:20 Interview.md
1161080 -rwxrwxrwx. 1 ozcomcn ozcomcn   4831 Oct 24 16:42 Java编程.md
1114992 -rwxrwxrwx. 1 ozcomcn ozcomcn  24680 Oct 25 14:43 Linux系统编程.md
2813097 -rwxrwxrwx. 1 ozcomcn ozcomcn    152 Oct 24 01:00 Linux网络编程.md
1160504 -rwxrwxrwx. 1 ozcomcn ozcomcn     21 Oct 25 14:43 MCU编程.md
1160473 -rwxrwxrwx. 1 ozcomcn ozcomcn     24 Oct 25 14:30 Script编程.md
1163394 drwxrwxrwx. 1 ozcomcn ozcomcn      0 Oct 25 16:32 shells
1152848 -rwxrwxrwx. 1 ozcomcn ozcomcn    903 Oct 25 19:28 Shell编程.md
1164349 -rwxrwxrwx. 1 ozcomcn ozcomcn 154965 Jul 22 16:21 SpringBoot入门简介.md
1164350 -rwxrwxrwx. 1 ozcomcn ozcomcn  59076 Jul 22 16:21 SpringBoot高级教程.md
1160474 -rwxrwxrwx. 1 ozcomcn ozcomcn     21 Oct 25 14:31 SQL编程.md
1163760 -rwxrwxrwx. 1 ozcomcn ozcomcn    601 Oct 24 17:13 数据结构与算法.md
1160505 -rwxrwxrwx. 1 ozcomcn ozcomcn     30 Oct 25 14:43 音视频编解码.md

```

```shell
var=$(ls -il)
echo '$var'

#结果：
$var
```

反引号（`）：可定义命令代换

```shell
var=`ls -il`
```



### 算术运算（[ ]）

```shell
var=$[5+7]	//='12'
var2=2	//='2'
#1:
var3=$[$var+$var2]
#2:
var3=$[var+var2]

#结果：
14

```

### 进制运算（#）

```shell
var=$[16#b]	//='11'
var2=10
var3=$[$var+$var2]
echo "$var3"

#结果
21
```

### 比较运算（test）

条件成立为0，反之为1，$?为返回结果

#### 等于（-eq）

```shell
var=10
test $var -eq 100
echo $? //1
```

#### 不等于（-n）

```shell
var=10
test $var -n 100
echo $? //0
```

#### 小于（-lt）

```shell
var=10
#1
test $var -lt 100
#2
[ $var -lt 100 ]
echo $? //0
```

#### 小于等于（-le）

```shell
var=10
test $var -le 100
echo $? //0
```

#### 大于（-gt）

```shell
var=10
test $var -gt 100
echo $? //1
```

#### 大于等于（-ge）

```shell
var=10
test $var -ge 100
echo $? //1
```

#### 是否空

```shell
#1
var=	//''
#2
var=''
#3
var=$null
test $var
echo $?	//0
```

#### 目录是否存在（-d）

```shell
#1
test -d shells/
#2
[ -d shells/ ]

echo $? //0
```

#### 普通文件是否存在（-f）

```shell
[ -f shells/a.sh ]
echo $?
```

#### 是否为管道文件（-p）

```shell
mkfifo fifo1
[ -p fifo1 ]
echo $?	//0
```

#### 字符串长度为0（-z）

```shell
[ -z '1234' ]
echo $? //1
```

字符串长度非0 （-n）

```shell
[ -n '1234' ]
echo $? //0
```

字符串相同（=）

```shell
[ '123' = '1234' ]
echo $?	//1
```

字符串不同（!=）

```shell
[ '123' != '1234' ]
echo $?	//0
```

#### 或（-o）

```shell
var=
mkfifo fifo1
[ -p fifo1 -o "$var" ] 
echo "$?" //0
unlink fifo1
```

#### 与（-a）

```shell
var=
mkfifo fifo1
[ -p fifo1 -a "$var" ] 
echo "$?" //1
unlink fifo1
```



## 分支语句

### if

```shell
#! /bin/sh
#符号“:” 表示/bin/true
if : ;
then
echo "always true";
fi
```

```shell
#! /bin/bash

read MY_FILE

if [ -f "$MY_FILE" ];
then 
 echo "The input is regury  file";
elif [ "$MY_FILE" != '' ];
then
 echo "The input is chars";
else
 echo "The input is some";
fi 

exit 0

```

### case

case用于精确控制，符号“;;”代表break

```shell
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

```

## 循环语句

### foreach

#### 字符串遍历

```shell
#! /bin/bash

for E in a b c d e;
do
	echo "$E";
done


touch file0 file1 file2

for FN in file?;
do
	echo "$FN";
	unlink $FN;
done

exit 0

```

#### 文件遍历

方式1：

```shell
#! /bin/bash

touch file0 file1 file2

for FN in file?;
do
	echo "$FN";
	unlink "$FN";
done

exit 0
```

方式2

```shell
#! /bin/bash

touch file0 file1 file2

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

```

