---
title: "MethodInvokingTaskletAdapter"
date: 2022-08-17 10:20:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: 
tags: [batch, step, tasklet]
categories: Spring
---

`MethodInvokingTaskletAdapter` 를 사용하면 기존의 다른 클래스의 메서드를 Step 내의 [[Tasklet]]으로 사용 가능하다.

```java
    @StepScope
    @Bean
    public MethodInvokingTaskletAdapter methodInvokingTasklet(@Value("#{jobParameters['message']}") String message)
    {
        MethodInvokingTaskletAdapter methodInvokingTaskletAdapter = new MethodInvokingTaskletAdapter();

        methodInvokingTaskletAdapter.setTargetObject(service());
        methodInvokingTaskletAdapter.setTargetMethod("serviceMethod");
        methodInvokingTaskletAdapter.setArguments(new String[] {message});

        return methodInvokingTaskletAdapter;
    }

    // 내가 생성한 클래스(일반 POJO)
    @Bean
    public CustomService service()
    {
    	// 이 때 CustomService 클래스의 serviceMethod가 message 파라미터를 이용하지 않으면 에러 발생
        return new CustomService();
    }
```
