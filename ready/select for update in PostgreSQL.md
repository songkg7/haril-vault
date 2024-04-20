---
title: PostgreSQL 에서 SELECT FOR UPDATE 구문의 동작방식
date: 2024-04-20 18:30:00 +0900
aliases: 
tags:
  - postgresql
  - transaction
  - 2pl
categories: 
updated: 2024-04-20 21:55:13 +0900
---

## SELECT FOR UPDATE 구문의 동작 방식

PostgreSQL의 FOR UPDATE 잠금은 트랜잭션 내에서 SELECT 쿼리를 수행하는 동안 테이블의 행을 명시적으로 잠그는 데 사용됩니다. 이 잠금 모드는 일반적으로 트랜잭션이 완료될 때까지 선택한 행이 변경되지 않도록 하여 다른 트랜잭션이 충돌하는 방식으로 해당 행을 수정하거나 잠그지 못하도록 하려는 경우에 사용합니다.

예를 들면 티켓 예매처럼 특정 고객이 티켓 예매 과정을 진행하는 동안 다른 고객이 데이터를 변경할 수 없도록 막기 위해 사용할 수 있어요.

이번 글에서 살펴볼 케이스들은 조금 특별합니다.

- 잠금을 사용하는 읽기와 잠금을 사용하지 않는 읽기를 혼용하게 된다면 `select for update` 는 어떻게 동작할까요?
- 애초에 잠금을 사용했는데 다른 트랜잭션에서 읽기가 가능하긴 한 걸까요?
- 읽기 방식을 혼용해도 데이터의 일관된 읽기를 보장할 수 있을까요?

[[PostgreSQL]] 에서 `select for update` 구문은 **트랜잭션 격리레벨에 따라서 다르게 동작**합니다. 따라서 격리레벨 별로 살펴봐야 해요.

아래와 같은 데이터가 존재할 때 데이터를 변경하는 상황을 가정해볼게요.

| id  | name |
| --- | ---- |
| 1   | null |

## 1. Read committed

- [[PostgreSQL]] 의 기본 격리레벨
- A 트랜잭션이 `select for update` 로 행을 잠그더라도 B 트랜잭션에서 데이터를 읽을 수 있다.
    - 잠금없는 읽기
- A 트랜잭션이 커밋하기 전까지는 B 트랜잭션에서 데이터를 변경할 수 없다.
- B 트랜잭션이 A 트랜잭션이 커밋되길 기다리고 있을 경우, A 트랜잭션이 커밋되면 B 트랜잭션이 곧바로 커밋된다.
- 일관된 읽기를 보장하지 않는다.
- **갱신 유실이 발생**한다.

```mermaid
sequenceDiagram
    participant A as A transation
    participant DB
    participant B as B transation
    A->>DB: BEGIN
    B->>DB: BEGIN
    A->>DB: select where id = 1 <br/>for update
    activate DB
    DB->>A: id=1, name=null
    B->>DB: select where id = 1
    DB->>B: id=1, name=null
    Note right of B: 읽기 가능
    B-->>DB: update set name = 'B'<br/>where id = 1
    Note over B,DB: A 가 커밋되기 전까지 대기
    A->>DB: update set name = 'A'<br/>where id = 1
    A->>DB: commit
    deactivate DB
    critical 갱신유실
        B->>DB: update set name = 'B'<br/>where id = 1
        B->>DB: commit
    end
```

Exclusive Lock 이 적용된 부분은 진한 색으로 표시했어요. 위 다이어그램에서 볼 수 있듯이, [[PostgreSQL]] 은 잠금없는 읽기를 막지 않아요. 대신 A 트랜잭션에서 잠금을 획득한 레코드에 대해서 B 트랜잭션이 변경하려고 시도하면 A 트랜잭션이 완료될 때까지 기다리게 되어요. 결국 **갱신 유실을 피할 수 없게 됩니다**.

만약 갱신 유실을 방지해야한다면 Repeatable Read 격리 레벨을 사용해야 해요.

## 2. Repeatable Read

- A 트랜잭션이 `select for update` 로 행을 잠그더라도 B 트랜잭션에서 데이터를 읽을 수 있다.
- A 트랜잭션이 커밋하기 전까지는 B 트랜잭션에서 데이터를 변경할 수 없다.
- B 트랜잭션에서 데이터를 변경하려고 하면 **직렬화 오류가 발생**한다. (B 트랜잭션 rollback 조치 필요)
- 일관된 읽기를 보장한다.
- **갱신 유실이 발생하지 않는다.**

### 트랜잭션간 데이터 변경 작업이 충돌하는 경우

```mermaid
sequenceDiagram
    participant A as A transation
    participant DB
    participant B as B transation
    A->>DB: BEGIN
    B->>DB: BEGIN
    A->>DB: select where id = 1<br/>for update
    activate DB
    B->>DB: select where id = 1
    DB->>B: id=1,name=null
    B-->>DB: update set name = 'B'<br/>where id = 1
    Note over B,DB: A 가 커밋되기 전까지 대기
    A->>DB: update set name = 'A'<br/>where id = 1
    A->>DB: commit
    deactivate DB
    critical serialize error
        B-->>DB: update set name = 'B'<br/>where id = 1
        Note over B,DB: 데이터 변경 불가
    end
    B->>DB: commit or rollback
```

![](https://i.imgur.com/pmzNncf.png)

동시 변경 작업이 감지되어 직렬화 오류가 발생하는 것을 확인할 수 있어요. 이럴 경우, 개발자가 직접 에러 핸들링을 해줘야 합니다.

### 트랜잭션간 데이터 변경 작업이 충돌하지 않는 경우

만약 A 트랜잭션에서 row 를 잠궜지만 변경하지 않았고, B 트랜잭션에서는 변경했다고 할 때 이 경우 결과는 어떻게 될까요?

[[PostgreSQL]] 에서는 커밋 결과가 충돌하지 않는 경우는 모든 변경사항이 반영됩니다.

```mermaid
sequenceDiagram
    participant A as A transation
    participant DB
    participant B as B transation
    A->>DB: BEGIN
    B->>DB: BEGIN
    A->>DB: select where id = 1<br/>for update
    activate DB
    B->>DB: select where id = 1
    DB->>B: id=1,name=null
    B-->>DB: update set name = 'B'<br/>where id = 1
    Note over B,DB: A 가 커밋되기 전까지 대기
    A->>DB: commit
    deactivate DB
    Note over A,DB: 변경없이 커밋
    B->>DB: update set name = 'B'<br/>where id = 1
    B->>DB: commit
```

A 트랜잭션이 먼저 lock 을 획득했지만, 결과적으로 충돌은 없기 때문에 B 트랜잭션의 변경사항이 에러없이 반영되요.

## 3. Serializable

- Repeatable Read 와 거의 동일합니다.
- Serializable 이 항상 안좋은 것은 아니에요. 최근 DB 들의 Serializable 은 고려해볼 가치[^1]가 있습니다.

## A, B 모두 SELECT FOR UPDATE 를 호출하는 경우

그렇다면 양 쪽 트랜잭션에서 모두 `select for update` 를 호출한다면 어떻게 될까요?

이렇게 될 경우는 **격리레벨과는 상관없이** 서로 Exclusive Lock 을 획득해야하기 때문에 **한 쪽에서 lock 을 해제해야 다른 트랜잭션이 lock 을 획득**할 수 있습니다.

```mermaid
sequenceDiagram
    participant A as A transation
    participant DB
    participant B as B transation
    A->>DB: BEGIN
    B->>DB: BEGIN
    A->>DB: select where id = 1<br/>for update
    activate DB
    DB->>A: id=1, name=null
    B-->>DB: select where id = 1<br/>for update
    Note over B,DB: A 가 커밋되기 전까지 대기
    A->>DB: update set name = 'A'<br/>where id = 1
    A->>DB: commit
    deactivate DB
    B->>DB: select where id = 1<br/>for update
    DB->>B: id=1,name='A'
    B->>DB: update set name = 'B'<br/>where id = 1
    B->>DB: commit
```

모든 작업을 순차적으로 처리하도록 보장하고 싶다면 모든 트랜잭션이 `select for update` 를 사용하여 lock 을 획득할 수 있도록 해야 합니다.

## Conclusion

지금까지 살펴본 부분들을 정리해볼게요.

- `select for update` 구문에서 잠금없는 읽기 동작을 막지 않아요.
- 동시성을 안전하게 제어하고자 한다면 모든 트랜잭션에서 `select for update` 를 사용하는게 좋아요.
- [[PostgreSQL]] 은 First-Committer Win 정책을 통해 가장 먼저 커밋된 트랜잭션을 허용하고 나머지는 허용하지 않는 방식으로 동시성을 제어해요.

[[PostgreSQL]] 의 `select for update` 구문은 **모든 격리 수준에서 잠금없는 읽기를 방해하지 않아요.** 대신 커밋 시점에서 데이터의 변경이 감지되면 그 때 에러를 발생시켜서 추가적인 핸들링을 유도합니다. 또한 잠금이라고 해서 항상 다른 트랜잭션을 기다려야하는 것도 아니에요. 상황에 맞게 처리하면서 성능을 최대한 발휘하도록 설계되어 있는 점이 흥미롭습니다.

## Reference

- [Locks in PostgreSQL part 3](https://dev.to/mahmoudhossam917/postgresql-locks-part-3-3481#:~:text=The%20FOR%20SHARE%20lock%20mode%20in%20PostgreSQL,ensuring%20data%20consistency%20without%20blocking%20other%20readers)

[^1]: [PSQL에서 Serializable 격리수준을 쓰기 무서우신가요?](https://velog.io/@jaquan1227/PSQL-%EC%97%90%EC%84%9C-Serializable-%EA%B2%A9%EB%A6%AC%EC%88%98%EC%A4%80%EC%9D%84-%EC%93%B0%EA%B8%B0-%EB%AC%B4%EC%84%9C%EC%9A%B0%EC%8B%A0%EA%B0%80%EC%9A%94)
