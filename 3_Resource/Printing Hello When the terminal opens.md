---
title: 터미널에 배너 출력하기
date: 2024-01-10T11:13:00
aliases: 
tags:
  - terminal
  - nerd
  - figlet
  - lolcat
  - ascii-art
categories: 
updated: 2025-01-07T00:35
---

figlet 과 lolcat 을 활용하면 터미널 세션을 시작할 때 문구가 출력되게 할 수 있다.

![](https://i.imgur.com/AidPz0C.png)

```bash
brew install figlet
brew install lolcat
```

```
figlet -f {font} {message} | lolcat
```
