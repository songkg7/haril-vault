---
title: "chezmoi, basic settings"
date: 2023-03-26 21:49:00 +0900
aliases: 
tags: [chezmoi]
categories: 
---

![[chezmoi, awesome dotfile manager|chezmoi]]

### Settings

chezmoi 는 `~/.config/chezmoi/chezmoi.toml` 파일을 설정으로 사용합니다. 만약 툴 관련 설정이 필요하다면 이 파일을 사용하여 정의해주면 되고, `toml` 뿐만 아니라 `yaml`, `json`까지 지원하니 익숙한 포맷으로 작성해주면 됩니다. 공식 문서에는 `toml` 로 가이드하기 때문에 저도 `toml` 을 기본으로 설명합니다.

### forget

> 더 이상 관리하지 않고 싶지 않을 때

remove 를 사용하면 chezmoi 에서는 물론 연결된 로컬파일까지 삭제합니다.

### edit-config

> chezmoi.toml 을 작성하거나 수정할 때

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

Template 을 활용하면 더 디테일한 작업이 가능하지만, 내용이 너무 길어지므로 생략. 자세한 내용은 공식 문서를 참조해주시길 바란다.

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

### auto commit and push

update 는 자동으로 되지만 설정의 변경이 자동으로 push 되진 않는다. 아래 설정을 적용하면 자동으로 push 할 수 있다.

```toml
# `~/.config/chezmoi/chezmoi.toml`
[git]
    autoCommit = true
    autoPush = true
```

다만 보안에 민감한 파일이 실수로 push 될 수 있으므로 주의.

### brew bundle

Mac 을 가정할 때 가장 자주 쓰게 되는 패키지 매니저가 바로 brew 이다. brew 로 뭔가 중요한걸 설치한다면 다른 기기에서도 동일하게 설치될 수 있도록 자동화된 스크립트를 만들어줄 수 있다.
