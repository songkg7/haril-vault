---
title: "delivery app sample"
date: 2023-04-05 09:46:00 +0900
aliases: 
tags: [jpa, kotlin]
categories: 
---

## Overview

JPA 학습 및 Kotlin 에 익숙해지기 위한 샘플 애플리케이션

## Skill

- [[Kotlin]]
- [[Spring Data JPA]]
- [[MySQL]]
- [[Kotest]]

## ERD

- Review
- Customer
- Restaurant
- **Order**
- Menu

```mermaid
---
title: delivery table
---
erDiagram
    CUSTOMER ||--o{ ORDER : do
    CUSTOMER {
        Long id PK
        String name
    }
    ORDER ||--|{ ORDER_MENU : contains
    ORDER {
        Long id PK
        Long customer_id FK
        Enum deliveryStatus
    }
    RESTAURANT ||--o{ REVIEW : contains
    REVIEW {
        Long id PK
        Long restaurant_id FK
        Long order_id FK
        Long customer_id FK
        String contents
        Int rating
    }
    RESTAURANT ||--|{ MENU : contains
    RESTAURANT {
        Long id PK
        String name
    }
    MENU {
        Long id PK
        Long restaurant_id FK
        String name
    }
    ORDER_MENU {
        Long id PK
        Long order_id FK
        Long menu_id FK
    }
    ORDER_MENU }|--|| MENU : contains
```

## Request

### Customer

- [x] 회원가입이 가능하다.
    - [x] 회원가입시에는 이름을 입력해야 한다.
    - [x] 회원가입시에는 주소를 입력해야 한다.
    - [x] 회원가입시에는 전화번호를 입력해야 한다.

### Order

- [x] 사용자는 주문을 생성할 수 있다.
    - 주문을 생성한 사용자는 **주문당 하나의 리뷰를 작성**할 수 있다.
    - 사용자는 **한 번에 하나의 식당에만 주문**할 수 있다.
    - [x] 한 번의 주문에 여러 메뉴를 담을 수 있다.
- (Optional) 배달이 완료되기 전에는 다른 주문을 할 수 없다.

### Restaurant & Menu

식당과 메뉴는 이미 등록되어 있다.

- 메뉴 페이징 처리

### (Optional) Security

#### Owner

- 회원가입이 가능하다.
    - 회원가입시에는 이름을 입력해야 한다.
    - 회원가입시에는 가게명(상호)를 입력해야 한다.
    - 회원가입시에는 전화번호를 입력해야 한다.

#### Restaurant

- Owner 만 식당을 등록할 수 있다.

#### Menu

- 식당을 등록한 Owner 만 Menu 를 등록할 수 있다.

#### Rider

- 라이더는 주문의 상태를 변경할 수 있다.

## Question

- GenerateValue
- 주문은 Order 를 통해서 생성되어야 할까? 아니면 OrderMenu 를 통해서 생성되어야 할까?
    - `CreateOrderController` 에서 요청을 받고, `CreateOrderUsecase` 에게 생성을 위임한다.
- Review 는 어느 도메인과 연관관계를 맺어야 할까?
- 한 번의 Order 에 5개의 menu 가 포함되어 있다면, OrderMenu 를 5번 insert 해야할까?
    - 처음 Order 를 생성하고 바로 save 를 해야 orderMenu 를 정상적으로 save 할 수 있으며, Menu 개수마다 insert 를 생성한다.
