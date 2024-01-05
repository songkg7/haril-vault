---
title: PostgreSQL
date: 2023-09-27 15:25:00 +0900
aliases:
  - postgres
  - psql
tags:
  - postgresql
  - rdb
  - database
categories: 
updated: 2024-01-04 11:10:14 +0900
---

## Indexes In PostgreSQL

많은 데이터베이스 벤더들은 Primary Key 를 생성할 경우 기본적으로 Clustered [[Index]] 로 생성해준다.

반면 PostgreSQL 에서는 동작이 약간 다른데, PK 의 정렬 순서가 아닌 tuple 의 삽입 순서를 기준으로 생성해준다.

## Reference

- https://techblog.woowahan.com/9478/
- https://techblog.woowahan.com/6550/
- https://d2.naver.com/helloworld/227936
- https://dev.to/mahmoudhossam917/indexes-in-postgresql-1hob
- https://aws.amazon.com/ko/blogs/database/multi-tenant-data-isolation-with-postgresql-row-level-security/
- https://github.com/jojoldu/postgresql-in-action

## Links

