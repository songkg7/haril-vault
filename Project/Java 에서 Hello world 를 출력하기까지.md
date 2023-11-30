---
title: Java 에서 Hello world 를 출력하기까지
date: 2023-11-12 16:20:00 +0900
aliases: 
tags:
  - java
  - compile
  - jvm
categories: 
updated: 2023-11-30 17:23:06 +0900
---

프로그래밍 세계에서는 항상 첫 시작을 `Hello World` 라는 문구와 함께 한다. 그게 암묵적인 규칙이다.

## Overview

```python
# hello.py
print("Hello World")
```

```bash
python hello.py
// Hello World
```

[[Python]]? 훌륭하다.

```js
// hello.js
console.log("Hello World");
```

```bash
node hello.js
// Hello World
```

[[JavaScript]]? 나쁘지 않다.

```java
// 심지어 VerboseLanguage.java 파일이여야만 하는 점도 빼놓을 수 없다.
public class VerboseLanguage {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

```bash
javac VerboseLanguage.java
java VerboseLanguage
// Hello World
```

그런데 [[Java]] 는 마치 다른 세계에서 온 것 같다. 심지어 여기서 끝이 아니다. 컴파일 과정은 아직 언급도 안했다. 여기서 이번 글의 주제가 등장한다. 스스로에게 질문해보자.

> Java 에서 "Hello, World" 를 출력하기 위해 어떤 과정이 숨어있을까요?

- Java 의 탄생 배경
- JVM 컴파일 과정 및 메모리 로딩
- public 접근제어자
- JVM 메모리 구조와 public static
- 왜 class 이름이 파일 이름과 같아야 하는지
- 왜 `main` 메서드여야 하는지
- `System.out` 의 의미

## Java 의 탄생

타언어들에 비해 [[Java]] 는 Hello World 를 출력하기 위해 알아야하는 배경지식이 많은 편이다.

"Hello World" 라는 2단어를 출력하기 위해 뒤에서는 무슨 일이 일어나는지 살펴본다.

`public` 은 무엇이고 `class` 는 무엇이고, `static` 은 또 무엇이며, `void`, `main`, `String[]`, `System.out.println` 을 거쳐야 드디어 "Hello World" 라는 문자열에 도달한다. ~~이제 다른 언어를 배우러 가자.~~

다음으로는 JVM 이 실행되는 과정에서 public static void main 을 메모리에 어떻게 적재하고 실행할 수 있는지 동작 원리에 대해 알아본다.

그 다음은 실제로 컴파일된 class 파일을 살펴보며 컴퓨터가 java 코드를 어떻게 해석하고 실행하는지 살펴본다.

아직 늦지 않았다. [생활코딩 파이썬](https://www.opentutorials.org/course/4769)

## Why?

### 왜 클래스 이름이 파일명이 되어야 하는가?

정확하게는 `public` 클래스의 이름이 파일명이어야 하는 것이다. 왜 그럴까?

Java 는 **컴파일 시점에 모든 class 를 `.class` 파일로 생성**한다. java 파일 이름이 public class 와 동일하지 않다면 java interpreter 는 모든 class 를 읽어서 main 메서드를 찾아야 한다. 파일 이름과 public class 의 이름이 같다면 Java interpreter 는 해석해야하는 파일을 더 잘 식별할 수 있다.

```java
public class Outer {
    public static void main(String[] args) {
        System.out.println("This is Outer class");
    }

    private class Inner {
    }
}
```

```bash
javac Outer.java
```

```text
Permissions Size User   Date Modified Name
.rw-r--r--   302 kgsong 30 Nov 16:09  Outer$Inner.class
.rw-r--r--   503 kgsong 30 Nov 16:09  Outer.class
.rw-r--r--   159 kgsong 30 Nov 16:09  Outer.java
```

`Java1000` 이라는 파일이 있고, 이 파일 내부에 1000개의 클래스가 존재한다고 생각해보자. 1000 개의 클래스 중 어디에 `main()` 이 있는지 식별하기 위해서는 모든 클래스 파일을 살펴봐야 한다.

하지만 파일 이름과 public class 이름이 같다면 `main()` 에 더 빠르게 접근할 수 있고(`main` 은 public class 에 존재하므로), 모든 로직이 `main()` 에서부터 시작하기 때문에 쉽게 다른 클래스로 접근할 수 있다.

### public

JVM 은 클래스 안에서 `main` 메서드를 찾아야 한다. 그렇다면 `public` 이어야 할 것이다. 실제로 접근제어자를 `private` 으로 바꾸면 `main` 을 `public` 으로 선언하라는 에러 메세지가 출력된다.

```text
Error: Main method not found in class VerboseLanguage, please define the main method as:
   public static void main(String[] args)
```

### static

`public main()` 이라는 메서드는 찾았다. 하지만 이 코드를 실행시키기 위해서는 `main` 메서드를 포함하고 있는 객체를 생성해야 한다. JVM 입장에서 이 객체는 필요한 객체일까? 아니다, `main` 을 호출할 수 있기만 하면 된다. `static` 으로 선언함으로서 JVM 은 불필요한 객체를 생성할 필요가 없고, 메모리를 절약할 수 있다.

```c
// JNI 는 true 가 되기 때문에 static 메서드를 찾는다
```

### void

`main` 메서드의 종료는 Java 의 종료를 의미한다. JVM 은 `main` 메서드의 반환값으로 아무 것도 할 수 없으며, 따라서 반환값의 존재가 무의미하다. 그렇게 `void` 가 되었다.

### main

앞선 문단에서 JVM 은 클래스 안에서 `main` 메서드를 찾는다고 했다.

`main` 이라는 메서드 이름은 JVM 이 애플리케이션을 실행하기 위해 찾는 진입점으로 설계되어 있다. OpenJDK 8 의 `java.c` 를 살펴보면 C 언어로 작성된 아래 코드를 발견할 수 있다.

```c
mainClassName = GetMainClassName(env, jarfile);
mainClass = LoadClass(env, classname);

// main 메소드의 아이디를 찾는다.
mainID = (*env)->GetStaticMethodID(env, mainClass, "main", "([Ljava/lang/String;)V");

/*
  mainClass, mainID를 가지고 
  java.lang.reflect.Method 객체로 변환한다.
  JNI_TRUE면 static 메소드를 찾는다.
*/
jbject obj = (*env)->ToReflectedMethod(env, mainClass, mainID, JNI_TRUE);
```

%% 내용 추가 %%

```c
// main 메소드의 아이디를 찾는다.
mainID = (*env)->GetStaticMethodID(env, mainClass, "main", "([Ljava/lang/String;)V");
```

말 그대로 JVM 은 running 시점에 `main` 이라는 이름을 찾아 실행시키는 것이다.

### args

`main()` 에는 `main(String[] args)` 라는 arguments 가 포함되어 있다.

### System.out.println()

드디어 출력과 관련된 메서드에 대해 이야기를 시작할 수 있다.

_굳이 다시 언급하자면, Python 은 `print("Hello World")` 였다. 생활코딩 파이썬 링크_

### String

Java 에서 문자열은 조금 특별하다.

### 정리

이번 챕터를 통해 다음과 같은 질문에 대답해봤다.

- 왜 `.java` 파일과 class 이름이 같아야할까?
- 왜 `public static void main(String[] args)` 이어야 할까?
- 출력 원리
- 문자열 동작 원리

---

## Compile

Java 를 컴파일 할 경우 어떤 형태로 생성되는지 확인해보자. 앞서 컴파일 과정은 이미 진행했으니 `javap` 를 사용해서 바이트코드를 사람이 읽을 수 있는 형태로 변환한다.

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

컴파일된 바이트 코드를 실행시키는건 JVM 이 담당한다.

## Java 를 실행하는 JVM

- [[Java Virtual Machine]]
- [[JNI]]
- Hello World 가 어떤 메모리 영역과 상호작용하게 되는지
- JVM 메모리 적재 과정

앞선 챕터에서 Java 의 기본적인 규칙이 정의된 이유에 대해 대략적으로 들여다봤다. 이번 챕터에서는 JVM 이 실행되면서 코드 블록을 어떻게 동작시키는지 살펴본다.

### Structure

#### Class Loader

#### Runtime Data Area

#### Execution Engine

## Conclusion

Java 는 분명 어려운 언어다.

면접을 보다보면 종종 이런 질문을 받는다.

_Java 에 대해서 얼마나 알고 계신다고 생각하시나요?_

이젠 대답한다.

_Hello World 정도요_

## Reference

- [OpenJDK java.c](https://github.com/AdoptOpenJDK/openjdk-jdk8u/blob/master/jdk/src/share/bin/java.c)
- [OpenJDK](https://github.com/openjdk/jdk/tree/master)
- https://www.geeksforgeeks.org/java-main-method-public-static-void-main-string-args/
- https://www.geeksforgeeks.org/myth-file-name-class-name-java/
- https://www.includehelp.com/java/why-does-java-file-name-must-be-same-as-public-class-name.aspx
