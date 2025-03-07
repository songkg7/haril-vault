---
title: Karatusba
date: 2023-12-06T22:19:00
aliases: 
tags:
  - algorithm
categories: 
updated: 2025-01-07T00:35
---

## Karatusba

카라츠바(Karatsuba) 알고리즘은 수백, 수만 자리의 큰 두 정수를 곱하는 알고리즘입니다. 이 알고리즘은 시간복잡도를 $O(N_{log}(3))$까지 낮춰주기 위해 사용됩니다. 

카라츠바 알고리즘의 기본 단계는 다음과 같습니다: 

- 큰 두 수 x와 y의 곱을 계산합니다.
- 자릿수가 x, y의 절반인 수들의 곱 3번을 계산합니다.
- 덧셈과 시프트 연산을 이용합니다.

카라츠바 알고리즘은 $O(n^2)$보다 훨씬 적은 곱셈을 필요로 합니다. 예를 들어, n이 10만이라고 하면 곱셈 횟수는 대략 100배 정도 차이가 납니다. 

카라츠바 알고리즘은 다음과 같은 특징이 있습니다: 

- 모든 기본 B 및 모든 m에 대해 작동합니다.
- 재귀 알고리즘은 m이 n/2 반올림된 경우 가장 효율적입니다.
- 한 자리 곱셈의 수는 3k입니다.
