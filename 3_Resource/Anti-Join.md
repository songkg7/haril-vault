---
title: Anti-Join
date: 2024-01-23 10:23:00 +0900
aliases: 
tags:
  - sql
  - join
  - rdb
categories: 
updated: 2024-10-05 11:44:36 +0900
---

[[PostgreSQL]]

## Anti-Join

Anti-Join은 두 개의 데이터 집합 중에서 첫 번째 데이터 집합에는 존재하지 않고 두 번째 데이터 집합에만 존재하는 값을 찾는 연산입니다.

일반적으로 SQL에서는 INNER JOIN, LEFT JOIN, RIGHT JOIN과 같은 조인 연산을 사용하여 데이터를 결합하는 작업을 수행합니다. 그러나 때로는 첫 번째 데이터 집합에서 제외되는 값을 찾기 위해 Anti-Join이 필요할 수 있습니다.

Anti-Join은 다음과 같은 SQL 구문으로 표현될 수 있습니다:

```sql
SELECT *
FROM table1
WHERE NOT EXISTS (
    SELECT 1
    FROM table2
    WHERE table2.id = table1.id
)
```

이 쿼리는 table1의 id 값이 table2의 id 값과 일치하지 않는 모든 레코드를 반환합니다. 따라서 Anti-Join은 첫 번째 데이터 집합에서 제외되는 값을 찾기 위해 사용됩니다.

Anti-Join은 대용량 데이터셋과 빠른 성능을 요구하는 경우 유용할 수 있습니다. `EXCEPT` 구문에 비해 3배 가까이 빠른 성능을 보여줄 수 있습니다.

`LEFT JOIN` 은 `NOT EXISTS` 와 같은 성능을 보여줍니다. left join 이 일반적으로 포함하는 행만 보여줘야 하므로 where 절에 is null 을 포함하면 not exists 와 같은 효과를 볼 수 있습니다.

## Reference

- https://www.crunchydata.com/blog/rise-of-the-anti-join
