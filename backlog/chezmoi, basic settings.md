---
title: "chezmoi, basic settings"
date: 2023-03-26 21:49:00 +0900
aliases: 
tags: [chezmoi]
categories: 
---

![[chezmoi, awesome dotfile manager|chezmoi]]

## 어떻게 사용해야 할까

chezmoi 의 명령어 사용법은 `chezmoi help` 및 공식문서에서 확인할 수 있으니, 이 글에서는 chezmoi 를 좀 더 편리하게 사용하기 위한 응용을 설명해봅니다.

### Settings

chezmoi 는 `~/.config/chezmoi/chezmoi.toml` 파일을 설정으로 사용합니다. 만약 툴 관련 설정이 필요하다면 이 파일을 사용하여 정의해주면 되고, `toml` 뿐만 아니라 `yaml`, `json`까지 지원하니 익숙한 포맷으로 작성해주면 됩니다. 공식 문서에는 `toml` 로 가이드하기 때문에 저도 `toml` 을 기본으로 설명합니다.

merge tool 및 기본 에디터 설정

템플릿을 활용한 gitconfig 관리

회사와 개인 환경의 변수를 어떻게 관리할 수 있을까? 예를 들면 gitconfig 의 email

활용한 예시

```dot_zprofiles.tmpl
{{ if stat "/opt/homebrew/bin/brew" -}}
fpath+=("$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions")
eval "$(/opt/homebrew/bin/brew shellenv)"
{{ else if stat "/usr/local/bin/brew" -}}
fpath+=("$(/usr/local/bin/brew --prefix)/share/zsh/site-functions")
eval "$(/usr/local/bin/brew shellenv)"
{{ end -}}
```

#### auto commit and push

update 는 자동으로 되지만 설정의 변경이 자동으로 push 되진 않는다. 아래 설정을 적용하면 자동으로 push 할 수 있다.

```toml
# `~/.config/chezmoi/chezmoi.toml`
[git]
    autoCommit = true
    autoPush = true
```

다만 보안에 민감한 파일이 실수로 push 될 수 있으므로 주의.

### brew list 관리

회사에서 업무 중 좋은 툴을 찾았다면, 잊지말고 개인 환경에서도 설치해줘야하죠. chezmoi 로 툴들의 목록을 관리해봅니다.

#### Templating

## Tip

만약 저처럼 인텔 맥과 M1 맥을 같이 사용하고 있다면 `brew` 의 설치경로가 달라서 동작하지 않는 설정파일들이 생길 수 있습니다. 때문에 shell script 및 환경변수를 적극적으로 활용해줘야 합니다.

예를 들면 프로세서에 의한 `brew` 경로 차이는 아래처럼 보정할 수 있습니다.

```bash
# M1: source /opt/homebrew/~
# Intel: /usr/local/~
source $(brew --prfix)/share/
```
