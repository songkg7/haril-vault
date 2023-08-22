---
title: Nested Loop Join
date: 2023-08-22 14:31:00 +0900
aliases: null
tags: database, join
categories: null
updated: 2023-08-22 15:06:06 +0900
---

## Nested Loop Join

2개 이상의 테이블에서 하나의 집합을 기준으로 순차적으로 상대방 Row 를 결합하여 원하는 결과를 조합하는 조인 방식. 조인해야할 데이터가 많지 않은 경우에 유용하게 사용된다.

Nested Loop Join 은 드라이빙 테이블로 한 테이블을 선정하고 이 테이블로부터 where 절에 정의된 검색 조건을 만족하는 데이터들을 걸러낸 후, 이 값을 가지고 조인 대상 테이블을 반복적으로 검색하면서 조인 조건을 만족하는 최종 결과값을 얻어냅니다.

### Driving Table 과 Driven Table

Driving Table 이란 JOIN 을 할 때 먼저 액세스 되어 Access path 를 주도하는 테이블을 Driving Table 이라고 합니다. 즉, 조인을 할 때 먼저 액세스 되는 테이블을 Driving Table 이라고 하며 나중에 액세스 되는 테이블을 Driven Table 이라고 합니다. 여기서 Driving Table 은 옵티마이저가 결정하고 자연스레 Driving Table 이 아닌 테이블은 Driven Table 로 결정됩니다.

## Reference

- https://coding-factory.tistory.com/756
