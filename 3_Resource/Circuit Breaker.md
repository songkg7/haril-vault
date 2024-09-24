---
title: Circuit Breaker
date: 2024-04-02 16:18:00 +0900
aliases: 
tags: 
categories: 
updated: 2024-04-16 15:42:43 +0900
---

## Circuit breaker 란?

- Circuit breaker는 일반적인 전기 회로에 사용되는 장치로, 과도한 전류가 흐를 때 회로를 차단하여 장치를 보호하는 역할을 한다.
- 이와 유사하게 소프트웨어에서의 Circuit breaker는 서버간의 연결에서 과도한 요청으로 인해 서버가 다운될 수 있는 상황을 방지하기 위해 사용된다.
- Circuit breaker는 기본적으로 open, half-open, close 3가지 상태로 나뉜다.

### Open

- Circuit breaker의 기본 상태이며, 요청이 너무 많이 들어오면, circuit breaker는 서버에 대한 요청을 모두 차단한다.
- 일정 시간 동안 해당 서버에 대해서는 요청을 받지 않고 에러 메시지만 응답한다.

### Half-open

- open 상태일 때 일정 시간이 지나면 circuit breaker는 다시 half-open 상태로 전환된다.
- 이 상태에서 circuit breaker는 일부 요청만 서버로 보내서 연결 가능한지 확인한다.
- 만약 정상적인 응답을 받으면 open -> close 로 전환되고 다시 서버에 대해 정상적으로 요청을 할 수 있게 된다.
- 만약 여전히 에러 응답을 받으면 다시 open 상태로 전환된다.

### Close

- 기본 상태와 같으며, 서버에는 정상적인 요청을 할 수 있게 된다.

## 스프링에서의 Resilience4j

### 서킷브레이커로 얻을 수 있는 효과

#### 에러를 보여주지 않을 수 있다

- timeout 시간을 짧게 주고 만약 readTimeOut 이 발생한다면 fallback 값을 리턴하도록 해서 클라이언트에는 timeout 이 발생했다는 사실을 숨길 수 있다.

## With WebFlux

```groovy
implementation 'io.github.resilience4j:resilience4j-reactor:{version}'
```

[[Spring WebFlux]] 의 경우 [[Reactor]] 를 사용하기 때문에 관련 의존성을 추가해주면 reactor 와 함께 적용할 수 있다.

![](https://i.imgur.com/ixUfGQJ.png)

```java

private final CircuitBreakerRegistry circuitBreakerRegistry; // autowired

// ...

public Flux<String> getRequest(SomeRequest request) {
    return get(request)
        .bodyToFlux(String.class)
            .transform(CircuitBreakerOperator.of(circuitBreakerRegistry.circuitBreaker("apple")))
            .onErrorResume(this::fallback);
}

private <T> Mono<T> fallback(Throwable throwable) {
    log.error(throwable.getMessage());
    return Mono.empty();
}
```

`CircuitBreakerOperator` 를 통해 reactor 의 chaining 으로 자연스럽게 사용할 수 있다.

## Reference

- https://tech.kakaopay.com/post/katfun-joy-multiple-biz-partner-02/
