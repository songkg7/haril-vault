---
title: ItemProcessor
date: 2022-08-17T17:06:00
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: 
tags:
  - batch
  - step
  - chunk
categories: Spring
updated: 2025-01-07T00:35
---

`ItemProcessor` 는 [[ItemReader]] 로 읽어온 배치 데이터를 변환하는 역할을 수행합니다.

`ItemProcessor` 가 존재하는 이유는 비즈니스 로직을 분리하기 위함입니다. [[ItemWriter]] 는 저장만 수행하고, `ItemProcessor` 가 처리만 수행하여 역할을 명확하게 분리하고 유지보수성을 용이하게 합니다.

`ItemProcessor` 는 타입 변환을 하는 경우 특히 유용합니다.

```java
public interface ItemProcessor<I, O> {
    O process(I item) throws Exception;
}
```
