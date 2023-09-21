---
title: DataJpaTest
date: 2023-09-21 15:56:00 +0900
aliases: 
tags:
  - jpa
  - test
categories: 
updated: 2023-09-21 15:56:26 +0900
---

## 사용방법

```java
@DataJpaTest
class RepositoryTest {
}
```

## 사용시 주의사항

- Transactional 어노테이션이 기본으로 붙어있다.
- Auditing 기능을 적용하였을 경우 `@EnableJpaAuditing` 어노테이션을 붙은 클래스를 bean 으로 등록하는지 확인해야한다. `@SpringBootApplication` 이 아닌 다른 설정 클래스로 구현하였을 경우에는 기본적으로는 로딩되지 않는다.

## Links

[[Java Persistence API|JPA]]
