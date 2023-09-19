---
title: 중복되는 설정들을 Annotation 으로 간단하게 관리하기
date: 2022-10-10 13:56:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-10-10
aliases: 
tags:
  - spring
  - annotation
categories: 
updated: 2023-09-16 11:09:36 +0900
---
 > [!NOTE] Example code
> 모든 예제 코드는 [GitHub](https://github.com/songkg7/java-practice)에서 보실 수 있습니다. 

## Overview

module 별 공통적으로 적용해야하는 설정이 있을 경우, 어떻게 적용해야 중복이 발생하지 않을까?

이 문제를 해결하기 위해 annotation 기반으로 설정하는 법을 소개한다.

## Contents

시간 데이터 타입을 특정한 포맷으로 변환하여 전달하기 위해서 module A, B, C 는 각각 공통된 Json encoder 및 Json decoder 를 가질 필요가 있다.

`@Configuration(proxy=false)` 에 대한 이해 필요

Spring proxy 는 개발자가 빈으로 등록한 객체에 대해 프록시 패턴을 사용해서 싱글톤임을 보장한다. 메서드를 직접 두 번 호출하는 경우 2개의 빈이 등록되길 원할 수 있다. 어차피 한 번만 사용되는 빈이라면 프록시 객체를 쓰지 않아도 무관할 수 있다. 프록시 객체를 생성하는 것에도 비용이 들어가기 때문이다. 이럴 때 proxyMode 를 false 로 설정하여 프록시 객체 생성을 막을 수 있으며 성능상 이점을 가진다.

`@Import` 를 통해 설정을 불러온다.

## Conclusion

## Reference

## Links

- [[Spring framework|Spring]]