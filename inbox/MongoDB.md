---
title: MongoDB
date: 2022-09-13 11:45:00 +0900
aliases: null
tags:
  - mongodb
  - nosql
categories: MongoDB
updated: 2023-08-19 12:38:12 +0900
---

## Overview

### What is MongoDB

기존 [[Database]] 의 단점 보완을 위해 Custom data store 개발

확장성과 신속성에서 자주 문제가 발생

DB 개발

텐젠이라는 이름으로 제공되다가 2013년에 MongoDB 로 사명이 변경

Document 기반 DB model 중엔 압도적 1위 전체 5위이지만 1~4위가 모두 관계형 데이터베이스

- schema 가 자유롭다.
- HA 와 Scale out solution 을 자체적으로 지원해서 확장이 쉽다.
- [[Secondary Index]] 를 지원하는 NoSQL
- 다양한 종류의 index 를 제공한다.
- 응답속도가 빠르다.
- 배우기 쉽고 간편하게 개발이 가능하다.

MongoDB 는 유연하고 확장성 높은 Opensource Document 지향 DB 이다.

### SQL vs NoSQL

2000년대 초반에 생성된 유저 테이블은 이메일을 회원간 연락 수단으로서 제공하고 있었다. 하지만 시대가 발전하면서 SNS 가 새로운 연락수단으로 등장했고, 해당 컬럼들이 유저 테이블에 추가되었다.

문제는 유저들이 모든 SNS 서비스를 이용하진 않는다는 것에 있었다. 그로 인해 테이블에 필연적으로 빈 곳이 생기게 되었고, query 사용이나 테이블 조회에서 애로사항이 발생하게 되었다.

관계형 DB 는 이 문제를 정규화라는 방식으로 풀어내기 시작했다. 유저 테이블을 주소 테이블, SNS 테이블, 핸드폰 테이블 등으로 분리하고 유저 테이블에는 FK 를 통해 연관관계를 생성하여 관리했다.

이 방법은 꽤나 좋았다.

- 데이터 중복을 방지할 수 있다.
- Join 의 성능이 좋다.
- 복잡하고 다양한 쿼리가 가능하다.
- 잘못된 입력을 방지할 수 있다.

하지만 여전히 단점이 존재했다.

- 하나의 레코드를 확인하기 위해 여러 테이블을 Join 해야해서 가시성이 떨어진다.
- 스키마가 엄격해서 변경에 대한 공수가 크다.
- Scale out 이 가능하지만, 설정이 어려웠다.
- 확장할 때마다 App 단의 수정이 필요하다.
- 전통적으로 Scale up 위주로 확장했다.

> [!INFO] 왜 데이터베이스는 이렇게 제한되고 복잡하게 되었을까?
> 관계형 데이터베이스는 1970년대부터 사용되었는데, 당시 Disk storage 가 매우 고가의 제품으로 데이터의 중복을 줄이는데에 집중했다. 그래서 데이터를 입력할 때 중복이 발생하지 않도록 많은 제한을 두도록 결정했고, Disk 의 큰 덩치를 감당할 수 없었기에 scale out 의 개념이 등장할 수 없었다.

시간이 지나며 disk 의 사이즈는 손톱만해졌고, 더 이상 중복을 걱정하는 것은 의미가 없을만큼 용량이 커졌다. 드디어 수평적인 확장, scale-out 에 대한 개념이 등장하기 시작했다.

MongoDB 는 기존 DB 의 단점을 보완하고 scale out 을 적극적으로 지원한다.

- 데이터 접근성과 가시성이 좋다.
- Join 없이 조회가 가능해서 응답속도가 일반적으로 빠르다.
- 스키마 변경에 공수가 적다.
- 스키마가 유연해서 데이터 모델을 App 의 요구사항에 맞게 수용할 수 있다.
- HA 와 Sharding 에 대한 솔루션을 자체적으로 지원하고 있어서 Scale out 이 간편하다.
- 확장시 application 의 변경이 없다.

단점은 다음과 같다.

- 데이터 중복이 발생한다.
- 스키마 설계를 잘해야 성능 저하를 피할 수 있다.

즉,

MongoDB 는 유연하고 확장성 높은 Opensource Document 지향 DB 이다.

### Architecture

표현은 json 으로 해주지만 실제 저장은 bson 을 사용한다.

#### Collection 특징

- 동적 스키마를 갖고 있어서 스키마를 수정하려면 필드값을 추가/수정/삭제하면 된다.
- Collection 단위로 index 를 생성할 수 있다.
- Collection 단위로 Shard 를 나눌 수 있다.

#### Document 특징

- Json 형태로 표현하고 Bson(Binary Json) 형태로 저장한다.
- 모든 Document 에는 `_id` 필드가 있고, 없이 생성하면 ObjectId 타입의 고유한 값을 저장한다.
- 생성 시, 상위 구조인 Database 나 Collection 이 없다면 먼저 생성하고 Document 를 생성한다.
- Document 의 최대 크기는 16MB 이다.

## Reference

- [MongoDB 이해하기](https://kciter.so/posts/about-mongodb)
