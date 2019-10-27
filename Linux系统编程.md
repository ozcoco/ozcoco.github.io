

# Linux系统编程

## CPU和MMU

------

我们知道，程序文件一般放在硬盘上，当把程序运行起来产生进程是，程序被放入内存中，通过内存放入cache，通过cache进入cpu，进入cpu的是程序的一条条指令，即01组合，下图中预取器就是负责从cache取出指令，然后由译码器译码，译码的作用就是要知道需要哪些寄存器配合完成指令，如该指令是一个加法运算，则译码器译码后发现需要使用到add，eax和ebx寄存器，然后交给ALU算数逻辑单元进行算数运算，结果放回寄存器，再放入cache，再放入内存，之后交给IO总线，再交给物理设备显示到屏幕上。

![å¨è¿éæå¥å¾çæè¿°](https://img-blog.csdnimg.cn/2019050421360261.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0lUXzEw,size_16,color_FFFFFF,t_70)

下图是一个0到4G的虚拟地址空间，.text存放代码，.data存放数据，heap是堆区，stack是栈区，这0到3G是用户区，3到4G是内核区，当程序运行的时候便会产生这样一个虚拟地址空间，程序运行时所需的所有资源都放到虚拟内存中。虚拟内存不是真实存在的，图中所示的4G大小的虚拟内存是指程序运行可用的地址空间有4G，程序运行的资源最终还是要放到物理内存中。那虚拟地址和物理地址如何对应？就是使用MMU。MMU：内存管理单元，用于完成虚拟内存和物理内存的映射，位于CPU内部；MMU将虚拟内存映射到物理内存，以及设置修改CPU的访问级别，如printf函数，要调用系统函数write，要进入内核空间，此时CPU的访问级别由3级用户空间转换到0级内核空间。

![å¨è¿éæå¥å¾çæè¿°](https://img-blog.csdnimg.cn/20190504213712649.png)

下图所示为在同一个机器上运行两份可执行程序a.out，产生两个虚拟地址空间，其中，两个进程的用户态虚拟地址被MMU映射到物理内存的不同地址，但是内核态映射到同一个地址（针对单核来讲），而PCB虽然位于内核中，两个进程的PCB是不一样的，只是位于同一个物理地址处。

![å¨è¿éæå¥å¾çæè¿°](https://img-blog.csdnimg.cn/20190504215839251.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0lUXzEw,size_16,color_FFFFFF,t_70)

综上，程序运行的时候产生虚拟地址空间，预取器取处指令后需要MMU的配合，将虚拟地址和物理地址做映射才能正确取出数据。
现在，进一步分析，如下图所示，进程a.out的PCB中有一个指针，指向页目录，页目录中有一个个的指针，其中一个指向页表，页表中也有一个个的指针，其中一个指向物理页面，物理页面中是一个个的内存单元，然后才通过MMU完成虚拟地址和物理地址的映射。

![å¨è¿éæå¥å¾çæè¿°](https://img-blog.csdnimg.cn/20190513205405985.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0lUXzEw,size_16,color_FFFFFF,t_70)

————————————————
版权声明：本文为CSDN博主「IT_10-」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/IT_10/article/details/89818738



## 进程

------

### 创建子进程

```c++
#include <cstdio>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <wait.h>

void create_task()
{
    int ret;

    ret = fork();

    if (ret < 0)
    {
        perror("Cant't create child task.\n");

    } else if (ret > 0)
    {
        int chpid = ret;

        int ppid = getpid();

        printf("Parent pid = %d \n", ppid);

    } else if (ret == 0)
    {

        printf("Child pid = %d \n", getpid());

    }

}
```

### 循环创建N个子进程

```c++
#include <cstdio>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <wait.h>

void create_task()
{
    int ret;

    ret = fork();

    if (ret < 0)
    {
        perror("Cant't create child task.\n");

    } else if (ret > 0)
    {
        int chpid = ret;

        int ppid = getpid();

        printf("Parent pid = %d \n", ppid);

    } else if (ret == 0)
    {

        printf("Child pid = %d \n", getpid());

    }

}
```

### 回收子进程

```c++
#include <cstdio>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <wait.h>

void recycle_child_task()
{

    const int N = 5;

    int childPidSet[N];

    int i = 0;

    for (; i < N; i++)
    {
        int ret = fork();

        if (ret == 0)
            break;

        childPidSet[i] = ret;
    }


    if (i == N)
        for (const int &pid : childPidSet)
            printf("Child pid=%d\n", pid);


    if (i == N)
        for (const int &pid: childPidSet)
        {
            int stat;

            waitpid(pid, &stat, 0);

            printf("Recycle child pid %d\n", pid);

        }


}

```



### 守护进程

```c++
#include <cstdio>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <wait.h>

void create_daemon_task()
{
    pid_t pid, sid;

    pid = fork();

    if (pid > 0)
        exit(0);

    setsid();

    if (chdir("/tmp"))
    {
        perror("Change dir error");

        exit(1);
    }

    umask(0002);

    close(STDIN_FILENO);

    open("/dev/null", O_RDWR);

    dup2(0, STDOUT_FILENO);

    dup2(0, STDERR_FILENO);

    int count = 0;

    while (1)
    {
        count++;

        write(STDOUT_FILENO, &count, sizeof(count));

        sleep(1);

    }

}
```



## 进程间通信

------

### 管道（PIPE）

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

static const int MSG_SIZE = 50;

void pipe_no_name()
{

    int ret;

    printf("present pid = %d \n", getpid());

    int pipesFD[2];

    ret = pipe(pipesFD);

    if (ret < 0)
    {
        printf("create pipe failure \n");

        return;
    }

    ret = fork();

    if (ret < 0)
    {
        printf("create process failure \n");

    } else if (ret > 0)
    {

        printf("present pid = %d \n", getpid());

        char msg[MSG_SIZE];

        std::fill(msg, msg + MSG_SIZE, 0);

        for (int i = 0;; i++)
        {
            sprintf(msg, "msg number=%d", i);

            write(pipesFD[1], msg, MSG_SIZE);

            std::fill(msg, msg + MSG_SIZE, 0);

            sleep(1);
        }

    } else
    {

        printf("child pid = %d \n", getpid());

        char msg[MSG_SIZE];

        for (;;)
        {
            read(pipesFD[0], msg, MSG_SIZE);

            printf("accept msg: %s \n", msg);

            std::fill(msg, msg + MSG_SIZE, 0);

            sleep(1);
        }


    }


    close(pipesFD[0]);
    close(pipesFD[1]);

}

```



### 有名管道（FIFO）

进程1

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

static const char FIFO_NAME[] = "/tmp/fifo666";
static const int MSG_SIZE = 50;

void fifo_name()
{

    int ret;

    remove(FIFO_NAME);

    ret = mkfifo(FIFO_NAME, 0666);

    if (ret < 0 && errno != EEXIST)
    {

        printf("create fifo failure\n");

        return;
    }

    ret = open(FIFO_NAME, O_WRONLY);

    if (ret < 0)
    {

        printf("open file failure\n");

        return;
    }

    int fifoRFD = ret;

    char msg[MSG_SIZE];

    for (int i = 0;; i++)
    {
        sprintf(msg, "msg number=%d", i);

        printf("send msg: %d", i);

        write(fifoRFD, msg, MSG_SIZE);

        sleep(1);
    }

    close(fifoRFD);


}
```

进程2

```c++
#include <iostream>
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>

static const char FIFO_NAME[] = "/tmp/fifo666";
static const int MSG_SIZE = 50;

void fifo_name()
{

    int ret;

    ret = open(FIFO_NAME, O_RDONLY);

    if (ret < 0)
    {
        printf("open file failure\n");

        return;
    }

    int fifoRFD = ret;

    char msg[MSG_SIZE];


    for (int i = 0;; i++)
    {
        read(fifoRFD, msg, MSG_SIZE);

        printf("accept msg: %s \n", msg);

        sleep(1);
    }

    close(fifoRFD);

}


int main()
{
    fifo_name();

    return 0;
}
```

### 高级管道（popen）

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>

void pipe_popen()
{

    char cmd[] = "ls";

    FILE *p = popen(cmd, "r");

    char buf[256];

    while (fgets(buf, 256, p))
    {

        printf("%s", buf);

    }

    pclose(p);

}
```



### 获取环境变量

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>


extern char **environ;


inline static std::string print_environ2() noexcept
{

    std::string ret{};

    for (int i = 0; environ[i]; i++)
    {

        ret.append(environ[i]);

        ret.append("\n");
    }

    return ret;

}

void print_environ()
{

    printf("%s \n", print_environ2().c_str());

}
```



### 文件操作

#### 创建文件

```c++

#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

constexpr const char new_filename[] = "/tmp/x1";

void create_file()
{

/*    int ret;

    ret = access(new_filename, F_OK | R_OK | W_OK);

    if (ret < 0)
    {
        perror("Can't permission access");
    }*/

    int fd = open(new_filename, O_RDWR | O_CREAT | O_TRUNC | O_NDELAY, 0766);

    if (fd)
    {
        char str[] = "1234567890";

        write(fd, str, sizeof(str));

    }

    close(fd);

}
```



#### 获取文件大小

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>


void get_file_size()
{

    int fd = open(new_filename, O_RDONLY | O_NDELAY, 0766);

    if (fd)
    {
        const long int &size = lseek(fd, 0, SEEK_END);

        char str[size];

        lseek(fd, 0, SEEK_SET);

        read(fd, str, size);

        printf("%s \n file size: %ld \n", str, size);
    }

    close(fd);

}
```



#### 设置文件size

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

void set_file_size_by_seek()
{
    int fd = open(new_filename, O_RDWR | O_CREAT | O_TRUNC | O_NDELAY, 0766);

    if (fd)
    {
        char str[] = "1234567890";

        write(fd, str, sizeof(str));

        printf("str size:%ld", sizeof(str));

        lseek(fd, 99, SEEK_SET);

        write(fd, "\0", 1);
    }

    close(fd);

}
```



```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

void set_file_size_by_truncate()
{

    int fd = open(new_filename, O_RDWR | O_CREAT | O_TRUNC | O_NDELAY, 0766);

    if (fd)
    {
        char str[] = "1234567890";

        write(fd, str, sizeof(str));

        printf("str size:%ld", sizeof(str));

        ftruncate(fd, 1024);

    }

    close(fd);

}
```



#### 获取文件的stat

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

void print_file_stat_struct()
{
    using FileStat = struct stat;

    size_t size = sizeof(FileStat);

    printf("size = %ld \n", size);

    FileStat fileStat{};

    lstat(new_filename, &fileStat);

    char _data[size];

    memcpy(_data, &fileStat, size);

    std::string data{_data, size};

    std::cout << data << std::endl;

    std::cout << fileStat.st_size << std::endl;
    std::cout << fileStat.st_gid << std::endl;
    std::cout << fileStat.st_uid << std::endl;
    std::cout << fileStat.st_ctim.tv_nsec << std::endl;
    std::cout << fileStat.st_ctim.tv_sec << std::endl;
    std::cout << fileStat.st_atim.tv_nsec << std::endl;
    std::cout << fileStat.st_atim.tv_sec << std::endl;
    std::cout << fileStat.st_blksize << std::endl;
    std::cout << fileStat.st_blocks << std::endl;
    std::cout << fileStat.st_dev << std::endl;
    std::cout << fileStat.st_mode << std::endl;
    std::cout << fileStat.st_nlink << std::endl;
    std::cout << fileStat.st_rdev << std::endl;

}
```



#### 检测文件对当前用户操作的权限（access）

```c++
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

void file_unlink_access()
{

    int ret;

    ret = access(new_filename, F_OK | R_OK | W_OK);

    if (ret < 0)
    {
        perror("Can't permission access\n");
    }

    int fd = open(new_filename, O_RDONLY);

    unlink(new_filename); //grant delete power of 目录项

    if (fd)
    {
        const long int &size = lseek(fd, 0, SEEK_END);

        char str[size];

        lseek(fd, 0, SEEK_SET);

        read(fd, str, size);

        printf("%s \n file size: %ld \n", str, size);

    }


    close(fd);

}
```

#### 标准输入（0），标准输出（1），标准错误（2）

```c
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>
#include <algorithm>

void stdout_dev()
{
    printf("Main precess pid: %u \t thread id = %lu\n", getpid(), pthread_self());

    char str[] = "213542363457";

    write(STDOUT_FILENO, str, sizeof(str) - 1);
    
    printf("%d\n%d\n%d\n", STDOUT_FILENO, STDIN_FILENO, STDERR_FILENO);
}
```



### 共享内存（shared memory）

server

```c++
#include <sys/ipc.h>
#include <sys/shm.h>
#include <csignal>
#include <iostream>

#define SHM_PATH "/tmp/test_shm"
#define SHM_SIZE 0x6400

inline void handle_sig(int sig)
{
    printf("handle signal, signal : %s\n", strsignal(sig));

    isLoop = false;
}


void s_shm()
{
    signal(SIGALRM, handle_sig);

    int shm_id;

    char *shmAddr;

    shm_id = shmget(ftok(SHM_PATH, 0x03), SHM_SIZE, IPC_CREAT | IPC_EXCL | 0600);

    if (shm_id == -1)
    {
        perror("shmget failure!");

        exit(errno);
    }

    shmAddr = reinterpret_cast<char *>(shmat(shm_id, NULL, 0));

    int count = 0;

    alarm(10);

    while (isLoop)
    {
        sprintf(shmAddr, "test shared memory! ---> %d", count++);
    }

    strcpy(shmAddr, "exit");

    sleep(1);

    shmdt(shmAddr);

    shmctl(shm_id, IPC_RMID, NULL);

}


```

client

```c++
#include <sys/ipc.h>
#include <sys/shm.h>
#include <iostream>

#define SHM_PATH "/tmp/test_shm"
#define SHM_SIZE 0x6400

void c_shm()
{
    int shm_id;

    char *shmAddr;

    shm_id = shmget(ftok(SHM_PATH, 0x03), SHM_SIZE, IPC_EXCL | 0600);

    if (shm_id == -1)
    {
        perror("shmget failure!");

        exit(errno);
    }

    shmAddr = reinterpret_cast<char *>(shmat(shm_id, NULL, 0));

    while (true)
    {
        if (strstr(shmAddr, "exit"))
        {
            break;
        }

        printf("%s\n", shmAddr);
    }

    shmdt(shmAddr);

    shmctl(shm_id, IPC_RMID, NULL);
}

```



### 消息队列（msg）

```c
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <sys/msg.h>

void msg_queue()
{
//    ftok();
//    msgget(123, 0666 | IPC_CREAT);
//    msgrcv()
//    msgsnd()
//    msgctl()
}
```



### 内存映射（mmap）

```c++

```



### 信号（Signal）

#### 发送信号

```c++
#include <iostream>
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <wait.h>
#include <functional>

void signal_alarm()
{
    alarm(1);

    for (int i = 0;; i++)
        printf("%d\n", i);

}
```



#### 捕获信号

##### 发送给自己（alarm、reise、abort）

```c++
#include <iostream>
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <memory.h>
#include <fcntl.h>
#include <wait.h>
#include <functional>

struct SignalHandler
{

    virtual inline void operator()(int sig) const
    {

    }

    static inline void signalHandle(int sig)
    {
        printf("capture signal \n");

        pause();

        printf(" signal handle continue \n ");

    }

};

void capture_signal()
{

//    std::function<void(int)> sh = SignalHandler();

    signal(SIGALRM, SignalHandler::signalHandle);

    alarm(2);

    while (1);

}
```

##### 发送给指定进程（kill）

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

void sig_kill_with_c()
{

    void (*handle)(int) = [](int sig) -> void
    {
        printf("signal:%s\n", strsignal(sig));

    };

    signal(SIGBUS, handle);

    kill(getpid(), SIGBUS);

}

```



### 带参信号（sigqueue）

```c
#include <signal.h>

void sigqueue_with_pure_c()
{
    struct Anim
    {
        char name[20];
        int age;
    };

    struct Anim sigVal{"oneko", 12};

    struct sigaction my_sigaction{};

    sigemptyset(&my_sigaction.sa_mask);

    my_sigaction.sa_flags = SA_SIGINFO;

    my_sigaction.sa_sigaction = [](int sig, siginfo_t *info, void *ucontext) -> void
    {
        struct Anim *revVal = (struct Anim *) info->si_ptr;

        printf("name: %s\narg: %d", revVal->name, revVal->age);

    };

    sigaction(SIGBUS, &my_sigaction, NULL);

    union sigval mysigVal{};

    mysigVal.sival_ptr = &sigVal;

    sigqueue(getpid(), SIGBUS, mysigVal);

}
```



### Socket

#### 三次握手（连接 connect / accept）

#### 四次握手（断开 close / shutdown）

#### net socket

TestSocket.h

```c++
//
// Created by ozcomcn on 10/22/19.
//

#ifndef SOCKET_S_TESTSOCKET_H
#define SOCKET_S_TESTSOCKET_H

#include <iostream>


template<typename __Type>
class ToUpper
{
public:
    inline __Type operator()(__Type &__t)
    {
        return toupper(__t);
    }
};

#endif //SOCKET_S_TESTSOCKET_H
```



server

```c++
#include <iostream>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <thread>
#include <cstring>
#include <algorithm>
#include <functional>
#include "TestSocket.h"

#define PROTOCOL 0
#define PORT 9999
#define DOMAIN AF_INET
#define TYPE SOCK_STREAM
#define S_IP "127.0.0.1"

inline void server()
{
    int listen_fd, c_fd;

    struct sockaddr_in sockAddr{}, acceptAddr{};

    socklen_t c_addr_len;

    char buf[BUFSIZ];

    memset(buf, 0, BUFSIZ);

    memset(&sockAddr, 0, sizeof(sockAddr));

    memset(&acceptAddr, 0, sizeof(acceptAddr));

    listen_fd = socket(DOMAIN, TYPE, PROTOCOL);

    if (listen_fd < 0)
    {
        perror("create socket failure !");

        exit(errno);
    }

    sockAddr.sin_family = AF_INET;

    sockAddr.sin_port = htons(PORT);

    sockAddr.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(listen_fd, (struct sockaddr *) &sockAddr, sizeof(sockAddr)) != 0)
    {
        perror("bind socket failure !");

        exit(errno);
    }

    if (listen(listen_fd, 200) != 0)
    {
        perror("listen socket failure !");

        exit(errno);
    }

    c_fd = accept(listen_fd, (struct sockaddr *) &acceptAddr, &c_addr_len);

    if (c_fd < 0)
        sockAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    {
        perror("accept socket failure !");

        exit(errno);
    }


    while (true)
    {
        size_t len = read(c_fd, buf, sizeof(buf));

        if (len == 0) continue;

        if (strstr(buf, "exit"))
        {
            break;
        }

        printf("%s\n", buf);

        std::transform(buf, buf + len, buf, ToUpper<char>());

        write(c_fd, buf, len);

        memset(buf, 0, len);
    }

    close(c_fd);

    close(listen_fd);

    printf("exit!!!");
}

```

client

```c++
#include <iostream>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <thread>
#include <cstring>
#include <sys/un.h>

#define PROTOCOL 0
#define PORT 9999
#define DOMAIN AF_INET
#define TYPE SOCK_STREAM
#define S_IP "127.0.0.1"

inline void client()
{
    int c_fd;

    struct sockaddr_in sAddr{};

    socklen_t c_addr_len;

    char buf[BUFSIZ];

    c_fd = socket(DOMAIN, TYPE, PROTOCOL);

    if (c_fd < 0)
    {
        perror("create socket failure !");

        exit(errno);
    }

    sAddr.sin_family = AF_INET;

    sAddr.sin_port = htons(PORT);

    sAddr.sin_addr.s_addr = inet_addr(S_IP);

    if (connect(c_fd, (sockaddr *) &sAddr, sizeof(sAddr)) != 0)
    {
        perror("connect socket failure !");
    }

    while (true)
    {
        scanf("%s", buf);

        printf("\n");

        int len;

        len = send(c_fd, buf, strlen(buf), 0);

        if (strstr(buf, "exit"))
        {
            break;
        }

        memset(buf, 0, len);

        len = recv(c_fd, buf, sizeof(buf), 0);

        printf("%s\n", buf);

        memset(buf, 0, len);
    }

    close(c_fd);

    printf("exit!!!");
}
```



#### local socket

server

```c++
#include <iostream>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <thread>
#include <cstring>
#include <sys/un.h>

#define LOCAL_SOCK_PATH "/tmp/test_local_sock"
#define PROTOCOL 0
#define TYPE SOCK_STREAM

void local_server()
{

    if (access(LOCAL_SOCK_PATH, F_OK) == 0)
    {
        unlink(LOCAL_SOCK_PATH);
    }

    int listen_fd, c_fd;

    struct sockaddr_un sockAddr{}, acceptAddr{};

    socklen_t c_addr_len;

    char buf[BUFSIZ];

    memset(&sockAddr, 0, sizeof(sockAddr));

    memset(&acceptAddr, 0, sizeof(acceptAddr));

    memset(buf, 0, BUFSIZ);

    listen_fd = socket(AF_UNIX, TYPE, PROTOCOL);

    if (listen_fd < 0)
    {
        perror("create socket failure !");

        exit(errno);
    }

    sockAddr.sun_family = AF_UNIX;

    strcpy(sockAddr.sun_path, LOCAL_SOCK_PATH);

    if (bind(listen_fd, (struct sockaddr *) &sockAddr, sizeof(sockAddr)) != 0)
    {
        perror("bind socket failure !");

        exit(errno);
    }

    if (listen(listen_fd, 200) != 0)
    {
        perror("listen socket failure !");

        exit(errno);
    }

    c_fd = accept(listen_fd, (struct sockaddr *) &acceptAddr, &c_addr_len);

    if (c_fd < 0)
    {
        perror("accept socket failure !");

        exit(errno);
    }


    while (true)
    {
        size_t len = read(c_fd, buf, sizeof(buf));

        if (len == 0) continue;

        if (strstr(buf, "exit"))
        {
            break;
        }

        printf("%s\n", buf);

        std::transform(buf, buf + len, buf, ToUpper<char>());

        write(c_fd, buf, len);

        memset(buf, 0, len);
    }

    close(c_fd);

    close(listen_fd);

    unlink(LOCAL_SOCK_PATH);

    printf("exit!!!");


}

```



client

```c++
#include <iostream>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <thread>
#include <cstring>
#include <sys/un.h>

#define LOCAL_SOCK_PATH "/tmp/test_local_sock"
#define PROTOCOL 0
#define TYPE SOCK_STREAM

void local_client()
{
    int c_fd;
    
    struct sockaddr_un sAddr{};

    socklen_t c_addr_len;

    char buf[BUFSIZ];

    c_fd = socket(AF_UNIX, TYPE, PROTOCOL);

    if (c_fd < 0)
    {
        perror("create socket failure !");

        exit(errno);
    }

    sAddr.sun_family = AF_UNIX;

    strcpy(sAddr.sun_path, LOCAL_SOCK_PATH);

    if (connect(c_fd, (sockaddr *) &sAddr, sizeof(sAddr)) != 0)
    {
        perror("connect socket failure !");
    }

    while (true)
    {
        scanf("%s", buf);

        printf("\n");

        int len;

        len = send(c_fd, buf, strlen(buf), 0);

        if (strstr(buf, "exit"))
        {
            break;
        }

        memset(buf, 0, len);

        len = recv(c_fd, buf, sizeof(buf), 0);

        printf("%s\n", buf);

        memset(buf, 0, len);
    }

    close(c_fd);

    printf("exit!!!");

}

```



#### c++大小写转换的9种实现方式

```c++
#include <iostream>
#include <cstring>

void test_toUpper()
{
    char content[] = "qqrrtetwertw";

    size_t len = strlen(content);

/*1*/
//    std::transform(content, content + len, content, toupper);

/*2*/
//    std::function<int(int)> toUp = toupper;
//
//    std::transform(content, content + len, content, toUp);

/*3*/
    //    std::transform(content, content + len, content, (int (*)(int)) toupper);
/*4*/
//    std::transform(content, content + len, content, ::toupper);

/*5*/
//    std::transform(content, content + strlen(content), content, [](auto &ch) -> int
//    {
//        return toupper(ch);
//    });
/*6*/
//    std::for_each(content, content + strlen(content), [](auto &ch)
//    {
//        ch = toupper(ch);
//    });

/*7*/
//    for (size_t i = 0; i < len; i++)
//    {
//        content[i] = static_cast<char>(toupper(content[i]));
//    }

/*8*/
//    auto toUpper = std::bind(ToUpper<char>(), std::placeholders::_1);
//
//    for (size_t i = 0; i < len; i++)
//    {
//        content[i] = static_cast<char>(toUpper(content[i]));
//    }

/*9*/
    std::transform(content, content + len, content, ToUpper<char>());

    printf("%s\n", content);

}
```



## IO多路转复用

### fcntl

```c++

```

### setsockopt / getsockopt

```c++

```

### select

```c++

```

### poll

```c++

```

### epoll

#### 水平触发（LT）

```c++

```

#### 边缘触发（ET）

```c++

```

#### 反应堆模型（非阻塞边缘触发转接）

```c++

```

#### 开源库

##### libevent

```shell

```



## inotify

监听目录状态变化

```c
#include <errno.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/inotify.h>
#include <unistd.h>

static void
handle_events(int fd, int *wd, int argc, char *argv[])
{
    /* Some systems cannot read integer variables if they are not
       properly aligned. On other systems, incorrect alignment may
       decrease performance. Hence, the buffer used for reading from
       the inotify file descriptor should have the same alignment as
       struct inotify_event. */

    char buf[4096]
            __attribute__ ((aligned(__alignof__(struct inotify_event))));
    const struct inotify_event *event;
    int i;
    ssize_t len;
    char *ptr;

    /* Loop while events can be read from inotify file descriptor. */

    for (;;)
    {

        /* Read some events. */

        len = read(fd, buf, sizeof buf);
        if (len == -1 && errno != EAGAIN)
        {
            perror("read");
            exit(EXIT_FAILURE);
        }

        /* If the nonblocking read() found no events to read, then
           it returns -1 with errno set to EAGAIN. In that case,
           we exit the loop. */

        if (len <= 0)
            break;

        /* Loop over all events in the buffer */

        for (ptr = buf; ptr < buf + len;
             ptr += sizeof(struct inotify_event) + event->len)
        {

            event = (const struct inotify_event *) ptr;

            /* Print event type */

            if (event->mask & IN_OPEN)
                printf("IN_OPEN: ");
            if (event->mask & IN_CLOSE_NOWRITE)
                printf("IN_CLOSE_NOWRITE: ");
            if (event->mask & IN_CLOSE_WRITE)
                printf("IN_CLOSE_WRITE: ");

            /* Print the name of the watched directory */

            for (i = 1; i < argc; ++i)
            {
                if (wd[i] == event->wd)
                {
                    printf("%s/", argv[i]);
                    break;
                }
            }

            /* Print the name of the file */

            if (event->len)
                printf("%s", event->name);

            /* Print type of filesystem object */

            if (event->mask & IN_ISDIR)
                printf(" [directory]\n");
            else
                printf(" [file]\n");
        }
    }
}


void inotify_with_c(int argc, char *argv[])
{
    char buf;
    int fd, i, poll_num;
    int *wd;
    nfds_t nfds;
    struct pollfd fds[2];

    if (argc < 2)
    {
        printf("Usage: %s PATH [PATH ...]\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    printf("Press ENTER key to terminate.\n");

    /* Create the file descriptor for accessing the inotify API */

    fd = inotify_init1(IN_NONBLOCK);
    if (fd == -1)
    {
        perror("inotify_init1");
        exit(EXIT_FAILURE);
    }

    /* Allocate memory for watch descriptors */

    wd = static_cast<int *>(calloc(argc, sizeof(int)));
    if (wd == NULL)
    {
        perror("calloc");
        exit(EXIT_FAILURE);
    }

    /* Mark directories for events
       - file was opened
       - file was closed */

    for (i = 1; i < argc; i++)
    {
        wd[i] = inotify_add_watch(fd, argv[i],
                                  IN_OPEN | IN_CLOSE);
        if (wd[i] == -1)
        {
            fprintf(stderr, "Cannot watch '%s'\n", argv[i]);
            perror("inotify_add_watch");
            exit(EXIT_FAILURE);
        }
    }

    /* Prepare for polling */

    nfds = 2;

    /* Console input */

    fds[0].fd = STDIN_FILENO;
    fds[0].events = POLLIN;

    /* Inotify input */

    fds[1].fd = fd;
    fds[1].events = POLLIN;

    /* Wait for events and/or terminal input */

    printf("Listening for events.\n");
    while (1)
    {
        poll_num = poll(fds, nfds, -1);
        if (poll_num == -1)
        {
            if (errno == EINTR)
                continue;
            perror("poll");
            exit(EXIT_FAILURE);
        }

        if (poll_num > 0)
        {

            if (fds[0].revents & POLLIN)
            {

                /* Console input is available. Empty stdin and quit */

                while (read(STDIN_FILENO, &buf, 1) > 0 && buf != '\n')

                    continue;
                break;
            }

            if (fds[1].revents & POLLIN)
            {

                /* Inotify events are available */

                handle_events(fd, wd, argc, argv);
            }
        }
    }

    printf("Listening for events stopped.\n");

    /* Close inotify file descriptor */

    close(fd);

    free(wd);
    exit(EXIT_SUCCESS);

}

int main()
{
    const char *argv[] = {"test", "/tmp"};

    inotify_with_c(sizeof argv / sizeof argv[0], const_cast<char **>(argv));

	return 0;
}
```



## 线程

### 简单线程

```c++
#include <pthread.h>
#include <iostream>

void *task_a(void *arg)
{
    auto no = reinterpret_cast<long int>(arg);

    for (;;)
    {
        printf("Thread %ld precess pid: %u \t thread id = %lu\n", no, getpid(), pthread_self());

        sleep(1);

    }
}

void create_thread()
{
    printf("Main precess pid: %u \t thread id = %lu\n", getpid(), pthread_self());

    pthread_t tid;

    for (int i = 0; i < 5; i++)
    {
        pthread_create(&tid, nullptr, task_a, reinterpret_cast<void *>(i));
    }

    sleep(1);

    printf("Main thread exit \n");

//    pthread_exit(nullptr);

//    exit(0);
    return;
}

```

### 带参线程

```c++
#include <pthread.h>
#include <iostream>

struct run_arg_t
{
    int num;
    char data[50];
};

typedef struct run_arg_t run_arg_t;


void thread_exit()
{

    printf("Main precess pid: %u \t thread id = %lu\n", getpid(), pthread_self());

    auto run = [](void *arg) -> void *
    {

        printf("this tid:%lu \n", pthread_self());

        auto *runArg = (run_arg_t *) arg;

        runArg->num = 123456789;

        strcpy(runArg->data, "123456789");

        usleep(2000);

        pthread_testcancel();

        pthread_exit(runArg);

        return arg;
    };

    pthread_t tid;

    pthread_attr_t attr;

    pthread_attr_init(&attr);

    size_t get_size;

    pthread_attr_getstacksize(&attr, &get_size);

    printf("thread default stack size:%ld\n", get_size);

    size_t stack_size = 100000000;

    void *stack = malloc(stack_size);

    pthread_attr_setstack(&attr, stack, stack_size);

//    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

    run_arg_t runArg = {123, "sdfsfsfsj"};

    runArg.num = 1;

    strcpy(runArg.data, "231423535634");

    printf("num=%d, data = %s\n", runArg.num, runArg.data);

    pthread_create(&tid, &attr, run, &runArg);

    printf("Main tid:%lu \n", pthread_self());

    printf("Child tid:%lu \n", tid);

    pthread_cancel(tid);

    pthread_attr_destroy(&attr);

    run_arg_t *retArg;

    int ret = pthread_join(tid, (void **) &retArg);

    if (ret == 0)
    {
        printf("ret arg num=%d, data = %s\n", retArg->num, retArg->data);
    } else
    {

        printf("detach recycle thread\n");

    }

    usleep(1000);

    free(stack);
}

```

### 最大线程数

```c++
#include <pthread.h>
#include <iostream>

void create_max_thread()
{
    struct run_arg_t
    {
        int num;
        char data[50];
    };

    typedef struct run_arg_t run_arg_t;


    printf("Main precess pid: %u \t thread id = %lu\n", getpid(), pthread_self());

    auto run = [](void *arg) -> void *
    {
        printf("thread %ld tid:%lu \n", reinterpret_cast<long int>(arg), pthread_self());

//        usleep(10);

        for (;;);

        pthread_exit(arg);
    };

    pthread_t tid;

    void *stack = nullptr;

    int ret;

    for (int i = 0; i < 1000000; i++)
    {
        pthread_attr_t attr;

        pthread_attr_init(&attr);

        size_t get_size;

        pthread_attr_getstacksize(&attr, &get_size);

        printf("thread default stack size:%ld\n", get_size);

        size_t stack_size = 100000000;

        stack = malloc(stack_size);

        pthread_attr_setstack(&attr, stack, stack_size);

        pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

        ret = pthread_create(&tid, &attr, run, reinterpret_cast<void *>(i));

        if (ret == 0)
        {
            printf("create %lu thread %d \n", tid, i);
        } else
        {
            static int count = 0;

            count++;

            perror(strerror(ret));

            if (count < 5)
                continue;
            else
                break;
        }

        pthread_attr_destroy(&attr);
    }

    free(stack);
}
```



### mutex

#### c++版本

```c++
#include <pthread.h>
#include <iostream>

void thread_sync_mutex_whit_cxx()
{
    struct Runnable
    {
        virtual void *run(void *) noexcept = 0;

    };

    struct Run : Runnable
    {
        pthread_mutex_t mutex;

        int count;

        inline Run() noexcept : count(0), mutex(pthread_mutex_t{})
        {
            pthread_mutex_init(&mutex, nullptr);
        }

        inline virtual ~Run() noexcept
        {
            pthread_mutex_destroy(&mutex);
        }

        inline void *run(void *arg) noexcept final
        {

            for (;;)
            {
                pthread_mutex_lock(&mutex);

                auto index = reinterpret_cast<long>(arg);

                if (index)
                    printf("count:%d \n", count);
                else
                    count++;

//                sleep(1);

                pthread_mutex_unlock(&mutex);
            }

            pthread_exit(arg);

            /*int ret;

             for (;;)
                 if (ret = pthread_mutex_lock(&mutex) == 0)
                 {
                     auto index = reinterpret_cast<long>(arg);

                     if (index)
                         printf("count:%d \n", count);
                     else
                         count++;

                     pthread_mutex_unlock(&mutex);

                 } else
                 {
                     printf("Cant't lock, error:%s\n", strerror(ret));
                 }*/
        }

        inline void *operator()(void *arg) noexcept
        {
            return run(arg);
        }


        static void *running(void *arg) noexcept
        {
            static Run run{};

            return run(arg);
        }
    };

    pthread_t tids[2];

    pthread_create(tids, nullptr, Run::running, (void *) 0);

    pthread_create(tids + 1, nullptr, Run::running, (void *) 1);

    usleep(1000);

    pthread_join(tids[0], nullptr);
    pthread_join(tids[1], nullptr);

}

```



#### 纯c++版本

```c++
#include <thread>
#include <mutex>
#include <iostream>

void thread_sync_mutex_whit_pure_cxx()
{

    class Running
    {
        virtual void run(int i) noexcept = 0;
    };

    class Runner : Running
    {
    private:
        std::mutex mutex1{};
        int count;

    public:
        Runner() : count(0) {}

        inline void operator()(int i) noexcept
        {
            run(i);
        }

        inline void run(int i) noexcept override
        {

            for (;;)
            {
                mutex1.lock();

                if (i % 2)
                {
                    count++;
                } else
                {
                    std::cout << "thread id: " << std::this_thread::get_id() << "\t count = " << count << std::endl;
                }

                mutex1.unlock();
            }
        }

    };

    std::vector<std::thread> threads;

    Runner runner{};

    for (int i = 0; i < 5; i++)
    {
        threads.push_back(std::thread(std::ref(runner), i));
    }

    for (auto &th: threads)
        th.join();
}

```



#### 纯c版本

```c
#include <pthread.h>
#include <iostream>

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

static int count = 0;

void *running1(void *arg)
{
    for (;;)
    {
        pthread_mutex_lock(&mutex);

        count++;

        pthread_mutex_unlock(&mutex);
    }

    pthread_exit(arg);
}

void *running2(void *arg)
{
    for (;;)
    {
        pthread_mutex_lock(&mutex);

        printf("count:%d \n", count);

        pthread_mutex_unlock(&mutex);
    }

    pthread_exit(arg);
}

void thread_sync_mutex_with_c()
{

    pthread_t tids[2];

    pthread_create(tids, nullptr, running1, (void *) 0);

    pthread_create(tids + 1, nullptr, running2, (void *) 1);

    usleep(1000);

    pthread_join(tids[0], nullptr);
    pthread_join(tids[1], nullptr);

    pthread_mutex_destroy(&mutex);
}

```



### 条件变量（condition）

```c++
#include <pthread.h>
#include <iostream>

pthread_cond_t cond = PTHREAD_COND_INITIALIZER;


void *running_cond1(void *arg)
{
    for (;;)
    {
        pthread_mutex_lock(&mutex);

        pthread_cond_signal(&cond);

        pthread_cond_wait(&cond, &mutex);

        count++;

        pthread_cond_signal(&cond);

        pthread_mutex_unlock(&mutex);
    }

    pthread_exit(arg);
}


void *running_cond2(void *arg)
{

    for (;;)
    {
        pthread_mutex_lock(&mutex);

        pthread_cond_signal(&cond);

        pthread_cond_wait(&cond, &mutex);

        printf("count:%d \n", count);

        pthread_cond_signal(&cond);

        pthread_mutex_unlock(&mutex);
    }

    pthread_exit(arg);
}

void thread_cond_mutex_with_c()
{
    pthread_t tids[2];

    pthread_create(tids, nullptr, running_cond1, (void *) 0);

    pthread_create(tids + 1, nullptr, running_cond2, (void *) 1);

    usleep(1000);

    pthread_join(tids[0], nullptr);
    pthread_join(tids[1], nullptr);

    pthread_mutex_destroy(&mutex);

    pthread_cond_destroy(&cond);

}
```

### 信号量（semaphore）

```c++
#include <semaphore.h>
#include <pthread.h>
#include <iostream>

sem_t sem;

void *running_sem(void *arg)
{
    for (;;)
    {
        sem_wait(&sem);

        long int index = (long int) arg;
        printf("thread %lu ...\n", index);

        sem_post(&sem);

        sleep(1);
    }

    pthread_exit(nullptr);
}


void thread_sem_with_c()
{
    sem_init(&sem, 0, 1);

    pthread_t tids[7];

    for (int i = 0; i < 7; i++)
        pthread_create(tids + i, nullptr, running_sem, reinterpret_cast<void *>(i));

    usleep(1000);

    for (int i = 0; i < 7; i++)
        pthread_join(tids[i], nullptr);

    sem_destroy(&sem);
}
```

### 屏障（barrier）

```c++
#include <pthread.h>
#include <iostream>

pthread_barrier_t barrier;

void *running_barrier1(void *arg)
{

    sleep(1);

    long int index = (long int) arg;

    printf("thread %lu waiting.... \n", index);

    pthread_barrier_wait(&barrier);

    printf("thread %lu running.... \n", index);

    for (int i = 0;; i++)
    {

        sleep(i % 3);

        printf("thread %lu %d'th count waiting.... \n", index, i);

        pthread_barrier_wait(&barrier);

        printf("thread %lu %d'th count  starting.... \n", index, i);

        sleep(1);

        count++;

        pthread_barrier_wait(&barrier);

    }

    pthread_exit(arg);
}


void *running_barrier2(void *arg)
{

    sleep(3);

    long int index = (long int) arg;

    printf("thread %lu waiting.... \n", index);

    pthread_barrier_wait(&barrier);

    printf("thread %lu running.... \n", index);

    for (int i = 0;; i++)
    {

        sleep(i % 5);

        printf("thread %lu %d'th print  waiting.... \n", index, i);

        pthread_barrier_wait(&barrier);

        printf("thread %lu  %d'th print  starting.... \n", index, i);

        sleep(1);

        printf("thread %lu print count:%d \n", index, count);

        pthread_barrier_wait(&barrier);
    }

    pthread_exit(arg);
}


void thread_barrier_with_c()
{
    pthread_barrier_init(&barrier, nullptr, 2);

    pthread_t tids[2];

    pthread_create(tids, nullptr, running_barrier1, (void *) 0);

    pthread_create(tids + 1, nullptr, running_barrier2, (void *) 1);

    usleep(1000);

    pthread_join(tids[0], nullptr);

    pthread_join(tids[1], nullptr);

    pthread_barrier_destroy(&barrier);
}

```

### 读写锁（rwlock）

```c++

```

### once

```c++

```



## 正则表达式

```c++
#include <iostream>
#include <regex.h>

void testRegex()
{
    const char str[] = "sdfsijweu34.67.5.89werqwesdfuji192.168.1.132sdfksdfjkghjisdf";

    const char regex[] = "([0-9]{1,3}\\.){3,3}[0-9]{1,3}";

    struct re_pattern_buffer preg{};

    int ret;

    ret = regcomp(&preg, regex, REG_EXTENDED);

    if (ret < 0)
    {
        char errbuf[BUFSIZ];

        regerror(ret, &preg, errbuf, sizeof(errbuf));

        write(STDOUT_FILENO, errbuf, strlen(errbuf));

        exit(ret);
    }

    const size_t size = 256;

    regmatch_t pmatch[size];

    ret = regexec(&preg, str, size, pmatch, 0);

    for (auto &index : pmatch)
    {
        write(STDOUT_FILENO, str + index.rm_so, index.rm_eo - index.rm_so - 1);
    }

    regfree(&preg);

}

```

