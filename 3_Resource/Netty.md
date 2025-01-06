---
title: Netty
date: 2024-02-13T14:42:00
aliases: 
tags:
  - java
  - nio
  - non-blocking
  - asnyc
categories: 
updated: 2025-01-07T00:35
---

## Netty 란

Netty는 자바 비동기 네트워크 프로그래밍 라이브러리로, 고성능, 고도의 확장성을 가지고 있습니다. Netty는 서버와 클라이언트 간에 데이터를 빠르고 쉽게 전송할 수 있도록 도와주는 도구입니다.

Netty는 다양한 프로토콜을 지원하며, TCP/IP 와 UDP를 포함한 대부분의 네트워크 프로그래밍을 단순화 시켜줍니다. 또한, 이러한 프로토콜들을 효율적으로 구현하기 위해 많은 최적화 기법들이 사용되었습니다.

Netty의 주요 특징은 다음과 같습니다:

- 통합된 API: Netty는 문자열, 스트림, 데이터그램 등 다양한 데이터 타입을 지원하며 이들을 모두 통합된 API로 제공합니다.
- 비동기 방식: Netty는 I/O 작업이 완료되기를 기다리지 않고 즉시 리턴하는 비동기 방식을 사용합니다. 이를 통해 성능 개선과 자원 사용량 최소화를 달성할 수 있습니다.
- 이벤트 기반: Netty는 이벤트 기반의 프로그래밍 모델을 제공하여 애플리케이션의 로직을 간단하고 명확하게 표현할 수 있습니다.
- 고성능: Netty는 네트워크 애플리케이션의 성능을 최적화하기 위한 다양한 기법을 사용합니다.
- 확장성: Netty는 코어 프레임워크와 독립적인 모듈로 이루어져 있어 확장성이 우수합니다.

_위 내용은 GPT 에 의해 작성되었습니다._

## Netty 톺아보기

### Channel

### Selector

클라이언트 연결이 붙게 되면 소켓채널(SocketChannel)이 열린다. 클라이언트는 자기가 보내고 싶을 때 요청을 보내기 때문에 서버는 클라이언트의 요청을 기다려야 한다.

멀티플렉싱(Multiplexing)

### Event Loop

### TaskQueue

## Reference

- https://hbase.tistory.com/39
- https://sightstudio.tistory.com/15
- https://www.getoutsidedoor.com/2021/10/03/eventloop-%EC%84%A4%EA%B3%84%EC%99%80-%EA%B5%AC%ED%98%84-el-project/
- https://mark-kim.blog/netty_workflow/