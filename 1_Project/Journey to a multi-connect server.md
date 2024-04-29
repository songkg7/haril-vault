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
categories: 
updated: 2024-04-29 12:17:14 +0900
---

네트워크 원리 챕터 6의 내용을 애플리케이션 레벨에서 좀 더 살펴보기

- 소켓 프로그래밍
    - 단일 프로세스
    - 멀티 프로세스
    - 멀티 스레드
    - 멀티 플렉싱
        - ~~논블로킹 폴링 모델~~(생략)
        - 논블로킹 이벤트 모델
        - 이벤트루프
- 보너스
    - Java I/O 는 왜 느린가?

## 소켓 프로그래밍

- 서버 입장에서 생각해보자
    - socket() 으로 소켓 생성
    - bind(), listen() 으로 연결 준비
    - accept() 로 연결 수락
    - 수락 후 바로 다른 소켓을 할당 = 다른 연결을 수락할 수 있어야 하기 때문

> [!question] 소켓을 fd 로 사용하는 이유는?
> 자신의 ip, port, 상대방의 ip, port 를 사용해도 소켓을 사용할 수 있지만 fd 를 사용하는 이유는 연결이 수락되기 전 소켓에는 아무런 정보가 없기 때문이고 또한 단순한 정수인 fd 보다 많은 데이터가 필요하기 때문

![](https://vos.line-scdn.net/landpress-content-v2_1761/1672029326745.png?updatedAt=1672029327000)

### 단일 프로세스 서버

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

실습

edf1a1b0faadb996c5a5fe1e866c3b89425ba6ca

### 멀티 프로세스 서버

- [[Operating system|OS]] 에서 프로세스는 서로 독립된 실행 객체로 존재하기 때문에, 안정적으로 동작이 가능
- 리소스를 많이 사용
- 자바에서는 멀티 프로세스를 다루기가 까다로우므로 생략

### 멀티스레드 서버

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

- 요청이 들어올 때마다 별개의 스레드를 생성해서 요청 처리
- 다중 접속 처리 가능
- [[Spring MVC]] 의 모델

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
- 스레드풀을 사용하여 운영할 수 있지만, 여전히 풀보다 큰 요청을 동시에 처리할 수는 없다. = https://songkg7.github.io/posts/Spring-MVC-Traffic-Testing/
- 멀티스레드로 다중 요청을 처리할 수 있게 되었고, 많은 스레드가 생성되어 서버의 리소스를 낭비하게 되는 경우를 막기 위해 스레드풀로 고정 개수의 스레드를 관리하게 되었지만, 스레드 하나가 블록될 때의 기회비용이 매우 커짐
    - 스레드 하나하나 열심히 굴려야하는 마당에, 블로킹되어 일하지 못하고 대기하는 것

### 멀티플렉싱

> 하나의 스레드로 여러 요청을 핸들링할 수 없을까?

- 왜 하나의 스레드가 하나의 요청밖에 핸들링할 수 없는걸까?
- 입출력 과정에서 스레드가 blocking 되기 때문
    - 입출력 함수가 블록되면 데이터가 준비될 때까지 무한정 블록
    - 네트워크로 데이터를 요청한다면, 데이터가 언제 올지 알 수 없는 상태이지만 데이터를 요청한 순간부터 블록된다.
- 싱글 스레드가 커널에 요청할 때 blocking 되지 않았다면, 커널이 작업을 완료한 뒤 유저 레벨에 어떻게 결과를 다시 돌려줄 수 있을까?
    - epoll 과 selector
- 데이터가 준비되면 그 때 입출력을 진행할 수 없을까? => epoll 시스템콜
- [[Spring WebFlux]] 의 모델
- 이게 무슨 의미인가?

## Blocking I/O

![](https://vos.line-scdn.net/landpress-content-v2_954/1663604281440.png?updatedAt=1663604282000)

- read 를 호출한 순간에는 데이터가 도착하지 않았을 수 있다.
- 데이터가 네트워크를 통해 커널 공간에 도착해 사용자 공간의 프로세스 버퍼에 복사될 때까지 시스템콜이 반환되지 않는다.

## I/O 멀티플렉싱 모델

![](https://vos.line-scdn.net/landpress-content-v2_954/1663604384989.png?updatedAt=1663604385000)

- **select 함수를 호출해서 여러 개의 소켓 중 읽을 준비가 된 소켓이 생길 때까지 대기 (blocking)**
- 준비가 된 소켓이 반환되면, read 함수를 호출
- 여러 소켓을 바라보다가 준비가 된 소켓부터 반환받아서 데이터를 처리하기 때문에, 블로킹되는 시간이 짧다.

## Java NIO

[[Java NIO]] 는 기존 I/O API 를 대체하기 위해 도입된 API

- 기존 I/O 는 왜 느렸나?
- JVM 이 커넉 메모리 영역에 직접 접근할 수없었기 때문에, 커널 버퍼를 JVM 메모리에 복사해야하는 과정이 필요했고, 이 동안 블로킹되었다.
- NIO 에서는 커널 메모리 영역에 직접 접근할 수 있는 API 가 추가되었고, 이것이 ByteBuffer

### Channel

서버에서 클라이언트와 데이터를 주고 받을 때 채널을 통해서 버퍼(ByteBuffer)를 이용해 읽고 씁니다.

- FileChannel: 파일에 데이터를 읽고 쓴다
- DatagramChannel: UDP 를 이용해 네트워크에서 데이터를 읽고 쓴다
- **SocketChannel**: [[TCP]] 를 이용해 네트워크에서 데이터를 읽고 쓴다.
- **ServerSocketChannel**: 클라이언트의 TCP 연결 요청을 수신(listening)할 수 있으며, SocketChannel 은 각 연결마다 생성된다.

### Buffer

데이터를 읽고 쓰는데 사용하는 컴포넌트. 양방향으로 동작해야하기 때문에 `flip()` 이라는 메서드로 쓰기 모드와 읽기 모드를 전환합니다. 모든 데이터를 읽은 후에는 버퍼를 지우고 다시 쓸 준비를 해야 하며, 이 때 `clear()` 메서드를 호출해서 전체 버퍼를 지울 수 있습니다.

### Selector

> 멀티플렉싱을 가능하게 하는 핵심 컴포넌트

![](https://vos.line-scdn.net/landpress-content-v2_1761/1672025602251.png?updatedAt=1672025604000)

![selector channel non blocking io](https://mark-kim.blog/static/0481f8c77c11b67a84bf2084d4fe599f/78d47/selector_channel_non_blocking_io.png "selector channel non blocking io")

- 여러 개의 채널에서 발생하는 이벤트를 모니터링할 수 있는 [[Selector]]
- 하나의 스레드로 여러 채널을 모니터링하는게 가능
- 내부적으로 SelectorProvider 에서 운영체제와 버전에 따라서 사용가능한 멀티플렉싱 기술을 선택해 사용
    - select, poll, epoll, kqueue..

#### 셀렉터 생성

```java
Selector selector = Selector.open();
```

#### 채널 등록

```java
ServerSocketChannel channel = ServerSocketChannel.open();
channel.bind(new InetSocketAddress("localhost", 8080));
channel.configureBlocking(false); // non-blocking mode
SelectionKey key = channel.register(selector, SelectionKey.OP_READ);
```

반드시 non-blocking 모드로 전환해야 합니다. 셀렉터에 채널을 등록할 때는 어떤 이벤트를 모니터링할 지 전달해줄 수 있는데, 이벤트에는 네 가지 종류가 있으며 SelectionKey 상수로 표시합니다.

- OP_CONNECT
- OP_ACCEPT
- OP_READ
- OP_WRITE

#### 셀렉터를 이용하여 채널 선택

어떤 소켓이 준비가 완료되었는지 알기 위해서 셀렉터는 블로킹 호출을 할 수 밖에 없습니다.

```java
selector.select();
```

`select()` 를 호출하면 셀렉터에 등록된 채널 중 하나 이상의 준비가 완료된 채널이 있을 때까지 blocking 됩니다. 이후 `selectedKeys()` 메서드를 사용해 준비된 채널의 집합을 받아올 수 있습니다.

```java
selector.selectedKeys();
```

## 멀티플렉싱 구현

지금까지 다중 접속 서버를 구현하기 위해 어떤 고민 과정이 있었는지 알아보았다.

- 단일 프로세스는 다중 접속을 처리할 수 없었고,
- 멀티 프로세스, 멀티 스레드는 리소스가 너무 많이 필요했으며,
- 스레드풀은 리소스 문제는 해결했지만, 많은 요청을 동시에 처리하기는 여전히 부족했다.

### Polling

### Event Loop

## Reference

- https://engineering.linecorp.com/ko/blog/do-not-block-the-event-loop-part1#mcetoc_1gdcaies0o
- https://mark-kim.blog/understanding-non-blocking-io-and-nio/
