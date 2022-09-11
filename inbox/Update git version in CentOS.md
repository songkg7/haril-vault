---
title: "Update git version in CentOS"
date: 2022-09-11 13:07:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-11
aliases: 
tags: [centos, git, yum]
categories: CentOS
---

git 최신 버전이 등록되어 있는 저장소 등록

```bash
yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-1.noarch.rpm
```

```bash
yum update git
```

update 명령어를 사용하면 최신 버전에 필요한 패키지들을 모두 설치한다.

제대로 설치되었는지 버전을 확인해보고 종료.

```bash
git --version
# 2.23.0
```

## Links

- [[CentOS]]
- [[Git]]
