---
title: Java 에서 Hello World 를 출력하기까지 1
date: 2023-11-12 16:20:00 +0900
aliases: 
tags:
  - java
  - compile
  - jvm
categories: 
updated: 2023-12-08 14:31:53 +0900
---

## 들어가기 전에

프로그래밍 세계에서는 항상 `Hello World` 라는 문장을 출력하면서 시작한다. 그게 ~~국룰~~ 암묵적인 규칙이다.

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

그런데 [[Java]] 는 마치 다른 세계에서 온 것 같다. 심지어 여기서 끝이 아니다. 컴파일 과정은 아직 언급도 안했다.

`public` 은 무엇이고 `class` 는 무엇이고, `static` 은 또 무엇이며, `void`, `main`, `String[]`, `System.out.println` 을 거쳐야 드디어 "Hello World" 라는 문자열에 도달한다. ~~이제 다른 언어를 배우러 가자.~~

Java 는 도대체 왜 이리 말 많은(verbose) 과정이 필요할까?

이번 시리즈에서는 "Hello World" 라는 2단어를 출력하기 위해 뒤에서는 무슨 일이 일어나는지 살펴본다.

- 첫 번째 챕터에서는 의문의 시작이 되는 Hello World 를 살펴보면서 간단하게 이유를 소개한다.
- 두 번째 챕터에서는 실제로 컴파일된 class 파일을 살펴보며 컴퓨터가 java 코드를 어떻게 해석하고 실행하는지 살펴본다.
- 마지막으로 JVM 이 실행되는 과정에서 `public static void main` 을 메모리에 어떻게 적재하고 실행할 수 있는지 동작 원리에 대해 살펴본다.

아직 늦지 않았다. [생활코딩 파이썬](https://www.opentutorials.org/course/4769)

## Chapter 1. Why?

Java 에서 Hello World 를 출력하기 전까지 살펴봐야할 몇가지 why moment 가 있다.

### 왜 클래스 이름이 파일명이 되어야 하는가?

정확하게는 `public` 클래스의 이름이 파일명이어야 하는 것이다. 왜 그럴까?

Java 는 **컴파일 시점에 모든 class 를 `.class` 파일로 생성**한다. java 파일 이름이 public class 와 동일하지 않다면 java interpreter%% footer 추가 %% 는 모든 class 파일을 읽어서 main 메서드를 찾아야 한다. 파일 이름과 public class 의 이름이 같다면 Java interpreter 는 해석해야하는 파일을 더 잘 식별할 수 있다.

_왜 `main` 을 찾아야하냐고? 조금만 기다려주시라._

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
.rw-r--r--   302 haril  30 Nov 16:09  Outer$Inner.class
.rw-r--r--   503 haril  30 Nov 16:09  Outer.class
.rw-r--r--   159 haril  30 Nov 16:09  Outer.java
```

`Java1000` 이라는 파일이 있고, 이 파일 내부에 1000개의 클래스가 존재한다고 생각해보자. 1000 개의 클래스 중 어디에 `main()` 이 있는지 식별하기 위해서는 모든 클래스 파일을 살펴봐야 한다.

하지만 파일 이름과 public class 이름이 같다면 `main()` 에 더 빠르게 접근할 수 있고(`main` 은 public class 에 존재하므로), 모든 로직이 `main()` 에서부터 시작하기 때문에 쉽게 다른 클래스로 접근할 수 있다.

### 왜 public 이어야 할까?

JVM 은 클래스 안에 존재하는 `main` 메서드를 찾아야 한다. 클래스 외부에서 접근하는 JVM 이 클래스 내부의 메서드를 찾아야한다면 그 메서드는 `public` 이어야 할 것이다. 실제로 접근제어자를 `private` 으로 바꾸면 `main` 을 `public` 으로 선언하라는 에러 메세지가 출력된다.

```text
Error: Main method not found in class VerboseLanguage, please define the main method as:
   public static void main(String[] args)
```

### 왜 static 이어야 할까?

`public main()` 이라는 메서드는 찾았다. 하지만 이 메서드를 호출시키기 위해서는 먼저 객체를 생성해야 한다. JVM 입장에서 이 객체는 필요한 객체일까? 아니다, `main` 을 호출할 수 있기만 하면 된다. `static` 으로 선언함으로서 JVM 은 불필요한 객체를 생성할 필요가 없고, 메모리를 절약할 수 있다.

### 왜 void 여야 할까?

`main` 메서드의 종료는 Java 의 실행종료를 의미한다. JVM 은 `main` 메서드의 반환값으로 아무 것도 할 수 없으며, 따라서 반환값의 존재가 무의미하다. 그렇게 `void` 가 되었다.

### 왜 main 이어야 할까?

`main` 이라는 메서드 이름은 JVM 이 **애플리케이션을 실행하기 위해 찾는 진입점으로 설계**되어 있다.

설계라는 거창한 표현을 썼지만, 실제로는 main 이라는 method 를 찾도록 하드코딩 되어 있을 뿐이다. OpenJDK 8 의 `java.c` 를 살펴보면 C 언어로 작성된 아래 코드를 발견할 수 있다.

```c
mainClassName = GetMainClassName(env, jarfile);
mainClass = LoadClass(env, classname);

// main 메소드의 아이디를 찾는다.
mainID = (*env)->GetStaticMethodID(env, mainClass, "main", "([Ljava/lang/String;)V");

jbject obj = (*env)->ToReflectedMethod(env, mainClass, mainID, JNI_TRUE);
```

찾아야 하는 이름이 main 이 아니라 haril 이였다면, haril 이라는 메서드를 찾았을 것이다. 물론 Java 창시자 입장에서는 main 이라는 단어를 선택한 이유가 있겠지만, 단지 그 뿐이다.

### args 의 존재 이유?

지금까지 생략하여 표현했지만, `main()` 에는 `String[] args` 라는 arguments 가 포함되어 있다. 이 인자(arguments)는 명령행 인자(command-line arguments)라고 한다. 왜 문자열 배열로 선언되어 있고 명시하지 않으면 에러가 발생할까?

`public static void main(String[] args)` 이 자바 애플리케이션의 실행지점인 이상, 이 인자는 반드시 자바 외부에서 들어오게 된다.

> 표준 입력을 통해 입력하는 모든 타입은 문자열로 입력된다.

이것이 args 가 문자열 배열로 선언된 이유이다. 그럼 왜 args 가 있어야할까?

args 들을 단순한 방식으로 외부에서 내부로 넘겨줌으로써 자바 애플리케이션의 동작 방식을 바꿔줄 수 있고, 이런 메커니즘은 C 프로그램의 초창기부터 프로그램의 동작을 제어하기 위해 널리 쓰이던 방식이였다. 특히 간단하게 구현된 애플리케이션은 이 방법이 매우 효과적이다. Java 는 단순히 널리 쓰이던 방식을 채택했을 뿐이다.

또한 Java 의 진입 지점으로 `public static void main(String[] args)` 단 하나만 허용되기 때문에, `String[] args` 를 생략할 수 없는 것이다.

### System.out.println

#native #JNI

드디어 출력과 관련된 메서드에 대해 이야기를 시작할 수 있다.

_굳이 다시 언급하자면, Python 은 `print("Hello World")` 였다. [생활코딩 파이썬](https://www.opentutorials.org/course/4769)

자바 프로그램은 OS 에서 바로 실행되는 것이 아니라 JVM 이라는 가상 머신 위에서 실행된다. 이 점은 JVM 을 사용하는 언어라면 OS 에 상관없이 어디서나 애플리케이션을 실행할 수 있다는 장점이 된다.

동시에 OS 가 제공하는 특정 기능을 JVM 에서 사용하기 어렵다는 단점이 된다. Java 로 CLI 를 만들거나 OS 메트릭을 수집하는 등의 시스템 레벨의 코딩이 어렵다고 하는 이유가 이 때문이다.

하지만 제한적이나마 OS 기능을 빌려쓸 수 있는데([[Java Native Interface]]), 이 기능을 제공하는 것이 바로 `System` 이다. 대표적인 기능은 아래와 같은 것들이 있다.

- 표준 입력
- **표준 출력**
- 환경변수 설정
- 수행 중인 응용프로그램 종료하고 status 코드를 반환

`Hello World` 를 출력하기 위해 `System` 의 표준 출력 기능을 빌려 사용하는 것이다.

`System.out.println` 의 흐름을 따라가다보면 `native` 키워드가 달려있는 `writeBytes` 메서드를 만나게 되는데, 이 메서드 이후 C언어로 작성된 코드에 동작이 위임되며 표준 출력으로 넘어가게 된다.

```java
// FileOutputStream.java
private native void writeBytes(byte b[], int off, int len, boolean append)
    throws IOException;
```

이 기능은 Java Native Interface([[Java Native Interface]]) 를 통해 사용이 가능한데, 이에 대해서는 별도로 다룬다.

### String

#constant-pool #intern

Java 에서 문자열은 조금 특별하다. 아니, 많이 특별한 것 같다(footnote: https://www3.ntu.edu.sg/home/ehchua/programming/java/J3d_String.html). 메모리 레벨에서 별도의 공간을 할당 받을 정도니 분명히 특별취급을 받고 있다. 왜 그럴까?

먼저 자바에서 문자열을 선언하는 방식에 대해 살펴보자.

```java
String greeting = "Hello World";
```

내부적으로는 아래처럼 동작한다.

![](https://i.imgur.com/7j2HMrL.png)

문자열은 String Constant Pool 이라는 곳에 생성되며, 불변 속성을 지니고 있다. 한 번 생성된 문자열은 변하지 않으며, 이 후 문자열을 생성하려고 할 때 같은 문자열이 Constant Pool 에 있다면 재활용하게 된다.

문자열을 선언하는 또 다른 방법은, 인스턴스화 하는 방식이다.

```java
String greeting = new String("Hello World");
```

일반적으로 이 방법은 거의 사용되지 않는다. 내부 동작에 차이가 있기 때문인데 아래와 같다.

![](https://i.imgur.com/pN25lbX.png)

new 키워드 없이 문자열을 직접 사용했을 때에는 String Constant Pool 에 생성되어 재사용이 가능했다. 하지만 new 키워드를 통해 인스턴스화하면 일반 객체를 다루듯이 Heap 영역에 생성된다. 이 말은 같은 문자열을 몇 번이고 생성할 수 있다는 뜻이고, 메모리 공간을 낭비하게 될 수 있다.

### 정리

이번 챕터를 통해 다음과 같은 질문에 대답해봤다.

- 왜 `.java` 파일과 class 이름이 같아야할까?
- 왜 `public static void main(String[] args)` 이어야 할까?
- 출력 원리
- 문자열 동작 원리

## Conclusion

Java 는 분명 어려운 언어다.

면접을 보다보면 종종 이런 질문을 받는다.

_Java 에 대해서 얼마나 알고 계신다고 생각하시나요?_

이젠 좀 확실히 대답할 수 있을 것 같다.

_음... 🤔 Hello World 정도요._

## Reference

- [OpenJDK java.c](https://github.com/AdoptOpenJDK/openjdk-jdk8u/blob/master/jdk/src/share/bin/java.c)
- [OpenJDK](https://github.com/openjdk/jdk/tree/master)
- https://www.geeksforgeeks.org/java-main-method-public-static-void-main-string-args/
- https://www.geeksforgeeks.org/myth-file-name-class-name-java/
- https://www.includehelp.com/java/why-does-java-file-name-must-be-same-as-public-class-name.aspx
- https://www.devkuma.com/docs/java/system-class/
- https://inpa.tistory.com/entry/JAVA-%E2%98%95-%ED%81%B4%EB%9E%98%EC%8A%A4%EB%8A%94-%EC%96%B8%EC%A0%9C-%EB%A9%94%EB%AA%A8%EB%A6%AC%EC%97%90-%EB%A1%9C%EB%94%A9-%EC%B4%88%EA%B8%B0%ED%99%94-%EB%90%98%EB%8A%94%EA%B0%80-%E2%9D%93#jvm%EC%9D%98_%ED%81%B4%EB%9E%98%EC%8A%A4_%EB%A1%9C%EB%8D%94_class_loader
- https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-2.html#jvms-2.5
- https://www.baeldung.com/java-jvm-run-time-data-areas
- https://sgcomputer.tistory.com/64
- https://johngrib.github.io/wiki/java/run-time-constant-pool/
- https://johngrib.github.io/wiki/jvm-stack/
- https://code-run.tistory.com/8
- https://www.baeldung.com/java-command-line-arguments
