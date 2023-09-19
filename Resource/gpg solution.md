---
title: "gpg solution"
date: 2023-03-30 00:11:00 +0900
aliases: 
tags: 
categories: 
---

gpg2 로 동작하는지 확인 후 아래 명령어 실행

```bash
git config --global gpg.program $(which gpg2)
```