---
title: "Spring WebFlux"
date: 2022-08-21 11:52:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-21
aliases: 
tags: [spring, mvc, non-blocking, async, java, kotlin, reactive]
categories: Spring
---

## Overview

[[Spring framework|Spring]], [[Spring MVC]] 를 포함한 기존 웹 프레임워크는 서블릿 API 와 서블릿 컨테이너를 위해 개발됐다. 5.0 버전에 추가된 Spring WebFlux 는 리액티브 스택 웹 프레임워크다. 완전하게 `Non-blocking` 으로 동작하며, Reactive streams back pressure 를 지원하고, [[Netty]], Undertow, 서블릿 3.1+ 컨테이너 서버에서 실행된다.

두 웹 프레임워크 모두 소스 모듈 이름과 동일하며(spring-webmvc, spring-webflux), [[Spring framework|Spring]]에 공존한다. 원하는 모듈을 선택하면 된다. 둘 중 하나를 사용해 애플리케이션을 개발할 수 있고, 둘 다 사용할 수도 있다(예를 들어, 스프링 MVC 컨트롤러에서 리액티브 [[WebClient]]를 사용하는 식으로).

## Spring WebFlux 는 왜 만들었을까?

Webflux 가 탄생한 이유 중 하나는 적은 쓰레드로 동시 처리를 제어하고, 적은 하드웨어 리소스로 확장하기 위해 non-blocking 웹 스택이 필요했기 때문이다. 이전에도 서블릿 3.1 은 non-blocking I/O 를 위한 API 를 제공했다. 하지만 서블릿으로 non-blocking 을 구현하려면 다른 동기 처리(`filter`, `servlet`)나, blocking 방식(`getParameter`, `getPart`)을 쓰는 API 를 사용하기 어렵다. 이런 점 때문에 어떤 non-blocking 방식과도 잘 동작하는 새 공통 API 를 만들게 됐다. 이미 비동기 논블로킹 환경에서 자리를 잡은 서버(e.g. Netty) 때문에라도 새 API 가 필요했다.

또 다른 이유는 [[Functional programming]]이다. Java 5 에서의 어노테이션 등장으로 선택의 폭이 넓어진 것처럼, [[Java]] 8 에서 추가된 람다 표현식 덕분에 자바에서도 함수형 API 를 작성할 수 있게 됐다. 이 기능은 논블로킹 애플리케이션을 만들 때도 요긴하게 쓰이며, 이제는 Continuation-style API(CompletableFuture 와 ReactiveX 로 대중화된)로 비동기 로직을 선언적으로 작성할 수 있다. 프로그래밍 모델 관점에서 보면, Webflux 에서 어노테이션을 선언한 컨트롤러와 더불어 함수형 웹 Endpoint 를 사용할 수 있는건 Java 8 덕분이다.

## Webflux 의 장단점

### 장점

- 고성능
- [[Spring framework|Spring]]과 완전한 통합
- [[Netty]] 지원
- Async non-blocking 메세지 처리

### 단점

- 오류처리가 다소 복잡
- [[R2DBC]]를 사용할 경우 Non-blocking 하게 데이터베이스를 연결할 수 있지만, 연관관계 매핑을 지원하지 않음

## Next step

- [[Reactive 에 대해]]
- [[Non-blocking]]
- [[Functional programming]]

## Reference

- [webflux 간단한 사용법](https://www.devkuma.com/docs/spring-webflux/)