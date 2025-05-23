---
title: Index
date: 2022-10-26T09:53:00
aliases: 
tags:
  - index
  - database
categories: 
updated: 2025-01-07T00:35
---

인덱스는 정렬된 테이블이다. 정렬되어 있기 때문에 빠른 조회를 보장한다. 하지만 인덱스는 테이블인만큼 추가 공간을 차지하게 된다. 또한 인덱스를 설정하게 되면 데이터를 쓰거나 삭제할 때 인덱스가 계속 변화하기 때문에 필연적으로 데이터 수정 성능을 낮추게 된다.

### 인덱스의 자료구조

B+Tree 를 사용하여 가장 마지막 노드에 모든 데이터를 저장한다. 이런 방식은 조회 성능을 위한 것으로, 마지막 노드만 탐색해도 모든 데이터를 찾을 수 있다.

## Reference

- https://12bme.tistory.com/138
- https://chartworld.tistory.com/18
