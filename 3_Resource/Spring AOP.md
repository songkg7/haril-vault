---
title: Spring AOP
date: 2022-08-16T17:05:00
publish: false
aliases: 
tags:
  - aop
  - aspect
  - spring
categories: Spring
updated: 2025-01-07T00:35
---

[[Spring framework|Spring]]

# Overview

> [!info] AOP?
> Aspect-Oriented Programming

특정 코드마다 필요한 비즈니스 로직이 있다고 할 때 필연적으로 반복적인 작업이 발생한다. AOP 는 이런 요구사항을 코드의 중복없이 해결하는 것에 중점을 두고 있다.

서로 다른 클래스라고 하더라도 비슷한 기능을 하는 부분이 있다. 이런 부분을 `Concern` 이라고 한다.

![[aspect.png]]

이 때 만약 노란색 기능을 수정해야한다면, 각각 클래스의 노란 부분마다 수정해주어야 하기 때문에 유지보수면에서 불리하다.

이것을 해결하기 위한 방법론이 AOP 이다.

흩어진 기능들을 모을 때 사용하는 것이 Aspect 이다. 각각 Concern 별로 Aspect 를 만들어주고, 어느 클래스에서 사용하는지 입력해주는 방식이다. 아래의 그림이 Aspect 로 모듈화한 것을 보여주고 있다.

![[aspect module.png]]

각 모듈에는 `Advice` 와 `PointCut`이 들어있다.

`Advice`란 해야할 일, 기능을 나타내는 것이다. `PointCut` 이란 어디에 적용해야하는지를 나타내는 것이다.

`Target`이란 개념도 있는데 적용이 되는 대상을 뜻하는 용어이다.

`Join point`라는 용어는 코드가 끼어드는 지점을 뜻한다. (ex. 메서드를 실행할 때, 필드에서 값을 가져갈 때 등)

# AOP 적용 방법

만약 Class A 에 Perf라는 메서드가 있고, Hello 라는 Aspect 가 있고, Class A 의 Perf 메서드가 실행되기 전에 항상 Hello 를 출력해야한다고 가정한다.

## 1. 컴파일 타임

AspectJ 사용

자바 파일을 클래스파일로 만들 때, 바이트 코드들을 조작하여 조작된 코드들을 생성한다. 즉, `A.java` 파일이 `A.class` 파일로 변환될 때 `A.class` 파일에 Hello 를 출력하는 메서드가 포함되어 있어야 한다.

## 2. 로드 타임

`A.java`는 순수하게 `A.class` 로 컴파일되었지만, `A.class` 를 로딩하는 시점에 Hello 를 출력하는 메서드를 끼워넣는 방법이다.

즉, A의 바이트코드는 변함이 없지만 로딩하는 JVM 메모리 상에서는 Perf 라는 메서드 전에 Hello 를 출력하는 메서드가 같이 포함된 상태로 로딩이 되는 것이다.

## 3. 런타임

> Spring AOP 가 사용하는 방법

A라는 Bean(Class A) 를 만들 때 A 라는 타입의 프록시 Bean 을 만든다. 이 프록시 Bean 이 실제 A 가 가지고 있는 Perf 라는 메서드를 호출하기 직전에 Hello 를 출력하는 일을 하고, 그 다음에 A 를 호출한다.
