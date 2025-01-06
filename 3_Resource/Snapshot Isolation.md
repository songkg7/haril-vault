---
title: Snapshot Isolation
date: 2024-06-09T17:37:00
aliases: 
tags:
  - transaction
  - database
  - isolation
  - write-skew
categories: 
updated: 2025-01-07T00:35
---

## Snapshot Isolation(SI)

- SI 는 read 와 write 간에 delay 가 없는 매우 성능이 좋은 isolation level
    - Repeatable Read 라고 불린다.
- 한 트랜잭션 안에서는 consistency 가 보장된 읽기를 보장한다.
    - 실행 timestamp보다 낮거나 같은 것만 보게 됩니다. 따라서 실행 이후 업데이트는 보지 않습니다.
    - transation 실행 이후 생기는 버전은 읽지 않습니다.
- psql 은 이를 하나의 item 에 대해서 여러 version 을 가지고 있는 [[MVCC]](Multi Version Concurrency Control)를 이용하여 구현합니다.
- first write win (fww) 규칙을 이용하여 transation 에서 consistency 를 방어합니다.
    - 같은 row 를 두 트랜잭션이 동시에 바꾸는 것은 불가능합니다.
- [[PostgreSQL]] 과 [[MySQL]] 에서는 Repeatable Read 라고 불리고, [[Oracle]] 에서는 Serializable 이라고 불립니다.
- 하지만 **Write Skew 현상이 일어납니다**.

## Write Skew

> 의사 당직 문제

- 갱신 손실과는 다릅니다.
- SI 에서는 하나의 트랜잭션 안에서 데이터를 읽을 때, 항상 일관된 값을 읽습니다.
    - 이것이 Repeatable Read 의 정의입니다.
- 그러나, 동시에 같은 데이터를 두 개의 트랜잭션이 읽어들인다면 어떻게 될까요?
    - 두 트랜잭션에서 각기 다른 값을 읽게 됩니다.
    - 그리고 각기 다른 값을 업데이트하게 됩니다.
    - 이 업데이트는 서로 마주보게 됩니다. 따라서 하나는 다른 것을 덮어씌우고 나서 Commit할 수 있습니다.

## Write Skew 예시

- 예를 들어, 위키피디아에서 [[잠금 방식]] 문서를 수정하려고 합니다.
- 나중에 잠금 방식을 변경하는 작업을 수행하려고 하는 사람이 있다면 작업이 취소되고 해당 사용자가 먼저 commit한 값으로 변환됩니다.
- 이것은 일관성이 깨지거나, 오버라이드 되는 것은 아닙니다. 따라서 모든 트랜잭션이 일관된 값을 보장받지 못하는 것입니다.

## Write Skew 방어 방식

### Pessimistic Locking

- 잠금 방식을 사용하여 해결할 수 있습니다.
- 하지만, 데드락이 발생하여 성능에 큰 영향을 미칠 수 있습니다.

### 설계 변경

- fww 로 방어할 수 있습니다.
- 설계시 고려되어야 합니다.
- 실수하기 쉽습니다.

## Reference

- [PSQL 에서 Serializable 격리 수준을 쓰기 무서우신가요?](https://velog.io/@jaquan1227/PSQL-%EC%97%90%EC%84%9C-Serializable-%EA%B2%A9%EB%A6%AC%EC%88%98%EC%A4%80%EC%9D%84-%EC%93%B0%EA%B8%B0-%EB%AC%B4%EC%84%9C%EC%9A%B0%EC%8B%A0%EA%B0%80%EC%9A%94)
