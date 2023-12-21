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
updated: 2023-12-21 16:02:24 +0900
---

[[Java Hello World Deepdive 1]] 편에 이어서 "Hello World" 가 바이트코드로 컴파일되는 과정을 살펴봅니다.

## Chapter 2. Compile & Disassemble

[[Java]] 는 OS 가 직접 실행할 수 있는 언어는 아니다. 컴퓨터가 실행하기 위해 변환과정이 필요한데 이를 컴파일(Compile)이라고 한다. 이런 컴파일 과정이 필요한 언어를 컴파일 언어라고 한다. 컴파일 과정의 유무는 언어의 성능을 가늠하는 중요 포인트 중 하나이다. 컴파일 언어들은 이 컴파일 과정을 최적화하기 위해 각고의 노력을 다하고 있다. 자바에서 컴파일이 어떻게 동작하는지 한 번 살펴보자.

### Compile

앞서 설명했던 것처럼 Java 코드는 컴퓨터가 읽고 해석할 수 없다. Java 애플리케이션의 실행을 위해서는 컴퓨터가 읽고 해석할 수 있는 형태로 변환해줘야하는데, 이를 위해 아래와 같은 과정을 거치게 된다.

```
.java --> .class --> interpreting --> execution
```

컴파일의 결과로 생성된 `.class` 파일은 JVM 이 읽고 해석할 수 있는 바이트 코드로 되어 있다. 하지만 이렇게 컴파일된 파일도 기계어는 아니기 때문에 여전히 OS 에서 실행할 수는 없다. 그걸 interpreter 에서 해석하는 과정이 있어야 비로소 OS가 실행할 수 있다.

우선, `.java` 파일을 컴파일해보자. 아래 명령어를 사용하면 된다.

```java
// VerboseLanguage.java
public class VerboseLanguage {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

```bash
$ javac VerboseLanguage.java
```

![](https://i.imgur.com/xPMY0Ib.png)

클래스 파일이 생성된 것을 확인할 수 있다. `java` 명령어를 사용해서 클래스 파일을 실행시킬 수 있다.

```bash
$ java VerboseLanguage
// Hello World
```

class 파일이 어떤 내용으로 이루어졌는지 궁금하지 않은가? 도대체 어떤 내용으로 이루어져 있을까? 기대를 안고 열어보면

![](https://i.imgur.com/t9WAXdz.png)
_어림도 없지_

바이너리(binary)라는 짤막한 내용만 표시된다.

_아니 지금까지 컴파일의 결과물은 바이트 코드라며...?_

그렇다. 바이트 코드다. 동시에 바이너리 코드이기도 하다. 이쯤에서 바이트 코드와 바이너리 코드의 차이점을 간략하게 짚어보고 넘어가자.

- 바이너리 코드: 0과 1 로만 구성된 코드. 기계어는 바이너리 코드로 이루어져 있지만, 모든 바이너리 코드가 기계어인 것은 아니다.
- 바이트 코드: 0과 1 로만 구성된 코드. 하지만 바이트 코드는 기계(machine)을 위한 것이 아닌 **VM 을 위한 것**이다. VM 에서 JIT compiler 등을 통해 기계어로 변환된다.

그래도 나름 이 글의 주제가 deepdive 를 표방하고 있는만큼 꾸역꾸역 변환하여 읽어봤다.

![](https://i.imgur.com/WwrGlp0.png)
_class 파일은 분명히 binary 로 되어 있다_

자바 컴파일의 결과물이 0과 1로 구성된 바이너리임을 명확히 했다.

### Disassemble

컴파일 과정을 진행하면 0과 1로 구성된 바이트 코드로 변환된다. 바이트 코드를 개발자가 해석하기는 어렵지만, JDK 에는 개발자가 컴파일된 바이트 코드를 읽을 수 있게 도와주는 도구가 포함되어 있어서 디버깅 목적 등으로 사용할 수 있다. 이 과정을 **역어셈블(disassemble)** 이라고 한다. 가끔 이 과정을 역컴파일이라고도 하는 것 같지만, `javap` 문서에는 명확하게 disassemble 이라고 표현하고 있으므로 이를 따르도록 하겠다.

![](https://i.imgur.com/vct9MSZ.png)

> [!info] 역컴파일(decompile)과 역어셈블(disassemble)의 차이
> 역컴파일의 경우는 바이트코드를 컴파일 되기 전, 상대적으로 고수준의 언어로 표현한다. 역어셈블의 경우는 바이트코드를 사람이 읽을 수 있는 특정 형식으로 표현해주는 것을 말한다.

`javap` 를 사용해서 바이트코드를 사람이 읽을 수 있는 형태로 변환(disassemble)해보자.

```bash
$ javap -c -p VerboseLanguage.class
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
