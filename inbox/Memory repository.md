---
title: "Memory repository"
date: 2022-09-08 09:49:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-08
aliases: 
tags: [java, library, memory]
categories: 
---

[[Spring batch]] 를 사용하면서 아쉬웠던 점은 Step 간 데이터를 원활하게 공유하기 위한 일종의 상태 저장소가 없다는 것이다. 물론 ExecutionContext 라는 데이터 공유 방법이 있지만, 데이터는 직렬화 되어 전달되며 최대 2500자까지만 가능하기 때문에 대량의 데이터를 전달하는 것에는 적합하지 않고, 거대한 비즈니스 처리 단위가 아닌 별개의 작업 집합이라는 스프링 배치의 철학에도 부합하지 않는다.

따라서 부득이하게 배치 과정에서 대량의 데이터를 다음 step 에 전달해야할 경우, 어디에 저장해놔야할 것인가에 대한 고민이 필연적으로 생길 수밖에 없다. 예를 들면 다음과 같은 경우가 있겠다.

1. A step 에서 A entity 를 처리하게끔 설계하였다. 하지만 A entity 의 처리를 위해서는 B entity 가 필요하다.
2. A step 에 구성된 reader 는 A entity reader 이므로 B entity reader 를 구성하기 위해 B step 를 구현하였다.
3. 이제 Job 은 B step -> A step 순서로 실행된다. 하지만 B step 에서 읽어온 B entity 를 A step 에서 사용할 수 있을까?




## 장점 및 단점

- 간단하게 사용이 가능하다. read only 로 구현하였으며, thread-safe 하기 때문에 멀티 쓰레드에서도 안전하다.
- JPA 의 naming convention 을 참고하였기 때문에 모든 method 는 예상하는대로 동작한다.

- in-memory 기반이기 때문에 재실행할 경우 offset 을 알 수 없고, 다시 memory 로 불러오는 작업을 거쳐야 한다. 만약 memory 에 저장해야하는 데이터가 부담스러울 정도로 클 경우는 [[Redis]] 같은 외부 memory 기반 저장소를 사용하는 것이 좋다.


## Reference

- [docs.spring](https://docs.spring.io/spring-batch/docs/current/reference/html/common-patterns.html#passingDataToFutureSteps)