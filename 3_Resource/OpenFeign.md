---
title: OpenFeign
date: 2024-04-25 14:04:00 +0900
aliases: 
tags:
  - spring
  - cloud
  - feign
categories: 
updated: 2024-04-25 14:04:02 +0900
---

## Spring Cloud Open Feign 이란?

Feign은 마이크로서비스 아키텍처에서 서비스간의 통신을 위한 클라이언트 라이브러리이다.

Feign 은 스프링 프레임워크와 통합되어 있고, Netflix OSS 의 일부임. 주요 기능은 다음과 같다.

- Netflix Eureka를 사용하여 서비스 디스커버리
- Ribbon 을 사용하여 로드밸런싱
- [[Resilience4j]] 를 사용하여 장애격리

즉, Feign을 사용하면 서비스 간의 호출에 대한 모든 부분을 쉽게 처리 할 수 있으며, 커넥션 풀링 및 로드 밸런싱 등과 같은 디테일한 설정을 Spring Cloud 에서 자동으로 처리해준다.

## Feign 선언형 인터페이스

Feign 을 사용하면 실제로는 RestTemplate 과 유사하지만, 인터페이스 형태로 원격 서버와의 HTTP 통신을 위한 API 를 정의한다는 점에서 다르다.

즉, Feign 을 선언적 방식으로 추상화를 제공함으로써 개발자들이 HTTP API를 호출하는 코드를 작성하는데 드는 비용을 줄여준다.

그리고 개발자들은 이 API 들에 대한 구현체는 신경쓸 필요가 없다. 대신 Feign 의 기본 설정 및 플러그인 등을 적용하면서 간단하게 API 호출을 처리할 수 있다.

## Feign 의 장점

- 별도의 구현체를 작성하지 않아도 된다.
- REST API 스펙을 선언하는 방식으로 코드를 작성한다.
- Spring Cloud Netflix Eureka 와 연동하여 로드밸런싱 및 서비스 디스커버리를 수행한다.
- [[Resilience4j]] 와 연동하여 장애격리를 수행한다.

## Feign 의 단점

- 구현체의 유연한 사용이 어렵다

Feign 은 인터페이스에 대한 구현체를 제공하기 때문에 개발자들이 이런 부분에 대해서는 정교한 설정을 하기 어렵다.

Feign 에서 제공하는 기능들이 충분하지 않은 경우 직접 구현체를 작성해야하는 경우가 많고, 이 때문에 서비스간 통신에서 발생하는 여러 이슈들로 인해 실제 개발단계에서는 다른 라이브러리나 커스터마이징된 코드로 대체해야 할 수도 있다는 단점이 있다.

즉, 재대로 된 로깅 및 오류 처리등의 기능을 추가하려면 Hystrix 외의 다른 라이브러리를 추가로 사용해야할 수도 있다.

## Feign 의 기본 설정

Feign 에서 기본적으로 제공하는 설정들은 다음과 같다.

- 서비스 디스커버리: Eureka 와 연동
- 로드밸런싱: Ribbon 과 연동
- 장애격리: Hystrix 와 연동
- 매핑: Spring MVC 의 어노테이션을 이용한 매핑 지원
- 인코딩 / 디코딩: Spring MVC 의 HttpMessageConverter 를 사용한 인코딩 및 디코딩 지원

## multipart/form-data

### Example 1

```java
@PostMapping(
        value = "/authenticate",
        produces = MediaType.APPLICATION_JSON_VALUE,
        consumes = MediaType.MULTIPART_FORM_DATA_VALUE
)
TokenResponse resolveAuthentication(
        @RequestPart("grant_type") String grantType,
        @RequestPart("client_id") String clientId,
        @RequestPart("client_secret") String clientSecret
);
```

- `produces`: header 에 `Accept: {value}` 가 추가된다.
- `cunsumes`: header 에 `Content-Type: multipart/form-data boundary=~` 가 추가된다.
