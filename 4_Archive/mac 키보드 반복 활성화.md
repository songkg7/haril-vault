---
title: mac 키보드 반복 활성화
date: 2022-08-25T22:38:00
fc-calendar: Gregorian Calendar
fc-date: 2022-08-25
aliases: 
tags: 
categories: 
updated: 2025-01-07T00:36
---

[[Vim]] 을 사용할 때 키를 꾹 누르고 있으면 반복입력되는 것을 원할 것이다. 하지만 맥에서는 반복입력 대신 특수문자가 뜨는 키들이 있는데, 이럴 때는 터미널에 다음 명령을 실행시켜보자.

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```

위 명령어를 실행 후 application 을 다시 실행해주면 키를 누른 상태를 유지해도 움라우트 등 특수 알파벳 입력창이 더이상 뜨지 않고 정상적으로 반복 입력된다.
