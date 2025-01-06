---
title: private method vs private static method
date: 2023-03-03T17:30:00
aliases: 
tags:
  - java
  - private
categories: 
updated: 2025-01-07T00:35
---

[[Java]] 에서 `private` 접근제어자를 쓸 때 static 의 유무가 어떤 차이가 있는지 이야기합니다.

### Example

```java
```

1. 외부에 공개되어 있지 않아서 클래스 내부에서만 쓸 수 있다.
2. 선언되어 있는 클래스의 내부 상태와 무관하다 = 독립적이다 = 그러므로 항상 같은 동작을 보장한다 = 사이드이펙트가 발생하지 않는다

즉, private static method 는 method 가 아니라 function 의 성격을 띄며, 실제로 함수처럼 동작합니다.

가급적이면 static 을 선언하여 쓰는 것이 좋습니다.
