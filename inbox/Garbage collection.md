---
title: "Garbage collection"
date: 2022-12-21 10:12:00 +0900
aliases: 
tags: [gc, jvm, garbage-collection]
categories: 
---

## Overview

[[JVM]] 의 Garbage collection(이하 GC) 에 대해서 정리해봅니다.

## What is GC?

JVM 안에서는 공유되는 영역인 Heap 과 각각의 메서드 별로 할당되는 영역인 Stack 이 존재한다. 만약 Java 로 작성된 프로그램이 종료되지 않고 계속 실행된다면 메모리 안에 데이터가 쌓이기만 할 것이다. 이러한 문제를 GC 를 통해 해결한다.

어떻게 해결한다는 것일까? JVM 은 도달할 수 없는 객체(unreachable)을 GC 의 대상으로 설정한다. 어떤 객체가 도달할 수 없는 객체가 되는지는 다음 코드를 보면 이해할 수 있다.

```java
public class Main {
	public static void main(String[] args) {
		Person person = new Person("a", "곧 참조되지 않음");
		person = new Person("b", "참조가 유지됨.")
	}
}
```

최초로 person 을 초기화할 때 생성된 a 는 바로 다음 줄에서 person 에 b 가 재할당되며 도달할 수 없는 객체가 된다. 이제 a 는 다음 GC 가 일어날 때 메모리에서 해제되게 된다.

## Stop the world

![[the-world-jojo.gif]]
 _The World! - 죠죠의 기묘한 모험 중_

GC 을 실행하기 위해 JVM 이 애플리케이션 실행을 멈추는 것. stop the world 가 발생하면 GC 를 실행하는 쓰레드를 제외한 나머지는 모두 작업을 멈춘다. GC 작업을 완료한 이후에야 중단했던 작업을 다시 시작한다. 어떤 GC 알고리즘을 사용하더라도 stop the world 는 발생하며, 대개 GC 튜닝이란 stop the world 시간을 줄이는 것이다.

> [!WARNING] `System.gc()` 는 사용금지
> Java 는 프로그램 코드에서 메모리를 명시적으로 지정하여 해제하지 않는다. 가끔 명시적으로 해제하려고 해당 객체를 `null` 로 지정하는 것은 큰 문제가 되지 않으나, `System.gc()` 를 호출하는 것은 시스템의 성능에 매우 큰 영향을 끼치므로 절대로 사용하면 안된다. 그리고 `System.gc()` 는 실제로 GC 가 일어날 것이라는 보장을 해주지 않는다.

## GC 가 발생하는 2가지 영역

[[Java]] 에서는 개발자가 프로그램 코드로 메모리를 명시적으로 해제하지 않기 때문에 가비지 컬렉터(Garbage Collector)가 더 이상 필요없는 (쓰레기) 객체를 찾아 지우는 작업을 한다. 이 가비지 컬렉터는 두 가지 전제 조건 하에 만들어졌다.

- 대부분의 객체는 금방 접근 불가능 상태(unreachable) 이 된다.
- 오래된 객체에서 젊은 객체로의 참조는 아주 적게 존재한다.

이러한 가설을 **weak generational hypothesis** 라 한다. 이 가설의 장점을 최대한 살리기 위해서 HotSpot VM 에서는 크게 2개로 물리적 공간을 나누었다. 둘로 나눈 공간이 Young 영역과 Old 영역이다.

- Young 영역(Young Generation 영역): 새롭게 생성한 객체의 대부분이 여기에 위치한다. 대부분의 객체가 금방 접근 불가능한 상태가 되기 때문에 매우 많은 객체가 Young 영역에 생성되었다가 사라진다. 이 영역에서 객체가 사라질 때 Minor GC 가 발생한다고 말한다.
- Old 영역(Old Generation 영역): 접근 불가능 상태로 되지 않아 Young 영역에서 살아남은 객체가 여기로 복사된다. 대부분 Young 영역보다 크게 할당하며, 크기가 큰 만큼 Young 영역보다 GC 는 적게 발생한다. 이 영역에서 객체가 사라질 때 Major GC(혹은 Full GC)가 발생한다고 말한다.

---

Q. G1GC가 이후 버전에서는 디폴트, 앞선 CMS와 비교해서 어떤 장/단점이 있을까?

- 장점
    - g1gc는 scan 하는 도중 해당리전에 대한 compacting도 수행한다.
    - 별도의 STW 없이도 여유 메모리 공간을 압축하는 기능을 제공한다.
        - Compacting으로 STW 발생 시간 최소화
    - String Deduplication Optimize
    - 사이즈, 카운트 등 튜닝 가능성 존재
- 단점
    - Full GC 수행 시 Single Thread로 동작한다.
    - 작은 heap 공간을 가지는 애플리케이션에서는 빈번한 Full GC 발생 가능

## Reference

- [Naver D2](https://d2.naver.com/helloworld/1329)
- https://tecoble.techcourse.co.kr/post/2021-08-30-jvm-gc/
