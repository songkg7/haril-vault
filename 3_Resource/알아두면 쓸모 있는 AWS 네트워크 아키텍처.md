---
title: 알아두면 쓸모 있는 AWS 네트워크 아키텍처
date: 2024-04-01 19:39:00 +0900
aliases: 
tags:
  - awskrug
  - aws
  - network
categories: 
updated: 2024-04-01 20:18:30 +0900
---

### Hybrid Cloud 를 네트워크 인프라

- 보통 온프레미스와 클라우드 간 전용선을 구축하고 [[VPC]] 를 여러 개 구성함
- [[Transit gateway]] 를 사용하여 편리하게 구성 가능
- 근데 transit gateway 는 생각보다 저렴하지 않음
- AWS 로 들어가는(inbound) 비용은 무료
- 하지만 transit gateway 는 inboud outbound 가 아니라 데이터가 지나간 양만큼 과금
- 비용문제 해결을 위해 transit gateway 를 뒤로 뺐다.

### 하이브리드 환경에서 AWS 서비스 사용

DNS 와 endpoint 설정에 대한 노하우

- [[Conditional Forwarder]]

### 하이브리드 환경에서 AWS 서비스 사용

On-prem -> AWS 연동 시 on-prem 보안 최적화

- VPC subnet 의 랜덤 IP 를 사용자 정의하여 생성할 수 있게됨
- Public VIF 의 사용에 대한 이점 소개

- [[NAT gateway]] 를 사용하면 IP 대역이 얼마나 크든 상관없이 온프레미스에서 특정 아이피를 열어줄 수 있다.
- ErrorPortAllocation = NAT 는 최대 55000개의 동시 연결 지원하기 때문
- 현재는 8개의 IP 주소를 연결하여 440000 개의 동시연결을 할 수 있다

### IP 대역 중복시, 통신 방법

> AWS 간의 통신, AWS 와 온프레미스 간의 통신

- IP 대역 중복 시에는 라우팅 불가
- 중간에 별도 대역을 가진 VPC 를 구성하여 중계하도록 한다
- [[PrivateLink]]
