---
title: "AceJump"
date: 2023-01-12 17:16:00 +0900
aliases: 
tags: [vim, plugin, acejump, easymotion]
categories: 
---

[[Vim]]

vim 에서 원하는 위치로 정확하게 커서를 옮겨주는 플러그인.

보통 leader + w 등의 조합으로 사용하며, leader + f + 찾고자하는단어 등의 조합으로 사용할 수도 있다.

IntelliJ 에서는 [[IntelliJ 에서 vim 사용하기|IdeaVim]] 설정에 아래와 같이 해놓고 사용한다.

```
map <Leader> <Plug>(easymotion-prefix)
nmap <Leader>l <Plug>(easymotion-lineforward)
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader>h <Plug>(easymotion-linebackward)
nmap <Leader>a <Plug>(easymotion-jumptoanywhere) 
```
