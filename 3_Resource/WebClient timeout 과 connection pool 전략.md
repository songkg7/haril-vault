---
title: WebClient timeout 과 connection pool 전략
date: 2022-08-29 10:43:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-29
aliases: null
tags:
  - webclient
  - http
categories: null
updated: 2023-08-19 12:37:52 +0900
---

## WebClient timeout

```java
new ReactorClientHttpConnector( reactorResourceFactory, httpClient -> httpClient .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 5000) .doOnConnected(connection -> connection.addHandlerLast(new ReadTimeoutHandler(5) ).addHandlerLast(new WriteTimeoutHandler(5)) ).responseTimeout(Duration.ofSeconds(5)) // 0.9.11 부터 추가 );
```

`ChannelOption.CONNET_TIMEOUT_MILLIS` 는 서버와 커넥션 맺는데 기다리는 시간이다. 이건 http client level 이다.

responseTimeout 은 순수 http 요청/응답 시간에 대한 timeout 이다.

...

## Reference

[참고](https://yangbongsoo.tistory.com/30)

## Links

- [[WebClient]]