---
title: Transaction Isolation Level
date: 2024-06-09T17:28:00
aliases: 
tags:
  - database
  - transaction
  - isolation
categories: 
updated: 2025-01-07T00:35
---

## 트랜잭션 격리 레벨이란?

트랜잭션의 격리 수준은 동시에 여러 트랜잭션이 처리될 때 발생하는 간섭을 어느 정도 허용할 것인지를 나타내는 것으로, 이를 잘 설정해야 데이터베이스에서 데이터의 무결성과 일관성을 유지할 수 있다. 따라서 효율성과 균일성 사이에서 적절한 균형을 맞춰야 한다.

### Read Uncommitted

트랜잭션에서 처리 중인 데이터에 Shared Lock(공유 잠금)이 걸리지 않는다. 이로 인해 다른 트랜잭션이 해당 데이터를 수정하거나 삭제할 수 있기 때문에 별도의 선점을 막기 위해 사용하는 것이다. 이 때문에 Dirty Read 문제가 발생할 수 있다.

**Dirty Read** : 커밋되지 않은 변경된 내용을 다른 트랜잭션에서 읽는 것

### Read Committed

트랜잭션이 커밋된 데이터만 읽을 수 있도록 하기 위해 Shared Lock(공유 잠금)이 걸린다. 따라서 Read Uncommitted에서 발생한 Dirty Read 문제를 해결할 수 있다. 하지만 Non-Repeatable Read 문제가 발생할 수 있다.

**Non-Repeatable Read** : 동일한 쿼리를 두 번 실행했을 때, 그 사이에 다른 트랜잭션이 해당 데이터를 수정 혹은 삭제하여 결과 값이 달라지는 것

[[PostgreSQL]] 의 기본 격리 레벨이다.

### Repeatable Read

> [[Snapshot Isolation]]

Shared Lock(공유 잠금)과 함께 Range Lock(범위 잠금)을 사용하여 해결한다. 따라서 Non-Repeatable Read 문제는 해결할 수 있지만 Phantom Read 문제가 발생할 수 있다.

**Phantom Read** : 동일한 쿼리를 두 번 실행했을 때, 그 사이에 다른 트랜잭션이 새로운 데이터를 추가하여 결과 값이 달라지는 것

[[MySQL]] 의 기본 격리 레벨이다.

### Serialization

모든 트랜잭션을 순차적으로 실행하도록 강제한다. 따라서 모든 문제점을 해결할 수 있지만 동시성이 낮아져서 효율성이 크게 떨어진다.
