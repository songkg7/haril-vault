---
title: Toss Interview Review
date: 2023-08-17 16:22:00 +0900
aliases: null
tags: null
categories: null
updated: 2023-08-17 17:05:31 +0900
---

### MSA 에서 트랜잭션 원자성을 보장하는 법

- [[Saga Pattern|Saga Pattern]]
- [[Transactional Outbox Pattern|Transactional Outbox Pattern]]
- [[Change Data Capture|CDC]]
- [[Two Phase Commit|2PC]]

### 테이블 조인에서 쿼리 최적화하는 방법들

- 조인될 테이블의 규모를 최소화하는 것이 중요
- group by 에서는 having 절 대신 where 절로 처리하는 것이 더 효율적. 순서상 where 을 먼저 처리하여 필터링해주기 때문
- select 절에서는 필요한 컬러만 조회

### select for update 를 지양해야하는 이유

### Spring MVC 에서 동시에 사용할 수 있는 사용자 수는 몇 명일까?

[[Spring MVC|Spring MVC]]

### 백프레셔를 직접 구현한다면 어떻게 구현할 수 있을까?
