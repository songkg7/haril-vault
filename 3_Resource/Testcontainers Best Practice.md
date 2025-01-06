---
title: Testcontainers Best Practice
date: 2024-10-04T15:51:00
aliases: 
tags:
  - test
  - testcontainers
  - kotlin
categories: 
description: 
updated: 2025-01-07T00:35
---

[[Testcontainers]]

1. abstract class 로 분리해서 컨테이너 재활용하기
2. 최대한 가벼운 이미지 사용하기
3. latest 대신 버전 명시해서 사용하기
4. ci/cd 레벨에서 cache 하기

간단한 CRUD 예제

car service

- [[Kotest]] 와 [[Testcontainers]] 를 함께 사용하는 것이 생각보다 꽤 힘들다. SpringBoot 가 자동 제공해주는 기능들을 동작시키기 까다로움