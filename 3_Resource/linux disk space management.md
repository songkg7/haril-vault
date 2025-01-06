---
title: 리눅스 용량 관리
date: 2024-05-16T11:26:00
aliases: 
tags:
  - linux
  - disk
  - management
categories: 
updated: 2025-01-07T00:35
---

[[Linux]] EC2 를 직접 관리하다보면 docker log 등으로 용량 부족이 발생하여 디스크 경고 알람이 올 때가 있다. log rolling 정책을 설정해둔다 해도 가끔은 직접 확인해야할 일이 있을 수도 있으니 명령어를 정리해보자.

```bash
# OS 용량 확인
df -h
```

```bash
# 특정 경로 용량 기준 상위 5개
du $PATH | sort -n -r | head -5
```
