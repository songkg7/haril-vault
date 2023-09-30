---
title: JPA 에서의 select for update 동작
date: 2023-09-30 19:48:00 +0900
aliases: 
tags:
  - jpa
  - sql
  - transaction
  - lock
categories: 
updated: 2023-09-30 19:48:09 +0900
---

[[Java Persistence API|JPA]] 에서는 `@Lock` 어노테이션을 통해서 `select for update` 구문을 사용할 수 있다.

`@Lock` 에는 3가지 옵션이 있다.

- pessimistic read: 해당 리소스에 Shared lock(공유 락)을 건다. 다른 트랜잭션에서 읽기는 가능하지만 쓰지 못하는 상태가 된다.
- pessimistic write: 해당 리소스에 [[Pessimistic Lock]](베타 락) 을 건다. 다른 트랜잭션에서 읽기와 쓰기 모두 불가능해진다.
- pessimistic force increment: pessimistic write 와 유사하게 동작하지만 추가적으로 [[Optimistic Lock]](낙관적 락)처럼 버저닝을 하게 된다. 따라서 버전에 대한 칼럼이 필요하다.

이 중에 `PESSIMISTIC_WRITE` 를 사용하면 쿼리문에 for update 가 붙어서 실행된다.

> [!INFO]
> `PESSIMISTIC_READ` 의 경우에는 lock in share mode 가 붙어서 실행된다

> [!warning]
> `@Lock` 어노테이션은 JPA 의 `@Transactional` 어노테이션 내부에서 실행되어야 한다.

## Reference

- https://wildeveloperetrain.tistory.com/128

## Links

[[Transaction]]
