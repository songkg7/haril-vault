---
title: network packet ppt
date: 2024-04-10 22:25:00 +0900
aliases: 
tags:
  - packet
  - ppt
categories: 
updated: 2024-04-10 23:16:51 +0900
---

# Week 1. Wireshark

---

## 네트워크가 어려운 이유

- 눈에 안보이는 부분에서 너무 많은 일이 일어난다
- 패킷 분석은 네트워크를 이해하는 첫걸음

---

## 사용할 툴

- Termshark(⭐)
- Docker(⭐)
- Httpie

모두 brew 로 설치할 수 있어요.

```bash
brew install httpie termshark orbstack
```

---

### Termshark

- Wireshark 의 TUI 버전
- Wireshark 를 사용해도 무방하나 wireshark 는 이미 자료가 많음
- GUI 를 사용할 수 없는 곳에서 패킷 분석이 필요하다면?
- 무엇보다 사용이 간편

---

### Httpie

- 일반적으로 사용하는 curl 에 비해 사용성이 좋다
- 직관적인 명령 및 출력으로 학습해야할 부분이 거의 없다

---

### Docker

- 테스트용 서버를 바로 실행하기 위해 사용
- 도커 네트워크의 동작도 재밌는 부분이지만...
- 자세한 설명은 생략

---

## 패킷이란?

- 모든 네트워크 송수신 동작은 OS 의 프로토콜 스택에서 발생
- OS 는 택배를 포장하듯이 데이터를 감싸고 송장을 붙여 발송한다
- 송장이 붙은 택배 종이박스 = 패킷

---

## 문제는...

- 모든 과정이 커널에서 발생하기 때문에 겉(브라우저 or 애플리케이션 레벨)로 드러나지 않는 것
- 내가 보낸 데이터가 상대에게 잘 갔는지 어떻게 확인할 수 있을까?
- 네트워크를 통해 정확하게 어떤 정보가 오고가는지 확인하고자 하는 것 = 패킷 덤프
- 즉, 패킷 분석은 네트워크 디버깅에서 매우 중요한 역할

---

## 핸즈온

- 패킷을 하나하나 직접 확인하며 네트워크 동작 과정을 들여다보자

---

### 아래 의문을 해결할 수 있을거에요

- 3 way handshake 과정
- 서버는 패킷이 유실되었는지 어떻게 알 수 있을까?
- flag?
- MSS

---

### 1. 네트워크 장비 확인

```bash
tshark -D # ifconfig
tshark -i 1 -t a --color # 현재 네트워크 동작이 보임
```

---

### 2. 테스트용 서버 실행

```bash
docker run -p 8080:8080 songkg7/rest-server
```

- 테스트 서버는 `/ping` 과 `/dummy` 엔드포인트를 제공
- 먼저 `/ping` 으로 요청

```bash
http localhost:8080/ping
# { "message": "pong" }
```

- 이 과정을 캡쳐하여 무슨 일이 일어나는지 살펴보자

---

### 3. 패킷 캡쳐

```bash
tshark -i lo0 -w test.pcap # 터미널 세션 block
```

다른 터미널 세션을 열고,

```bash
http localhost:8080/ping
```

이후 tshark 를 실행했던 세션으로 돌아가 `ctrl + c` 를 눌러 종료. `ls` 로 확인해보면 pcap 파일이 생긴 것을 확인할 수 있을 것

---

### 4. 분석

덤프파일을 열어보자

```bash
termshark -r test.pcap
```

- `tab`: focus 이동
- `?`: 도움말
- `/` : filter, `tcp.port==8080` 로 원하는 것만 볼 수 있다.
- `q`: 종료
