---
title: "chezmoi, awosome dotfile manager"
date: 2023-03-25 10:50:00 +0900
aliases: chezmoi
tags: [chezmoi, dotfiles]
categories: 
---

## Overview

수많은 개발환경에서 통일된 설정을 유지하려면 어떻게 해야할까?

`.zshrc` 를 비롯한 수많은 설정파일들은 대부분 루트 경로에 존재한다. 하지만 이 파일들의 버전 관리를 위해서 루트에 [[Git]] 을 설정하는 것은 불필요한 파일들을 하나하나 골라내야하는 문제가 발생할 수 있기 때문에 영 부담스러운 일이였다.

그렇게 symbolic link, 별도의 폴더에 dotfile 들을 모아두는 법 등을 고민하다가 발견한 chezmoi 라는 툴을 소개하고자 합니다.

## Install

```bash
brew install chezmoi
```

## How to use

### Settings

chezmoi 는 `~/.local/share/chezmoi` 를 working directory 로 사용하며 이 디렉토리에 있는 파일은 chezmoi 가 관리합니다. 사용자는 명령어를 통해 이 디렉토리를 직접 제어함으로써 chezmoi 가 어떤 파일을 관리해야할지 알려주게 됩니다.

chezmoi 는 `~/.config/chezmoi/chezmoi.toml` 파일을 설정으로 사용합니다. 만약 툴 관련 설정이 필요하다면 이 파일을 사용하여 정의해주면 되고, `toml` 뿐만 아니라 `yaml`, `json`까지 지원하니 익숙한 포맷으로 작성해주면 됩니다. 공식 문서에는 `toml` 로 가이드하기 때문에 저도 `toml` 을 기본으로 설명합니다.

### add

> 설정파일을 chezmoi 에 등록할 때

관리하려는 파일을 chezmoi 에 추가해준다.

```bash
chezmoi add ~/.zshrc
```

그럼 chezmoi 가 local 에 특정한 디렉토리를 생성하고 변경사항을 감지하게 된다.

> [!WARNING] `chezmoi.toml` 은 add 할 수 없다.
> 아무래도 메인 툴의 설정인만큼 재귀를 막기 위해서인지 모르겠지만 protected 되어 있다는 에러가 출력된다.

편집 방법은 아래와 같습니다.

```bash
chezmoi edit ~/.zshrc
```

![[chezmoi-workflow.png]]

### forget

> 더 이상 관리하지 않고 싶지 않을 때

remove 를 사용하면 chezmoi 에서는 물론 연결된 로컬파일까지 삭제합니다.

### edit-config

> chezmoi 자체 설정을 작성하거나 수정할 때

### cd

> working directory 로 이동

## Secuirty

gpg key 를 사용하여 민감한 내용은 encrypt 하여 repository 에 올릴 수 있다. 물론 repository 자체를 private 으로 해도 되지만 이 기능을 활용하면 repository 를 public 으로도 사용할 수 있다.

## Tip

만약 저처럼 인텔 맥과 M1 맥을 같이 사용하고 있다면 `brew` 의 설치경로가 달라서 동작하지 않는 설정파일들이 생길 수 있습니다. 때문에 shell script 및 환경변수를 적극적으로 활용해줘야 합니다.

예를 들면 프로세서에 의한 `brew` 경로 차이는 아래처럼 보정할 수 있습니다.

```bash
# M1: source /opt/homebrew/~
# Intel: /usr/local/~
source $(brew --prfix)/share/
```

### auto commit and push

update 는 자동으로 되지만 설정의 변경이 자동으로 push 되진 않는다. 아래 설정을 적용하면 자동으로 push 할 수 있다.

```toml
# `~/.config/chezmoi/chezmoi.toml`
[git]
    autoCommit = true
    autoPush = true
```

다만 보안에 민감한 파일이 실수로 push 될 수 있으므로 주의.

## Conclusion

문서화가 상당히 잘 되어 있고, 상당히 활발하게 개발이 진행되고 있다.

## Reference

- [chezmoi](https://www.chezmoi.io)
