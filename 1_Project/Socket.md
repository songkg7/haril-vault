---
title: Socket
date: 2023-10-01 16:08:00 +0900
aliases: 
tags:
  - socket
  - network
categories: Network
updated: 2023-11-11 00:19:01 +0900
---

## Socket 의 본질에 대한 이해

- 소켓(Socket)은 [[운영체제 (Operating system)|OS]] 커널에 구현되어 있는 프로토콜 요소에 대한 추상화된 인터페이스
- **장치 파일의 일종**으로 이해할 수 있음
- 일반 파일에 대한 개념이 대부분 적용됨

Stream 이라는 키워드를 알아둬야 한다. 소켓 또한 파일이기 때문에 파일에 append mode 로 쓰듯이 데이터가 네트워크로 전송된다. 따라서 유저 모드 애플리케이션에서 소켓이라는 단어가 나오게 되면 스트림이라는 말이 함께 나온다.

유저 모드 애플리케이션에서는 소켓 파일에 작성하지만, L4 로 내려가면 데이터 단위가 바뀌게 되는데 이를 [[Segment]] 라고 부른다. 더 내려가 L3 로 가게되면 [[Packet]] 이라고 하게 되는 것이다. 한 번 더 내려가면 L2 Datalink 인데 여기서는 [[Frame]] 이라고 한다.

- Stream: 데이터
- Segment: 데이터 조각
- Packet: 네트워크 전송을 위해 포장된 Segment

## Reference

- [소켓의 본질에 대한 이해](https://www.youtube.com/watch?v=3jQ2dBpiqPo)
- [커널과 함께 알아보는 소켓과 TCP Deep Dive](https://brewagebear.github.io/linux-kernel-internal-3/)
