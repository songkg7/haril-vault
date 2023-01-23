---
title: "Interface 란 무엇인가?"
date: 2023-01-22 21:09:00 +0900
aliases: 
tags: [java, interface, architecture, oop]
categories: 
---

어느 날, 이런 질문을 받았습니다.

_객체지향을 잘 디자인하려면 클래스와 인터페이스의 관계를 잘 정의하라는데, 인터페이스는 무엇인가요?_

이번 글에서는 이 질문에 대한 답을 나름대로 내려보고자 합니다.

## What is interface?

[[Java]] 에서 interface 는 다음과 같은 class 를 표현합니다.

1. new 키워드를 통해 인스턴스화 될 수 없다.
2. 모든 멤버 메서드는 public abstract 이기 때문에 sub class 에서의 구현을 강제한다.
3. 상수를 포함할 수 있다.

좁은 의미에서만 본다면 이게 가장 정확한 설명일 것 입니다.

하지만 객체지향 관점에서 인터페이스는 **추상화** 라는 큰 임무를 가지고 있습니다. 그럼 우선 추상화가 뭔지 알아야 합니다.

## Abstraction

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

반드시 A = B 가 반드시 참인 경우에만 사용해야 하며, 그렇지 않은 경우가 있다면 interface 를 우선적으로 사용해야 한다.

class 를 이용하여 상속을 하는 것은 계층의 표현에 유리하다. 펭귄은 조류임에 틀림없다. 하지만 날 수 있는 기능적 측면은 조류가 아니여도 된다. 예를 들면 박쥐는 조류가 아니지만 날 수 있으며 비행기는 생물조차 아니지만 날 수 있다. 이런 기능 요소는 클래스의 계층 요소와는 상관이 없으므로 interface 를 통해 추상화를 설계해야 한다. 박쥐에게 날 수 있는 기능을 추가하기 위해 Bird 를 상속해야한다면 매우 어색할 것이다.

```java
public class Bat extends Bird { // 박쥐는 새인가?
	@Override
	public void flying() { 
		System.out.println("Bat can flying!");
	}
}
```

Relationship 을 잘못 정의한 것이라고 볼 수 있다.

```java
public class Penguin extends Bird { // 펭귄은 새이다. 하지만... 
	@Override
	public void flying() { 
		throw new UnsupportedOperationException();
		// 펭귄은 날 수 없으므로 flying 가 호출되어도 동작하지 않도록 해야한다.
		// 하지만 client 측면에서는 penguin.flying() 를 호출할 수 있는 것 자체가 이미 충분히 어색하다.
	}

	public void swimming() {
		System.out.println("Penguin can swimming!");
	}
}
```

만약 Bird 라는 abstract class 를 구현해서 상속의 방식으로 설계한다면 펭귄은 새지만 날 수 없기 때문에 fly method 를 갖고는 있지만 호출되면 안되는 아이러니한 상황이 만들어진다. 이러한 인지부조화는 개발자에게 혼란을 주며 대표적으로 `Stack` 이 `Vector` 를 상속함으로써 이러한 문제를 갖고 있다.

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
public class Eagle extends Bird implements Flyable, Predator {

}
```

`Bird` 를 통해 Eagle 이 조류임을 표현하며 `Flyable` 을 통해 날 수 있는 기능을 가지고 있다는 것을 나타낸다. interface 는 다중구현이 가능하므로, 포식자임을 나타내기 위해 `Predator` 라는 interface 또한 구현할 수 있다.

#### 또 다른 예제

선박

컨테이너선, 전함, 항공모함, 요트

컨테이너선과 전함은 모두 선박으로서 바다를 항해할 수 있는 능력을 갖추고 있음. 이 중에 전함은 다른 배를 공격할 수 있는 능력 또한 갖추고 있음. 항공모함은 다른 배를 직접 공격할 수는 없지만, 다른 비행기를 싣고 다닐 수 있는 능력이 있으며 이 비행기가 다른 배를 공격할 수 있음. 

## Conclusion

결국 인터페이스는 어떤 비즈니스 로직에서 책임과 역할을 분리해내는 도구로써, 추상화에 핵심적인 역할을 맡고 있다고 할 수 있습니다.