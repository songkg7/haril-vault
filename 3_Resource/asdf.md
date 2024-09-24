---
title: asdf
date: 2023-11-02 18:03:00 +0900
aliases: 
tags:
  - tool
  - version-manager
categories: 
updated: 2023-11-02 18:03:34 +0900
---

## Install

설치는 [링크](https://asdf-vm.com/guide/getting-started.html)를 참조한다.

## Usage

asdf 는 플러그인을 추가하여 언어 버전 목록을 관리한다.

```bash
asdf plugin add nodejs
```

플러그인이 추가되면 설치 가능한 버전 목록을 확인할 수 있다.

```bash
asdf list all nodejs
```

원하는 목록을 선택하여 설치할 수 있으며 `latest` 를 입력하면 자동으로 최신 stable 버전을 설치한다.

```bash
asdf install nodejs latest
```

`asdf list` 로 설치된 언어 목록을 확인할 수 있다. 하지만 이 상태에서는 아직 언어 버전이 적용되지 않았다. 사용하기 위해서는 어떤 언어 버전을 사용할 것인지를 정확하게 지정해줘야 한다.

```bash
asdf global nodejs latest
```

언어 버전을 지정하면 `.tool-versions` 라는 파일에 지정한 언어 버전이 명시되어 있는 것을 볼 수 있다. asdf 는 이 파일로 어떤 언어 버전을 사용할 것인지 알려주어 환경을 일관되게 유지할 수 있다.

설정이 끝나면 이런 식으로 현재 사용 중인 언어별 버전을 확인할 수 있다.

![[Pasted image 20231102181634.png]]

## Reference

- https://asdf-vm.com/
