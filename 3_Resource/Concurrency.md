---
title: 동시성
date: 2023-08-09T21:24:00
aliases:
  - 동시성
tags:
  - transaction
  - lock
categories: 
updated: 2025-01-07T00:35
---

## 동시성에 대한 정의

두 작업이 "같은 시각"에 발생하면 두 작업이 동시에 호출된 것으로 보일 수 있다. 하지만 사실 두 작업이 정말로 시간적으로 겹쳐졌는지 여부는 중요하지 않다. 분산 시스템에서는 각 작업이 서로 알지 못하면 단순히 두 작업은 동시에 수행됐다 말한다. 예를 들어 네트워크가 느려지거나 어떤 시점에 중단되면 네트워크 문제로 한 작업이 다른 작업에 대해 알 수 없기 때문에 두 작업은 시간 간격을 두고 발생하더라도 동시에 수행한 것으로 본다.

## 문제

```java

```

어떤 요청이 동시에 발생했을 때 애플리케이션 내부에서 어떤 일이 벌어질까?

### 해결 방법

- `synchronized`
    - 불필요하게 트랜잭션 주기가 길어질 수 있다.
    - 분산환경에서는 불가능한 옵션
- [[Pessimistic Lock|비관적 락]]
- [[Optimistic Lock|낙관적 락]]

## Links

- [[Redis|Redis]]
- [[Database|DB]]
- [[Transaction|Transaction]]

## Reference

- https://helloworld.kurly.com/blog/distributed-redisson-lock/
- [동시성 문제 해결을 위한 락 선택에 고려해볼 것들](https://www.blog.ecsimsw.com/entry/%EB%8F%99%EC%8B%9C%EC%84%B1-%ED%85%8C%EC%8A%A4%ED%8A%B8%EC%99%80-%ED%95%B4%EA%B2%B0-%EB%B0%A9%EC%95%88)
- https://mangkyu.tistory.com/30