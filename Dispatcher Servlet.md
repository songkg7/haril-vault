---
title: "Dispatcher Servlet"
date: 2022-08-14 00:11:00 +0900
tags: [network, http, spring]
categories: [Spring]
publish: false
aliases: 
fc-calendar: Gregorian Calendar
fc-date: 2022-08-14
---

## Dispatcher Servlet?

> Servlet Container 에서 [[HTTP & HTTPS]] 프로토콜을 통해 들어오는 모든 요청을 프레젠테이션 계층의 제일 앞에 둬서 중앙집중식으로 처리해주는 프론트 컨트롤러(Front Controller)

클라이언트로부터 어떠한 요청이 오면 Tomcat 과 같은 서블릿 컨테이너가 요청을 받는데, 이 때 제일 앞에서 서버로 들어오는 모든 요청을 처리하는 프론트 컨트롤러를 [[Spring framework|Spring]] 에서 정의하였고, 이를 Dispatcher Servlet 이라고 한다.

> [!info] Front Controller?
> 주로 서블릿 컨테이너의 제일 앞에서 서버로 들어오는 클라이언트의 모든 요청을 받아서 처리해주는 컨트롤러인데, MVC 구조에서 함께 사용되는 패턴이다.

## Dispatcher Servlet 의 장점

Spring MVC 는 Dispatcher Servlet 이 등장함에 따라 `web.xml` 의 역할을 상당히 축소시킬 수 있었다. 기존에는 모든 서블릿에 대해 URL 매핑을 활용하기 위해서 `web.xml` 에 모두 등록해주어야 했지만, Dispatcher Servlet 이 해당 애플리케이션으로 들어오는 모든 요청을 핸들링해주면서 작업을 상당히 편리하게 할 수 있게 되었다.

![[dispatcher-servlet.png]]

개발자는 Handler 만 직접 구현해주면 되고 나머지 객체들은 Dispatcher servlet 이 스프링 컨테이너로부터 주입받아서 사용하고 동작하게 된다.
