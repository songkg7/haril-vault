---
title: Feature Toggle
date: 2024-04-02 17:54:00 +0900
aliases: 
tags:
  - feature-toggle
  - feature-flag
categories: 
updated: 2024-04-02 17:54:04 +0900
---

## Feature Toggle 이란?

Feature Toggle 은 애플리케이션의 기능을 On/Off 할 수 있는 방식이다. 사용자는 불필요한 기능이나 실험적인 새로운 기능을 사용하지 않게 할 수 있다. 이 외에도 A/B test 나 Canary Release 같은 용도로 이용할 수 있다.

## 사용 예시

예를 들어, "모바일 버전에서는 아직 제공되지 않는 기능인데 어떤 사용자들은 이미 이용하고 있어서 문제가 생기고 있다" 라는 상황이 있을 때, 모바일 버전에서 그 기능을 끄도록 하여 문제를 해결할 수 있다.

또는, 다음과 같은 상황이 있을 때, "새로운 프로덕트를 출시하는데, 이번에 만든 새로운 기능이 너무 고객들에게 좋아서 계속 발전시켜야 하는데 하루라도 더 빠르게 출시하고 싶다"라면 새로운 프로덕트의 기능 중에 실험적인 것들을 Feature Toggle 로 만들어서 전체적으로 출시하지 않고 일부러 그것만 빠르게 출시할 수 있다.

## 요구사항

- 모든 조직의 모든 소프트웨어에 적용 가능
- 단위 테스트와 같이 자동화된 테스트가 필수
- 토글링 기능을 활성화/비활성화 할 수 있는(On/Off) 코드가 필요
- 구현하기 쉬워야 한다

## 구현 방법

1. if/else 문을 이용한 분기 처리 - 가장 기본적인 방법이지만, 코드의 중복과 복잡도가 증가하여 관리하기 어려움

```java
if (featureToggle) {
    // 기능 활성화 시 실행할 코드
} else {
    // 기능 비활성화 시 실행할 코드
}
```

2. 상속 활용 - 기본 라이브러리를 상속받아서 원하는 대로 오버라이딩하는 방식으로 구현한다.
3. 인터페이스 활용 - FeatureToggle 인터페이스를 만들고 이를 구현한 클래스에서 True 또는 False를 반환하도록 한다.
4. 설정파일 이용 - 설정 파일에 설정값을 넣어놓고 읽어서 사용하는 방식. 단, 설정파일의 내용을 변경하려면 재시작해야 하므로 유의해야 한다.
5. 서비스 이용 - 서비스에서 Feature Toggle 지원 API 를 제공하며, 데이터베이스나 메모리에 상태를 저장한다.
6. 애노테이션 이용 - 애노테이션을 이용해 기능을 활성화 시킬 수 있다.
7. AOP 이용 - 메서드 호출 전/후에 기능을 활성화할 수 있도록 하여 구현한다.

## 참고 자료

- https://martinfowler.com/articles/feature-toggles.html
- https://wiki.c2.com/?FeatureToggle
- http://www.thoughtworks.com/insights/blog/practical-guide-feature-toggles
- https://sungjk.github.io/2023/03/04/feature-toggle.html
