# Repository Guidelines

## Project Structure & Module Organization
Content lives in Markdown under context-specific folders. Use `1_Project` for active initiatives with subpages per deliverable, `2_Area` for ongoing responsibilities, `3_Resource` for reference material, and `4_Archive` for retired notes. Daily journals stay in `daily` with filenames such as `2025-10-28.md`. Media belongs in `attachments/`, while whiteboard sketches go in `Excalidraw/`. Utility scripts (`cleanup.sh`, `convert_date_format.sh`) reside at the repository root; avoid editing them without coordination.

## Build, Test, and Development Commands
Run scripts from the vault root: `bash cleanup.sh` purges conflict-marked files via `gum`, `fd`, and `trash-cli`; install those dependencies first. `bash convert_date_format.sh` normalizes timestamps within `daily/`. Use `git status` to confirm Obsidian sync noise before committing. There is no build pipeline; keep commands lightweight and reproducible.

## Coding Style & Naming Conventions
Write Markdown with clear headings, lists, and callouts for action items. Keep front matter minimal and in YAML when required. Prefer ISO dates (`YYYY-MM-DD`) for files and titles, and organize meeting notes as `<project>-<topic>-<date>.md`. Shell scripts should remain POSIX-compatible, use two-space indentation, and include concise comments ahead of non-trivial logic. Store screenshots or binary assets in `attachments/` and link relatively.

## Testing Guidelines
There is no automated test suite; validate shell utilities manually. Before pushing, run `shellcheck cleanup.sh convert_date_format.sh` and spot-check a sample file produced by each script. When adding new automation, include a dry-run flag or sample invocation in the note describing it so others can reproduce the verification steps.

## Commit & Pull Request Guidelines
Git history favors timestamped backups (`vault backup: 2025-10-28 20:58:17`). Follow that format for routine snapshots. For substantive edits, use `<area>: <concise summary>`—for example, `daily: add standup notes`. Pull requests should explain scope, note any scripts touched, and mention follow-up tasks. Link related Obsidian notes or issue trackers, and include screenshots when visual changes affect attachments or Excalidraw canvases.

## Security & Configuration Tips
Redact personal data before syncing. Keep private credentials in the `private/` directory and exclude them from sharing. Verify Obsidian plug-in settings in `ready/` documentation before enabling new extensions, and capture configuration changes in that folder for future reference.
