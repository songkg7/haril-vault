---
title: git history
date: 2024-03-13 17:17:00 +0900
aliases: 
tags:
  - git
categories: 
updated: 2024-03-13 17:17:22 +0900
---

[[Git|Git]]

### 특정 파일 기록 삭제하기

보안상 위험한 내용이 담긴 파일이 history 에 남아있을 경우, 아래와 같은 명령어로 삭제할 수 있다.

```bash
git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch {파일명}' --prune-empty -- --all
```

```bash
git push -f --all
```
