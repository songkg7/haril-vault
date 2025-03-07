---
title: Database
date: 2023-02-09T16:35:00
aliases: DB
tags:
  - database
categories: 
updated: 2025-01-07T00:35
---

## 데이터베이스 관리 시스템

### 01. 데이터베이스 관리 시스템의 등장 배경

과거에는 데이터를 관리하기 위해 파일시스템을 사용했다. 별도의 구매 비용이 들지 않는다는 장점이 있지만 응용 프로그램마다 파일을 따로 유지하는 특징 때문에 다음과 같은 문제가 발생한다.

- 같은 내용의 데이터가 여러 파일에 중복 저장된다
- 응용프로그램이 데이터 파일에 종속적이다
- 데이터 파일에 대한 동시 공유, 보안, 회복 기능이 부족하다
- 응용 프로그램을 개발하기 쉽지 않다

### 02. 데이터베이스 관리 시스템의 정의

> DataBase Management System (DBMS)

DBMS 는 파일 시스템의 데이터 중복과 데이터 종속 문제를 해결하기 위해 제시된 소프트웨어다. 데이터베이스 관리 시스템이 제공하는 주요 기능은 다음 세가지로 요약할 수 있다.

#### 정의 기능

데이터베이스 관리 시스템은 조직에 필요한 데이터를 저장하기 적합한 데이터베이스 구조를 정의하거나, 이미 정의된 구조를 수정할 수 있다.

#### 조작 기능

사용자 요구에 따라 데이터를 삽입 삭제 수정 검색 하는 연산을 효율적으로 처리한다.

#### 제어 기능

데이터를 여러 사용자가 공유해도 항상 정확하고 안전하게 유지하는 기능을 제공한다.

### 03. 데이터 베이스 관리 시스템의 장단점

#### 장점

1. 데이터 중복을 통제할 수 있다
2. 데이터 독립성이 확보된다
3. 데이터를 동시 공유할 수 있다
4. 데이터 보안이 향상된다
5. 데이터 무결성을 유지할 수 있다
6. 표준화할 수 있다
7. 장애 발생 시 회복이 가능하다
8. 응용 프로그램 개발 비용이 줄어든다

#### 단점

1. 비용이 많이 든다
2. 백업과 회복 방법이 복잡하다
3. 중앙 집중 관리로 인한 취약점이 존재한다

### 04. 데이터베이스 관리 시스템의 발전 과정

크게 4세대로 분류하고, 사용하는 데이터 모델에 따라 네트워크 DBMS, 계층 DBMS, 관계 DBMS, 객체지향 DBMS, 객체관계 DBMS, NoSQL, NewSQL 로 나눈다.

- 1세대 : 네트워크 DBMS, 계층 DBMS
- 2세대 : 관계 DBMS
- 3세대 : 객체지향 DBMS, 객체관계 DBMS
- 4세대 : NoSQL DBMS, NewSQL DBMS

## 데이터베이스 시스템

### 01. 데이터베이스 시스템의 정의

### 02. 데이터베이스의 구조

### 03. 데이터베이스 사용자

### 04. 데이터 언어

### 05. 데이터베이스 관리 시스템의 구성
