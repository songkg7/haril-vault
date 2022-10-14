---
title: "MySQL"
date: 2022-10-14 20:50:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-10-14
aliases: 
tags: [sql, database, opensource, rdb]
categories: Database
---

## Overview

대용량 데이터 처리에 특화되어 있는 오픈소스 데이터베이스.

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
