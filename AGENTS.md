---
updated: 2026-04-06T10:58
---

# Repository Guidelines

## Project Structure & Module Organization

This repository is an Obsidian vault, organized by PARA-style folders:

- `1_Project/`: active project notes.
- `2_Area/`: ongoing responsibilities (interview prep, library, tasks).
- `3_Resource/`: reference and study notes.
- `4_Archive/`: completed or inactive notes.
  Supporting content lives in `attachments/` (images/media), `templates/` (note templates), `raw/` (immutable raw sources — articles, papers, data files; never modify after creation), `Excalidraw/`, and `.obsidian/` (workspace/plugin config).
- Do not create nested directories. All documents managed by tag instead of structure of directories.

## Build, Test, and Development Commands

There is no compile/build pipeline in this repository. Use these maintenance commands:

- `git status` - review local note/config changes before committing.
- `bash cleanup.sh` - interactively remove files matching `*conflicted*` (requires `gum`, `fd`, `trash-cli`).
- `bash convert_date_format.sh` - normalize datetime strings in `daily/` notes.
- `rg "keyword" 3_Resource/` - quickly search notes by topic.

## Coding Style & Naming Conventions

- Write notes in Markdown (`.md`) with clear H1 titles and concise sections.
- Prefer descriptive filenames; keep date-based notes in ISO format when possible (for example, `2026-02-27 ...md`).
- Keep templates in `templates/` and reuse them instead of duplicating structures.
- Do not commit transient workspace noise beyond what is intentionally tracked in `.obsidian/`.

## Testing Guidelines

No automated test framework is configured. Validate changes by:

- Opening the vault in Obsidian and checking links, embeds, and template rendering.
- Running `git diff --name-only` to confirm only intended files changed.
- Spot-checking edited notes for broken markdown links and attachment paths.

## Commit & Pull Request Guidelines

Git history shows a backup-first pattern, mainly `vault backup: YYYY-MM-DD HH:MM:SS`, plus occasional maintenance commits like `update gitignore`.

- For routine snapshots, keep the existing `vault backup: ...` format.
- For targeted edits, use imperative subjects (for example, `add weekly template tags`).
- PRs should include: purpose, changed folders, and any Obsidian/plugin impact (especially `.obsidian/` changes).
- Link related issues/tasks when available and attach screenshots only for UI/workflow-relevant changes.

## LLM Wiki Operations

이 vault는 Karpathy LLM Wiki 패턴을 따른다. LLM은 아래 워크플로에 따라 위키를 유지보수한다.

### Ingest (새 자료 추가)
0. 원본 자료를 `raw/`에 저장한다 (불변, 수정 금지). 네이밍: `YYYY-MM-DD - 원본제목.md`.
1. 소스를 읽고 핵심 내용을 파악한다.
2. `index.md`를 읽어 기존 관련 페이지를 확인한다.
3. 관련 페이지가 있으면 내용을 통합/업데이트한다.
4. **모순 확인**: 새 자료가 기존 페이지와 상충하면 양쪽에 모순을 명시하고, 어느 쪽이 최신인지 표기한다.
5. 새 페이지가 필요하면 `3_Resource/`에 생성한다 (중첩 디렉토리 금지).
6. 관련 페이지에 `[[wikilink]]` 크로스레퍼런스를 추가한다.
7. `index.md`의 해당 카테고리에 항목을 추가/업데이트한다.
8. `log.md`에 ingest 기록을 append 한다.

### Query (질문 → 저장)
1. `index.md`를 먼저 읽어 관련 페이지를 찾는다.
2. 관련 페이지를 읽고 답변을 합성한다. **답변에는 출처 페이지를 `[[wikilink]]`로 인용한다.**
3. 답변이 재사용 가치가 높으면 사용자 확인 후 새 위키 페이지로 저장한다.
4. 저장 시 `index.md`에 항목 추가하고, 관련 페이지에 크로스레퍼런스도 추가한다.
5. `log.md`에 query 기록을 append 한다.

### Lint (건강 점검)
1. 고아 페이지 탐지: 다른 페이지에서 링크되지 않은 노트.
2. 오래된 정보: `updated` 또는 `ingested` 날짜가 6개월 이상 된 페이지 목록.
3. 누락된 크로스레퍼런스: 관련 주제인데 서로 링크 안 된 페이지.
4. 모순 탐지: 서로 다른 페이지에서 상충하는 내용.
5. 누락된 개념 페이지: 여러 페이지에서 언급되지만 독립 페이지가 없는 개념.
6. Data gap: 웹 검색으로 채울 수 있는 정보 공백 식별.
7. index.md 누락: 페이지가 존재하나 index.md에 등록되지 않은 것.
8. 결과를 사용자에게 보고하고 `log.md`에 기록.
9. 자동화: `bash lint.sh`로 기본 탐지 실행 가능.
10. 참고: 존재하지 않는 파일로의 `[[wikilink]]`는 Obsidian stub이므로 문제가 아님.

### Meta Documents
- `index.md`: 전체 위키 카탈로그. LLM은 탐색 시 이 파일을 먼저 읽는다.
- `log.md`: 시간순 활동 기록. 모든 ingest/query/lint 후 append.

## Security & Configuration Tips

- `private/` and `daily/` are ignored by default; keep sensitive or ephemeral content there.
- Review `.gitignore` before adding new tooling outputs or local plugin artifacts.
