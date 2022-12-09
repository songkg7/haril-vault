---
title: "Warp + starship + nerd font"
date: 2022-11-21 17:04:00 +0900
aliases: 
tags: [terminal, custom, warp, starship, nerd-font]
categories: 
---

## Overview

iTerm2 는 Mac OS 에서 사용하는 강력한 터미널이였습니다. 자동완성 및 다양한 커스텀 기능들로 인해서 개발자들에게 많은 편의성을 제공해왔죠. 하지만 이제는 더 세련된 터미널이 등장한 것 같습니다. 이번 게시글에서는 Warp 에 대한 간단한 소개와 제가 쓰는 약간의 커스텀 설정을 소개합니다.

## Content

### Warp

warp 는 차세대 터미널로서, 다양한 편집 기능 및 자동완성, AI 기반의 명령어 추천 기능등을 제공합니다. 특히 AI recommand 기능은 익숙해질 경우, 구글링하는 시간을 굉장히 단축시켜주기 때문에 생산성 향상에 아주 탁월합니다.

### Starship

starship 은 ruby 기반의 터미널 커스텀 툴입니다. Warp 는 iTerm 과는 달리 어느 정도 warp 만의 UI 를 강제하는 측면이 있는데 starship 을 사용하면 이 제약 안에서 최대한 커스텀이 가능합니다.

iTerm2 에서 많이 사용하는 powerlevel10k 는 아직 warp 에서 지원하지 않습니다.

### Nerd Font

터미널에 특화되어있는 이모티콘을 출력하기 위해 필요한 font 입니다. 관련 폰트들이 설치되어 있지 않을 경우, 아이콘이 출력되지 않을 수 있습니다.

아래에서 원하는 폰트만 설치하셔도 무방합니다.

```bash
brew tap homebrew/cask-fonts && brew install --cask font-3270-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-fira-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-inconsolata-go-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-inconsolata-lgc-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-inconsolata-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-monofur-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-overpass-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-ubuntu-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-agave-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-arimo-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-anonymice-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-aurulent-sans-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-bigblue-terminal-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-bitstream-vera-sans-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-blex-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-caskaydia-cove-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-code-new-roman-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-cousine-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-daddy-time-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-dejavu-sans-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-droid-sans-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-fantasque-sans-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-fira-code-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-go-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-gohufont-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-hasklug-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-heavy-data-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-hurmit-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-im-writing-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-iosevka-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-lekton-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-liberation-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-meslo-lg-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-monoid-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-mononoki-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-mplus-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-noto-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-open-dyslexic-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-profont-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-proggy-clean-tt-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-roboto-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-sauce-code-pro-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-shure-tech-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-space-mono-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-terminess-ttf-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-tinos-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-ubuntu-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-victor-mono-nerd-font
```

## Conclusion

## Reference

- [Warp](https://www.warp.dev)
