---
title: "SynchronizeItemReader"
date: 2022-08-24 20:19:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-24
aliases: 
tags: [spring, batch, reader, synchronize, thread-safe]
categories: Spring
---

## Overview

Memory 에 저장되어 있는 item 들을 `reader` 에서 사용하기 위해서는 `ListItemReader` 를 사용할 수 있다.

```java
package org.springframework.batch.item.support;  
  
import java.util.LinkedList;  
import java.util.List;  
  
import org.springframework.aop.support.AopUtils;  
import org.springframework.batch.item.ItemReader;  
import org.springframework.lang.Nullable;  
  
/**  
 * An {@link ItemReader} that pulls data from a list. Useful for testing.  
 * @author Dave Syer  
 * @author jojoldu  
 * */
public class ListItemReader<T> implements ItemReader<T> {  
  
    private List<T> list;  
  
    public ListItemReader(List<T> list) {
	    if (AopUtils.isAopProxy(list)) {  
	        this.list = list;  
	    } else {  
	        this.list = new LinkedList<>(list);  
	    }
	} 

    @Nullable  
    @Override
	public T read() {
        if (!list.isEmpty()) {  
            return list.remove(0);  
        }
        return null;  
    }  
}
```

하지만 `ListItemReader` 를 많은 양의 데이터 처리에 사용하기엔 부적합한데, thread-safe 하지 않기 때문이다.

실제로 multi-thread 에서도 안전하게 사용가능한 `itemReader` 를 만들어보자.

## Example

```java
public class SynchronizedItemReader<T> implements ItemReader<T> {  
  
    private final Queue<T> queue;  
  
    public SynchronizedItemReader(Collection<T> collection) {  
        this.queue = new ConcurrentLinkedQueue<>(collection);  
    }  

    @Nullable  
    @Override    
    public T read() {  
        return queue.poll();  
    }
}
```

`SynchronizedItemReader` 의 특징은 다음과 같다.

- [[Spring batch]]의 `SynchronizedItemStreamReader` 와는 달리 delegate 하지 않고 `collection` 을 복사하여 동작한다.
- `ConcurrentLinkedQueue` 를 사용하여 thread-safe 하게 성능을 최적화한다.
- `Queue.poll()` 을 사용하여 `read()` 를 처리한다. `poll()` 은 `Queue` 가 비면 null 을 반환하기 때문에 로직을 단순화할 수 있다.
	- `ListItemReader`의 `read()` method 는 `List.remove()` 를 사용하기 때문에 `OutOfRangeException` 을 방지하기 위해서 비어있는지 체크해야했다.

## Test

멀티쓰레드 테스트 구현하기

## Links

- [[Spring batch]]
