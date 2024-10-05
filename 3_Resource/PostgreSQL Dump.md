---
title: PostgreSQL Dump
date: 2024-01-09 15:36:00 +0900
aliases: 
tags:
  - postgresql
  - rdb
  - dump
  - migration
  - psql
  - pg_dump
  - pg_restore
categories: 
updated: 2024-10-05 11:44:36 +0900
---

## Condition

- 전체 데이터 약 2억건
- AWS RDB 에서 Aurora 로 데이터 마이그레이션
- 기존 동작 중인 배치를 종료하지 않고 처리

### DataGrip 에서 Import/Export 직접 실행

OutOfMemory Exception 발생

### Copy

100만건까지는 쓸만했지만 2억 건에 가까운 데이터를 처리하기에는 너무 느렸음

### pg_dump

`libpq` 를 로컬에 설치하여 postgresql 을 설치하지 않고도 `pg_dump` 명령을 사용할 수 있다.

```bash
$ pg_dump --dbname={db} --schema={schema} --table={table} --file={dump_file} --format=p --data-only --username={username} --host={host} --port={port}
```

`pg_restore`, `psql` 을 사용하여 restore 할 수 있다.

```bash
$ psql --file={dump_file} --username={username} --host={host} --port={port} {DataBase}
```
