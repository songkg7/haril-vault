---
title: JVM Compressed OOPS
date: 2023-10-12 17:34:00 +0900
aliases: 
tags:
  - jvm
  - memory
  - heap
categories: 
updated: 2023-10-12 18:13:34 +0900
---

JVM 기반의 애플리케이션은 STW 를 고민하게 된다. heap 을 많이 잡는다면 성능이 잘 나올 것 같은 느낌이 있지만 그렇지 않다.

full [[Garbage Collection|GC]] 가 돌게 되면 애플리케이션이 먹통이 된다. 독립적으로 구성된 애플리케이션이라면 큰 문제가 안될 수도 있다.

heap 을 무작정 많이 잡으면 GC 의 실행속도에도 악영향을 주므로 STW 가 지나치게 길어질 수 있다. 왜 하필 ~32GB 로 잡으라고 가이드하는 것일까?

## OOPS (Ordinary Object Pointer)

Java 에는 포인터가 없다. JVM 은 오브젝트의 레퍼런스를 관리하기위해 OOPS 라고 불리는 자료구조를 가진다.

[[Object Memory Layout]]

- 32bit 시스템(ILP32)에서 OOPS 는 최대 힙을 4GB($2^32$)까지 사용할 수 있다.
- 64bit 시스템(LP64)에서 OOPS 는 최대 힙을 18.5EB($2^64$)까지 사용할 수 있다.

다만 64bit 포인터로 공간을 관리하는 것은 매우 비효율적이다.

## Compressed OOPS

Java 에서는 트리키한 방법을 사용했다.

기존에는 OOPS 가 4GB 만큼 메모리 영역을 직접 관리했다. Compressed OOPS 에서는 OOPS 가 object 를 referencing 하는 대신 object 의 offset 을 referencing 한다.

3bit 만큼을 더 사용할 수 있으므로 64bit 레퍼런스가 아닐 때에도 $2^32$ * $2^3$ = 32GB 만큼의 힙을 사용할 수 있다.

다만, 32GB 를 넘게 되면 기존의 OOPS 를 사용하게 된다.

```
java -Xmx31G -XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal -version 2>/dev/null | grep 'UseCompressedOops'  
     bool UseCompressedOops                        = true

                                 {lp64_product} {ergonomic}
```

```
java -Xmx32G -XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal -version 2>/dev/null | grep 'UseCompressedOops'  
     bool UseCompressedOops                        = false

                                {lp64_product} {default}
```

## Zero-based Compressed OOPS

JVM 이 OS 에 virtual address 가 0 부터 시작하는 java heap 용 메모리를 요청하여 Compressed OOP 를 사용하는 경우이다. java heap 의 base address 를 더하는 연산을 할 필요가 없기 때문에 성능에 좀 더 이점이 있다.

## Reference

- https://xephysis.tistory.com/6
- https://velog.io/@mlaw12/%EC%A0%81%EC%A0%88%ED%95%9C-Heap-Size%EC%97%90-%EB%8C%80%ED%95%B4