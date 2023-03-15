---
title: "JdbcItemReader sortKeys 설정시 주의사항"
date: 2023-03-06 16:46:00 +0900
aliases: 
tags: [postgresql, rdb, spring, batch]
categories: 
---

[[PostgreSQL]]에서  대용량 데이터를 조회하며 겪었던 문제에 대해 공유합니다.

## Contents

[[Spring Batch]] `JdbcPagingItemReader` 를 사용 중 `sortKeys` 를 다음과 같이 설정했다.

```java
...
	.selectClause("SELECT *")
	.fromClause("FROM big_partitioned_table_" + yearMonth)
	.sortKeys(Map.of(
					"timestamp", Order.ASCENDING,
					"mmsi", Order.ASCENDING,
					"imo_no", Order.ASCENDING
			)
	)
...
```

현재 table 의 index 는 `timestamp`, `mmsi`, `imo_no` 가 함께 복합 인덱스로 설정되어 있기 때문에 조회시 index scan 이 일어날 것이라 예상했지만, 실제로는 seq scan 이 발생했다. 대상 테이블은 2억건 정도의 데이터가 존재하는 테이블이여서 배치가 끝날 기미를 보이지 않았고, 결국 강제로 batch 를 shutdown 시켜야 했다. 왜 index 조건으로 조회하는데도 seq scan 이 일어날까? 🤔

PostgreSQL 에서 Seq scan 을 하는 경우는 다음과 같다.

- 테이블의 데이터가 많지 않아서 seq scan 을 하는 것이 더 빠르다고 optimizer 가 판단한 경우
- 혹은 조회하려는 데이터가 너무 많아서(테이블의 약 10% 이상) index scan 이 seq scan 보다 비효율적이라고 판단한 경우. index scan 은 건별로 IO 
- Index scan 으로 반환되어야 하는 데이터가 너무 많은 경우. 이럴 때는 `limit` 을 통해 index scan 으로 수행시킬 수 있다.

그럼 정확한 원인 파악을 위해 실제 발생한 쿼리를 확인해보자. yaml 의 설정을 약간만 수정하면 `JdbcPagingItemReader` 가 실행하는 쿼리를 확인할 수 있다.

```yaml
logging:
  level.org.springframework.jdbc.core.JdbcTemplate: DEBUG
 ```

다시 배치를 실행시켜서 쿼리를 직접 확인해봤다.

```sql
SELECT * FROM big_partitioned_table_202301 ORDER BY imo_no ASC, mmsi ASC, timestamp ASC LIMIT 1000
```

`order by` 구문의 순서가 뭔가 이상해서 다시 실행시켜봤다.

```sql
SELECT * FROM big_partitioned_table_202301 ORDER BY timestamp ASC, mmsi ASC, imo_no ASC LIMIT 1000
```

실행할 때마다 order by 조건이 변하는 것을 확인할 수 있다. index scan 을 위해서는 정확한 순서로 정렬 조건을 지정해줘야 하므로 순서를 보장하지 않는 일반적인 `Map` 을 sortKeys 에 전달했기 때문에 발생한 문제다.

순서를 보장하려면 `LinkedHashMap` 을 사용할 수 있다.

```java
Map<String, Order> sortKeys = new LinkedHashMap<>();
sortKeys.put("timestamp", Order.ASCENDING);
sortKeys.put("mmsi", Order.ASCENDING);
sortKeys.put("imo_no", Order.ASCENDING);
```

이후 배치를 다시 실행해보면 정확한 순서로 정렬 조건이 지정되는 것을 확인할 수 있다.

```sql
SELECT * FROM big_partitioned_table_202301 ORDER BY timestamp ASC, mmsi ASC, imo_no ASC LIMIT 1000
```

## Conclusion

index scan 이 아닌 seq scan 이 발생하던 문제는 테스트 코드로 검증이 안되는 부분이기 때문에 버그가 있는지도 모르고 있었다. 실제 운영환경에서 간헐적으로 1000배 가까이 배치의 속도가 저하되는 모습을 보고서야 뭔가 문제가 있다는걸 알게 되었는데, `Map` 자료구조로 인해서 정렬 조건이 계속 변할 줄은 개발 당시에는 미처 생각하지 못했다.

그나마 조회하려는 대상 테이블의 데이터가 많아서 index scan 이 실행되지 않는다면 굉장히 느려지기에 금방 눈치챌 수 있었지만, 만약 데이터의 수가 적어서 index scan 과 seq scan 이 비슷한 실행속도였다면 꽤 오래 눈치채지 못했을 수도 있을 것 같다.

여전히 index 관련 문제는 테스트 코드를 작성하지 못했는데, 어떻게 하면 이 문제를 사전에 파악할 수 있을지는 고민이 좀 더 필요할 것 같다.

다만, `order by` 조건은 순서가 중요한 경우가 많으므로 `HashMap` 보다 `LinkedHashMap` 을 써야 안전하다고 코드 리뷰를 남기는 방향이 현상황에서 가장 이상적일 것 같다.
