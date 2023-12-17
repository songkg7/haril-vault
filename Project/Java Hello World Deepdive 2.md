---
title: Java 에서 Hello World 를 출력하기까지 2
date: 2023-12-08 14:33:00 +0900
aliases: 
tags:
  - java
  - compile
  - javac
  - javap
categories: 
updated: 2023-12-18 03:18:54 +0900
---

[[Java Hello World Deepdive 1]] 편에 이어서 "Hello World" 가 바이트코드로 컴파일되는 과정을 살펴봅니다.

## Chapter 2. Compile & Decompile

Java 를 컴파일 할 경우 어떤 형태로 생성되는지 확인해보자.

### Compile

Java 코드는 컴퓨터가 읽고 해석할 수 없다. Java 애플리케이션의 실행을 위해서는 컴퓨터가 읽고 해석할 수 있는 형태로 변환해줘야하는데, 이를 위해 아래와 같은 과정을 거치게 된다.

```
.java -> .class -> interpreting -> execution
```

`.class` 파일로 만든 파일은 JVM 이 읽고 해석할 수 있는 바이트코드로 되어 있다. 하지만 이렇게 컴파일된 자바 파일도 기계어는 아니기 때문에 OS 에서 실행할 수는 없다. 그걸 interpreter 에서 해석하는 과정이 있어야 비로소 컴퓨터가 실행할 수 있다. `.java` 파일을 클래스 파일로 만들어보자. 아래 명령어를 사용하면 된다.

```bash
$ javac VerboseLanguage.java
```

![](https://i.imgur.com/xPMY0Ib.png)

클래스 파일이 생성된 것을 확인할 수 있다. `java` 명령어를 사용해서 클래스 파일을 실행시킬 수 있고, 이때 확장자는 명시하지 않아야 한다.

```bash
$ java VerboseLanguage
// Hello World
```

컴파일 과정을 진행하면 읽기 어려운 바이트코드로 변환된다. JDK 에는 개발자가 컴파일된 바이트 코드를 확인해볼 수 있도록 도구를 제공하므로 사용해보자.

### Decompile

앞서 컴파일 과정은 이미 진행했으니 `javap` 를 사용해서 바이트코드를 사람이 읽을 수 있는 형태로 변환(decompile)한다.

```java
public class VerboseLanguage {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

```bash
javap -c -p VerboseLanguage.class
```

```
Compiled from "VerboseLanguage.java"
public class VerboseLanguage {
  public VerboseLanguage();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: getstatic     #7                  // Field java/lang/System.out:Ljava/io/PrintStream;
       3: ldc           #13                 // String Hello World
       5: invokevirtual #15                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
       8: return
}
```

출력된 결과를 보면 기본 생성자처럼 보이는 구조와 main 메서드를 확인할 수 있다.

- `invokespecial` : 생성자
- `invokevirtual`
- getstatic 에서 System.out 의 PrintStream 을 static 호출하는 것을 확인할 수 있다.
- `ldc` 라인에서 문자열 생성, ldc 는 runtime data area 에 데이터를 로드했다는 의미
- println 이 호출된다

컴파일된 바이트 코드를 실행시키는건 JVM 이 담당한다.

```java
void spin() {
    int i;
    for (i = 0; i < 10; i++) {
        // Loop body is empty
    }
}
```

```
void spin();
    Code:
       0: iconst_0
       1: istore_1
       2: iload_1
       3: bipush        10
       5: if_icmpge     14
       8: iinc          1, 1
      11: goto          2
      14: return
```

![[Java Hello World Deepdive 1#Reference]]
