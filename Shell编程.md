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

### echo（打印）

-n     do not output the trailing newline（不尾随换行）

-e     enable interpretation of backslash escapes（转义）

-E     disable interpretation of backslash escapes (default)（不转义）

```shell
echo "123"	//123
echo "123\n4"	//123\n4
echo -e "123\n4"
结果：
123
4
echo -n -e "123\n4"
结果：
123
4[ozcomcn@localhost shells]$ 
```

### tee

read from standard input and write to standard output and files

Copy standard input to each FILE, and also to standard output.

 -a, --append
          append to the given FILEs, do not overwrite

   -i, --ignore-interrupts
          ignore interrupt signals

   -p     diagnose errors writing to non pipes

   --output-error[=MODE]
          set behavior on write error.  See MODE below

```shell
df -a | tee out
cat out
```

### df

report file system disk space usage

```shell
df
结果：
Filesystem                              1K-blocks      Used Available Use% Mounted on
devtmpfs                                  8110092         0   8110092   0% /dev
tmpfs                                     8127792    409160   7718632   6% /dev/shm
tmpfs                                     8127792      2152   8125640   1% /run
tmpfs                                     8127792         0   8127792   0% /sys/fs/cgroup
/dev/mapper/fedora_localhost--live-root  64728684  19975280  41435644  33% /
tmpfs                                     8127792      4484   8123308   1% /tmp
/dev/mapper/fedora_localhost--live-home  31602528  17631452  12342712  59% /home
/dev/nvme0n1p3                             999320    235156    695352  26% /boot
/dev/nvme0n1p2                             204580     18344    186236   9% /boot/efi
tmpfs                                     1625556        32   1625524   1% /run/user/42
tmpfs                                     1625556        92   1625464   1% /run/user/1000

```

### tail

output the last part of files

```shell
tail -f out //实时打印
```

### |，>，>> ，<，<<，1，2，3

```shell
1	//标准输入
2	//标准输出
3	//标准错误
top | tee out //管道
echo "12345" > out //输出重定向，覆盖写入
echo "12345" >> out //输出重定向，追加写入
asdfasdf 2>out //标准输出到out文件
cat < out > out2	//输入重定向
```

### wc

print newline, word, and byte counts for each file

​    -c, --bytes
​              print the byte counts

   -m, --chars
          print the character counts

   -l, --lines
          print the newline counts

   --files0-from=F
          read input from the files specified by NUL-terminated names in file  F;
          If F is - then read names from standard input

   -L, --max-line-length
          print the maximum display width

   -w, --words
          print the word counts

```shell
echo -e "214124\n3143" > out
wc -c < out //12
wc -m < out //12
wc -l < out //2
wc -w < out	//2
```

### find

find [-H] [-L] [-P] [-D debugopts] [-Olevel] [starting-point...] [expression]

#### -name

```shell
find . -name "*.sh"
```

#### -type

​	f	普通文件

​	d	文件夹

​	p	管道

​	c	字符设备

​	b	块设备

​	s	socket

​	l	软连接

```shell
find . -type l
```

#### -size

​	默认单位：512b ---> 0.5k -->  一个磁盘扇区大小

​	b,k,M

```shell
find /tmp -size +3M -size -7M	//大于3M小于7M的文件
```

#### -maxdepth

​	递归深度：-maxdepth 2

```shell
find /usr -maxdepth 2 -type l | wc -l
```

#### -exec

整批处理

```shell
find . -name "*.sh" -exec ls -lh {} \;	//{}代表find语句，\;结束符号
```

#### -print

```shell
find . -name "*.sh" print0 | xargs -0 ls -hl //在find结果的每一条item后追加0字符
```

#### -xargs

​	分批处理

```shell
find . -name "*.sh" print0 | xargs -0 ls -hl //以0为分隔符拆分items
```

#### -atime -amin -mtime -mmin -ctime

​	time：天

​	min:	分钟

```shell
File: while.sh
  Size: 150       	Blocks: 1          IO Block: 4096   regular file
Device: 811h/2065d	Inode: 1167696     Links: 1
Access: (0777/-rwxrwxrwx)  Uid: ( 1000/ ozcomcn)   Gid: ( 1000/ ozcomcn)
Context: system_u:object_r:fusefs_t:s0
Access: 2019-10-26 15:25:03.018047300 +0800	//访问时间
Modify: 2019-10-26 15:24:57.739388200 +0800	//文件修改时间
Change: 2019-10-26 15:24:57.739388200 +0800	//文件属性修改时间
 Birth: -
```



```shell
find -amin +5	//5min前
find -atime +5	//5天前
```



### sed

Stream Editor，sed对一个文件当中的行进行处理，与vi同宗

命令格式：

​			sed	 参数	'脚本'	文件

参数：-i 	将修改写入文件，默认不写入修改

​		  -f	指定脚本文件

脚本：a	append

​		   i	insert

​		  d	delete

​		  s	substitution

sed.sh

```shell
#! /bin/bash

echo "$0"
echo "$@"
echo "$*"
echo "$$


exit 0
```

#### 追加（a）

```shell
sed '1aprintf "$#"' sed.sh //在第1行后追加一行 printf "$#"

结果：
#! /bin/bash
printf "$#"

echo "$0"
echo "$@"
echo "$*"
echo "$$


exit 0
```

#### 插入（i）

```shell
sed '1iprintf "$#"' sed.sh	//在第1行后插入一行 printf "$#"

结果：
printf "$#"
#! /bin/bash

echo "$0"
echo "$@"
echo "$*"
echo "$$


exit 0
```

#### 删除（d）

```shell
sed '1d' sed.sh	//删除第1行

结果：

echo "$0"
echo "$@"
echo "$*"
echo "$$


exit 0
```

#### 替换（s）

‘s/regexp/replacement/flags’

##### 替换指定行

```shell
sed '3s/echo/printf/g' sed.sh	//将第3行中‘echo’替换成‘printf’

结果：
#! /bin/bash

printf "$0"
echo "$@"
echo "$*"
echo "$$


exit 0
```

##### 替换指定多行

```shell
sed '3,5s/echo/printf/g' sed.sh	//将第3-5行中‘echo’替换成‘printf’

结果：
#! /bin/bash

printf "$0"
printf "$@"
printf "$*"
echo "$$


exit 0
```

##### 正则替换

```shell
sed '3,5s/.*/xxxxxxxx/g' sed.sh	//将第3-5行替换成‘xxxxxxxx’

结果：
#! /bin/bash

xxxxxxxx
xxxxxxxx
xxxxxxxx
echo "$$


exit 0
```



### awk

awk对一个文件当中的列进行处理，默认按制表符、空格拆分

awk	参数	'{脚本}'	文件 

脚本:

/pattern/{action}

condition{action}

参数：

​		-F   指定拆分分割符（如：-F ,）

​		-f	指定脚本文件

#### 关键词BEGIN和END

- BEGIN{ 这里面放的是执行前的语句 }
- END {这里面放的是处理完所有的行后要执行的语句 }
- {这里面放的是处理每一行时要执行的语句}

```shell
#!/bin/awk -f
#运行前
BEGIN {
    math = 0
    english = 0
    computer = 0
 
    printf "NAME    NO.   MATH  ENGLISH  COMPUTER   TOTAL\n"
    printf "---------------------------------------------\n"
}
#运行中
{
    math+=$3
    english+=$4
    computer+=$5
    printf "%-6s %-6s %4d %8d %8d %8d\n", $1, $2, $3,$4,$5, $3+$4+$5
}
#运行后
END {
    printf "---------------------------------------------\n"
    printf "  TOTAL:%10d %8d %8d \n", math, english, computer
    printf "AVERAGE:%10.2f %8.2f %8.2f\n", math/NR, english/NR, computer/NR
}
```



#### 运算符

| 运算符                  | 描述                             |
| :---------------------- | :------------------------------- |
| = += -= *= /= %= ^= **= | 赋值                             |
| ?:                      | C条件表达式                      |
| \|\|                    | 逻辑或                           |
| &&                      | 逻辑与                           |
| ~ 和 !~                 | 匹配正则表达式和不匹配正则表达式 |
| < <= > >= != ==         | 关系运算符                       |
| 空格                    | 连接                             |
| + -                     | 加，减                           |
| * / %                   | 乘，除与求余                     |
| + - !                   | 一元加，减和逻辑非               |
| ^ ***                   | 求幂                             |
| ++ --                   | 增加或减少，作为前缀或后缀       |
| $                       | 字段引用                         |
| in                      | 数组成员                         |

#### 内建变量

| 变量        | 描述                                                       |
| :---------- | :--------------------------------------------------------- |
| $n          | 当前记录的第n个字段，字段间由FS分隔                        |
| $0          | 完整的输入记录                                             |
| ARGC        | 命令行参数的数目                                           |
| ARGIND      | 命令行中当前文件的位置(从0开始算)                          |
| ARGV        | 包含命令行参数的数组                                       |
| CONVFMT     | 数字转换格式(默认值为%.6g)ENVIRON环境变量关联数组          |
| ERRNO       | 最后一个系统错误的描述                                     |
| FIELDWIDTHS | 字段宽度列表(用空格键分隔)                                 |
| FILENAME    | 当前文件名                                                 |
| FNR         | 各文件分别计数的行号                                       |
| FS          | 字段分隔符(默认是任何空格)                                 |
| IGNORECASE  | 如果为真，则进行忽略大小写的匹配                           |
| NF          | 一条记录的字段的数目                                       |
| NR          | 已经读出的记录数，就是行号，从1开始                        |
| OFMT        | 数字的输出格式(默认值是%.6g)                               |
| OFS         | 输出记录分隔符（输出换行符），输出时用指定的符号代替换行符 |
| ORS         | 输出记录分隔符(默认值是一个换行符)                         |
| RLENGTH     | 由match函数所匹配的字符串的长度                            |
| RS          | 记录分隔符(默认是一个换行符)                               |
| RSTART      | 由match函数所匹配的字符串的第一个位置                      |
| SUBSEP      | 数组下标分隔符(默认值是/034)                               |

```shell
$ awk 'BEGIN{printf "%4s %4s %4s %4s %4s %4s %4s %4s %4s\n","FILENAME","ARGC","FNR","FS","NF","NR","OFS","ORS","RS";printf "---------------------------------------------\n"} {printf "%4s %4s %4s %4s %4s %4s %4s %4s %4s\n",FILENAME,ARGC,FNR,FS,NF,NR,OFS,ORS,RS}'  log.txt
FILENAME ARGC  FNR   FS   NF   NR  OFS  ORS   RS
---------------------------------------------
log.txt    2    1         5    1
log.txt    2    2         5    2
log.txt    2    3         3    3
log.txt    2    4         4    4
$ awk -F\' 'BEGIN{printf "%4s %4s %4s %4s %4s %4s %4s %4s %4s\n","FILENAME","ARGC","FNR","FS","NF","NR","OFS","ORS","RS";printf "---------------------------------------------\n"} {printf "%4s %4s %4s %4s %4s %4s %4s %4s %4s\n",FILENAME,ARGC,FNR,FS,NF,NR,OFS,ORS,RS}'  log.txt
FILENAME ARGC  FNR   FS   NF   NR  OFS  ORS   RS
---------------------------------------------
log.txt    2    1    '    1    1
log.txt    2    2    '    1    2
log.txt    2    3    '    2    3
log.txt    2    4    '    1    4
# 输出顺序号 NR, 匹配文本行号
$ awk '{print NR,FNR,$1,$2,$3}' log.txt
---------------------------------------------
1 1 2 this is
2 2 3 Are you
3 3 This's a test
4 4 10 There are
# 指定输出分割符
$  awk '{print $1,$2,$5}' OFS=" $ "  log.txt
---------------------------------------------
2 $ this $ test
3 $ Are $ awk
This's $ a $
10 $ There $
```



#### 默认格式拆分

```shell
ps aux | awk '{print $11}'	//打印pa aux第11列

结果：
COMMAND
/usr/lib/systemd/systemd
[kthreadd]
[rcu_gp]
[rcu_par_gp]
[kworker/0:0H-kblockd]
[mm_percpu_wq]
[ksoftirqd/0]
[rcu_sched]
[migration/0]
[cpuhp/0]
[cpuhp/1]
[migration/1]
[ksoftirqd/1]
[kworker/1:0H-kblockd]
[cpuhp/2]
[migration/2]
[ksoftirqd/2]
[kworker/2:0H-kblockd]
[cpuhp/3]
[migration/3]
[ksoftirqd/3]
[kworker/3:0H-kblockd]
[cpuhp/4]
[migration/4]
[ksoftirqd/4]
[kworker/4:0H-kblockd]
[cpuhp/5]
[migration/5]
[ksoftirqd/5]
[kworker/5:0H-kblockd]
。。。
```

#### 指定格式拆分

##### 参数-F指定

```shell
awk -F : '{print $7}' /etc/passwd

结果：
/bin/bash
/sbin/nologin
/sbin/nologin
。。。
/bin/sync
/sbin/shutdown
/sbin/halt
。。。
/sbin/nologin
/sbin/nologin
。。。
/sbin/nologin
/sbin/nologin
```

##### 内建变量指定拆分符

```shell
awk 'BEGIN{FS=":"} {print $7}' /etc/passwd

结果：
/bin/bash
/sbin/nologin
/sbin/nologin
。。。
/bin/sync
/sbin/shutdown
/sbin/halt
。。。
/sbin/nologin
/sbin/nologin
。。。
/sbin/nologin
/sbin/nologin
```



#### 条件统计

脚本中可以定义变量，可以调用c语言函数

##### 统计行数

```shell
ps aux | awk '$2>1000 && $2<2000 {count=count+1} END {print count}'

结果：
40
```

##### 打印指定列并统计行数

```shell
ps aux | awk '$2>1000 && $2<2000 {count=count+1} {printf("%d\t%d\t%s\n",count,$2,$11)} END {print count}'

结果：
0	0	COMMAND
0	1	/usr/lib/systemd/systemd
0	2	[kthreadd]
0	3	[rcu_gp]
0	4	[rcu_par_gp]
0	6	[kworker/0:0H-kblockd]
。。。
0	219	[dm_bufio_cache]
0	222	[ipv6_addrconf]
0	229	[kstrp]
0	308	[kworker/11:1H-kblockd]
0	481	[scsi_eh_6]
0	482	[scsi_tmf_6]
。。。
0	528	[nvme-delete-wq]
0	532	[kworker/8:1H-kblockd]
0	539	[scsi_eh_7]
0	540	[scsi_tmf_7]
0	541	[usb-storage]
。。。
0	987	[nvidia-modeset/]
0	988	[nvidia-modeset/]
1	1005	[kdmflush]
2	1016	[irq/142-3-0008]
。。。
9	1069	[xprtiod]
10	1085	/usr/sbin/sssd
11	1086	/sbin/rngd
12	1087	/usr/libexec/rtkit-daemon
13	1088	/usr/lib/systemd/systemd-machined
。。。
31	1196	/usr/lib/polkit-1/polkitd
32	1197	/usr/libexec/sssd/sssd_nss
。。。
39	1540	/usr/sbin/gdm
40	1990	/usr/sbin/libvirtd

```



#### 正则统计

```shell
ps aux | awk '$2>1000 && $2<2000 {count=count+1} /^ozcomcn/{printf("%s\t%d\t%d\t%s\n",$1,count,$2,$11)} END {print count}'

结果：
ozcomcn	40	2733	/usr/lib/systemd/systemd
ozcomcn	40	2740	(sd-pam)
ozcomcn	40	2749	/usr/bin/pulseaudio
ozcomcn	40	2755	/usr/bin/gnome-keyring-daemon
ozcomcn	40	2766	/usr/bin/dbus-broker-launch
ozcomcn	40	2767	dbus-broker
ozcomcn	40	2774	/usr/libexec/gdm-x-session
ozcomcn	40	2826	/usr/libexec/gnome-session-binary
ozcomcn	40	2852	/usr/libexec/imsettings-daemon
ozcomcn	40	2855	/usr/libexec/gvfsd
ozcomcn	40	2860	/usr/libexec/gvfsd-fuse
ozcomcn	40	3014	/usr/bin/ssh-agent
ozcomcn	40	3054	/usr/libexec/at-spi-bus-launcher
。。。
ozcomcn	40	3193	/usr/libexec/gsd-a11y-settings
ozcomcn	40	3198	/usr/libexec/gsd-sound
ozcomcn	40	3206	/usr/libexec/gsd-media-keys
ozcomcn	40	3208	/usr/libexec/gsd-print-notifications
ozcomcn	40	3210	/usr/libexec/gsd-clipboard
。。。
ozcomcn	40	3231	/usr/libexec/gsd-screensaver-proxy
ozcomcn	40	3241	/usr/libexec/gsd-datetime
ozcomcn	40	3246	/usr/libexec/gsd-sharing
ozcomcn	40	3251	/usr/libexec/gsd-housekeeping
ozcomcn	40	3298	/usr/bin/gnome-software
ozcomcn	40	3312	/usr/libexec/tracker-miner-fs
。。。
ozcomcn	40	4261	/usr/libexec/gvfsd-dnssd
ozcomcn	40	4416	/bin/sh
ozcomcn	40	4476	/run/media/ozcomcn/^_^/JetBrains/Toolbox/apps/CLion/ch-0/192.6817.32/jbr/bin/java
ozcomcn	40	4544	/run/media/ozcomcn/^_^/JetBrains/Toolbox/apps/CLion/ch-0/192.6817.32/bin/fsnotifier64
ozcomcn	40	4650	/run/media/ozcomcn/^_^/JetBrains/Toolbox/apps/CLion/ch-0/192.6817.32/bin/clang/linux/clangd
ozcomcn	40	5080	/usr/libexec/gvfsd-http
ozcomcn	40	5085	/opt/google/chrome/chrome
ozcomcn	40	5097	cat
ozcomcn	40	5098	cat
ozcomcn	40	5101	/opt/google/chrome/chrome
。。。
ozcomcn	40	5367	/opt/google/chrome/chrome
ozcomcn	40	5410	persepolis
ozcomcn	40	5432	aria2c
ozcomcn	40	7328	/usr/libexec/gvfsd-metadata
ozcomcn	40	10823	/opt/google/chrome/chrome
ozcomcn	40	11803	/opt/google/chrome/chrome
。。。
ozcomcn	40	16505	/opt/typora/Typora
ozcomcn	40	16513	/opt/typora/Typora
ozcomcn	40	17148	/opt/google/chrome/chrome
ozcomcn	40	18079	/usr/bin/nautilus
。。。
ozcomcn	40	28368	bash
ozcomcn	40	28413	adb
ozcomcn	40	29134	bash
ozcomcn	40	30080	ps
ozcomcn	40	30081	awk
40

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

#### 非（!）

```shell
touch out
[ ! -f out ]
echo "$?" //1
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

### while

```shell
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

```

#### break[ ] 和 continue

continue与c语言一致，break[n]可以指定跳出循环的层数



## 位置参数和特殊变量

```shell
$0	//相当于c语言main函数的argv[0]
$1 $2 $3 ...	//均为位置参数
$# //相当于c语言main函数的argc-1
$@ 	//表示参数列表"$1" "$2"... ，可用于for循环
$*	//表示参数列表，同上
$?	//上一条命令的结果Exit Status
$$	//当前进程号pid
shift //位置参数左移，如shift 3表示将$4变为$1，shift默认为shift 1
```

```shell
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

```

## 函数（fun）

没有参数列表，但可用$1,$2,$3...传值，没有返回类型，可以用return返回Exit Status（0或1）

### 判断输入是否为dir

```shell
#! /bin/bash

echo "Please input dir name"

is_dir()
{

  if [ -d $1 ];
  then
	return 0;
  else

	return 1;
  fi

}


read dir

if is_dir "$dir";
then
	echo "the $dir is dir";
else
	echo "the $dir not is dir";
fi

exit 0

```

### 循环创建文件夹

```shell
#! /bin/bash

echo "Please input dir name"

is_dir()
{

  if [ -d $1 ];
  then
	return 0;
  else

	return 1;
  fi

}


read dir

if is_dir "$dir";
then
	echo "the $dir is dir";
else
	echo "the $dir not is dir";
fi

exit 0
[ozcomcn@localhost shells]$ cat fun.sh 
#! /bin/bash

is_dir()
{
	DIR_NAME=$1
	if [ ! -d "$DIR_NAME" ];
	then
		
		return 1;
	else

		return 0;
	fi
}


create_dir()
{
	DIR_NAME=$1
	
	mkdir $DIR_NAME > /dev/null 2>&1

	if [ "$?" = 0 ];
	then
	    echo "$DIR_NAME created a dir ";
	else
	    echo "Cannot create dir $DIR_NAME";
	fi		
}


for DIR in "$@";
do
   if is_dir "$DIR"
   then

	   echo "$DIR dir exist";

    else
	
	  create_dir "$DIR"
   fi

done


exit 0

```



## 调试

### sh（-n -v -x）

```shell
#1
./if.sh -n //读取脚本检查脚本语法错误，但不执行
./if.sh -v //一边执行，一边将脚本错误打印到标准错误
./if.sh -x //提供跟踪信息，将每一条命令和结果依次打印

#2
#！/bin/bash -x|-v|-n
```

### set（-x +x）

```shell
#! /bin/bash -x //全局跟踪

set -x	// debug start 局部跟踪
echo "$@"
echo "$$"
set +x	//debug end
exit 0
```

