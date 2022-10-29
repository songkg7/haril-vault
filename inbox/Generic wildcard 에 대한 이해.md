---
title: "Generic wildcard 에 대한 이해"
date: 2022-10-29 23:59:00 +0900
aliases: 
tags: [java, generic, wildcard]
categories: Java
---

## Question

What are the defferences in the codes:

```java
void deleteAll(Iterable<? extends T> elements);
```

```java
<S extends T> void deleteAll(Iterable<S> elements);
```

## Answer

1 번은 method 내부에서 element 의 타입을 알 방법이 없어서 T type 에 이미 선언되어 있는 메서드만 참조할 수 있다. 반면 2번은 구체적으로 element 의 타입을 알 수 있다. 그렇기 때문에 T type 뿐만 아니라 S type 인 자신의 메서드도 참조할 수 있게 된다.

wildcard 로 사용하는 경우는 메서드의 타입보단 메서드의 기능에 중점을 둘 때 사용하게 된다.

## Links

- [[Java]]
