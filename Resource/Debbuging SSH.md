---
title: "Debbuging SSH"
date: 2023-05-29 09:37:00 +0900
aliases: 
tags: [ssh, debug]
categories: 
updated: 2023-05-29 09:56:07 +0900
---

[[Jenkins|Jenkins]] 를 사용하다가 [[GitLab|GitLab]]에 ssh 로 연결하는 과정에서 간헐적으로 128 에러가 관찰되었다.

SSH 를 사용하여 인증할 때 다양한 에러를 마주하게 된다. 이럴 땐 어떤 방식으로 트러블슈팅을 해야하는지를 기록해둔다.

`-vvv` 옵션을 통해 디버깅에 필요한 로그들을 출력할 수 있다.

```bash
ssh -vvv git@github.com
```
