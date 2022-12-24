---
title: "Vim"
date: 2022-10-21 15:30:00 +0900
aliases: 
tags: [vim]
categories: 
---

## Overview

Linux 를 비롯한 거의 모든 환경에서 사용이 가능한 에디터의 근본, Vim 에 대해서 알아본다.

## Vim 이란 무엇인가?

## 기본 단축키

Vim 은 기본적으로 방향키를 사용하지 않는다. 동작하지 않는다는 의미가 아니라 필요가 없다는 의미이다.

Vim 에서의 커서 이동은 hjkl 을 사용한다.

h: <-

j: 아래

k: 위

l: ->

### 단축키의 조합

### IntelliJ 를 강력하게, ideaVim

### Register

vim 은 기본적으로 register 를 사용하며 이는 클립보드에 저장하는 방식과 다르다. 때문에 클립보드와 함께 사용하고 싶다면 명령어를 통해 활성화하거나, 커맨드를 통해서 붙여넣기 및 복사를 할 수 있다.

clipboard 복사: `"+y`

### Settings

자세한 내용은 [[Vim settings]] 를 참조

#### .vimrc

```
let $LANG = 'en'
set termguicolors
```

#### Vim Plug

vim 은 플러그인을 통해 다양한 커스터마이징이 가능하다.

## Reference

- [키 조합에 대하여](https://github.com/johngrib/simple_vim_guide/blob/master/md/keys_basic.md)

## Links

- [[NeoVim]]
