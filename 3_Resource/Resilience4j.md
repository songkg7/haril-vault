---
title: Resilience4j
date: 2024-04-02 16:19:00 +0900
aliases: 
tags:
  - rate-limit
  - circuit-breaker
categories: 
updated: 2024-04-02 16:19:10 +0900
---

## Resilience4j 란

* Resilience4j는 자바8+용 경량 라이브러리이다.
* 단순한 프로그래밍 모델을 사용하여 함수형, 반응형 및 복원력 기반의 분산 시스템을 구축할 수 있게 해준다.
* Resilience4j는 기능적으로 다양한 모듈로 구성되어 있어서, 애플리케이션에 필요한 유연성과 신뢰성을 제공하려는 목적으로 사용한다.

## Resilience4j 간단한 예제

### 내장 샘플

Resilience4j는 내장 샘플로 여러 가지 예제를 제공한다.

```java
public class HelloWorldExample {

    public static void main(String[] args) {
        // Create a Retry with at most 3 retries and a fixed time interval between retries of 500ms
        RetryConfig config = RetryConfig.custom()
                .maxAttempts(3)
                .waitDuration(Duration.ofMillis(500))
                .build();

        // Create a RetryRegistry with a custom global configuration
        RetryRegistry registry = RetryRegistry.of(config);

        // Get or create a Retry from the registry - 
        // retryWithFixedWait is thread-safe and can be used concurrently
        Retry retryWithFixedWait = registry.retry("name1");

        Supplier<String> supplier = () -> "test";
        
         // Decorate your call to BackendService.doSomething()
        Supplier<String> retryableSupplier = Retry.decorateSupplier(retryWithFixedWait, supplier);

        // Execute the decorated supplier and recover from any exception
        String result = Try.ofSupplier(retryableSupplier)
                           .recover((exception) -> "Hello from Recovery").get();

        System.out.println(result);
    }
}
```

### 샘플 실행

Gradle을 사용하여 샘플을 실행한다.

```
./gradlew :resilience4j-samples:hello-world:run
```

위 명령어를 실행하면, 다음과 같은 결과를 얻는다.

## Resilience4j 주요 기능

* [[Circuit Breaker]]
* [[Rate Limiter]]
* [[Bulkhead]]
* [[Retry]]
* [[TimeLimiter]]
* [[Cache]]

Resilience4j의 모든 기능은 [Spring AOP](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop) 와 [Vavr](https://www.vavr.io/) 에서 제공하는 라이브러리를 기반으로 구현되어 있기 때문에, [[Spring Boot]] 에서도 사용이 가능하다.

## Resilience4j 설치 방법

Gradle을 사용하여 Resilience4j를 이용한 애플리케이션을 구축하기 위해 build.gradle 파일에 다음 내용을 추가하면 된다.

```java
dependencies {
    implementation 'io.github.resilience4j:resilience4j-spring-boot3:${resilience4jVersion}'
}
```

## Resilience4j 샘플 소스

### resilience4j-aspect

이 모듈에는 다음과 같은 내용이 포함되어 있다.

* Circuit Breaker
* RateLimiter
* Retry
* Bulkhead

위 기능들은 [Spring Boot AOP](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop)를 사용하여 구현되었다.

[[Spring AOP|Spring AOP]]

### resilience4j-cache

모듈은 다음과 같은 내용을 포함하고 있다.

* Cache
* TimeLimiter

TimeLimiter는 [Spring Boot AOP](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop)를 사용하여 구현되었다.

### resilience4j-timelimiter

모듈은 다음과 같은 내용을 포함하고 있다.

* TimeLimiter
* CircuitBreaker with TimeLimiter and CompletableFuture
* Bulkhead with TimeLimiter and CompletableFuture

### resilience4j-reactor

모듈에는 다음과 같은 내용이 포함되어 있다.

* CircuitBreaker with Reactor
  * Mono (synchronous)
  * Flux (asynchronous)
  * Mono (asynchronous)
* Retry with Reactor
  * Mono (synchronous)
  * Flux (asynchronous)
  * Mono (asynchronous)

### resilience4j-retry

모듈은 다음과 같은 내용을 포함하고 있다.

* Retry
  * Sync
  * Async

### resilience4j-demo

이 모듈은 다음과 같은 내용을 포함하고 있다.

* CircuitBreakerSyncDemo
* CircuitBreakerAsyncDemo
* RateLimiterSyncDemo
* RateLimiterAsyncDemo
* RetryDemo

## 참고 자료

* [Resilience4j Github](https://github.com/resilience4j/resilience4j/)
* [Resilience4j Github Wiki](https://github.com/resilience4j/resilience4j/wiki/)
