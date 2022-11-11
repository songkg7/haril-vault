---
title: "Vim"
date: 2022-10-21 15:30:00 +0900
aliases: 
tags: [vim]
categories: 
---

## Overview

## Contents

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
