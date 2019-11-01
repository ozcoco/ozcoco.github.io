# C++编程

------

## 基础

### 变量

#### 定义字符串数组

```c
const char *argv[] = {"test", "/tmp"};
int len = sizeof argv / sizeof argv[0]; //数组长度
```

#### 构造器（constructor）

```c++

```

#### 析构器（destructor）

```c++

```

## 异常处理

#include <exception>

```c++
#include <iostream>
#include <exception>

class MyException : public std::exception {

public:

    inline explicit MyException(const char *_msg) noexcept : msg(_msg) {

    }

    [[nodiscard]] inline const char *getMsg() const noexcept {

        return msg.c_str();
    }

private:
    std::string msg;

};


int main() {

    try {

        printf("1234\n");

        throw MyException("11212421423");

    } catch (const MyException &ex) {

        printf("----->%s", ex.getMsg());

    }
    catch (...) {

        printf("finally");

    }

}

```



## 容器

### 常见问题

#### 对象切割

```c++
class Anim
{


public:
    Anim(int type, int age, std::string name, std::string desc) : type(type), age(age), name(std::move(name)),

                                                                  desc(std::move(desc)) {}

    virtual ~Anim()
    {

    }

    int getType() const
    {
        return type;
    }

    void setType(int type)
    {
        Anim::type = type;
    }

    int getAge() const
    {
        return age;
    }

    void setAge(int age)
    {
        Anim::age = age;
    }

    const std::string &getName() const
    {
        return name;
    }

    void setName(const std::string &name)
    {
        Anim::name = name;
    }

    const std::string &getDesc() const
    {
        return desc;
    }

    void setDesc(const std::string &desc)
    {
        Anim::desc = desc;
    }

    bool operator==(const Anim &rhs) const
    {
        return type == rhs.type &&
               age == rhs.age &&
               name == rhs.name &&
               desc == rhs.desc;
    }

    bool operator!=(const Anim &rhs) const
    {
        return !(rhs == *this);
    }

    bool operator<(const Anim &rhs) const
    {
        if (type < rhs.type)
            return true;
        if (rhs.type < type)
            return false;
        if (age < rhs.age)
            return true;
        if (rhs.age < age)
            return false;
        if (name < rhs.name)
            return true;
        if (rhs.name < name)
            return false;
        return desc < rhs.desc;
    }

    bool operator>(const Anim &rhs) const
    {
        return rhs < *this;
    }

    bool operator<=(const Anim &rhs) const
    {
        return !(rhs < *this);
    }

    bool operator>=(const Anim &rhs) const
    {
        return !(*this < rhs);
    }

    friend std::ostream &operator<<(std::ostream &os, const Anim &anim)
    {
        os << "type: " << anim.type << " age: " << anim.age << " name: " << anim.name << " desc: " << anim.desc;
        return os;
    }

private:
    int type;
    int age;
    std::string name;
    std::string desc;
};


class Dog : public Anim
{
public:
    Dog(int type, int age, const std::string &name, const std::string &desc, int color) : Anim(type, age, name, desc),
                                                                                          color(color) {}

    enum : int
    {
        RED = 0xff0000,
        GREEN = 0x00ff00,
        BLUE = 0x0000ff
    };

    enum class TYPE : unsigned int
    {
        RED = 0xff0000,
        GREEN = 0x00ff00,
        BLUE = 0x0000ff
    };

    int getColor() const
    {
        return color;
    }

    void setColor(int color)
    {
        Dog::color = color;
    }

private:
    int color;

};

#include <vector>

void objectCut()
{
    using std::vector;

    vector<Anim> animVc;

#ifdef __linux__

    printf("anim size:%lu\n dog size:%lu\n", sizeof(Anim &), sizeof(Dog &));

    __try
    {
        animVc.push_back(Dog(1, 12, "oneko", "Cat", 123456));

        Dog &dog2 = (Dog &) animVc.at(0);

        printf("color=%d\nname=%s", dog2.getColor(), dog2.getName().c_str());
    }
    __catch(std::bad_cast &ex)
    {
        printf("ERR:%s\n", ex.what());
    }
    __catch(std::bad_alloc &ex)
    {
        printf("ERR:%s\n", ex.what());
    }
    __catch(...)
    {
        printf("ERR:%s\n", std::current_exception().__cxa_exception_type()->name());
    }

#elif WIN32

    using std;

    cout<<"windows"<<endl;

#endif


}
```

结果：

anim size:80
 dog size:88
color=0
name=oneko
Process finished with exit code 0