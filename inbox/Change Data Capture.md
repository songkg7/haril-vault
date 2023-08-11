---
title: CDC
date: 2023-08-11 10:14:00 +0900
aliases: CDC
tags: cdc, event, distribute
categories: null
updated: 2023-08-11 17:16:02 +0900
---

## CDC 의 개념과 동작 방식

CDC 는 Change Data Capture 의 약자로, 소스 시스템에서 데이터가 변경된 것을 감지하여 타깃 시스템이 변경 작업에 대응하는 작업을 수행하도록 하는 프로세스. CDC 를 사용한다면 데이터를 사용하는 모든 시스템에서 일관성을 유지할 수 있다는 장점이 있다.

CDC 에서 데이터 변경을 감지하는 방법

- Pull 방식: 타깃 시스템에 주기적을 풀링으로 변경 사항이 있는지 확인하는 방법. 쉽게 구현할 수 있지만 실시간성이 떨어진다는 단점 또한 있다.
- Push 방식: 소스 시스템이 변경이 발생할 때마다 타깃 시스템에 알려주는 방법. Pull 방식에 비해 소스 시스템이 많은 작업을 해야 하고, 타깃 시스템에 문제가 발생한다면 변경 이벤트에 누락이 발생할 수 있지만, 실시간성이 뛰어나다는 장점이 있다.

Push 방식에서 이벤트 누락의 단점을 메시지큐인 Kafka 를 통해 해결하여 CDC 시스템을 만드는 것이 바로 Kafka CDC

DB 로부터 데이터의 변경 이벤트를 감지해서 Kafka 이벤트를 발행해 주는 것이 바로 Debezium MySQL Connector 이다.

## Kafka CDC 를 사용할 때 주의할 것

### AWS Aurora 환경에서 쓰기 부하가 많은 경우

Debezium [[MySQL]] Connector 를 연동하면 binlog dump thread 가 Aurora MySQL 클러스터 스토리지의 binlog 를 읽는데, 이 때 잠시 락을 걸게 된다. 만약 binlog dump thread 의 부하가 심해지는 경우 INSERT, UPDATE, DELETE, COMMIT 등 DML 관련 레이턴시가 증가하게 되고, 이에 따라 장애가 발생할 수 있게 된다.

### 중복 메시지 발생의 가능성

여러 가지 경우로 Kafka 메시지는 중복될 수 있다. Redis Cache 를 이용하여 문제를 해결할 수 있다.

```kotlin
class CdcEventListener(
    private val cdcEventProcessor: List<CdcEventProcessor>,
) {
    // ...
    @PostConstruct
    protected fun init() {
        disposable = sinks.asFlux()
            // ...
            // 이벤트를 처리 하는 과정에서 doCheckDuplicationPrevent 으로 중복 확인 
            .flatMap(::doCheckDuplicationPrevent)
            // ...
    }

    private fun doCheckDuplicationPrevent(cdcRecords: List<Envelope>): Mono<List<Envelope>> {
        return Mono.fromCallable {
            cdcRecords.filter {
                // HashCode를 이용한 RedisKey 생성
                val key = RedisCacheType.DUPLICATION_PREVENT.addPostfix(name = "${it.getAfter().getId()}:${it.hashCode()}")
                // 해당 Key가 이미 존재하는지 확인
                val existKey = redisTemplate.opsForValue().existKey(
                    key = key
                )
                log.debug(
                    "[CDC][EventEmitterSinks] Check Duplication Prevent. Key = `{}`, Value = `{}`",
                    key, existKey
                )
                (!existKey)
            }
        }.subscribeOn(Schedulers.boundedElastic())
    }
}
```

## 마무리
