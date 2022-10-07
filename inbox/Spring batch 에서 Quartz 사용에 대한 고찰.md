---
title: "Spring batch 에서 Quartz 사용에 대한 고찰"
date: 2022-09-07 11:38:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-07
aliases: 
tags: [spring, batch, quartz, schedular]
categories: Spring
---

## Overview

[[Spring batch]] 에서 주로 사용되는 스케쥴러인 [[Quartz]] 에 대해 간단히 살펴보고 batch processing 운영을 위한 최적의 방법은 무엇일지 알아본다.

## Quartz

일반적으로 일괄 처리를 하는 형태인 batch 는, 특정 시간에 실행된다. 어떤 시간에 실행시킬 지 정하는 작업을 스케쥴링이라고 하는데, 이 스케쥴링을 도와주는 java library 가 바로 `Quartz` 이다.

Quartz 는 여러모로 편리한 기능을 가지고 있다. 

- 설정이 매우 쉽고 간편하며, 빠르게 적용이 가능하다.
- cron 표현식을 매우 잘 지원하여 디테일하게 시간을 지정할 수 있다.