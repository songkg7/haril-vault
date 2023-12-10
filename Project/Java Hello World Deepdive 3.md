---
title: Java 에서 Hello World 를 출력하기까지 3
date: 2023-12-08 14:34:00 +0900
aliases: 
tags:
  - java
  - jvm
categories: 
updated: 2023-12-10 12:49:35 +0900
---

## Chapter 3. Java 를 실행하는 JVM

- [[Java Virtual Machine]]
- [[Java Native Interface]]
- Hello World 가 어떤 메모리 영역과 상호작용하게 되는지
- JVM 메모리 적재 과정

앞선 챕터에서 Java 의 기본적인 규칙이 정의된 이유에 대해 대략적으로 들여다봤다. 이번 챕터에서는 JVM 이 실행되면서 'Hello World' 코드 블록을 어떻게 동작시키는지 살펴본다.

[[Java Virtual Machine|JVM]] 이 실행되면 `main` 메서드를 찾는다. 찾은 메서드를 Method Area 에 적재한 뒤 call 하여 호출

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

- intern() 의 기능(ch.3)
- 더 이상 intern 은 사용할 필요가 없다(ch.3)

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

## Conclusion

Java 는 분명 어려운 언어다.

면접을 보다보면 종종 이런 질문을 받는다.

_Java 에 대해서 얼마나 알고 계신다고 생각하시나요?_

이젠 좀 확실히 대답할 수 있을 것 같다.

_음... 🤔 Hello World 정도요._

![[Java Hello World Deepdive 1#Reference|Java 에서 Hello World 를 출력하기까지 1]]
