---
title: "Pessimistic Lock"
date: 2023-07-10 12:38:00 +0900
aliases: 
tags: [database, transaction]
categories: 
updated: 2023-07-10 12:39:42 +0900
---

## What is Pessimistic Lock?

Pessimistic lock is a concurrency control mechanism used in computer systems to prevent multiple users or processes from accessing and modifying a shared resource simultaneously. It is based on the assumption that conflicts are likely to occur, and thus, locks are acquired on the resource before any operation is performed.

In pessimistic locking, when a user or process wants to access a shared resource, it requests a lock on that resource. If the lock is available, it grants the lock to the requester and blocks any other requests for the same lock until it is released. This ensures that only one user or process can access and modify the resource at a time.

Pessimistic locking is often used in situations where conflicts or data integrity issues are expected to occur frequently. It provides strict synchronization and ensures data consistency by preventing concurrent modifications. However, it can also lead to increased contention and decreased performance if locks are held for long periods of time.

Common implementations of pessimistic locking include using mutexes, semaphores, or database locks. These locks can be acquired at different levels, such as row-level locking in databases or file-level locking in operating systems, depending on the granularity required.

Overall, pessimistic locking provides a reliable way to manage concurrent access to shared resources but may come at the cost of reduced concurrency and performance.

비관적 락은 컴퓨터 시스템에서 여러 사용자나 프로세스가 동시에 공유 리소스에 접근하고 수정하는 것을 방지하기 위해 사용되는 동시성 제어 메커니즘입니다. 충돌이 발생할 가능성이 높다는 가정에 기반하여 작동합니다. 

비관적 락에서는 사용자나 프로세스가 공유 리소스에 접근하려면 해당 리소스에 대한 락을 요청합니다. 만약 락이 사용 가능하다면, 요청한 사람에게 락을 부여하고 다른 동일한 락에 대한 요청은 차단됩니다. 이를 통해 한 번에 하나의 사용자나 프로세스만 리소스에 접근하고 수정할 수 있도록 보장합니다.

비관적 락은 충돌이나 데이터 일관성 문제가 자주 발생할 것으로 예상되는 상황에서 자주 사용됩니다. 엄격한 동기화를 제공하며, 동시 수정을 방지하여 데이터 일관성을 보장합니다. 그러나, 락이 오랜 시간 유지된다면 경합(concurrency)의 증가와 성능 감소를 야기할 수도 있습니다.

비관적 락의 일반적인 구현 방법으로는 뮤텍스, 세마포어, 데이터베이스 락 등을 사용합니다. 필요한 정밀도에 따라 데이터베이스에서는 행 수준의 락을 사용하거나 운영 체제에서는 파일 수준의 락을 사용할 수 있습니다.

전반적으로 비관적 락은 공유 리소스에 대한 동시 접근을 관리하는 신뢰성 있는 방법을 제공하지만, 동시성과 성능이 감소할 수 있다는 비용이 발생할 수 있습니다.

## Links

[[Optimistic Lock]]
