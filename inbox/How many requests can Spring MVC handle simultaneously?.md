---
title: Spring MVC 는 얼마나 많은 요청을 동시에 처리할 수 있을까?
date: 2023-08-25 10:23:00 +0900
aliases: []
tags:
  - mvc
  - thread
  - network
  - connection
categories: 
updated: 2023-09-02 14:10:37 +0900
---

## 의문

Spring MVC 의 기본 max pool size 는 200 이다. 사용자 요청 당 하나의 스레드가 스프링 컨테이너를 생성하며 동작하는 MVC 특성을 생각해보면, 동시에 200개의 요청을 처리할 수 있는 것처럼 생각된다. 그렇다면 8000개 이상의 요청이 동시에 발생한다면 어떻게 동작할까? 스프링 MVC 는 이걸 처리할 수 있을까?

## 추정

- Spring MVC 의 기본 max pool size 는 200 이다. 이론상은 동시에 200개의 요청밖에 처리하지 못한다는 것이다. 그렇다면 너무 비효율적이므로 실제로는 그것보다는 많은 요청을 처리할 수 있을 것이다.
- NIO Connector 를 사용하므로 커넥션과 쓰레드는 1:1 매핑이 아닐 것이다.
    - 즉, 적은 수의 쓰레드를 효율적으로 처리하여 max 보다 더 많은 커넥션을 처리할 수 있을 것이다.

## 실험 설계

적은 수의 max 쓰레드를 설정하고 많은 수의 요청을 보내볼 때 대기열을 초과하는 요청은 어떻게 될까?

```yaml
server:
  tomcat:
    threads:
      max: 1
    accept-count: 1 # 대기열
```

5초 정도의 지연을 가지는 컨트롤러를 작성한다. 그리고 이 엔드포인트로 동시에 여러 요청을 보내봤을 때 서버에 찍히는 로그를 확인해보자.

## 결론

## Reference

- https://velog.io/@sihyung92/how-does-springboot-handle-multiple-requests
- https://velog.io/@hyunjong96/Spring-NIO-Connector-BIO-Connector

## Links

- [[Spring MVC|Spring MVC]]
