---
title: 트랜잭션 테스트 코드의 어려움
date: 2023-07-19 23:38:00 +0900
aliases: null
tags:
  - spring
  - transaction
  - transactional
  - test
categories: null
updated: 2023-08-26 13:39:44 +0900
---

## `@Transactional` 테스트의 문제점

1. JPA detached 상태 오브젝트의 변경이 자동감지 되지 않는 코드가 테스트에서는 정상동작하는 것처럼 보이는 문제
2. `@Transactional` 이 동일 클래스 내의 메서드 사이 호출에서는 적용되지 않는 문제(스프링 기본 프록시AOP 를 사용하는 경우, [[JDK dynamic proxy vs CGLIB|JDK dynamic proxy vs CGLIB]] 참조)
3. [[Java Persistence API|JPA]] 에서는 save 한 오브젝트가 영속성 컨텍스트에서만 존재하고 DB 로 flush 되지 않은 상태에서 rollback 되기 때문에 명시적으로 flush 를 호출하지 않으면 실제 DB 매핑에 문제가 있어도 검증하지 못하는 문제
