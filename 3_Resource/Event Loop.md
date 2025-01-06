---
title: 
date: 2023-01-11T18:32:00
aliases: 
tags:
  - webflux
  - reactive
  - reactor
categories: 
updated: 2025-01-07T00:35
---
## Overview

single thread 를 사용하여 대량의 트래픽을 처리하기 위한 reactive 처리 방식

Event Loop 는 중단되지 않고 실행되는 상태로 존재하다가 event 가 들어오면 요청을 보내고 바로 반환한다? event 에 대한 결과가 처리되면 다시 반환?

하나의 event 는 event 의 라이프사이클동안은 같은 thread 안에서 동작한다.

[[Spring WebFlux|WebFlux]]

- [ ] 멀티스레드와 이벤트 루프의 차이점
- [ ] 이벤트 루프는 비동기인가?
- [ ] 이벤트 루프는 논블락킹인가?

blocking, non-blocking I/O 시스템콜에 대한 이해가 필요하다.

## 구현

- while 루프를 통한 task 위임
- Java 21 의 [[Virtual Thread]] 를 사용해보기
- thread pool 구현
- stack trace 문제를 어떻게 해결할 수 있을까?
    - stack trace 는 스레드에 할당되는 stack 공간에 대한 추적 정보이다. 따라서 스레드를 넘나드는 태스크라면 활용하기 어렵다.
    - stack trace 대신 로그 정보를 담는 기능을 boolean 값으로 전달할 수 있으면 좋을듯
    - 퍼포먼스 관점에서 트레이드오프 지점인지 체크
    - **Continuation**
- non-blocking I/O 로 처리할 경우, 응답을 어떻게 다시 돌려받을 수 있는지 확인
- event loop 에서 실행될 작업은 `Runnable` 을 구현한 `Task` 객체를 정의하여 구현

이벤트 루프는 단일 스레드로 구현하되, 메인 스레드가 블로킹되는 상황 회피를 위해 멀티스레드 방식을 혼합해야 할 수 있다. 이 때 멀티스레드는 스레드풀을 구현하여 미리 생성되어 있는 스레드르 사용하자.

이벤트 루프를 완전한 단일 스레드로 구현하기 위해서는 시스템 콜에 의해 블로킹되지 않도록, non-blocking I/O 를 사용하여야 한다.

블로킹을 해야한다면 이벤트 루프가 블록되는 상황을 피하기 위해 별도의 스레드에서 작업을 수행해야 한다

네트워크 호출은 OS 가 처리한다. 일반적으로는 blocking 작업이지만 non-blocking I/O 를 사용하여 구현할 수 있다.

- `Socket`: blocking network call
- `SocketChnnel`: non-blocking network call

> [!NOTE] `ServerSocket`
> 클라이언트의 요청을 받기 위한 socket, 즉 서버 애플리케이션을 만들기 위한 클래스이다

```java
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.util.Iterator;
import java.util.Set;

public class NonBlockingClient {
    public static void main(String[] args) {
        try {
            // Create a non-blocking socket channel
            SocketChannel socketChannel = SocketChannel.open();
            socketChannel.configureBlocking(false);

            // Create a selector
            Selector selector = Selector.open();

            // Register the socket channel with the selector to connect
            socketChannel.register(selector, SelectionKey.OP_CONNECT);

            // Attempt to connect to the server
            socketChannel.connect(new InetSocketAddress("localhost", 8080));

            while (true) {
                // Wait for events
                selector.select();

                // Get selected keys
                Set<SelectionKey> selectedKeys = selector.selectedKeys();
                Iterator<SelectionKey> iter = selectedKeys.iterator();

                while (iter.hasNext()) {
                    SelectionKey key = iter.next();

                    if (key.isConnectable()) {
                        // Finish the connection if it's ready
                        SocketChannel client = (SocketChannel) key.channel();
                        if (client.isConnectionPending()) {
                            client.finishConnect();
                            System.out.println("Connected to server");
                            // Once connected, register interest in writing data
                            client.register(selector, SelectionKey.OP_WRITE);
                        }
                    } else if (key.isWritable()) {
                        // Write data
                        SocketChannel client = (SocketChannel) key.channel();
                        ByteBuffer buffer = ByteBuffer.wrap("Hello, server!".getBytes());
                        client.write(buffer);
                        System.out.println("Sent message to server");
                        // Once written, register interest in reading the response
                        client.register(selector, SelectionKey.OP_READ);
                        buffer.clear();
                    } else if (key.isReadable()) {
                        // Read data
                        SocketChannel client = (SocketChannel) key.channel();
                        ByteBuffer buffer = ByteBuffer.allocate(256);
                        client.read(buffer);
                        String response = new String(buffer.array()).trim();
                        System.out.println("Server response: " + response);
                        // Close the connection after reading the response
                        client.close();
                        System.out.println("Connection closed");
                        return; // Exit after processing
                    }
                    iter.remove();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## Reference

- https://developer.ibm.com/articles/l-async/
- https://grip.news/archives/1304
- https://smileostrich.tistory.com/entry/What-is-IOuring-Inside-IOuring
