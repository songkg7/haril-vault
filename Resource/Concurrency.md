---
title: 동시성
date: 2023-08-09 21:24:00 +0900
aliases:
  - 동시성
tags:
  - transaction
  - lock
categories: 
updated: 2023-10-01 22:01:22 +0900
---

## 동시성에 대한 정의

두 작업이 "같은 시각"에 발생하면 두 작업이 동시에 호출된 것으로 보일 수 있다. 하지만 사실 두 작업이 정말로 시간적으로 겹쳐졌는지 여부는 중요하지 않다. 분산 시스템에서는 각 작업이 서로 알지 못하면 단순히 두 작업은 동시에 수행됐다 말한다. 예를 들어 네트워크가 느려지거나 어떤 시점에 중단되면 네트워크 문제로 한 작업이 다른 작업에 대해 알 수 없기 때문에 두 작업은 시간 간격을 두고 발생하더라도 동시에 수행한 것으로 본다.

## 문제

```java

```

어떤 요청이 동시에 발생했을 때 애플리케이션 내부에서 어떤 일이 벌어질까?

### 해결 방법

- 비관적 락([[Pessimistic Lock]])
- 낙관적 락([[Optimistic Lock]])

## Links

- [[Redis|Redis]]
- [[Database|DB]]
- [[Transaction|Transaction]]

## Reference

https://helloworld.kurly.com/blog/distributed-redisson-lock/
