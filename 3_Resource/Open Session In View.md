---
title: Open Session In View
date: 2023-09-01 12:31:00 +0900
aliases: OSIV
tags: osiv, jpa, entity, persistence
categories: null
updated: 2023-09-01 12:31:15 +0900
---

영속성 컨텍스트의 생명주기를 뷰 계층까지 유지시키는 기능. 기본값은 true 로 지정되어 있다.

왜 false 를 권장할까?

영속성 컨텍스트는 DB 커넥션과 1:1 로 매핑되어 있다. 때문에 실시간성이 중요한 애플리케이션에서 영속성 컨텍스트가 너무 오래 살아있으면 DB 커넥션이 빠르게 고갈될 수 있다.

osiv 옵션을 끄면 모든 지연로딩을 트랜잭션 안에서 처리해야 한다. 커맨드와 쿼리를 분리함으로써 복잡도를 관리할 수 있다.

## Links

- [[Java Persistence API|JPA]]

## Reference

- [OSIV 정리](https://ykh6242.tistory.com/entry/JPA-OSIVOpen-Session-In-View%EC%99%80-%EC%84%B1%EB%8A%A5-%EC%B5%9C%EC%A0%81%ED%99%94)
