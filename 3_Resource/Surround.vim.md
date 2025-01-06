---
title: Surround.vim
date: 2022-09-05T16:59:00
aliases: 
tags:
  - vim
  - plugin
categories: Vim
updated: 2025-01-07T00:35
---

## Tip

우선, 플러그인 작동 방식을 이해합니다.

- 감싸기: `ys`
- 삭제: `ds`
- 바꾸기: `cs`

```text
Old text                  Command     New text ~
"Hello *world!"           ds"         Hello world!
[123+4*56]/2              cs])        (123+456)/2
"Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
if *x>3 {                 ysW(        if ( x>3 ) {
my $str = *whee!;         vllllS'     my $str = 'whee!';
```

## 감싸기

## 한단어 감싸기

```test
I am happy.
I am "happy".
```

`ysiw"`: `ys` 감싸고, `iw` 커서가 위치한 단어를 선택한 후, `"` " 로 감싸기

b = )
B = }
r = ]
a = >

각 단어별로 괄호의 alias 로 지정되어 있다. ysiwa 의 경우 java 나 kotlin 에서 특히 유용하다.

## Reference

- [surround.vim 소개](https://forteleaf.tistory.com/entry/VIM-Surroundvim-사용하기)

## Links

- [[Vim]]
