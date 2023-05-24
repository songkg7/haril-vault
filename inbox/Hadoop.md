---
title: "Hadoop"
date: 2023-05-24 20:12:00 +0900
aliases: HDFS
tags: [apache, distribute, open-source, hdfs]
categories: 
updated: 2023-05-24 20:16:24 +0900
---

## 하둡이란?

하둡(Hadoop)은 대규모 데이터를 처리하기 위한 Apache Software Foundation에서 개발한 오픈소스 분산 컴퓨팅 플랫폼이다. 하둡은 데이터를 여러 대의 서버에 분산 저장하고 처리하는 방식으로 동작한다. 이를 위해 하둡은 HDFS(Hadoop Distributed File System)와 MapReduce 라는 두 가지 기술을 사용한다.

HDFS는 대용량 파일을 여러 블록으로 나누어 분산 저장하고, 이들 블록을 여러 대의 컴퓨터에 저장하며, 이들 각각의 블록을 복제하여 안정성을 보장한다. MapReduce는 데이터를 분산 처리하기 위한 프로그래밍 모델로, 맵(Map)과 리듀스(Reduce)라는 두 가지 함수를 사용하는 방식이다. 맵 함수는 입력 데이터를 키-값 쌍으로 변환한 후, 리듀스 함수가 이들 값을 집계하여 최종 결과를 생성한다.

하둡은 다양한 언어와 도구에서 접근할 수 있는 API를 제공하며, 기업에서는 하둡 Ecosystem인 [[Hive]], [[Pig]], [[Spark]] 등 다양한 도구들을 활용하여 비즈니스 인텔리전스(BI), 데이터 마이닝 등 다양한 목적으로 활용되고 있다.
