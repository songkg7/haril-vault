---
title: 비관적 락
date: 2023-09-29T20:07:00
aliases: 
tags:
  - rdb
  - database
  - transaction
categories: 
updated: 2025-01-07T00:35
---

Pessimistic Locking refers to a concurrency control mechanism in computer systems that assumes conflicts will occur and locks resources to prevent concurrent access. This approach is pessimistic because it assumes that conflicts will happen, and takes the precaution of locking resources to avoid them.

In pessimistic locking, when a transaction wants to access a resource, it requests a lock on that resource. The lock prevents any other transaction from accessing or modifying the resource until the lock is released. This ensures that the resource remains consistent and prevents conflicts.

There are two types of locks used in pessimistic locking:

1. Shared Lock: Also known as a read lock, this allows multiple transactions to read the same resource simultaneously but prevents any transaction from modifying it until all shared locks are released.
2. Exclusive Lock: Also known as a write lock, this allows only one transaction at a time to access or modify a resource. Any other transaction attempting to obtain an exclusive lock on the same resource will have to wait until the lock is released.

Pessimistic locking is commonly used in database management systems (DBMS) to ensure data integrity and consistency. It is particularly useful in scenarios where conflicts are likely to occur, such as when multiple transactions try to update the same data concurrently.

However, pessimistic locking can also have drawbacks. It can lead to decreased concurrency and performance since transactions may have to wait for resources which may be locked by other transactions for an extended period of time. Additionally, if locks are not managed properly, it can also result in deadlocks, where two or more transactions are waiting indefinitely for each other's locks to be released.

Overall, pessimistic locking provides a cautious approach to concurrency control by assuming conflicts will occur and actively preventing them through resource locks.

비관적인 잠금은 컴퓨터 시스템에서 동시 액세스를 방지하기 위해 리소스를 잠그는 동시성 제어 메커니즘을 가리킵니다. 이 방법은 **충돌이 발생할 것으로 가정**하고, 충돌을 피하기 위해 리소스를 잠그는 접근 방식입니다.

스비관적 잠금에서 트랜잭션이 리소스에 액세스하려면 해당 리소스에 대한 잠금을 요청합니다. 이 잠금은 다른 트랜잭션이 해당 리소스에 액세스하거나 수정하는 것을 방지하여 리소스의 일관성을 유지하고 충돌을 방지합니다.

비관적 잠금에는 두 가지 유형의 잠금이 사용됩니다:

1. 공유 잠금: 읽기 잠금이라고도하는 이 유형은 여러 트랜잭션이 동시에 동일한 리소스를 읽을 수 있지만, 모든 공유 잠금이 해제 될 때까지 해당 리소스를 수정할 수 없습니다.
2. 배타적 잠금: 쓰기 잠금이라고도하는 이 유행은 한 번에 한 개의 트랜잭션만 리소스에 액세스하거나 수정할 수 있습니다. 동일한 리소스에 대한 배타적 잠금을 얻으려는 다른 트랜잭션은 잠금이 해제 될 때까지 대기해야합니다.

비관적 잠금은 데이터 무결성과 일관성을 보장하기 위해 데이터베이스 관리 시스템 (DBMS)에서 주로 사용됩니다. 특히 여러 트랜잭션이 동시에 동일한 데이터를 업데이트하려고 할 때와 같이 충돌이 발생할 가능성이 있는 시나리오에서 유용합니다.

그러나 비관적 잠금은 단점도 가지고 있을 수 있습니다. 다른 트랜잭션이 장기간에 걸쳐 다른 트랜잭션에 의해 잠겨있을 수있는 리소스를 기다려야하는 경우, 동시성과 성능이 감소할 수 있습니다. 또한, 잠금이 올바르게 관리되지 않는 경우 [[Dead Lock]] 이 발생할 수도 있으며, 이는 두 개 이상의 트랜잭션이 서로의 잠금이 해제 될 때까지 무기한으로 기다리는 상황입니다.

전반적으로 비관적 잠금은 충돌이 발생할 것으로 가정하고 리소스 잠금을 통해 적극적으로 충돌을 방지하는 조심스러운 접근 방식을 제공합니다.

## Links

- [[Transaction|Transaction]]
