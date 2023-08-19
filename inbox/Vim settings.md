---
title: Vim settings
date: 2022-08-26 10:11:00 +0900
aliases: null
tags:
  - vim
categories: null
updated: 2023-08-19 12:38:07 +0900
---

## Overview

이 글에서는 [[Vim]] 에서의 다양한 플러그인 및 설정을 소개한다.

## Contents

### Neovim

init.vim

```
set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'preservim/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'

call plug#end()

set nu
set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
set termguicolors

map <F3> :NERDTreeToggle<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


let g:fzf_preview_window = ['right,50%', 'ctrl-/']
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
  \ }

let g:gruvbox_contrast_dark="hard"
set background=dark
autocmd vimenter * colorscheme gruvbox 
```

.vimrc

```
let $LANG = 'en'
set termguicolors 
```

## Plugins

### Multi cursor

mac 에서는 alt 키가 obtion 에 매핑되어 있는데, option 은 이모지 등 특수동작을 위해 매핑되어 있다. 이 기능은 multi cursor 보다 우선되어 동작하는데 키보드 레이아웃을 unicode 로 바꾸면 해결된다. 하지만 키보드 레이아웃을 unicode 로 바꾸는 것보다 option 대신 ctrl 에 매핑하는 방법으로 해결하는 것을 권장한다.

```
map <C-N>  <A-N>
map <C-P>  <A-P>
map <C-X>  <A-X>
map g<C-N> g<A-N>
```

## Surround

[[Surround.vim]]

### Copilot

### fzf.vim
