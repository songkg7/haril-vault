---
title: Two Phase Commit
date: 2023-08-10 20:41:00 +0900
aliases: 2PC
tags: msa, atomic, distribution
categories: null
updated: 2023-08-11 17:41:30 +0900
---

## What is Two Phase Commit?

Two Phase Commit (2PC) is a distributed transaction protocol used in computer science and database systems to ensure the atomicity and consistency of a transaction across multiple nodes or databases. It is commonly used in systems where data needs to be coordinated and synchronized across multiple resources or databases.

The Two Phase Commit protocol involves two phases: the prepare phase and the commit phase. In the prepare phase, the transaction coordinator sends a prepare message to all participating nodes or databases, asking them to prepare for committing the transaction. Each participating node then checks if it can successfully complete the transaction without any conflicts or errors. If all nodes respond with a positive acknowledgment, indicating that they can successfully commit the transaction, the protocol proceeds to the commit phase.

In the commit phase, the coordinator sends a commit message to all participating nodes, instructing them to commit the transaction. Upon receiving this message, each node applies the changes associated with the transaction and releases any resources held during its execution.

If any participating node encounters an error during either phase of the protocol, it will send an abort message to notify other nodes that it cannot proceed with the transaction. In this case, all participating nodes will roll back their changes and release any held resources.

The Two Phase Commit protocol ensures that either all participating nodes commit or none of them do. This guarantees atomicity, meaning that either all changes associated with a transaction are applied or none of them are. It also ensures consistency by coordinating all participating nodes to reach a consistent state after executing a distributed transaction.

However, one limitation of Two Phase Commit is its blocking nature. During both phases of the protocol, all participants must wait for responses from other participants before proceeding further. This can lead to potential performance issues in large-scale distributed systems where delays or failures can occur.

To mitigate these limitations, alternative protocols such as Three Phase Commit (3PC) have been developed that aim to improve performance and fault tolerance while still maintaining atomicity and consistency guarantees.

![[Pasted image 20230811172203.png]]


Two Phase commit 은 분산되어 있는 DB 들 간에 atomic 한 trasaction commit 처리를 위해 사용되는 알고리즘이다.

Coordinator 가 각 DB에 해당 trasaction 이 문제없이 commit 이 가능한 상태인지 확인하고 (각 DB는 해당 trasaction 을 commit 만 남겨놓고 수행했으므로), 모든 DB 로부터 성공응답을 받게되면 Coordinator 가 commit 처리하도록 DB 에 요청하고, 어느 하나의 DB 라도 commit 할 수 없는 상태이면, 모든 db 에서 rollback 되도록 한다.

- client 가 각 DB 에 trasaction 을 수행할 때, 해당 transaction 에 고유한 unique ID 를 coordinator 로부터 발급받는다.
- client 는 각 db 에 transaction 이 수행되도록 한다.
- client 는 coordinator 에게 해당 transaction 이 commit 되도록 요청한다.
- coordinator 는 해당 transaction 이 commit 가능한 상태인지 각 db 에 체크한다.
- 각 db 는 해당 transaction 을 disk 에 update 하고 lock 을 hold 하고 있는 상태에서 integraity constraint 체크 등을 하고 해당 prepare request 에 응답한다.
- 모든 db 가 ok 시 commit 되도록 하며 하나의 db 라도 commit 이 불가능하거나 응답이 없으면 전부 abort 되도록 한다.

### 주의해야할 부분

coordinator 에 장애가 발생하거나 failure 되면 어떻게 될까?

## 언제 사용해야 할까?

2PC 는 단일 db 에 비해서 10배 가량의 performance 차이가 난다고 한다. 해당 commit 의 가능 여부를 network io 를 이용하여 판단하기에 io 로 인한 퍼포먼스 저하라고 생각하였으나 crash recovery 를 위해서 추가적인 `fsync()` 도 퍼포먼스 저하 원인 중 하나라고 한다.

그럼에도 불구하고 언제 사용해야 할까?

### Two(or more) databases from different vendors

서버에서 작업하다보면 특정 처리의 결과를 두 개의 db 에다 데이터를 write 하는 경우가 발생한다. 허나 2PC 의 경우 performance 나 구현에 들어가는 리소스를 생각했을 때, 상황에 따라서 uow 디자인 패턴을 이용하는 경우도 있다.

### Exactly-once message processing

메세지 큐와 해당 메세지를 처리하는 분산된 node 에서 둘 다 제대로 처리되었다는 commit 이 필요하다. 메세지 큐에서는 해당 메세지를 가져갔다고 commit 이 되었는데 메세지를 처리하는 쪽에서는 받아서 처리되었다는 commit 이 되지 않을 경우에는 메세지가 분실된다.

따라서 둘 다 처리되었다고 commit 하거나, 둘 다 처리되지 않게 처리하여 메세지가 다시 처리될 수 있도록 해야 한다.

## 더 생각해볼 점

하나의 db 에서 transaction 이 read, write skew 나 phantom 현상이 발생했을 경우 각 db 에 다른 데이터가 심어지게 되는데 이는 어떻게 해결할 수 있을까?
