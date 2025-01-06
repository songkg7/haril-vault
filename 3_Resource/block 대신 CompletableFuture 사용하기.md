---
title: block 대신 CompletableFuture 사용하기
date: 2022-12-06T10:10:00
aliases: 
tags:
  - webflux
  - block
  - asnyc
categories: 
updated: 2025-01-07T00:35
---

## Overview

[[Spring WebFlux]] 에서 동기처리를 위해 `block()` 을 사용하려하면 [[Spring MVC]] 의존성이 필요하다. 하지만 Spring MVC 의존성을 추가하게 되면 Netty 가 아닌 Tomcat 이 실행된다.

때문에 해당 의존성을 추가하지 않고 [[Netty]] 에서 동기 코드를 작성하기 위해서는 `toFuture()` 를 사용하여 처리하면 된다.

## Example

아래는 [[WebClient]] 를 사용하여 token 을 받아오는 예시이다. 특정 요청을 위해 token 이 필요하다고할 때 token 을 발급받기 전 비동기로 요청이 실행되면 `401` error 가 발생할 수 있기 때문에 동기 처리 혹은 token 발급을 기다리는 코드 작성이 필수적이다.

```java
public String execute() {
	CompletableFuture<String> future = webClient.post()
			.body(BodyInserters.fromFormData("grant_type", "client_credentials")
					.with("client_id", clientId)
					.with("client_secret", clientSecret)
					.with("scope", scope))
			.retrieve()
			.bodyToMono(OauthToken.class)
			.map(OauthToken::getAccessToken)
			.toFuture();

	try {
		return future.get(10, TimeUnit.SECONDS);
	} catch (Exception e) {
		throw new RuntimeException("Error while retrieving oauth token", e);
	}
} 
```

`future.get()` 에 파라미터로 시간을 전달하여 10초 안에 token 을 발급해오지 못할 경우 예외를 던지도록 했다.

테스트는 아래와 같이 쓸 수 있다.

```java
@Test
void execute_after_10s() {
	mockWebServer.enqueue(new MockResponse()
			.setResponseCode(200)
			.setHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
			.setBody("{\"access_token\":\"token\",\"token_type\":\"bearer\",\"expires_in\":3600}")
			.setBodyDelay(11, TimeUnit.SECONDS));

	assertThatThrownBy(oauthTokenCommand::execute)
			.isInstanceOf(RuntimeException.class)
			.hasMessage("Error while retrieving oauth token");
} 
```

body 의 delay 를 11초로 설정하여 `future.get()` 에 설정한 시간인 10초를 초과하게 한다.

`join()` 을 사용하면 exception 을 던지지 않는다. timeout 관련 처리는 어떻게 되는지 확인 필요

