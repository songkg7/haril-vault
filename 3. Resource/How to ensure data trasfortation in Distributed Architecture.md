---
title: 분산 시스템에서의 데이터 전달 보장 방법
date: 2023-09-04 10:35:00 +0900
aliases: []
tags:
  - distribution
  - kafka
  - message-queue
  - rebbitmq
  - rdb
  - transaction
categories: 
updated: 2023-09-04 10:35:01 +0900
---

## 분산 시스템에서 데이터 전달 보장 방법

### Remote API 를 사용한 데이터 전달

- 서버-클라이언트 구조
- 사용자 요청에 즉각 응답하는 API에서 주로 사용하는 방식
- 비교적 간단한 개발

### MessageQueue 를 사용한 데이터 전파

- Publisher - Consumer 구조
- 배치 작업, 비동기 작업에서 주로 사용
- 비교적 복잡한 개발

분산 시스템에서 컴포넌트들은 네트워크로 연결

- 네트워크는 시스템을 연결하는 유일한 수단
- 하지만 네트워크는 신뢰할 수 없는 매체
- 항상 데이터 유실에 대비
- At most once(최대 한 번)
- At Least Once(최소한 한 번)
- 정확하게 한 번

### 서비스별 데이터베이스 패턴

- 마이크로 서비스 아키텍처 패턴
- DB 는 롤백되는데 이벤트는 발행되는 문제가 생길 수 있다.
- @TransactionalEventListener, @Retryable 로 commit 이후에 이벤트 발행이 되도록 컨트롤할 수 있다.
    - 하지만 네트워크는 문제가 생겼을 때 언제 복구될지 알 수 없으므로, 아래 두가지 패턴으로 보완할 수 있다.
    - [[Transactional Outbox Pattern]]
    - Polling Publisher Pattern(약간의 지연이 있다)

### RabbitMQ 를 사용한 전달 방법

- AMQP
- pub/sub
- ACK 메세지 응답 처리 메커니즘

ack nack 를 개발자가 직접 컨트롤하는 방법을 제공

처리하지 못하는 메세지는 dead letter queue 를 별도로 사용하여 분리

### Kafka 를 사용한 전달 방법

- Producer Confirm 을 사용하여 콜백으로 결과를 전달받을 수 있다.
- Consumer ACK - AcknowledgingMessageListener

## Links

- [[Kafka]]

## Reference

- [NHN Dooray](https://www.youtube.com/watch?v=uk5fRLUsBfk)
