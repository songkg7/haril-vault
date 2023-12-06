---
title: Toom Cook 3way
date: 2023-12-06 22:23:00 +0900
aliases: 
tags:
  - algorithm
categories: 
updated: 2023-12-06 22:23:21 +0900
---

Toom-Cook 3-Way는 안드레이 톰과 스테픈 쿡이 제안한 곱셈 알고리즘인 Toom–Cook 알고리즘의 일종입니다.  Toom-Cook 알고리즘은 큰 두 정수를 곱할 때 사용됩니다.  Toom-Cook 3-Way는 최적의 평가 및 보간 시퀀스를 구현합니다. Toom-Cook 3-Way는 매우 효율적이며 작은 나눗셈 하나만 필요합니다. 

Toom-Cook 3-Way의 특징은 다음과 같습니다. 

- 정수 곱셈의 결과를 1/3로 곱합니다
- 5번의 재귀적 곱셈을 수행합니다
- 각 곱셈의 크기는 원래 크기의 1/3입니다
- Karatsuba 알고리즘의 일반화입니다

Toom-Cook 3-Way의 시간 복잡도는 Θ(c(k)n^e)입니다. 여기서 e = log(2k − 1) / log(k)입니다.
