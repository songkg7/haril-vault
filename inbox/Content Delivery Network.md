---
title: CDN
date: 2023-09-05 18:07:00 +0900
aliases:
  - CDN
tags:
  - cache
  - network
categories: 
updated: 2023-09-05 18:07:53 +0900
---

지리적인 제약 없이 전세계 사용자에게 빠르고 안전하게 컨텐츠 전송을 할 수 있는 기술. 이를 통해서 컨텐츠의 병목현상을 피할 수 있다.

## 장점

1. 웹사이트 로딩 속도 개선
2. 인터넷 회선 비용 절감
3. 컨텐츠 제공의 안정성
4. 웹사이트 보안 개선

## CDN 의 필요기술

1. Load Balancing
2. 컨텐츠를 배포하고 캐시를 갱신하는 기술
3. CDN 의 트래픽을 감지하는 기술

## 캐싱 방식

### Dynamic Caching

Origin Server 의 컨텐츠 운영자가 미리 캐시 서버를 업데이트하지 않는다. 사용자가 컨텐츠를 요청시 해당 컨텐츠가 캐시 서버에 존재하지 않으면 Origin Server 에 컨텐츠를 요청하고 캐시한다.

### Static Caching

Origin Server 의 컨텐츠 운영자가 미리 캐시 서버에 복사한다. 사용자의 요청은 반드시 캐시 히트한다. 대부분의 국내 CDN 에서 이 방식을 사용한다.

## Links

- [[AWS CloudFront]]

## Reference

- [CDN 이란 무엇인가](https://velog.io/@youngblue/CDN%EC%9D%B4%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)