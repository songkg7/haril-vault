---
title: "floating point"
date: 2022-08-14 02:54:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-14
aliases: [부동소수점]
tags: [floating-point, float]
categories: Computer science
---

## 부동소수?

컴퓨터에서 실수를 표현하는 방법은 고정 소수점과 부동 소수점 두 가지 방식이 존재한다.

### 고정 소수점(Fixed point)

![[fixed point.png]]

> 소수점이 찍힐 위치를 미리 정해놓고 소수를 표현하는 방식 (정수 + 소수)

3.141592 는 부호(-)와 정수부(3), 소수부(0.141592) 3가지의 요소가 필요함

#### 장점

- 실수를 정수부와 소수부로 표현하여 단순하다.

#### 단점

- 표현의 범위가 너무 적어서 활용하기 힘들다.
	- 정수부는 15bit, 소수부는 16bit

### 부동 소수점(Floating point)

![[floating point.png]]

> 실수를 가수부 + 지수부로 표현한다.

- 가수: 실수의 실제값 표현
- 지수: 크기를 표현, 가수의 어디쯤에 소수점이 있는지 나타냄

지수의 값에 따라 소수점이 움직이는 방식을 활용한 실수 표현 방법이다.

즉, 소수점의 위치가 고정되어 있지 않는다.

#### 장점

- 표현할 수 있는 수의 범위가 넓어진다.
	- 현재 대부분의 시스템에서 활용

#### 단점

- 오차가 발생할 수 있다.
	- 부동 소수점으로 표현할 수 있는 방법이 매우 다양함

## Reference

[부동소수](https://www.tcpschool.com/cpp/cpp_datatype_floatingPointNumber)
