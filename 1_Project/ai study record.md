---
title:
date: 2026-01-24T11:08:25+09:00
aliases:
tags:
  - ai
  - study
description:
updated: 2026-02-15T23:36
---

- 클로드
- 멀티 모델 리뷰
- 무한 루프를 통해 원하는 상태를 구현하는 방법 (ralph loop)
- 작업을 한 번 더 하거나 하는 경우는 없음
- slack cli 를 클로드가 사용할 수 있게끔 해서 슬랙 내용을 참조할 수 있게끔
- 레이어드 아키텍처 비교
- slash command, subagent 와 기존 레이어드 아키텍처 비교

---


---

- 일렉트론 기반 데스크탑 앱
- AI 도구보다는 QA 작업을 어떻게 효율적으로 할까?
- 입력폼이 다양해서 QA 가 복잡함
    - 코드 구조를 바꾸기는 힘듬

---

- Opencode
- OpenAI, Gemini, [[GitHub]] Copilot/Cluade sonnet 4.5
- MCP 를 6개 정도 연결해놓고 사용
- ./.agents/guides/...
    - ex) ./.agents/guides/...convention.md
    - @.agents/guides/... 으로 참조

---

### 고민

- 문서 최신화 이슈
    - AI 가 커밋 전 최신화하도록 강제
- 문서 카테고리 구분 이슈 -> 카테고리 구분 안하기
    - 다 섞이잖아요
    - tagging 을 잘하자
    - PARA
        - Project
            - 일시적인 것들
            - end 일자 정해져있는 것들
        - Area
            - 영속적
            - 건강관리하기
            - 데드라인이 없는 것들
        - Resource
            - entrypoint
            - 신규 문서는 다 여기다가 넣으세요
            - hell
            - 이 문서가 뭘 설명하고 있는지 태깅 필수
                - [[Docker Network]]
                - network, docker
                - tag:network, tag:docker
        - Archive
            - 더이상 관리할 필요가 없는 것들
            - 만료된 것들

---

2026-01-31

- [GitHub - openclaw/openclaw: Your own personal AI assistant. Any OS. Any Platform. The lobster way. 🦞](https://github.com/openclaw/openclaw)
- [[Obsidian]] plugin 뭐 쓰시나
- 잘 쓴 글처럼 느껴지게 하는 법
    - 어떤 글이 ai 가 쓴 느낌이 드는걸까
- 싱크업

---

2026-02-14

- gpt 사셨는지?
- 벡터 DB 개요 설명
- TDD (ticket driven develop) 소개
- agents.md 가 프로젝트마다 파편화되는 문제를 심볼릭링크로 이 문제를 해결할 수 있을지 실험해볼 예정

- scales.md
- skill.md
- codex app
- [Compound Engineering: Make Every Unit of Work Compound Into the Next](https://every.to/guides/compound-engineering)

---

- 레제가 여행 플랜을 분단위 + 해당 날짜에 있는 이슈까지 서치해서 짜줌