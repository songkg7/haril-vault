---
title: chezmoi, 본격적으로 활용하기
date: 2023-03-26T21:49:00
aliases: 
tags:
  - chezmoi
  - dotfiles
categories: 
updated: 2025-01-07T00:36
---

지난 글 [[chezmoi, awesome dotfile manager|chezmoi, awosome dotfile manager]]에 이어 좀 더 편리하게 활용할 수 있는 방법들에 대해 공유합니다.

## 어떻게 사용해야 할까

chezmoi 의 명령어 사용법은 `chezmoi help` 및 공식문서에서 확인할 수 있으니, 이 글에서는 chezmoi 를 좀 더 편리하게 사용하기 위한 응용을 설명해봅니다.

### Settings

chezmoi 는 `~/.config/chezmoi/chezmoi.toml` 파일을 설정으로 사용합니다. 만약 툴 관련 설정이 필요하다면 이 파일을 사용하여 정의해주면 되고, `toml` 뿐만 아니라 `yaml`, `json`까지 지원하니 익숙한 포맷으로 작성해주면 됩니다. 공식 문서에는 `toml` 로 가이드하기 때문에 저도 `toml` 을 기본으로 설명합니다.

#### merge tool 및 기본 에디터 설정

**chezmoi 는 기본 에디터로 vi 를 사용**합니다. 저는 nvim 을 주로 사용하기 때문에 기본 에디터로 nvim 이 실행되도록 수정해보겠습니다.

```bash
chezmoi edit-config
```

```toml
[edit]
    command = "nvim"

[merge]
    command = "nvim"
    args = ["-d", "{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
```

VScode 를 사용하신다면 아래처럼 설정해주시면 됩니다.

```toml
[edit]
    command = "code"
    args = ["--wait"]
```

#### 템플릿을 활용한 gitconfig 관리

가끔은 통일된 설정이 아닌 분리된 설정이 필요할 수 있습니다. 예를 들면 회사와 개인 환경의 gitconfig 같은 경우가 있겠네요. 전체적으론 비슷하지만 특정 부분의 데이터만 분리되어야 하는 경우, 이럴 때를 위해 chezmoi 에서는 template 이라고 부르는 일종의 환경변수 주입방식을 통해 제어할 수 있습니다.

먼저 gitconfig 파일을 만들어줍니다.

```bash
mkdir ~/.config/git
touch ~/.config/git/config
```

gitconfig 를 template 로 등록하여 변수를 사용할 수 있도록 해줍니다.

```bash
chezmoi add --template ~/.config/git/config
```

데이터 치환이 필요한 부분을 작성해줍니다.

```bash
chezmoi edit ~/.config/git/config
```

```toml
[user]
	name = {{ .name }}
	email = {{ .email }}
```

이 중괄호는 로컬 환경에서 정의한 변수가 들어가게 됩니다. 기본 변수 목록은 `chezmoi data` 로 확인할 수 있습니다.

변수는 `chezmoi.toml` 에 작성해줍니다.

```bash
# chezmoi edit-config 가 아닌 로컬 설정을 작성해줍니다.
vi ~/.config/chezmoi/chezmoi.toml
```

```toml
[data]
    name=privateUser
    email=private@gmail.com
```

다 작성한 후 `chezmoi apply -vn` 혹은 `chezmoi init -vn` 을 사용해보면 template 변수에 data 값으로 채워져서 config 파일이 생성되는 것을 확인할 수 있습니다.

#### auto commit and push

`chezmoi edit` 을 사용해 dotfile 을 수정한다고해서 local repository 의 git 에 자동으로 반영되지는 않습니다.

```bash
# 수작업으로 해줘야 한다.
chezmoi cd
git add .
git commit -m "update something"
git push
```

이 과정을 자동으로 하기 위해서는 `chezmoi.toml` 에 설정을 추가해줘야 합니다.

```toml
# `~/.config/chezmoi/chezmoi.toml`
[git]
    # autoAdd = true
    autoCommit = true # add + commit
    autoPush = true
```

다만 push 까지 자동으로 할 경우, 보안에 민감한 파일이 실수로 remote repository 에 올라갈 수 있어서 개인적으로는 **commit 까지만 auto 옵션을 활성화하시는 것을 추천**드립니다.

### brew package 관리

회사에서 업무 중 좋은 툴을 찾았다면, 잊지말고 개인 환경에서도 설치해줘야하죠. chezmoi 로 관리해봅니다.

```bash
chezmoi cd
vi run_once_before_install-packages-darwin.sh.tmpl
```

`run_once_` 는 chezmoi 가 사용하는 스크립트 키워드입니다. 이전에 실행된 적이 없을때만 실행시키고 싶을 때 사용합니다. `before_` 키워드를 사용하면 dotfiles 생성 이전에 스크립트를 먼저 동작시킵니다. 이 키워드들을 사용하여 작성된 스크립트가 실행되는 경우는 2가지 경우가 있습니다.

- 한 번도 실행된 적이 없는 경우 (최초 설정)
- 스크립트가 자체가 수정되었을 경우 (업데이트)

이 동작을 응용하여 brew bundle 을 스크립팅해두면 모든 환경에서 통일된 brew package 를 사용할 수 있게 됩니다. 다음은 제가 사용하고 있는 스크립트입니다.

```bash
# MacOS 에서만 실행
{{- if eq .chezmoi.os "darwin" -}}
#!/bin/bash

PACKAGES=(
    asdf
    exa
    ranger
    chezmoi
    difftastic
    gnupg
    fzf
    gh
    glab
    htop
    httpie
    neovim
    nmap
    starship
    daipeihust/tap/im-select
)

CASKS=(
    alt-tab
    shottr
    raycast
    docker
    hammerspoon
    hiddenbar
    karabiner-elements
    obsidian
    notion
    slack
    stats
    visual-studio-code
    warp
    wireshark
    google-chrome
)

# If Homebrew is not installed on the system, it will be installed here
if test ! $(which brew); then
   printf '\n\n\e[33mHomebrew not found. \e[0mInstalling Homebrew...'
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  printf '\n\n\e[0mHomebrew found. Continuing...'
fi

# Update homebrew packages
printf '\nInitiating Homebrew update...\n'
brew update

printf '\nInstalling packages...\n'
brew install ${PACKAGES[@]}

printf '\n\nRemoving out of date packages...\n'
brew cleanup

printf '\n\nInstalling cask apps...\n'
brew install --cask ${CASKS[@]}

{{ end -}}
```

sh 에 익숙하지 않더라도 이해하기 크게 어렵지 않으리라 생각합니다. `PACKAGE` 목록은 `brew install` 로 설치하는 패키지들을, `CASKS` 에는 `brew install --cask` 로 설치하는 애플리케이션들을 정의해주시면 이후 스크립트에 의해 설치과정이 진행됩니다.

스크립트는 chezmoi 로 사용할 수 있는 기능 중에 상대적으로 복잡한 편입니다. 다양한 응용 방식이 있고 같은 기능을 다르게 정의할 수도 있습니다. 좀 더 자세한 사용방법은 [공식 문서](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#set-environment-variables)를 참고해주세요.

## Conclusion

이번 글에서는 기본 사용법을 설명했던 지난 글에 이어, chezmoi 의 유용한 설정들에 대해 정리해보았습니다. 마지막에 소개해드린 스크립트 사용법은 기본 설정이라는 타이틀이 무색하게도 다소 복잡한 내용이지만, 적용해두면 굉장히 편리하게 사용할 수 있어서 넣어보았습니다.

## Reference

- [chezmoi](https://www.chezmoi.io/user-guide/command-overview/)
