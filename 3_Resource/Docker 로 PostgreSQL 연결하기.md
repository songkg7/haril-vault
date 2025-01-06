---
title: Docker 로 PostgreSQL 연결하기
date: 2023-10-31T10:45:00
aliases: 
tags:
  - docker
  - postgresql
  - postgis
categories: 
updated: 2025-01-07T00:35
---

- [[Docker|Docker]]
- [[PostgreSQL|postgres]]

### 1. image pull 및 실행

```bash
docker run -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=1234 -d postgres
```

### 2. 컨테이너 내부로 접근

```bash
docker exec -it postgres /bin/bash
docker exec -it postgres psql -U postgres # 한 번에 접근 가능
```

### 3. DB 접근

```bash
psql -U postgres
```

### 4. 유저 생성

```sql
create user kgsong password '1234' superuser;
```

### 5. database 생성

```sql
create database testdb owner kgsong;
```

이후 DB 를 연결하여 사용한다.

### PostGIS

[[PostGIS]] 는 extension을 설치해줘야한다.

```sql
create extension postgres;
```
