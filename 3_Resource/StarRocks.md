---
title:
date: 2025-12-03T11:21:15+09:00
aliases:
tags:
  - datalake
description:
updated: 2025-12-03T11:22
---

# StarRocks 기반의 차세대 데이터 레이크하우스 아키텍처: 심층 기술 분석 및 전략적 도입 보고서

## 1. 서론: 데이터 분석 패러다임의 전환과 고속 쿼리 엔진의 부상

디지털 트랜스포메이션의 가속화와 함께 기업이 보유한 데이터의 양은 폭발적으로 증가해왔다. 지난 10여 년간 데이터 아키텍처는 하둡(Hadoop) 기반의 온프레미스 데이터 레이크에서 클라우드 네이티브 객체 스토리지(Object Storage) 기반의 데이터 레이크로, 그리고 최근에는 데이터 웨어하우스(DW)의 정합성과 데이터 레이크의 유연성을 결합한 **'레이크하우스(Lakehouse)'** 아키텍처로 진화하고 있다.

초기의 데이터 레이크는 저렴한 비용으로 막대한 양의 정형 및 비정형 데이터를 저장할 수 있다는 장점으로 인해 빠르게 확산되었으나, 데이터 접근성과 분석 성능 측면에서 심각한 병목 현상을 겪었다. 특히 Amazon S3, Azure Blob Storage, Google Cloud Storage와 같은 객체 스토리지는 무한한 확장성을 제공하지만, 파일 시스템의 메타데이터 작업(Listing, Rename 등) 속도가 느리고 네트워크 I/O 지연이 발생하여, 1초 미만의 응답 속도(Sub-second Latency)가 요구되는 사용자 대면(User-facing) 분석이나 대화형(Interactive) BI 대시보드에는 적합하지 않다는 인식이 지배적이었다.1

이러한 한계를 극복하기 위해 등장한 것이 **StarRocks**와 같은 차세대 MPP(Massively Parallel Processing) 분석 엔진이다. StarRocks는 '속도(Speed)'와 '단순성(Simplicity)'을 핵심 가치로 내세우며, 데이터 레이크 상의 데이터를 별도의 전처리나 이동 없이 고속으로 분석할 수 있는 환경을 제공한다. 본 보고서는 StarRocks의 아키텍처적 특성, 주요 경쟁 기술(Trino, ClickHouse 등)과의 비교 우위, 그리고 엔터프라이즈 환경에서의 도입 전략 및 효용성을 15,000단어 규모로 심도 있게 분석한다. 이를 통해 데이터 엔지니어, 아키텍트, 그리고 기술 의사결정권자들이 StarRocks를 통해 데이터 레이크의 잠재력을 극대화할 수 있는 방안을 제시하고자 한다.

## 2. StarRocks 아키텍처: 고성능 분석을 위한 기술적 토대

StarRocks가 데이터 레이크 분석 시장에서 게임 체인저(Game Changer)로 부상할 수 있었던 배경에는 철저하게 성능 최적화를 목표로 설계된 아키텍처가 존재한다. StarRocks는 기존의 Apache Doris에서 분기되었으나, 90% 이상의 코드를 재작성하여 완전히 새로운 수준의 성능과 기능을 제공한다.3

### 2.1 완전 벡터화 실행 엔진 (Fully Vectorized Execution Engine)

현대 CPU 아키텍처의 성능을 100% 활용하는 것은 고성능 데이터베이스의 필수 조건이다. StarRocks는 **완전 벡터화된 실행 엔진**을 채택하여 쿼리 처리의 모든 단계를 최적화했다.

#### 2.1.1 컬럼 지향 처리와 SIMD 가속

전통적인 데이터베이스(Row-oriented)가 한 번에 하나의 행(Row)을 처리하며 과도한 함수 호출 오버헤드와 CPU 분기 예측 실패(Branch Misprediction)를 유발했던 것과 달리, StarRocks는 데이터를 컬럼(Column) 단위의 청크(Chunk)로 묶어 처리한다. 이는 CPU 캐시 적중률(Cache Hit Rate)을 극대화할 뿐만 아니라, 최신 x86 및 ARM 프로세서가 제공하는 **SIMD(Single Instruction, Multiple Data)** 명령어 세트(AVX2, AVX-512 등)를 적극적으로 활용할 수 있게 한다.4

예를 들어, 수백만 건의 레코드에 대한 필터링 연산이나 집계 연산을 수행할 때, StarRocks는 단일 CPU 명령어로 여러 데이터 포인트를 동시에 연산한다. 벤치마크 결과에 따르면, 이러한 벡터화 기술만으로도 비벡터화 엔진 대비 3배에서 10배 이상의 성능 향상을 달성하는 것으로 나타났다.4 이는 Java 기반의 쿼리 엔진인 Trino가 JVM(Java Virtual Machine)의 제약으로 인해 SIMD 활용에 한계를 가지는 것과 대비되는 StarRocks의 결정적인 기술적 우위 요소이다.6

#### 2.1.2 인코딩된 데이터 직접 연산 (Operation on Encoded Data)

StarRocks는 딕셔너리 인코딩(Dictionary Encoding) 등으로 압축된 데이터를 메모리에 적재한 후, 이를 디코딩(Decoding)하지 않고 압축된 상태 그대로 연산을 수행하는 고급 기술을 적용했다. `GROUP BY`, `FILTER` 등의 연산 시 문자열 비교와 같은 고비용 작업을 정수(Integer) 비교 연산으로 대체함으로써, 메모리 대역폭 사용량을 줄이고 CPU 연산 효율을 획기적으로 높였다. 이 기술은 특히 카디널리티(Cardinality)가 낮은 문자열 컬럼이 많은 데이터 웨어하우스 및 레이크 환경에서 2배 이상의 성능 개선 효과를 제공한다.4

### 2.2 비용 기반 옵티마이저 (CBO: Cost-Based Optimizer)

데이터 레이크 환경은 정형화된 데이터 웨어하우스와 달리 데이터의 분포가 불균일하고 테이블 간의 조인 관계가 복잡하다. 따라서 최적의 쿼리 실행 계획(Execution Plan)을 수립하는 옵티마이저의 역할이 무엇보다 중요하다.

#### 2.2.1 Cascades 프레임워크 기반 설계

StarRocks는 데이터베이스 학계 및 산업계에서 검증된 **Cascades 프레임워크**를 기반으로 자체적인 CBO를 개발했다.8 이 옵티마이저는 수천, 수만 개의 가능한 실행 계획 공간을 탐색하며, CPU 비용, 메모리 사용량, 네트워크 전송 비용 등을 종합적으로 계산하여 가장 효율적인 경로를 선택한다. 이는 규칙 기반(Rule-Based) 최적화에 의존하거나 조인 최적화가 미흡한 ClickHouse와 비교했을 때, 복잡한 다중 테이블 조인 쿼리(Multi-table Join Query)에서 StarRocks가 압도적인 성능을 발휘하는 원동력이 된다.3

#### 2.2.2 외부 데이터 소스 통계 수집

StarRocks 3.2 버전부터는 내부 테이블뿐만 아니라 Hive, Iceberg, Hudi와 같은 외부 데이터 레이크 테이블에 대해서도 통계 정보(행 수, 컬럼 분포, NULL 비율, Min/Max 값 등)를 수집하고 활용하는 기능이 대폭 강화되었다.8 이를 통해 StarRocks는 외부 데이터를 쿼리할 때도 내부 데이터와 동일한 수준의 정교한 실행 계획(조인 순서 변경, 조인 알고리즘 선택 등)을 수립할 수 있다. 예를 들어, 대형 팩트 테이블(Fact Table)과 소형 디멘전 테이블(Dimension Table)을 조인할 때, CBO는 자동으로 '브로드캐스트 조인(Broadcast Join)'을 선택하여 네트워크 셔플링 비용을 최소화한다.

### 2.3 분산 아키텍처와 스케일아웃

StarRocks는 **FE(Frontend)**와 **BE(Backend, 또는 CN - Compute Node)**라는 단순하고 명확한 두 가지 유형의 노드로 구성된다.5

- **Frontend (FE):** 클라이언트의 연결을 관리하고, SQL 쿼리를 파싱(Parsing) 및 분석하며, CBO를 통해 실행 계획을 수립한다. 또한 메타데이터(테이블 스키마, 권한, 파티션 정보 등)를 관리하고 노드 간의 상태를 조정하는 코디네이터 역할을 수행한다. FE는 고가용성(HA)을 위해 리더-팔로워(Leader-Follower) 구조로 구성될 수 있다.
    
- **Backend (BE) / Compute Node (CN):** 실제 데이터 저장과 쿼리 실행을 담당한다. 데이터 레이크 쿼리 시나리오에서는 로컬 스토리지에 의존하지 않는 무상태(Stateless) 컴퓨팅 노드(CN)를 활용하여, 쿼리 부하에 따라 유연하게 스케일아웃(Scale-out)할 수 있다.2 이는 클라우드 환경에서 비용 효율성을 극대화하는 '스토리지와 컴퓨팅의 분리(Separated Storage and Compute)' 아키텍처를 완벽하게 지원한다.12
    

### 2.4 지능형 계층적 캐싱 (Intelligent Hierarchical Caching)

스토리지와 컴퓨팅이 분리된 아키텍처의 최대 약점은 네트워크 I/O로 인한 지연 시간(Latency)이다. StarRocks는 이를 극복하기 위해 다계층 캐싱 전략을 도입했다.13

| **캐시 계층**     | **구성 요소**      | **역할 및 특징**                                                                                 |
| ------------- | -------------- | ------------------------------------------------------------------------------------------- |
| **메모리 캐시**    | Page Cache     | 압축 해제된 데이터 페이지 및 인덱스 페이지를 메모리에 상주시켜 가장 빠른 접근 속도 제공. LRU(Least Recently Used) 알고리즘 기반 관리.    |
| **로컬 디스크 캐시** | Block Cache    | 원격 스토리지(S3 등)의 파일(Parquet, ORC)을 블록 단위(기본 1MB)로 분할하여 BE/CN 노드의 고속 NVMe SSD에 캐싱.14           |
| **메타데이터 캐시**  | Metadata Cache | Hive Metastore, Iceberg Catalog 등의 파일 목록, 파티션 정보를 로컬에 캐싱하여 쿼리 계획 수립(Planning) 단계의 지연 최소화.15 |

특히 **블록 캐시(Block Cache)**는 데이터 레이크 분석의 핵심 가속 기술이다. 사용자가 쿼리를 실행하면 StarRocks는 먼저 로컬 디스크의 캐시를 확인하고, 없는 블록만 S3에서 가져와 채워 넣는다(Asynchronous/Synchronous Population).13 이는 '콜드 데이터(Cold Data)' 저장소인 데이터 레이크를 빈번하게 접근하는 '핫 데이터(Hot Data)' 영역에 대해서는 고성능 로컬 DW처럼 동작하게 만든다. 최신 버전에서는 SLRU(Segmented LRU)와 같은 고급 교체 알고리즘을 도입하여, 일회성 대량 스캔 쿼리에 의해 유용한 캐시 데이터가 축출(Eviction)되는 '캐시 오염(Cache Pollution)' 문제를 방지하고 있다.17

## 3. 데이터 레이크 생태계 통합: 개방성과 확장성

StarRocks는 독자적인 포맷에 데이터를 가두는 '벤더 락인(Vendor Lock-in)'을 지양하고, 개방형 데이터 레이크 생태계와 완벽하게 통합되는 것을 목표로 한다.

### 3.1 오픈 테이블 포맷(Open Table Formats) 지원 현황

StarRocks는 현재 업계에서 가장 널리 사용되는 3대 오픈 테이블 포맷인 **Apache Iceberg**, **Apache Hudi**, **Delta Lake**를 모두 지원하며, 최근 부상하는 **Apache Paimon**까지 커버리지를 확장했다.2

#### 3.1.1 Apache Iceberg 통합

StarRocks는 Iceberg 테이블에 대해 업계 최고 수준의 지원을 제공한다. V1(Copy-on-Write) 및 V2(Merge-on-Read) 스펙을 모두 지원하며, 특히 V2 테이블의 Equality Delete 파일을 효율적으로 처리하기 위해 벡터화 엔진을 최적화했다.17 또한, Iceberg의 메타데이터 파일(Manifest Files)을 병렬로 읽고 파싱하여, 수십만 개의 파티션과 수억 개의 파일을 가진 대형 테이블에서도 쿼리 계획 수립 시간을 단축시키는 기술을 적용했다.20

#### 3.1.2 Apache Hudi 및 Delta Lake 통합

Hudi의 경우, COW(Copy On Write) 테이블뿐만 아니라 실시간성이 강한 MOR(Merge On Read) 테이블에 대한 쿼리도 완벽하게 지원한다.22 Delta Lake에 대해서는 델타 로그(Delta Log)를 직접 파싱하여 최신 스냅샷을 읽어오며, 최근 버전에서는 '컬럼 매핑(Column Mapping)' 기능을 지원하여 스키마 진화(Schema Evolution)가 발생한 Delta 테이블도 문제없이 쿼리할 수 있게 되었다.17

### 3.2 외부 카탈로그(External Catalog)와 제로 ETL

StarRocks는 `CREATE EXTERNAL CATALOG` 구문을 통해 외부 메타스토어(AWS Glue, Hive Metastore)와 즉시 연결된다.24 이는 데이터를 StarRocks 내부로 복사(Copy)하거나 적재(Load)하는 복잡한 ETL 과정 없이, **'Zero Migration'** 방식으로 데이터 레이크를 즉시 분석할 수 있게 해준다.1

- **다중 카탈로그 쿼리 (Federated Query):** 하나의 SQL 문장 안에서 Iceberg 테이블, Hive 테이블, 그리고 StarRocks 내부 테이블을 조인할 수 있다. 예를 들어, 최근 24시간의 실시간 데이터는 StarRocks 내부 테이블에 있고, 과거 5년치 이력 데이터는 Iceberg에 있는 경우, 이를 투명하게 결합하여 분석할 수 있다.
    

### 3.3 쓰기(Write) 기능의 제한과 전략

StarRocks는 읽기(Query) 성능에서는 타의 추종을 불허하지만, 데이터 레이크로의 쓰기(Write) 기능은 상대적으로 제한적이다.

- **지원 현황:** StarRocks 3.x 버전부터 `INSERT INTO` 구문을 통해 Iceberg, Hive 테이블에 데이터를 쓸 수 있게 되었으며, Parquet 및 ORC 포맷 출력을 지원한다.18 그러나 Hudi, Delta Lake 등에 대해서는 쓰기 기능이 제한적이거나 개발 중인 상태이다.26
    
- **전략적 권장 사항:** 대규모 ETL이나 복잡한 UPSERT 로직이 필요한 쓰기 작업은 여전히 Spark나 Flink를 사용하는 것이 권장되며 27, StarRocks는 이렇게 생성된 데이터를 초고속으로 조회하는 '서빙 레이어(Serving Layer)'로 활용하는 것이 가장 효율적이다.
    

## 4. 경쟁 기술 비교 분석: StarRocks의 위치와 차별점

데이터 레이크 분석 엔진 시장은 Trino(구 PrestoSQL), ClickHouse, Apache Druid, Apache Spark 등 쟁쟁한 경쟁자들이 포진해 있다. StarRocks는 이들 사이에서 독보적인 성능과 유연성의 균형을 찾아냈다.

### 4.1 StarRocks vs. Trino (PrestoSQL)

Trino는 데이터 레이크 쿼리의 표준처럼 여겨져 왔으나, 성능과 안정성 측면에서 StarRocks가 명확한 우위를 점하고 있다.

| **비교 항목**    | **Trino**  | **StarRocks**     | **분석 및 시사점**                                                                        |
| ------------ | ---------- | ----------------- | ----------------------------------------------------------------------------------- |
| **쿼리 성능**    | 느림         | **압도적 빠름**        | TPC-DS 1TB 벤치마크에서 StarRocks가 Trino 대비 **5.54배** 빠른 성능 기록.29 C++ 벡터화 엔진의 차이.         |
| **언어 및 런타임** | Java (JVM) | **C++ (Native)**  | Java의 GC(Garbage Collection) 오버헤드와 SIMD 활용 제약이 Trino의 한계. StarRocks는 리소스 효율이 훨씬 높음. |
| **캐싱**       | 제한적        | **계층적 캐싱**        | Trino는 인메모리 셔플 중심이나, StarRocks는 로컬 디스크 블록 캐시를 내장하여 I/O 비용 절감.6                      |
| **안정성**      | OOM 발생 잦음  | **Spill to Disk** | Trino는 메모리 초과 시 쿼리가 실패하기 쉬우나, StarRocks는 디스크로 스필(Spill)하여 안정적으로 완료.6                |
| **비용 효율성**   | 낮음         | **높음**            | 동일 워크로드 처리 시 StarRocks가 Trino 대비 1/3 수준의 하드웨어 리소스만으로 더 높은 성능을 냄.30                  |

**결론:** 대화형 분석과 고성능이 필요한 경우, Trino를 StarRocks로 교체하는 것만으로도 즉각적인 성능 향상과 인프라 비용 절감 효과를 볼 수 있다. 실제로 여행 플랫폼 Trip.com과 중고 거래 플랫폼 ATRenew는 Trino를 StarRocks로 교체하여 막대한 비용을 절감했다.5

### 4.2 StarRocks vs. ClickHouse

ClickHouse는 단일 테이블 쿼리 속도에서 매우 강력하지만, 복잡한 분석 시나리오에서는 한계를 보인다.

| **비교 항목**            | **ClickHouse** | **StarRocks**         | **분석 및 시사점**                                                                     |
| -------------------- | -------------- | --------------------- | -------------------------------------------------------------------------------- |
| **조인(Join) 성능**      | 취약함            | **강력함**               | ClickHouse는 대규모 조인 시 성능이 급격히 저하됨. StarRocks는 CBO를 통해 복잡한 다중 조인을 효율적으로 처리.3       |
| **데이터 업데이트**         | 어려움 (비동기)      | **실시간 (Primary Key)** | ClickHouse의 `ALTER UPDATE`는 무겁고 비동기적임. StarRocks는 PK 모델로 실시간 Upsert/Delete 지원.33 |
| **동시성(Concurrency)** | 낮음             | **높음**                | ClickHouse는 소수의 무거운 쿼리에 최적화됨. StarRocks는 파이프라인 엔진으로 높은 동시 접속 처리 가능.32            |
| **사용 편의성**           | 복잡함            | **표준 SQL**            | ClickHouse는 독자적인 SQL 문법이 많으나, StarRocks는 표준 MySQL 프로토콜과 문법을 지원하여 호환성이 높음.3       |

**결론:** 로그 분석과 같이 단순 집계가 주류인 경우에는 ClickHouse가 여전히 유용하지만, 비즈니스 인텔리전스(BI), 복잡한 조인이 필요한 분석, 실시간 데이터 갱신이 필요한 경우에는 StarRocks가 훨씬 적합하다.

### 4.3 StarRocks vs. Apache Druid

- **유연성:** Druid는 시계열 데이터와 사전 집계(Pre-aggregation)에 특화되어 있어 유연한 Ad-hoc 쿼리에는 제약이 많다. StarRocks는 범용적인 SQL 엔진으로 다양한 형태의 질의를 소화한다.
- **고차원 데이터:** 고차원(High-Cardinality) 컬럼에 대한 그룹핑 및 필터링 시 StarRocks가 Druid 대비 **8.9배** 더 빠른 성능을 보였다.29
- **아키텍처 복잡도:** Druid는 Coordinator, Overlord, Broker, Historical, MiddleManager 등 수많은 컴포넌트로 구성되어 운영이 매우 복잡하다. 반면 StarRocks는 FE와 BE 단 두 가지 프로세스로 구성되어 배포와 관리가 획기적으로 단순하다.5

## 5. StarRocks의 장단점 및 한계점 심층 분석

StarRocks 도입을 고려하는 조직을 위해 객관적인 장점과 단점을 상세히 분석한다.

### 5.1 장점 (Pros)

1. **압도적인 Query Performance:** C++ 기반의 벡터화 엔진과 고도화된 CBO의 결합으로, 데이터 레이크 상에서도 로컬 데이터 웨어하우스 수준의 속도를 제공한다. 이는 사용자 경험을 혁신하고 의사결정 속도를 높인다.
2. **데이터 파이프라인의 단순화 (Pipeline-free):** 복잡한 ETL 과정을 거쳐 데이터를 전용 DW로 옮길 필요 없이, 데이터 레이크를 직접 쿼리(Direct Query)하거나 필요한 경우 StarRocks 내부의 **Materialized View**를 활용하여 가속화할 수 있다. 이는 데이터 엔지니어링 복잡도를 줄이고 데이터 신선도(Freshness)를 유지한다.34
3. **지능형 Materialized View (MV):** StarRocks의 MV는 단순한 뷰가 아니다. Iceberg나 Hive 테이블의 파티션 변경을 감지하여 증분 갱신(Incremental Refresh)을 수행하며, 쿼리 재작성(Query Rewrite)을 통해 사용자가 MV를 직접 참조하지 않아도 자동으로 가속화된 경로를 찾아준다.21
4. **폭넓은 생태계 호환성:** MySQL 프로토콜 지원으로 Tableau, PowerBI, Superset, Metabase 등 기존 BI 도구와 즉시 연동되며, Trino 방언(Dialect) 호환 모드를 지원하여 기존 Trino 쿼리를 수정 없이 마이그레이션할 수 있다.6
5. **유연한 스케일링:** 컴퓨팅과 스토리지가 분리된 아키텍처를 통해 워크로드 변화에 따라 컴퓨팅 노드를 수초 내에 확장하거나 축소할 수 있어 클라우드 비용을 최적화할 수 있다.

### 5.2 단점 및 고려사항 (Cons & Limitations)

1. **쓰기(Write) 기능의 성숙도:** 앞서 언급했듯이, 데이터 레이크로의 대량 쓰기 기능은 Spark나 Flink에 비해 기능이 제한적이다. 복잡한 트랜잭션 처리나 대규모 배치 처리를 StarRocks만으로 수행하기에는 아직 이르다.
2. **리소스 집약적 특성:** 성능을 최우선으로 설계되었기 때문에 메모리와 CPU를 적극적으로 사용한다. 따라서 적절한 용량 산정(Capacity Planning)이 선행되지 않으면 리소스 경합이 발생할 수 있다. (단, 4.0 버전의 리소스 격리 기능 강화로 많이 개선됨).36
3. **오픈소스 커뮤니티 규모:** 빠르게 성장하고 있지만, 아직 Spark나 Trino, ClickHouse에 비해 글로벌 커뮤니티의 규모나 서드파티 통합 도구의 수는 적은 편이다.
4. **객체 스토리지 비용:** 성능을 위해 메타데이터 조회나 데이터 스캔을 공격적으로 수행할 수 있어, S3 API 호출 비용(LIST, GET 등)이 증가할 수 있다. StarRocks 4.0에서는 파일 번들링과 메타데이터 캐싱 최적화를 통해 이를 90%까지 줄이는 노력을 기울이고 있다.37

## 6. StarRocks가 부합하는 비즈니스 니즈 및 활용 시나리오

StarRocks는 모든 상황을 위한 만능열쇠는 아니다. 하지만 다음과 같은 특정 니즈가 있는 환경에서는 대체 불가능한 가치를 제공한다.

### 6.1 핵심 니즈 (Needs Alignment)

- **"데이터 레이크의 속도가 너무 느려 비즈니스 기회를 놓치고 있다."**
    - S3에 페타바이트 단위의 데이터가 쌓여 있지만, Trino/Hive 쿼리가 수십 분씩 걸려 실시간 의사결정이 불가능한 경우. StarRocks 도입 시 수초 내로 응답 시간을 단축할 수 있다.
- **"사용자 대면(User-Facing) 대시보드 성능이 1초 미만이어야 한다."**
    - 수백 명의 내부 직원이나 수만 명의 외부 고객이 사용하는 분석 대시보드를 구축해야 하는 경우. 높은 동시성 처리 능력과 짧은 지연 시간이 필수적이다.38
- **"실시간 데이터와 과거 데이터를 조인해서 보고 싶다."**
    - Kafka로 들어오는 실시간 스트림 데이터와 데이터 레이크의 5년치 이력 데이터를 조인하여 '실시간 매출 현황 vs 전년 대비 성장률' 등을 즉시 보고 싶은 경우.
- **"데이터 인프라 비용(TCO)을 절감해야 한다."**
    - 고비용의 상용 데이터 웨어하우스(Snowflake, BigQuery) 비용을 줄이거나, 비효율적인 Trino 클러스터 규모를 줄이고 싶은 경우.39

### 6.2 추천 아키텍처 패턴

#### 6.2.1 데이터 레이크 가속화 (Lakehouse Acceleration)

데이터는 Iceberg/Hudi 포맷으로 S3에 저장하고, StarRocks는 순수한 쿼리 엔진으로 활용한다. 자주 조회되는 핫 데이터는 StarRocks의 로컬 블록 캐시에 자동으로 상주하게 되며, 성능이 더욱 중요한 집계 지표는 StarRocks 내부에 **Async Materialized View**로 생성하여 관리한다. 이 방식은 데이터 중복을 최소화하면서도 성능을 극대화한다.

#### 6.2.2 실시간 데이터 웨어하우스 (Real-time Enterprise Warehouse)

StarRocks를 메인 저장소로 활용하는 방식이다. Flink/Kafka를 통해 데이터를 StarRocks 내부 테이블(Primary Key Table)로 실시간 적재한다. StarRocks는 로컬 스토리지와 S3를 계층적으로 활용하여, 최근 데이터는 고성능 SSD에, 오래된 데이터는 S3로 내려보내는(Tiered Storage) 방식으로 비용과 성능의 균형을 맞춘다.

## 7. 심층 기술적 통찰 (In-depth Technical Insights)

단순한 기능 설명을 넘어, StarRocks가 가져오는 기술적 변화의 함의를 분석한다.

### 7.1 데이터 파이프라인의 종말과 'Pipeline-free' 분석

전통적인 데이터 엔지니어링은 `Source -> Staging -> Data Lake -> Warehouse -> Data Mart`로 이어지는 복잡한 파이프라인을 관리하는 것이 주 업무였다. 각 단계마다 데이터가 복제되고, 지연이 발생하며, 정합성 문제가 생긴다. StarRocks는 데이터 레이크를 직접 고속으로 조회하고, MV를 통해 가상 마트를 생성함으로써 중간 단계를 제거한다. 이는 데이터 엔지니어링의 병목을 해소하고 **'데이터 신선도(Data Freshness)'**를 획기적으로 개선한다.34

### 7.2 머터리얼라이즈드 뷰의 재발견

과거의 MV는 관리가 어렵고 리프레시 비용이 비싼 애물단지였다. 그러나 StarRocks의 MV는 파티션 레벨의 증분 갱신과 투명한 쿼리 재작성을 통해 **'자동화된 성능 최적화 도구'**로 진화했다. 데이터 엔지니어는 복잡한 ETL 잡(Job)을 작성하는 대신, 선언적인 SQL(CREATE MATERIALIZED VIEW) 하나만으로 데이터 가공 파이프라인을 구축할 수 있다.

### 7.3 Shared-Data 아키텍처의 완성

StarRocks 3.0 이후의 아키텍처는 **"S3의 무한한 확장성"**과 **"로컬 디스크의 고성능"**이라는 상충되는 두 가치를 성공적으로 결합했다. 컴퓨팅 노드는 상태를 가지지 않아(Stateless) 유연하게 확장되며, 데이터는 S3에 안전하게 저장되고, 성능은 로컬 캐시가 보장한다. 이는 클라우드 네이티브 시대에 가장 이상적인 데이터베이스 아키텍처의 전형을 보여준다.

## 8. 결론 및 제언

StarRocks는 단순한 오픈소스 쿼리 엔진을 넘어, 현대적인 데이터 레이크하우스 구축을 위한 핵심 플랫폼으로 자리 잡았다. 특히 **"Trino보다 빠르고, ClickHouse보다 유연하며, Druid보다 관리가 쉽다"**는 점은 수많은 기업들이 StarRocks로 마이그레이션하는 이유를 명확히 설명해준다.5

**도입을 위한 제언:**

1. **POC(Proof of Concept) 수행:** 현재 사용 중인 Trino나 Hive 쿼리 중 가장 느린 쿼리들을 선별하여 StarRocks에서 테스트해보라. 별도의 튜닝 없이도 수 배의 성능 향상을 경험할 가능성이 높다.
2. **데이터 레이크 포맷 전환 검토:** 아직 Parquet 파일만 사용 중이라면, Iceberg와 같은 테이블 포맷 도입을 함께 고려하라. StarRocks와 Iceberg의 조합은 성능과 관리 편의성 면에서 최적의 시너지를 낸다.
3. **캐싱 전략 수립:** BE 노드의 로컬 디스크(NVMe) 용량을 충분히 확보하여 블록 캐시의 적중률을 높이는 것이 성능의 핵심이다.

StarRocks는 데이터 레이크의 잠재력을 해방시키고, 기업이 데이터를 통해 더 빠르고 정확한 의사결정을 내릴 수 있도록 돕는 강력한 무기가 될 것이다.

---

### [부록] 주요 벤치마크 데이터 요약 표

| **시나리오**             | **비교 대상**    | **StarRocks 성능 배수** | **데이터셋**                    | **비고**                                    |
| -------------------- | ------------ | ------------------- | --------------------------- | ----------------------------------------- |
| **Wide-table Query** | ClickHouse   | **1.7x ~ 2.2x**     | SSB (Star Schema Benchmark) | 넓은 테이블 조회 및 집계 29                         |
| **Wide-table Query** | Apache Druid | **2.2x ~ 8.9x**     | SSB                         | 29                                        |
| **Multi-table Join** | Trino        | **5.54x**           | TPC-DS 1TB                  | 데이터 레이크(Iceberg) 상의 복잡한 조인 쿼리 29          |
| **Multi-table Join** | Trino        | **14.6x**           | TPC-DS                      | StarRocks Native Storage vs Trino Hive 41 |
| **Low-cardinality**  | ClickHouse   | **2.3x**            | -                           | 저카디널리티 컬럼 집계 성능 40                        |

이 표는 StarRocks가 단일 테이블뿐만 아니라 복잡한 조인 시나리오에서 경쟁 기술 대비 압도적인 성능 우위를 점하고 있음을 정량적으로 보여준다.
