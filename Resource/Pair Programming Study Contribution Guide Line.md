---
title: Pair Programming Study 가이드라인
date: 2023-09-06 20:45:00 +0900
aliases: []
tags:
  - livid
  - study
  - kotlin
  - codecov
  - ktlint
categories: 
updated: 2023-09-06 22:04:35 +0900
---

## Contribution Guide Line

> [!warning] 모든건 절대적이지 않습니다.
> 본 문서는 언제든 변경될 수 있습니다. Issue 를 생성해주시거나, Discord 를 통해 의견을 전달해주세요.

본 문서는 원활한 스터디를 진행하기 위해 도움이 되는 가이드라인을 구성원들에게 제공하는 것을 목표로 작성되었습니다.

### Kotest

이 스터디의 핵심 학습 목표이기도 한 [Kotest](https://kotest.io/) 는 다양한 [Testing Style](https://kotest.io/docs/framework/testing-styles.html) 을 지원합니다.

취향에 맞는 방식의 Spec 을 사용하시면서 어떤 Spec 이 어떤 상황에 어울리는지 고민해보시는 것도 좋습니다. 다만 **Annotation Spec 의 경우는 Java 의 JUnit5 와 거의 차이가 없기 때문에 Kotlin Style 을 학습하는 이 스터디의 목표와는 맞지 않다**고 생각되기 때문에 제외합니다.

### PR

#### Size Labeling

PR 을 생성하면 코드의 변경 내용을 기반으로 size 라벨링이 진행됩니다.

![[Pasted image 20230906205001.png]]

리뷰어는 라벨만 봐도 리뷰해야할 코드 양을 대략적으로 파악할 수 있습니다.

#### Codecov

PR 을 생성하면 작성된 코드를 테스트한 뒤 커버리지 리포트를 생성합니다.

![[Pasted image 20230906205436.png]]

만약 이전보다 커버리지가 감소한다면 pipeline 이 실패(...!)합니다. 클래스 별 70% 이상의 커버리지여야 빌드가 가능하니 테스트에 신경써주세요.

#### Ktlint

Kotest 와 함께 본 스터디의 핵심 학습 목표입니다.

코드 스타일은 [Kotlin Standard Rule](https://pinterest.github.io/ktlint/1.0.0/rules/standard/) 을 따르고 있습니다.

![[Pasted image 20230906210528.png]]

스타일이 ktlint 표준과 다르다면 PR 상태 체크가 실패하니 기여자는 코드 스타일을 준수해주세요.

#### 정족수 Approve

PR 을 merge 하기 위해서는 최소 2명의 승인이 필요합니다. 기본적으로는 **전체인원 / 2** 로 설정합니다.

## Links

- [[Kotlin|Kotlin]]
- [[Kotest]]

## Reference

- [GitHub](https://github.com/Learning-Is-Vital-In-Development/23-17-pair-programming-game)
- [O2](https://github.com/songkg7/o2/pull/210)
