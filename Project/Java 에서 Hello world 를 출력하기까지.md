---
title: Java 에서 Hello world 를 출력하기까지
date: 2023-11-12 16:20:00 +0900
aliases: 
tags:
  - java
  - compile
  - jvm
categories: 
updated: 2023-11-23 19:01:53 +0900
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

## JVM

[[Java Virtual Machine]]

## Compile

Java 를 컴파일 할 경우 어떤 형태로 생성되는지 확인해보자.

## Conclusion

## Reference
