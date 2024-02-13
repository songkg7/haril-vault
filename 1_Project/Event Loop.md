---
title: Event Loop
date: 2023-01-11 18:32:00 +0900
aliases: 
tags:
  - webflux
  - reactive
  - reactor
categories: 
updated: 2024-02-13 12:02:20 +0900
---

## Overview

single thread 를 사용하여 대량의 트래픽을 처리하기 위한 reactive 처리 방식

Event Loop 는 중단되지 않고 실행되는 상태로 존재하다가 event 가 들어오면 요청을 보내고 바로 반환한다? event 에 대한 결과가 처리되면 다시 반환?

하나의 event 는 event 의 라이프사이클동안은 같은 thread 안에서 동작한다.

[[Spring WebFlux|WebFlux]]

- [ ] 멀티스레드와 이벤트 루프의 차이점
- [ ] 이벤트 루프는 비동기인가?
- [ ] 이벤트 루프는 논블락킹인가?

## 구현

- while 루프를 통한 task 위임
- Java 21 의 [[Virtual Thread]] 를 사용해보기
- thread pool 구현
- stack trace 문제를 어떻게 해결할 수 있을까?
    - stack trace 는 스레드에 할당되는 stack 공간에 대한 추적 정보이다. 따라서 스레드를 넘나드는 태스크라면 활용하기 어렵다.
    - stack trace 대신 로그 정보를 담는 기능을 boolean 값으로 전달할 수 있으면 좋을듯
    - 퍼포먼스 관점에서 트레이드오프 지점인지 체크

이벤트 루프는 단일 스레드로 구현하되, 메인 스레드가 블로킹되는 상황 회피를 위해 멀티스레드 방식을 혼합해야 할 수 있다. 이 때 멀티스레드는 스레드풀을 구현하여 미리 생성되어 있는 스레드르 사용하자.

이벤트 루프를 완전한 단일 스레드로 구현하기 위해서는 시스템 콜에 의해 블로킹되지 않도록, non-blocking I/O 를 사용하여야 한다.

## Reference

- https://developer.ibm.com/articles/l-async/
- https://grip.news/archives/1304
