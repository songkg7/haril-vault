---
title: 배타적 잠금에서는 조회가 가능할까
date: 2023-09-28 16:45:00 +0900
aliases: 
tags:
  - s-lock
  - transaction
  - rdb
  - lock
  - sql
categories: Database
updated: 2023-09-28 16:45:33 +0900
---

select for update 문을 사용하면 데이터에 X-lock 이 걸리고 다른 트랜잭션에서 lock 을 획득하려하는 시도를 차단한다.

그러므로 lock 이 필요없는 조회 쿼리의 경우는 차단되지 않는다. 케이스는 아래 두 가지 경우가 있다.

1. 트랜잭션이 없는 조회: 테이블을 직접 조회한다.
2. 트랜잭션 안에서 발생하는 조회: Repeatable Read 의 경우 스냅샷을 조회한다.

## Links

- [[Transaction|Transaction]]
