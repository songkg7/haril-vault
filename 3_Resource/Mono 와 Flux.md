---
title: Mono 와 Flux
date: 2022-08-21 12:59:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-21
aliases: null
tags:
  - reactive
  - webflux
  - mono
  - flux
categories: null
updated: 2023-08-19 12:37:56 +0900
---

[[Spring WebFlux]] 에서 사용하는 reactive library 가 Reactor 이고 Reactor 가 Reactive streams 의 구현체입니다. `Flux` 와 `Mono` 는 Reactor 객체이며, 차이점은 발행하는 데이터 갯수입니다.

- `Mono`: 0 ~ 1 개의 데이터 전달
- `Flux`: 0 ~ N 개의 데이터 전달

보통 여러 스트림을 하나의 결과로 모아줄 때 `Mono` 를, 각각 `Mono` 를 합쳐서 여러개의 값을 처리할 때 `Flux` 를 사용한다.

그런데 `Flux` 도 0 ~ 1개의 데이터 전달이 가능한데 굳이 한개까지만 데이터를 처리할 수 있는 `Mono` 라는 타입이 필요할까? 데이터 설계를 할 때 결과가 없거나 하나의 결과값만 받는 것이 명백한 경우, `List` 나 `Array` 를 사용하지 않는 것처럼, Multi result 가 아닌 하나의 결과셋만 받게 될 경우 불필요하게 `Flux` 를 사용하지 않고 `Mono` 를 사용하게 된다.
