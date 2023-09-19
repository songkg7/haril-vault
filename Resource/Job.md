---
title: Job
date: 2022-08-17 09:36:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: null
tags:
  - batch
  - job
categories: Spring
updated: 2023-08-19 12:38:07 +0900
---

# Job

Job 은 배치 처리 과정을 하나의 단위로 만들어 표현한 객체입니다. 전체 배치 처리에서 항상 최상단 계층에 있습니다. [[Spring Batch]]에서 `Job` 객체는 여러 [[Step]] 인스턴스를 포함하는 컨테이너입니다.

```java
@Configuration
@RequiredArgsConstructor
public class SimpleJobConfiguration {

    private final JobBuilderFactory jobBuilderFactory;
    private final StepBuilderFactory stepBuilderFactory;

    @Bean
    public Job simpleJob() {
        // simpleJob이라는 이름을 가진 Job을 생성할 수 있는 JobBuilder 인스턴스 반환
        return jobBuilderFactory.get("simpleJob")
                // simpleJobBuilder 인스턴스 반환
                .start(simpleStep1())
                // simpleJob이라는 이름을 가진 Job 인스턴스 반환 
                .build(); 
    }
}
```

보통 배치 Job 객체를 만드는 빌더는 여러개 있습니다. 여러 빌더를 통합처리하는 공장인 `JobBuilderFactory` 의 `get()` 메서드를 호출하여 `JobBuilder` 를 생성하고 이를 이용합니다.

## JobBuilder

`JobBuilder` 의 메서드를 살펴보면 모든 반환 타입이 빌더입니다. 아무래도 비즈니스 환경에 따라서 Job 생성방법이 모두 다릑 때문에 별도의 구체적인 빌더를 구현하고 이를 통해 Job 생성이 이루어지게 하려는 의도가 아닌가 싶습니다.

## JobInstance

`JobInstance` 는 배치에서 Job 이 실행될 때 Job 실행 단위입니다. 만약 하루에 한 번씩 Job 이 실행된다면 어제와 오늘 실행한 각각의 Job 을 `JobInstance` 라고 부를 수 있습니다.

만약 `JobInstance` 가 Job 실행에 실패하면 `JobInstance` 가 끝나지 않고 내부에 가지고 있는 `JobExecution` 에 실패 정보를 기록합니다. Job 실행에 성공하면 `JobInstance` 가 끝난 것으로 간주됩니다. 그리고 `JobExecution` 에 성공 정보를 기록하여 총 2개의 `JobExecution` 을 가지게 됩니다. 여기서 `JobInstance` 와 `JobExecution` 은 부모 자식 관계로 생각하면 됩니다.

## JobParameters

`JobParameters` 는 Job 이 실행될 때 필요한 파라미터들을 `Map` 타입으로 저장하는 객체입니다.

`JobParamters` 는 `JobInstance` 를 구분하는 기준이 되기도 합니다. 예를 들어서 Job 하나를 생성할 때 시작시간 등의 정보를 파라미터로 해서 하나의 `JobInstance` 를 생성합니다. 즉, `JobInstance` 와 `JobParamters` 는 1:1 관계입니다. 파라미터 타입으로는 `String`, `Long`, `Date`, `Double` 을 사용할 수 있습니다.

## [[JobRepository]]
