---
title: "Sharded Cluster"
date: 2022-12-16 21:49:00 +0900
aliases: 
tags: [mongodb]
categories: MongoDB
---

## Concept

모든 Shard 는 Replica Set 으로 구성되어 있다.

## Pros & Cons

- 용량의 한계를 극복할 수 있다.
- 데이터 규모와 부하가 크더라도 처리량이 좋다.
- 고가용성을 보장한다.
- 하드웨어에 대한 제약을 해결할 수 있다.

- 관리가 비교적 복잡하다.
- Replica Set 과 비교해서 쿼리가 느리다.

## Compare

## Sharding Collections

일부 컬렉션의 경우 분산하지 않는 것이 유리한 경우가 있을 수 있다.

데이터가 분산되어 있으면 각각 조회해야하고 머지하는 시간이 필요하기 때문에 일반적으로 Replica Set 보다 느리다.

## Ranged Sharding

- 샤드 키를 지정한 타겟 쿼리
- 빠르게 조회 가능
- 샤드가 어떻게 분산되어 있는지 알 수 있는 경우 사용 가능
- 데이터가 균형있게 분산되어 있지 않을 경우 문제가 될 수 있음
- hash sharding 을 사용하지 못하는 경우 주로 사용

## Hashed Sharding

- 샤드 키의 hash function 결과값을 이용해서 chunk 에 할당
- 매우 균등하게 분산이 잘 됨
- hash 값의 카디널리티가 높으면?
- 범위 검색에 불리
- Sharding 의 경우 데이터를 고르게 분산시키는게 목적이기 때문에 대부분의 경우는 Hashed sharding 을 사용하게 된다.

## Zone Sharding



## Conclusion

- Sharded Cluster 는 MongoDB 의 분산 Solution 이다.
- Collection 단위로 Sharding 이 가능하다.
- Sharding 은 Shard Key 를 선정해야하고 해당 필드에는 Index 가 만들어져 있어야 한다.
- 꼭 Router 를 통해 접근한다.
- 가능하면 Hashed Sharding 을 통해 분산한다.
