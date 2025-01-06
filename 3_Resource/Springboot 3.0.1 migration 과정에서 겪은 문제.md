---
title: Springboot 3.0.1 migration 과정에서 겪은 문제
date: 2023-01-18T14:56:00
aliases: 
tags:
  - java
  - spring
  - springboot
categories: Spring
updated: 2025-01-07T00:35
---

[[Spring framework|Spring]]

#### 별도의 모듈에 존재하는 `@EnableWebFluxSecurity` 가 적용되지 않음

`@Configuration` 을 명시적으로 붙여주니 ComponentScan 이 정상적으로 이루어짐. 원래는 `@EnableWebFluxSecurity` 가 `@Configuration` 이 정의되어 있었는데 Springboot 3 이 되면서 제거된 것으로 확인. 비슷한 역할을 하는 다른 설정 annotation 들에도 `@Configuration` 이 제거된 것을 확인함.
