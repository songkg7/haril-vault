---
title: AsynchronousFileChannel
date: 2024-02-13 16:53:00 +0900
aliases: 
tags:
  - java
  - asnyc
  - file
  - channel
categories: 
updated: 2024-02-13 16:53:43 +0900
---

java.io 의 InputStream OutputStream 은 단방향이며, 파일의 경우 블로킹되는 단점도 있다. 만약 사이즈가 큰 파일의 경우는 블로킹이 큰 단점이 될 수 있기에 java.nio 부터는 비동기 I/O 를 지원하는 `AsynchronousChannel` 을 사용할 수 있다. 이번 글에서는 그 중에 파일과 관련된 Channel 인 `AsnycronousFileChannel` 의 간략한 사용법을 적어본다.

## 쓰기 구현

```java
public class ChannelWriteExample {

    // logger
    private static final Logger logger = Logger.getLogger(ChannelWriteExample.class.getName());

    public static void main(String[] args) {
        try {
            AsynchronousFileChannel fileChannel = AsynchronousFileChannel.open(
                    Paths.get("./output.txt"),
                    StandardOpenOption.WRITE, StandardOpenOption.CREATE);

            ByteBuffer buffer = ByteBuffer.allocate(1024);
            buffer.put("Sample text to write asynchronously.".getBytes());
            buffer.flip();
            long position = 0; // Position in the file to start the write operation

            fileChannel.write(buffer, position, buffer, new CompletionHandler<>() {
                @Override
                public void completed(Integer result, ByteBuffer attachment) {
                    logger.info("Write completed, " + result + " bytes written.");
                    try {
                        fileChannel.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void failed(Throwable exc, ByteBuffer attachment) {
                    logger.severe("Write failed.");
                    exc.printStackTrace();
                    try {
                        fileChannel.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        // wait for the asynchronous write to complete
        try {
            logger.info("Waiting for the asynchronous write to complete...");
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

예제에서는 파일에 미처 데이터를 쓰기 전에 코드가 종료되어 버리는 상황을 막기 위해 `Thread.sleep` 코드가 추가되어 있다.

## 주의점

[[try-with-resource]] 의 사용은 주의해야 한다. 파일 처리가 끝나기 전에 자원이 해제되면서 에러가 발생할 수 있다.

![](https://i.imgur.com/4qhzMZx.png)

너무 큰 파일을 비동기로 읽을 경우는 OutOfMemoryError 가 발생할 수 있으니 적당한 크기의 `ByteBuffer` 로 쪼개서 반복 처리해야할 수 있다.
