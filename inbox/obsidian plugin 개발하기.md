---
title: "obsidian plugin 개발하기"
date: 2023-02-13 08:59:00 +0900
aliases: 
tags: [obsidian, plugin, side-project, typescript]
categories: 
---

# O2

> Obsidian to

## 문제인식

jeykell 블로그를 사용하여 포스팅을 하고 있기 때문에 [[Obsidian 사용 후기|Obsidian]] 의 markdown 문법과 일부 호환되지 않는 현상이 있다. 때문에 obsidian 에서 글을 작성한 이후 jeykell 문법으로 일일히 수작업으로 수정해줘야하는 워크플로우가 존재했다. 대표적으로는 아래와 같다.

- [[]] 을 사용한 post 간 링크는 obsidian 고유 문법
- img 파일의 경로를 하나하나 재지정해줘야 한다
- jeykell 은 markdown 파일 이름을 url 로 사용하므로 obsidian 에서 사용하던 제목을 그대로 사용할 수 없다
- callout 문법이 다르다

## 목표

`/ready` 디렉토리에 있는 문서들을 복사하여 적절한 문법으로 변환 뒤 jeykell 블로그가 관리되는 경로의 `_post` 로 이동하고 `/ready` 에 있던 문서는 `/published` 로 이동시키고 싶다.

- 특정 단축키 입력시 파일이 jeykell 문법으로 변환되어야 한다
- 적용이 쉽도록 obsidian plugin 으로 개발


#### 추가사항

- 특정 모듈 활성화/비활성화가 가능해야하며 활성화할 경우 해당 모듈에 대한 설정 정보가 노출되어야 한다

## Architecture

### Skills

**옵시디언의 플러그인을 개발하기 위해서는 Node.js 환경이 필요**하므로 TypeScript 를 사용하여 개발한다.

변환함수를 모듈화하여 jeykell 포맷뿐만 아니라 다른 포맷으로도 변환할 수 있는 기능을 추가 개발할 수 있도록 확장성을 고려하여 설계한다.

### Prerequisite

- 유저는 obsidian vault 에서 image 를 `/img` 아래에 저장해야 한다
- 글 작성이 완료되어 문법 변환을 하고 싶은 경우, `/ready` 디렉토리를 사용해야 한다
- 변환이 완료된 문서는 `/published` 로 이동한다

### Flow

1. obsidian vault 에서 `/ready` 의 파일을 읽는다.
2. 원본은 published 로 복사한다.
3. `xxx.md` 라는 파일을 읽었다면 `yyyy-MM-dd-xxx.md` 라는 제목으로 수정하여 jeykell 블로그의 `_post` 경로로 이동한다.
4. [[]] 문법은 jeykell 에서 적용되지 않으므로 삭제한다. url 링크나 image 의 [] 를 제거하지 않도록 주의한다.
5. `yyyy-MM-dd-xxx.md` 에 image 문법(![[]])이 적용되어 있다면 대괄호 안의 image 를 `/img` 하위 경로에서 찾는다. 이 때 포함된 모든 image 를 검색한다.
6. 찾은 image 파일들을 jeykell 블로그 파일을 관리하는 workspace 의 `_assets/img/고유문자열` 로 이동한다. 글의 상단 순서로 넘버링을 image 파일 이름 끝에 추가한다.
7. `yyyy-MM-dd-xxx.md` 글의 포함된 image 경로들을 `![imageN](/assets/img/고유문자열/imageN.png` 형태로 수정한다.
8. callout 처리
9. 모든 처리가 완료되면 `/ready` 에 있던 `xxx.md` 문서를 `/published` 경로로 이동한다.
10. `/ready` 에 더 이상 문서가 없을 때까지 위의 과정을 반복한다.

기본 단축키는 `cmd+shift+p` 를 사용하게 한다.

#### Optional

- Transaction
- 기존 vault 저장소 이미지를 재사용하는 방안 -> git 을 쓰지 않는 사람이 있을 수 있어서 제외

### obsidian callout

> [!NOTE] Title
> Contents

### jeykell callout

> Title
{: .prompt-info}

## Reference

- [Obsidian plugins](https://marcus.se.net/obsidian-plugin-docs/getting-started/create-your-first-plugin)
