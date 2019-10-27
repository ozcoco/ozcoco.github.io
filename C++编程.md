# C++编程

------

## 基础

### 变量

#### 定义字符串数组

```c
const char *argv[] = {"test", "/tmp"};
int len = sizeof argv / sizeof argv[0]; //数组长度
```

