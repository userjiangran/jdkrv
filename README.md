# jdk版本控制工具 jdkrv



## 操作便捷，几行命令即可完成jdk下载环境变量配置，jdk统一管理，代码开源 gitee地址：



## 一、下载

### 有两种方式一种是开箱即用里面已经包含了各个版本的jdk省的自己下载了将压缩包下载到本地解压后将解压文件夹添加到系统变量中直接就可以执行查看命令切换jdk版本了，查看命令和切换版本命令看下面

![image-20250207150703429](C:\Users\kcswg\AppData\Roaming\Typora\typora-user-images\image-20250207150703429.png)

### 另一种就是创建一个文件夹下载jdkrv.bat文件放到创建的文件夹里面然后执行初始化命令就可以下载自己所需的jdk了，初始化命令和下载命令看下面

## 2.使用命令（操作时用管理身份打开cmd在切换jdk版本时不是管理员添加不上）

### 第一步先将jdkrv.bat添加到环境变量

![image-20250207152634937](C:\Users\kcswg\AppData\Roaming\Typora\typora-user-images\image-20250207152634937.png)

### 查看版本

```cmd
jdkrv version
```



### 初始化命令（刚下载jdkrv.bat文件的第一步需要初始化，用的现成的压缩包的就不用了）

```cmd
jdkrv init
```

![1738913427139](C:\Users\kcswg\Documents\WeChat Files\wxid_po1qb7ozirk622\FileStorage\Temp\1738913427139.jpg)

初始化后会生成配置文件，conf.jdkrv在里面可以修改jdk的下载存放路径，jdkLinks.jdkrv中可以修改增加jdk的下载url地址



### 查看可以下载jdk

```cmd
#查看可下载jdk
jdkrv links
#查看可下载jdk和url
jdkrv links all
```

![image-20250207153356177](C:\Users\kcswg\AppData\Roaming\Typora\typora-user-images\image-20250207153356177.png)



### 下载jdk(后面版本自行替换)

```cmd
jdkrv install jdk-12
```

![image-20250207154254734](C:\Users\kcswg\AppData\Roaming\Typora\typora-user-images\image-20250207154254734.png)



### 查看本地已下载jdk

```cmd
jdkrv list
```

![image-20250207153938257](C:\Users\kcswg\AppData\Roaming\Typora\typora-user-images\image-20250207153938257.png)



### 切换jdk(切换后在打开一个cmd用 java -version验证)

```cmd
jdkrv use jdk-12
```

![image-20250207154034633](C:\Users\kcswg\AppData\Roaming\Typora\typora-user-images\image-20250207154034633.png)



