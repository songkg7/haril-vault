---
title: PostgreSQL 100% 사용하기 밋업
date: 2024-04-17T18:51:00
aliases: 
tags:
  - postgresql
categories: 
updated: 2025-01-07T00:35
---

# 연사 소개

- 11년 이상 [[PostgreSQL]] 을 사용해온 분들

# 세션

## PostgreSQL Community 에 참여 / 기여하는 방법

- 연사: 비트나인 임상욱 상무
- Open Source No.1 DBMS

![](https://i.imgur.com/jIAlI9j.png)

- mailing list, commitfest 를 통해 기여를 받고 있음, github 은 mirror
- github 대신 자체 git repository 를 유지

## PostgreSQL 아키텍처 구성 방법

- 표준을 준수하고 개방적인 DBMS
- PG Core 커뮤니티: 대용량 처리와 성능위주 R&D 를 하고 있음

![](https://i.imgur.com/GB4unoD.png)

![](https://i.imgur.com/RvtP3Ay.png)

### Replication

[[Replication|데이터베이스 복제]]

- Logical Replication: sql 을 사용하여 이기종 DB 복제
- Physical Replication: 동일 DB 간 복제, 바이너리 레벨에서 동일하다

### Fail Over

시스템 장애 발생 시 자동으로 백업 시스템 전환

- PgPool 은 Auto fail over 가 가능

### High Availability (HA)

### 아키텍처 구성을 위한 OSS

- PgPool-2
- PgBouncer

### Single Node 와 Multi Node 구성에 따른 방법

- 공유 디스크 = 스토리지를 공유
- 멀티 노드

![](https://i.imgur.com/JrIlvFg.png)

AWS Aurora DB with PostgreSQL