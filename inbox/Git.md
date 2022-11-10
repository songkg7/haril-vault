---
title: "Git"
date: 2022-11-10 21:08:00 +0900
aliases: 
tags: [git]
categories: 
---

## Overview

소스코드를 관리해주는 툴. 변경내역을 기록하여 언제든지 원하는 지점으로 돌아가거나 다른 변경사항과 병합처리 등 다양한 기능을 지원한다.

개발자라면 숨쉬듯 자연스럽게 다룰 줄 알아야 한다.

## Contents

### Configuration

git 의 설정은 local 설정과 global 설정으로 구분할 수 있다.

#### Local

local 설정은 특정한 repository 에 한정해서 설정을 적용하고 싶을 때 사용한다. 보통 개인용 PC 에서 회사 프로젝트를 작업하는 경우, user 정보를 구분하기 위해서 많이 사용한다.

다음 명령어로 특정 프로젝트의 설정을 확인할 수 있다.

```bash
git config --local --list
```

```bash
git config --local user.name testuser
git config --local user.email test@email.com
```

이런 식으로 특정한 프로젝트 내부에서만 쓸 사용자 정보를 지정할 수 있다.

#### Global

만약 전역적으로 git 설정을 적용하고 싶다면 global 옵션을 통해서 사용한다. global 설정은 `~/.gitconfig` 라는 파일에서 확인할 수 있다.

```bash
cat ~/.gitconfig
# or
git config --global --list
```

만약 현재 사용중인 PC 가 개인용이라면 전역설정으로 개인정보를 저장해놓고 사용하면서 특정한 저장소만 변경하여 사용할 수 있다. local 설정이 global 을 덮어쓰게 된다.

```bash
git config --global user.name privateUser
git config --global user.email myEmail@email.com
```

#### `.gitignore`

특정한 파일은 git 이 관리하지 못하도록 `.gitignore` file 을 통해서 정의해둘 수 있다.

`.git` 파일과 같은 레벨에 존재하는 `.gitignore` file 이 적용되며 global 설정의 경우 `~/.gitignore` 를 통해 관리된다.
 
> [!NOTE] gitignore_global
> 정확한 내용확인 필요


secret 정보라던가 credential 등 보안상 민감한 정보는 공유하지 않는 것이 현명하다. 

### commit

### remote

### push

### branch

### pull

### switch

### restore

### reset

### merge

### rebase 에 대한 이해

## Advance

### shell scripting

[[fzf]]

### diff

[[difftastic]]

### reflog

`reset --hard` 를 사용하여 작업 내용을 날렸다고 해도, reflog 만 알고 있다면 걱정할 필요가 없다.

git 은 모든 command 실행을 기록하고 있으며 `reflog` command 를 통해 특정 명령어를 실행하기 이전으로 돌아갈 수 있다.

### debug



## Links

- [[GitHub]]
- [[GitLab]]
