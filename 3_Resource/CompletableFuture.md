---
title: CompletableFuture
date: 2024-03-21 12:38:00 +0900
aliases: 
tags:
  - java
  - nio
  - async
categories: 
updated: 2024-03-21 17:43:25 +0900
---

## CompletableFuture 란?

CompletableFuture는 비동기 프로그래밍을 쉽게 구현할 수 있도록 자바8에서 추가된 라이브러리입니다. CompletableFuture의 핵심은 Future 패턴과 콜백 패턴을 결합하여 작성된 비동기 코드를 동기적으로 작성하는 것입니다. 이를 통해 코드의 가독성을 높이고, 에러 처리 등을 보다 쉽게 할 수 있습니다.

CompletableFuture는 ExcutorService와 ForkJoinPool에서 실행되며, 비동기 작업의 결과를 담는 객체입니다. CompletableFuture는 두 가지 상태, 완료(completed)와 미완료(incomplete), 그리고 세 가지 종류의 결과, 정상값(value), 예외(exception), 아무 값도 없음(nothing)을 가질 수 있습니다.

## CompletableFuture 의 장점

1. 메서드 체이닝을 통한 간결한 코드 구현 - thenApply(), thenAccept(), thenRun() 등 다양한 메서드를 사용하여 간결하고 읽기 쉬운 비동기 코드를 작성할 수 있습니다.
2. 콜백 함수에 대한 에러 처리 - 예외 발생 시 exceptionally() 메서드를 사용하여 에러를 처리할 수 있습니다.
3. 스레드 관리 - ExecutorService나 ForkJoinPool에서 실행되므로 스레드 관리가 용이합니다.
4. 완료 여부 확인 - isDone() 메서드를 통해 작업이 완료되었는지 확인할 수 있습니다.
5. 취소할 수 있는 작업 - cancel() 메서드를 사용하여 작업을 취소할 수 있습니다.
6. 둘 이상의 작업 조합 - thenCompose(), thenCombine() 등의 메서드를 사용하여 둘 이상의 작업을 조합할 수 있습니다.

## CompletableFuture 의 단점

1. 코드 복잡성 - 다른 비동기 라이브러리보다 코드가 복잡하고 난해할 수 있습니다.
2. 과도한 스레드 생성 - ExecutorService나 ForkJoinPool을 사용하기 때문에 스레드 생성이 과도해질 수 있습니다.
3. 콜백 지옥 가능성 - 메서드 체이닝을 남용하면 코드가 복잡해질 가능성이 있습니다.

## Example

다음 예제는 CompletableFuture를 사용하여 비동기 작업을 수행하는 간단한 예제입니다.

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
	return "Hello, world!";
}).thenApply(s -> s + " Welcome to java world");
 
System.out.println(future.get()); // Hello, world! Welcome to java world
```

CompletableFuture의 thenApply() 메서드를 사용하여 supplyAsync() 메서드가 반환하는 Future 객체의 처리 결과를 가지고 추가적인 작업을 할 수 있습니다. 이때 thenApply() 메서드는 Function<T, R> 타입의 콜백 함수를 인자로 받습니다.

### 취소가 가능한 CompletableFuture

CompletableFuture의 경우 cancel() 메서드를 통해 작업을 취소할 수 있습니다. 이때 cancel() 메서드는 boolean 타입의 파라미터를 받으며, true로 설정하면 해당 작업이 현재 진행 중인 스레드에서 계속 진행됩니다. 그러나 false로 설정하면 해당 작업은 무시되고 완료 처리가 됩니다.

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
	try {
		Thread.sleep(1000);
	} catch (InterruptedException e) {
	}
	return "Hello";
});
 
future.cancel(false); // 취소 시도
 
System.out.println(future.get()); // Hello
```

### CompletableFuture 에러 처리

exceptionally() 메서드를 사용하면 예외 발생 시에 공통적으로 처리할 수 있는 로직을 구현할 수 있습니다.

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
	return "Hello, world!";
}).thenApply(s -> {
	throw new NullPointerException();
}).exceptionally(e -> "error: " + e.getMessage());
 
System.out.println(future.get()); // error: java.lang.NullPointerException
```

exceptionally() 메서드는 Function<T, R> 타입의 콜백 함수를 인자로 받으며, 예외가 발생했을 때 실행됩니다. 이때 예외가 발생하면 exceptionally() 메서드 내의 콜백 함수를 실행하고 정상적으로 작업이 완료되면 thenApply() 메서드 내의 콜백 함수를 실행합니다.

### CompletableFuture 의 thenCompose() 와 thenCombine()

thenCompose() 메서드는 두 개의 CompletableFuture를 조합하여 순차적으로 작업을 수행할 수 있도록 합니다. thenCombine() 메서드는 두 개의 CompletableFuture가 모두 완료되었을 때 각각의 값을 조합하는 방식으로 작업을 수행합니다.

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
	return "Hello";
});
 
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
	return "world";
});
 
CompletableFuture<String> result = future1.thenCompose(s -> future2.thenApply(v -> s + ", "+ v));
 
System.out.println(result.get()); // Hello, world
```

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
	return "Hello";
});
 
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
	return "world";
});
 
CompletableFuture<String> result = future1.thenCombine(future2, (s1, s2) -> s1 + ", " + s2);
 
System.out.println(result.get()); // Hello, world
```

## CompletableFuture 는 Network I/O 를 blocking 할까?

CompletableFuture는 ExcutorService와 ForkJoinPool에서 실행되며, 이 두 가지 모두 I/O 작업을 위해 다수의 스레드를 사용하므로 Network I/O가 blocking될 수 있습니다. 따라서 Network I/O를 비동기적으로 처리하기 위해서는 별도의 Non-blocking I/O 라이브러리를 사용하는 것이 좋습니다.

### Testing

[[Awaitility]] 사용

## Reference

- https://www.baeldung.com/java-completablefuture
* [CompletableFuture API](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html)
* [Java 8 CompletableFuture Tutorial](https://www.baeldung.com/java-completablefuture)
* [Java 8 CompletableFuture Tutorial: Developing Asynchronous Applications](https://www.youtube.com/watch?v=5i0y3UqZnhw)
