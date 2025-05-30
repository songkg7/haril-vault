---
title: Virtual Thread
date: 2023-12-12T19:00:00
aliases: 
tags:
  - java
  - thread
  - virtual
  - loom-project
  - jdk21
categories: 
updated: 2025-01-07T00:35
---

## 배경

- Java 의 스레드는 OS 스레드를 래핑한 것 = Platform Thread
- OS thread 는 생성 개수가 제한적이고 생성 유지하는 비용이비싸다
- 스레드풀을 만들어서 사용
- 기본적인 thread per request 하나의 요청/하나의 스레드
- 처리량을 높이려면 스레드 증가 필요, but 스레드를 무한정 늘릴 수 없다

### blocking i/o

- thread 에서 io 작업을 처리할 때 blocking 이 일어난다.
- 처리 시간보다 대기시간이 길다

이런 점을 극복하기 위해 리액티브 프로그래밍

- Webflux 스레드를 대기하지 않고 다른 작업 처리 가능
- 코드를 작성하고 이해하는 비용이 높다
- 리액티브 하게 동작하는 라이브러리 지원을 필요로 한다.
- JPA 대신 R2DBC 등을 사용해야 함

### Java design

- 스레드 중심으로 구성되어 있다
- Exception stack trace, debugger, profiling 모두 스레드 기반
- 리액티브할 때 작업이 여러 스레드를 거쳐 처리되는데, 컨텍스트 확인이 어려워 디버깅이 어려움

## 해결하고자 하는 문제

- 높은 처리량(throughput) 확보
    - Blocking 발생시 내부 스케쥴링을 통해 다른 작업을 처리
- 자바 플랫폼의 디자인과 조화를 이루는 코드 생성
    - 기존 스레드 구조 그대로 사용

```yaml
spring:
  threads:
    virtual:
      enabled: true
```

## 유의사항

전통적인 스레드와는 다르다. OS 의 자원이라기보다는 하나의 task 에 가깝다

스레드 로컬 사용시 주의

- 가상 스레드는 힙을 사용하기 때문에 이를 남발하면 메모리 사용이 늘어남
- synchronized 사용시 가상 스레드에 연결된 캐리어 스레드가 블로킹될 수 있으니 주의 = 이런 경우를 pinning 이라고 함
    - reentrantLock 사용으로 회피할 수 있다

## 성능 테스트

쿼리 질의도 테스트해봐야

[[MySQL]] DB의 Max-connections 은 기본 150, Database Connection 을 기다리다가 타임아웃이 발생할 수 있다

- 기존의 스레드 풀을 사용했던 이유는 DB 가 압도되지 않도록 하는 스로틀링의 이유도 있다.

## 적합한 사용처

- I/O Blocking 이 발생하는 경우
- CPU Intensive 하지 않은 작업
- Spring MVC 기반 Web API 제공시 편리하게 사용할 수 있음
    - 높은 throughput 을 위해서 WebFlux 를 고려 중이라면 대안이 될 수 있다

## 오해

- 가상 스레드는 기존 스레드를 대체하는 것이 목적이 아니다
- 가상 스레드는 기다림에 대한 개선, 그리고 플랫폼 디자인과의 조화
- 도입한다고 무조건 처리량이 높아지진 않는다
- 가상 스레드는 그 자체로 Java 의 동시성을 완전히 개선했다고 보기는 어렵다

## 제약

- 스레드 풀에 적합하지 않다
- 스레드 로컬 사용시 메모리 사용량 증가 가능성
- synchronized 사용시 주의
- 제한된 리소스의 경우 세마포어를 사용해서 코드를 안전하게 관리

## 신기능

경량 스레드

- OS 스레드를 그대로 사용하지 않는다
- JVM 내부 스케쥴링을 사용

> 기존 스레드 사용성을 해치지 않으면서도 단점만을 개선한 가상 스레드

## 궁금증

- 자바의 스택트레이스는 말씀하셨던 것처럼 스레드별 생성되는 스택이라는 영역을 기반으로 동작하는데, 가상 스레드를 적용한다면 스택 트레이스의 정보는 캐리어 스레드인가 아니면 가상 스레드인가? 기존 스택 영역의 동작이 변하진 않을 것 같은데
    - OS 스레드일듯
    - 이걸 어떻게 증명하지?
- 

## Reference

- https://d2.naver.com/helloworld/1203723
- https://guruma.github.io/posts/2018-09-27-Project-Loom-Fiber-And-Continuation/
