---
title: MongoDB Developer Day
date: 2025-04-23T11:08:46+09:00
aliases: 
tags:
  - mongodb
description: 
updated: 2025-04-23T18:16
---

# Exercise 1. Schema modeling

- TTL [[Index]] 가 존재
    - 필요를 다해 지워야하는 데이터를 만료시간 기준으로 제거할 수 있다
- 더 자주 조회되는 쪽에 참조배열을 두자
    - 내장 대신 참조로 문서 사이즈 줄이기
- One-to-Few 는 one 쪽에 내장(embedding)
- One-to-Zillions 는 Many 쪽에 참조를 두자
    - 중복된 정보를 최소화하고 id 만 관리하도록 한다
- One-to-Many 는 케바케

![](https://i.imgur.com/RrOa3zJ.png)

## Anti pattern

- 비대한 문서는 MongoDB 의 대표적인 안티패턴
    - 작업세트가 캐시 메모리를 초과
        - MongoDB 의 캐시사이즈: RAM 1GB 의 50% 또는 256MB 중 큰 값
    - 빈번한 캐시 교체와 디스크 I/O 가 발생하며 성능 저하
    - 스키마 최적화를 통해, 작업세트가 캐시 메모리 내에 유지되도록 해야 한다
- 과도한 컬렉션 수
- **무제한 배열**은 안티패턴
    - 하나의 배열의 최대 크기는 16MB 인데 그걸 초과하게 될 수 있음
    - 조회성능에 악영향
    - 서브셋 패턴을 사용해서 피할 수 있음
- 불필요한 인덱스
- 함께 접근되는 데이터 분리
    - MongoDB 원칙은 함께 접근하는 데이터는 함께 저장하는 것으로, 임베딩과 배열을 활용해야 함
- 인덱스 없이 대소문자 구분없는 쿼리 사용

# Exercise 2. Aggregation Framework

- [[MongoDB]] 의 `_id` 를 숨기는게 인덱스를 효율적으로 사용할 수 있는 경우도 있음
    - 쿼리에 명시적으로 `_id`: 0 처리를 해줘야 함
- `unwind` 는 array 를 분리해서 원하는 필드만 볼 수 있게 해주지만 사용에는 신중할 것
- `count` 는 group 쿼리의 shortcut, 동작에 별 차이는 없다
- `group` 을 쓰면 sort 이 깨질 수 있다. 내부적으로 hashMap 을 쓰는 이유도 있다.
    - 인덱스스캔을 하고 싶을 땐 주의할 것. 앞선 인덱스스캔으로 자동정렬이 되더라도 다시 순서보장이 되지 않을 수 있음
    - blocking stage 라서 group 을 다 처리하기 전에는 다음 스테이지로 진행되지 못함 -> 즉 스트림이 아니게 되는 것
    - 전체 문서를 스캔하게 될 가능성이 있기 때문에 주의해야 한다
        - `setWindowFields` 를 대신 사용해야 한다
- `addFields`
    - 기존 필드에 영향을 주지 않고 특정 필드만 추가하고 싶은 경우 사용
    - `$set` 도 같은 역할을 하지만, 더 많은 기능을 제공 (ex. update)
    - `$set.$$REMOVE` 로 특정 필드를 제거할 수도 있다
- `$graphLookup` 은 graphRag 에 유용하게 활용될 수 있다
- aggregation 이라고 특별히 느리진 않으며 OLTP, OLAP 를 구분해서 사용하는 것이 중요하다.
    - aggregate 할 때 너무 많은걸 하려고 하면 안되고 클라이언트로 최소한의 데이터를 뽑아오는 것에만 집중해야 한다

# Execise 3. Search

### Vector Search

- Atlas Vector Search 는 **최대 4096차원까지 벡터를 지원**
- 검색 쿼리 자체를 vectorize 하는게 중요
    - 그래야 의미공간에서 벡터끼리 거리 계산이 가능하므로
- 외부 임베딩 모델을 활용하여 사용

# Conclusion

- 평소 [[MongoDB]] 에 대해 궁금했던 부분을 해결할 수 있었어서 매우 도움이 된 세션
