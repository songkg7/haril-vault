---
title: DEFFERED keyword in PostgreSQL
date: 2023-11-30T10:09:00
aliases: 
tags:
  - postgresql
categories: 
updated: 2025-01-07T00:35
---

제약 조건의 평가를 트랜잭션 이후로 미룬다. 기본 값은 Immediately 로 트랜잭션과 상관없이 즉시 평가하게 되어있다. DEFFERED 로 설정한다면 upsert 가 되지 않는다.

### INITIALLY DEFERRED?


