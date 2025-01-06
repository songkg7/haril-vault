---
title: ItemWriter
date: 2022-08-17T17:10:00
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

`ItemWriter` 는 배치 데이터를 저장합니다. 일반적으로는 DB 에 저장하지만, 거의 대부분의 포맷을 지원하므로 상황에 따라 선택하면 됩니다.

```java
public interface ItemWriter<T> {
    public write<(List<? extends T> items) throws Exception;
}
```

[[ItemReader]] 와 비슷한 방식으로 구현하면 됩니다. 제네릭으로 원하는 타입을 받습니다. `write()` 메서드는 List 자료구조를 사용하여 지정한 타입의 리스트를 매개변수로 받습니다. List 의 데이터 수는 설정한 `chunkSize` 만큼씩 처리됩니다.
