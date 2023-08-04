---
title: Question list
date: 2023-05-24 20:20:00 +0900
aliases: null
tags:
  - question
categories: null
updated: 2023-08-04 14:11:34 +0900
---

![[Dev QnA|개발 질문 모음]]

1. 동시성 이슈가 발생할 수 있는 부분을 염두에 둔 구현
: DBMS 레벨 lock, 애플리케이션 레벨 lock

- 공유 락(Shared Lock): 읽기에서 발생하는 db lock 읽기간에는 영향을 주지 않는다. 외래 키에 의해서 발생하는 락이기도 하다
- 베타 락(Exclusive Lock): 데이터에 변경을 가하는 쓰기 명령들에 대해 주어지는 락으로 Write Lock 으로도 불리며, X 로 표기합니다. 베타 락은 이름처럼 다른 세션이 해당 자원에 접근하는 것을 막는다. 베타락은 트랜잭션동안 유지된다.
- 업데이트 락(Update Lock): 업데이트 락은 데이터를 수정하기 위해 베타 락을 걸기 전, 데드 락을 방지하기 위해 사용되는 락
- 내재 락(Intent Lock): 내재 락은 사용자가 요청한 범위에 대한 락을 걸 수 있는지 여부를 빠르게 파악하기 위해 사용되는 락

- 낙관적 락: 일반적으로 락이 발생하지 않을 것이라고 접근하는 방식. 데이터를 읽는 시점에 Lock 을 걸지 않고 수정을 하려고 할 때 데이터가 변경되었는지 확인하고 변경을 시도한다.

https://hudi.blog/jpa-concurrency-control-optimistic-lock-and-pessimistic-lock/
https://techblog.woowahan.com/9478/

@Version 을 통해 최초 커밋만 인정하기 전략을 JPA 레벨에서 구현할 수 있다. @Version 으로 추가한 버전 관리 필드는 JPA 가 직접 관리하므로 수정해서는 안된다. 그런데 벌크 연산의 경우는 버전을 무시하므로, 벌크 연산을 수행할 때에는 버전 필드를 강제로 증가시켜야 한다.

낙관적 비관적락은 관심사가 엔티티에 대한 동시 접근에 대한 처리

트랜잭션 격리레벨은 일관된 읽기를 구현하기 위한 전략, 하지만 실제로는 대부분의 DB 에서 락 대신 MVCC 가 사용되긴 한다.

2. SPOF, 외부 의존성 최소화
: 레플리케이션, 클러스터링, 써킷브레이커

3. 대용량의 데이터를 효과적으로 저장하는 방법
: write cache, x-lock 등

4. 대용량의 데이터를 효과적으로 읽는 방법
: index, s-lock, read cache 등

spin lock

---

## 경험 강조하기

https://brownbears.tistory.com/45

1. 내가 엔지니어로서 해보고 싶은 전체적인 경험
2. 그 중 과거에 했던 경험
3. 2를 바탕으로 그 회사에 기여할 수 있을만한 점
4. 그 회사에서 해보고 싶은 경험

5줄정도 쓰면 돌려먹기

내가 궁극적으로 하고 싶은 것들은 ~~~이런거야. 그러 기 위해선 xX, yy, 2z 경험이 필요한 것 같아.

이를 위해서 나는 과거에 xX, yy 경험을 해봤고, 이걸 바탕으로 너네 회사에 ~~~이렇게 기여할 수 있을 것 같아. 내가 평소에 관심 가지고 있는 프로젝트에 기여 할 수 있다는 부분이 너무 기대 되고,

아직 못해본 zZ를 너네 회사에서 해볼 수 있을 것 같 다는 기대가 있어. 그래서 너무 함께 하고 싶어.

---

[https://careerly.co.kr/comments/83898?utm_campaign=user-share](https://careerly.co.kr/comments/83898?utm_campaign=user-share)

- 트래픽이 갑자기 몰린다면 어떻게 대처할 수 있을까?
    - 상황에 따라 다르다. 사실 당장 트래픽이 몰릴때 개발자가 할 수 있는건 스케일아웃 외에는 거의 없다.
    - 만약 트래픽이 증가하는 상황이 예상된다면 이것저것 시도해볼 수 있을 것 같다.
- (캐시를 사용한다면) CUD 작업에 몰리는 트래픽에 대해서는 어떻게 대처할 것인가?
    - Read DB, Write DB 의 분리
- 방문 수를 기록하는 기능과 같은 데이터가 있다면 어떻게 동시성을 보장할 것인가?
    - 메세지큐에 밀어넣고 배치 등으로 이벤트를 처리하기?
    - 조회 수 같은 경우는 실시간성이 크게 중요하지 않기 때문에 허수 처리에 대한 방법을 고민하는 것이 더 중요할 수 있다.
- 결제를 기다리고 있는 모달 창에서 사용자가 화면을 벗어난 경우 어떻게 처리해야할까?
- 선착순 이벤트의 경우 대기열을 기다리던 사용자가 매진된 상황을 인지하지 못하고 계속 대기하는 경우가 있다. 이런 불편한 경험을 해소하려면 어떤 기술적 조치가 있을 수 있을까?

## Java

1. **JVM 의 구조에 대해서 설명해보세요. (→ 자바 코드가 실행되는 과정을 설명해주세요.)**
2. 클래스와 객체지향 개념에 대해서 설명해보세요.
3. 오버라이딩과 오버로딩이란 무엇인지 설명해보세요.
4. JDK 와 JRE, JVM 의 차이에 대해서 설명해보세요.
    - VM을 사용함으로써 얻을 수 있는 장점과 단점에 대해 설명해 주세요.
    - JVM과 내부에서 실행되고 있는 프로그램은 부모 프로세스 - 자식 프로세스 관계를 갖고 있다고 봐도 무방한가요?
5. GC (Garbage Collection) 에 대해서 설명해보세요.
6. 자바 파이널 키워드 적용 시 어떤 현상이 일어나는지 설명해보세요.
    1. 그렇다면 컴파일 과정에서, final 키워드는 다르게 취급되나요?
7. 자바의 equals(), hashcode() 설명해보세요.
8. 컴파일 과정을 말해보라
9. interface와 abstract class차이
    1. 왜 클래스는 단일 상속만 가능한데, 인터페이스는 2개 이상 구현이 가능할까요?
10. 캡슐화와 은닉화? 차이는 무엇인가?
11. **String, StringBuilder, StringBuffer의 차이는**
12. JAVA의 Garbage Collector는 어떻게 동작하는지.
    1. finalize() 를 수동으로 호출하는 것은 왜 문제가 될 수 있을까요?
    2. 어떤 변수의 값이 null이 되었다면, 이 값은 GC가 될 가능성이 있을까요?
13. GC 옵션
14. **자바 다이나믹 프록시 → 스프링 AOP랑 같이 물어보는 경향**
15. enum 이란
16. 자바에서 == 와 Equals() 메서드의 차이는
17. java의 접근 제어자의 종류와 특징
18. Java SE와 Java EE 애플리케이션 차이
19. java의 final 키워드 (final/finally/finalize)
20. 리플렉션이란?
    1. 의미만 들어보면 리플렉션은 보안적인 문제가 있을 가능성이 있어보이는데, 실제로 그렇게 생각하시나요? 만약 그렇다면, 어떻게 방지할 수 있을까요?
    2. 리플렉션을 언제 활용할 수 있을까요?
21. Wrapper class
22. OOP의 4가지 특징
    1. 추상화(Abstraction)
    2. 캡슐화(Encapsulation)
    3. 상속(Inheritance)
    4. 다형성(Polymorphism)
23. **OOP의 5대 원칙(이중에 니 생각에 뭐가 제일 중요하냐?)**
    1. **S**
    2. **O**
    3. **L**
    4. **I**
    5. **D**
24. java의 non-static 멤버와 static 멤버의 차이
25. static class와 static method를 비교해 주세요.
    1. static 을 사용하면 어떤 이점을 얻을 수 있나요? 어떤 제약이 걸릴까요?
    2. 컴파일 과정에서 static 이 어떻게 처리되는지 설명해 주세요.
26. java의 main 메서드가 static인 이유
27. Java 에서 Annotation 은 어떤 기능을 하나요?
    1. 별 기능이 없는 것 같은데, 어떻게 Spring 에서는 Annotation 이 그렇게 많은 기능을 하는 걸까요?
    2. Lomok의 @Data를 잘 사용하지 않는 이유는 무엇일까요?
28. java 직렬화(Serialization)와 역직렬화(Deserialization)란 무엇인가?
29. 제네릭이란, 왜 쓰는지 어디에 써 봤는지 알려주세요
30. 클래스, 객체, 인스턴스의 차이
31. 객체(Object)란 무엇인가?
32. Call by Reference와 Call by Value의 차이
33. 제네릭에 대해 설명해주시고, 왜 쓰는지 어디세 써 봤는지 알려주세요.
34. Java의 Exception에 대해 설명해 주세요.
    1. 예외 처리를 하는 세 방법에 대해 설명해 주세요.
    2. CheckedException, UncheckedException 의 차이에 대해 설명해 주세요.
    3. 예외 처리가 성능에 큰 영향을 미치나요? 만약 그렇다면, 어떻게 하면 부하를 줄일 수 있을까요?
35. **Java Collections Framework**
    1. **java Map 인터페이스 구현체의 종류 → 이거 당골**
        1. **HashMap vs HashTable vs ConcurrentHashMap vs TreeMap vs LinkedHashMap의 차이를 설명하시오.**
    2. **java Set 인터페이스 구현체의 종류**
    3. **java List 인터페이스 구현체의 종류**
36. 깊은복사 , 얇은복사의 차이
37. 동기화와 비동기화의 차이(Syncronous vs Asyncronous)
38. **Stream이란? → 보통 어떨 때 Stream 많이 쓰세요?**
    1. Stream과 for ~ loop의 성능 차이를 비교해 주세요,
    2. **Stream은 병렬 처리 할 수 있나요?**
    3. Stream에서 사용할 수 있는 함수형 인터페이스에 대해 설명해 주세요.
    4. 가끔 외부 변수를 사용할 때, final 키워드를 붙여서 사용하는데 왜 그럴까요? 꼭 그래야 할까요?
39. Lambda란?
40. 자바에 함수형 인터페이스에 선언문이 하나인 이유
41. new String()과 ""의 차이에 대해 설명해주세요.
42. 오버로딩과 오버라이딩의 차이
43. java immutable Object
44. Java Functional Interface 종류
45. java heap 최대 사이즈 설정
46. optional 생성 방법
47. java map flatmap 차이
48. heap dump 뜨는 방법
49. 클래스변수, 인스턴스변수, 지역 변수
50. java volatile vs atomic
51. java String 불변 객체인 이유
52. **Synchronized 키워드에 대해 설명해 주세요. → 동시성에 대한 질문에서 자바는 어떻게 하냐?**
    1. Synchronized 키워드가 어디에 붙는지에 따라 의미가 약간씩 변화하는데, 각각 어떤 의미를 갖게 되는지 설명해 주세요.
    2. **효율적인 코드 작성 측면에서, Synchronized는 좋은 키워드일까요? → 느린 이유는 아는 지?**
    3. **Synchronized 를 대체할 수 있는 자바의 다른 동기화 기법에 대해 설명해 주세요.**
    4. **Thread Local에 대해 설명해 주세요.**

## Spring

1. DI 와 IoC 에 대해서 설명해보세요.
    1. 후보 없이 특정 기능을 하는 클래스가 딱 한 개하면, 구체 클래스를 그냥 사용해도 되지 않나요? 그럼에도 불구하고 왜 Spring에선 Bean을 사용 할까요?
    2. Spring의 Bean 생성 주기에 대해 설명해 주세요.
        - [[Spring Bean Lifecycle|스프링 빈 생성주기]]
        1. 프로토타입 빈은 무엇인가요?
2. ORM 에 대해서 설명해보세요.
    1. JPA 와 영속성 컨텍스트
3. Spring Collection 에 대해서 설명해보세요.
4. Spring DI 에 대해 설명해보세요.
5. Spring IOC 에 대해 설명해보세요.
6. Spring AOP 에 대해 설명해보세요.
    1. @Aspect는 어떻게 동작하나요?
7. Spring MVC 패턴이 요청을 주고 받을 때 어떤 흐름인지 설명해보세요.
8. JPA에서 dao, dto를 사용해야하는 이유는 무엇인지 설명해보세요.
9. 스프링 시큐리티의 원리와 동작 방식 설명해주세요.
10. 스프링 빈이라는 게 어떤 역할을 하는지 설명해주세요.
11. 스프링 로컬 캐시쓰면 되는데 redis를 쓰는 이유는 무엇일까요?
12. Spring 에서 Interceptor와 Servlet Filter에 대해 설명해 주세요.
    1. 설명만 들어보면 인터셉터만 쓰는게 나아보이는데, 아닌가요? 필터는 어떤 상황에 사용 해야 하나요?
13. DispatcherServlet 의 역할에 대해 설명해 주세요.
    1. 여러 요청이 들어온다고 가정할 때, DispatcherServlet은 한번에 여러 요청을 모두 받을 수 있나요?
    2. 수많은 @Controller 를 DispatcherServlet은 어떻게 구분 할까요?
14. @Transactional 은 어떤 기능을 하나요?
    1. @Transactional(readonly=true) 는 어떤 기능인가요? 이게 도움이 되나요?
    2. 그런데, 읽기에 트랜잭션을 걸 필요가 있나요? @Transactional을 안 붙이면 되는거 아닐까요?
15. Tomcat이 정확히 어떤 역할을 하는 도구인가요?
    1. 혹시 Netty에 대해 들어보셨나요? 왜 이런 것을 사용할까요?

## Reference

![[Pasted image 20230804141117.png]]

- https://www.aha-contents.com/362