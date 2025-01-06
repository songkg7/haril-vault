---
title: Equals 와 Hashcode 를 함께 재정의해야하는 이유
date: 2023-09-18T13:11:00
aliases: 
tags:
  - java
  - equality
  - hash
categories: 
updated: 2025-01-07T00:35
---

둘 다 재정의하지 않더라도 `Object` 에 기본적으로 정의되어 있으므로 모든 객체는 두 메서드를 사용할 수 있다.

기본적으로 hashcode 는 객체의 주소값을 바탕으로 jvm 에 의해 부여된 정수값이다.

equals 는 객체 값이 동일한지 확인할 때 사용한다. hashcode 와 equals 의 값이 모두 같다면 두 객체는 동일한 객체라고 판단할 수 있다.

그렇다면 둘 중 하나만 구현한다면 어떤 문제가 발생할까?

### 아무 것도 구현하지 않은 경우

먼저 아무 것도 구현하지 않은 경우를 살펴보자.

값이 동일한지 확인하려면 equals 를 호출해야한다. equals 를 재정의하지 않는다면 기본적으로 주소값을 체크한다.

```java
Student a = new Student("Kim");
Student b = new Student("Kim");

a.equals(b); // false
```

두 학생의 이름은 모두 Kim 이다. 학생 객체 비교 기준이 이름이라면 이 두 객체는 서로 같은 객체라고 판단해야한다. 하지만 실제로는 `new` 키워드를 통해 생성된 별개의 객체이므로 equals 를 재정의해주지 않았다면 객체의 주소를 비교하게 되고, 동등비교에 실패한다.

### equals 만 구현한 경우

### hashcode 만 구현한 경우

[[HashMap]] 의 경우는 내부 탐색시 hashcode 값을 먼저 확인한다. 따라서 equals 값이 같더라도 hashcode 값이 다르면 값을 찾을 수 없다.
