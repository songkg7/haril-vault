---
title: git rebase policy
date: 2024-10-15 13:36:00 +0900
aliases: 
tags:
  - git
  - rebase
description: 
updated: 2024-10-15 13:36:26 +0900
---

[[Git]]

```bash
git config --global pull.rebase true
```

- fast-forward 가 가능하다면 항상 ff 가 적용
- 불필요한 Merge commit 이 생기지 않음
