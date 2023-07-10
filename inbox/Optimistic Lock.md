---
title: "Optimistic Lock"
date: 2023-07-10 12:37:00 +0900
aliases: 
tags: [database, transaction]
categories: 
updated: 2023-07-10 12:38:09 +0900
---

## What is Optimistic Lock?

Optimistic lock is a concurrency control mechanism used in database management systems to prevent conflicts between multiple users or processes accessing and modifying the same data concurrently. It is based on the assumption that conflicts between concurrent transactions are rare, therefore allowing multiple transactions to proceed simultaneously without blocking each other.

In optimistic lock, when a transaction wants to modify a piece of data, it first reads the data and records a version number or timestamp associated with that data. When the transaction is ready to commit, it checks if the version number or timestamp of the data has changed since it read it. If the version number has not changed, it proceeds with the commit. However, if the version number has changed, it means another transaction has modified the data in the meantime, and a conflict has occurred.

In case of a conflict, optimistic lock usually aborts the transaction and starts over by re-reading the data and applying any necessary modifications again. This ensures that only one transaction can successfully commit its changes while others are forced to retry.

Optimistic lock is considered optimistic because it assumes conflicts are rare and allows transactions to proceed without blocking each other until a conflict occurs. It provides better scalability and performance compared to pessimistic locking mechanisms that block concurrent transactions from accessing data simultaneously. However, it requires careful handling of conflicts and potential rollback of transactions.

옵티미스틱 락(Optimistic Lock)은 데이터베이스 관리 시스템에서 여러 사용자 또는 프로세스가 동시에 동일한 데이터에 접근하고 수정하는 것을 방지하기 위해 사용되는 동시성 제어 메커니즘입니다. 이는 동시 트랜잭션 간의 충돌이 드물다는 가정을 기반으로 하므로, 서로를 차단하지 않고 여러 트랜잭션이 동시에 진행될 수 있습니다.

옵티미스틱 락에서 트랜잭션이 데이터를 수정하려면 먼저 데이터를 읽고 해당 데이터와 연결된 버전 번호 또는 타임스탬프를 기록합니다. 트랜잭션이 커밋할 준비가 되면, 읽은 이후로 데이터의 버전 번호나 타임스탬프가 변경되었는지 확인합니다. 버전 번호가 변경되지 않았다면 커밋을 진행합니다. 그러나 버전 번호가 변경된 경우, 다른 트랜잭션이 그동안 데이터를 수정한 것을 의미하며 충돌이 발생한 것입니다.

충돌이 발생한 경우, 옵티미스틱 락은 일반적으로 트랜잭션을 중단하고 데이터를 다시 읽고 필요한 수정을 다시 적용하여 재시작합니다. 이를 통해 하나의 트랜잭션이 성공적으로 변경 사항을 커밋하고 나머지는 다시 시도해야 합니다.

옵티미스틱 락은 충돌이 드물다는 가정을 기반으로 하여 동시 트랜잭션이 충돌이 발생할 때까지 서로를 차단하지 않고 진행할 수 있기 때문에 낙관적인(Optimistic)이라고 간주됩니다. 비관적인 락 메커니즘과 비교하여 확장성과 성능이 우수합니다. 그러나 충돌 처리와 잠재적인 롤백 처리에 주의가 필요합니다.

## Links

[[Pessimistic Lock]]
