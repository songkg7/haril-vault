---
title: Kafka
date: 2024-08-15T21:47:00
aliases:
tags:
  - kafka
categories:
description:
updated: 2026-01-31T17:27
---

## Monitoring

- [AKHQ](https://github.com/tchiotludo/akhq)
- [kafbat ui](https://github.com/kafbat/kafka-ui)
-  [Quick start | Kafbat UI](https://ui.docs.kafbat.io/configuration/helm-charts/quick-start)

## 핵심 개념

### 아키텍처 개요
- **브로커(Broker)**: 메시지를 저장하고 전달하는 서버 노드이다. 클러스터는 여러 브로커로 구성된다.
- **토픽(Topic)**: 메시지의 논리적 스트림이다. 동일 토픽 내 메시지는 목적/스키마가 유사하다는 전제가 있다.
- **파티션(Partition)**: 토픽의 물리적 분할 단위이다. 파티션 단위로 순서가 보장되며, 병렬 처리와 확장성을 제공한다.
- **복제(Replication)**: 파티션은 복제되어 고가용성을 확보한다. 리더/팔로워 구조로 동작한다.

### 메시지 흐름
- **프로듀서(Producer)**가 토픽에 메시지를 기록한다.
- **컨슈머(Consumer)**가 토픽을 읽는다.
- **컨슈머 그룹(Consumer Group)**은 파티션을 분산 처리한다. 동일 그룹 내에서는 한 파티션을 하나의 컨슈머가 담당한다.

### 전달 보장(Delivery Semantics)
- **At most once**: 중복 없이 손실 가능.
- **At least once**: 손실 없이 중복 가능.
- **Exactly once**: 중복/손실을 모두 방지한다. 트랜잭션과 idempotent producer 설정이 필요하다.

### 순서 보장과 키
- 순서는 **파티션 단위**로만 보장된다.
- 동일 키는 동일 파티션으로 라우팅되어 순서 보장이 가능하다.
- 키 설계는 파티션 분산과 처리 순서 요구를 동시에 고려해야 한다.

### 오프셋(Offset)
- 각 메시지는 파티션 내에서 증가하는 오프셋을 가진다.
- 컨슈머는 오프셋을 커밋하여 읽은 위치를 기록한다.
- 오프셋 커밋 전략(자동/수동)에 따라 재처리 여부와 안정성이 달라진다.

### 토픽 설정의 핵심 파라미터
- **replication.factor**: 데이터 내구성과 가용성 수준.
- **min.insync.replicas**: 안전한 쓰기 보장의 기준.
- **retention.ms / retention.bytes**: 보관 기간/용량.
- **cleanup.policy**: 삭제(delete) 또는 압축(compact).

### 컴팩션(Compaction)
- 동일 키의 최신 레코드만 유지하는 정책이다.
- 상태 저장형 스트림이나 캐시 성격의 데이터에 적합하다.

### 장애와 리밸런싱
- 브로커 장애 시 리더가 교체된다.
- 컨슈머가 추가/이탈하면 리밸런싱이 발생하고 파티션 재할당이 진행된다.
- 잦은 리밸런싱은 처리 지연을 유발할 수 있어 파티션 수, 세션 타임아웃 등을 함께 고려해야 한다.
