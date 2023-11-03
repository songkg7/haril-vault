---
title: Docker Study Chapter 10
date: 2023-11-03 08:49:00 +0900
aliases: 
tags:
  - docker
  - study
  - docker-compose
categories: 
updated: 2023-11-03 08:49:13 +0900
---

### 확장 필드

> [!warning]
> 코어 컴포즈 파일에 정의된 확장 필드를 오버라이드 파일에서 사용할 수는 없다.

## Fixed

- 244p 의 실습은 `.env` 파일이 정상 경로에 존재하지 않기 때문에 찾을 수 없어서 에러가 발생한다.
- 248p 의 실습은 compose 을 수정해야 정상 실행된다. yaml 파일에서는 같은 이름의 키가 존재할 수 없기 때문에 발생하는 에러로, 키를 다르게 수정해주면 해결된다.
