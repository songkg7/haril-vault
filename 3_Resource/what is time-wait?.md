---
title: TIME_WAIT 상태란 무엇일까?
date: 2024-05-19T00:05:00
aliases: 
tags:
  - network
  - packet
  - tcp
categories: 
updated: 2025-01-07T00:35
---

## TIME_WAIT 상태란 무엇인가?

- TIME_WAIT은 소켓이 닫힌 후 해당 포트를 재사용하기 전까지 머무르는 상태이다.
- 소켓이 닫히면 커널은 일정 기간 동안 네트워크에서 발생한 모든 패킷을 폐기하고, 해당 포트로 전송되는 패킷에 대해서는 "소켓을 찾을 수 없음"이라는 ICMP 메시지를 보낸다.
- 이러한 작업에 대해 일정 시간을 가질 필요가 있는데 이것이 TIME_WAIT 상태의 목적이다.
  - TIME_WAIT 상태가 아니라면 같은 포트를 사용하는 다른 연결과 충돌할 수 있기 때문.
  - TIMR_WAIT 상태가 아니라면 같은 IP 주소와 포트 번호를 가질 수 없다. => RFC793의 MSL(Maximum Segment Lifetime)에 따른 것.

## TIME_WAIT가 발생하는 경우

1. TCP `4-way handshake` 후 소켓 연결 종료
   - FIN 패킷을 받은 측에서 ACK 패킷을 보낸 후 -> ESTABLISHED -> CLOSE_WAIT
   - CLOSE_WAIT 상태에서 자신도 FIN 패킷을 보내고 ACK 패킷 받으면 -> LAST_ACK
   - 마지막으로 받은 측에서 ACK 패킷 보내면 -> CLOSED
   - FIN-WAIT-2, CLOSING 상태에서 소켓 연결이 끊어지지 않아서 TIME_WAIT 상태로 진입하는 경우도 있음
2. `TCP 서버소켓`을 만들어서 소켓 연결 종료
   - 클라이언트가 FIN 패킷을 보내고 ACK 패킷 받은 후 -> CLOSE_WAIT
   - 서버에서 FIN 패킷 보내고 ACK 패킷 받으면 -> LAST_ACK
   - 클라이언트 ACK 패킷 보내면 -> CLOSED

## TIME_WAIT 대처 방안

1. 서버소켓 바인딩 포트 재사용 옵션 설정
   - socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
2. 클라이언트 측에서 타임아웃 시간 설정
   - setsockopt(SOL_SOCKET, SO_LINGER)
3. 네트워크 레벨에서 타임아웃 시간 설정

## 사용 명령어

```bash
ss -tanop
```

## Reference

- https://docs.likejazz.com/time-wait/
- https://tech.kakao.com/posts/321
