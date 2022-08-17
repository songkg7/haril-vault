---
title: "ItemReader"
date: 2022-08-17 17:01:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: 
tags: [batch, chunk, step]
categories: Spring
---

`ItemReader` 는 [[Step]] 의 대상이 되는 배치 데이터를 읽어오는 인터페이스입니다. `file`, `xml`, `DB`, 등 여러 타입의 데이터를 읽어올 수 있습니다.

```java
public interface ItemReader<T> {
    T read() throws Exception, UnexpectedInputException, ParseException, NonTransientResourceException;
}
```

`ItemReader` 에서 `read()` 메서드의 반환 타입을 제네릭으로 구현했기 때문에 다양한 타입을 사용할 수 있습니다.
