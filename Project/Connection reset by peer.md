---
title: Connection reset by peer
date: 2023-12-15 10:35:00 +0900
aliases: 
tags:
  - debug
  - webclient
categories: 
updated: 2023-12-20 16:54:27 +0900
---

# Connection reset by peer 문제 해결하기

## 현상

- private network 안에 존재하는 ECS fargate 에서 외부 API 를 호출해야 한다.
- 컨테이너 실행 직후는 잘 되지만, 일정 시간이 경과한 이후는 Connection reset by peer 에러가 발생한다.

![](https://i.imgur.com/d0FzOEn.png)

- public network 를 사용하는 GCP [[Kubernetes]] 에서는 관련 문제가 발생하지 않았음

## 예상 원인

AWS NAT gateway 에서 차단되는게 아닐까?

- NAT gateway 의 idle timeout 은 350s
    - NAT gateway 는 타임아웃이 될 때 **FIN 이 아니라 RST 패킷**을 보내고, 이는 클라이언트의 커넥션을 정상적으로 종료시키지 못하는 원인이 된다.
- ELB 의 timeout 은 60s

클라이언트의 타임아웃을 NAT gateway 보다 짧게 설정해주어 커넥션이 정상적으로 종료되도록 유도하면 해결될 것이다.

## 시도해본 방법

### Keep Alive 활성화

기본적으로 활성화되어 있음

### Idle Timeout 설정

httpClient 의 maxIdleTime 을 50s 로 설정했으나 해결되지 않음

## 해결

사용하고 있던 WebClient 에 타임아웃 관련 옵션들이 적용되고 있지 않았던 것을 발견하고, 해당 부분을 해결해주니 이후로는 관련 에러가 발생하지 않음.

```java
ConnectionProvider connectionProvider = ConnectionProvider.builder("myConnectionPool")
        .maxIdleTime(Duration.ofSeconds(30))
        .maxLifeTime(Duration.ofSeconds(50))
        .pendingAcquireTimeout(Duration.ofSeconds(30))
        .lifo()
        .metrics(true)
        .build();
```

## Reference

- https://velog.io/@swjeong98/EC2-ElasticSearch-%EC%97%90%EC%84%9C-Connection-Reset-by-peer-%EC%97%90%EB%9F%AC-%EB%B0%9C%EC%83%9D
- https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/vpc-nat-gateway-cloudwatch.html
- https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/nat-gateway-troubleshooting.html#nat-gateway-troubleshooting-timeout
