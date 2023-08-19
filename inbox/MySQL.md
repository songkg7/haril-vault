---
title: MySQL
date: 2022-10-14 20:50:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-10-14
aliases: null
tags:
  - sql
  - database
  - opensource
  - rdb
categories: Database
updated: 2023-08-19 12:37:51 +0900
---

## Overview

대용량 데이터 처리에 특화되어 있는 오픈소스 데이터베이스.

## Architecture

query parser

optimizer

컴파일 타임에 구문 검사를 할 수가 없기 때문에 실행될 때마다 구문 분석을 진행

5.0 대까지는 query cache 라는 것이 존재했다가 8.0에서 사라짐

스토리지 엔진의 존재

## Install

### Docker

```bash
docker pull mysql
```

```bash
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=1234 -p 3306:3306 mysql
```

```bash
docker exec -it mysql bash
```

```bash
mysql -uroot -p
```

```sql
create database db_name;
show database;
```

mysql 환경 설정 끝.
