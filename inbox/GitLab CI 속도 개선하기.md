---
title: "GitLab CI 속도 개선하기"
date: 2022-09-26 11:21:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-26
aliases: 
tags: [ci, cd, gitlab, cache]
categories: 
---

GitLab 에서 gradle build 속도가 로컬에 비해 월등히 느린 현상이 있다.

### Cache

![[스크린샷 2022-12-29 오후 10.25.21.png]]

최대 10배 가량 속도가 빨라진 것을 확인할 수 있다.

## Reference

- [saramin](https://saramin.github.io/2021-07-01-gitlab-ci-pipeline-efficiency/)