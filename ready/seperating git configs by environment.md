---
title: 환경별로 다른 git 설정 적용하기
date: 2025-07-06T09:54:56+09:00
aliases: 
tags:
  - git
description: 
updated: 2025-07-06T10:44
published: 2025-07-06
---

## TL;DR

- `includeIf` 문법을 사용하면 특정 조건을 만족하는 git 설정 파일만 적용할 수 있다.
- 업무 환경과 개인 환경을 분리하는데 유용하다.

## Problems

- 업무용 개발 환경과 개인 개발 환경이 분리되어 있다.
- 그런데 global git config 는 개인 환경 기준으로 설정해놓고 사용하다보니 [[chezmoi, basic settings|chezmoi]] 로 설정파일을 동기화할 때 업무 개발환경에 개인 설정이 overwrite 되어 적용되는 문제가 있었다.
- 어떻게해야 업무 환경과 개인 환경을 안정적으로 분리할 수 있을까?

## Solusion

[[Git]] 에는 이런 경우를 위해 조건별로 설정파일을 다르게 적용할 수 있는 방법을 제공한다. 바로 [includeIf](https://git-scm.com/docs/git-config#_includes) 이다. `include` 는 마치 모듈화처럼 외부 파일을 git 설정에 포함시키는 것인데, 여기에 조건식을 적용하여 특정 조건을 만족하는 경우에만 설정 파일이 포함되도록 하는 것이다.

몇몇 회사에서는 커밋 시 이메일과 이름을 체크하는 rule 이 있기 때문에, 이를 지켜주지 않으면 커밋 할 수 없다.

```bash
# ~/projects/company
git config --get user.email
# songkg7@gmail.com <- 회사 이메일이 아니라 개인 계정이 email 에 설정되어 있을 경우 커밋이 거절된다.
```

`user.name` 과 `user.email` 이 회사 계정으로 설정되도록 구성해보자. 먼저 `~/.gitconfig-work` 라는 파일을 만들고 다음처럼 필요한 설정을 정의해줬다.

```toml
# ~/.gitconfig-work
[user]
name = kyungkeun.song
email = kyungkeun.song@42dot.ai
```

```toml
# ~/.gitconfig OR ~/.config/git/config
[includeIf "hasconfig:remote.*.url:git@ssh.gitlab.42dot.ai:**/**"]
path = ~/.gitconfig-work

[includeIf "gitdir:~/projects/42dot/"]
path = ~/.gitconfig-work
```

위 쪽 설정은 git remote 경로가 정의된 경로로 설정되어 있다면 `~/.gitconfig-work` 설정을 포함시킨다. 아래쪽 설정은 디렉토리 기반 설정으로, git 이 호출되는 경로가 정의된 디렉토리 내라면 `~/.gitconfig-work` 설정을 포함시킨다. 두 설정을 함께 정의해서 혹시 모르는 규칙 위반이 발생하지 않도록 설정했다.

> [!NOTE]
> 개인적으로 HOME 경로에 설정파일들이 정리되지 않은 상태로 있는걸 좋아하지 않아서, `~/.config/` 이하 경로로 설정하는걸 선호하는 편이다.

이후 정의된 경로의 git directory 에 접근 한 뒤 user.name or email 을 확인해보면,

![](https://i.imgur.com/NBuF6bp.png)

`.git` 폴더가 생기기 전에는 개인 설정이 적용되다가, `.git` 폴더가 생기는 순간 `includeIf` 가 동작하여 업무 설정이 적용된 것을 확인할 수 있다.

## Conclusion

재택을 허용하는 회사라면 부득이하게 개인 장비를 가지고 업무를 해야하는 경우가 생길 수 있는데, 이럴 때 유용하게 사용될 수 있을 것이다.
