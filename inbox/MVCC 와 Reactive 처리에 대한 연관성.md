---
title: "MVCC 와 Reactive 처리에 대한 연관성"
date: 2023-01-28 19:15:00 +0900
aliases: 
tags: [nosql, reactive, non-blocking, mvcc, rdb]
categories: 
updated: 2023-04-25 10:04:12 +0900
---

## MVCC 란?

> Multi Version Concurrency Control

다중 버전 동시성 제어의 줄임말로, 과거부터 현재까지의 다양한 버전 데이터들에 대한 관리와 제공이 가능한지를 나타내는 DMBS 의 기능 중 하나.

즉 시시각각 변하고 있는 데이터 중 사용자가 조회를 시작한 시점의 정확한 데이터를 제공받을 수 있는지를 나타내는 것으로, 그 구현 방법은 각각의 DBMS 마다 다르지만 목적은 모두 동일하다.

### PostgreSQL 의 MVCC

1. 테이블 내부에 변경 이전버전(들)과 현재 버전의 데이터를 모두 위치시킨다.
2. 각 레코드(row) 별로 4 byte 의 버전정보(XID)를 두어 시점을 식별할 수 있도록 한다.
3. 수행 시점의 Transaction ID 와 레코드의 XID(XMIN) 비교를 통해 MVCC 를 구현한다.

[[PostgreSQL]] 에서는 이전 버전을 들고 있기 때문에, dead tuple 이라고 하는 데이터가 존재한다. 데이터가 삭제되지 않고 계속 디스크 상에 쌓여가기 때문에 vaccum 이라는 과정을 통해서 더 이상 필요없어진 데이터들을 정리하는 과정을 해줘야 한다.

## RDB 에서의 비동기 처리

## NoSQL 에서의 비동기 처리

## Conclusion

## Reference

- [MVCC 알아보기](https://medium.com/monday-9-pm/mvcc-multi-version-concurrency-control-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0-e4102cd97e59)
