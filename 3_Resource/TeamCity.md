---
title: TeamCity
date: 2022-08-20 13:26:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-20
aliases: 
tags:
  - CI
  - CD
  - teamcity
  - jetbrains
categories: DevOps
updated: 2024-07-17 10:37:04 +0900
---

## Overview

TeamCity 는 JetBrains 사가 개발한 CI/CD tool 로 2006년부터 서비스되고 있다. Jenkins 와 같은 포지션에 있지만 새로운 CI/CD tool 이 필요하다면 TeamCity 를 한 번 고려해보는 걸 추천하고 싶다. 이번 글에서는 Spring batch 개발의 관점에서 왜 Jenkins 가 아니라 TeamCity 를 추천하는지 설명하고자 한다.

## 어떤 문제점을 해결할 수 있을까?

TeamCity 의 장점을 살펴보기 전에 먼저 왜 CI/CD tool 을 사용해야 하는지 간단하게 장단점을 살펴보자.

### CI/CD tool 을 사용하지 않을 경우

- 배치 모니터링에 대한 부재로 운영 및 관리가 어렵다.
- `Quartz` 를 사용하여 스케쥴링한다면 재배포 없이 스케쥴링을 조절할 수 없다.
- 배치에 문제가 생겼을 경우 재실행이 힘들다.
- 애플리케이션이 종료되지 않고 항상 실행 상태를 유지하고 있기 때문에 아무런 처리 작업이 없는 상태에서도 리소스를 사용하게 된다.

### tool 을 사용할 경우

- 모니터링 및 특정 배치 재실행이 용이하다. 대부분 UI 를 제공해주기 때문에, 직관적으로 현재 상태를 체크할 수 있다.
- Spring batch 의 설계를 훨씬 자유롭게 한다. `Job`, `Step` 실행순서의 제약에서 완전히 해방되어 외부에서 원하는 부분만 실행시킬 수 있다.
- 외부에서 환경변수를 주입할 수 있기 때문에, 코드 내부의 설정을 건드리지 않고 컨트롤할 수 있게 된다.
- 운영환경에서 동작할지 확인하는 테스트를 로컬에서 원격으로 실행시킬 수 있기 때문에, 동작 확인을 위한 배포가 필요하지 않다.
- 배치의 무중단 배포가 가능해진다.

그 외에도 다양한 상황에 유연하게 대처가 가능하기 때문에 대부분의 회사에서는 CI/CD tool 을 적극적으로 활용하고 있다.

## TeamCity 의 장단점

### IntelliJ IDEA 및 타 IDE 와의 통합

IntelliJ 를 사용한다면 code 를 commit 하기 전에 test 가 통과할지 원격으로 실행시켜볼 수 있다.

![[teamcity2.png]]

remote 로 동작하면서 관련 로그를 IntelliJ 로 알려주기까지 한다. 이렇게 개인이 커밋 전 실행한 빌드 결과는 다른 사람이 볼 수 없게 되어 있어서 TeamCity 로그를 더럽힐 걱정없이 얼마든지 실행시켜볼 수 있다.

![[teamcity3.png]]

![[teamcity4.png]]

![[teamcity 1.png]]

Jenkins 에 비해 유려한 UI 및 기능에도 불구하고, 여전히 Jenkins 에 비해 점유율이 낮은게 사실이다. 또한 Plugin 생태계도 Jenkins 에 비해서는 초라하다.

## Conclusion

## Reference

- [TeamCity](https://www.jetbrains.com/help/teamcity/teamcity-documentation.html)

## Links

- [[Spring Batch]]
- [[Operate Jenkins using Docker|Docker 로 Jenkins 운영하기]]
