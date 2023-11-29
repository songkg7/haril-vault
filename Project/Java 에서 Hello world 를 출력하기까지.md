---
title: Java 에서 Hello world 를 출력하기까지
date: 2023-11-12 16:20:00 +0900
aliases: 
tags:
  - java
  - compile
  - jvm
categories: 
updated: 2023-11-29 20:44:19 +0900
---

## Overview

```python
print("Hello World")
```

[[Python]]? 훌륭하다.

```js
console.log("Hello World");
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

`public` 은 무엇이고 `class` 는 무엇이고, `static` 은 또 무엇이며, `void`, `main`, `String[]`, `System.out.println` 을 거쳐야 드디어 "Hello World" 라는 문자열에 도달한다. ~~이제 다른 언어를 배우러 가자.~~

"Hello World" 라는 2단어를 출력하기 위해 뒤에서는 무슨 일이 일어나는지 살펴본다.

아직 늦지 않았다.

## Java 를 실행하는 JVM

- [[Java Virtual Machine]]
- [[JNI]]

Hello World 가 어떤 메모리 영역에 적재되고 자바는 왜 main 메서드를 호출하는지

### main

`main` 이라는 메서드 이름은 JVM 이 애플리케이션을 실행하기 위해 찾는 진입점으로 설계되어 있다. OpenJDK 8 의 java.c 를 살펴보면 C 언어로 작성된 아래 코드를 발견할 수 있다.

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

```c
mainID = (*env)->GetStaticMethodID(env, mainClass, "main", "([Ljava/lang/String;)V");
```

말 그대로 JVM 은 running 시점에 `main` 이라는 이름을 찾아 실행시키는 것이다.

### public

JVM 은 클래스 안에서 `main`  메서드를 찾아야 한다. 그렇다면 `public` 이어야 할 것이다. 실제로 접근제어자를 private 으로 바꾸면 main 을 찾지 못한다.

```text
Error: Main method not found in class com.choonghee.MainMethod, please define the main method as:
   public static void main(String[] args)
```

### static

`public main()` 이라는 메서드는 찾았다. 하지만 이 코드를 실행시키기 위해서는 `main` 메서드를 포함하고 있는 객체를 생성해야 한다. JVM 입장에서 이 객체는 필요한 객체일까? `main` 을 호출할 수 있기만 하면 된다. `static` 으로 선언함으로서 JVM 은 `main` 을 실행시키기 위해서만 존재하는 불필요한 객체를 생성할 필요가 없고, 메모리를 절약할 수 있다.

### void

`main` 메서드의 종료는 Java 의 종료를 의미한다. JVM 은 `main` 메서드의 반환값으로 아무 것도 할 수 없으며, 따라서 반환값의 존재가 무의미하다. 그렇게 `void` 가 되었다.

## Compile

Java 를 컴파일 할 경우 어떤 형태로 생성되는지 확인해보자.

## Conclusion

Java 는 분명 어려운 언어다.

면접을 보다보면 종종 이런 질문을 받는다.

_Java 에 대해서 얼마나 알고 계신다고 생각하시나요?_

## Reference

- [OpenJDK java.c](https://github.com/AdoptOpenJDK/openjdk-jdk8u/blob/master/jdk/src/share/bin/java.c)
- [OpenJDK](https://github.com/openjdk/jdk/tree/master)
- https://www.geeksforgeeks.org/java-main-method-public-static-void-main-string-args/