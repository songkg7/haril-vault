---
title: "mac 키보드 반복 활성화"
date: 2022-08-25 22:38:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-25
aliases: 
tags: 
categories: 
---

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```

위 명령어를 실행 후 application 을 다시 실행해주면 움라우트 등 특수 알파벳 입력창이 더이상 뜨지 않고 반복실행된다.