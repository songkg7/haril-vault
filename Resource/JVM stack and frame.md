---
title: JVM stack and frame
date: 2023-08-08 16:20:00 +0900
aliases: 
tags: jvm, stack
categories: 
updated: 2023-12-07 15:43:44 +0900
---

## JVM Stack

- 기본 크기는 운영체제에 따라 다르지만 약 1MB

각 [[Java Virtual Machine|JVM]] 스레드는 독립된 스택을 가집니다. JVM 스택은 메서드 호출 정보를 저장하는 데이터 구조입니다. 각 메서드가 호출될 때마다 스택에 메서드의 지역 변수와 반환 값의 주소를 가지고 있는 새로운 프레임이 생성됩니다. 이 프레임들은 Heap 에 저장될 수 있습니다.

- ? 힙에 저장될 수 있지만 공유되지는 않는가?

JVM 스택 덕분에 JVM 은 프로그램 실행을 추적하고 필요에 따라 스택 추적을 기록할 수 있습니다. = stack trace

JVM 구현에 따라 스택의 메모리 사이즈와 할당이 결정될 수 있습니다. = 구현이 항상 같진 않다는 뜻

JVM 의 메모리 할당 에러는 stack overflow error 를 수반할 수 있습니다. 그러나 만약 JVM 구현이 JVM 스택 사이즈의 동적 확장을 허락한다면, 그리고 만약 메모리 에러가 확장 도중에 발생한다면 JVM 은 OutOfMemory 에러를 던질 수 있습니다.

스레드마다 분리된 stack 영역을 갖는다. Stack 은 호출되는 메서드 실행을 위해 해당 메서드를 담고 있는 역할을 한다. 메서드가 호출되면 새로운 Frame 이 Stack 에 생성된다. 이 Frame 은 LIFO 로 처리되며, 메서드 실행이 완료되면 제거된다.

### Frame

프레임은 다음의 3가지로 구성되어 있다.

- Local Variable
- Operand Stack
- Constant Pool Reference

#### Local Variables

로컬 변수 배열은 메서드의 지역 변수들을 갖는다.

```java
class Test {
    public int hello(int a, double b, String c) {
        return 0;
    }
}
```

프레임의 로컬 변수 배열은 다음과 같이 만들어진다.

```ascii-art
  +-----------+
0 | reference | this (hidden)
  +-----------+
1 | int       | int a
  +-----------+
2 |           | double b
  + double    +
3 |           |
  +-----------+
4 | reference | String c
  +-----------+
```

- reference 는 heap 의 레퍼런스를 의미한다
- primitive 타입은 값을 그냥 프레임에 저장한다
    - 그래서 int 나, double 이 Integer, Double 보다 조금 더 빠르다
- double, long 은 두 칸씩 차지한다

#### Operand Stack

오퍼랜드 스택은 메서드 내 계산을 위한 작업 공간이다. 어셈블리어나 아희, 브레인퍽 같은 언어를 다뤄봤다면 어렵지 않게 이해할 수 있다.

예를 들어 다음과 같은 `4 + 3` 을 계산하는 자바 코드를 작성했다고 치자.

%% 링크 참조 %%

#### Constant Pool Reference

프레임은 런타임 상수 풀의 참조를 갖는다. 코드의 동적 링크를 지원하기 위해

`idc`

## Reference

- https://johngrib.github.io/wiki/jvm-stack/
- https://www.baeldung.com/jvm-configure-stack-sizes