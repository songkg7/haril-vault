---
updated: 2026-02-27T20:53
---

# Repository Guidelines

## Project Structure & Module Organization

This repository is an Obsidian vault, organized by PARA-style folders:

- `1_Project/`: active project notes.
- `2_Area/`: ongoing responsibilities (interview prep, library, tasks).
- `3_Resource/`: reference and study notes.
- `4_Archive/`: completed or inactive notes.
  Supporting content lives in `attachments/` (images/media), `templates/` (note templates), `Excalidraw/`, and `.obsidian/` (workspace/plugin config).
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

## Security & Configuration Tips

- `private/` and `daily/` are ignored by default; keep sensitive or ephemeral content there.
- Review `.gitignore` before adding new tooling outputs or local plugin artifacts.
