---
title: 이미 push 된 파일을 ignore 처리하는 법
date: 2023-01-19T12:24:00
aliases: 
tags:
  - git
  - rm
  - gitignore
categories: 
updated: 2025-01-07T00:35
---

[[Git]]

`.gitignore` 에 파일을 정의하기 전 이미 remote 에 push 했다면 이후에 `.gitignore` 에 파일을 정의하더라도 원격 저장소에서 파일이 삭제되지 않는다.

다음 명령을 통해 cache 에서 삭제시켜주고 다시 add 함으로써 원격저장소에서 삭제할 수 있다.

```bash
git rm -r --cached .
git add .
git commit -m "delete ignored files"
git push
```
