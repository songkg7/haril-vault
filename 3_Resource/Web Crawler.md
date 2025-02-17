---
title: Web Crawler 설계
date: 2023-05-08T19:31:00
aliases: 
tags:
  - crawler
  - system-architecture
categories: 
updated: 2025-01-07T00:35
---

## 웹 크롤러

### 1단계. 문제 이해 및 설계 범위 확정

웹 크롤러의 기본 알고리즘

1. URL 집합이 입력으로 주어지면, 해당 URL들이 가리키는 모든 웹 페이지를 다운로드한다.
2. 다운받은 웹 페이지에서 URL들을 추출한다.
3. 추출된 URL들을 다운로드할 URL 목록에 추가하고 위의 과정을 처음부터 반복한다.

### 2단계. 개략적 설계안 제시 및 동의 구하기

#### 시작 URL 집합

시작 URL 집합은 웹 크롤러가 크롤링을 시작하는 출발점. 각 나라별, 지역별로 적절한 지점이 다를 수 있으므로 의도가 무엇인지만 정확히 전달하자.

#### 미수집 URL 저장소

다운로드할 URL 을 저장 관리하는 컴포넌트. FIFO 큐 라고 생각하자.

#### HTML 다운로더

인터넷에서 웹 페이지를 다운로드하는 컴포넌트.

#### 도메인 이름 변환기

#### 콘텐츠 파서

웹 컨텐츠가 문제를 일으킬 수 있는 페이지인지 검증하는 컴포넌트.

#### 중복 콘텐츠인가?

웹 페이지의 해시 값을 비교하여 중복된 페이지인지 판별 후 크롤링 과정을 최적화한다.

#### 콘텐츠 저장소

HTML 문서를 보관하는 시스템.

#### URL 추출기

링크들을 골라내는 역할.

#### URL 필터

접근할 경우 오류가 발생하는 URL 등, 미리 걸러낼 URL 들을 배제하는 역할을 하는 컴포넌트.

#### 이미 방문한 URL?

[[bloom filter|bloom filter]] 나 해시 테이블을 하용하여 이미 방문한 적이 있는 URL 인지 추적하여 같은 URL 을 여러 번 처리하는 일을 방지한다.

#### URL 저장소

이미 방문한 URL 을 보관하는 저장소.

### 3단계. 상세 설계

#### DFS를 쓸 것인가, BFS를 쓸 것인가

웹은 유향 그래프와 같다. 페이지는 노드이고, 하이퍼 링크는 에지라고 보면 된다. 크롤링 프로세스는 이 유향 그래프를 에지를 따라 탐색하는 과정이다.

DFS, BFS 는 그래프 탐색에 널리 활용되는 알고리즘이지만, DFS 는 적절하지 않을 가능성이 높다. 웹 페이지가 클 경우 깊이를 가늠하기 어려워서다. 따라서 웹 크롤러는 보통 BFS, 넓이 우선 탐색법을 사용한다.

문제는 다음과 같다.

- 웹 페이지에서 나오는 링크의 상당수는 같은 서버로 되돌아 간다.
- URL 간에 우선순위를 두지 않는다.

#### 미수집 URL 저장소

이전 문제를 해결하기 위해 미수집 URL 저장소를 사용할 수 있다.

##### 예의

짧은 시간 안에 너무 많은 요청을 보내는 것을 삼가야 한다.

##### 우선순위

순위결정장치를 통해 페이지에 우선순위를 부여한다.

##### 신선도

웹 페이지는 수시로 변경되기 때문에 주기적으로 재수집할 필요가 있다.

- 웹 페이지으 변경 이력 활용
- 우선순위를 활용하여, 중요한 페이지는 좀 더 자주 재수집

#### HTML 다운로더

##### 성능 최적화

##### 안정성

##### 확장성

##### 문제 있는 콘텐츠 감지 및 회피

1. 중복 콘텐츠
2. 거미 덫
3. 데이터 노이즈

### 4단계. 마무리

- 서버 측 렌더링
- 페이지 필터링
- 데이터베이스 다중화 및 샤딩
- 수평적 규모 확장성
- 가용성, 일관성, 안정성
- 데이터 분석 솔루션
