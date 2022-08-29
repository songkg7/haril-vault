---
title: "Tasklet"
date: 2022-08-17 10:15:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: 
tags: [step, batch, tasklet]
categories: Spring
---

## Tasklet

`Tasklet` 기반 Step 을 만드는데는 두 가지 방법이 있다.

### 1. MethodInvokingTaskletAdapter

- 사용자가 작성한 코드를 Tasklet step 처럼 실행하는 방식
- 일반 POJO 를 `Step` 으로 활용 가능

### 2. Tasklet 인터페이스 구현

일반적인 방식이다. 이 때 Tasklet 인터페이스는 함수형 인터페이스이므로 람다식으로 구현할 수 있다.

Tasklet 구현체의 처리가 완료되면 `RepeatStatus` 객체를 반환해야 한다.

```java
public enum RepeatStatus {
	CONTINUABLE(true), // 어떤 조건이 충족될 때까지 반복 실행
	FINISHED(false); // 성공 여부에 관계없이 tasklet 처리 완료 후 다음 처리
}
```

### 그 외 Tasklet 구현체

- [[CallableTaskletAdapter]]
- [[MethodInvokingTaskletAdapter]]
- [[SystemCommandTasklet]]

# Reference

[step](https://velog.io/@s2moon98/Spring-Batch%EC%97%90%EC%84%9C-Job%EA%B3%BC-Step)
