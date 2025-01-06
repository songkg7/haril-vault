---
title: Test 의 실행속도를 빠르게, Spring context mocking
date: 2022-09-05T12:33:00
published: 2023-01-25T11:33:00
aliases: 
tags:
  - test
  - spring
  - mockito
  - junit
categories: 
updated: 2025-01-07T00:36
---

## Overview

모든 프로젝트에서 테스트 코드를 작성하는 것은 이제 일상이 된지 오래다. 프로젝트가 커지면 커질수록 필연적으로 테스트의 수도 많아지면서 전체 테스트 수행시간이 점점 길어지게 된다. 특히 [[Spring framework|Spring]] 을 기반으로 하는 프로젝트의 테스트를 쓰고 있다면 Spring Bean 의 Context loading 에 의해서 테스트 실행이 급격하게 느려지게 되는데, 오늘은 Spring Context 를 불어오는 시간을 어떻게 해결했는지 작성해보고자 한다.

## 모든 테스트는 유닛 테스트로 작성

테스트는 빨라야 한다. 빨라야 자주 실행하는데 있어서 주저함이 없어진다. 전체 테스트 한 번 실행하는데 10분씩 걸린다면, 피드백이 10분은 지나야 온다는 의미이다.

Spring 에서의 빠른 테스트를 위해서는 `@SpringBootTest` 의 사용을 피해야 한다. 모든 Bean 을 불러오기 때문에 비즈니스 로직을 테스트하는 코드의 실행보다 필요한 Bean을 불러오는 시간이 압도적으로 길어진다.

```java
@SpringBootTest
class SpringApplicationTest {

	@Test
	void main() {
		
	}
}
```

위 코드는 Spring application 을 실행하기 위한 기본 테스트 코드다. `@SpringBootTest` 에 의해서 설정되어있는 모든 Bean 이 불러와진다. 어떻게 하면 필요한 Bean 만 주입받아서 테스트할 수 있을까?

## `@WebMvcTest`, Mockito 활용

특정 어노테이션을 사용하면, 관련 테스트에 필요한 Bean 만 자동으로 불러와진다. 덕분에 모든 Bean 을 Context loading 하는 것이 아닌, 진짜 필요한 Bean 만 불러와서 테스트 수행시간을 최소화 할 수 있다.

[[Mockito]] 를 활용하면 복잡한 의존관계를 간편하게 해결하여 테스트를 작성할 수 있다. 이 두 개념을 적절히 사용한다면 대부분의 유닛 테스트는 크게 어렵지 않다.

## 그렇다면 SpringApplication 은?

SpringApplication 이 실행되려면 `SpringApplication.run()` 이 실행되어야 한다. 해당 method 의 실행을 확인하기 위해서 모든 Spring context 를 loading 하는 것은 역시 비효율적이므로, context loading 이 일어나는 `SpringApplication` 을 mocking 처리하고 `run()` 이 호출되는지만 검증하면 `@SpringBootTest` 를 사용하지 않고도 테스트할 수 있다.

```java
class DemoApplicationTests {  
  
    @Test  
    void main() {  
        try (MockedStatic<SpringApplication> springApplication = mockStatic(SpringApplication.class)) {  
            when(SpringApplication.run(DemoApplication.class)).thenReturn(null);  
  
            DemoApplication.main(new String[]{});  
  
            springApplication.verify(  
                    () -> SpringApplication.run(DemoApplication.class), only()  
            );        }    }}
```

## Conclusion

로버트 마틴의 Clean Code 9장에 보면 'FIRST 원칙' 에 대해 설명하고 있다.

그 중에 첫 글자인 F, Fast(빠르게) 에 대해서 고민해본 결과를 이번 글에서 간단하게 소개해봤다. 다시 한 번 언급하며 글을 마무리한다.

> 테스트는 충분히 빨라야 한다.
