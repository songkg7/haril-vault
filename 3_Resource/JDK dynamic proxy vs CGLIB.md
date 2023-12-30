---
title: JDK dynamic proxy vs CGLIB
date: 2023-02-05 15:56:00 +0900
aliases: 
tags:
  - java
  - proxy
  - cglib
  - jdk-dynamic-proxy
categories: 
updated: 2023-09-04 15:34:11 +0900
---

- JDK Dynamic proxy
	- interface 의 필요성과 Reflection
	- Proxy 객체
- CGLIB proxy
	- 바이트코드를 직접 조작하는 Code Generator library
	- class 상속을 사용하는 `Enhancer`
	- 한계점

## prerequisite

- [[Java]] 11

Java 16+ 에서 실행할 경우

![[Screenshot 2023-02-05 오후 4.01.19.png]]

## JDK Dynamic proxy

### Proxy 객체

### 한계

interface 가 필요하며 reflection 을 통해 proxy 객체를 생성하므로 속도가 느리다.

## CGLIB

CGLIB(Code Genereator library)는 바이트 코드를 조작하여 proxy 객체를 생성한다.

```java
public class PersonService {

    public String sayHello(String name) {
        return "Hello" + name;
    }

    public Integer lengthOfName(String name) {
        return name.length();
    }  
}
```

### Enhancer

```java
@Test
void returning_the_same_value() {
	Enhancer enhancer = new Enhancer();
	enhancer.setSuperclass(PersonService.class);
	enhancer.setCallback((FixedValue) () -> "Hello Tom!");
	PersonService proxy = (PersonService) enhancer.create();

	String res = proxy.sayHello(null);

	assertThat(res).isEqualTo("Hello Tom!");
}
```

`Enhancer` 를 통해 target 객체를 super class 로 설정하여 target 객체가 가진 모든 메서드를 사용할 수 있도록 한다.

`sayHello` 의 parameter 로 `null` 을 전달했지만 proxy 객체의 `FixedValue` 에 의해 `Hello Tom!` 이 반환되게 된다.

### Method Interceptor

첫 번째 방법은 항상 프록시 객체가 실행되기 때문에 경우에 따라 super class 를 호출하고 싶은 경우 처리가 힘들다는 단점이 있다. 이럴 때 `MethodInterceptor` 를 사용하면 프록시 호출을 가로채고 부모 클래스의 메서드를 호출할지 혹은 직접 구현한 부분이 실행되게할지를 결정할 수 있다.

```java
@Test
void returning_value_depending_on_method_signature() {
	Enhancer enhancer = new Enhancer();
	enhancer.setSuperclass(PersonService.class);
	enhancer.setCallback((MethodInterceptor) (obj, method, args, proxy) -> {
		if (method.getDeclaringClass() != Object.class && method.getReturnType() == String.class) {
			return "Hello Tom!";
		} else {
			return proxy.invokeSuper(obj, args);
		}
	});

	PersonService proxy = (PersonService) enhancer.create();

	String res = proxy.sayHello(null);
	assertThat(res).isEqualTo("Hello Tom!");

	int length = proxy.lengthOfName("Mary"); // this method is not intercepted because it returns an int
	assertThat(length).isEqualTo(4);
}
```

이 예제에서는, `Object` class 가 아닌 모든 method 호출을 가로챈다. 즉, `toString()` 또는 `hashCode()` 는 가로채지 않는다. 그 외에도, 오직 `PersonService` 에서 `String` 을 반환하는 메서드만 가로챈다. `lengthOfName()` 메서드는 `Integer` 를 반환하기 때문에 가로채지 않고 부모 클래스의 메서드가 호출된다.

### Bean Generator

CGLIB 의 또다른 유용한 생성 방법으로는 `BeanGenerator` class 가 있다. `BeanGenerator` 는 setter getter 를 가진 필드를 포함한 동적 빈 생성이 가능하다. 이 방법은 간단한 POJO 객체를 생성하기 위한 code generation tools 들에서 많이 사용되고 있다.

```java
@Test
void beanCreator() throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
	BeanGenerator beanGenerator = new BeanGenerator();
	beanGenerator.addProperty("name", String.class);
	Object myBean = beanGenerator.create();
	Method setter = myBean.getClass().getMethod("setName", String.class);
	setter.invoke(myBean, "some string value set by a cglib");

	Method getter = myBean.getClass().getMethod("getName");
	String value = (String) getter.invoke(myBean);

	assertThat(value).isEqualTo("some string value set by a cglib");
}
```

### Mixin

Mixin 은 다양한 객체들을 하나로 합치는 방식의 생성 방법이다. 서로 다른 동작을 하는 여러 클래스들을 단일 클래스 혹은 인터페이스로 사용할 수 있다. 그러나 반드시 인터페이스를 구현한 클래스여야 mixin 으로 사용할 수 있다.

```java
public interface Interface1 {
    String first();
}

public interface Interface2 {
    String second();
}

public class Class1 implements Interface1 {

    @Override
    public String first() {
        return "first behavior";
    }
}

public class Class2 implements Interface2 {

    @Override
    public String second() {
        return "second behavior";
    }

}

public interface MixinInterface extends Interface1, Interface2 {
}
 ```

`Mixin.create()` 를 사용하여 서로 다른 동작을 하는 두 개의 클래스를 `MixinInterface` 로 사용할 수 있다.

```java
@Test
void mixin() {
	Mixin mixin = Mixin.create(
			new Class[]{ Interface1.class, Interface2.class, MixinInterface.class },
			new Object[]{ new Class1(), new Class2() }
	);
	MixinInterface mixinDelegate = (MixinInterface) mixin;

	assertThat(mixinDelegate.first()).isEqualTo("first behavior");
	assertThat(mixinDelegate.second()).isEqualTo("second behavior");
}
 ```

`mixinDelegate` 를 호출하면 `Class1` 과 `Class2` 에서의 코드 구현이 호출된다.

### 한계

상속을 이용하기 때문에 target class 가 final class 일 경우 사용이 불가능하다.

## Reference

- [Stackoverflow](https://stackoverflow.com/questions/66974846/java-lang-exceptionininitializererror-with-java-16-j-l-classformaterror-access)
- [Baeldung](https://www.baeldung.com/cglib)
- https://logical-code.tistory.com/118
