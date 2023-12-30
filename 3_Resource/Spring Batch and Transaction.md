---
title: Spring Batch 와 Transaction 의 상관관계
date: 2023-08-26 13:59:00 +0900
aliases: null
tags: spring-batch, transaction, job, batch
categories: Spring
updated: 2023-08-26 14:09:41 +0900
---

[[Spring Batch]] 에서 [[Job]] 을 [[Transaction]] 안에서 실행하려고 하면 다음과 같은 에러를 만나게 된다.

```java
@Transactional
public void runJob() {
    jobLauncher.run(job, jobParameters)
}
```

```
Existing transaction detected in JobRepository. Please fix this and try again (e.g. remove @Transactional annotations from client).
```

Exception 을 제거하려면 `@Transactional` 을 제거해야 한다. 스프링 배치의 기본 설정이 [[JobRepository]] 외부 트랜잭션을 허용하지 않기 때문이다.

### Why

[Check for existing transaction when job is started (and fail if present by default) [BATCH-1668]](https://github.com/spring-projects/spring-batch/issues/1916)

TaskletStep 을 `@Transactional` 이 붙은 메서드에서 실행했는데 두 번째 Chunk 를 처리하던 도중 데드락이 발생한 이슈가 있었다.

StepExecution 을 업데이트할 때 세마포어를 획득해야하지만, 세마포어를 획득하지 못하고 데드락이 발생했다는 것이 이슈의 내용이다.

세마포어를 풀어주는 부분이 어디 있었을까? 세마포어는 `TransactionSyncronizationAdapter` 의 afterCompletion 을 구현하여 트랜잭션 커밋 후에 세마포어를 풀도록 되어 있었다. 근데 문제는 afterCompletion 이 호출되지 않은 것이다. 왜 호출되지 않았을까?

문제는 간단하다. `@Transactional` 로 인해 commit 시점이 afterCompletion 보다 뒤로 밀렸기 때문이다. `@Transational` 은 기본적으로 부모 트랜잭션의 범위를 물려받으면서 동작한다. 따라서 내부 트랜잭션 범위보다 큰 메서드에 `@Transational` 을 사용할 경우 내부 트랜잭션이 커밋되지 못하고, 결과적으로 afterCompletion 보다 일찍 커밋되지 못한 것이다.

그렇다면 Transational 의 propagation 옵션을 사용하여 매번 새로운 트랜잭션이 생성되도록 하면 문제가 해결되지 않을까?? 안타깝게도 여기에도 문제는 있다. 외부 트랜잭션과 내부 트랜잭션에서의 StepExecution 일관성이 깨지게 될 수 있다. 그리하여 Job 실행 외부에서 임의로 트랜잭션을 시작하지 못하도록 한 것이다.

## Conclusion

Spring Batch 는 [[Job]] 과 [[Step]] 의 실행 상태(JobInstance, JobExecution, StepExecution)를 관리하는 [[JobRepository]] 가 있다. JobRepository 의 오퍼레이션에 외부 트랜잭션이 개입하지 못하도록 Job 실행시점에 열려있는 외부 트랜잭션이 존재하는지 검사한다. 만약 트랜잭션이 활성화되어 있다면 익셉션을 던져 Job 의 실행을 중단한다.

## Reference

- https://brunch.co.kr/@anonymdevoo/50
