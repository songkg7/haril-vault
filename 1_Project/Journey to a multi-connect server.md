---
title: 다중 접속 서버로의 여정
date: 2024-04-27 00:27:00 +0900
aliases: 
tags:
  - network
  - socket
  - multi-thread
  - eventloop
  - kernel
  - non-blocking
  - nio
  - java
categories: 
updated: 2024-05-17 16:46:26 +0900
---

## Overview

너무나 당연하게 느껴지는 멀티커넥션 서버. 하지만 극단적으로 많은 요청이 발생하면 미리 알고 있어야하는 지식들이 꽤 많다. 이번 글에서는 많은 트래픽이 발생하는 환경을 처리하기 위해 어떻게 기술이 발달해왔는지, 네트워크와 [[Java]] 를 기준으로 살펴봅니다.

## 소켓 프로그래밍

- 서버 입장에서 생각해보자
    - socket() 으로 소켓 생성
    - bind(), listen() 으로 연결 준비
    - accept() 로 연결 수락
    - 수락 후 바로 다른 소켓을 할당 = 다른 연결을 수락할 수 있어야 하기 때문

> [!question] 소켓을 fd 로 사용하는 이유는?
> 자신의 ip, port, 상대방의 ip, port 를 사용해도 소켓을 사용할 수 있지만 fd 를 사용하는 이유는 연결이 수락되기 전 소켓에는 아무런 정보가 없기 때문이고 또한 단순한 정수인 fd 보다 많은 데이터가 필요하기 때문

![](https://vos.line-scdn.net/landpress-content-v2_1761/1672029326745.png?updatedAt=1672029327000)

## 단일 프로세스 서버

```java
try (ServerSocket serverSocket = new ServerSocket(PORT)) {
    while (true) {
        try (
                Socket clientSocket = serverSocket.accept();
                BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)
        ) {
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                out.println("Echo: " + inputLine);
            }
            System.out.println("Client disconnected.");
        } catch (IOException e) {
            println("Exception in connection with client: " + e.getMessage());
        }
    }
} catch (IOException e) {
    println("Could not listen on port " + PORT + ": " + e.getMessage());
}
```

- 하나의 클라이언트가 연결할 때는 문제가 없지만 다수의 클라이언트가 연결하는 경우에는 문제
- 처음 연결한 클라이언트가 연결을 종료하기 전까진 큐에 들어가 대기해야 하기 때문
- 다수의 요청을 처리할 수 없다

## 멀티 스레드 서버

- 요청이 들어올 때마다 별개의 스레드를 생성해서 요청 처리
- 다중 접속 처리 가능
- [[Spring MVC]] 의 모델

https://github.com/songkg7/network-study-code-sample/tree/multi-thread

```java
try (ServerSocket serverSocket = new ServerSocket(PORT)) {
    LOGGER.info("Server is running on port " + PORT);

    while (true) {
        Socket clientSocket = serverSocket.accept(); // 메인 스레드가 요청을 수락하면서 클라이언트 소켓 생성
        new Thread(new ClientHandler(clientSocket)).start(); // 워커 스레드에 위임
    }
} catch (IOException e) {
    LOGGER.severe("Could not listen on port " + PORT + ": " + e.getMessage());
}
```

```java
public class ClientHandler implements Runnable {
    // 생략...

    @Override
    public void run() {
        try (
                BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)
        ) {
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                out.println("Echo: " + inputLine); // Echo back the received message
            }
        } catch (IOException e) {
            LOGGER.severe("Error handling client: " + e.getMessage());
        } finally {
            try {
                clientSocket.close();
            } catch (IOException e) {
                LOGGER.severe("Failed to close client socket: " + e.getMessage());
            }
        }
    }
}
```

![](https://i.imgur.com/HwdAnxF.png)

![thread blocking i o](https://mark-kim.blog/static/b6c2670ce0509c3f3f241df696922319/d1b94/thread_blocking_i_o.png "thread blocking i o")

1. 메인 스레드는 listening 중인 서버 소켓을 사용하여 accept 함수를 호출해서 연결 요청을 수락
2. 이때 얻는 소켓을 별도의 워커 스레드를 생성하여 넘겨준다.
3. 워커 스레드에서 서비스 제공

연결이 하나 생성될 때마다 스레드를 생성해서 서비스를 제공하는 것

#### 장점

- 프로세스 복사 비용보다는 스레드 생성비용이 적다.
- 서로 공유하는 메모리가 있기 때문에 스레드간 정보 교환이 쉽다.

#### 단점

- 특정 스레드의 문제가 다른 스레드에 영향을 줄 수 있다.
- JVM 은 스레드 하나당 약 1MB 정도의 공간이 필요하다. 여전히 리소스가 많이 필요하다.
- 스레드풀을 사용하여 운영할 수 있지만, 여전히 풀보다 큰 요청을 동시에 처리할 수는 없다. = https://haril.dev/blog/2023/11/10/Spring-MVC-Traffic-Testing
- 멀티스레드로 다중 요청을 처리할 수 있게 되었고, 많은 스레드가 생성되어 서버의 리소스를 낭비하게 되는 경우를 막기 위해 스레드풀로 고정 개수의 스레드를 관리하게 되었지만, 스레드 하나가 블록될 때의 기회비용이 매우 커짐
    - 스레드 하나하나 열심히 굴려야하는 마당에, 블로킹되어 일하지 못하고 대기하는 것

## 멀티플렉싱

스레드가 블로킹되는 것은 서버 애플리케이션 입장에서는 굉장히 큰 오버헤드였습니다. 어떻게 해야 스레드가 블로킹되지 않게 하면서 많은 요청을 처리할 수 있을까요?

답은 멀티플렉싱에 있습니다. 멀티플렉싱은 적은 스레드로 많은 요청을 처리할 수 있게 하는 기술입니다. 멀티플렉싱에 자세히 살펴보기 전에 먼저 Java 의 I/O 에 대해 이해할 필요가 있습니다.

### Java NIO

[[Java NIO]] 는 기존 I/O API 를 대체하기 위해 도입된 API

- 기존 I/O 는 왜 느렸나?
- JVM 이 커넉 메모리 영역에 직접 접근할 수없었기 때문에, 커널 버퍼를 JVM 메모리에 복사해야하는 과정이 필요했고, 이 동안 블로킹되었다.
- NIO 에서는 **커널 메모리 영역에 직접 접근**할 수 있는 API 가 추가되었고, 이것이 ByteBuffer

#### Channel

서버에서 클라이언트와 데이터를 주고 받을 때 채널을 통해서 버퍼(ByteBuffer)를 이용해 읽고 씁니다.

- FileChannel: 파일에 데이터를 읽고 쓴다
- DatagramChannel: UDP 를 이용해 네트워크에서 데이터를 읽고 쓴다
- **SocketChannel**: [[TCP]] 를 이용해 네트워크에서 데이터를 읽고 쓴다.
- **ServerSocketChannel**: 클라이언트의 TCP 연결 요청을 수신(listening)할 수 있으며, SocketChannel 은 각 연결마다 생성된다.

#### Buffer

데이터를 읽고 쓰는데 사용하는 컴포넌트. 양방향으로 동작해야하기 때문에 `flip()` 이라는 메서드로 쓰기 모드와 읽기 모드를 전환합니다. 모든 데이터를 읽은 후에는 버퍼를 지우고 다시 쓸 준비를 해야 하며, 이 때 `clear()` 메서드를 호출해서 전체 버퍼를 지울 수 있습니다.

버퍼는 몇가지 특징을 가지고 있습니다.

- capacity: 생성할 때 크기를 지정해야하며, 변경할 수 없습니다.
- position: 다음에 읽거나 쓸 요소의 인덱스를 나타냅니다.
- limit: 버퍼 내에서 데이터를 읽거나 쓸 수 있는 첫 번째 제한 위치를 나타냅니다.
- mark: 위치를 한 번 표시하고 나중에 다시 그 위치로 되돌아갈 수 있게 해주는 기능입니다.

#### Selector

> 멀티플렉싱을 가능하게 하는 핵심 컴포넌트

![](https://vos.line-scdn.net/landpress-content-v2_1761/1672025602251.png?updatedAt=1672025604000)

![selector channel non blocking io](https://mark-kim.blog/static/0481f8c77c11b67a84bf2084d4fe599f/78d47/selector_channel_non_blocking_io.png "selector channel non blocking io")

- 여러 개의 채널에서 발생하는 이벤트를 모니터링할 수 있는 [[Selector]]
- 하나의 스레드로 여러 채널을 모니터링하는게 가능
- 내부적으로 SelectorProvider 에서 운영체제와 버전에 따라서 사용가능한 멀티플렉싱 기술을 선택해 사용
    - select, poll, epoll, kqueue..

##### 셀렉터 생성

```java
Selector selector = Selector.open();
```

##### 채널 등록

```java
ServerSocketChannel channel = ServerSocketChannel.open();
channel.bind(new InetSocketAddress("localhost", 8080));
channel.configureBlocking(false); // non-blocking mode
SelectionKey key = channel.register(selector, SelectionKey.OP_READ);
```

반드시 non-blocking 모드로 전환해야 합니다. 셀렉터에 채널을 등록할 때는 어떤 이벤트를 모니터링할 지 전달해줄 수 있는데, 이벤트에는 네 가지 종류가 있으며 SelectionKey 상수로 표시합니다.

- `OP_CONNECT`
- `OP_ACCEPT`
- `OP_READ`
- `OP_WRITE`

##### 셀렉터를 이용하여 채널 선택

셀렉터는 어떤 소켓이 준비가 완료되었는지 알기 위해서 select 를 호출합니다. select 는 데이터가 준비된 채널이 있다면 채널 목록을 반환해주고, 준비된 채널이 없다면 블로킹되게 됩니다.

```java
selector.select(); // blocking
```

재밌지 않나요? 논블로킹이라 해서 모든 내부 동작이 논블로킹인 것은 아니에요. 준비된 채널이 없는데 데이터를 읽으려한다면 정상적으로 동작할 수 있을까요? 이런 상황에서는 블로킹을 통해 데이터가 준비될 때까지 기다리는 동작이 오히려 자연스럽습니다.

읽을 수 있는 데이터가 존재할 때까지 블로킹된다면 멀티 스레드와 도대체 무슨 차이가 있는걸까요?

멀티 스레드 모델에서는 하나의 스레드가 하나의 요청만 처리할 수 있었지만, 멀티 플렉싱 모델에서는 하나의 스레드가 다수의 요청을 처리할 수 있다는 점이 다릅니다. **여러 요청 중 먼저 준비된 요청부터 스레드가 처리할 수 있는 메커니즘을 셀렉터를 통해 제공**하기 때문에, 스레드가 블로킹되는 시간을 멀티 스레드 모델에 비해 크게 줄일 수 있게 되는 것이지요.

물론 필요하다면 select 도 논블로킹으로 동작시킬 수 있습니다. `selectNow` 를 호출하면 됩니다.

```java
selector.selectNow(); // non-blocking
```

이후 `selectedKeys()` 메서드를 사용해 준비된 채널의 집합을 받아올 수 있습니다.

```java
Set<SelectionKey> keys = selector.selectedKeys();
```

### 정리

#### Blocking I/O

![](https://vos.line-scdn.net/landpress-content-v2_954/1663604281440.png?updatedAt=1663604282000)

- read 를 호출한 순간에는 데이터가 도착하지 않았을 수 있다.
- 네트워크는 그 특성상 응답이 언제 돌아올지 확신할 수 없다.
- 데이터가 네트워크를 통해 커널 공간에 도착해 사용자 공간의 프로세스 버퍼에 복사될 때까지 시스템콜이 반환되지 않는다.
- 스레드가 블로킹되어 다른 작업을 처리할 수 없다.

#### Non-blocking 기반의 I/O 멀티플렉싱 모델

![](https://vos.line-scdn.net/landpress-content-v2_954/1663604384989.png?updatedAt=1663604385000)

- **select 함수를 호출해서 여러 개의 소켓 중 읽을 준비가 된 소켓이 생길 때까지 대기 (blocking)**
- 준비가 된 소켓이 반환되면, read 함수를 호출
- 여러 소켓을 바라보다가 준비가 된 소켓부터 반환받아서 데이터를 처리하기 때문에, 블로킹되는 시간이 짧다.

## 멀티플렉싱 서버 구현해보기


```java
try (
        ServerSocketChannel channel = ServerSocketChannel.open();
        Selector selector = Selector.open()
) {
    channel.bind(new InetSocketAddress(PORT));
    channel.configureBlocking(false); // non-blocking mode
    LOGGER.info("Server started on port " + PORT);

    channel.register(selector, SelectionKey.OP_ACCEPT);
    ByteBuffer buffer = ByteBuffer.allocate(256);

    while (true) {
        selector.select(); // blocking

        // 선택된 키 셋 반복
        Iterator<SelectionKey> keys = selector.selectedKeys().iterator();
        while (keys.hasNext()) {
            SelectionKey key = keys.next();
            keys.remove();

            if (key.isAcceptable()) {
                // 새로운 클라이언트 연결 수락
                accept(channel, selector);
            } else if (key.isReadable()) {
                // 클라이언트로부터 데이터 읽기
                read(key, buffer);
            }
        }
    }
}
```

## 이벤트 루프(Event Loop)

이벤트 루프에 대한 설명을 살펴보면,

> 큐와 같은 자료구조에 이벤트가 발생하는지 무한루프를 돌며 지켜보다가, 이벤트를 처리할 수 있는 적절한 핸들러에 동작을 위임하여 처리하는 것

이라고 되어 있어요. 무한루프, 이벤트 처리... 뭔가 우리가 지금까지 확인해봤던 동작하고 비슷하지 않나요? 이벤트루프가 바로 멀티플렉싱을 바탕으로 구현된 개념이기 때문입니다.

```java
// Event Loop
while (true) {
    selector.select();
    Set<SelectionKey> selected = selector.selectedKeys();
    for (SelectionKey selectionKey : selected) {
        dispatch(selectionKey);
    }
    selected.clear();
}
```

main 스레드는 루프 안에서 이벤트가 발생할 때까지 대기했다가 적절한 핸들러에 이벤트를 위임합니다.

주의해야할 점은 main 스레드가 dispatch 메서드를 처리하는 중 블로킹되게 된다면, 전체 처리가 지연되게 됩니다. 이벤트 루프가 모든 과정에서 논블로킹을 유지해야하는 이유에요.

## 몇가지 질문

### 가상 스레드가 나온 시점에서, java i/o 여도 괜찮은거 아닌가?

결론부터 말하자면 그렇지 않다. 몇가지 큰 차이점이 있는데,

- java io 의 stream 은 단방향이며 중간에 멈추거나, 특정 지점부터 다시 읽기가 불가능하다. 반면 channel 의 buffer 는 position 을 통해 읽기를 잠시 중단하거나, 특정 지점부터 다시 읽는 등의 처리가 가능하다.

## Conclusion

지금까지 다중 접속 서버를 구현하기 위해 어떤 고민 과정이 있었는지 알아보았습니다.

- 단일 프로세스는 다중 접속을 처리할 수 없었고,
- 멀티 프로세스, 멀티 스레드는 리소스가 너무 많이 필요했으며,
    - 스레드풀은 리소스 문제는 해결했지만, 많은 요청을 동시에 처리하기는 여전히 부족했다.
- 멀티플렉싱을 사용하여 하나의 스레드로도 많은 요청을 처리할 수 있게 한다.
    - 어떤 요청이 처리할 준비가 되었는지 알아낼 수 있는 셀렉터가 핵심

## Reference

- https://engineering.linecorp.com/ko/blog/do-not-block-the-event-loop-part1#mcetoc_1gdcaies0o
- https://mark-kim.blog/understanding-non-blocking-io-and-nio/
