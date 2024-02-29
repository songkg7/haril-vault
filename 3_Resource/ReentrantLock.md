---
title: ReentrantLock
date: 2024-02-29 11:21:00 +0900
aliases: 
tags:
  - lock
  - concurrency
categories: 
updated: 2024-02-29 11:43:33 +0900
---

## ReentrantLock 이란

ReentrantLock은 Java의 동시성 프로그래밍을 위한 동기화 메커니즘 중 하나로, 스레드가 이미 점유하고 있는 락을 다시 점유하려 할 때, 이를 가능하게 하는 재진입 가능 락이다. 

기본적으로 synchronized 키워드와 같은 역할을 수행하지만, synchronized 키워드보다 더 세밀한 제어가 가능하다. 예를 들어, lock을 획득할 때 시간 제한을 두거나, 공정한 lock(먼저 요청한 순서대로 lock이 부여되는 방식)을 사용하는 등의 기능을 제공한다.

ReentrantLock는 java.util.concurrent.locks 패키지에 포함되어 있으며, Lock 인터페이스를 구현한다. 사용하기 위해서는 인스턴스를 생성하고, lock() 메소드로 락을 획득하며, finally 블록에서 unlock() 메소드로 반드시 락을 해제해야 한다. 이러한 과정은 Exception 발생 시에도 안전하게 리소스를 반환해야 함을 보장한다.

## 기본 동작 원리

lock 을 획득하면 state 카운트가 증가한다.

- `0`: free, 점유되지 않음
- `1`: lock 을 점유한 스레드가 존재함

이미 lock 을 점유한 스레드가 다시 lock 을 획득하려 하는 경우는 어떻게 될까?

## DeadLock 발생 예시

먼저 아래 코드를 보자. 출금 요청 pseudo code 이다.

```kotlin
private val locks: ConcurrentHashMap<Long, ReentrantLock> = ConcurrentHashMap()

fun deposit(id: Long, amount: Long): Account {
    require(lock.tryLock()) { "lock is already acquired" }
    lock.withLock {
        log.info("locked: $lock")
        val balance = db.balance(id).balance
        return db.balance(id, balance + amount)
    }
}
```

위 코드는 deadlock 이 발생한다.

```java
@ReservedStackAccess
final boolean tryLock() {
    Thread current = Thread.currentThread();
    int c = getState();
    if (c == 0) {
        if (compareAndSetState(0, 1)) {
            setExclusiveOwnerThread(current);
            return true;
        }
    } else if (getExclusiveOwnerThread() == current) {
        if (++c < 0) // overflow
            throw new Error("Maximum lock count exceeded");
        setState(c);
        return true;
    }
    return false;
}
```

---

[[Kotlin]] 을 사용 중이라면 [[Spring AOP]] 대신 아래처럼 작성할 수 있다.

```kotlin
fun <T> runWithLock(id:Long, function: () -> T): T {
    val lock = locks.computeIfAbsent(id) { ReentrantLock() }
    log.info("lock: $lock")
    lock.withLock {
        log.info("locked: $lock")
        return function()
    }
}
```