---
title: Java NIO
date: 2024-03-21 17:44:00 +0900
aliases: 
tags:
  - java
  - nio
  - non-blocking
categories: 
updated: 2024-05-14 14:33:13 +0900
---

## nio 란?

java에서 비동기 입출력을 지원하기 위한 라이브러리

### Channel

Channel은 입출력이 가능한 엔티티를 의미한다. 채널은 스트림과 달리 양방향으로 데이터를 전송할 수 있다.

| Channel                         | Description                  |
| ------------------------------- | ---------------------------- |
| FileChannel                     | 파일 입출력                       |
| DatagramChannel                 | UDP 방식의 네트워크 입출력             |
| SocketChannel                   | TCP 방식의 네트워크 입출력             |
| ServerSocketChannel             | TCP 방식에서 서버에 대한 연결을 수락하는 채널  |
| AsynchronousServerSocketChannel | 비동기화 버전의 ServerSocketChannel |
| AsynchronousFileChannel         | 비동기화 버전의 FileChannel         |

### Buffer

java nio에서는 데이터가 채널로부터 읽어들여서 이동할 때, 중간 저장소(buffer)를 사용한다. buffer 객체는 데이터를 쓰고, 읽는 것을 돕는다. buffer 객체는 일반적으로 고정된 크기로 만들어진다.

#### Buffer 클래스

- ByteBuffer
- CharBuffer
- DoubleBuffer
- FloatBuffer
- IntBuffer
- LongBuffer
- ShortBuffer

각각의 class에 allocate() 메서드가 있어서 인스턴스를 생성할 수 있다.

인스턴스 생성 후 put 메서드로 값을 입력하고, flip 메서드로 limit와 position 값 설정 후 get 메서드로 값을 추출한다.

```java
ByteBuffer buf = ByteBuffer.allocate(1024);
buf.put("some string".getBytes());
buf.flip();
byte[] b = new byte[10];
buf.get(b, 0, 10); // some string
```

### Charset

charset은 문자들의 인코딩 방식을 의미한다. charset 객체를 이용해서 문자열을 byte buffer로 변환하거나 반대로 변환할 수 있다.

```java
Charset charset = Charset.forName("UTF-8");

String str = "안녕하세요";
ByteBuffer buf = charset.encode(str);

while(buf.hasRemaining()) {
  System.out.println(buf.get());
}
// -19
// -107
// -100
// -26
// -116
// -91

buf.flip();
System.out.println(charset.decode(buf)); // 안녕하세요
```

## Seletor

#selector

Selector는 IO 멀티플렉싱을 위한 클래스로, 다수의 채널들을 감시하고 있다가 채널에 발생한 이벤트를 감지하여 해당하는 처리를 해주는 역할을 한다.

서버에서 클라이언트와 연결된 소켓의 처리를 위해서는 별도의 스레드를 생성하는 것이 일반적이지만, **selector 패턴을 사용하면 단일 스레드에서 여러 개의 채널을 처리**할 수 있다.

### Selector 동작과정

1. 셀렉터 객체 생성
2. select 메소드 실행 (**블로킹**)
3. select 메소드로 반환된 결과 중 관심 이벤트가 발생한 채널만 추출
4. 추출된 채널에서 발생한 이벤트를 처리

다음과 같은 순서로 진행되며, 이벤트가 발생하는 순간까지 select 메소드는 블로킹 상태가 된다.

### Selector 클래스 메서드

| Method                 | Description              |
| ---------------------- | ------------------------ |
| open()                 | Selector 생성              |
| isOpen()               | Selector 객체의 오픈 여부 확인    |
| close()                | Selector 종료              |
| select()               | 이벤트 발생 시까지 블로킹           |
| select(long timeout)   | 타임아웃 설정 후 이벤트 발생 시까지 블로킹 |
| selectNow()            | 이벤트 발생 시까지 블로킹하지 않음      |
| wakeup()               | select 메서드를 실행중인 스레드를 깨움 |
| selectedKeys()         | 이벤트 발생한 채널 반환            |
| keys()                 | 셀렉터에 등록된 채널의 목록을 반환      |
| selectedKeys().clear() | 이벤트 발생한 채널 목록 삭제         |
| keys().clear()         | 모든 등록된 채널 목록 삭제          |
| keys().remove(key)     | key에 해당하는 채널 목록 삭제       |
| keys().iterator()      | Iterator 객체 생성           |

### SelectionKey 클래스

Selector 클래스는 관심 이벤트가 발생한 채널을 추출하면, 이 추출된 채널은 SelectionKey 객체로 반환된다.

SelectionKey 객체는 register 메서드를 통해 selector에 등록할 때, 생성되며, 각각의 상태를 저장하고 있으며 selector로부터 관심 이벤트가 발생하면 하나의 SelectionKey 객체를 반환한다.

SelectionKey 객체는 다음과 같은 상태를 가진다.

- OP_CONNECT
- OP_ACCEPT
- OP_READ
- OP_WRITE

```java
Set<SelectionKey> set = selector.selectedKeys();
Iterator<SelectionKey> iter = set.iterator();

while(iter.hasNext()) {
  SelectionKey key = iter.next();
  if(key.isConnectable()) {
    // 연결 이벤트 처리
  } else if(key.isAcceptable()) {
    // 연결 수락 이벤트 처리
  } else if(key.isReadable()) {
    // 읽기 이벤트 처리
  } else if(key.isWritable()) {
    // 쓰기 이벤트 처리
  }
}
```

### select 메서드

select 메서드는 동작하는 방식에 따라 다음과 같이 분류된다.

| Method               | Description                                               |
| -------------------- | --------------------------------------------------------- |
| select()             | 블로킹 형태로 동작하며, 관심 이벤트가 발생할 때까지 대기한다.                       |
| select(long timeout) | 타임아웃 값을 설정하면 설정된 시간동안 블로킹 형태로 동작하며, 설정된 값이 지나면 블로킹을 해제한다. |
| selectNow()          | 즉시 반환하며, 관심 이벤트가 발생하지 않으면 null을 반환한다.                     |

해당 메서드들은 selector의 관심 이벤트가 발생한 채널이 없을 경우에는 계속해서 블로킹 상태를 유지하기 때문에, wakeup 메서드를 사용해서 깨우는 방식으로 해야한다.

### wakeup 메서드

selector의 select 메서드를 호출하면, 블로킹 상태가 되고, wakeup 메서드를 호출해야만 블로킹 상태에서 빠져나올 수 있으며, wakeup 메서드를 호출하면 selector의 select 메서드가 실행되는 스레드가 깨어난다.

```java
Selector selector = Selector.open();
SocketChannel sc = SocketChannel.open();
sc.connect(new InetSocketAddress("localhost", 5001));
sc.configureBlocking(false);
sc.register(selector, SelectionKey.OP_READ);

ByteBuffer buffer = ByteBuffer.allocate(1024);

while(true) {
  int n = selector.select();
  if(n == 0) continue;
  
  Set<SelectionKey> set = selector.selectedKeys();
  Iterator<SelectionKey> iter = set.iterator();
  
  while(iter.hasNext()) {
    SelectionKey key = iter.next();
    
    if(key.isReadable()) {
      SocketChannel channel = (SocketChannel) key.channel();
      buffer.clear();
      int readByte = channel.read(buffer);
      buffer.flip();
      
      Charset charset = Charset.forName("UTF-8");
      String data = charset.decode(buffer).toString();
      
      System.out.println("수신 데이터 : " + data);
    }
    iter.remove(); // 처리된 이벤트 제거
  }
}
```

## Reference

- https://dev-coco.tistory.com/44
- https://e-una.tistory.com/76