---
title: Cyclic barrier
date: 2024-02-25T22:37:00
aliases: 
tags:
  - synchronize
categories: 
updated: 2025-01-07T00:35
---

## CyclicBarrier 란?

CyclicBarrier는 자바의 동시성 프로그래밍을 위한 클래스로, 여러 스레드가 특정 지점에서 기다리도록 하는데 사용된다.

즉, CyclicBarrier를 설정한 수만큼의 스레드가 해당 지점에 도달할 때까지 모든 스레드가 대기하게 된다. 이 때, 대기 중인 스레드들은 모두 block 상태가 된다.

모든 스레드가 barrier point에 도달하면, 모든 스레드가 다시 실행 상태로 전환된다. 이런 특성 때문에 동기화 작업에서 유용하게 사용된다.

CyclicBarrier의 이름에서 알 수 있듯이, 이 barrier는 재사용 가능하다. 한 번 barrier point를 통과한 후에는 다음 번 대기를 위해 다시 초기화되고 재사용될 수 있다.

## Example

```java
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.BrokenBarrierException;

class WorkerThread implements Runnable {

    private CyclicBarrier barrier;

    public WorkerThread(CyclicBarrier barrier) {
        this.barrier = barrier;
    }

    @Override
    public void run() {
        try {
            System.out.println(Thread.currentThread().getName() + " is waiting on barrier");
            barrier.await();
            System.out.println(Thread.currentThread().getName() + " has crossed the barrier");
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        } catch (BrokenBarrierException ex) {
            ex.printStackTrace();
        }
    }
}

public class CyclicBarrierExample {

    public static void main(String[] args) {

        final CyclicBarrier cb = new CyclicBarrier(3, new Runnable(){
            @Override
            public void run(){
                //This task will be executed once all thread reaches barrier
                System.out.println("All parties are arrived at barrier, lets play");
            }
        });

        Thread t1 = new Thread(new WorkerThread(cb), "Worker 1");
        Thread t2 = new Thread(new WorkerThread(cb), "Worker 2");
        Thread t3 = new Thread(new WorkerThread(cb), "Worker 3");

        //starting all threads
        t1.start();
        t2.start();
        t3.start();

    }

}
```

위의 예제에서는 3개의 스레드가 동시에 작업을 수행하면서 일정 지점에서 서로 기다리게 됩니다. 이 때 사용되는 것이 CyclicBarrier입니다.

각 스레드는 작업을 수행한 후에는 `barrier.await()`를 호출하여 다른 스레드들이 모두 도달할 때까지 대기하게 됩니다.

모든 스레드가 barrier point에 도달하면, CyclicBarrier에 설정된 Runnable의 run 메소드가 호출되며, 모든 스레드는 barrier를 통과하고 다음 작업을 수행합니다.

이렇게 CyclicBarrier를 사용하면 여러 스레드가 동시에 같은 지점에서 기다리도록 하여 동기화 문제를 해결할 수 있습니다.
