---
title: Reactive 에 대해
date: 2022-08-21 12:10:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-21
aliases: 
tags:
  - reactive
categories: 
updated: 2023-10-09 14:47:26 +0900
---

**Reactive** 라는 용어는 변화에 반응하는 것을 중심에 두고 만든 프로그래밍 모델을 의미한다. Non-blocking 은 작업을 기다리기보다 완료되거나 데이터를 사용할 수 있게 되면 반응하므로, 이 말대로면 Non-blocking 도 reactive 다.

[[Spring framework|Spring]]은 reactive 와 관련된 중요한 매커니즘이 하나 더 있는데, Non-blocking back pressure 다. 동기식 명령형(imperative) 코드에서 블로킹 호출은 호출자를 강제로 기다리게하는 일종의 back pressure 다. Non-blocking 코드에선, 프로듀서 속도가 컨슈머 속도를 압도하지 않도록 이벤트 속도를 제어한다.

Reactive stream 은 back pressure 를 통한 비동기 컴포넌트 간의 상호작용을 정의한 간단한 스펙이다(Java 9 에서도 채택했다). 예를 들어 데이터 레포지토리(Publisher)가 데이터를 만들고, HTTP 서버(Subscriber)로 이 데이터 요청을 처리할 수 있다. Reactive stream 을 쓰는 주목적은 subscriber 가 publisher 의 데이터 생산 속도를 제어하는 것이다.

> [!info] Publisher 속도를 늦출 수 없다면 어떻게 할까?
> Reactive stream 의 목적은 매커니즘과 경계를 확립하는 것이다. publisher 가 속도를 늦출 수 없다면 버퍼에 담을지, 데이터를 날릴지, 실패로 처리할지 결정해야 한다.

## Links

- [[Back pressure]]
- [[Sync Async and Blocking Non-blocking|Sync Async and Blocking Non-blocking]]