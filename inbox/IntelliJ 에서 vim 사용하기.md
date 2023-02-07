---
title: "IntelliJ 에서 vim 사용하기"
date: 2022-08-23 22:00:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-23
aliases: IdeaVim
tags: [vim, ideavim, intellij]
categories: Vim
---

intelliJ 에서는 [[Vim]] 을 위해 `ideaVim` 이라는 플러그인을 제공한다.

```
"" Source your .vimrc  
"source ~/.vimrc  
Plug 'preservim/nerdtree'  
  
Plug 'easymotion/vim-easymotion'  
let mapleader=","  
map <Leader> <Plug>(easymotion-prefix)  
  
nmap \f :NERDTreeFind<CR>  
  
"" -- Suggested options --  
" Show a few lines of context around the cursor. Note that this makes the" text scroll if you mouse-click near the start or end of the window.

set scrolloff=5  
set surround  
set commentary  
set NERDTree  
set multiple-cursors  
set easymotion  
  
" Do incremental searching.
set incsearch  
  
" Don't use Ex mode, use Q for formatting.
map Q gq  
  
  
"" -- Map IDE actions to IdeaVim -- https://jb.gg/abva4t  
"" Map \r to the Reformat Code action  
"map \r <Action>(ReformatCode)  
  
"" Map <leader>d to start debug  
"map <leader>d <Action>(Debug)  
  
"" Map \b to toggle the breakpoint on the current line  
"map \b <Action>(ToggleLineBreakpoint)  

map <Tab>to <C-w>o<CR>:tabonly<CR>

"" switch tab
nmap <C-[> gT
nmap <C-]> gt
  
" Find more examples here: https://jb.gg/share-ideavimrc
```

프로젝트 디렉토리 같은 위치에서 마우스 우클릭이 필요할 경우: m

### 장점

When using vim with [[IntelliJ]],  you can:

- You can use a key as a shotcut that is not usually used as a shotcut. For example, you can edit keymap TAB + C for create changelist.

## Reference

- [ideaVim](https://bylee5.tistory.com/102)