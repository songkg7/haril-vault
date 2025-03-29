---
title: Network Monitoring CLI tools
date: 2024-05-18T13:00:00
aliases: 
tags:
  - tool
  - network
  - k6
  - ngrinder
  - jmeter
  - locust
categories: 
updated: 2025-03-02T20:39
published: 2025-03-02
---

![](https://i.imgur.com/LuUWLuZ.png)

## Overview

발표 준비를 어디서부터 시작해야할지 모르겠다는 분들을 위해 짤막하게 준비해본 세션입니다. 네트워크 모니터링 및 실험에 사용할 수 있는 다양한 도구들에 대해 소개하고 사용법을 설명합니다.

## 환경

네트워크를 공부하기 위해 어떤 환경을 준비해야할까요? 물론 공부하고자하는 주제에 따라 다르겠지만, 자주 사용되는 방법 몇가지를 살펴봅시다.

### 1. EC2 생성 후 Public IP 오픈

#### Pros

- 가장 일반적인 방법
- 물리적으로 다른 기기이기 때문에 로컬 환경에 영향받지 않고 가장 정확한 테스트가 가능

#### Cons

- 유료이기 때문에 리소스 정리에 신경쓸 필요가 있음
- 네트워크 설정이 필요하기 때문에 인프라에 대한 이해가 필요함

### 2. Docker 로 특정 OS 컨테이너 실행

#### Pros

- docker 만 설치되어 있다면 편리하게 셋업 가능
- 무료

#### Cons

- docker exec 를 통해 컨테이너에 직접 접근해야하는데, 이 경험이 그닥 좋지 않음
- docker container 로 다른 OS 를 띄우는건 컨테이너 목적에 부합한 방법은 아님
- 호스트 머신의 리소스를 빌려 사용하기 때문에 완벽하게 분리된 테스트는 아님

### 3. VM

#### Pros

- 호스트 머신의 OS 와 다른 OS 를 사용해야할 때 유용
- 물리적으로 분리된 환경 구성 가능

#### Cons

- 맥에서 VM 을 사용하기 위한 셋업이 까다로움
- 별도의 OS 를 실행하기 위한 리소스가 많이 필요함

## 성능 테스트 도구

### [[Apache Bench]]

[ab - Apache HTTP server benchmarking tool - Apache HTTP Server Version 2.4](https://httpd.apache.org/docs/2.4/programs/ab.html)

터미널로 사용할 수 있어서 매우매우 간단하게 접근할 수 있는 벤치마크 툴

### [[K6]]

[Load testing for engineering teams \| Grafana k6](https://k6.io/)

[[Grafana]] Lab 에서 만들고 있는 성능 테스트 도구. 현대적인 인터페이스와 사용법, 다양한 유즈케이스를 모두 지원한다.

[이 글](https://haril.dev/blog/2023/11/10/Spring-MVC-Traffic-Testing) 에서도 K6 를 사용했었다. **일반적으로 성능테스트가 필요하다면 K6 를 가장 추천**

### nGrinder

[nGrinder](https://naver.github.io/ngrinder/)

Naver 에서 만들고 있는 성능테스트 도구. 분산환경 테스트에 유리하다. 꽤 많은 사용사례가 있고, 한국어 문서가 많아서 국내 개발자들에게는 접근성이 훌륭하다.

### JMeter

[Apache JMeter - Apache JMeter™](https://jmeter.apache.org/)

### Locust

[Locust - A modern load testing framework](https://locust.io/)

[[Python]] 으로 작성된 성능테스트 도구. 본인의 환경이 [[Python]] 에 특화되어 있다면 다른 툴에 비해 장점을 가질 수 있다.

## 전통적 네트워크 모니터링 도구

- 네트워크 관련 실험을 위해서는 결과 비교를 위해 네트워크 모니터링 관련 도구 사용법이 요구된다

### `lsof`

```bash
lsof path/to/file # file 을 열고 있는 프로세스 조회
lsof -i :8080 # local internet 포트를 통해 열려있는 프로세스 조회
lsof -p PID # 주어진 PID 가 열고 있는 파일 목록 조회
```

- lsof = Lists open files
- 어떤 파일이 어떤 프로세스를 통해 열려있는지 출력해주는 명령어 = 파일 디스크립터 조회 가능
- 애플리케이션을 개발하다가 이미 포트를 점유하고 있다는 에러를 봤을 때 한번쯤은 사용해봤을 명령어
- kill 명령어와 함께 8080 포트를 점유한 인텔리제이를 강제 종료하는데 가장 많이 사용되지 않았을까...

### `ifconfig`

```bash
ifconfig
```

- 네트워크 장비 체크의 기본 명령
- [net-tools](https://github.com/giftnuss/net-tools) 에 포함

### `netstat`

- 네트워크 접속, 라우팅 테이블, 네트워크 인터페이스의 통계 정보를 표시하는데 사용되는 도구

```bash
netstat -p tcp -van
```

## 현대적인 네트워크 모니터링 도구

### 다소 낡은 Net-tools

- 꽤 오래된 net-tools = **약 26년**
- **마지막 커밋이 14년 전**
- 최근에는 iproute2 라는 프로젝트의 새로운 명령어들이 사용
- ubuntu 18.04 부터는 net-tools 가 더 이상 포함되지 않음
- mac 이라면 `brew install iproute2mac` 명령어로 새로운 도구들을 사용할 수 있다

### `ip`

ifconfig 를 대체하는 명령

```bash
ip address show # 네트워크 인터페이스 정보
ip route show # routing 요소
ip neighbor show # ARP 테이블에 등록된 알려진 호스트들 = 서브 네트워크에 포함된
```

### `ss`

- 소켓 상태를 조회하는 유틸
- [[netstat]] 의 개선버전
- 최근 리눅스 배포판은 netstat 보다는 ss 사용을 권장

```bash
ss -a # 모든 소켓 표시
ss -t # TCP 소켓 표시
ss -u # UDP 소켓 표시
ss -lt src :80 # 80 포트 리스닝 소켓 표시
```

### Bandwhich

- 네트워크 대역폭 모니터링 도구
- 어떤 요청이 오고가는지 실시간으로 모니터링 가능

```bash
bandwhich
```

## 실습

목적은 빠르게 nginx 서버를 실행시켜보고, 네트워크 테스트 용도로 사용할 수 있을지 확인해보는 것.

- vm 생성은 [[Orbstack]] 을 사용
- orbstack 은 vm 을 편리하게 다룰 수 있는 기능을 제공

먼저 ubuntu 머신을 하나 생성

```bash
orb create ubuntu
```

가상머신이 정상적으로 생성되었는지 확인해보기

```bash
orb list
```

ssh 를 통해 방금 생성한 가상머신에 접근

```bash
ssh orb
# or
ssh machine@orb
```

현재 접속한 가상머신의 아키텍처 확인

```bash
uname -a
arch
```

준비 완료.

간단한 네트워크 요청 테스트를 위해 [[NginX]] 를 설치

```bash
sudo apt update
sudo apt install nginx
```

localhost or http://ubuntu.orb.local/ 로 접근해보자

![](https://i.imgur.com/2OAjyz9.png)

아래 명령으로 tcp 연결이 생성되는걸 모니터링할 수 있다.

```bash
watch ss -taonp
```

curl 이나 httpie 로 요청을 보낼 경우 바로 time_wait 상태로 변한다. 이는 내부적으로 요청에 대한 응답을 받는 경우 바로 연결을 끊는 매커니즘이 존재하기 때문이다.

![](https://i.imgur.com/ftNEOoK.png)

![](https://i.imgur.com/XO1oqk9.png)

## Conclusion

네트워크 상태를 모니터링하기 위한 방법들과 사용할 수 있는 도구들에 대해 살펴보았다. 각자의 도구는 특화된 분야가 다르고 쓰임새도 가지각색이니, 여러 도구를 알아두는 것이 디버깅에 유리할 것이다. 모든 도구를 자세히 알아야하는 것은 아니고 '이런 것들도 있구나' 정도로 살펴본 뒤, 필요할 때 자세히 살펴보면 충분히 도움이 될 것으로 생각된다.

## Reference

- https://www.lesstif.com/lpt/linux-socket-ss-socket-statistics-91947283.html
- https://awesometic.tistory.com/125
