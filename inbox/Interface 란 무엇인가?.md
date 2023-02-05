---
title: "Interface 란 무엇인가?"
date: 2023-01-22 21:09:00 +0900
aliases: 
tags: [java, interface, architecture, oop]
categories: 
---

## Overview

어느 날, 이런 질문을 받았습니다.

_객체지향을 잘 디자인하려면 클래스와 인터페이스의 관계를 잘 정의하라는데, 인터페이스는 무엇인가요?_

이번 글에서는 객체지향 프로그래밍에 대해 처음 배울 때를 떠올려보며 이 질문에 대한 답을 나름대로 내려보고자 합니다.

## What is interface?

[[Java]] 에서 interface 는 다음과 같은 class 를 표현합니다.

1. `new` 키워드를 통해 인스턴스화 될 수 없다.
2. 모든 멤버 메서드는 public abstract 이기 때문에 sub class 에서의 구현을 강제한다.
3. 상수를 포함할 수 있다.

좁은 의미에서만 본다면 이게 가장 정확한 설명일 것 입니다.

하지만 객체지향 관점에서 인터페이스는 **추상화** 라는 막중한 임무를 가지고 있습니다. 그럼 우선 추상화가 뭔지 알아야 합니다.

## 추상화(Abstraction)

예제 그림 추가

소프트웨어 관점에서의 추상화란 어떤 시스템이나 설계 내에서 핵심적인 부분을 분리해내는 것을 뜻한다. 토끼, 인간, 호랑이의 공통점이 무엇일까? 포유류라는 점이다. 그렇다면 우리는 3가지의 서로 다른 동물을 포유류라는 하나의 집단 안에서 구현할 수 있다. 이때 포유류 라는 개념처럼 공통된 속성을 정의하는 과정을 추상화라고 부른다.

자바에서 추상화를 위한 도구로는 `abstract class` 와 `interface` 가 있지만, 대부분의 상황에서 `interface` 로 구현 가능한지를 먼저 고민해보는 편이다.

## Example

### 객체지향적이지 못한 인터페이스 설계

```java
public abstract Bird {
	public void flying(){
		System.out.println("Can flying!");
	}
}
```

새는 날 수 있다.

얼핏 이 클래스는 참인듯 보입니다. 하지만 예외가 있으므로..

반드시 A = B 의 역도 반드시 참인 경우에만 사용해야 하며, 그렇지 않은 경우가 있다면 interface 를 우선적으로 사용해야 한다.

> 새는 날 수 있다. = 날 수 있는 것은 새이다. (X)

class 를 이용하여 상속을 하는 것은 계층의 표현에 유리하다. 펭귄은 조류임에 틀림없다. 하지만 날 수 있는 건 조류뿐만이 아니다. 예를 들면 박쥐는 조류가 아니지만 날 수 있으며 비행기는 생물조차 아니지만 날 수 있다. 이런 요소는 기능적 요소로서 클래스의 계층 요소와는 상관이 없으므로 interface 를 통해 추상화함으로써 설계해야 한다. 박쥐에게 날 수 있는 기능을 추가하기 위해 Bird 를 상속해야한다면 매우 어색할 것이다.

```java
public class Bat extends Bird { // 박쥐는 새인가?
	@Override
	public void flying() { 
		System.out.println("Bat can flying!");
	}
}
```

바로 이런 점을 **Relationship 을 잘못 정의한 것**이라고 볼 수 있겠다.

```java
public class Penguin extends Bird { // 펭귄은 새이다. 하지만... 
	@Override
	public void flying() { 
		throw new UnsupportedOperationException();
		// 펭귄은 날 수 없으므로 flying 가 호출되어도 동작하지 않도록 해야한다.
		// 하지만 client 측면에서는 penguin.flying() 을 호출할 수 있는 것 자체가 이미 충분히 어색하다.
	}

	public void swimming() {
		System.out.println("Penguin can swimming!");
	}
}
```

만약 Bird 라는 abstract class 를 구현해서 상속의 방식으로 설계한다면 펭귄은 조류라서 fly method 를 갖고는 있지만 날 수 없기 때문에 호출되면 안되는 아이러니한 상황이 만들어진다. 이러한 인지부조화는 개발자에게 혼란을 줄 수 있다. 대표적으로 `Stack` 이 `Vector` 를 상속함으로써 이러한 문제를 갖고 있다.

```java
package java.util;

public class Stack<E> extends Vector<E> {
...
}
```

### 객체지향적인 인터페이스 설계

#### Bird 를 잘 설계하려면...

```java
public interface Flyable {
	void flying();
}
```

```java
public interface Flyable {
	default void flying() {
		System.out.println("can flying!");
	}
}
```

```java
public class Bat implements Flyable {

}
```

```java
public class Eagle extends Bird implements Flyable {

}
```

`Bird` 를 통해 `Eagle` 이 조류임을 표현하며 `Flyable` 을 통해 날 수 있는 기능을 가지고 있다는 것을 나타낸다.

이러한 기능적 요소의 interface 분리는 또 다른 장점을 갖고 있는데 바로 다중구현이 가능하다는 점이다. 예를 들면 독수리가 포식자임을 나타내기 위해 `Predator` 라는 interface 를 추가로 구현할 수 있다.

```java
public class Eagle extends Bird implements Flyable, Predator {

}
```

이렇듯 기능의 확장에 유연하게 적용할 수 있다는 것이 인터페이스를 사용했을 때의 장점이다.

#### 또 다른 예제

다음 글은 좀 더 구체적으로 객체지향을 통해 구현하는 과정을 설명한다.

[[객체지향의 세계 - 바다]]

## Conclusion

결국 인터페이스는 어떤 비즈니스 로직에서 책임과 역할을 분리해내는 도구로써, 추상화를 통한 객체지향 프로그래밍의 핵심적인 역할을 맡고 있다고 할 수 있습니다.
