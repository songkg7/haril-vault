---
title: database internals study
date: 2024-07-04 19:14:00 +0900
aliases: 
tags: 
categories: 
description: 
updated: 2024-10-05 11:44:36 +0900
---

첫시간인데 바로 공부만 하는 것도 삭막하니까 간단하게 자기소개나 하고 진행방식을 정리하고 진행하는게 좋을 것 같다. 그럼에도 불구하고 미리 앞부분을 읽어와달라고 한 이유는, 이 책의 난이도를 모두 인지하고 그에 따른 진도를 확정하기 위해서.

- 간단한 자기소개
- 진행 방식 공유
    - 매주 2명 선정(정, 부)해서 2명이 다음 내용을 준비해온다.
        - 본인이 준비할 수 있을 만큼만 준비해오면 된다.
    - 참여가 어려울 경우 미리 알려주기
    - 해야할 내용이 많아서, 시간관계상 건너뛰지 않고 매주 진행
    - 조금 깊게 다루려면 매주 2장씩이 아니라 1장씩 준비하는게 나을수도

---

- 책을 스캔해서 PDF 로 준비하면 좋을 듯
- 단순히 책의 내용을 해설하기보다는, '함께 읽기' 가 메인 주제인만큼 읽어오셨다고 가정한 상태에서 언급할만한 부분들에 대해서만 이야기할 것
- 1부는 스토리지 엔진에 대한 이야기, 2부는 분산 시스템

## 1장. 소개 및 개요

> 데이터베이스의 주목적은 데이터를 안정적으로 저장하고 사용자에게 제공하는 것. 데이터 저장 및 검색 기능을 개발자가 고려할 필요가 없도록 도와준다.

- 데이터베이스는 일종의 모듈식 애플리케이션
- 간략한 분류와 개괄적인 내용 소개, 용어 정리가 주를 이루고 있음

데이터베이스 분류는 OLTP, OLAP, HTAP 처럼 할 수도 있고,

- 온라인 트랜잭션 처리(OLTP) 데이터베이스: 대량의 사용자 요청과 트랜잭션을 처리
- 온라인 분석 처리(OLAP) 데이터베이스: 복잡한 집계 작업을 처리
    - Amazon Redshift, Snowflake, Apache Kylin 등

### DBMS 구조

- 쿼리 프로세서, 실행 엔진, 스토리지 엔진
- 쿼리 분석 -> 옵티마이저가 최적화 -> 선택된 실행 계획을 바탕으로 실행 엔진이 실행
    - 여러 노드간 쓰기 및 복제를 포함하는 원격 실행도 실행엔진이 실행
- 로컬에 반영되어야 하는 쿼리는 스토리지 엔진이 수행
    - 트랜잭션, 잠금, 엑세스, 버퍼, 복구 등의 역할을 수행하는 개별 컴포넌트로 구성

### 인메모리 DBMS 대 디스크 기반 DBMS

- 주 저장소로 메모리를 사용하는지, 디스크를 사용하는지의 차이
- 메모리는 빠르지만 비싸고 휘발될 가능성이 있다.
- 디스크는 느리지만, 상대적으로 저렴하며 반영구적이다.

#### 인메모리 데이터베이스의 지속성

- 데이터 손실을 방지하기 위해 디스크에 백업
- [[WAL]], write ahead log
- 수정 내용은 비동기적으로 갱신하며 I/O 작업을 최소화하기 위해 배치 단위로 백업
- 복구 시에는 백업본과 로그를 기반으로 데이터를 재구성

> [!NOTE] 큰 페이지 캐시를 사용하는 디스크 기반 DBMS 와 무엇이 다른가
> 인메모리 DBMS 와 큰 페이지 캐시를 사용하는 디스크 기반 DBMS 는 같아 보인다. 하지만 디스크 기반 DBMS 는 페이지 전체를 메모리에 캐시해도 직렬화와 데이터 레이아웃을 유지하는 오버헤드가 있어서 인메모리 DBMS 의 성능을 능가할 수 없다.

### 칼럼형 DBMS 대 로우형 DBMS

- 로우형 DBMS: [[MySQL]] 과 [[PostgreSQL]] 등 대부분의 전통적 관계형 데이터베이스
    - 페이지 단위로 읽어오기 때문에 단건 조회는 유리하지만 집계 처리에 불리
    - 레코드 단위로 저장하기 때문에 데이터의 완결성이 보장
    - 새로운 레코드를 디스크에 추가할 때는 원본 데이터의 가장 끝에 추가하면 된다 => 빠름
    - 공간지역성이 높다
- 칼럼형 DBMS: [[Oracle]] 의 Exadata, Amazon Redshift, BigQuery, Cassandra, HBase* 등등
    - 데이터의 추세와 평균 등을 계산하는 분석 작업에 적합
    - 중복도를 높일 수 있으므로 압축에 매우 유리 -> 대규모 데이터셋 유지 가능
    - 동시성, 삽입, 삭제 과정에서는 성능이 낮다. -> 새로운 레코드를 추가하려면 컬럼별로 어느 위치에 넣어야하는지 새로 계산해야 하기 때문
- [컬럼형 DB는 왜 빠른가 – DATA ON-AIR](https://dataonair.or.kr/db-tech-reference/d-lounge/expert-column/?mod=document&uid=52606)
- [\[DB\] 열 기반 데이터베이스 vs 행 기반 데이터베이스](https://chaarlie.tistory.com/674)

### 데이터 파일과 인덱스 파일

- 저장 효율성
- 접근 효율성
- 갱신 효율성

위 조건을 만족하기 위해 일반 파일 대신 특수한 포맷을 사용한다.

- [CTO가 커리어를 걸고 비트 레벨까지 내려가서 DB를 해킹했던 이야기](https://tech.devsisters.com/posts/bit-level-database-hacking/)

레코드의 위치를 효율적으로 찾기 위해 인덱스를 사용하며, 인덱스는 레코드를 식별할 수 있는 필드들의 부분집합을 통해 데이터 파일과는 별도로 구축된다.

기본 인덱스를 통한 간접 참조

- 기본 인덱스와 보조 인덱스가 모두 데이터를 직접 참조하는 경우
    - 데이터 접근 빠름
    - 데이터가 변경되면 인덱스를 모두 갱신해야 하는 오버헤드 존재
- 보조 인덱스가 기본 인덱스의 참조를 가지고, 기본 인덱스로 데이터를 참조하는 경우
    - 기본 인덱스를 한 번 스캔하고, 데이터를 찾기 때문에 기본 인덱스 스캔 비용이 추가
    - 데이터가 변경되어도 기본 인덱스만 갱신하면 되므로 포인터 갱신을 줄일 수 있음

### 버퍼링과 불변성, 순서화

#### 버퍼링

- 데이터를 디스크에 쓰기 전 일부를 메모리에 저장하는 것
- 디스크와 데이터를 주고 받는 가장 작은 단위는 블록이므로 블록을 채워서 쓰는 것이 바람직하기 때문

#### 가변성

- 파일을 제자리에서(in-place) 수정하는지에 대한 여부를 나타내는 속성
- copy on write 방식 등으로 구현할 수 있다

#### 순서화

- 디스크 페이지에 데이터 레코드를 키 순서로 저장하는 것
- 인접한 키는 디스크의 연속된 세그먼트에 저장된다.
- 효율적인 범위 스캔에 매우 중요
- append only 로 저장하면 쓰기 순서를 최적화할 수 있다.

## 2장. B-트리 개요

### 이진 탐색 트리

### 디스크 기반 자료 구조

- HDD
- SDD

### 디스크 기반 자료 구조

- 블록이라는 작업 단위의 제약이 디스크 기반 자료 구조를 효율적으로 설계하기 어렵게 한다
- 저장 매체의 구조를 고려해서 설계해야 하며, 디스크 접근 횟수를 최소화해야 한다.
- 지역성을 높여서 페이지를 넘나드는 포인터를 최소화해야 한다.

### 유비쿼터스 B-트리

- 해시가 가장 빠르지 않나
- 랜덤 엑세스와 페이징, 그리고 공간 지역성 = range query
- 이진 트리와 균형 트리
- 리밸런싱의 오버헤드, 트리 높이 문제
- [[B-Tree]]
    - 인접한 키의 지역성을 높이기 위한 팬아웃
    - 디스크 탐색 횟수를 줄이기 위한 낮은 트리 높이

- [(1부) B tree의 개념과 특징, 데이터 삽입이 어떻게 동작하는지를 설명합니다! (DB 인덱스과 관련있는 자료 구조) - YouTube](https://www.youtube.com/watch?v=bqkcoSm_rCs)

## 5장. 트랜잭션 처리와 복구

- 내용이 좀 길다
- WAL 에 대한 내용
- 익숙한 내용들이긴 하다
- 

## 6장. B-트리의 변형

- 상당히 고급 [[B-Tree]] 이야기

---

## 7장. 로그 구조 스토리지

- 불변으로 관리하면 롤백이 쉽다.
    - 옵시디언 관련 플러그인을 만들 때 복사본을 사용해서 파일을 변경했다. 문제가 생기면 복사본만 지우면 된다.
    - 불변 속성은 이런 스토리지 뿐만 아니라 여러 방면에서 유리하다.
- 여러 파일이 존재하면 원하는 버전을 찾기 위해 읽기 비용이 증가한다. -> 읽기 증폭
- 읽기 증폭은 효율적인 컴팩션으로 방지한다
- SSTable, 데이터가 정렬되어 있다면 데이터 조회도 빠르며 컴팩션도 효율적으로 수행할 수 있다.