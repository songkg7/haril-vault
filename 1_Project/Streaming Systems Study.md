---
title: Streaming Systems Study
date: 2024-07-02 11:30:00 +0900
aliases: 
tags:
  - book
  - study
  - stream
  - streaming
  - batch
categories: 
description: 
updated: 2024-07-02 18:08:24 +0900
---

## 1부. 빔모델

## 스트리밍 101

스트리밍 데이터 처리가 주목받는 이유

- 스트리밍으로 전환하면 시기적절한 통찰력을 빠르게 얻을 수 있다
- 무한 데이터셋이 점점 더 보편화
- 데이터가 도착하는 시점에 처리될 수 있으면 작업 부하가 고르게 분산되어 시스템 자원을 예측 가능한 형태로 소비하는데 도움이 된다

### 스트리밍이란

> [!NOTE]
> 저자는 잘 설계된 **스트리밍 시스템이 기존의 모든 배치 시스템과 마찬가지로 정확하고 일관적이며 반복 가능한 결과를 생성할 수 있고 기술적으로 더 낫다**고 주장하고 있다.

> 무한 데이터셋을 염두에 두고 설계된 데이터 처리 엔진의 유형

용어를 정확하게 사용하자.

데이터셋의 모양을 정의하는 두 가지 중요한 차원

- 기수(cardinality): 데이터셋의 크기, 기수의 가장 두드러진 측면은 지정된 데이터 집합이 유한인지 무한인지를 결정
- 구성 (constitution)

이 두 속성은 직교적(othogonal)이다.

데이터셋의 기수를 설명할 때 사용하는 두 용어

- 유한 데이터
- 무한 데이터

기수가 중요한 이유는 무한 데이터셋의 무한함이라는 특성으로 인해 데이터를 처리하는 데이터 처리 프레임워크가 갖게 되는 부담이 발생하기 때문.

### 심하게 과장된 스트리밍의 한계

#### 람다 아키텍처

> 동일한 계산을 수행하는 배치 시스템과 스트리밍 시스템을 함께 운영하는 것

스트리밍 시스템은 낮은 지연시간으로 부정확한 결과를 제공하며, 얼마 후 배치 시스템을 통해 최종적으로 정확한 결과를 보여준다.

그러나 독립된 두 버전의 파이프라인을 구축하고 유지해야 하며 최종엔 두 파이프라인에서 나온 결과를 병합해야 했기 때문에 람다 시스템을 유지하는 것은 번거로울 수밖에 없다.

#### 새로운 주장

> 배치 시스템은 기능상 잘 설계된 스트리밍 시스템의 엄격한 부분집합에 불과하다고 생각한다.

효율성 면에서 발생하는 차이를 제외하면 오늘날 배치 시스템은 더 이상 쓸 이유가 없다.

> [!NOTE] 배치 시스템은 더 이상 쓸 필요가 없는가
> 다소 공격적인 표현이지만 어느 정도 공감할 수 있었다. 배치를 만들다보면 이거 스트림 처리로도 가능하지 않나 싶은 포인트들을 느낀 적이 종종 있다.

- 무한 데이터 처리를 위해 강력한 프레임워크와 결합된 스트리밍 시스템이 광범위하게 성숙해 감에 따라, 람다 아키텍처는 빅데이터 역사에서 유물로 전락해갈 것

다음은 스트리밍 시스템이 배치 시스템을 이기기 위해 필요한 두 가지

##### 정확성 (correctness)

- 배치와 동등해지기 위해 필요한 조건
- 핵심은 일관성을 제공할 수 있는 스토리지
- 스파크 스트리밍이 일관성 지원이 가능함을 보여줌
- 강한 일관성은 '정확히 한 번 처리 방식'을 지원하기 위해서 반드시 필요
- ? 정확성 = 일관성

##### 시간 판단 도구 (tools for reasoning about time)

- 스트리밍이 배치의 능력을 뛰어넘을 수 있게 해주는 부분
- ? 무한 비순서 데이터를 처리할 때 반드시 필요

### 이벤트 시간 대 처리 시간

- 이벤트 시간: 이벤트가 실제 발생한 시간
- 처리 시간: 이벤트가 처리 시스템에서 관측된 시간

이벤트 시간과 처리 시간이 같은 것이 이상적이지만, 다음과 같은 이유로 사실상 매우 어렵다.

- 공유된 리소스로 인한 제약
- 분산 시스템의 로직, 경쟁 상황 같은 소프트웨어 상의 원인
- 데이터 자체의 특성들 - 키 분산, 전달되는 데이터 양이나 순서의 변화

### 데이터 처리 패턴

#### 유한 데이터

#### 무한 데이터: 배치

##### 고정 윈도우

#### 무한 데이터: 스트리밍

---

- 왜 다 101 이라는 용어를 쓸까: 저자의 다른 책인듯?
