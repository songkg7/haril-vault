---
title: "WebFlux 에서 Date type 을 url parameter 로 사용하기"
date: 2022-11-22 11:28:00 +0900
aliases: 
tags: [webflux, localdatetime, url]
categories: 
---

`LocalDateTime` 같은 시간 형식을 url parameter 로 사용할 경우 다음과 같은 에러 메세지를 보게 된다.

```console
Exception: Failed to convert value of type 'java.lang.String' to required type 'java.time.LocalDateTime';
```

## Contents

### 1. `@DateTimeFormat`

### 2. `WebFluxConfigurer`
