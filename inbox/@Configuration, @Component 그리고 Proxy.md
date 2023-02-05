---
title: "@Configuration, @Component 그리고 Proxy"
date: 2023-01-24 01:53:00 +0900
aliases: 
tags: [java, annotation, bean, proxy, spring, cglib, jdkdynamicproxy]
categories: 
---

너무 방대한 주제를 한 번에 다루려다 보니 글의 중심을 잡기 어려워서 다음 세 개의 글로 분리

java practice 다음 module 추가

- proxy-example
- spring-bean-example

1. JDK Dynamic proxy 와 CGLIB
	- JDK Dynamic proxy
		- interface 의 필요성과 Reflection
		- Proxy 객체
	- CGLIB proxy
		- 바이트코드를 직접 조작하는 Code Generator library
		- class 상속을 사용하는 `Enhancer`
		- 한계점
2. Springboot 에서의 Bean 등록 방법
	- Component Scanning
	- `@Bean` 만 사용하여 등록해보기
		- 테스트
	- `@Component`
		- Lite mode
		- 테스트
			- CGLIB proxy 동작 검증
	- `@Configuration`
		- `proxyMethod` option
		- 테스트
  3. Spring AOP
	  - proxy 기반의 AOP
	  - 어떤 proxy 가 사용될까?

2번 글에서 1번 글을 link

## Overview

많은 게시글에서 `@Configuration` 과 `@Component` 를 비교하는 내용을 확인할 수 있습니다. 이번 글에서는 각각의 어노테이션에 대해 간단한 설명부터 시작하여 좀 더 자세히 들여다 봅니다.

@Configuration and @Component are both annotations used in Spring framework, but they serve different purposes.

@Configuration: This annotation is used to indicate that a class defines a configuration for the application. Classes annotated with @Configuration are used to define beans and their dependencies using Java code, rather than using XML configuration files. The configuration is done using methods annotated with @Bean, which define the bean and its properties.

@Component: This annotation is used to indicate that a class is a component. Components are simple Java classes that can be automatically detected and registered as beans by the Spring framework using component scanning. These classes can be used to define services, controllers, or other kinds of components that are part of the application.

In summary, @Configuration is used for defining beans and their dependencies in Java code, while @Component is used to indicate that a class is a component that can be automatically detected and registered as a bean.

## Contents

### Spring 에서의 Bean

사실 `@Configuration` 은 `@Component` 와 비교하기에 적절하지 않을 수 있다. `@Configuration` 또한 `@Component` 의 일부이기 때문이다.

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Configuration  
```

다만 Bean 객체를 등록할 수 있는 방법으로써 `@Configuration` 과 `@Component` 는 공통점을 가지기 때문에 이 관점에서 진행하려고 한다.

[[Spring framework|Spring]]에서의 Bean 은 굉장히 중요한 개념이다. 애플리케이션 전체에서 클래스를 싱글톤으로 관리할 수 있게 해주고, 스프링이 직접 관리하는 객체이기 때문에 개발자가 따로 의존성을 주입할 필요없이 스프링에 의해 의존성이 관리된다.

그렇다면 Bean 은 어떻게 등록하고 사용할 수 있을까?

이게 바로 `@Configuration` 과 `@Component` 를 비교하는 출발점이 되겠다.

Bean 은 ComponentScan 이라고 하는 과정을 통해 `@Component` 어노테이션이 정의된 모든 클래스가 등록된다.

### @Configuration

> CGLIB is a Java library that provides code generation capabilities for creating dynamic proxies, used to implement aspects such as AOP (Aspect-Oriented Programming) and to extend classes at runtime. It is used as a supplement to the standard Java reflection API and works by generating bytecode for a subclass of a target class, allowing the subclass to override or extend the methods of the target class.

`@Configuration` 이 선언된 객체에서 생성되는 Bean 은 CGLIB 에 의해 메서드가 단 1회만 호출되도록 조작된다. 즉, 싱글톤 객체임이 보장된다.

```java
@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new PasswordEncoder();
    }

} 
```

```java
@Slf4j
public class PasswordEncoder {
	public void encode(String password) {
        log.info("PasswordEncoder.encode: {}", password);
	}
} 
```

간단한 테스트를 통해 Bean 을 직접 사용해보자.

```java
class BeanTest {

    @Test
    void getPasswordEncoderBean() {
        ApplicationContext context = new AnnotationConfigApplicationContext(
                SecurityConfig.class);

        PasswordEncoder passwordEncoder = context.getBean(PasswordEncoder.class);
        System.out.println("passwordEncoder.getClass(): " + passwordEncoder.getClass());
		passwordEncoder.encode("password");
    }

} 
```

> [!NOTE] AnnotationConfigApplicationContext
>  `AnnotationConfigApplicationContext` 를 사용하면 지정된 클래스는 별도의 annotation 이 없어도 Bean 으로 등록되지만, 실제 SpringApplication.run() 을 호출했을 때는 ComponentScan 을 통해 `@Component` 를 명시한 클래스가 Bean 으로 등록된다.

```console
passwordEncoder.getClass(): class basic.configurationvscomponent.PasswordEncoder 
```

![[Screenshot 2023-02-03 오전 11.17.29.png]]

실제 객체가 생성되어 Bean 으로 등록되었음을 알 수 있다.

다른 Bean 등록 방식에서도 마찬가지지만 Spring 은 객체의 생성을 위임받아 대신 관리해준다.

모든 Bean 이 proxy가 되는 것은 아니다. 특정 조건을 만족했을 경우에만 proxy 객체로 생성되며 일부 Bean 은 일반 객체로 생성된다.

스프링에서 Bean 을 proxy 로 관리하는 대표적인 경우는 [[Spring AOP]] 가 있다. AOP 가 적용되면 Spring 은 Bean 을 proxy 객체로 생성한다.

직접 확인해보기 위해 간단하게 AOP 를 적용해보자.

```java
@Aspect
public class AspectService {

    @Around("execution(* basic.configurationvscomponent.PasswordEncoder.encode(..))")
    public Object log(ProceedingJoinPoint pjp) {
        System.out.println("AspectService.log");
        return null;
    }

} 
```

```java
@Configuration
@EnableAspectJAutoProxy
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new PasswordEncoder();
    }

    @Bean
    public AspectService aspectService() {
        return new AspectService();
    }

} 
```

이전과 같은 테스트를 실행시켜봤다.

![[Screenshot 2023-02-03 오후 12.59.54.png]]

CGLIB 라는 키워드를 확인할 수 있다. 내부적으로 `AbstractAopProxyCreator` 를 통해서 proxy 객체로 생성되야하는지 아닌지를 판단한 후 proxy 로 생성된다.

`CglibAopProxy.getProxy()` 를 살펴보면 아래와 같은 코드를 확인할 수 있다.

```java
			enhancer.setSuperclass(proxySuperClass);
			enhancer.setInterfaces(AopProxyUtils.completeProxiedInterfaces(this.advised));
			enhancer.setNamingPolicy(SpringNamingPolicy.INSTANCE);
			enhancer.setStrategy(new ClassLoaderAwareGeneratorStrategy(classLoader));

			Callback[] callbacks = getCallbacks(rootClass);
			Class<?>[] types = new Class<?>[callbacks.length];
			for (int x = 0; x < types.length; x++) {
				types[x] = callbacks[x].getClass();
			}
			// fixedInterceptorMap only populated at this point, after getCallbacks call above
			enhancer.setCallbackFilter(new ProxyCallbackFilter(
					this.advised.getConfigurationOnlyCopy(), this.fixedInterceptorMap, this.fixedInterceptorOffset));
			enhancer.setCallbackTypes(types); 
```

결과적으로 proxy 객체는 target class 의 subclass 이므로 DI 에 의해서 Target class 로 주입될 수 있다.

### @Component

[[@Component]] 를 통해서 Bean 을 등록하면 Lite mode 가 된다. Lite mode 가 되면 바이트 코드를 조작하지 않으므로 `@Configuration` 을 사용하는 것보다는 빠르지만 큰 차이는 없다.

> [!NOTE] Lite mode란?
> CGLIB 를 통해 바이트 코드를 조작하지 않는 상태를 말한다. `@Configuration` 어노테이션이 잇다면 CGLIB 를 통해 메서드 호출이 1회로 제한되도록 바이트코드가 조작된다.

중요한 것은 객체의 생명 주기이다. `@Component` 를 통해 Bean 을 등록한 경우 CGLIB 에 바이트 코드가 조작되지 않으므로, 해당 클래스 안에서 등록된 Bean 을 호출하면 실제 메서드를 호출한 것처럼 **객체가 새로 생성**된다. 즉, 싱글톤 객체임을 보장할 수 없다.

#### @Component 를 통한 Bean 등록

```java
@Component
public class SecurityComponent {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new PasswordEncoder();
    }

    // Lite mode 로 인해 객체가 다시 한 번 생성되므로 결과적으로 서로 다른 PasswordEncoder 가 생성된다.
    @Bean
    public PasswordEncoder anyPasswordEncoder() {
        return passwordEncoder();
    }
 
} 
```

```java
@Test
void component() {
	AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(
			SecurityComponent.class);

	PasswordEncoder passwordEncoder = context.getBean("passwordEncoder", PasswordEncoder.class);
	PasswordEncoder anyPasswordEncoder = context.getBean("anyPasswordEncoder", PasswordEncoder.class);
	System.out.println("passwordEncoder.getClass(): " + passwordEncoder.getClass());
	System.out.println("anyPasswordEncoder.getClass(): " + anyPasswordEncoder.getClass());

	assertThat(passwordEncoder).isNotSameAs(anyPasswordEncoder);
} 
```

![[Screenshot 2023-02-03 오후 4.40.36.png]]

몇몇 글에서 `@Component` 는 CGLIB proxy 를 사용하지 못한다고 적혀있었다. 사실인지 아닌지 검증해보자.

```java
@Component
@EnableAspectJAutoProxy
public class SecurityComponent {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new PasswordEncoder();
    }

    @Bean
    public PasswordEncoder anyPasswordEncoder() {
        return passwordEncoder();
    }

    @Bean
    public AspectService aspectService() {
        return new AspectService();
    }

} 
```

![[Screenshot 2023-02-03 오후 4.48.23.png]]

딱히 CGLIB 를 사용하지 못하는 것은 아닌거 같다.

## Conclusion

- Lite mode: CGLIB 를 통해 바이트 코드를 조작하지 않음을 의미

### 공통

- ComponentScan 을 통해 자기 자신을 Bean 으로 등록
- `@Bean` 어노테이션을 사용하여 다른 객체들을 Bean 으로 등록할 수 있음
	- ReadOnly 인 외부 라이브러리 클래스들도 Bean 으로 등록시킬 수 있음
- 사용되는 proxy 는 경우에 따라 다름
	- 기본적으로는 [[CGLIB]] 를 사용

### @Component

- Lite mode
- `@Component` 안에서의 Bean 등록과정에서 이미 등록된 Bean 을 재사용하려고 하는 경우, 싱글톤이 유지되지 않을 수 있음
- 파라미터 주입을 통해 Bean 을 주입받는 경우엔 `@Configuration` 과 마찬가지로 기존 Bean 객체가 주입

### @Configuration

- CGLIB 를 통해 메서드 호출이 모두 1회만 일어나도록 바이트 코드가 수정된다.
- 싱글톤으로 객체들의 생명주기를 관리
- proxyBeanMethod 옵션을 false 로 하면 Component 와 마찬가지로 Lite mode 로 동작한다.

Lite mode 의 장점은 신경써야 하는 점들에 비해서 미미하므로 `@Bean` 어노테이션을 통한 Bean 객체 생성은 `@Configuration` 에서만 하는 것을 권장한다.

## Reference

- [tistory](https://woooongs.tistory.com/99?category=826142)
