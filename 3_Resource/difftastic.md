---
title: difftastic
date: 2022-11-09T12:53:00
aliases: 
tags:
  - tool
  - git
  - diff
categories: 
updated: 2025-01-07T00:35
---

## Overview

`git diff` 를 좀 더 편리하게 사용할 수 있도록 만들어주는 툴

It is a diff tool that prints more intuitively. If you often use [[Git]] at terminal, it can be very useful.

## Usage

```bash
brew install difftastic
```

global setting: 

```bash
git config --global diff.external difft
```

Now, we can use difftastic by default.

awesome! It looks better than before default git diff.

![[스크린샷 2022-11-09 오후 1.00.44.png]]

## Reference

- [difftastic](https://difftastic.wilfred.me.uk/introduction.html)
