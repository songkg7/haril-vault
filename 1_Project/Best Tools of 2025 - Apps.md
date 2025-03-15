---
title: 알아두면 쓸데있는 개발자 도구 - App 편
date: 2024-10-01T14:10:00
aliases: 
tags:
  - inflearn
  - tool
  - productivity
  - lecture
categories: 
description: 
updated: 2025-03-16T00:01
---

## Overview

MacOS 사용 10년 이상.

개발자를 위해 추천할만한 앱들을 정리해본다. 평소 자주 사용하는 도구들로만 모았으며, 최소 6개월이상 꾸준히 써온 도구만 작성했다. CLI 에 익숙하지 않은 분들을 위해 본 글은 App 편과 CLI 편, 총 2편으로 나누어 작성한다.

> [!info]
> 소개된 모든 도구는 `brew` 명령을 통해 설치할 수 있다.

## Raycast

[Raycast - Your shortcut to everything](https://www.raycast.com/)

단연컨데, 부동의 원탑. 만약 MacOS 에 단 하나의 앱만 깔 수 있다면 주저없이 Raycast 를 고르겠다.

경쟁도구로는 Alfred 가 있지만, 이미 강하게 Alfred 에 락인된게 아니라면 Raycast 로 넘어오길 강력하게 추천. 어느 정도냐하면 Alfred 에 락인된 경우에도 넘어오길 추천한다.

Raycast 에 대한 소개는 존경해마지않는 숑숑님께서 이미 잘 작성해주셔서 아래 글을 참고해주시길 바라며 이 글에서는 생략한다.

- [생산성에 진심인 자의 Raycast 세팅 엿보기 (for macOS)](https://velog.io/@wisepine/%EC%83%9D%EC%82%B0%EC%84%B1%EC%97%90-%EC%A7%84%EC%8B%AC%EC%9D%B8-%EA%B0%9C%EB%B0%9C%EC%9E%90%EC%9D%98-Raycast-%EC%84%B8%ED%8C%85-%EC%97%BF%EB%B3%B4%EA%B8%B0-for-macOS)

## AltTab

![](https://i.imgur.com/72f2zUw.png)

[AltTab - Windows alt-tab on macOS](https://alt-tab-macos.netlify.app/)

MacOS 의 앱 전환 UX 는 처참하기 그지없다. [[Chrome]] 같은 브라우저는 윈도우를 여러 개 띄워놓기도 하는데, 기본 앱 전환은 Chrome 아이콘 하나만 보여주기에 원하는 창으로 바로 전환하기 어렵다. WindowOS 에 익숙한 유저라면 더더욱 어색하다고 느껴질 부분이다.

AltTab 은 이런 문제를 완벽하게 해결해주어 훨씬 직관적으로 앱 전환을 할 수 있게 해준다. 불이익없이 순수하게 이익만 발생하는 앱이므로 반드시 설치해서 사용해볼 것을 권장한다.

## [[Loop]]

[GitHub - MrKai77/Loop: Window management made elegant.](https://github.com/MrKai77/Loop)

> 창분할 및 관리

Rectangle 이나 Magnet 을 이미 불편함없이 쓰고 있다면, 굳이 필요하지 않을 수 있겠다. 다만 Loop 는 방향키를 분할에 사용하고 애니메이션을 통해 직관적인 UX 를 제공한다. 만약 창 분할 도구를 써본 적이 없다면 Loop 로 시작해보자.

## Aerospace Beta

[GitHub - nikitabobko/AeroSpace: AeroSpace is an i3-like tiling window manager for macOS](https://github.com/nikitabobko/AeroSpace)

**창을 열 때마다 자동으로 분할**된다. Workspace 기능이 있어서 화면을 그룹화하여 빠르고 편리하게 관리할 수 있다. 만약 필자처럼 마우스를 거의 사용하지 않는 Vim 유저라면 특히 유용하다.

## 구름 입력기

[구름 입력기 - macOS를 위한 새로운 한글 입력기](https://gureum.io/)

'모아치기' 라는 꽤나 신기한 기능을 제공하는데, 자모음의 순서를 바꿔서 입력해도 음절을 정확하게 완성해주는 기능이다. 이게 생각보다 오타율을 꽤나 줄여준다. 평소 오타가 잦다면 한 번 써봄직하다.

> [!warning]
> 구름입력기를 활성화한채로 Confluence 등의 웹 에디터에서 글자를 입력하면 마지막 글자가 사라지는 버그가 있는데 도구 자체의 버그인지는 확실하지 않다.

## Input Source Pro

[Input Source Pro - Switch and track your input sources with ease](https://inputsource.pro/)

특정 앱에 언어를 지정해놓으면, 해당 앱으로 전환이 발생할 시 현재 입력 소스를 지정된 언어로 변경한다.

[[IntelliJ IDEA]] 등 한글을 거의 입력하지 않는 IDE 의 기본 언어로 영어를 지정해두면, 해당 앱으로 전환이 발생할 때 별도의 한/영키 입력없이도 입력 소스가 영어로 변경된다는 의미다. 반대의 경우도 마찬가지.

입력 소스가 변경될 때는 작은 팝업이 잠깐 표시되기 때문에, 변경을 직관적으로 알 수 있어서 더욱 편리하다.

## Shottr

[Shottr – Screenshot Annotation App For Mac](https://shottr.cc/)

MacOS 의 기본 캡쳐는 캡쳐 직후 편집이 다소 번거롭다. shottr 을 사용하면 개발자들이 자주 사용할만한 blur, box, crop 등을 단축키로 적용가능하고 결과물을 즉시 클립보드로 복사해준다. 세로로 긴 웹 화면 캡쳐시 유용한 스크롤 캡쳐는 덤. 기본 캡쳐 단축키를 비활성화하고 shottr 에서 해당 단축키를 그대로 적용하는 방식으로, 최대한 위화감없이 기본 캡쳐 기능을 대체하여 사용 중이다.

## Warp

[The intelligent terminal \| Warp](https://www.warp.dev/i)

기본적으로 필요한 기능을 다 갖추고 있다. 특히 리눅스 명령어에 익숙하지 않은 사람도 바로 SRE 경력자로 만들어주는 wrapping 기능은 놀랍다.

Election 이 아닌 Rust 로 작성된 자체 프레임워크로 구현되었는데, 그래서 그런지 꽤 많은 기능을 제공함에도 빠르게 동작한다. 새로운 기능의 추가도 엄청 적극적으로 이루어지고 있어서, '갑자기 패치가 없어지면 어쩌지' 하는 걱정도 필요없다. 어떤 터미널을 써야할지 모르겠다는 사람은 그냥 맘편히 Warp 를 써보자.

## Ghostty

[Ghostty](https://ghostty.org/)

iTerm2 는 유명하지만 현재는 (Warp 를 제외하더라도) 더 세련되고 우아한 터미널이 너무 많다. 그동안의 옛정이 아니라면 요즘 iTerm2 는 그다지 매력적이지 않다... 고 생각하는 그대에게 Ghostty 를 추천해본다.

Warp 를 사용하지만 새로운 도구는 항상 살펴본다. Ghostty 는 그 중에서도 인상적인 터미널 에뮬레이터다. 가장 좋은건 설정이 간편하다는 점이다. iTerm2 를 커스텀할 때처럼 머리 싸매고 이것저것 안해도 기본적인건 내장되어 있어서 정말 좋았다.

## Homerow

[Homerow — Keyboard shortcuts for every button in macOS](https://www.homerow.app/)

마우스없이 vim 방식으로 Mac 을 제어할 수 있다. 유료지만, vim 유저라면 굉장히 유용하다.

## Apidog

[Apidog An integrated platform for API design, debugging, development, mock, and testing](https://apidog.com/)

Postman 은 많은 사람들이 사용하는 유명한 도구지만, 보안 패치가 꽤 오래 진행이 안되는 등의 문제가 많아서 그다지 정이 가지 않았다. 차라리 HTTPie 나 curl 등의 CLI 를 쓰거나, IDE 내에서 제공하는 `.http` 파일을 사용하는걸 추천하게 될 정도. 외부 요인으로 인해 선택의 여지가 없는게 아니라면 Postman 보다는 다른 도구를 살펴보길 권해본다.

그 다른 도구가 바로 Apidog 이다. 처음 봤을 때 세련된 UI/UX 에 한 번 놀랐고, 문서를 편리하게 생성할 수 있는 점에 두 번 놀랐다. 사용법 자체는 Postman 과 크게 다르지 않으니, 금방 적응할 수 있을 것이라 생각한다.

## Markdown Editor

- [[Obsidian]]

초기 진입장벽은 좀 있지만, 가볍고 플러그인으로 기능의 추가가 자유로워서 개발자 친화적이다. 로컬에서 파일을 관리하기 때문에 백업이 용이하고, 특정 니즈에 맞추는 자동화를 매우 유연하게 적용할 수 있다.

요즘은 인터넷이 안되는 곳이 거의 없긴하지만, 비행기 안에서도 문서 편집이 무리없이 가능한 점도 소소한 장점.

최근 [요금 관련 정책이 변경](https://obsidian.md/blog/free-for-work/)되어 회사에서도 라이센스없이 사용가능해졌기 때문에, 더욱 부담없이 접근할 수 있게 되었다.

## 1Password

1Password 를 좀 더 추천한다. 가격이 크게 비싸지도 않고, 거의 모든 환경에서 잘 동작한다. Bitwarden 은 무료지만 직접 설치하여 관리해야해서 조금 번거롭다.

## Ice

[GitHub - jordanbaird/Ice: Powerful menu bar manager for macOS](https://github.com/jordanbaird/Ice)

hidden-bar 를 완전히 대체한다.

최신형 맥북은 디스플레이 상단에 노치가 생겨서 hidden-bar 를 사용할 경우 숨겨진 영역이 노치에 가려서 확인하기 어려웠는데, ice 를 사용할 경우는 숨겨진 영역을 팝업으로 표시할 수 있어서 간섭이 생기지 않는다.

## Conclusion

Application 위주로 선별했다. 다음은 CLI 위주로
