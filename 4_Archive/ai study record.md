---
title:
date: 2026-01-24T11:08:25+09:00
aliases:
tags:
  - ai
  - study
description:
updated: 2026-03-28T13:08
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

---

- Flip score board
    - UI 측면에서의 개선
    - 숫자가 동적으로 변하니까 그럴듯하더라
- backtest dashoboard 고도화
    - 데이터 수집이 핵심
        - OHLCV
        - fundamentals
        - volume, 거래량
    - [[Parquet]] + [[DuckDB]] 사용
    - 생존자 편향 발생하지 않도록 해야
        - 상폐된 종목까지 수집
    - 당분간은 UI 보다는 품질 좋은 데이터 확보에 노력을 기울일 예정
    - 근데 수집은 AI 보다는 아직 사람 손이 꽤 많이 감
        - provider 정해서 토큰 받고 인증하는 과정이 필요해서
    - 데이터 품질 검증 파이프라인이 필요
- 꾸준한 아키텍처 개선 시도
    - 모든 코드를 AI 에게 맡기다보니, 구조가 잡혀있지 않으면 신뢰하기 어려움
    - 마지막 순간에 직접 리뷰해야할 경우, 코드가 읽을 수 있는 상태여야
- QA 단계 강화
    - 스위스치즈모델
    - AI 에게 위임하기 전까지라면 이렇게까지 촘촘하게 구성하진 않았을텐데
- observability 도 강화
    - 관측가능성을 올려놔야 AI 한테 적절한 지시를 내릴 수 있음
    - 서비스 상태를 조망하면서 AI 가 엉뚱한 곳으로 향하지는 않는지 수시로 체크
    - 구현이나 수정은 AI 가 하더라도, 디테일한 분석이 필요할 때가 있는데 그를 위한 준비작업
        - 일단 뭘 볼 수 있는 상태여야 이마저도 AI 한테 보라고 할 수 있으니..
    - ![[Pasted image 20260323021637.png]]

---

## 1회차 스터디 결과 회고

### 해본 것

- Quant, 체인소맨 세계관을 AI agent 들로 구축하기 with OpenClaw, LocalLLM, [[vaultwarden]] 등 다양한 AI 관련 프로젝트 진행
- 여러가지 실험을 통해 현재 Agent 수준에서 어디까지 가능할지 직접 확인
    - Quant 의 경우 hexagonal architecture 에 observability stack 까지 의도적으로 전과정 코드리뷰없이 진행하는 중
    - ![[Pasted image 20260328124005.png]]
    - 최근 한달간 codex 로만 55억 토큰 소모 ![[Pasted image 20260328124243.png]] 
    - 얼마나 AI 를 적극적으로 사용했는지 명확하게 측정할 수단이 마땅치 않아서 토큰사용량으로 측정하긴 했으나, 토큰을 많이 사용했다일 뿐 **성과의 지표로 쓰는 것은 말도 안된다**고 생각한다. 최대한 비용효율적인 방법으로 AI 를 사용하려고 시도 중. OMC, OMX 같은 외부 하네스 다 걷어냄.
- md 가이드와 skill 의 차이를 확인
- Harness 를 어떻게 만들어야할지 직접 테스트해보고 결과 확인
- 인지부하를 최대한 줄이면서 해야할 일을 놓치지 않는 방법들 위주로 실험 진행

### Conclusion

- 개발자가 AI 로 대체될 것이라고는 생각하지 않음.
- 본질에 집중하는 것이 더욱 중요.
    - 결국 판단은 사람이 한다. 책임도 사람이 진다.
- 용어는 금방 변하고, 사라진다.
- CS 지식 같은 백그라운드 지식을 더욱 강화해야할 필요성 느껴짐.
- 새로운 것을 배우기가 너무나 쉬운 시대다. 알고 있다고 착각하기에도 너무나 쉬운 시대다.
    - 비판적인 사고가 필요하다.
- 직접 해보고 만들어보는 것이 무엇보다 중요하다고 생각.
- AI 를 신뢰하기 위해서는, 신뢰할 수 있는 환경을 구성하는게 중요하다.
    - 코드를 블랙박스가 아닌, 관측가능한 상태로 유지해야 한다.
- 테이블 대신 망치만 자랑하는 사람이 넘쳐난다. 테이블을 만드는데에 집중하자.
    - e.g. '내 망치는 토큰 10억개 짜리', '한달동안 토큰 20억개로 망치만든 썰'..
