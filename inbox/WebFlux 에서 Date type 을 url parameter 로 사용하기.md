---
title: "WebFlux 에서 Date type 을 url parameter 로 사용하기"
date: 2022-11-22 11:28:00 +0900
aliases: 
tags: [webflux, localdatetime, url]
categories: 
---

`LocalDateTime` 같은 시간 형식을 url parameter 로 사용할 경우 기본 포맷에 맞지 않는다면 다음과 같은 에러 메세지를 보게 된다.

```console
Exception: Failed to convert value of type 'java.lang.String' to required type 'java.time.LocalDateTime';
```

특정 포맷도 convert 할 수 있도록 하기 위해서 어떻게 할 수 있는지 알아본다.

## Contents

### Example

간단한 샘플 예제를 하나 만들어보자.

```java
public record Event(
        String name,
        LocalDateTime time
) {
} 
```

event 의 이름과 발생 시간을 담고 있는 간단한 객체이다.

```java
@RestController
public class EventController {

    @GetMapping("/event")
    public Mono<Event> helloEvent(Event event) {
        return Mono.just(event);
    }

}
```

```bash
$ http localhost:8080/event Accept=application/stream+json name==test time==2022-01-01T00:00
HTTP/1.1 200 OK
Content-Length: 44
Content-Type: application/stream+json

{
    "name": "test",
    "time": "2022-01-01T00:00:00"
} 
```

기본 포맷으로 요청하면 정상적으로 응답을 받지만,

```bash
$ http localhost:8080/event Accept=application/stream+json name==test time==2022-01-01T00:00:00Z
HTTP/1.1 500 Internal Server Error
Content-Length: 131
Content-Type: application/stream+json

{
    "error": "Internal Server Error",
    "path": "/event",
    "requestId": "ecc1792e-3",
    "status": 500,
    "timestamp": "2022-11-28T10:04:52.784+00:00"
} 
```

특정 포맷으로 응답을 받고 싶은 경우는 별도의 설정이 필요하다.

### 1. `@DateTimeFormat`

가장 간단한 해결법은 annotation 을 추가하는 것이다. 어떤 포맷으로 변환할 것인지 정의해주면 원하는 포맷으로 요청할 수 있다.

```java
public record Event(
        String name,

        @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'")
        LocalDateTime time
) {
}
 ```

```bash
$ http localhost:8080/event Accept:application/stream+json name==test time==2022-01-01T00:00:00Z
HTTP/1.1 200 OK
Content-Length: 44
Content-Type: application/stream+json

{
    "name": "test",
    "time": "2022-01-01T00:00:00"
}
 ```

하지만 파라미터로 받을 수 있게 되었을 뿐, json response 의 모양까지 바꾸진 않는다.

변환해야하는 필드가 많다면 하나하나 annotation 을 붙이는 건 꽤나 귀찮은 작업이 되고, 실수로 annotation 을 작성하지 않아서 버그가 발생할 수도 있다.

### 2. `WebFluxConfigurer`
