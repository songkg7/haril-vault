---
title: Reactive API
date: 2022-08-21 12:51:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-21
aliases: null
tags:
  - reactive
  - library
categories: null
updated: 2023-08-19 12:38:02 +0900
---

Reactive streams 은 컴포넌트 상호 작용에서 중요한 역할은 한다. 하지만 이건 라이브러리와 기반 구조에 사용되는 컴포넌트엔 유용해도, 애플리케이션 API 에서 다루기엔 너무 저수준이다. 애플리케이션은 비동기 로직을 만들기 위한 풍부한 고수준 함수형 API 가 필요하다(Java 8 Stream API 와 비슷하지만 컬렉션만을 위한게 아니다). 이게 바로 Reactive library 가 하는 일이다.

Reactor 는 [[Spring WebFlux]]가 선택한 리액티브 라이브러리다. 리액터는 `Mono` 와 `Flux` API 타입을 제공한다. ReactiveX vocabulary of operators 에 정리된 풍부한 연산자를 사용해 데이터 시퀀스를 0~1개는 `Mono`, 0~N개는 `Flux` 로 표현할 수 있다. 리액터는 리액티브 스트림 라이브러리이기 때문에 모든 연산자는 Non-blocking back pressure 를 지원한다. 리액터는 특히 servier-side java 에 초점을 두고 스프링과 긴밀히 협력해서 개발됐다.

Webflux 는 리액터를 핵심 라이브러리로 사용하지만, 다른 리액티브 라이브러리를 써도 리액티브 스트림으로 상호 작용할 수 있다. Webflux API 의 일반적인 룰은, 순수한 publisher 를 입력으로 받아 내부적으로 리액터 타입으로 맞추고, 이걸 사용하여 `Flux`나 `Mono`를 반환한다. 따라서 어떤 Publisher 든 입력으로 전달하고 연산할 수 있지만, 다른 리액티브 라이브러리를 사용하려면 출력 형식을 맞춰줘야 한다. Webflux 는 가능만 하다면(e.g. 어노테이션을 선언한 컨트롤러) 투명한 방식으로 RxJava 나 다른 리액티브 라이브러리에 맞게 바꿔준다.

## Reference

- [언제 어떤 operator 를 써야할까?](https://luvstudy.tistory.com/m/100)

## Links

- [[Reactive 에 대해]]
- [[Mono 와 Flux]]
