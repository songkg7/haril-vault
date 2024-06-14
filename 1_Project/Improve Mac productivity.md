---
title: Improve Mac productivity
date: 2024-01-24 14:23:00 +0900
aliases: 
tags:
  - productivity
  - tool
  - inflearn
categories: 
updated: 2024-06-14 21:37:01 +0900
---

> 인프런 생산성 강의 촬영을 위해 정리

SCQA

- Situation
- Complication
- Question
- Answer

## 1. 입문

> 개발자가 아니여도 누구에게나 유용

- Raycast
- Rantangle
- 1Password
- alt-tab
- hiddenbar
- shottr
- gureumkim(구름 입력기)
- Amphetamine
- WeatherBug
- [[Notion]]
- [[Obsidian]]
- [[Arc]]
- Spark Desktop
- Notion Calendar

## 2. 초급

> 모든 소프트웨어 엔지니어

먼저, 여기서부터 맥의 언어설정은 영어를 추천. 영어 학습을 위해서다 이런 흔한 이유보다도 훨씬 실용적인 이유가 있습니다. 한글은 명실상부 우수한 언어지만, 터미널에 친화적이진 않습니다. 자모음이 합쳐지면서 하나의 글자를 형성하는 특성때문인데 파일 구성 요소 중 한글이 섞여있다면 여러가지 귀찮은 상황을 마주하게 될 수 있습니다.

- 대표적으로 스크린샷의 경우, 언어설정이 한글일 경우 prefix 에 `스크린샷`이라는 한글이 포함되기 때문에 CLI 검색이 귀찮아집니다. 영어일 경우 screenshot 이라고 생성됨.
- 클라우드 스토리지를 사용하는 경우, `충돌된 파일` 이라는 한글이 포함되면 `conflicted` 라는 영단어를 검색하는 것에 비해 매우 번거로워짐. 한글은 자소분리가 발생할 수 있음.

따라서 언어설정은 영어로 하여, 모든 디렉토리나 자동으로 생성되는 파일들이 영어로 생성될 수 있도록 하는걸 추천합니다.

- Warp or iTerm2
- [[Homebrew]]
- [[asdf]] or [[mise]]
- tldr
- zoxide
- [[HTTPie]]
- direnv
- walk
- [[atuin]]
- bat
- fd
- ripgrep
- lsd
- RunCat
- Clop (파일 용량 감소)
- @ figlet
- @ lolcat

## 3. 중급

> 명령어보다 GUI 가 익숙한 대부분의 개발자

- [[fzf]]
- karabiner-elements
- 1password-cli
- [[chezmoi, awesome dotfile manager|chezmoi]][^1]
- orbstack
- git-number
- fx
- htop or bottom

## 4. 고급

> Vim 에 익숙하며, Terminal 이 근본이라고 생각하는 개발자

- [[Vim]], [[NeoVim]], Lunarvim
- yabai and skhd
- ranger
- lazygit
- homerow

[^1]: 여러 기기를 사용하는 경우 필수, 기기가 1대라면 불필요

---

- alt-tab
- hiddenbar
- shottr
- gureumkim(구름 입력기)
- [[Notion]]
- [[Obsidian]]
- [[Arc]]
- Spark Desktop
- Notion Calendar

난이도보다는 유저 스토리에 초점을 맞춰서 강의를 설계해보라는 피드백을 받았고, 이를 적용해보려고 한다.

## 생산성

### alt-tab

#### Situation

여러 앱들이 열려있는 상태에서 포커스를 이동시키고 싶다.

#### Complication
 
 앱 간 전환을 위해 `cmd + tab` 을 사용해보니 열려있는 크롬 창은 여러개지만 화면에 보이는 크롬 아이콘은 하나뿐.
#### Question

같은 앱을 여러 윈도우로 사용할 때, 정확히 특정 윈도우로 포커스를 이동시키려면 어떻게 해야 하나?

#### Answer

alt-tab 을 사용하면 윈도우에서 사용하던 포커스 전환 경험을 맥에 그대로 이식할 수 있다.

### Amphetamine

#### Situation

업무 중 잠깐만 자리를 비워도 화면이 잠긴다.

#### Complication

하루에도 몇 번씩 잠긴 화면을 해제해야 한다.

#### Question

최소한 업무시간에는 화면이 잠기지 않게 할 수 있을까요?

#### Answer

Amphetamine 을 사용하면 특정 시간 등 조건에 따라 화면이 잠기지 않도록 제어할 수 있습니다. 보안을 위해 화면을 잠궈야 하는 경우까지 방해하지는 않으며, 시간의 흐름에 따라 잠기는 경우만 방지해줍니다.

### WeatherBug

맥의 상단에 현재 기온과 날씨를 표시해주는 간단한 앱

### Raycast

맥의 spotlight 기능은 원하는 앱이나 설정, 혹은 파일에 빠르게 접근하게 해주는 굉장히 편리한 기능이에요. 애플의 공식 기능인만큼 UI 도 유려하고 자연스러운 동작을 보여주지만, spotlight 는 확장성에 조금 아쉬움이 있었어요. 애플이 제공하는 기능 외적으로는 사용하기 힘들었죠.

- Alfred 에서는 IntelliJ 의 특정 프로젝트를 실행하고 싶어도, IntelliJ IDEA 까지만 접근가능

Raycast 는 이 spotlight 의 기능에 확장성을 추가하여 다양한 조작을 가능하게 해주는 툴이에요.

- DeepL 을 설치하여 번역기능 추가 가능
- 음악 재생 및 정지
- 단축어 실행
- KakaoMap 최단 경로 탐색
- HotKey 기능

익숙해진다면 원하는 앱 및 기능에 매우 빠르게 접근하는 것이 가능하죠.

### Rectangle

맥은 화면분할이 윈도우에 비해서 조금 불편한 편이에요. 그래서 여러 툴들이 만들어졌고 사용되고 있어요. Rectangle 은 무료로도 충분한 기능을 사용할 수 있기 때문에 추천하는 윈도우 매니저입니다.

여러 단축키들로 다양한 기능을 사용할 수 있어요. 대표적으로 `ctrl + option` key 조합 정도만 알아둬도 충분히 쓸만한 것 같아요.

%% 단축키 리스트 몇가지 작성 %%

### 1Password (유료)

> 3.99$

Mac 및 윈도우를 가리지 않고 사용가능한 Password Manager. 터미널에 익숙한 개발자가 사용하게 된다면, 패스워드 관리를 뛰어 넘어 굉장히 강력해지게 되요. 가격도 저렴한 편이라, 큰 부담없이 사용할 수 있는 점도 메리트.

## 디자인

## 문서

### Obsidian

지식은 계층이 아니라 그래프

## 터미널

### iTerm2 or Warp

개인적으로는 warp 를 조금 더 추천.
