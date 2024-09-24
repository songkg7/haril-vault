---
title: Spatial index
date: 2024-03-03 14:00:40 +0900
aliases: 
tags:
  - spatial-index
  - index
  - postgis
  - geometry
categories: 
updated: 2024-03-03 14:01:05 +0900
---

매우 비효율적이였던 기존 구현 방식을 설명하고, 개선하기 위해 시도한 방법들을 기록합니다.

## 기존 문제점

![](https://i.imgur.com/wPORK6n.png)

_한 번의 쿼리로 여러 DB 에 흩어진 테이블을 join 하는 것은 불가능하진 않지만 어려웠다..._

1. 특정 좌표가 a 라는 영역에 포함되어 있는가?
2. 물리적으로 다른 서버에 존재하는 테이블로 인해 join 쿼리를 작성하기 어려웠음
    1. 왜 한방 쿼리여야 하는가? 조회해야하는 데이터의 사이즈가 매우 크기 때문에 애플리케이션 메모리로 로드되는 양을 최대한 줄이고 싶었음
3. DB 조인이 안되기 때문에 애플리케이션 조인을 해야 했고 60000 * 40000 = 24억 정도의 루프가 발생했음
    1. 파티션 처리를 통해 최대한 처리시간을 줄였으나, 여전히 루프로 인해 CPU 부하가 매우 심했다
4. 물리적으로 다른 데이터베이스를 마이그레이션 과정을 통해 하나로 합치게 되었고, 조인이 가능해지면서 고대하던 쿼리 최적화의 기회를 얻게 됨

## 해결 방향

그동안 데이터베이스의 조인을 사용하지 못했던 가장 큰 원인이 해결된 상황이였기 때문에 적극적으로 인덱스 스캔을 활용한 geometry 처리 방법을 고민해봤다.

- PostGIS 의 GIST index 를 사용하면 R-tree 와 유사한 공간 인덱스를 생성할 수 있고, 인덱스 스캔을 통해 쿼리에서 바로 조회할 수 있을 것이다.
- 공간 인덱스를 사용하기 위해서는 geometry 타입의 컬럼이 필요하다.
- 기존에는 위경도 좌표는 있었지만 geometry 타입은 없었기에, 위경도를 사용하여 geometry POINT 값을 먼저 생성해줘야 한다.

위 과정을 모의하기 위해 실제 운영 중인 DB 와 완전히 같은 데이터를 준비하고 실험을 진행했다.

인덱스를 먼저 생성해주고,

```postgresql
CREATE INDEX idx_port_geom ON port USING GIST (geom);
```

PostGIS 의 `contains` 함수를 실행해봤다.

```postgresql
SELECT *
FROM ais AS a
JOIN port AS p ON st_contains(p.geom, a.geom);
```

![](https://i.imgur.com/aMFmfCh.png)

_Awesome..._

## 적용 결과

### spatial index 적용 전

1m 47s ~ 2m 30s

### spatial index 적용 후

0.23ms ~ 0.243ms

캡쳐를 준비하진 못했지만, 인덱스를 적용하기 전에는 조회에만 1분30초 이상이 소요됐었다.

결론부터 설명했다. 왜 이런 결과가 나오는지 살펴보자.

## GiST (Generalized Search Tree)

복합적인 지리(geometric) 데이터를 조회하는데 매우 유용한 인덱스이며 내부 구조 예시는 아래와 같다.

R-tree의 아이디어는 평면을 직사각형으로 분할하여 색인되는 모든 점을 전체적으로 포괄하는 것이다. 인덱스 행은 직사각형을 저장하며 다음과 같이 정의할 수 있다.

> "찾고자 하는 점은 주어진 사각형 안에 있다".

R-트리의 루트에는 여러 개의 가장 큰 사각형(교차하는 사각형일 수도 있음)이 포함된다. 자식 노드는 부모 노드에 포함된 더 작은 크기의 직사각형을 포함하며, 전체적으로 모든 기본 포인트를 포함한다.

이론적으로 리프 노드에는 인덱싱되는 포인트가 포함되어야 하지만 모든 인덱스 행에서 데이터 유형이 동일해야 하므로 포인트로 축소된 직사각형이 반복적으로 저장된다.

이러한 구조를 시각화하기 위해 세 가지 수준의 R-tree 에 대한 이미지를 살펴보자. 점은 공항의 좌표이다.

![](https://i.imgur.com/VnMOteR.png)

_Level one: two large intersecting rectangles are visible._

교차하는 두 직사각형이 표시된다.

![](https://i.imgur.com/HSqc7xA.png)

_Level two: large rectangles are split into smaller areas._

큰 직사각형이 작은 영역으로 분할된다.

![](https://i.imgur.com/PLDS9BR.png)

_Level three: each rectangle contains as many points as to fit one index page._

각 직사각형에는 하나의 색인 페이지에 맞는 만큼의 점들이 포함된다.

이후 영역들은 트리로 구성되고, 조회시 트리를 스캔한다. 더 자세한 정보가 필요하다면 [다음 글](https://medium.com/postgres-professional/indexes-in-postgresql-5-gist-86e19781b5db)을 살펴보시는걸 추천한다.

## 결론

지금까지 특정 조건 하에서, 어떤 문제가 있었고 해결하기 위해 어떤 노력을 해왔는지, 이 문제를 해결하기 위해 필요한 기본 개념에 대해서 간단하게 소개하는 글을 적어보았다. 내용을 정리해보면 아래와 같다.

- 물리적으로 분리된 데이터베이스에서는 인덱스를 활용한 효율적인 조인을 수행할 수 없었다
- 마이그레이션을 통해 물리적 조인을 수행할 수 있게 변경했다
- 인덱스 스캔을 활용할 수 있게 되면서 전체적인 퍼포먼스가 크게 개선되었다
- 애플리케이션 메모리에 데이터를 불필요하게 로드할 필요가 없어졌다
- 루프로 인한 CPU 부하가 해소되었다

## Reference

- [Spatial Indexing](https://postgis.net/workshops/postgis-intro/indexing.html)
- https://dbknowledge.tistory.com/48
- https://medium.com/postgres-professional/indexes-in-postgresql-5-gist-86e19781b5db
