---
title: Docker Study Chapter 18
date: 2023-12-02 18:52:00 +0900
aliases: 
tags:
  - docker
  - study
  - livid
categories: 
updated: 2023-12-02 20:29:39 +0900
---

# 컨테이너의 애플리케이션 설정 관리

실습이 핵심 컨텐츠

## 다단 애플리케이션 설정

The Twelve Factor App([[12 Factors]])

애플리케이션 설정을 별도의 환경변수로 분리한 뒤, 컨테이너에 오버라이드 하는 방식으로 적용

## 환경별 설정 패키징하기

이미지에 설정 파일을 포함한 뒤, 실행 시점에 어떤 설정을 적용할지 선택하게 하는 방식이다.

```bash
docker run -e profile=dev -d -p 8080:8080 sample-server
```

이미지를 통해 민감한 정보가 평문으로 유출되지 않도록 신경써야 한다.

## 런타임에서 설정 읽어 들이기

코드에서 설정 파일을 어디에서 읽을 것인지를 지정하는 방식이다.

디버깅을 위해서는 설정 API 등을 사용할 수 있다. 설정 API 는 Spring 진영이라면 [[Spring Actuator]] 를 사용할 수 있다. 다만 설정값은 민감한 정보가 포함되어 있을 수 있으므로, 다음 수칙을 지켜야 한다.

- 전체 설정을 공개하지 않는다.
- 허가받은 사용자만 접근할 수 있도록 엔드포인트에 보안을 설정한다.
- 설정 API 의 사용 여부를 설정할 수 있도록 한다.

## 레거시 애플리케이션에 설정 전략 적용하기

애플리케이션 플랫폼의 동작 방식에 따라 적용 방법이 달라질 수 있다. 문서화를 통해서 이러한 혼선을 줄이기 위해 노력해야 한다.

## 유연한 설정 모델의 이점

- 버전에 따라 달라지는 설정은 이미지에 포함
- 환경별로 달라지는 설저은 컨테이너 플랫폼에서 제공하는 오버라이드 파일을 통해 적용