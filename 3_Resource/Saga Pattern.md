---
title: SAGA Pattern
date: 2023-08-11 17:38:00 +0900
aliases: 
tags:
  - msa
  - distribute
  - transaction
categories: 
updated: 2024-01-31 13:57:41 +0900
---

## 분산 트랜잭션 처리 패턴

[[Micro-Service Architecture]] 에서 기능을 분리하고 저장소를 격리함에 따라 이전에는 존재하지 않았던 문제가 생긴다.

여러 개의 분산된 서비스에 걸쳐서 비즈니스 처리를 수행하는 경우 비즈니스 정합성 및 데이터 일관성을 어떻게 보장할 것인가에 대한 문제가 생기는데 이를 손쉽게 처리할 수 있는 방법 중 하나는 여러 개의 분산된 서비스를 하나의 일관된 트랜잭션으로 묶는 것이다.

이를 위한 전통적인 방법으로 2단계 커밋 기법([[Two Phase Commit]])이 있다.

마이크로서비스의 독립적인 분산 트랜잭션 처리를 지원하는 패턴이 바로 사가(Saga) 패턴이다.

사가 패턴은 각 서비스의 로컬 트랜잭션을 순차적으로 처리하는 패턴이다. 사가 패턴은 여러 개의 분산된 서비스를 하나의 트랜잭션으로 묶지 않고 각 로컬 트랜잭션과 보상 트랜잭션을 설정해 비즈니스 및 데이터 정합성을 맞춘다.

즉 로컬 트랜잭션은 자신의 데이터를 업데이트 한 다음 사가 내에 다음 로컬 트랜잭션을 업데이트하는 트리거 메시지를 게시해서 정합성을 맞춘다.

다른 트랜잭션이 실패해서 롤백이 필요한 경우에 보상 트랜잭션을 따라서 앞서 처리한 트랜잭션들을 되돌리게 한다.

즉 일관성 유지가 필요한 트랜잭션들을 하나로 묶어서 처리하는게 아니라 하나하나씩 로컬 트랜잭션으로 처리하고 이벤트를 날리고 다음 로컬 트랜잭션이 처리하는 식으로 진행된다.

### 결과적 일관성(Eventual Consistency)

모든 비즈니스에서 데이터는 일관성이 있어야 한다. 하지만 이전까지는 이 같은 데이터 일관성은 실시간으로 반드시 맞아야 한다는 생각이다.

그렇지만 모든 비즈니스 규칙들이 실시간으로 데이터 일관성이 맞아야 하는 것은 아니다. 예를 들면 쇼핑몰에서 주문을 하고 결제 처리가 완료되면 결제 내용과 함께 주문 내역이 고객의 이메일로 전송되어야 한다고 생각해보자.

이 경우들을 모두 그 즉시 순차적으로 처리해야 하는 것은 아니다. 주문만 미리 받아놓고(주문 서비스만 미리 Scale Out 해놓는다면) 외부 결제 서비스는 자신이 처리할 수 있는 만큼만 계속해서 처리한다라고 가정을 해봐도 문제되는 점은 없다. 데이터의 일관성이 실시간으로 맞지 않더라도 어느 일정 시점에서는 일관성이 맞을 것이다. 이를 결과적 일관성이라고 한다.

이런 결과적 일관성은 고가용성을 극대화한다. 실시간성을 강제로 해서 다른 서비스의 가용성을 떨어뜨리지 않는다.

이는 마이크로서비스의 사가 패턴과 이벤트 메시지 기반 비동기 통신을 통해서 만들 수 있다.

## Saga Pattern

사가 패턴에는 크게 두 종류가 있다. **Choreography-Based Pattern** 과 **Orchestration-Based Pattern** 이다. 각각의 패턴에 대해 좀 더 자세하게 알아보자.

### Choreography-Based Pattern

이 패턴은 Saga 에 참여하는 사람들이 이벤트를 교환하고 협력하는 방식이다.

여기서 발생하는 이벤트들은 각각의 데이터베이스를 업데이트한다. 처음의 시작은 외부 요청으로부터 시작하고(예를 들면 HTTP POST) 이후의 스텝은 이벤트에 대한 응답을 기반으로 한다.

각각의 Step 들은 다음과 같다.

| Step | Triggering event | Participant | Command | Events |
| ---- | ---- | ---- | ---- | ---- |
| 1 | (External Request) | Order Service | createPendingOrder() | OrderCreated |
| 2 | OrderCreated | Customer Service | reserveCredit() | Credit Reserved, Credit Limit Exceeded |
| 3a | Credit Reserved | Order Service | approveOrder() |  |
| 3b | Credit Limit Exceeded | Order Service | rejectOrder() |  |

Step 2 같은 경우는 가능한 이벤트가 두 가지 있다고 생각하면 된다.

- 고객의 신용카드로 결제 처리된 경우
- 한도초과가 발생한 경우

다이어그램은 다음과 같다.

![[Pasted image 20230811175229.png]]

순서를 살펴보자면,

1. `OrderService` 가 외부의 `POST /orders` 요청을 받고 `Order` 객체를 `Pending` 상태로 만든다.
2. 그 후 `OrderService` 는 `OrderCreated` 를 라는 이벤트를 발생시킨다.
3. `CustomerService` 는 이 이벤트를 수신하고 나서 `Credit Reserve` 를 시도한다.
4. 그 후 `CustomerService` 는 이 결과에 대해 이벤트를 만든다.
5. `OrderService` 는 이 이벤트를 받고나서 `Order` 를 Approve 할지 reject 할 지 결정한다.

#### 단점

- 이벤트 유실
- 순서 보장이 어려움 -> [[Transactional Outbox Pattern|Transactional Outbox Pattern]] 으로 해결

### Orchestration-Based Pattern

Orchestration-Based Pattern 에서는 Saga 의 participant 들에게 뭘 해야 하는지 알려주는 orchestrator 가 있다.

Saga Orchestrator 는 참가자들과 비동기 통신을 통해서 상호작용을 한다. 각각의 스텝에서 Saga Orchestrator 는 participant 에게 어떤 행동을 해야 하는지 알려준다. 그 후 participant 는 적절한 행동 후에 orchestrator 에게 응답을 보낸다. orchestrator 는 이 메시지를 읽고 다음 participant 에게 보낼 메시지를 만든다.

다이어그램은 다음과 같다.

![[Pasted image 20230812154531.png]]

순서를 살펴보자면

1. `OrderService` 는 `POST /orders` 요청을 `Order Saga Orchestrator` 를 만들어서 처리한다.
2. `Saga Orchestrator` 는 `Order` 를 `Pending` 상태로 만든다.
3. 그 후 `Saga Orchestrator` 는 `Reserve Credit` 명령을 `CustomerService` 에게 보낸다.
4. `CustomerService` 는 명령대로 행동한다.
5. 그 후 `CustomerService` 는 결과에 따른 응답 메시지를 보낸다.
6. `Saga Orchestrator` 는 이 결과를 보고 `Order` 를 approve 할지 reject 할지 결정한다.

## Reference

- [마이크로서비스 - 분산 트랜잭션 처리 패턴](https://velog.io/@youngerjesus/%EB%A7%88%EC%9D%B4%ED%81%AC%EB%A1%9C%EC%84%9C%EB%B9%84%EC%8A%A4-%ED%8C%A8%ED%84%B4-%EB%B6%84%EC%82%B0-%ED%8A%B8%EB%9E%9C%EC%9E%AD%EC%85%98-%EC%B2%98%EB%A6%AC)
