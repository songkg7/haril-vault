---
title: "NeoVim"
date: 2022-09-06 20:46:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-06
aliases: 
tags: [vim, nvim, neovim]
categories: Vim
---

## Overview

일종의 [[Vim]] 확장이라고 할 수 있다.

## Install

```bash
brew install nvim
```

## Settings

```bash
nvim ~/.config/nvim/init.vim
```

## Plugins

## Sample

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
