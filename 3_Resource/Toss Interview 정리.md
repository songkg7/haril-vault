---
title: Toss Interview 정리
date: 2024-09-19T22:51:00
aliases: 
tags: 
categories: 
description: 
updated: 2025-01-07T00:35
---

# 1회차

답이 좀 아쉬웠던 질문

- [ ] 인덱스 관련 질문
- [ ] 국적 테이블의 데이터는 3만개,유저 테이블의 유저는 10만명. 어떻게 하면 특정 국적을 가진 인원이 몇 명인지를 효율적으로 확인할 수 있을까

```sql
-- 국적 테이블 = nationality
-- 유저 테이블 = user
SELECT n.id, n.name, count(*)
FROM nationality AS n
JOIN user ON n.id = user.nationality_id
GROUP BY n.name;
```

- [ ] Select for update 동작 방식
    - [ ] MySQL 은 데드락을 자동으로 감지해주는 기능이 있다. 어떤 원리로 가능한가?
- [ ] 50ms 의 응답속도롤 보여주는 API 가 문제가 되고 있다. 어떻게 개선할 것인가?
- [ ] Spring MVC 의 톰캣 쓰레드는 200개가 기본값인데 그럼 이 서버의 동시 사용 가능한 유저 수는 어느 정도 될까?
- [ ] MSA 환경에서의 분산 트랜잭션을 어떻게 해야 보장할 수 있을까?
- [ ] rate limit 를 직접 구현해야한다면 어떻게 구현할 것인가?
- [ ] [[Back pressure]]의 구현방법
    - [ ] rate limit 과 back pressure 의 차이
- [ ] UUID, ULID, [[Snowflake]] 에 대해서 = 전역 아이디 생성기에 대한 이야기
    - [ ] snowflake 는 중앙 집중적인 방식인가? 아니면 분산 방식인가?
- [ ] [[AWS Lambda]] 의 cold start 문제 해결법
- [ ] 그렇다면 Repeatable read 격리 레벨과 낙관적 락의 차이는 무엇인가?

---

# 2회차

## 실제 질문 받은 내용

몇가지 질문들에서 맥락 파악을 잘 못한 부분이 있는 것 같음

### 테스트 관련 질문

- FixtureMonkey 사용 이유에 대한 경험 기반 질문들
    - Why? 관점. 왜 꼭 그거여야만 하는지, 다른 방법은 없는지, 설득력이 있는지 확인하려는 느낌

### 네트워크 관련 질문

- [ ] 비동기 HTTP 호출에 대해
    - [ ] 비동기는 멀티스레드로 구현하는가?
    - [ ] (이벤트루프 관련 이야기를 꺼낼 경우) 그렇다면 이벤트루프와 멀티쓰레드의 차이는 무언인가?
    - [ ] 그래서 이벤트루프는 싱글 스레드? 멀티 스레드?
    - [ ] async 와 non-blocking 의 차이를 제대로 알고 있는가?
- [ ] read timeout 을 얼마나 걸어야할까
- [ ] 네트워크 타임아웃이 발생한다면
- [ ] 서킷 브레이커의 구현
    - [ ] 레디스로 구현할 수 있을까?
- [ ] TCP/IP 순서보장 원리
    - [ ] packet, ip header 등등 네트워크에 대해 최대한 알고있는만큼 설명해달라
- [ ] 메세지 큐를 사용할 때 이벤트 유실이 될 수 있는지
    - [ ] TCP 기반이라면 응답이 보장되지 않는가? 왜 유실될 수 있는가?
- [ ] Interface 에 대해
    - 자주 사용하는 JDK or Spring interface 가 있다면

## 느낀 점

- 기술 질문 외적인 질문은 거의 나오지 않음
- 기본 네트워크 질문이 많이 나옴
- 기본기가 중요
- 전체적인 질문 맥락 이해를 못하고 대답한게 몇가지 있는듯
