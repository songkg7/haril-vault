---
title: Java Lambda 의 동작 과정
date: 2023-11-01T13:50:00
aliases: 
tags:
  - java
  - bytecode
  - compile
categories: 
updated: 2025-01-07T00:35
---

```java
public class SimpleLambda {
    public static void main(String[] args) {
        // Lambda expression
        Runnable lambda = () -> System.out.println("Hello Lambda");
        lambda.run();

        // Anonymous class
        Runnable anonymous = new Runnable() {
            @Override
            public void run() {
            System.out.println("Hello Anonymous");
            }
        };
        anonymous.run();
    }
}
```

```bash
javap -c -p SimpleLambda
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
      12: new           #15                 // class SimpleLambda$1
      15: dup
      16: invokespecial #17                 // Method SimpleLambda$1."<init>":()V
      19: astore_2
      20: aload_2
      21: invokeinterface #11,  1           // InterfaceMethod java/lang/Runnable.run:()V
      26: return

  private static void lambda$main$0();
    Code:
       0: getstatic     #18                 // Field java/lang/System.out:Ljava/io/PrintStream;
       3: ldc           #24                 // String Hello Lambda
       5: invokevirtual #26                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
       8: return
}
```

invokedynamic 이라는 명세로 변환된 것을 확인할 수 있다. 또한 익명 클래스는 private static 으로 변환되는 것을 볼 수 있다.

### During Compile Time

람다식은 컴파일 타임에는 객체를 생성하지 않는다. 다만 런타임에 JVM 이 객체를 생성할 수 있도록 람다식을 invokedynamic 으로 변환하여 그 '레시피'만을 생성해둔다. invokedynamic 은 다음과 같은 3가지 정보를 필요로 한다.

- bootstrap method: 동적으로 객체를 생성하는 메소드
- static arguments
- dynamic arguments

### 람다식의 효율성

람다식의 효율성은 invokedynamic 에 의한 동적 객체 생성에 기인한다.

```java
public void loopLambda() {
    myStream.forEach(item -> item.doSomething());
}

public void loopAnonymous() {
    myStream.forEach(new Consumer<Item> () {
            @Override
            public void accept(Item item) {
                item.doSomething();
            }
        );
    }
}
```

첫 번째 메소드는 람다식으로 구현한 stream forEach 문이고, 두 번째 메소드는 익명 클래스로 구현한 stream forEach 문이다. 익명 클래스로 구현한 forEach 문은 매 iteration 마다 익명 클래스를 정의하고, 그 객체를 생성한다.

하지만 람다식으로 구현된 forEach 문은 단 한 개의 클래스만을 생성한다. private static 으로 람다의 바디가 생성되어 있기 때문에 몇 번이고 재활용할 수 있다.

## Reference

- https://dreamchaser3.tistory.com/5
- https://d2.naver.com/helloworld/4911107
