---
title: Aerospace
date: 2024-06-22 16:22:00 +0900
aliases: 
tags:
  - display
  - window-manager
  - tiling
  - yabai
  - tool
categories: 
updated: 2024-11-08 17:46:53 +0900
---

- 윈도우 매니저
- [[yabai]] 의 대체
- yabai 는 skhd 를 사용하여 단축키를 관리했는데, aerospace 는 자체적으로 단축키를 설정할 수 있다.
- yabai 는 업데이트될 때마다 시스템 권한을 요구했기에 귀찮은 점이 있었다.
- Aerospace 는 자체적으로 워크스페이스를 지원하여 맥의 윈도우를 추가하지 않아도 된다.
- mode 를 설정하면 같은 단축키여도 모드에 따라 다르게 동작하도록 설정이 가능하다.
- [[Loop]] 를 함께 사용하면 floating 윈도우 설정이 조금 더 간편하다.

## Pros

- 명령어를 매핑하기 위해 skhd 같은 부가적인 툴이 필요없음
- 제공되는 명령이 많고 직관적이며 구성이 유연함
- mode 변경을 통해 같은 키로도 다른 동작을 실행할 수 있음
- 멀티 모니터 환경에서도 잘 동작

## Cons

- 일종의 가상 그룹인 워크스페이스로 전환이 부드럽지 않고, 이유는 정확하지 않지만 맥OS 의 기본 기능인 mission control 의 UI 를 과하게 작게 표시하는 문제가 있음
    - `defaults write com.apple.dock expose-group-apps -bool true && killall Dock` 명령을 사용하여 앱별로 그룹화하면 해결 가능

## Reference

- https://github.com/nikitabobko/AeroSpace
- https://nikitabobko.github.io/AeroSpace/guide
