---
title: CIDR
date: 2024-04-02 10:44:00 +0900
aliases:
  - CIDR
tags:
  - cidr
  - network
  - ip
  - ipv4
categories: 
updated: 2024-04-02 10:44:57 +0900
---

[[Network|Network]]

## CIDR 이란 무엇일까?

CIDR(Classless Inter-Domain Routing)는 인터넷의 IP 주소 체계를 나타내는 표기법입니다. [[IP|IP]] 주소는 일반적으로 네트워크 ID와 호스트 ID로 구성되어 있습니다. 네트워크 ID는 네트워크 자체를 식별하고, 호스트 ID는 해당 네트워크에 연결된 각각의 컴퓨터를 식별합니다.

기존에는 IP 주소 체계에서 네트워크 클래스(Class)라는 개념을 사용해 네트워크 ID와 호스트 ID의 비율을 정했습니다. 예를 들어, A 클래스의 IP 주소는 첫 번째 바이트가 네트워크 ID로 사용되고 나머지 세 바이트가 호스트 ID로 사용되었습니다. 따라서 A 클래스의 IP 주소 범위는 0.0.0.0에서 127.255.255.255까지였습니다.

하지만 이 방식은 인터넷이 확장됨에 따라 IP 주소 부족 문제가 발생하게 되었습니다. 그래서 CIDR 방식이 도입되었습니다. CIDR 방식에서는 더 큰 범위의 IP 주소 블록을 나타낼 수 있도록 비트 단위로 유연하게 조정할 수 있습니다.

CIDR은 두 부분으로 이루어져 있습니다.

첫 번째 부분은 IP 주소를 나타내는 부분입니다. 예를 들어, 192.168.1.0/24라는 CIDR 표기법이 있다면, 여기에서 192.168.1.0은 네트워크 ID를 나타내고, /24는 네트워크 ID의 비트 수를 나타냅니다.

두 번째 부분은 서브넷 마스크(Subnet Mask)입니다. 서브넷 마스크는 네트워크 ID와 호스트 ID를 분리하는 역할을 합니다. 예를 들어, 위의 CIDR 표기법에서 /24는 255.255.255.0과 동일한 의미를 가지며, 이는 첫 번째 세 바이트가 네트워크 ID로 사용되고 나머지 한 바이트가 호스트 ID로 사용된다는 것을 의미합니다.

CIDR 방식은 IP 주소 블록을 더 유연하게 나타낼 수 있으며, IP 주소 부족 문제를 해결하는 데 큰 역할을 하였습니다. 또한 서브넷팅(Subnetting)과 슈퍼넷팅(Supernetting) 등의 기술도 가능하게 만들어주었습니다.