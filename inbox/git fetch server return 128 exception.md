---
title: git fetch server return 128 exception
date: 2022-11-30 11:08:00 +0900
aliases: null
tags:
  - error
  - git
  - jenkins
categories: null
updated: 2023-08-19 12:37:41 +0900
---

[[Jenkins]] 에서 간헐적으로 gitlab 과의 연결과정에서 128 응답이 올 때가 있다. 해당 문제 해결 과정을 정리해둔다.

`sshd_config` 가 docker jenkins 내부에 존재하지 않아서 직접 생성하고 error 발생 기다리는 중. 어떤 조건에 에러가 발생하는지 정확하게 파악이 되지 않아서 에러를 제어할 수 없다.

## Reference

https://issues.jenkins.io/browse/JENKINS-11576
https://wiseworld.tistory.com/72