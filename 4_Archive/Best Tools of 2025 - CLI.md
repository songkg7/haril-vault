---
title: Best Tools of 2025 - CLI
date: 2025-03-15T22:01:32+09:00
aliases: 
tags:
  - cli
description: 
updated: 2025-04-09T00:55
published: 2025-03-30
---

![](https://i.imgur.com/zgIVoVN.png)

## Overview

최고의 App 을 설명했던 [지난 글](https://haril.dev/blog/2025/03/16/Best-Tools-of-2025-Apps) 에 이어서 Command Line Interface(이하 CLI) 중 추천할만한 도구를 살펴본다. 이번에 소개되는 모든 툴들은 필자가 최소 6개월 이상 써본 도구들이며, 새로운 장비를 설정할 때 반드시 설치하는 것들이다.

## zoxide

[GitHub - ajeetdsouza/zoxide: A smarter cd command. Supports all major shells.](https://github.com/ajeetdsouza/zoxide)

한 번이라도 방문했던 디렉토리라면 경로를 기억할 필요가 없게 해주는 툴. 예를 들면 아래와 같은 경우다.

```bash
cd ~/.config/somewhere/longlong/path

# 다음부터는 아래 명령으로 바로 방문가능
z path
```

이게 굉장히 편리해서, 특정 설정 파일이 어디있는지 기억할 필요가 없어진다. `zi` 를 사용하면 우선순위 List 가 출력되기 때문에, fuzzy 하게 찾아갈 수도 있다.

한 번 써보면 다시는 이 툴을 사용하기 전으로 돌아갈 수 없을 것.

## [[mise]]

[GitHub - jdx/mise: dev tools, env vars, task runner](https://github.com/jdx/mise)

각종 환경변수 및 언어, 패키지들의 버전 매니저. 구조상 안정성이 매우 뛰어나며, Rust 로 구현되어 속도도 빠르다. 직관적인 명령어는 러닝커브를 크게 완화시켜 준다.

이미 본 블로그에 [글로도 소개](https://haril.dev/blog/2024/06/27/Easy-devtools-version-management-mise)했을만큼, 굉장히 애정하는 툴이다. mise 역할을 해줄 비슷한 도구는 몇가지 더 있지만 개인적으로는 그 중 가장 추천할만하다고 생각한다. 예를 들면, direnv 는 mise 로 완전히 대체가 가능하고 nix 는 과하게 복잡하여 범용성이 떨어진다.

다양한 언어를 다루는 프로그래밍 Multilingual 이라면, 꼭 써보자.

## [[chezmoi, awesome dotfile manager|chezmoi]]

[chezmoi](https://www.chezmoi.io/)

사용하는 장비가 여러 대라면, 개발 환경을 동기화하기가 여간 귀찮은게 아니다. 특히 CLI 를 자주 사용하는 개발자라면 더더욱.

아예 동기화를 포기하고 지낼 생각이라면 모르겠지만, 어떻게 동기화할 수 있을지 고민하고 있다면 chezmoi 를 써보자. 혹여, 새로운 장비를 구매하더라도 초기 설정에 시간을 들일 필요가 없어진다.

mise 와 마찬가지로 본 블로그에 사용법에 관한 [글](https://haril.dev/blog/2023/04/08/chezmoi-basic-settings)이 있으니 참고.

## [[fzf]]

[GitHub - junegunn/fzf: :cherry\_blossom: A command-line fuzzy finder](https://github.com/junegunn/fzf)

GitHub Star 약 70k, 더 이상의 설명이 필요할까(참고로 spring-framework 가 57k 이다).

한국인 개발자인 junegunn 님께서 관리하시는 오픈소스 fuzzy finder 로, 표준입출력 파이프라이닝을 통해 어마어마한 범용성을 자랑한다.

**검색이 필요하다면, 종류에 상관없이 fzf 를 쓰면 된다.** 워낙 이런저런 패키지들이 가져다가 쓰는 중이라, fzf 의 존재를 몰랐더라도 이미 간접적으로 쓰고 있었을 수 있다.

## fd

[GitHub - sharkdp/fd: A simple, fast and user-friendly alternative to 'find'](https://github.com/sharkdp/fd)

`find` 명령을 대체한다.

Rust 로 작성되었으며, `find` 에 비해 최대 50% 빠르다고 한다. highlighting 도 깔끔한 편이고, 명령어 옵션도 `find` 보다 훨씬 직관적이다.

## ripgrep

[GitHub - BurntSushi/ripgrep: ripgrep recursively searches directories for a regex pattern while respecting your gitignore](https://github.com/BurntSushi/ripgrep)

`grep` 명령을 대체한다. 이름은 ripgrep 이지만 `rg` 를 명령어로 사용한다.

`fd` 와 비슷하게, Rust 로 작성되었다. `grep` 에 비해 출력으로 훨씬 다양한 정보를 얻을 수 있다. 명령어도 직관적이라 사용도 쉬운데 속도까지 빠르니 안쓸 이유가 딱히 없다.

그야말로 'RIP, grep'.

## lsd

![](https://i.imgur.com/VMB6SHj.png)

[GitHub - lsd-rs/lsd: The next gen ls command](https://github.com/lsd-rs/lsd)

`ls` 명령을 대체한다.

`ls` 명령은 어마어마하게 많이 쓰는 명령이다. 명령어 자체가 오래되었기도 하지만, 출력으로 알 수 있는 정보가 다양하지는 않다. `lsd` 를 사용하면 기존 `ls` 를 완전히 대체할 수 있다.

## bat

![](https://i.imgur.com/r04J8qn.png)

[GitHub - sharkdp/bat: A cat(1) clone with wings.](https://github.com/sharkdp/bat)

`cat` 명령을 대체한다.

`cat` 명령은 단순 출력이지만, `bat` 을 사용하면 code highlighting 을 누릴 수 있다. 어느 정도 눈치 빠른 개발자라면 라인 출력을 보고 '쉘 파이프라이닝을 방해하는거 아닐까' 걱정이 될 수 있지만,

![](https://i.imgur.com/VYxO8gx.png)

_필자는 `bat` 명령의 alias 를 `cat` 으로 설정하여 사용하고 있다._

전혀 방해하지 않는다. 걱정말고 신문물을 누려보자.

## [[HTTPie]]

[HTTPie – API testing client that flows with you](https://httpie.io/)

[[curl]] 을 대체한다.

APP 도 있어서 어느 글에 포함시켜야할까 고민을 했지만, 개인적으로는 cli 로만 사용하기 때문에 이쪽 글로 넣었다.

왜 curl 대신 [[HTTPie]] 를 선호하냐하면, 매우매우 직관적이기 때문이다. 간단한 GET 요청은 아래처럼 보낼 수 있다.

```bash
https httpie.io/hello
```

응답은 이렇게 포맷팅되어 온다.

![](https://i.imgur.com/A0sI2WH.png)

curl 응답을 떠올려보자. 개발자도 예쁜걸 좋아한다.

## [[Orbstack]]

[OrbStack · Fast, light, simple Docker & Linux](https://orbstack.dev/)

Docker Desktop 을 대체한다.

Docker 컨테이너를 사용할 때 조금 더 빨라지고 몇몇 버그들이 사라진다. 하지만 진정한 진가는 VM 을 사용할 때인데, 전통적으로 VM 을 쓰기 어려웠던 맥에서 VM 을 굉장히 가볍게 실행시킬 수 있다. 우분투나 칼리리눅스 등의 OS 에서 테스트가 필요할 경우, orbstack 을 사용하면 매우 빠르고 편리하게 관리할 수 있으니 사용해보자. 개인적으로 매우 재밌는 경험이었다.

## [[atuin]]

[GitHub - atuinsh/atuin: ✨ Magical shell history](https://github.com/atuinsh/atuin)

[[chezmoi, awesome dotfile manager|chezmoi]] 를 사용하면 사용하는 도구들의 설정은 동기화할 수 있었다. atuin 을 사용하면 회사에서 쳤던 명령어 history 를 동기화할 수 있다. 더 이상 회사에서 사용했던 명령어가 뭐였는지 기억해내려고 안간힘을 쓸 필요가 없다.

> [!warning]
> 한가지 아쉬운 점은 터미널로 Warp 를 사용한다면 온전히 atuin 을 활용하기 어렵다는 점이다. Warp 는 자체 history 기능을 제공하여 atuin 과 간섭이 있다. 아래 명령을 사용하면 history 에서 명령어 검색이 가능하여, 임시방편으로 쓰고 있다.
>
> ```bash
> atuin history list | fzf
> ```

## trash-cli

터미널에 '휴지통' 기능을 구현한다. 따라서 더 이상 `rm -rf /` 을 두려워할 필요가 없어진다. 얼마든지 복원이 가능하기 때문.

개발자 최대의 적인 `rm -rf /` 에서 자유로워질 수 있다는데, 그 이상의 이유가 필요한가?

## Conclusion

지금까지 개인적으로 매우 좋아하는 여러 툴들을 소개했다.

사실 이 외에도 추천할만한 도구는 얼마든지 더 있지만, 누가 뭘 추천해주든 자기 손에 익은게 제일 좋은 법이다. 나머지는 자신의 환경에 맞게 찾아써보자.

> [!info]
> 사용 중인 모든 툴은 [여기서](https://github.com/songkg7/dotfiles/blob/main/Brewfile) 볼 수 있다.
