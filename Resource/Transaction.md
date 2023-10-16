---
title: Transaction
date: 2023-08-08 21:48:00 +0900
aliases: 
tags:
  - database
  - acid
categories: 
updated: 2023-10-16 23:06:33 +0900
---

## What is Transaction?

A transaction is a series of actions or operations performed within a system or business process that results in a change or transfer of goods, services, or information. It involves the exchange of resources between two or more parties, typically with the aim of achieving a specific goal or objective.

Transactions can occur in various contexts, including financial transactions, business transactions, and computer transactions. In financial terms, a transaction refers to the buying or selling of goods, services, or financial assets such as stocks and bonds. Business transactions involve activities such as purchasing supplies, signing contracts, and making payments.

Computer transactions refer to the execution of commands or operations within a computer system. These can include tasks like data entry, database updates, file transfers, and online purchases.

Transactions are typically characterized by certain key attributes:

1. Atomicity: A transaction is considered atomic if it is treated as a single unit of work that either completes successfully in its entirety or fails completely without any intermediate state being saved.
2. Consistency: A transaction should transform the system from one consistent state to another. It ensures that all constraints and rules governing the system are maintained throughout the transaction.
3. Isolation: Transactions should be executed in isolation from other concurrent transactions to prevent interference and maintain data integrity.
4. Durability: Once a transaction is committed and completed successfully, its changes should be permanent and survive any subsequent failures or system crashes.

Transactions play a crucial role in various industries and sectors by facilitating secure and reliable exchanges of goods, services, information, and funds. They provide accountability and transparency while ensuring that parties involved can trust the outcome of their interactions.

---

# 트랜잭션

- 데이터베이스 소프트웨어나 하드웨어는 (쓰기 연산이 실행 중일 때를 포함해서) 언제라도 실패할 수 있다
- 애플리케이션은 (연속된 연산이 실행되는 도중도 포함해서) 언제라도 죽을 수 있다
- 네트워크가 끊기면 애플리케이션과 데이터베이스의 연결이 갑자기 끊기거나 데이터베이스 노드 사이의 통신이 안 될 수 있다
- 여러 클라이언트가 동시에 데이터베이스에 쓰기를 실행해서 다른 클라이언트가 쓴 내용을 덮어쓸 수 있다
- 클라이언트가 부분적으로만 갱신돼서 비정상적인 데이터를 읽을 수 있다
- 클라이언트 사이의 경쟁 조건은 예측하지 못한 버그를 유발할 수 있다

트랜잭션은 자연 법칙이 아니며 데이터베이스에 접속하는 애플리케이션에서 프로그래밍 모델을 단순화하려는 목적으로 만든 것이다.

## 애매모호한 트랜잭션의 개념

### ACID의 의미

- Atomicity(원자성)
- Consistency(일관성)
- Isolation(격리성)
- Durability(지속성)

저자가 해당 원칙의 모호함에 대해 엄청 디스하는 느낌

#### 원자성

시스템은 연산을 실행하기 전이나 실행한 후의 상태에만 있을 수 있으며 그 중간 상태에는 머물 수 없다.

ACID 의 맥락에서 보면 원자성은 동시성과 관련이 **없다**. 원자성은 여러 프로세스가 동시에 같은 데이터에 접근하려고 할 때 무슨 일이 생기는지 설명하지 않는다. 이 내용은 격리성에서 다룬다.

오류가 생겼을 때 트랜잭션을 어보트하고 해당 트랜잭션에서 기록한 모든 내용을 취소하는 능력은 원자성의 결정적인 특징이다. 어보트 능력(abortability)이라고 부르는게 적합하다.

#### 일관성

일관성은 굉장히 여러 의미로 쓰인다.

ACID 일관성의 아이디어는 항상 진실이어야 하는, 데이터에 관한 어떤 선언(invariant)이 있다는 것이다. 트랜잭션이 불변식이 유효한 데이터베이스에서 시작하고 트랜잭션에서 실행된 모든 쓰기가 유효성을 보존한다면 불변식이 항상 만족된다고 확신할 수 있다.

그러나 일관성을 유지하도록 트랜잭션을 올바르게 정의하는 것은 애플리케이션의 책임이며 데이터베이스가 보장할 수 있는 게 아니다.

원자성, 격리성, 지속성은 데이터베이스의 속성인 반면 (ACID에서의) 일관성은 애플리케이션의 속성이다. 따라서 C는 실제로는 ACID에 속하지 않는다.

#### 격리성

동시에 여러 클라이언트가 데이터베이스의 동일한 레코드에 접근하면 동시성 문제(경쟁 조건)에 맞닥뜨리게 된다.

ACID 에서 격리성은 동시에 실행되는 트랜잭션은 서로 격리된다는 것을 의미한다. 트랜잭션은 다른 트랜잭션을 방해할 수 없다. 고전적인 데이터베이스 교과서에서는 격리성을 직렬성(Serializable)이라는 용어로 공식화한다. 데이터베이스는 실제로는 여러 트랜잭션이 동시에 실행됐더라도 트랜잭션이 커밋됐을 때의 결과가 트랜잭션이 순차적으로 실행됐을 때의 결과와 동일하도록 보장한다.

그러나 직렬성 격리(serializable isolation)는 성능 손해를 동반하므로 현실에서는 거의 사용되지 않는다. 오라클 11g 같은 대중적인 데이터베이스 중에는 아예 구현조차 하지 않는 것도 있다. [[Oracle]] 에는 "직렬성"이라는 격리 수준이 있지만 실제로는 직렬성보다 보장이 약한 **스냅숏 격리**를 구현한 것이다.

#### 지속성

지속성(durability)은 트랜잭션이 성공적으로 커밋됐다면 하드웨어 결함이 발생하거나 데이터베이스가 죽더라도 트랜잭션에서 기록한 모든 데이터는 손실되지 않는다는 보장이다.

단일 노드 데이터베이스에서 지속성은 일반적으로 데이터가 하드디스크나 SSD 같은 비휘발성 저장소에 기록됐다는 뜻이다. 보통 디스크에 저장된 데이터 구조가 오염됐을 때 복구할 수 있게 해주는, 쓰기 전 로그([[write-ahead log]])나 비슷한 수단을 동반한다. 지속성을 보장하려면 데이터베이스는 트랜잭션이 성공적으로 커밋됐다고 보고하기 전에 쓰기나 복제가 완료될 때까지 기다려야 한다.

완벽한 지속성은 존재하지 않는다. 모든 하드디스크와 백업이 동시에 파괴돼 버리면 당연히 데이터베이스가 해줄 수 있는 것은 아무 것도 없다.

### 단일 객체 연산과 다중 객체 연산

![[Pasted image 20231010182757.png]]

## 완화된 격리 수준

직렬성 격리는 데이터베이스가 여러 트랜잭션들이 직렬적으로 실행되는 것과 동일한 결과가 나오도록 보장한다는 것을 의미한다.

현실적으로, 직렬성 격리는 성능 비용이 있고 많은 데이터베이스들은 그 비용을 지불하려고 하지 않는다.

맹목적으로 도구에 의존하기보다는 존재하는 동시성 문제의 종류를 잘 이해하고 방지하는 방법을 배울 필요가 있다. 그러면 사용 가능한 도구를 써서 신뢰성 있고 올바르게 동작하는 애플리케이션을 만들 수 있다.

### 커밋 후 읽기(read committed)

1. 데이터베이스에서 읽을 때 커밋된 데이터만 보기 된다(더티 읽기가 없음)
2. 데이터베이스에 쓸 때 커밋된 데이터만 덮어쓰게 된다(더티 쓰기가 없음)

#### 더티 읽기 방지

커밋 후 읽기 격리 수준에서 실행되는 트랜잭션은 더티 읽기를 막아야 한다. 트랜잭션이 쓴 내용은 커밋된 후에야 다른 트랜잭션에서 보인다는 뜻이다.

- 트랜잭션이 여러 객체를 갱신하는데 더티 읽기가 생기면 다른 트랜잭션이 일부는 갱신된 값을, 일부는 갱신되지 않은 값을 볼 수 있다.
- 트랜잭션이 어보트되면 그때까지 쓴 내용은 모두 롤백되야 한다. 데이터베이스가 더티 읽기를 허용하면 트랜잭션이 나중에 롤백될 데이터, 즉 실제로는 데이터베이스에 결코 커밋되지 않을 데이터를 볼 수 있다.

#### 더티 쓰기 방지

먼저 쓴 내용이 아직 커밋되지 않은 트랜잭션에서 쓴 것이고 나중에 실행된 쓰기 작업이 커밋되지 않은 값을 덮어써버리면 어떻게 될까? 이를 더티 쓰기(dirty write)라고 부른다. 보통 먼저 쓴 트랜잭션이 커밋되거나 어보트될 때까지 두 번째 쓰기를 지연시키는 방법을 사용한다.

![[Pasted image 20231010180918.png]]

#### 커밋 후 읽기 구현

Oracle, [[PostgreSQL]], SQL Server, MemSQL 과 다른 여러 데이터베이스에서는 커밋 후 읽기 격리 수준이 기본 설정이다.

로우 수준 잠금을 사용해 더티 쓰기를 방지한다.

더티 읽기를 어떻게 막을 수 있을까? 한가지 선택은 동일한 잠금을 써서 객체를 읽기 원하는 트랜잭션이 잠시 잠금을 획득한 후 읽기가 끝난 후 바로 해제하게 하는 것이다.

그러나 읽기 잠금을 요구하는 방법은 읽기만 실행하는 여러 트랜잭션들이 오랫동안 실행되는 쓰기 트랜잭션 하나가 완료될 때까지 기다려야 할 수 있기 때문에 현실에서는 잘 사용하지 않는다. 읽기만 실행하는 트랜잭션들의 응답시간에 해를 끼치며 운영성이 나쁘다.

이런 이유로 대부분의 데이터베이스는 다음과 같은 방법을 사용해 더티 읽기를 방지한다. 쓰여진 모든 객체에 대해 데이터베이스는 과거에 커밋된 값과 현재 쓰기 잠금을 갖고 있는 트랜잭션에서 쓴 새로운 값을 모두 기억한다. 해당 트랜잭션이 실행 중인 동안 그 객체를 읽는 다른 트랜잭션들은 과거의 값을 읽게 된다. 새 값이 커밋돼야만 다른 트랜잭션들이 새 값을 읽을 수 있게 된다.

### 스냅숏 격리와 반복 읽기

- 백업: 백업을 하려면 데이터베이스 전체의 복사본을 만들어야 하는데 데이터베이스가 크면 몇 시간이 걸릴 수도 있다. 백업 프로세스가 실행되는 동안에도 데이터베이스에 쓰기가 실행되므로 백업의 일부는 과거 버전을, 다른 부분은 새 버전을 갖고 있을 수 있다. 이런 백업을 사용하여 복원하면 비일관성이 영속적이게 된다.
- 분석 질의와 무결성 확인: 데이터의 큰 부분을 스캔하는 질의를 실행하고 싶을 때가 있다. 이런 질의는 다른 시점의 데이터베이스의 일부를 보게 되면 불합리한 결과를 반환할 수도 있다.

스냅숏 격리는 이런 문제의 가장 흔한 해결책이다. 각 트랜잭션은 데이터베이스의 일관된 스냅숏으로부터 읽는다. 즉 트랜잭션은 시작할 때 데이터베이스에 커밋된 상태였던 모든 데이터를 본다.

#### 스냅숏 격리 구현

읽는 쪽에서 쓰는 쪽을 결코 차단하지 않고 쓰는 쪽에서 읽는 쪽을 결코 차단하지 않는다.

데이터베이스는 커밋된 버전 여러개를 유지할 수 있어야 한다. 진행 중인 여러 트랜잭션에서 서로 다른 시점의 데이터베이스 상태를 봐야 할 수도 있기 때문이다. 객체의 여러 버전을 함께 유지하므로 이 기법은 **다중 버전 동시성 제어(nulti-version concurrency control, [[MVCC]])** 라고 한다.

트랜잭션이 시작하면 계속 증가하는 고유한 트랜잭션 아이디를 부여받고, 트랜잭션이 데이터베이스에서 데이터를 쓸 때마다 실행한 트랜잭션의 ID 가 함께 붙는다.

#### 가시성 규칙

- 읽기를 실행하는 트랜잭션이 실행한 시점에 읽기 대상 객체를 생성한 트랜잭션이 이미 커밋된 상태였다
- 읽기 대상 객체가 삭제된 것으로 표시되지 않았다. 또는 삭제된 것으로 표시됐지만 읽기를 실행한 트랜잭션이 시작한 시점에 삭제 요청 트랜잭션이 아직 커밋되지 않았다

데이터베이스는 갱신할 때 값을 교체하지 않고 값이 바뀔 때마다 새 버전을 생성함으로써 작은 오버헤드만 유발하면서 일관된 스냅숏을 제공할 수 있다.

#### 색인과 스냅숏 격리

다중 버전 데이터베이스에서 색인은 어떻게 동작할까? 하나의 선택지는 색인이 객체의 모든 버전을 가리키게 하고 색인 질의가 현재 트랜잭션에서 볼 수 없는 버전을 걸러내게 하는 것이다. 가비지 컬렉션이 어떤 트랜잭션에게도 더 이상 보이지 않는 오래된 객체 버전을 삭제할 때 대응되는 색인 항목도 삭제된다.

[[PostgreSQL]] 은 동일한 객체의 다른 버전들이 같은 페이지에 저장될 수 있다면 색인 갱신을 회피하는 최적화를 한다.

[[카우치DB]], [[데이토믹]], [[LMDB]] 에서는 다른 방법을 쓴다. 이것들도 [[B-Tree]] 를 사용하지만 **추가 전용이며 쓸 때 복사되는(append-only/copy-on-write)** 변종을 사용한다. 트리의 페이지가 갱신될 때 덮어쓰는 대신 각 변경된 페이지의 새로운 복사본을 생성한다. 트리의 루트에 이르기까지 존재하는 부모 페이지들은 복사되고 그것들의 자식 페이지들의 새 버전을 가리키도록 갱신된다. 쓰기에 영향을 받지 않는 페이지들은 복사될 필요가 없고 변함 없는 상태로 남는다.

추가 전용 B-Tree 를 사용하면 쓰기를 실행하는 모든 트랜잭션은 새로운 B-Tree 루트를 생성하며 특정 루트는 그것이 생성된 시점에 해당하는 데이터베이스의 일관된 스냅숏이 된다. 나중에 실행되는 쓰기는 새로운 트리 루트만 생성할 수 있고 존재하는 B-Tree를 변경할 수 없으므로 트랜잭션 ID 를 기반으로 객체를 걸러낼 필요가 없다. 그러나 이 방법도 컴팩션(compaction)과 가비지 컬렉션을 실행하는 백그라운드 프로세스가 필요하다.

### 갱신 손실 방지

### 쓰기 스큐와 팬텀

## 직렬성

### 실제적인 직렬 실행

### 2단계 잠금(2PL)

### 직렬성 스냅숏 격리(SSI)

## Reference

- https://m-falcon.tistory.com/527
