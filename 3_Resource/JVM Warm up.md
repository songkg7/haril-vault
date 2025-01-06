---
title: JVM Warm up
date: 2023-01-12T15:17:00
aliases: 
tags:
  - jvm
  - java
  - cache
categories: 
updated: 2025-01-07T00:35
---

[[Java]]

## Java, JIT Compiler

## Real traffic API Warm up

## JIT C2 Optimization

## JIT Interval

- Method
- Profiling
- Tiered compilation
	- C1: optimization
	- C2: fully optimization

### Compilation level

level0 ~ level4

C1 과 C2 는 각각 쓰레드를 가지고 있고 별도로 동작한다.

### Code Cache

JVM option 을 설정하여 크기를 조절할 수 있다.

```bash
java -XX:+PrintFlagsFinal -version | grep Threshold | grep Tier
```

## Reference

- [if(Kakao)dev2022](https://www.youtube.com/watch?v=utjn-cDSiog)