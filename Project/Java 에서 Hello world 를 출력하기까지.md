---
title: Java 에서 Hello world 를 출력하기까지
date: 2023-11-12 16:20:00 +0900
aliases: 
tags:
  - java
  - compile
  - jvm
categories: 
updated: 2023-12-07 18:46:44 +0900
---

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

Java 는 도대체 왜 이리 말 많은(verbose) 과정이 필요할까?

- public 접근제어자
- JVM 메모리 구조와 public static
- 왜 class 이름이 파일 이름과 같아야 하는지
- 왜 `main` 메서드여야 하는지
- `System.out` 의 의미
- JVM 컴파일 과정 및 메모리 로딩

## 들어가기 전에

타언어들에 비해 [[Java]] 는 Hello World 를 출력하기 위해 알아야하는 배경지식이 많은 편이다.

"Hello World" 라는 2단어를 출력하기 위해 뒤에서는 무슨 일이 일어나는지 살펴본다.

`public` 은 무엇이고 `class` 는 무엇이고, `static` 은 또 무엇이며, `void`, `main`, `String[]`, `System.out.println` 을 거쳐야 드디어 "Hello World" 라는 문자열에 도달한다. ~~이제 다른 언어를 배우러 가자.~~

다음으로는 JVM 이 실행되는 과정에서 `public static void main` 을 메모리에 어떻게 적재하고 실행할 수 있는지 동작 원리에 대해 알아본다.

그 다음은 실제로 컴파일된 class 파일을 살펴보며 컴퓨터가 java 코드를 어떻게 해석하고 실행하는지 살펴본다.

아직 늦지 않았다. [생활코딩 파이썬](https://www.opentutorials.org/course/4769)

## Chapter 1. Why?

Java 에서 Hello World 를 출력하기 전까지 살펴봐야할 몇가지 why moment 가 있다.

### 왜 클래스 이름이 파일명이 되어야 하는가?

정확하게는 `public` 클래스의 이름이 파일명이어야 하는 것이다. 왜 그럴까?

Java 는 **컴파일 시점에 모든 class 를 `.class` 파일로 생성**한다. java 파일 이름이 public class 와 동일하지 않다면 java interpreter%% footer 추가 %% 는 모든 class 파일을 읽어서 main 메서드를 찾아야 한다. 파일 이름과 public class 의 이름이 같다면 Java interpreter 는 해석해야하는 파일을 더 잘 식별할 수 있다.

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

### public

JVM 은 클래스 안에서 `main` 메서드를 찾아야 한다. 그렇다면 `public` 이어야 할 것이다. 실제로 접근제어자를 `private` 으로 바꾸면 `main` 을 `public` 으로 선언하라는 에러 메세지가 출력된다.

```text
Error: Main method not found in class VerboseLanguage, please define the main method as:
   public static void main(String[] args)
```

### static

`public main()` 이라는 메서드는 찾았다. 하지만 이 메서드를 호출시키기 위해서는 먼저 객체를 생성해야 한다. JVM 입장에서 이 객체는 필요한 객체일까? 아니다, `main` 을 호출할 수 있기만 하면 된다. `static` 으로 선언함으로서 JVM 은 불필요한 객체를 생성할 필요가 없고, 메모리를 절약할 수 있다.

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

JNI 가 false 인 경우는 언제일까?

%% 내용 추가 %%

```c
// main 메소드의 아이디를 찾는다.
mainID = (*env)->GetStaticMethodID(env, mainClass, "main", "([Ljava/lang/String;)V");
```

말 그대로 JVM 은 running 시점에 `main` 이라는 이름을 찾아 실행시키는 것이다.

### args

`main()` 에는 `main(String[] args)` 라는 arguments 가 포함되어 있다.

### System.out.println

#native #JNI

드디어 출력과 관련된 메서드에 대해 이야기를 시작할 수 있다.

_굳이 다시 언급하자면, Python 은 `print("Hello World")` 였다. [생활코딩 파이썬](https://www.opentutorials.org/course/4769)

자바 프로그램은 OS 에서 바로 실행되는 것이 아니라 JVM 이라는 가상 머신 위에서 실행된다. 따라서 OS 에 직접 접근하는 방법은 꽤나 까다롭다. Java 로 CLI 를 만들거나 OS 메트릭을 수집하는 등의 시스템 레벨의 코딩이 어렵다고 하는 이유일 것이다.

하지만 제한적이나마 OS 기능을 빌려쓸 수 있는데, 이 기능을 제공하는 것이 바로 `System` 이다. 대표적인 기능은 아래와 같은 것들이 있다.

- 표준 입력
- **표준 출력**
- 환경변수 설정
- 수행 중인 응용프로그램 종료하고 status 코드를 반환

`Hello World` 를 출력하기 위해 바로 이 표준 출력 기능을 빌려 사용하는 것이다.

### String

#constant-pool #intern

Java 에서 문자열은 조금 특별하다. 아니, 많이 특별한 것 같다(footnote: https://www3.ntu.edu.sg/home/ehchua/programming/java/J3d_String.html). 메모리 레벨에서 별도의 공간을 할당 받을 정도니 분명히 특별취급을 받고 있다. 왜 그럴까?

```java
String greeting = "Hello World";
```

```java
String greeting = new String("Hello World");
```

![](https://i.imgur.com/pN25lbX.png)

문자열 동작 원리 작성, 힙 영역의 차이를 그림으로 그리기

힙 영역에 대해서는 이후 다시 살펴본다.

문자열은 String Constant Pool 이라는 영역에 생성된다. 이후 같은 문자열을 생성하면, String Constant Pool 에 먼저 존재하는지 확인한 후, 없으면 새로 생성하고 이미 존재한다면 기존 문자열을 그대로 사용한다. 이 String Constant Pool 은 Heap 영역에 존재하는데, 덕분에 더 이상 참조되지 않는 문자열을 GC 를 통해 제거할 수 있다.

### 정리

이번 챕터를 통해 다음과 같은 질문에 대답해봤다.

- 왜 `.java` 파일과 class 이름이 같아야할까?
- 왜 `public static void main(String[] args)` 이어야 할까?
- 출력 원리
- 문자열 동작 원리

---

## Chapter 2. Compile & Decompile

Java 를 컴파일 할 경우 어떤 형태로 생성되는지 확인해보자.

### Compile

Java 코드는 컴퓨터가 읽고 해석할 수 없다. Java 애플리케이션의 실행을 위해서는 컴퓨터가 읽고 해석할 수 있는 형태로 변환해줘야하는데, 이를 위해 아래와 같은 과정을 거치게 된다.

```
.java -> .class -> interpreting -> execution
```

`.class` 파일로 만들고 그걸 해석하는 과정이 있어야 비로소 Java 를 실행할 수 있는 것이다. `.java` 파일을 클래스 파일로 만들어보자. 아래 명령어를 사용할 수 있다.

```bash
$ javac VerboseLanguage.java
```

![](https://i.imgur.com/xPMY0Ib.png)

클래스 파일이 생성된 것을 확인할 수 있다. `java` 명령어를 사용해서 클래스 파일을 실행시킬 수 있고, 이때 확장자는 명시하지 않아야 한다.

```bash
$ java VerboseLanguage
// Hello World
```

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

---

## Chapter 3. Java 를 실행하는 JVM

- [[Java Virtual Machine]]
- [[JNI]]
- Hello World 가 어떤 메모리 영역과 상호작용하게 되는지
- JVM 메모리 적재 과정

앞선 챕터에서 Java 의 기본적인 규칙이 정의된 이유에 대해 대략적으로 들여다봤다. 이번 챕터에서는 JVM 이 실행되면서 'Hello World' 코드 블록을 어떻게 동작시키는지 살펴본다.

JVM 이 실행되면 `main` 메서드를 찾는다. 찾은 메서드를 Method Area 에 적재한 뒤 call 하여 호출

### Class Loader

Java 의 클래스들이 언제, 어디서, 어떻게 메모리에 올라가고 초기화가 일어나는지 알기 위해서는 우선 JVM **클래스 로더(Class Loader)** 에 대해 살펴볼 필요가 있다.

클래스 로더는 컴파일된 자바의 클래스 파일(.class)을 동적으로 로드하고, JVM 의 메모리 영역인 Runtime Data Area 에 배치하는 작업을 수행한다.

클래스 로더에서 class 파일을 로딩하는 순서는 다음과 같이 3단계로 구성된다.

1. Loading: 클래스 파일을 가져와서 **JVM 의 메모리에 로드**한다.
2. Linking: 클래스 파일을 사용하기 위해 **검증**하는 과정이다.
3. Initialization: 클래스 파일을 적절한 값으로 **초기화**한다.

유의할 점은, 클래스 파일은 한 번에 메모리에 올라가는 것이 아니라 **애플리케이션에서 필요할 경우 동적으로 메모리에 적재**된다는 점이다.

많이들 착각하는 부분은 클래스나 클래스에 포함된 static 멤버들이 메모리에 올라가는 시점이다. 소스를 실행하자마자 메모리에 모두 올라가는줄 착각하는데, 언제 어디서 사용될지 모르는 static 멤버들을 시작 시점에 모두 메모리에 올려놓는다는 것은 비효율적이다. 클래스 내의 멤버를 호출하게 되면 그제서야 클래스가 동적으로 메모리에 로드된다.

verbose 옵션을 사용하면 메모리에 올라가는 동작과정을 엿볼 수 있다.

```bash
java -verbose:class VerboseLanguage
```

![](https://i.imgur.com/4suH8mS.png)

'Hello World' 가 출력되기 전에 `VerboseLanguage` 클래스가 먼저 로드되는걸 확인할 수 있다.

> [!NOTE] 버전 별로 약간의 차이가 있다.
> Java 1.8 과 Java 21 은 컴파일 결과물부터 로그 출력 포맷도 다르다. 버전이 올라감에 따라 최적화가 많이 이루어지고 컴파일러 동작도 약간씩 변하므로, 버전을 잘 확인하자. 이 글에서는 Java21 을 기본으로 사용하고 다른 버전의 경우 별도로 명시한다.

### Runtime Data Area

Runtime Data Area 는 프로그램이 동작하는 동안 데이터들이 저장되는 공간이다. 크게는 Shared Data Area 와 Per-thread Data Area 로 나누어진다.

#### Shared Data Areas

JVM 에는 JVM 안에서 동작하는 여러 스레드 간 데이터를 공유할 수 있는 여러 영역이 존재한다. 따라서 다양한 스레드가 이러한 영역 중 하나에 동시에 접근할 수 있다.

##### Heap

> `VerboseLanguage` 클래스가 로드되는 곳

Heap 영역은 모든 자바 객체 혹은 배열이 생성될 때 할당되는 영역이다. JVM 이 실행되는 순간에 만들어지고 JVM 이 종료될 때 함께 사라진다.

자바 스펙에 따라서, 이 공간은 자동으로 관리되어져야 한다. 이 역할은 [[Garbage Collection|GC]] 라고 알려진 도구에 의해 수행된다.

Heap 사이즈에 대한 제약은 JVM 명세에 존재하지 않는다. 메모리 처리도 JVM 구현에 맡겨져 있다. 그럼에도 불구하고 Garbage Collector 가 새로운 객체를 생성하기에 충분한 공간을 확보하지 못한다면 JVM 은 OutOfMemory 에러를 발생시킨다.

##### Method Area

Method Area 는 클래스 및 인터페이스 정의를 저장하는 공유 데이터 영역이다. Heap 과 마찬가지로 JVM 이 시작될 때 생성되며 JVM 이 종료될 때만 소멸된다.

전역 변수와 static 변수는 이 영역에 저장되므로 프로그램이 시작부터 종료될 때까지 어디서든 사용이 가능한 이유가 된다.

구체적으로는 클래스 로더는 클래스의 바이트코드(.class)를 로드하여 JVM 에 전달하는데, JVM 은 객체를 생성하고 메서드를 호출하는 데 사용되는 클래스의 내부 표현을 런타임에 생성한다. 이 내부 표현은 클래스 및 인터페이스에 대한 필드, 메서드, 생성자에 대한 정보를 수집한다.

사실 Method Area 는 JVM 명세에 따르면 구체적으로 '이래야 한다' 는 명확한 정의가 없는 영역이다. **논리적 영역**이며, 구현에 따라서 힙의 일부로 존재할 수도 있다. 간단한 구현에서는 힙의 일부이면서도 GC 나 압축이 발생하지 않도록 할 수도 있다.

##### Run-Time Constant Pool

Run-Time Constant Pool 은 Method Area 의 일부로 클래스 및 인터페이스 이름, 필드 이름, 메서드 이름에 대한 심볼릭 참조를 포함한다. JVM 은 Run-Time Constant Pool 을 통해 실제 메모리상 주소를 찾아서 참조할 수 있다.

##### String Constant Pool

> "Hello World" 문자열이 저장되는 곳

앞 문단에서 Run-Time Constant Pool 이 Method Area 에 속한다고 했었다. Heap 에도 Constant Pool 이 하나 존재하는데 바로 String Constant Pool 이다.

이전, String 을 설명하며 Heap 을 잠깐 언급했다. `new String("Hello World")` 을 사용하여 문자열을 생성할 경우, 문자열을 객체로 다루게 되므로 Heap 영역에서 관리된다.

```java
String s1 = "Hello World";
String s2 = new String("Hello World");
```

```
0: ldc           #7                  // String Hello World
2: astore_1
3: new           #9                  // class java/lang/String
6: dup
7: ldc           #7                  // String Hello World
9: invokespecial #11                 // Method java/lang/String."<init>":(Ljava/lang/String;)V
12: astore_2
13: return
```

바이트코드를 확인해보면 invokespecial 을 통해 문자열이 heap 영역에 '생성' 되는걸 확인할 수 있다.

invokespecial 은 객체 초기화 메서드가 직접 호출된다는걸 의미한다.

왜 Method Area 에 존재하는 Run-Time Constant Pool 과는 달리 String Constant Pool 은 Heap 에 존재할까? 문자열은 굉장히 큰 객체에 속한다. 또한 얼마나 생성될지 알기 어렵기 때문에, 메모리 공간을 효율적으로 사용하기 위해서는 사용되지 않는 문자열을 정리하는 과정이 필요하다. 즉, Heap 영역에 존재하는 GC 가 필요하다는 의미다.

문자열은 불변으로 관리된다. 수정은 허용되지 않으며, 항상 새롭게 생성된다. 이미 생성된 적이 있다면 재활용함으로써 메모리 공간을 절약한다. 하지만 참조되지 않는 문자열이 생길 수 있으며, 애플리케이션의 생명 주기동안 계속해서 쌓여갈 것이다. 메모리를 효율적으로 활용하기 위해 참조되지 않는(unreachable) 문자열을 정리할 필요가 있고, 이 말은 GC 가 필요하다는 말과 동일하다. 결국 String Constant Pool 은 Heap 영역에 존재하는게 자연스러운 것이다.

문자열은 특성상 어디까지 커질지 가늠하기가 불가능하다. 스택에 저장한다면 공간을 찾기 힘들어서 문자열 선언 자체가 실패할 수 있다.

문자열 비교 연산은 길이가 N 이라면 완벽하게 일치하기 위한 판단에 N 번의 연산이 필요하다. 반면 풀을 사용한다면, equals 비교로 ref 체크만 하면 되므로 $O(1)$ 의 비용이 든다.

1. 숫자들은 최댓값이 제한되어 있는 반면에 문자열은 그 특성상 최대 크기를 고정하기 애매하다.
2. 매우 커질 수 있고, 생성 이후 자주 사용될 가능성이 다른 타입에 비해 높다
3. 자연스럽게 메모리 효율성이 높을 것이 요구된다. 그러면서도 사용성을 높이기 위해 전역적으로 참조될 수 있어야 한다.
4. Per-Thread Date Area 중 Stack 에 있을 경우는 다른 스레드에서 재활용할 수 없고, 크기가 크면 할당 공간을 찾기 어렵다
5. Shared Date Area 에 있는게 합리적 + Heap 에 있어야 하지만 JVM 레벨에서 불변으로 다뤄야하므로 전용 Constant Pool 을 Heap 내부에 별도로 생성하여 관리하게 되었다

- ? `new String("Hello World)"` 로 생성자 호출로 문자열을 생성한다면 String Constant Pool 을 사용하지 않는 것일까?

"Hello World" 라는 문자열을 선언한 시점에 바로 String Constant Pool 에 생성된다. new 키워드를 호출하면 Heap 영역에 객체가 생성되며 String Constant Pool 에 존재하는 "Hello World" 문자열의 주소를 참조하게 된다?

#### Per-thread Data Areas

Shared Data Area 외에도 JVM 은 개별 스레드 별로 데이터를 관리한다. **JVM 은 실제로 꽤 많은 스레드의 동시 실행을 지원**한다.

##### PC Register

각 JVM 스레드는 PC(program counter) register 를 가진다.

PC register 는 CPU 가 명령(instruction)을 이어서 실행시킬 수 있도록 현재 명령어가 어디까지 실행되었는지를 저장한다. 또한 다음으로 실행되어야할 위치(메모리 주소)를 가지고 명령 실행이 최적화될 수 있도록 돕는다.

PC 의 동작은 메서드의 특성에 따라 달라진다.

- non-native method 라면, PC register 는 현재 실행 중인 명령의 주소를 저장한다.
- native method 라면, PC register 는 undefined 를 가진다.

PC register 의 수명 주기는 기본적으로 스레드의 수명주기와 같다.

##### JVM Stack

각 JVM 스레드는 독립된 스택을 가집니다. JVM 스택은 메서드 호출 정보를 저장하는 데이터 구조입니다. 각 메서드가 호출될 때마다 스택에 메서드의 지역 변수와 반환 값의 주소를 가지고 있는 새로운 프레임이 생성됩니다. 이 프레임들은 Heap 에 저장될 수 있습니다.

- ? 힙에 저장될 수 있지만 공유되지는 않는가?

JVM 스택 덕분에 JVM 은 프로그램 실행을 추적하고 필요에 따라 스택 추적을 기록할 수 있습니다. = stack trace

JVM 구현에 따라 스택의 메모리 사이즈와 할당이 결정될 수 있습니다. = 구현이 항상 같진 않다는 뜻

JVM 의 메모리 할당 에러는 stack overflow error 를 수반할 수 있습니다. 그러나 만약 JVM 구현이 JVM 스택 사이즈의 동적 확장을 허락한다면, 그리고 만약 메모리 에러가 확장 도중에 발생한다면 JVM 은 OutOfMemory 에러를 던질 수 있습니다.

스레드마다 분리된 stack 영역을 갖는다. Stack 은 호출되는 메서드 실행을 위해 해당 메서드를 담고 있는 역할을 한다. 메서드가 호출되면 새로운 Frame 이 Stack 에 생성된다. 이 Frame 은 LIFO 로 처리되며, 메서드 실행이 완료되면 제거된다.

##### Native Method Stack

Native Method 는 자바가 아닌 다른 언어로 작성된 메서드를 말한다. 이 메서드들은 바이트코드로 컴파일될 수 없기 때문에(Java 가 아니므로 javac 를 사용할 수 없다), 별도의 메모리 영역이 필요하다.

Native Method Stack 은 JVM Stack 과 매우 유사하지만 오직 native method 전용이다.

Native Method Stack 의 목적은 native method 의 실행을 추적하는 것이다.

JVM 구현은 Native Method Stack 의 사이즈와 메모리 블록을 어떻게 조작할 것인지를 자체적으로 결정할 수 있다.

JVM Stack 의 경우, Native Method Stack 에서 발생한 메모리 할당에러의 경우 스택오버플로우 에러가 됩니다. 반면에 Native Method Stack 의 사이즈를 늘리려는 시도가 실패한 경우 OutOfMemory 에러가 된다.

결론적으로 JVM 구현은 Native Method 호출을 지원하지 않기로 결정할 수 있고, 이러한 구현은 Netive Method Stack 이 필요하지 않다는 점을 강조한다.

### Execution Engine

로딩과 저장하는 단계가 끝나고 나면 JVM 은 마지막 단계로 Class File 을 실행시킨다. 다음과 같은 세 가지 요소로 구성된다.

- Interpreter
- JIT Compiler
- Garbage Collector

#### Interpreter

프로그램을 시작하면 Interpreter 는 Bytecode 를 한 줄씩 읽어가며 기계가 이해할 수 있도록 변환한다.

일반적으로 Interpreter 의 속도는 느린 편인데, 모든 코드를 한 줄씩 읽어야 하기 때문이고 반복적인 작업에 대한 최적화가 어렵기 때문이다.

#### JIT Compiler

Just In Time Compiler 는 Interpreter 의 단점을 극복하기 위해 도입되었다. (언제?)

#### Garbage Collector

별개의 문서로 다뤄야할만큼 매우 중요한 컴포넌트다.

## Chapter 4. Java Native Interface

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
