---
title: Reactive 한 데이터베이스 요청에 대한 이해
date: 2023-07-04T10:01:00
aliases: 
tags: 
categories: 
updated: 2025-01-07T00:35
---

## Overview

## Reactor

비동기 논블로킹 프로그래밍 [[Reactor]]

`block()` 을 호출할 수 없는 [[Spring WebFlux]]

## DB Connection

Spring 에서 [[Database|DB]] 접근을 위해 많이 쓰이는 기반기술은 [[JDBC]]

JDBC 는 non-blocking 을 지원하지 않기 때문에 blocking 으로 동작하게 되고, 이벤트 루프 쓰레드는 DB 의 결과를 기다리느라 non-blocking 의 이점을 잃게 됨

## R2DBC 및 Reactive DB Driver

[[R2DBC]] 는 non-blocking 을 지원하는 DB Connection 기술이다.

DB 별로 Reactive 스펙을 지원할 수 있도록 별도의 드라이버를 제공한다.
