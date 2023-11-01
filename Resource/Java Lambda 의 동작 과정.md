---
title: Java Lambda 의 동작 과정
date: 2023-11-01 13:50:00 +0900
aliases: 
tags: 
categories: 
updated: 2023-11-01 13:50:30 +0900
---

```java
public class SimpleLambda {
    public static void main(String[] args) {
        // Lambda expression
        Runnable lambda = () -> System.out.println("Hello World");
        lambda.run();
    }
}
```

```bash
javap -c SimpleLambda
```

```
Compiled from "SimpleLambda.java"
public class SimpleLambda {
  public SimpleLambda();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: invokedynamic #7,  0              // InvokeDynamic #0:run:()Ljava/lang/Runnable;
       5: astore_1
       6: aload_1
       7: invokeinterface #11,  1           // InterfaceMethod java/lang/Runnable.run:()V
      12: return
}
```

invokedynamic 이라는 명세로 변환된 것을 확인할 수 있다.

