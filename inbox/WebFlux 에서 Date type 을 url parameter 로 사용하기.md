---
title: "WebFlux 에서 Date type 을 url parameter 로 사용하기"
date: 2022-11-22 11:28:00 +0900
aliases: 
tags: [webflux, localdatetime, url]
categories: 
---

`LocalDateTime` 같은 시간 형식을 url parameter 로 사용할 경우 기본 포맷에 맞지 않는다면 다음과 같은 에러 메세지를 보게 된다.

```console
Exception: Failed to convert value of type 'java.lang.String' to required type 'java.time.LocalDateTime';
```

특정 포맷도 convert 할 수 있도록 하기 위해서 어떻게 할 수 있는지 알아본다.

## Contents

### 1. `@DateTimeFormat`

### 2. `WebFluxConfigurer`
