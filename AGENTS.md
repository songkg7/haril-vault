---
updated: 2026-04-06T23:30
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

This vault follows the Karpathy LLM Wiki pattern. The LLM maintains the wiki according to the workflows below.

### Ingest (Add New Source)

One source typically touches 10–15 wiki pages. Don't just file the source — integrate it across the wiki.

0. Save the original source to `raw/` (immutable, never modify). Naming: `YYYY-MM-DD - Original Title.md`.
1. Read the source and identify key takeaways.
2. Read `index.md` to find existing related pages.
3. If related pages exist, integrate and update their content.
4. **Contradiction check**: If the new source conflicts with existing pages, annotate both sides with the contradiction and which is more recent.
5. If a new page is needed, create it in `3_Resource/` (no nested directories).
6. Add `[[wikilink]]` cross-references to related pages.
7. Add or update the entry in the appropriate category of `index.md`.
8. Append an ingest record to `log.md`.

### Query (Question → Save)
1. Read `index.md` first to find relevant pages.
2. Read relevant pages and synthesize an answer. **Cite source pages using `[[wikilink]]`.**
3. Answers can take various forms: markdown pages, comparison tables, slide decks (Marp), or charts — choose the format that best serves the question.
4. If the answer has high reuse value, save it as a new wiki page after user confirmation.
5. When saving, add an entry to `index.md` and add cross-references to related pages.
6. Append a query record to `log.md`.

### Lint (Health Check)
1. Orphan pages: notes not linked from any other page.
2. Stale information: pages with `updated` or `ingested` date older than 6 months.
3. Missing cross-references: related topics that are not linked to each other.
4. Contradiction detection: conflicting claims across different pages.
5. Missing concept pages: concepts mentioned in multiple pages but lacking a dedicated page.
6. Data gaps: information voids that could be filled with a web search. Suggest specific searches when gaps are found.
7. Index gaps: pages that exist but are not registered in `index.md`.
8. Report results to the user and record in `log.md`.
9. Automation: run `bash lint.sh` for basic detection.
10. Note: `[[wikilink]]` to non-existent files are Obsidian stubs, not errors.

### Meta Documents
- `index.md`: Full wiki catalog. The LLM reads this file first when exploring the vault.
- `log.md`: Chronological activity log. Append after every ingest, query, and lint. Use `## [YYYY-MM-DD] type | Title` format so entries are parseable (`grep "^## \[" log.md | tail -5`).

### Tips
- Obsidian graph view shows wiki shape — hubs, orphans, and connection density at a glance.
- `[[wikilink]]` to non-existent files are Obsidian stubs (click to create), not errors.
- The vault is a git repo — use `git log` and `git diff` to track wiki evolution over time.

## Security & Configuration Tips

- `private/` and `daily/` are ignored by default; keep sensitive or ephemeral content there.
- Review `.gitignore` before adding new tooling outputs or local plugin artifacts.
