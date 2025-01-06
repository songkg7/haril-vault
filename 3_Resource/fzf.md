---
title: fzf
date: 2022-10-19T11:12:00
aliases: 
tags:
  - fuzzy
  - fzf
  - find
categories: 
updated: 2025-01-07T00:35
---

터미널이나 vim 에서 파일 검색을 굉장히 효율적으로 도와주는 라이브러리. 다양한 응용이 가능하다.

## Install

기본 옵션을 설정해둘 경우 더욱 편리하게 이용이 가능하다.

```bash
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
```

## Search syntax

| Token     | Match type                 | Description                          |
| --------- | -------------------------- | ------------------------------------ |
| `sbtrkt`  | fuzzy-match                | Items that match `sbtrkt`            |
| `'wild`   | exact-match (quoted)       | Items that include `wild`            |
| `^music`  | prefix-exact-match         | Items that start with `music`        |
| `.mp3$`   | suffix-exact-match         | Items that end with `.mp3`           |
| `!fire`   | inverse-exact-match        | Items that do not include `fire`     |
| `!^music` | inverse-prefix-exact-match | Items that do not start with `music` |
| `!.mp3$`  | inverse-suffix-exact-match | Items that do not end with `.mp3`    |

## Tip

### cd

```bash
alias sd="cd ~ && cd \$(find * -type d | fzf)"
```

alias 를 설정하여 더욱 편하게 사용할 수 있다. 하지만 권한 관련 에러는 조심.

## Reference

- [fzf](https://github.com/junegunn/fzf)
