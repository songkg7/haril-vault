---
title: "Question list"
date: 2023-05-24 20:20:00 +0900
aliases: 
tags: [question]
categories: 
updated: 2023-06-30 14:23:07 +0900
---

1. 동시성 이슈가 발생할 수 있는 부분을 염두에 둔 구현
: DBMS 레벨 lock, 애플리케이션 레벨 lock

2. SPOF, 외부 의존성 최소화
: 레플리케이션, 클러스터링, 써킷브레이커

3. 대용량의 데이터를 효과적으로 저장하는 방법
: write cache, x-lock 등

4. 대용량의 데이터를 효과적으로 읽는 방법
: index, s-lock, read cache 등

spin lock
https://brownbears.tistory.com/45

1. 내가 엔지니어로서 해보고 싶은 전체적인 경험
2. 그 중 과거에 했던 경험
3. 2를 바탕으로 그 회사에 기여할 수 있을만한 점
4. 그 회사에서 해보고 싶은 경험

5줄정도 쓰면 돌려먹기

[https://careerly.co.kr/comments/83898?utm_campaign=user-share](https://careerly.co.kr/comments/83898?utm_campaign=user-share)

- 트래픽이 갑자기 몰린다면 어떻게 대처할 수 있을까?
    - 상황에 따라 다르다. 사실 당장 트래픽이 몰릴때 개발자가 할 수 있는건 스케일아웃 외에는 거의 없다.
    - 만약 트래픽이 증가하는 상황이 예상된다면 이것저것 시도해볼 수 있을 것 같다.
- (캐시를 사용한다면) CUD 작업에 몰리는 트래픽에 대해서는 어떻게 대처할 것인가?
    - Read DB, Write DB 의 분리
- 방문 수를 기록하는 기능과 같은 데이터가 있다면 어떻게 동시성을 보장할 것인가?
    - 메세지큐에 밀어넣고 배치 등으로 이벤트를 처리하기?
    - 조회 수 같은 경우는 실시간성이 크게 중요하지 않기 때문에 허수 처리에 대한 방법을 고민하는 것이 더 중요할 수 있다.
