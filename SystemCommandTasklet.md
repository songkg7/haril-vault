---
title: "SystemCommandTasklet"
date: 2022-08-17 10:22:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: 
tags: [batch, step, tasklet]
categories: Spring
---

시스템 명령을 실행해야할 때 사용하며 해당 명령은 비동기로 실행된다.

```java
    @Bean
    public SystemCommandTasklet systemCommandTasklet()
    {
        SystemCommandTasklet systemCommandTasklet = new SystemCommandTasklet();

        systemCommandTasklet.setCommand("rm -rf /tmp.txt");
        systemCommandTasklet.setTimeout(5000);
        // 시스템 명령이 비정상 종료될때 스레드를 강제 종료할지 여부 설정
        systemCommandTasklet.setInterruptOnCancel(true);

        return systemCommandTasklet;
    }
```

```java
    @Bean
    public SystemCommandTasklet systemCommandTasklet()
    {
        SystemCommandTasklet systemCommandTasklet = new SystemCommandTasklet();

        systemCommandTasklet.setCommand("rm -rf /tmp.txt");
        systemCommandTasklet.setTimeout(5000);
        systemCommandTasklet.setInterruptOnCancel(true);

	// working directory 설정
        systemCommandTasklet.setWorkingDirectory("/Users/we/spring-batch");

	// ExitCode 설정
        systemCommandTasklet.setSystemProcessExitCodeMapper(touchCodeMapper());
        systemCommandTasklet.setTerminationCheckInterval(5000);
        // Lock이 걸리지 않도록 비동기 executor 설정
        systemCommandTasklet.setTaskExecutor(new SimpleAsyncTaskExecutor());
        // 환경 변수 설정
        systemCommandTasklet.setEnvironmentParams(new String[] {
            "JAVA_HOME=/java",
            "BATCH_HOME=/Users/batch"
        });

        return systemCommandTasklet;
    }

    @Bean
    public SimpleSystemProcessExitCodeMapper touchCodeMapper()
    {	
    	// 종료 상태에 따라 ExitStatus.COMPLETED, ExitStatus.FAILED 리턴
        return new SimpleSystemProcessExitCodeMapper();
    }
```
