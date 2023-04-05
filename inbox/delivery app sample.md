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
- Shop
- **Order**
- Menu

```mermaid
---
title: delivery
---
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ MENU : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
    REVIEW |o--|| ORDER : contains
```
