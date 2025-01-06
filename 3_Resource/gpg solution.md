---
title: gpg solution
date: 2023-03-30T00:11:00
aliases: 
tags: 
categories: 
updated: 2025-01-07T00:35
---

gpg2 로 동작하는지 확인 후 아래 명령어 실행

```bash
git config --global gpg.program $(which gpg2)
```