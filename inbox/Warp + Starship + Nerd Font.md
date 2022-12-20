---
title: "Warp + starship + nerd font"
date: 2022-11-21 17:04:00 +0900
aliases: 
tags: [terminal, custom, warp, starship, nerd-font]
categories: 
---

## Overview

iTerm2 는 MacOS 에서 사용하는 강력한 터미널이였습니다. 자동완성 및 다양한 커스텀 기능들로 인해서 개발자들에게 많은 편의성을 제공해왔죠. 하지만 이제는 더 세련된 터미널이 등장한 것 같습니다. 이번 게시글에서는 Warp 에 대한 간단한 소개와 제가 쓰는 약간의 커스텀 설정을 소개합니다.

## Content

### Warp

warp 는 차세대 터미널로서, 다양한 편집 기능 및 자동완성, AI 기반의 명령어 추천 기능등을 제공합니다. 특히 AI recommand 기능은 익숙해질 경우, 구글링하는 시간을 굉장히 단축시켜주기 때문에 생산성 향상에 아주 탁월합니다.

```bash
brew install warp
```

### Starship

starship 은 ruby 기반의 터미널 커스텀 툴입니다. Warp 는 iTerm 과는 달리 어느 정도 warp 만의 UI 를 강제하는 측면이 있는데 starship 을 사용하면 이 제약 안에서 최대한 커스텀이 가능합니다.

iTerm2 에서 많이 사용하는 powerlevel10k 는 아직 warp 에서 지원하지 않습니다.

```bash
brew install starship
```

### Nerd Font

터미널에 특화되어있는 이모티콘을 출력하기 위해 필요한 font 입니다. 관련 폰트들이 설치되어 있지 않을 경우, 아이콘이 출력되지 않을 수 있습니다.

개인적으로는 Hack nerd font 를 사용하고 있습니다.

## Conclusion

## Reference

- [Warp](https://www.warp.dev)
