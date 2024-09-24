---
title: AspectJ
date: 2024-06-09 21:06:00 +0900
aliases: 
tags: 
categories: 
updated: 2024-06-09 21:06:16 +0900
---

## AspectJ 란?

자바 코드에 **Aspect 라는 모듈** 형태로 문제를 분리 및 해결하는 프레임워크

### Aspect

개발 시 **공통문제**에 대해 공통의 로직을 작성하는 부분

### AOP (Aspect Oriented Programming)

Aspect 를 이용한 프로그래밍 방식

- OOP (Object Oriented Programming)
    - 문제점
        - 중복된 코드가 발생할 수 있음
        - 한 클래스 내에서 비즈니스 로직과 비즈니스 외 로직이 섞일 수 있음
    - 해결방법?
        - 상속 (extends)
        - 인터페이스 (implements)
        - 위의 두 방식은 많은 양의 코드를 생성할 수 있고, 유지보수가 어려움
- AOP 적용 후 문제점 해결 방법?
    1. 공통모듈을 분리하여 작성 후 Aspect 에서 호출 -> 중복된 코드 해결
    2. 핵심로직과 공통모듈을 분리하여 관리 -> 유지보수 용이

## Spring AOP 와 AspectJ

### Spring AOP

- Spring 안에서 제공하는 AOP 기능 사용
- JDK Dynamic Proxy 또는 CGLIB Proxy를 이용하여 생성된 Proxy 객체가 대상객체를 감싸며, 메서드 호출 시 InvocationHandler 에 의해 메서드 전/후 추가로직을 수행

### AspectJ

- Spring AOP 와는 달리 별도의 컴파일 작업이 필요
- Aspect (공통문제) 를 별도의 모듈로 작성 후, 반영하려는 타겟 객체에 AspectJ 코드를 삽입하여 횡단 관심사 (cross-cutting concern) 를 해결
