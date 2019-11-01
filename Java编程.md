# Java编程

------



## 对象序列化

### Serializable

```java
class Pair<K, V> implements Serializable {

    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }

    public K key;

    public V value;
    
    public transient String desc = getClass().descriptorString();

    @Override
    public String toString() {
        return "Pair{" +
                "key=" + key +
                ", value=" + value +
                '}';
    }
}


    private static void testSerializable() {

        String objFile = "/tmp/a.obj";

        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(objFile))) {

            Pair inObj = new Pair<Integer, String>(1, "serializable");

            System.out.println("-->inObj:" + inObj.desc);

            oos.writeObject(inObj);

            oos.flush();

            oos.close();

            ObjectInputStream ois = new ObjectInputStream(new FileInputStream(objFile));

            Pair outObj = (Pair) ois.readObject();

            ois.close();

            System.out.println(outObj.toString());

            System.out.printf("inA hashcode: %d \n outA hashcode: %d\n", inObj.hashCode(), outObj.hashCode());

            System.out.println("**->outObj:" + outObj.desc);

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }

    }
```

### Externalizable

被序列化类必须存在无参构造函数

```java
/*Externalizable, There must be a constructor with no parameters */
class Tuple implements Externalizable {


    public Tuple() {
    }

    public Tuple(Object key, Object value) {
        this.key = key;
        this.value = value;
    }

    public Object key;

    public Object value;

    @Override
    public String toString() {
        return "Tuple{" +
                "key=" + key +
                ", value=" + value +
                '}';
    }

    @Override
    public void writeExternal(ObjectOutput out) throws IOException {

        out.writeObject(key);

        out.writeObject(value);
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {

        key = in.readObject();

        value = in.readObject();

    }
}

    private static void testExternalizable() {

        String objFile = "/tmp/b.obj";

        ObjectOutputStream oos = null;

        ObjectInputStream ois = null;

        Tuple inObj, outObj;

        try {

            oos = new ObjectOutputStream(new FileOutputStream(objFile));

            inObj = new Tuple(1, "serializable");

            oos.writeObject(inObj);

            oos.flush();

            ois = new ObjectInputStream(new FileInputStream(objFile));

            outObj = (Tuple) ois.readObject();

            System.out.println(outObj.toString());

            System.out.printf("inA hashcode: %d \n outA hashcode: %d", inObj.hashCode(), outObj.hashCode());

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {

            if (oos != null) {
                try {
                    oos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (ois != null) {
                try {
                    ois.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            inObj = null;

            outObj = null;
        }

    }
```



## 线程

### Runnable

```java

```

### Thread

```java

```

### Callable

```java

```

### 线程池（Executors）

```java

```

### 共享内存

#### 可见性（volatile）

```java

```

#### 原子性（Atomic）

```java

```

#### 线程内通信（ThreadLocal）

```java

```

#### 线程间通信（单例static）

```java

```



### 并发

#### 互斥（synchronized）

```java

```

#### 同步（wait / notify / notifyAll）

```java

```



#### Lock

##### 	互斥

###### ReentrantLock

```java

```

###### ReentrantReadWriteLock

```java

```



##### 	同步

###### 条件变量（Condition）

```java

```

###### 信号量（Semaphore）

```java

```

###### 屏障（CyclicBarrier）

```java

```

###### 倒计时（CountDownLatch）

```java

```

###### 交换（Exchanger）

```java

```



## NIO

```java

```



## 设计模式

### 单例

```java

```

### 观察者

```java

```

### 静态代理

```java

```

### 动态代理

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class DynamicProxy {

    public static void main(String[] args) {

        DynamicTest2 dynamicTest2 = new DynamicTest2();

        IDynamicTest dynamicTest = (IDynamicTest) Proxy.newProxyInstance(
                LogHandler.class.getClassLoader(),
                new Class[]{IDynamicTest.class},
                new LogHandler(dynamicTest2, new ThreadLogger()));

        dynamicTest.print();

        dynamicTest.print2();

    }

}


interface IDynamicTest {

    void print();

    void print2();

}


class DynamicTest2 implements IDynamicTest {

    @Override
    public void print() {

        System.out.println("DynamicTest2");

    }

    @Override
    public void print2() {

    }
}


class DynamicTest3 implements IDynamicTest {

    @Override
    public void print() {

        System.out.println("DynamicTest3");

    }

    @Override
    public void print2() {

    }
}

interface ILogger {

    void d(String msg);

    void w(String msg);

    void e(String msg);

    void i(String msg);

}


class ThreadLogger implements ILogger {


    private void print(String msg) {

        System.out.println(Thread.currentThread().getName() + "---->" + msg);

    }

    @Override
    public void d(String msg) {
        print("D:\t" + msg);
    }

    @Override
    public void w(String msg) {
        print("W:\t" + msg);
    }

    @Override
    public void e(String msg) {
        print("E:\t" + msg);
    }

    @Override
    public void i(String msg) {
        print("I:\t" + msg);
    }
}


class LogHandler implements InvocationHandler {

    private final ILogger mLogger;

    private final Object mTarget;

    public LogHandler(Object target, ILogger logger) {

        this.mTarget = target;

        this.mLogger = logger;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

        mLogger.d("enter-->" + method.getName());

        final Object result = method.invoke(mTarget, args);

        mLogger.d("exit-->" + method.getName());

        return result;
    }
}


```

### 依赖注入

```java

```

### 装饰器

```java

```

### 适配器

```java

```

### MVP

```java

```

### MVC

```java

```

### MVVM

```java

```



## 集合

### Array

#### ArrayList

### Link

#### LinkedList

### Tree

#### HashMap

```java

```

#### HashTable

```java

```

