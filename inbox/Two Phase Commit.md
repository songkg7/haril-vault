---
title: Two Phase Commit
date: 2023-08-10 20:41:00 +0900
aliases: null
tags: msa, atomic, distribution
categories: null
updated: 2023-08-11 10:14:16 +0900
---

## What is Two Phase Commit?

Two Phase Commit (2PC) is a distributed transaction protocol used in computer science and database systems to ensure the atomicity and consistency of a transaction across multiple nodes or databases. It is commonly used in systems where data needs to be coordinated and synchronized across multiple resources or databases.

The Two Phase Commit protocol involves two phases: the prepare phase and the commit phase. In the prepare phase, the transaction coordinator sends a prepare message to all participating nodes or databases, asking them to prepare for committing the transaction. Each participating node then checks if it can successfully complete the transaction without any conflicts or errors. If all nodes respond with a positive acknowledgment, indicating that they can successfully commit the transaction, the protocol proceeds to the commit phase.

In the commit phase, the coordinator sends a commit message to all participating nodes, instructing them to commit the transaction. Upon receiving this message, each node applies the changes associated with the transaction and releases any resources held during its execution.

If any participating node encounters an error during either phase of the protocol, it will send an abort message to notify other nodes that it cannot proceed with the transaction. In this case, all participating nodes will roll back their changes and release any held resources.

The Two Phase Commit protocol ensures that either all participating nodes commit or none of them do. This guarantees atomicity, meaning that either all changes associated with a transaction are applied or none of them are. It also ensures consistency by coordinating all participating nodes to reach a consistent state after executing a distributed transaction.

However, one limitation of Two Phase Commit is its blocking nature. During both phases of the protocol, all participants must wait for responses from other participants before proceeding further. This can lead to potential performance issues in large-scale distributed systems where delays or failures can occur.

To mitigate these limitations, alternative protocols such as Three Phase Commit (3PC) have been developed that aim to improve performance and fault tolerance while still maintaining atomicity and consistency guarantees.
