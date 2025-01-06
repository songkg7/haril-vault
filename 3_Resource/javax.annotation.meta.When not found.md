---
title: javax.annotation.meta.When not found
date: 2022-08-23T17:42:00
fc-calendar: Gregorian Calendar
fc-date: 2022-08-23
aliases: 
tags:
  - exception
categories: Exception
updated: 2025-01-07T00:35
---

## Solution

다음 의존성을 추가한다.

```gradle
implementation 'com.google.code.findbugs:jsr305:3.0.2'
```
