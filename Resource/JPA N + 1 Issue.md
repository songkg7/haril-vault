---
title: JPA N + 1 Issue
date: 2023-09-03 15:01:00 +0900
aliases:
  - N + 1
tags:
  - jpa
  - orm
categories: 
updated: 2023-09-03 16:09:43 +0900
---

연관관계를 사용하다보면 발생할 수 있는 문제.

집사와 고양이 엔티티가 있다고 가정해보자. 집사는 10마리의 고양이를 키운다.

10명의 집사는 각각 10마리의 고양이를 키운다.

집사를 조회하면?

```sql
select * from owner o where o.id;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
select * from cat c where c.owner_id = ?;
```

집사를 조회하는 쿼리 1번, 고양이를 조회하는 쿼리가 10번 발생한다. 이 현상을 우리는 N+1 문제라고 부른다.

## Solution

### 1. Fetch Join

Fetch Join 을 사용하면 실제로 inner join 이 호출되면서 한번에 조회할 수 있다.

```java
@Query("select o from Owner o join fetch o.cats")
List<Owner> findAllJoinFetch();
```

```sql
select * from Owner o inner join Cat c on o.id = c.owner_id;
```

다만, `FetchType.LAZY` 는 더 이상 의미가 없어지게 된다. 조회 시점에 모든 데이터를 불러오기 때문이다. 또한, 페이징 쿼리를 사용할 수 없다. 하나의 쿼리로 가져오다보니 페이징 단위로 가져오는 것이 불가능하다.

### 2. EntityGraph

@EntityGraph 의 attributePaths에 쿼리 수행시 바로 가져올 필드명을 지정하면 Lazy가 아닌 Eager 조회로 가져오게 된다. Fetch join과 동일하게 JPQL을 사용하여 query 문을 작성하고 필요한 연관관계를 EntityGraph에 설정하면 된다. 그리고 Fetch join과는 다르게 join 문이 outer join으로 실행되는 것을 확인할 수 있다.

```java
@EntityGraph(attributePaths = "cats")
@Query("select o from Owner o")
List<Owner> findAllEntityGraph();
```

```sql
 select * from Owner o left outer join Cat c on o.id = c.owner_id;
```

> [!WARNING] 
>  Fetch Join과 EntityGraph는 JPQL을 사용하여 JOIN문을 호출한다는 공통점이 있다. 또한, 공통적으로 카테시안 곱(Cartesian Product)이 발생하여 Owner의 수만큼 Cat이 중복 데이터가 존재할 수 있다. 그러므로 중복된 데이터가 컬렉션에 존재하지 않도록 주의해야 한다.

####  그렇다면 어떻게 중복된 데이터를 제거할 수 있을까?

- 컬렉션을 Set을 사용하게 되면 중복을 허용하지 않는 자료구조이기 때문에 중복된 데이터를 제거할 수 있다.
- JPQL을 사용하기 때문에 distinct를 사용하여 중복된 데이터를 조회하지 않을 수 있다.

### 3. FetchMode.SUBSELECT

두 번의 쿼리로 해결하는 방법이다.

### 4. BatchSize

BatchSize 의 개수만큼 아이디를 모아서 in 절로 쿼리하는 방법이다.

### 5. QueryBuilder

로직에 최적화된 쿼리를 생성해주는 플러그인을 사용하는 방법이다.

## Links

- [[Java Persistence API|JPA]]
- [[Spring Data JPA|Spring Data JPA]]

## Reference

- https://incheol-jung.gitbook.io/docs/q-and-a/spring/n+1
