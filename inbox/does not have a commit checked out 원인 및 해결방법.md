---
title: "does not have a commit checked out 원인 및 해결방법"
date: 2022-08-28 15:39:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-28
aliases: 
tags: [git, error]
categories: 
---

```bash
$ git add .
error: 'spring-mvc/' does not have a commit checked out
fatal: adding files failed
```

해당 에러는 멀티 프로젝트를 관리할 때 하위 모듈에 `.git` 이 존재하여 상위 모듈의 `.git` 과 충돌하여 발생한다.

## Solution

하위 모듈 경로로 이동하여 `.git` 을 지워주고 다시 `git add .` 을 하면 해결