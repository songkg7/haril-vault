---
title: how to writing daily note
date: 2025-05-20T20:57:09+09:00
aliases: 
tags:
  - tip
description: 
updated: 2025-05-27T15:57
---

## Overview

daily 를 어떻게 작성해야하는지 소개하는 글입니다.

**TLDR;**

- 자신만의 template 을 만들어놓고 활용하는 것이 중요
- 메타데이터를 잘 기록해두면 두고두고 유용하게 사용할 수 있다

## daily 를 쓰는 이유

- 그 날 있었던, 했던 일 또는 사건에 대한 정리
- 내일 해야할 일에 대한 정리
    - 그리고 이 내용을 daily scrum 으로 활용함
- 매일 하지 않으면 금방 휘발되는 경우가 많음
- daily 를 적다가 필요하다면 특정 키워드는 별개의 글로 분리할 수도 있음
    - daily 를 모든 글의 진입점으로 접근하는 방식

## daily 노트 쓰는 법

- obsidian template
- dataview 를 사용하여 이전 todo 를 매일 넘김
- 체크박스에 체크할 경우, 어느날짜에 체크했는지 표시됨
    - 플러그인 활용
- 최대한 많은 메타데이터를 남겨야 이후에 쿼리 가능
- 백업 및 동기화는 git, iCloud Drive 를 활용 중
    - iCloud Drive 를 사용하여 기기간 동기화하는 중이지만 git 에는 남기지 않기 위해 `daily/` 를 `.gitignore` 에 넣어두고 있음

### Obsidian Template

결론부터 바로 간다. daily template 은 아래처럼 만들어놓고 사용하고 있다.

```text
---
title: {{title}}
date: {{date}}T{{time}}
tags: daily
description: 
---

## Memo

## Daily Scrum

{{date}}
- 

todo
- 

---

## Review

``dataview
task
from "daily"
where !completed AND date(file.name) <= date(this.file.name) - dur(1 day)
``
```

![](https://i.imgur.com/QbtOw9f.png)

업무내용을 적고 있어서 구체적인 부분들은 블러처리했지만, 해결되지 않은 todo 는 다음날의 daily 에 보이게 되는 구조다. todo 를 체크하면 리스트에서 사라지게 되어 더이상 표시되지 않는다.

todo 옆에는 어떤 주제인지 간단한 태그를 남겨두곤 하는데, 이럴 경우 Dataview 에서 특정 태그가 달려있는 todo list 만 추출해낼 수 있기 때문에 유용하다.

### Dataview

Dataview 는 [[Obsidian]] 의 핵심 플러그인 중 하나로, 노트 안에 작성된 메타데이터들을 쿼리할 수 있게 한다. 자세한 정보는 [공식 문서](https://blacksmithgu.github.io/obsidian-dataview/)를  참고해주시면 좋겠고, 이 글에서는 daily 를 적을 때 활용한 부분에 대해서만 설명한다.

- code review tag 추출하는 예제

### Templater

복잡한 템플릿 생성을 도와주는 플러그인. daily 에서는 간단하게 사용하고 있다. dataview 와 조합해서 기본 템플릿 문법으로 처리하기 어려운 부분을 해결하고 있다.

## Conclusion
