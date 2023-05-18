---
title: "개발 질문 모음"
date: 2023-05-18 16:55:00 +0900
aliases: 
tags: [qna]
categories: 
updated: 2023-05-18 22:52:27 +0900
---

## Q

1. [[Spring WebFlux|Spring WebFlux]] 사용 중 외부 N개 서버에 API 요청을 비동기적으로 보낸 후, 다음 동작은 앞선 요청의 결과를 모두 받은 다음 실행해야한다고 할 경우 어떻게 해야할까?

### Expected

WebFlux 에서는 `block()` 을 사용할 수 없다. WebFlux 가 사용하는 [[Netty]] 는 블로킹을 지원하지 않기 때문이다. 블로킹을 위해서는 Spring MVC 의존성이 필요하다. 의존성 없이 블로킹을 해야한다면 `CompletableFuture` 를 대신 사용할 수 있다.

하지만 subscribe 동작을 사용한다면 블로킹 없이도 처리할 수 있지 않을까? 다음 동작을 구성할 때 앞선 이벤트 루프의 결과를 사용할 수 있도록 subscribe 를 연결하면 N개 서버에 요청한 결과를 받으면 publishing 처리될 것이라 생각한다.

만약 앞선 N개 서버의 모든 결과가 한 번에 필요해질 경우는 블로킹을 사용하면 될 것이다.

### Actual

`Mono.zip` 혹은 `Flux.zip` 을 사용하면 이전 퍼블리셔 응답이 완료된 이후 이어서 처리가 가능하다.

https://gngsn.tistory.com/228

