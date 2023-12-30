---
title: "WebFlux with Cache"
date: 2023-06-20 16:31:00 +0900
aliases: 
tags: 
categories: 
updated: 2023-06-20 21:06:43 +0900
---

Spring MVC 에서 자주 사용되는 `@Cacheable` 은 [[Spring WebFlux|WebFlux]] 에서는 제대로 동작하지 않는다.

```java
@Cacheable
public Flux<Item> getItems() {

}
```

필요한 내부 데이터가 아닌 구조적 조립체인 Flux 만 캐시되기 때문이다.

[[Reactor]] 는 이 문제의 해결방법이 이미 내장되어 있다. `@Cacheable` 을 통해 wrapper object 를 캐시하고, 빌트인 캐시를 활성화시킴으로써 실제 데이터의 참조를 생성할 수 있다.

```java
cache()
```

이 방법은 캐시의 캐시를 사용하고 있으므로, 캐시가 만료될 때 문제가 발생할 수 있다. 사용하는 두 종류의 캐시 모두에게 적절한 만료 정책을 설정해주는게 안전하다. 일반적으로는 Reactor 의 캐시 만료 시간을 `@Cacheable` 보다 길게 주는게 권장된다.

cold 와 hot 에 대한 이해가 필요하다.

## Reference

- [Spring WebFlux Cacheable](https://www.baeldung.com/spring-webflux-cacheable)
