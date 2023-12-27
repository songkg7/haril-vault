---
title: Log 를 잘 남기는 법
date: 2023-05-22 15:38:00 +0900
aliases: null
tags:
  - log
categories: null
updated: 2023-08-19 12:37:48 +0900
---

- `printStackTrace` 는 사용하지 않는다.
- level 을 명확하게 구분하고 사용할 수 있어야 한다. error 로 표시한 log 는 개발자의 즉각적인 조치가 필요함을 나타내야 한다.
- log format 으로는 json 을 사용한다. parsing 과정을 편리하게 해준다.
- 가급적이면 모든 로그는 영어로 작성한다. 한글을 위해서는 형태소 분석기 등 검색엔진의 도움이 필요할 수 있기 때문이다.
