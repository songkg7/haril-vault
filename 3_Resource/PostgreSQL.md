---
title: PostgreSQL
date: 2023-09-27T15:25:00
aliases:
  - postgres
  - psql
  - pg
tags:
  - postgresql
  - rdb
  - database
categories: 
updated: 2025-04-24T11:21
---

## Indexes In PostgreSQL

많은 데이터베이스 벤더들은 Primary Key 를 생성할 경우 기본적으로 Clustered [[Index]] 로 생성해준다.

반면 PostgreSQL 에서는 동작이 약간 다른데, PK 의 정렬 순서가 아닌 tuple 의 삽입 순서를 기준으로 생성해준다.

## Transation isolation level

- https://www.postgresql.org/docs/current/transaction-iso.html

## 실행중인 쿼리 확인

https://blog.gaerae.com/2015/09/postgresql-pg-stat-activity.html

```sql
-- 실행 중인 쿼리
SELECT *
FROM pg_stat_activity
where application_name like 'DataGrip%'
ORDER BY query_start ASC;

-- 현재 진행 중인 lock 모니터링
select locktype, relation::regclass, mode, transactionid tid, pid, granted
from pg_catalog.pg_locks
where not pid = pg_backend_pid();

-- 어떤 쿼리가 블로킹 상태인지
SELECT blockeda.pid    AS blocked_pid,
       blockeda.query  as blocked_query,
       blockinga.pid   AS blocking_pid,
       blockinga.query as blocking_query
FROM pg_catalog.pg_locks blockedl
         JOIN pg_stat_activity blockeda ON blockedl.pid = blockeda.pid
         JOIN pg_catalog.pg_locks blockingl ON (blockingl.transactionid = blockedl.transactionid
    AND blockedl.pid != blockingl.pid)
         JOIN pg_stat_activity blockinga ON blockingl.pid = blockinga.pid
WHERE NOT blockedl.granted;
```

## 실험

- repeatable read 부터 phantom read 현상 나타나지 않음
- repeatable read 부터 갱신 유실 발생하지 않음(동시 트랜잭션이 감지되었을 때 변경하려고 하면 거절됨)
- Exclusive Lock 이 걸려있어도 shared lock 을 통한 읽기가 가능
- serializable 에서 SIReadLock 이 걸리기는 하나 상호 읽기를 방해하지 않음

Repeatable Read 일 때, 일반적인 RDB 라면 언두 영역의 데이터가 아니라 테이블의 레코드를 가져오게 되면서 phantom read 가 발생한다. 
- [[MySQL]] 에서는 gap lock 이 존재하기 때문에 next key lock 을 건다. 따라서 범위에 해당하는 데이터의 삽입을 시도한다면 대기하게 되면서 phantom read 를 막는다.
- PostgreSQL 에서는 next key lock 없이도 phantom read 가 발생하지 않는다. TXID 를 통해 특정 트랜잭션 이후에 실행된 트랜잭션의 변경은 읽지 않으면 되기 때문이다.

## Reference

- https://techblog.woowahan.com/9478/
- https://techblog.woowahan.com/6550/
- https://d2.naver.com/helloworld/227936
- https://dev.to/mahmoudhossam917/indexes-in-postgresql-1hob
- https://aws.amazon.com/ko/blogs/database/multi-tenant-data-isolation-with-postgresql-row-level-security/
- https://github.com/jojoldu/postgresql-in-action
- https://chrisjune-13837.medium.com/db-postgresql-lock-%ED%8C%8C%ED%97%A4%EC%B9%98%EA%B8%B0-57d37ebe057
- https://github.com/junhkang/postgresql

## Links

