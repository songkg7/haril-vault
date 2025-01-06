---
title: CallableTaskletAdapter
date: 2022-08-17T10:10:00
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: 
tags:
  - batch
  - step
  - tasklet
categories: Spring
updated: 2025-01-07T00:35
---

Tasklet 이 Step 을 실행하는 스레드와 별개로 새로운 스레드에서 실행된다. 하지만 병렬로 실행되지는 않는다. `Callable` 객체가 `RepeatStatus` 를 반환하기 전까지는 해당 Step 이 완료된 것으로 간주하지 않는다.

```java
	@Bean
    public Callable<RepeatStatus> callableObject()
    {
        return () -> {
            System.out.println("This was executed in another thread");
            
	    // Callable 객체가 RepeatStatus를 리턴해야 tasklet 완료로 간주
            return RepeatStatus.FINISHED;
        };
    }

    @Bean
    public CallableTaskletAdapter tasklet()
    {
        CallableTaskletAdapter callableTaskletAdapter = new CallableTaskletAdapter();

        callableTaskletAdapter.setCallable(callableObject());

        return callableTaskletAdapter;
    }
```

