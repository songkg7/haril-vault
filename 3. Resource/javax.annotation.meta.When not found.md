---
title: javax.annotation.meta.When not found
date: 2022-08-23 17:42:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-23
aliases: null
tags:
  - exception
categories: Exception
updated: 2023-08-19 12:36:31 +0900
---

## Solution

다음 의존성을 추가한다.

```gradle
implementation 'com.google.code.findbugs:jsr305:3.0.2'
```
