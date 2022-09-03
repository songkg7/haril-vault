---
title: "Vim settings"
date: 2022-08-26 10:11:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-26
aliases: 
tags: [vim]
categories: 
---

## Overview

이 글에서는 [[Vim]] 에서의 다양한 플러그인 및 설정을 소개한다.

## Contents

### Multi cursor

mac 에서는 alt 키가 obtion 에 매핑되어 있는데, option 은 이모지 등 특수동작을 위해 매핑되어 있다. 이 기능은 multi cursor 보다 우선되어 동작하는데 키보드 레이아웃을 unicode 로 바꾸면 해결된다. 하지만 키보드 레이아웃을 unicode 로 바꾸는 것보다 option 대신 ctrl 에 매핑하는 방법으로 해결하는 것을 권장한다.

```
map <C-N>  <A-N>
map <C-P>  <A-P>
map <C-X>  <A-X>
map g<C-N> g<A-N>
```
