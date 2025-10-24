---
title:
date: 2025-09-18T22:54:31+09:00
aliases:
tags:
  - package-manager
  - os
description:
updated: 2025-10-06T19:14
---

Nix = language, package manager, and ci buildkit

- 허들이 높다고 알려져있는 패키지 매니저
- [[chezmoi, awesome dotfile manager|chezmoi]] 와 [[mise]] , [[Homebrew]] 를 대체할 수 있다
- [[chezmoi, awesome dotfile manager|chezmoi]] 는 configuration 파일을 복사하는 정도라 패키지 설치에는 brew 에 의존해야 하지만, Nix 는 외부 의존성없이 선언형으로 관리할 수 있다
- [[NixOS]] 라는 리눅스 배포판도 존재한다.
    - NixOS 는 리눅스의 패키지 매니저로 apt 대신 nix 를 사용한다.
- CI/CD 구성에서 강점을 가진다. 로컬에서 동작했다면 서버에서 동작하는 것을 보장한다.
    - 코드로 모든 것을 관리할 수 있다.
    - It works on my machine 문제 해소
- 롤백이 매우 간편하다.
- 개인 서버 운영시 학습에 투자할 가치가 높아진다. 로컬과 서버 모든 환경에서 nix 를 통해 일관된 관리가 가능하고 동작을 보장할 수 있기 때문
- nixvim 을 통해 vim 설정을 할 수 있다. [[AstroNvim]] 도 nixvim 을 사용하면 가능할듯.
    - home.file 을 사용해서 astro 설정을 복사하여 설정
- direnv 와의 통합을 제공한다. nix develop 을 자동화한다.
    - [[mise]] 도 연동할 수 있는것으로 보이는데 실험해봐야겠다.
- slack 같은 GUI 를 관리할 때 앱 메타정보가 변경되면서 crash 가 잦으므로, GUI 만 [[Homebrew]] 로 관리하는 것도 방법이 될 수 있겠다.
    - nix 에서 homebrew 와의 연동을 지원하므로, 직접 brew 명령을 쳐야할 필요는 없다. 정의된 casks 에 대해서만 nix 가 brew 로 설치한다.
- [[Homebrew]] module 에 버그가 있다. arm64 architecture 를 인식하지 못하고 homebrew prefix 를 잘못 설정한다.
    - determinate-nix 를 사용할 경우에만 발생하는 문제로 보인다.
    - 정확한 원인을 파악하지 못했기 때문에 다음에 다시 실험해보자.
- agenix 를 사용하면 민감한 정보도 관리할 수 있다. 다만 기본적으로 nix 는 재현가능한 불변성을 추구하므로, 수정이 필요하면 system rebuild 를 해야 한다.
    - mise + chezmoi 로 관리하는만큼의 편리함은 기대하기 어렵다.
    - 자주 수정되지 않는 변수라면 Nix 로 쓸 수 있겠다.
- agenix 로 민감정보를 관리하려면,
    - secrets.nix 에 어떤 이름으로 사용할건지, 어떤 public key 를 사용할건지 정의
    - age.nix 를 수정하여 secret 정의
    - 사용할 prrograms 에서 age.nix 에 정의된 값으로 사용
    - credential 내용을 수정하려면 `agenix -e secret.age` 로 수정
- chezmoi 는 `chezmoi add --encrypted <file.name>` 이면 끝인데 agenix 이건 너무 불편하지 않나?
    - `chezmoi --edit file.name` 으로 바로 편집 화면이 열린다.
    - 마찬가지로 age 를 사용하여 암호화 복호화를 처리한다.
- 하이브리드로 사용할 경우 불편한 점이 있을까?
    - PoC 나 언어 버전을 명시해두는 mise config 처럼 자주 변경되는 파일은 nix 로 관리하면 불변 symbolic link 특성상 너무 불편하다.
    - [[chezmoi, awesome dotfile manager|chezmoi]] 와 병행하면서 변경되는 수준에 따라 나눠서 관리하는게 좋겠다.
- 반면 chezmoi 는 항상 파일을 통째로 관리해야하는데, Nix 는 파일의 특정 부분만 환경별로 변경하는 등 매우 유연하게 관리할 수 있는 점은 장점이다.

## 단점

- Nix 언어에 대해 익숙해져야 한다
- 매우 방대한 패키지들이 있지만, 기본적으로 가이드는 [[Homebrew]] 가 많기 때문에 설치를 위해서는 별도로 문서를 찾아봐야 한다.
- slack 같은 GUI 처리가 번거롭다.

## 언제 써야할까?

- 특정 프로젝트에서만 사용되는 도구라서 글로벌로 설치하기 부담스러울 때
- 개인 서버를 운영하고 있을 때

## 시작하기

- [Zero to Nix](https://zero-to-nix.com/) 을 통해 학습해보는 것을 추천

### Install

설치에는 두가지 방법이 있다.

- Official: [Download \| Nix & NixOS](https://nixos.org/download/)

Determinate Nix Installer 

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## features

### file copy

```nix
home.file."target-path".source = ./original-file
```

## Conclusion

## Reference

- [PyCon KR 2023 Python 개발자를 위한 Nix 김수빈 - YouTube](https://www.youtube.com/watch?v=Y5NHZ1YXnM4)