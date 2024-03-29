---
title: SummerTime Application
date: 2024-03-28 19:51:00 +0900
aliases: 
tags:
  - app
  - summertime
  - api
categories: 
updated: 2024-03-28 23:10:46 +0900
---

## Overview

- ZonedDateTime 을 입력하면 특정 지역의 localtime 에 summertime 이 적용되서 반환하는 api

## Architecture

- 가용성이 매우 중요
    - 대부분의 서비스가 summertime 을 적용하기 위해 한 번쯤은 요청해야 하므로 많은 트래픽이 예상
- WorldTime api
    - rate limit 이 걸려있음
    - [[Redis]] 를 통해 데이터를 캐시해두고 사용하자
    - 서머타임은 한 번 적용되면 수개월 이상 변하지 않으므로 TTL 을 길게 가져가도 좋다

- `ZoneRules` 클래스에 `dayLightSaving` 이라는 서머타임 관련 어노테이션이 존재한다.
