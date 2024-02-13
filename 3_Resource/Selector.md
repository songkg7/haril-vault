---
title: Selector
date: 2024-02-13 14:38:00 +0900
aliases: 
tags:
  - nio
  - non-blocking
categories: 
updated: 2024-02-13 14:38:24 +0900
---

## Selector 란?

Java Selector는 Java NIO (New I/O) 패키지에서 제공하는 클래스로, 네트워크 소켓 채널의 이벤트를 모니터링하고 처리하는 데 사용됩니다.

일반적으로 Java Selector는 다수의 네트워크 소켓 채널을 단일 스레드에서 관리할 때 사용됩니다. 하나의 스레드에서 여러 개의 네트워크 연결을 처리할 수 있으므로, 네트워크 프로그래밍의 확장성과 성능을 향상시킬 수 있습니다.

Java Selector는 SelectionKey라는 객체를 사용하여 소켓 채널과 연결됩니다. SelectionKey에는 등록된 채널과 해당 채널에 대한 관심 이벤트 등록 정보가 포함되어 있습니다. Selector는 등록된 채널들 중에서 발생한 이벤트를 감지하고, 해당 이벤트에 대한 처리를 위해 스레드를 깨우거나 작업을 수행합니다.

Selector를 사용하면 비동기적인 네트워크 프로그래밍이 가능해지며, 블로킹 입출력 모델보다 훨씬 효율적인 방식으로 동작할 수 있습니다.

## Reference

- https://hbase.tistory.com/39
