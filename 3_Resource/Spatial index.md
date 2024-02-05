---
title: Spatial index
date: 2024-01-17 17:50:00 +0900
aliases: 
tags:
  - spatial-index
  - index
  - postgis
categories: 
updated: 2024-02-05 22:40:26 +0900
---

[[PostGIS]]

[[PostgreSQL]]

## 기존 문제점

1. 물리적으로 다른 서버에 존재하는 테이블로 인해 join 쿼리를 작성하기 어려웠음
2. 따라서 애플리케이션 조인을 해야 해서 60000 * 40000 = 24억 정도의 루프가 발생했음
    1. 파티션을 통해 최대한 퍼포먼스를 개선했으나, 배치 전체 시간은 2m 남짓
3. 물리적으로 다른 데이터베이스를 마이그레이션 과정을 통해 하나로 합치게 되었고, 조인이 가능해지면서 고대하던 쿼리 최적화의 기회를 얻게 됨

## 해결 방향

GIST index 를 사용하면 R-tree 와 유사한 공간 인덱스를 생성할 수 있고, 인덱스 스캔을 통해 쿼리에서 바로 조회할 수 있을 것이라 생각했음

## 적용 결과

### spatial index 적용 전

1m 47s ~ 2m 30s

### spatial index 적용 후

0.23ms ~ 0.243ms

## 결론

## Reference

- [Spatial Indexing](https://postgis.net/workshops/postgis-intro/indexing.html)