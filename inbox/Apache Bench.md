---
title: Apache Bench
date: 2022-08-23 18:05:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-23
aliases: null
tags:
  - apache
  - bench
categories: null
updated: 2023-08-19 12:37:58 +0900
---

## Overview

Apache Bench 는 커맨드 라인을 활용한 매우 가볍고 유용한 웹 서버 벤치마킹 도구이다. `nginder` 나 `JMeter` 같은 도구를 사용하기 부담스럽거나, 간단한 response time 정도만 측정하고자 할 때 매우 유용하다.

mac 을 사용하는 경우엔 기본적으로 설치되어 있다.  설치 여부를 확인해보기 위해선 `ab -V` 를 입력해보면 된다.

```bash
ab -n 100 -c 20 http://localhost:3000
```

- `-c` : concurrency level, 동시 요청 수
- `-n` : 요청당 호출 수
- `-t`: 테스트 실행 시간

참고로 요청에 delay 는 없기 때문에 굉장히 많은 요청이 발생한다. 충분히 낮은 값으로 설정하여 실행해보고 점차 늘려가면서 확인하는 방법을 추천한다.

## Reference

- [Apache Bench](https://httpd.apache.org/docs/2.4/ko/programs/ab.html)
