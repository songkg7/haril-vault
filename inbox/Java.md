---
title: "Java"
date: 2022-08-14 00:33:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-14
aliases: 
tags: [backend, java, programming-language, jvm]
categories: Java
updated: 2023-07-16 14:20:19 +0900
---

## Overview

Java 는 [[운영체제 (Operating system)|OS]]에 독립적인 특징을 가지고 있다. 그게 가능한 이유는 [[Java Virtual Machine]] 덕분이다. 그렇다면 JVM 의 어떠한 기능 덕분에 OS에 독립적으로 실행시킬 수 있는지 Java 컴파일 과정을 통해 알아보도록 하자.

## Java 컴파일 순서

1. 개발자가 Java 소스코드(.java)를 작성합니다.
2. Java compiler 가 자바 소스파일을 컴파일 합니다. 이 때 나오는 파일은 Java byte code(.class, 바이트 코드)파일로 아직 컴퓨터가 읽을 수 없는, JVM만 이해할 수 있는 코드입니다. 바이트 코드의 각 명령어는 1byte 크기의 Opcode 와 추가 피연산자로 이루어져 있습니다.
3. 컴파일된 바이트 코드를 JVM 의 클래스 로더(Class Loader)에게 전달합니다.
4. 클래스 로더는 동적 로딩(Dynamic Loading)을 통해 필요한 클래스들을 로딩 및 링크하여 런타임 데이터 영역(Runtime Data Area), 즉 JVM 의 memory 에 올립니다.
5. 실행 엔진(Execution Engine)은 JVM memory 에 올라온 바이트 코드들을 명령어 단위로 하나씩 가져와서 실행합니다. 이 때, 실행 엔진은 두가지 방식으로 변경합니다.
	1. 인터프리터(Interpreter): 바이트 코드 명령어를 하나씩 읽어서 해석하고 실행합니다. 하나하나의 실행은 빠르나, 전체적인 실행속도가 느리다는 단점을 가집니다.
	2. JIT 컴파일러(Just In Time Compiler): 인터프리터의 단점을 보완하기 위해 도입된 방식으로 바이트 코드 전체를 컴파일하여 바이너리 코드로 변경하고 이후에는 해당 메서드를 더 이상 인터프리팅하지 않고, 바이너리 코드로 직접 실행하는 방식입니다. 하나씩 인터프리팅하여 실행하는 것이 아니라 바이트 코드 전체가 컴파일된 바이너리 코드를 실행하는 것이기 때문에 전체적인 실행속도는 인터프리팅 방식보다 빠릅니다.

## Class loader 세부 동작

1. load(로드): 클래스 파일을 가져와서 JVM memory 에 불러옵니다.
2. 검증: 자바 언어 명세(Java Language Specification) 및 JVM 명세에 명시된대로 구성되어 있는지 검사합니다.
3. 준비: 클래스가 필요로 하는 메모리를 할당합니다. (필드, 메서드, 인터페이스 등)
4. 분석: 클래스와 상수 pool 내 모든 심볼릭 레퍼런스를 다이렉트 레퍼런스로 변경합니다.
5. 초기화: 클래스 변수들을 적절한 값으로 초기화합니다. (static 필드)

## Links

- [[Java Virtual Machine]]
