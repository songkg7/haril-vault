---
title: WebFlux tutorial
date: 2022-09-03T11:10:00
fc-calendar: Gregorian Calendar
fc-date: 2022-09-03
aliases: 
tags:
  - kotlin
  - webflux
  - spring
categories: Spring
updated: 2025-01-07T00:35
---

## Overview

이 글에서는 [[Kotlin]] 을 사용하여 [[Spring WebFlux]] 의 특징 및 기능에 대해서 간단하게 살펴본다.

관련 샘플 코드는 아래 [github](https://github.com/songkg7/kotlin-practice/tree/main/spring-webflux)에서 확인할 수 있으며, http 요청으로는 [[curl]] 대신 [[HTTPie]] 를 사용한다.
 
## Contents

### Mono and Flux

```kotlin
@RestController
class HelloController {

    @GetMapping("/mono")
    fun helloMono() = Mono.just("hello")

    @GetMapping("/flux")
    fun helloFlux() = Flux.just("hello", "world")

} 
```

```bash
http localhost:8080/mono
```

```bash
http localhost:8080/flux
```
