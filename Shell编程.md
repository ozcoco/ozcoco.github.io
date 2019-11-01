# Shell编程

------

## 常用命令

> 日 志 文 件 说 明
>

- /var/log/message 系统启动后的信息和错误日志，是Red Hat Linux中最常用的日志之一

- /var/log/secure 与安全相关的日志信息

- /var/log/maillog 与邮件相关的日志信息

- /var/log/cron 与定时任务相关的日志信息

- /var/log/spooler 与UUCP和news设备相关的日志信息

- /var/log/boot.log 守护进程启动和停止相关的日志消息

> 系统
>

- uname -a # 查看内核/操作系统/CPU信息

- cat /etc/issue

- cat /etc/redhat-release # 查看操作系统版本  Enterprise Linux Enterprise Linux Server release 5.1 (Carthage)企业Linux服务器版本迦太基

- cat /proc/cpuinfo # 查看CPU信息

- hostname # 查看计算机名

- lspci -tv # 列出所有PCI设备

- lsusb -tv # 列出所有USB设备

- lsmod # 列出加载的内核模块

- env # 查看环境变量


> 资源
>

- free -m # 查看内存使用量和交换区使用量

- df -h # 查看各分区使用情况

- du -sh <目录名> # 查看指定目录的大小

- grep MemTotal /proc/meminfo # 查看内存总量

- grep MemFree /proc/meminfo # 查看空闲内存量

- uptime # 查看系统运行时间、用户数、负载

- cat /proc/loadavg # 查看系统负载


> 磁盘和分区
>

-  mount | column -t # 查看挂接的分区状态

-  fdisk -l # 查看所有分区

-  swapon -s # 查看所有交换分区

-  hdparm -i /dev/hda # 查看磁盘参数(仅适用于IDE设备)

-  dmesg | grep IDE # 查看启动时IDE设备检测状况


> 网络
>

-  ifconfig # 查看所有网络接口的属性

-  iptables -L # 查看防火墙设置

-  route -n # 查看路由表

- netstat -lntp # 查看所有监听端口

-  netstat -antp # 查看所有已经建立的连接

-  netstat -s # 查看网络统计信息


> 进程
>

-  ps -ef # 查看所有进程

- top # 实时显示进程状态


> 用户
>

-  w # 查看活动用户

-  id <用户名> # 查看指定用户信息

-  last # 查看用户登录日志

-  cut -d: -f1 /etc/passwd # 查看系统所有用户

-  cut -d: -f1 /etc/group # 查看系统所有组

-  crontab -l # 查看当前用户的计划任务


> 服务
>

-  chkconfig –list # 列出所有系统服务

-  chkconfig –list | grep on # 列出所有启动的系统服务


> 程序
>

-  rpm -qa # 查看所有安装的软件包





### 用户管理

#### groupadd

Options:
  -f, --force                   exit successfully if the group already exists,
                                and cancel -g if the GID is already used
  -g, --gid GID                 use GID for the new group
  -h, --help                    display this help message and exit
  -K, --key KEY=VALUE           override /etc/login.defs defaults
  -o, --non-unique              allow to create groups with duplicate
                                (non-unique) GID
  -p, --password PASSWORD       use this encrypted password for the new group
  -r, --system                  create a system account
  -R, --root CHROOT_DIR         directory to chroot into
  -P, --prefix PREFIX_DIR       directory prefix

##### 查看系统所有用户组

```shell
cat /etc/group | awk 'BEGIN{FS=":"} {print $1} {count=count+1} END{printf "count:%d\n",count}'
```

##### 添加新用户组

```shell
groupadd test	//add test group
groupdel test	//del test group
```



#### useradd

Options:
  -b, --base-dir BASE_DIR       base directory for the home directory of the
                                new account
  -c, --comment COMMENT         GECOS field of the new account
  -d, --home-dir HOME_DIR       home directory of the new account
  -D, --defaults                print or change default useradd configuration
  -e, --expiredate EXPIRE_DATE  expiration date of the new account
  -f, --inactive INACTIVE       password inactivity period of the new account
  -g, --gid GROUP               name or ID of the primary group of the new
                                account
  -G, --groups GROUPS           list of supplementary groups of the new
                                account
  -h, --help                    display this help message and exit
  -k, --skel SKEL_DIR           use this alternative skeleton directory
  -K, --key KEY=VALUE           override /etc/login.defs defaults
  -l, --no-log-init             do not add the user to the lastlog and
                                faillog databases
  -m, --create-home             create the user's home directory
  -M, --no-create-home          do not create the user's home directory
  -N, --no-user-group           do not create a group with the same name as
                                the user
  -o, --non-unique              allow to create users with duplicate
                                (non-unique) UID
  -p, --password PASSWORD       encrypted password of the new account
  -r, --system                  create a system account
  -R, --root CHROOT_DIR         directory to chroot into
  -P, --prefix PREFIX_DIR       prefix directory where are located the /etc/* files
  -s, --shell SHELL             login shell of the new account
  -u, --uid UID                 user ID of the new account
  -U, --user-group              create a group with the same name as the user
  -Z, --selinux-user SEUSER     use a specific SEUSER for the SELinux user mapping

##### 查看系统用户

```shell
cat /etc/passwd | awk 'BEGIN{FS=":"} {print $1} {count=count+1} END{printf("count:%d\n",count)}'
```

##### 创建新用户

```shell
groupadd test2
useradd -m -g test2 test2
```

##### 修改用户

```shell
usermod -a -G root test2
[root@localhost home]# id test2
uid=1001(test2) gid=1001(test2) groups=1001(test2),0(root)
```

##### 删除用户

```shell
userdel test2
```



### 权限管理

```shell
touch file2
chmod u+x file2	//为文件所有者增加可执行权限
chmod g+w file2 //为文件所属组增加可写权限
chmod o+w file2	//为文件其他用户增加可写权限
```

### 磁盘管理

```

```



### ab（http服务器压力测试）

```shell
ab -c 1 -n 10000 https://www.baidu.com/index.html
```

### dstat（系统资源监控）

```shell
#输出监控信息并把监控信息导出为cvs文件
[root@org-oz learn]# dstat --output dstat.cvs
You did not select any stats, using -cdngy by default.
----total-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw 
  0   0 100   0   0|   0     0 |  66   673 |   0     0 | 114   209 
  0   0  99   0   0|   0     0 | 284   514 |   0     0 | 111   200 
  0   1 100   0   0|   0     0 | 242   514 |   0     0 | 146   203 
  0   0 100   0   0|   0     0 |  66   354 |   0     0 | 125   197 
  0   0 100   0   0|   0     0 |  66   338 |   0     0 | 124   197 
  0   0 100   0   0|   0    12k|  66   338 |   0     0 | 125   226 
  0   0 100   0   0|   0     0 | 108   424 |   0     0 | 130   198 
  0   0  99   0   0|   0     0 |  66   338 |   0     0 | 134   211 
  0   0 100   0   0|   0     0 | 168   432 |   0     0 | 125   202 
  0   0 100   0   0|   0     0 |  66   338 |   0     0 | 125   186 
  0   0 100   0   0|   0     0 |  66   338 |   0     0 | 132   197 
  1   0  99   0   0|   0    12k|3652   338 |   0     0 | 199   250 
  0   0  99   0   0|   0    64k|  66   354 |   0     0 | 203   244 

```

### tcpdump（网络抓包）

```shell
tcpdump -c 10 -w tcpdump.log	//抓去10个包导出到tcpdump.log文件
tcpdump -r tcpdump.log	//读取tcpdump.log文件
```

#### -v -vv（输出详细信息）

```shell
[root@org-oz learn]# tcpdump -c 3 -v
tcpdump: listening on wlp8s0, link-type EN10MB (Ethernet), capture size 262144 bytes
18:46:22.291025 IP (tos 0x48, ttl 64, id 41450, offset 0, flags [DF], proto TCP (6), length 184)
    org-oz.ssh > 192.168.0.106.46970: Flags [P.], cksum 0x36c2 (correct), seq 1138752128:1138752260, ack 4287140438, win 501, options [nop,nop,TS val 3373607179 ecr 1320782790], length 132
18:46:22.291535 IP (tos 0x0, ttl 64, id 47843, offset 0, flags [DF], proto UDP (17), length 72)
    org-oz.51063 > 192.168.1.1.domain: 30970+ PTR? 106.0.168.192.in-addr.arpa. (44)
18:46:22.298384 IP (tos 0x48, ttl 64, id 41451, offset 0, flags [DF], proto TCP (6), length 184)
    org-oz.ssh > 192.168.0.106.46970: Flags [P.], cksum 0x6a45 (correct), seq 132:264, ack 1, win 501, options [nop,nop,TS val 3373607186 ecr 1320782790], length 132
3 packets captured
13 packets received by filter
0 packets dropped by kernel

[root@org-oz learn]# tcpdump -c 3 -vv
tcpdump: listening on wlp8s0, link-type EN10MB (Ethernet), capture size 262144 bytes
18:46:26.130471 IP (tos 0x0, ttl 4, id 59600, offset 0, flags [none], proto UDP (17), length 288)
    _gateway.ssdp > 239.255.255.250.ssdp: [udp sum ok] UDP, length 260
18:46:26.133529 IP (tos 0x0, ttl 4, id 59602, offset 0, flags [none], proto UDP (17), length 297)
    _gateway.ssdp > 239.255.255.250.ssdp: [udp sum ok] UDP, length 269
18:46:26.137237 IP (tos 0x0, ttl 4, id 59604, offset 0, flags [none], proto UDP (17), length 360)
    _gateway.ssdp > 239.255.255.250.ssdp: [udp sum ok] UDP, length 332
3 packets captured
19 packets received by filter
0 packets dropped by kernel

```

#### -i（指定网卡）

```shell
//查看网卡
[root@org-oz learn]# tcpdump -D
1.wlp8s0 [Up, Running]
2.lo [Up, Running, Loopback]
3.any (Pseudo-device that captures on all interfaces) [Up, Running]
4.enp9s0 [Up]
5.virbr0 [Up]
6.docker0 [Up]
7.bluetooth-monitor (Bluetooth Linux Monitor) [none]
8.nflog (Linux netfilter log (NFLOG) interface) [none]
9.nfqueue (Linux netfilter queue (NFQUEUE) interface) [none]
10.usbmon0 (All USB buses) [none]
11.usbmon1 (USB bus number 1)
12.usbmon2 (USB bus number 2)
13.usbmon3 (USB bus number 3)
14.usbmon4 (USB bus number 4)
15.virbr0-nic [none]

//指定网卡
[root@org-oz learn]# tcpdump -i wlp8s0 -c 5
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp8s0, link-type EN10MB (Ethernet), capture size 262144 bytes
18:40:27.122188 IP org-oz.ssh > 192.168.0.106.46970: Flags [P.], seq 1138431304:1138431500, ack 4287138586, win 501, options [nop,nop,TS val 3373252010 ecr 1320427623], length 196
18:40:27.122595 IP org-oz.36457 > 192.168.1.1.domain: 31910+ PTR? 106.0.168.192.in-addr.arpa. (44)
18:40:27.131022 IP 192.168.0.106.46970 > org-oz.ssh: Flags [.], ack 196, win 8665, options [nop,nop,TS val 1320427674 ecr 3373252010], length 0
18:40:27.133620 IP 192.168.1.1.domain > org-oz.36457: 31910 NXDomain* 0/0/0 (44)
18:40:27.134733 IP org-oz.57080 > 192.168.1.1.domain: 30809+ PTR? 108.0.168.192.in-addr.arpa. (44)
5 packets captured
10 packets received by filter
0 packets dropped by kernel
```

#### -n（不反解IP）

```shell
[root@org-oz learn]# tcpdump -n  -c 3
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp8s0, link-type EN10MB (Ethernet), capture size 262144 bytes
18:51:57.968506 IP 192.168.0.108.ssh > 192.168.0.106.46970: Flags [P.], seq 1140301172:1140301368, ack 4287147174, win 501, options [nop,nop,TS val 3373942856 ecr 1321118466], length 196
18:51:57.968658 IP 192.168.0.108.ssh > 192.168.0.106.46970: Flags [P.], seq 196:424, ack 1, win 501, options [nop,nop,TS val 3373942856 ecr 1321118466], length 228
18:51:57.970206 IP 192.168.0.108.ssh > 192.168.0.106.46970: Flags [P.], seq 424:636, ack 1, win 501, options [nop,nop,TS val 3373942858 ecr 1321118466], length 212
3 packets captured
5 packets received by filter
0 packets dropped by kernel

```

#### 指定条件

##### and

```shell
[root@org-oz learn]# tcpdump tcp and src 192.168.0.106 and port 22 and tcp and dst 192.168.0.108 and port 22 -c 3
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp8s0, link-type EN10MB (Ethernet), capture size 262144 bytes
19:13:55.477584 IP 192.168.0.106.46970 > org-oz.ssh: Flags [.], ack 1191319008, win 8665, options [nop,nop,TS val 1322436024 ecr 3375260360], length 0
19:13:55.504468 IP 192.168.0.106.46970 > org-oz.ssh: Flags [.], ack 197, win 8665, options [nop,nop,TS val 1322436051 ecr 3375260382], length 0
19:13:55.513865 IP 192.168.0.106.46970 > org-oz.ssh: Flags [.], ack 377, win 8665, options [nop,nop,TS val 1322436059 ecr 3375260393], length 0

```

or

```shell
[root@org-oz learn]# tcpdump tcp and src 192.168.0.106 and port 22 or tcp and src 192.168.0.108 and port 22 -c 3
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp8s0, link-type EN10MB (Ethernet), capture size 262144 bytes
19:16:40.332390 IP org-oz.ssh > 192.168.0.106.46970: Flags [P.], seq 1191323988:1191324184, ack 4287216830, win 719, options [nop,nop,TS val 3375425220 ecr 1322600849], length 196
19:16:40.344478 IP org-oz.ssh > 192.168.0.106.46970: Flags [P.], seq 196:424, ack 1, win 719, options [nop,nop,TS val 3375425232 ecr 1322600889], length 228
19:16:40.344789 IP org-oz.ssh > 192.168.0.106.46970: Flags [P.], seq 424:620, ack 1, win 719, options [nop,nop,TS val 3375425232 ecr 1322600889], length 196

```

not

```shell
[root@org-oz learn]# tcpdump not port 22 or icmp or udp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp8s0, link-type EN10MB (Ethernet), capture size 262144 bytes
19:18:34.711068 ARP, Request who-has org-oz tell _gateway, length 28
19:18:34.711114 ARP, Reply org-oz is-at 44:6d:57:3d:8c:c9 (oui Unknown), length 28
19:18:34.712406 IP org-oz.54910 > 192.168.1.1.domain: 55949+ PTR? 108.0.168.192.in-addr.arpa. (44)
19:18:34.716653 IP 192.168.1.1.domain > org-oz.54910: 55949 NXDomain* 0/0/0 (44)
19:18:34.717693 IP org-oz.33919 > 192.168.1.1.domain: 41751+ PTR? 1.0.168.192.in-addr.arpa. (42)
19:18:34.738012 IP 192.168.1.1.domain > org-oz.33919: 41751 NXDomain* 0/0/0 (42)
19:18:34.738995 IP org-oz.36638 > 192.168.1.1.domain: 13572+ PTR? 1.1.168.192.in-addr.arpa. (42)
19:18:34.753458 IP 192.168.1.1.domain > org-oz.36638: 13572 NXDomain* 0/0/0 (42)
19:18:39.967965 ARP, Request who-has _gateway tell org-oz, length 28
19:18:39.983560 ARP, Reply _gateway is-at bc:54:fc:ca:95:32 (oui Unknown), length 28
```



### rsync （文件夹同步）

```shell
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

#### -n（打印指定行）

```shell
[root@org-oz docker_net]# docker network ls | sed -n '2p'	//打印第2行
a24ce0ad29e4        bridge              bridge              local
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

##### NR（打印某一行）

```shell
docker network ls | awk 'NR==2{print $1}'	//打印第2行
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

#### 引入外部参数

##### -v

```shell
hello=1234567890
awk -v hello=$hello 'BEGIN{print hello}'
```

##### ""

```shell
echo "132342" | awk "{print \"$hello\"}"
```

#### sort

```shell
[root@org-oz demo2]# printf "11\n11\n11\n33\n55\n44\n99\n66" | sort
11
11
11
33
44
55
66
99
```

##### -u（去重）

```shell
[root@org-oz demo2]# printf "11\n11\n11\n33\n55\n44\n99\n66" | sort -u
11
33
44
55
66
99
```



### 任务后台运行

```shell
ping 192.168.0.1 &   //后台运行，任务所在终端退出，任务结束

nohup ping 192.168.0.108 &	//后台运行，nohup: ignoring input and appending output to 'nohup.out'，任务所在终端退出，任务继续运行
```

#### jobs（查看当前终端后台任务）

Options:
      -l	lists process IDs in addition to the normal information
      -n	lists only processes that have changed status since the last
    		notification
      -p	lists process IDs only
      -r	restrict output to running jobs
      -s	restrict output to stopped jobs

```shell
jobs -l
```

#### fg

```shell
fg 1	//把后台任务放在前台运行
```

#### bg

把已经暂停的任务放在后台运行

```shell
ping 192.168.0.1
ctrl+z	//暂停任务
bg	//把暂停状态的任务放在后台运行
```

#### seq

打印数字序列

> Usage: seq [OPTION]... LAST
>   or:  seq [OPTION]... FIRST LAST
>   or:  seq [OPTION]... FIRST INCREMENT LAST
> Print numbers from FIRST to LAST, in steps of INCREMENT.
>
> Mandatory arguments to long options are mandatory for short options too.
>   -f, --format=FORMAT      use printf style floating-point FORMAT
>   -s, --separator=STRING   use STRING to separate numbers (default: \n)
>   -w, --equal-width        equalize width by padding with leading zeroes
>       --help     display this help and exit
>       --version  output version information and exit

```shell
[ozcomcn@localhost ~]$ seq  1 10
1
2
3
4
5
6
7
8
9
10

[ozcomcn@localhost ~]$ seq 1 2 10
1
3
5
7
9

[ozcomcn@localhost ~]$ seq 10 -1 1
10
9
8
7
6
5
4
3
2
1

[ozcomcn@localhost ~]$ seq 10 -2 1
10
8
6
4
2

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

