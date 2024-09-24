---
title: Memory repository
date: 2022-09-08 09:49:00 +0900
aliases: null
tags:
  - java
  - library
  - memory
categories: null
updated: 2023-08-19 12:38:12 +0900
---

## Motivation

[[Spring Batch]] 를 사용하면서 아쉬웠던 점은 Step 간 데이터를 원활하게 공유하기 위한 일종의 상태 저장소가 없다는 것이다. 물론 ExecutionContext 라는 데이터 공유 방법이 있지만, 데이터는 직렬화 되어 전달되며 최대 2500자까지만 가능하기 때문에 대량의 데이터를 전달하는 것에는 적합하지 않고, 거대한 비즈니스 처리 단위가 아닌 별개의 작업 집합이라는 스프링 배치의 철학에도 부합하지 않는다.

따라서 부득이하게 배치 과정에서 대량의 데이터를 다음 step 에 전달해야할 경우, 어디에 저장해놔야할 것인가에 대한 고민이 필연적으로 생길 수밖에 없다. 예를 들면 다음과 같은 경우가 있겠다.

1. A step 에서 A entity 를 처리하게끔 설계하였다. 하지만 A entity 의 처리를 위해서는 B entity 가 필요하다.
2. A step 에 구성된 reader 는 A entity reader 이므로 B entity reader 를 구성하기 위해 B step 를 구현하였다.
3. 이제 Job 은 B step -> A step 순서로 실행된다. 하지만 B step 에서 읽어온 B entity 를 A step 에서 사용할 수 있을까?

Step 은 하나의 작업 단위이기 때문에 writer 를 통해 어딘가로 출력이 전달되면, 다음 Step 에서 해당 출력을 다시 입력으로 가져와야한다는 것이다. 이 입출력을 처리하기 위해 메모리에 저장하는 방식을 택했고, 사용이 쉽고 대체가 간편하도록 JPA 의 method naming 을 오마주하여 구현하게 되었다.

## Architecture

TODO hierachy image

```
MemoryRepository
|
+-- 
```

## 장점 및 단점

- 간단하게 사용이 가능하다. read only 로 구현하였으며, thread-safe 하기 때문에 멀티 쓰레드에서도 안전하다.
- JPA 의 naming convention 을 참고하였기 때문에 모든 method 는 예상하는대로 동작한다.
- in-memory 기반이기 때문에 재실행할 경우 offset 을 알 수 없고, 다시 memory 로 불러오는 작업을 거쳐야 한다. 만약 memory 에 저장해야하는 데이터가 부담스러울 정도로 클 경우는 [[Redis]] 같은 외부 memory 기반 저장소를 사용하는 것이 좋다.

## Getting started

릴리즈되었기 때문에 maven 또는 gradle 에서 의존성 추가로 사용이 가능하다.

```gradle
repositories {
    mavenCentral()
    maven { url "https://jitpack.io" }
}
dependencies {
    implementation 'com.github.next-operation:memory-repository:<version>'
}
```

## 개발 회고

### Naming 의 중요성

처음 이 프로젝트를 만들 때 `MemoryRepository` 는 추상 클래스여야 쉽게 의미를 이해하고 사용할 수 있을 것이라 생각했다. 이미 MemoryRepository 라는 이름도 충분히 길다고 생각했기 때문에 접두사를 붙여서 구체적인 설명을 하는 것에 부담을 느꼈기 때문이기도 하다. 하지만 이 생각은 오래가지 못하고 금방 후회로 변했는데, MemoryRepository 에서 사용하는 map 을 concurrent 이외의 것을 추가하려고 하는 순간이였다. class 이름을 바꾸려면 하위 호환성을 포기해야 했기 때문이다.

`MemoryRepository` 는 `interface` 여야 했던 것이다. 그리고 기존 `MemoryRepository` 는 multi-thread 환경을 고려하여 concurrentHashMap 을 사용했기 때문에 이름을 `ConcurrentMemoryRepository` 로 정했어야 했다. 이 소스를 사용하는 사람은 팀원밖에 없었기 때문에 비교적 큰 비용없이도 설계를 수정할 수 있었지만, 큰 프로젝트일수록 이런 점은 주의해야 하겠다.

## Conclusion

이 프로젝트는 사내에서 쓰려고 만든 매우 간단한 프로젝트에 불과했지만, 한번이라도 오픈소스로 릴리즈해보는 좋은 경험을 해볼 수 있었고 소스를 공개하지 않고 개발할 때 고려해야할 점과는 전혀 다른 부분을 알 수 있었다.

## Reference

- [docs.spring](https://docs.spring.io/spring-batch/docs/current/reference/html/common-patterns.html#passingDataToFutureSteps)
- [Github](https://github.com/next-operation/memory-repository)
