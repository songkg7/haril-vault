---
title: Network Monitoring CLI tools
date: 2024-05-18 13:00:00 +0900
aliases: 
tags:
  - tool
  - network
categories: 
updated: 2024-05-18 13:58:59 +0900
---

네트워크 모니터링 및 실험에 사용할 수 있는 다양한 도구들에 대해 소개.

[[Linux]] 환경에서 동작하는 명령도 있기 때문에, vm 을 하나 생성해서 진행. vm 생성은 [[Orbstack]] 을 사용.

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
```

현재 접속한 가상머신의 아키텍처 확인

```bash
uname -a
arch
```

준비 완료.

net-tools 프로그램의 일원으로 아래 명령어들이 있다.

## ifconfig

```bash
ifconfig
```

## netstat

```bash
netstat -p tcp -van
```

하지만 위 두 명령어는 방치된지 너무 오래되어(17년 이상) 최근은 iproute2 라는 프로젝트로 새로운 명령어들이 사용된다. 특히 ubuntu 18.04 부터는 net-tools 프로그램이 더이상 포함되지 않는다.

아직도 net-tools 만 사용할 줄 안다면...

```bash
brew install iproute2mac
```

### bandwhich

### lsof

lsof = Lists open files

애플리케이션을 개발하다가 이미 포트를 점유하고 있다는 에러를 봤을 때 한번쯤은 사용해봤을 명령어

```bash
lsof -i :8080
```

## Linux

### ip

ifconfig 를 대체하는 명령

```bash
ip address show # 네트워크 인터페이스 정보
ip route show # routing 요소
ip neighbor show # ARP 테이블에 등록된 알려진 호스트들
```

### ss

- 소켓 상태를 조회하는 유틸
- [[netstat]] 의 개선버전
- 최근 리눅스 배포판은 netstat 보다는 ss 사용을 권장

```bash
ss -a # 모든 소켓 표시
ss -t # TCP 소켓 표시
ss -u # UDP 소켓 표시
ss -lt src :80 # 80 포트 리스닝 소켓 표시
```

## Reference

- https://www.lesstif.com/lpt/linux-socket-ss-socket-statistics-91947283.html
- https://awesometic.tistory.com/125