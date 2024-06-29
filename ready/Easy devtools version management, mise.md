---
title: 개발도구 버전 관리하기, mise
date: 2024-04-18 20:35:00 +0900
aliases: 
tags:
  - mise
  - version-manager
categories: 
updated: 2024-06-29 12:49:14 +0900
description: 개발 도구의 여러 버전을 바꿔가며 사용해야한다면 어떻게 해야할까요? 이번 글에서는 mise 를 통해 개발 환경을 편리하게 관리하는 방법을 살펴봅니다.
---

## Overview

- 하나의 개발 언어만 쓰는게 아니라 다양한 개발 언어를 활용하고 계신가요?
- sdkman, rvm, nvm 등등 여러 패키지 매니저의 명령어를 외우는데 피로감을 느끼신 적은 없으신가요?
- 개발 환경을 좀 더 빠르고 편리하게 관리하고 싶지 않으신가요?

mise 를 사용하면 어떤 언어, 도구를 사용하더라도 정확하게 필요한 버전을 사용할 수 있고 다른 버전으로 전환해가며 사용한다거나 프로젝트별로 버전을 지정하는 것도 가능해요. 파일로 명시하기 때문에 팀원들간에 어떤 버전을 사용할지 토론하는 등의 커뮤니케이션 비용이 줄어들 수 있지요.

지금까지 이 분야에서 가장 유명한건 [[asdf]] 였어요[^1]. 하지만 최근 mise 를 사용하기 시작한 뒤로는 mise 가 UX 측면에서 조금 더 괜찮다는 생각이 들었어요. 이번 글에서는 간단한 사용 용례를 소개해드려보려고 해요.

![](https://i.imgur.com/9gGGfot.png)

_의도적인지는 모르겠으나 웹페이지조차 비슷하다._

## mise-en-place, mise

`mise`('meez, 미즈'라고 발음하는 것 같아요)는 개발 환경 설정 툴입니다. 이 이름은 프랑스 요리 문구에서 유래한 것으로, 대략 "설정" 또는 "제자리에 놓다"로 번역됩니다. 요리를 시작하기 전에 모든 도구와 재료가 제자리에 놓일 준비가 되어 있어야 한다는 뜻이라고 하네요.

간단한 특징을 나열해보면 아래와 같아요.

- 거의 대부분의 개발 언어 및 도구들을 지원하는 패키지 매니저
    - 플러그인 형태로 추가도 가능
- Shell 로 작성된 asdf 와 다르게 Rust 로 작성
- [[asdf]] 기능 외에도 direnv 처럼 환경변수를 설정하는 기능도 제공

## 설치

설치는 brew 를 통해 할 수 있습니다.

```bash
brew install mise
# or
curl https://mise.run | sh
```

```bash
mise --version
# mise 2024.6.6
```

### Activate mise

가이드에 따라 활성화 명령을 실행합니다.

```bash
# bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

# zsh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```

## 사용 사례

### 의존 버전 관리

새로운 환경으로 취직 or 이직하게 되서 새로운 장비를 받았다고 가정해볼까요? 새로운 곳에서는 [[Java]] 를 기본으로 사용하고 있다고 하니, 필요로하는 버전을 설치할 수 있는지 확인해봅니다.

```bash
mise ls-remote java
```

![](https://i.imgur.com/8kzA8dE.png)

> [!tip] fuzzy finder, fzf
> 버전이 너무 많이 출력되어 당황스럽다면 `mise ls-remote java | fzf` 를 사용해보세요

`corretto-11.0.18.10.1` 를 설치하면서 기본적인 자바 버전으로 사용하도록 설정했습니다.

```bash
mise use --global java@corretto-11.0.18.10.1
```

![](https://i.imgur.com/PT7UxD1.png)

![](https://i.imgur.com/Arqxubw.png)

글 작성 기준 Java 의 LTS 는 21 입니다. 21 을 설치해주면서, 자주 쓰고 있는 17 도 함께 설치해볼게요.

```bash
mise install java@17 java@21
```

![](https://i.imgur.com/pdBt4or.png)

설치가 완료된 이후, `mise ls` 명령을 사용해보면 어떤 언어들이 설치되어 있는지 확인할 수 있습니다.

```bash
mise ls
```

![](https://i.imgur.com/lecwTLv.png)

마침 팀장님이 새로운 프로젝트는 Java 21 로 해보자고 합니다. 우선 **해당 프로젝트에서만 Java 21 을 사용**해보면 좋을 것 같네요.

```bash
mkdir project && cd project
touch .mise.toml
mise use java@21
```

mise 를 사용할 때는 `.mise.toml` 이라는 파일을 사용해서 어떤 버전을 사용할 것인지 명시합니다.[^2]

```toml
# ~/project/.mise.toml
[tools]
java = "21"
```

다시 `mise ls` 를 실행해보면 `Config Source` 의 변경과 함께 적용 중인 Java 버전이 변경된 것을 확인할 수 있습니다.

![](https://i.imgur.com/HVX9ASk.png)

![](https://i.imgur.com/kNLORwK.png)

> [!tip]
> 그동안 [[asdf]] 를 사용해와서 `.tool-versions` 파일이 이미 있다면, `tool-versions` 을 그대로 사용할 수도 있습니다.

이제 프로젝트 별로 다른 Java 버전을 사용할 수 있게 되었습니다.[^3] 어떤 Java 버전을 사용하는지 `.mise.toml` 파일에 명시되어 있으므로, 팀원들간 개발환경 차이로 인해 발생하는 문제도 최소화할 수 있을 것 같네요.

생각해보니, Java 11 은 이제 없어도 될 것 같네요. 그냥 17을 기본값으로 쓰기로 하고, 11 은 삭제하겠습니다.

```bash
mise use --global java@17
mise uninstall java@corretto-11.0.18.10.1
```

자, 이제 업무에 사용할 언어 설치는 끝났으니 개인적으로 자주 사용하는 언어들을 좀 더 설치해야겠네요.

저는 옵시디언의 플러그인인 [[o2|O2]] 를 [[TypeScript]] 를 사용하여 개발 중이에요. node 의 최신 안정화 버전을 설치해줍니다.

```bash
mise use node@lts
```

[[Python]] 을 사용하는 데이터 정제 작업이 종종 있기도 합니다.

```bash
mise use python@3.12.3 # 파이썬은 버전에 민감하여 최대한 구체적인 버전을 사용하고 있어요.
```

업무용 메신저 봇을 [[Go|golang]] 으로 만들기도 하구요. 트래픽 실험에 사용하는 API 도 golang 으로 만들고 있어요.

```bash
mise use go@latest
```

~~Rust, Ruby 등등도 간간히 사용하지만 생략...~~

어휴, 뭐가 참 많네요. 한 번에 설치할 수 있으면 좋을 것 같아요.

`~/.config/mise/config.toml` 에 명시해준 뒤

```toml
# ~/.config/mise/config.toml
[tools]
java = "corretto-11.0.18.10.1"
node = "lts"
go = "latest"
python = "3.12.3"
```

`mise install` 을 사용하면 필요한 의존성들을 한 번에 설치할 수 있습니다.

```bash
mise install
```

![](https://i.imgur.com/jmFlah3.png)

물론 그냥 명령어로 한 번에 처리해도 무방합니다. `~/.config/mise/config.toml` 에 명시되어 있지 않은 언어는 알아서 append 처리될거에요.

```bash
mise use --global node@lts python@3.12.3 go@latest
```

![](https://i.imgur.com/I9KtmEi.png)

![](https://i.imgur.com/46FKxVA.png)

> [!tip]
> 저는 보통 개발 언어만 관리하는 편이지만, gradle 이나 awscli 등 다른 도구들도 mise 를 통해 버전 관리가 가능합니다.

### 환경 변수 관리

> mise = asdf + **direnv**

mise 를 사용하면 각기 다른 프로젝트마다 서로 다른 개별적인 환경변수도 지정할 수 있어요. [direnv](https://direnv.net/) 로 얻을 수 있는 사용자 경험과 완전히 동일합니다. 아니, 오히려 `.envrc` 파일을 관리하지 않아도 되니 더 편하게 느껴지네요.

`.mise.toml` 에 간단한 변수를 하나 정의해보겠습니다.

```toml
[env]
HELLO = 'WORLD'
```

> [!warning]
> `.mise.toml` 에 정의한 환경변수가 적용되려면, `mise trust` 라는 명령을 통해서 확인해줘야 합니다. 이는 다른 프로젝트 파일을 다운받았다가 자동으로 실행되어 보안문제가 발생하는 것을 막기 위함이에요.

`echo` 로 출력해보면 환경 변수가 정상적으로 동작하고 있는 것을 확인할 수 있어요.

![](https://i.imgur.com/jyU0Rwj.png)

`~/project/.mise.toml` 에 설정된 정보는 `~/project` 디렉토리 내에서만 유효하므로 이 scope 를 벗어나면 HELLO 환경변수도 자동으로 해제됩니다.

![](https://i.imgur.com/Sb11T0T.png)

`.mise.toml` 을 직접 수정하지 않고, CLI 를 통해서도 관리할 수 있습니다.

```bash
mise set HELLO=world
mise set HELLO
# world
mise set
# key    value source
# HELLO  WORLD ~/project/.mise.toml
mise unset HELLO
mise set
# key    value source
```

간단하죠? global 로 환경변수를 관리해야한다면, 상술했듯이 `~/.config/mise/config.toml` 에 정의해두면 됩니다.

```bash
mise set -g GLOBAL='mise is insane!'
mise set
# key     value           source
# GLOBAL  mise is insane! ~/.config/mise/config.toml
```

특정 개발환경에 필요한 정보를 모두 `.mise.toml` 에 담아두고 공유받는다면 훨씬 쉽게 환경 설정을 마무리할 수 있겠죠. 상술했듯이 mise 로는 패키지 버전도 관리할 수 있으니까요. `asdf` 도 all-in-one 에 가까운 매우 훌륭한 도구였는데, 환경변수까지 관리할 수 있는 점은 mise 를 더욱 특별하게 만들어줍니다.

## Conclusion

이렇게 대략적인 개발환경 구성을 끝냈습니다.언어만 설치했을 뿐인데 뭐가 끝이냐구요? 다른 부분은 [dotfile 관리하기](https://haril.dev/blog/2023/03/26/chezmoi-awesome-dotfile-manager) 를 참고해주세요. 다들 새로운 장비를 받고 개발 환경을 구성하는데 1~2시간은 걸린다고 생각하실테니 남은 시간은 개발 서적이나 읽어야겠습니다.

![[DALL·E comic office scene.webp]]

## Reference

- https://github.com/jdx/mise

---

[^1]: 24년 6월 기준 GitHub Star 21k
[^2]: https://mise.jdx.dev/configuration.html
[^3]: 예시로 Java 를 사용했을 뿐이고, Java 는 [[IntelliJ]] 에서 설정하는걸 더 선호합니다.
