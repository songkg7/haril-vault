---
title: "Vim"
date: 2022-10-21 15:30:00 +0900
aliases: 
tags: [vim]
categories: 
---

## Overview

본문으로 들어가기 전에 영상을 하나 보고 시작합니다.

[Flutter Focus Nvim/Nvchad](https://www.youtube.com/watch?v=lr7YpK6rrAM)

멋지지 않은가요?

이 글에서는 Linux 를 비롯한 거의 모든 환경에서 사용이 가능한 에디터의 근본, Vim 에 대해서 알아보고 사용법에 대해서 설명합니다.

## Vim 이란 무엇인가?

Vim(빔, Vi iMproved)은 Bram Moolenaar 가 만든 vi 호환 텍스트 편집기이다. 개선된 vi 라는 뜻이며 vi 에 비해서 다양한 기능이 추가되었고 현재는 그 구분이 모호할 정도로 vim 이 널리 쓰이고 보편화되어 있다.

## 기본 단축키

vim 의 기초는 `vimtutor` 를 통해서도 배울 수 있다. 공식 문서를 통해 배워보고 싶다면 활용해보자.

```bash
vimtutor
```

Vim 은 기본적으로 방향키를 사용하지 않는다. 동작하지 않는다는 의미가 아니라 필요가 없다는 의미이다.

Vim 에서의 커서 이동은 hjkl 을 사용한다.

h: <-

j: 아래

k: 위

l: ->

처음엔 어색할 수 있지만, hjkl 에 익숙해진다면 방향키보다 훨씬 빠르고 편리한 이동을 보장한다.

`i` 를 누르면 왼쪽 하단에 INSERT 라고 표시되며 편집 가능한 상태가 된다. 이 상태에서는 일반적인 에디터와 비슷하게 동작한다. 다시 hjkl 로 이동하고 싶은 상태로 오려면 `esc` 를 누르면 된다. `hjkl` 를 통해 이동이 가능한 이 상태를 `normal` mode 라고 부르며 mode 에 대해서는 이후 다시 설명한다.

### 저장 및 종료

normal mode 에서 `:w` enter 를 입력하면 현재 편집 중이던 문서가 저장된다. 이후 `:q` enter 를 입력하면 vim 이 종료된다. `:wq` 를 입력하면 저장 후 종료가 된다.

만약 현재 작업 중인 내용을 drop 하고 강제로 종료하고 싶다면, `:q!` 를 사용할 수 있다.

vim 에서 탈출하고 싶다면 지금이 마지막 기회가 될지도...

### 지우기 및 되돌리기

normal mode 에서 `x` 를 누르면 커서가 위치한 곳의 글자를 지울 수 있다. 실수로 잘못 지웠다면 `u`(undo) 를 눌러서 변경내역을 되돌릴 수 있다.

이제 편집을 위한 준비는 끝났다. 지금까지는 일반적인 에디터와 단축키만 다를 뿐이지 그렇게  다음부터는 진정한 vim 의 방식대로 편집을 하는 법을 알아보자.

## Mode

vim 에는 4가지 모드가 존재한다.

1. Normal
2. Insert
3. Visual
4. Command

vim 을 처음 실행하면 normal mode 인 상태로 실행된다. vim 이 다른 에디터와의 차이 중 가장 큰 점이라면 바로 이 normal mode 의 존재라고 할 수 있다. 일반적인 에디터는 항상 입력이 가능한 상태이므로 기본 character 들을 단축키로 활용할 수 없지만, normal mode 에서는 입력되지 않으므로 a, d, m, g 등을 단축키로 활용할 수 있게 된다.

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
