---
title: "Apache Bench"
date: 2022-08-23 18:05:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-23
aliases: 
tags: [apache, bench]
categories: 
---

## Overview

아파치 웹서버 성능검사 도구

mac 을 사용하는 경우엔 기본적으로 설치되어 있다.

설치 여부를 확인해보기 위해선 `ab -V` 를 입력해보면 된다.

```bash
ab -n 100 -c 20 http://localhost:3000
```

## Reference

- [Apache Bench](https://httpd.apache.org/docs/2.4/ko/programs/ab.html)
