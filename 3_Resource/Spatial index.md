---
title: Spatial index
date: 2024-01-17 17:50:00 +0900
aliases: 
tags:
  - spatial-index
  - index
  - postgis
  - geometry
categories: 
updated: 2024-02-22 17:58:00 +0900
---

매우 비효율적이였던 기존 구현 방식을 설명하고, 개선하기 위해 시도한 방법들을 기록합니다.

## 기존 문제점

![](https://i.imgur.com/wPORK6n.png)

_한 번의 쿼리로 여러 DB 에 흩어진 테이블을 join 하는 것은 불가능하진 않지만 어려웠다...

1. 특정 좌표가 a 라는 영역에 포함되어 있는가?
2. 물리적으로 다른 서버에 존재하는 테이블로 인해 join 쿼리를 작성하기 어려웠음
    1. 왜 한방 쿼리여야 하는가? 조회해야하는 데이터의 사이즈가 매우 크기 때문에 애플리케이션 메모리로 로드되는 양을 최대한 줄이고 싶었음
3. DB 조인이 안되기 때문에 애플리케이션 조인을 해야 했고 60000 * 40000 = 24억 정도의 루프가 발생했음
    1. 파티션 처리를 통해 최대한 처리시간을 줄였으나, 여전히 루프로 인해 CPU 부하가 매우 심했다
4. 물리적으로 다른 데이터베이스를 마이그레이션 과정을 통해 하나로 합치게 되었고, 조인이 가능해지면서 고대하던 쿼리 최적화의 기회를 얻게 됨

## 해결 방향

그동안 데이터베이스의 조인을 사용하지 못했던 가장 큰 원인이 해결된 상황이였기 때문에 적극적으로 인덱스 스캔을 활용한 geometry 처리 방법을 고민해봤다.

[[PostGIS]] 의 GIST index 를 사용하면 R-tree 와 유사한 공간 인덱스를 생성할 수 있고, 인덱스 스캔을 통해 쿼리에서 바로 조회할 수 있을 것이라 생각했다.

공간 인덱스를 사용하기 위해서는 geometry 타입의 컬럼이 필요하다.

기존에는 위경도 좌표는 있었지만 geometry 타입은 없었기에, 위경도를 사용하여 geometry POINT 값을 먼저 생성해줘야 한다.

인덱스를 먼저 생성해주고,

```postgresql
CREATE INDEX idx_port_geom ON port USING GIST (geom);
```

[[PostGIS]] 의 `contains` 함수를 실행해봤다.

```postgresql
SELECT *
FROM ais AS a
JOIN port AS p ON st_contains(p.geom, a.geom);
```

![](https://i.imgur.com/aMFmfCh.png)
_Awesome..._

GIST 인덱스의 동작 원리 설명

## 적용 결과

### spatial index 적용 전

1m 47s ~ 2m 30s

### spatial index 적용 후

0.23ms ~ 0.243ms

## 결론

- 애플리케이션 메모리에 데이터를 불필요하게 로드할 필요가 없어짐
- 루프로 인한 CPU 부하가 해소

## Reference

- [Spatial Indexing](https://postgis.net/workshops/postgis-intro/indexing.html)
