---
title: REST API
date: 2022-08-19 17:46:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-19
aliases: 
tags:
  - http
  - api
  - restful
categories: 
updated: 2023-10-19 11:32:34 +0900
---

## REST 란?

> REpresentational State Transfer: 자원의 상태 전달

REST 의 기본 원칙을 성실히 지킨 서비스 디자인은 'RESTful' 하다고 표현할 수 있다.

REST 는 Resource Oriented Architecture 이다. API 설계의 중심에 자원(Resource)이 있고 HTTP method 를 통해 자원을 처리하도록 설계하는 것이다.

## REST 6원칙

### 1. Client, Server

클라이언트와 서버가 서로 독립적으로 분리되어 있어야 한다.

### 2. Stateless

요청에 대해서 클라이언트의 상태를 서버에 저장하지 않는다.

### 3. Cache

클라이언트는 서버의 응답을 Cache(임시 저장)할 수 있어야 한다.

### 4. 계층화 (Layered System)

서버와 클라이언트 사이에, 방화벽, 게이트웨이, proxy 등 다양한 계층 형태로 구성이 가능해야하며, 이를 확장할 수 있어야 한다.

### 5. 인터페이스 일관성

인터페이스의 일관성을 지키고, 아키텍처를 단순화시켜 작은 단위로 분리하여 클라이언트, 서버가 독립적으로 개선될 수 있어야 한다.

### 6. Code on Demand (Optional)

자바, 자바스크립트, 플래시 등 특정한 기능을 서버로부터 클라이언트가 전달받아 코드를 실행할 수 있어야 한다.

## RESTful API 디자인

### 1. 리소스와 행위를 명시적이고 직관적으로 분리

- 리소스는 URI 로 표현되며 리소스가 가리키는 것은 명사로 표현되어야 한다.
- 행위는 HTTP method 로 표현하고 GET, POST, PUT, PATCH, DELETE 를 분명한 목적으로 사용한다.

### 2. Message 는 Header 와 Body 를 명확하게 분리해서 사용

- Entity 에 대한 내용은 body 에 담는다.
- 애플리케이션 서버가 행동할 판단의 근거가 되는 컨트롤 정보인 API 버전 정보, 응답받고자 하는 MIME 타입 등은 header 에 담는다.
- header 와 body 는 http header 와 http body 로 나눌 수도 있고 http body 에 들어가는 json 구조로 분리할 수도 있다.

### 3. API 버전을 관리

- 환경은 항상 변하기 때문에 API의 signature가 변경될 수 있음에 유의하자.
- 특정 API를 변경할 때는 반드시 하위호환성을 보장해야 한다.

### 4. 서버와 클라이언트가 같은 방식을 사용해서 요청

- 브라우저는 form-data 형식의 submit 으로 보내고 서버에서는 json 형태로 보내는 식의 분리보다는 json 으로 보내든, 둘 다 form-data 형식으로 보내든 하나로 통일한다.
- 다른 말로 표현하자면 URI 가 플랫폼 중립적이어야 한다.

## REST API 의 장점

- Open API 를 제공하기 쉽다.
- 멀티플랫폼 지원 및 연동이 용이하다.
- 원하는 타입으로 데이터를 주고 받을 수 있다.
- 기존 웹 인프라(HTTP)를 그대로 사용할 수 있다.

## REST API 의 단점

- 사용할 수 있는 메서드가 제한된다.
- 분산환경에 부적합?하다.
- HTTP 통신 모델에 대해서만 지원한다.

## Links

- [[HTTPS]]
- [[GraphQL]]
- [[Network]]
