---
title: TCP
date: 2022-08-16T12:37:00
publish: false
aliases: []
tags:
  - network
  - tcp
  - ip
categories: Network
updated: 2025-01-07T00:35
---

[[Network]]

> [!info] TCP
> 전송 제어 프로토콜 (Transmission Control Protocol)

## TCP/IP 의 중요한 성질

데이터의 순서가 바뀌지 않으면서 데이터가 유실되지 않도록 가급적 빠르게 데이터를 보내려면 네트워크 프로토콜을 어떻게 설계해야 할까? TCP/IP 는 이런 고민 아래 설계된 것이다.

### 1. Connection oriented

두 개의 엔드포인트(로컬, 리모트) 사이에 연결을 먼저 맺고 데이터를 주고 받는다. 여기서 'TCP 연결 식별자'는 두 엔드포인트의 주소를 합친 것으로, <로컬 IP 주소, 로컬 포트번호, 리모트 IP 주소, 리모트 포트번호> 형태이다.

### 2. Bidirectional byte stream

양방향 데이터 통신을 하고, 바이트 스트림을 사용한다.

### 3. In-order delivery

송신자(sender)가 보낸 순서대로 수신자(receiver)가 데이터를 받는다. 이를 위해서는 데이터의 순서가 필요하다. 순서를 표시하기 위해 32-bit 정수 자료형을 사용한다.

### 4. Reliability through ACK

데이터를 송신하고 수신자로부터 ACK(데이터 받았음)를 받지 않으면, 송신자 TCP 가 데이터를 재전송한다. 따라서 송신자 TCP 는 수신자로부터 ACK를 받지 않은 데이터를 보관한다(buffer unacknowledged data).

### 5. Flow control

송신자는 수신자가 받을 수 있는 만큼 데이터를 전송한다. 수신자가 자신이 받을 수 있는 바이트 수(사용하지 않은 버퍼 크기, received window)를 송신자에게 전달한다. 송신자는 수신자 receive window 가 허용하는 바이트 수만큼 데이터를 전송한다.

### 6. Congestion control

네트워크 정체를 방지하기 위해 receive window 와 별도로 congestion window 를 사용하는데 이는 네트워크에 유입되는 데이터양을 제한하기 위해서이다. Receive window 와 마찬가지로 congestion window 가 허용하는 바이트 수만큼 데이터를 전송하며 여기에는 TCP Vegas, Wetwood, BIC, CUBIC 등 다양한 알고리즘이 있다. Flow control 과는 달리 송신자가 단독으로 구현한다.

---

# IP stack 4계층

1. Link - 네트워크 인터페이스 계층
2. IP - 인터넷 계층
3. TCP, UDP - 전송 계층
4. HTTP, FTP - 애플리케이션 계층

## 특징

- 연결지향
- 데이터 전달 보증
- 순서 보장
- 신뢰할 수 있는 프로토콜
- ~~현재는 대부분 TCP 사용~~ HTTP 3 부터는 UDP

## Reference

- [TCP 속도](https://m.blog.naver.com/PostView.naver?blogId=goduck2&logNo=221112593320&navType=by)
- https://d2.naver.com/helloworld/47667
