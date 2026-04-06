---
title: Activity Log
tags:
  - meta
updated: 2026-04-06T12:04
---

# Activity Log

LLM Wiki 운영 기록. Ingest, Query, Lint 이벤트를 시간순으로 append 한다.

## [2026-04-06] lint | Karpathy Gist 대조 및 보강
- Karpathy LLM Wiki gist(442a6bf5)와 현재 vault 구조 대조
- CLAUDE.md: Ingest에 "하나의 소스가 10-15 페이지를 건드린다" 원칙 추가, Query에 다양한 출력 형식 언급, log.md 파싱 컨벤션 명시, Tips 섹션 추가
- templates/ingest.md: Contradictions 섹션 추가, description 필드 가이드 추가
- lint.sh: Missing Concept Pages 탐지 추가 (3회 이상 참조되나 파일 없는 개념 리포트)

## [2026-04-06] ingest | Raw Source 레이어 도입
- raw/ 디렉토리 생성 (불변 원본 자료 보관소)
- AGENTS.md: Project Structure에 raw/ 추가, Ingest 단계 0 추가
- templates/ingest.md: source 필드가 raw/ 참조하도록 변경
- index.md: raw/는 인덱싱 대상 아님을 명시

## [2026-04-06] lint | Codex 검토 기반 수정
- lint.sh: regex 이스케이프(rg -F), NFD/NFC Unicode 정규화, index 누락 체크 추가
- lint.sh: ingested/updated 둘 다 읽도록 stale 체크 개선
- templates/ingest.md: updated 필드 추가 (lint와 메타데이터 정렬)
- AGENTS.md: Ingest에 모순 탐지 규칙, Query에 인용/index 업데이트 의무화, Lint에 누락 개념/data gap 추가
- index.md: What is DBA? 항목 추가

## [2026-04-06] init | LLM Wiki 구조 도입
- Karpathy LLM Wiki 패턴 기반으로 vault 운영 워크플로 추가
- index.md, log.md 생성
- AGENTS.md에 Ingest/Query/Lint 규칙 추가
- templates/ingest.md 생성
- lint.sh 스크립트 생성
