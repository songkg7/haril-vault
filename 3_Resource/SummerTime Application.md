---
title: SummerTime Application
date: 2024-03-28 19:51:00 +0900
aliases: 
tags:
  - app
  - summertime
  - api
categories: 
updated: 2024-03-30 17:45:08 +0900
---

## Overview

- 글로벌 서비스의 경우 Daylight saving time, 소위 서머타임을 고려해야할 필요가 있다
- 나라별 지역별로 다르게 시행되는 서머타임을 어떻게 판단할 수 있을까?
- 정확도가 크게 중요하지 않다는 전제하에 최대한 비슷하게만 맞추면 되지 않을까?
- 높은 트래픽 처리량을 보장하는 서머타임 변환 API 서비스를 만들어보자

## Architecture

- ZonedDateTime 을 입력하면 특정 지역의 localtime 에 summertime 이 적용되서 반환하는 api
- 가용성이 매우 중요
    - 대부분의 서비스가 summertime 을 적용하기 위해 한 번쯤은 요청해야 하므로 많은 트래픽이 예상
- WorldTime api
    - rate limit 이 걸려있음
    - [[Redis]] 를 통해 데이터를 캐시해두고 사용하자
    - 서머타임은 한 번 적용되면 수개월 이상 변하지 않으므로 TTL 을 길게 가져가도 좋다
- `ZoneRules` 클래스에 `dayLightSaving` 이라는 서머타임 관련 어노테이션이 존재한다.

## WorldTime API

이미 오픈되어 있는 API 가 있다.

```bash
https worldtimeapi.org/api/timezone/Asia/Seoul
```

아래와 같은 결과를 얻을 수 있다.

```json
{
    "abbreviation": "KST",
    "client_ip": "59.5.26.138",
    "datetime": "2024-03-30T17:41:26.815647+09:00",
    "day_of_week": 6,
    "day_of_year": 90,
    "dst": false,
    "dst_from": null,
    "dst_offset": 0,
    "dst_until": null,
    "raw_offset": 32400,
    "timezone": "Asia/Seoul",
    "unixtime": 1711788086,
    "utc_datetime": "2024-03-30T08:41:26.815647+00:00",
    "utc_offset": "+09:00",
    "week_number": 13
}
```

`dst` 는 해당 지역에 서머타임이 적용되고 있는지 여부를 반환해준다. 서울은 현재 서머타임을 시행하는 지역이 아니므로 false 가 반환된다. 서머타임 시행 지역인 미국 시카고를 한 번 보자.

```bash
https worldtimeapi.org/api/timezone/America/Chicago
```

```json
{
    "abbreviation": "CDT",
    "client_ip": "59.5.26.138",
    "datetime": "2024-03-30T03:43:09.746753-05:00",
    "day_of_week": 6,
    "day_of_year": 90,
    "dst": true,
    "dst_from": "2024-03-10T08:00:00+00:00",
    "dst_offset": 3600,
    "dst_until": "2024-11-03T07:00:00+00:00",
    "raw_offset": -21600,
    "timezone": "America/Chicago",
    "unixtime": 1711788189,
    "utc_datetime": "2024-03-30T08:43:09.746753+00:00",
    "utc_offset": "-05:00",
    "week_number": 13
}
```

`dst_from`, `dst_until` 을 통해 `dst` 가 적용되는 기간을 확인할 수 있고, `dst_offset` 을 통해 서머타임에 의해 조정되는 시간이 어느 정도나 되는지 확인할 수 있다.

이 정보들을 활용하면 원하는 서머타임 변환 API 를 만들 수 있겠다.
