---
title:
date: 2026-01-03T21:51:24+09:00
aliases:
tags:
  - gitlab
  - ci
description:
updated: 2026-01-03T21:52
---

파이프라인을 동적으로 생성하여 static 파일 숫자를 획기적으로 줄여줄 수 있는 기능

```yaml
trigger-child-pipelines:
  stage: module_triggers
  needs:
    - job: prepare-child-pipelines
      artifacts: true
  trigger:
    include:
      - artifact: .gitlab-ci/generated-child-pipeline.yml
        job: prepare-child-pipelines
    strategy: depend
  variables:
    UPSTREAM_MERGE_REQUEST_ID: "$CI_MERGE_REQUEST_ID"
  rules:
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
      when: never
    - when: on_success

prepare-child-pipelines:
  stage: detect
  image: alpine:3.19
  rules:
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
      when: never
    - when: on_success
  script:
    - apk add --no-cache git python3
    - |
      python3 - <<'PY'
      import os
      import subprocess
      import sys
      from pathlib import Path

      modules_dir = Path('.gitlab-ci/applications')
      modules = sorted(path.stem for path in modules_dir.glob('*.yml'))

      output_path = Path('.gitlab-ci/generated-child-pipeline.yml')
      head = os.environ.get('CI_COMMIT_SHA')
      if not head:
        raise SystemExit('CI_COMMIT_SHA is not available')

      force_full = False
      base = os.environ.get('CI_MERGE_REQUEST_DIFF_BASE_SHA') or os.environ.get('CI_COMMIT_BEFORE_SHA')
      if not base or set(base) == {'0'}:
        try:
          base = subprocess.check_output(['git', 'rev-parse', f'{head}^'], text=True).strip()
        except subprocess.CalledProcessError:
          base = None
          force_full = True

      if base:
        diff_args = ['git', 'diff', '--name-only', f'{base}...{head}']
      else:
        diff_args = ['git', 'diff', '--name-only', head]

      try:
        diff_output = subprocess.check_output(diff_args, text=True)
        changed_files = [line.strip() for line in diff_output.splitlines() if line.strip()]
      except subprocess.CalledProcessError:
        changed_files = []

      global_dirs = (
        'stream-core/',
        '.gitlab-ci/',
        'build-logic/',
      )
      global_files = {
        'build.gradle.kts',
        'settings.gradle.kts',
        'gradle.properties',
        'gradlew',
        'gradlew.bat',
      }

      def is_global(path: str) -> bool:
        return any(path.startswith(prefix) for prefix in global_dirs) or path in global_files

      selected = set()
      if force_full:
        selected.update(modules)
      elif changed_files:
        if any(is_global(path) for path in changed_files):
          selected.update(modules)
        else:
          for file_path in changed_files:
            for module in modules:
              if file_path.startswith(f'{module}/'):
                selected.add(module)
                break

      deploy_app = os.environ.get('DEPLOY_APPLICATION_NAME', '').strip()
      if deploy_app:
        if deploy_app in modules:
          selected.add(deploy_app)
        else:
          print(f"[WARN] DEPLOY_APPLICATION_NAME '{deploy_app}' does not match any module", file=sys.stderr)

      if not selected:
        output_path.write_text('workflow:\n  rules:\n    - when: never\n', encoding='utf-8')
        print('No modules selected')
      else:
        lines = ['include:', '  - local: .gitlab-ci/child/base.yml']
        for module in sorted(selected):
          lines.append(f'  - local: .gitlab-ci/applications/{module}.yml')
        output_path.write_text('\n'.join(lines) + '\n', encoding='utf-8')
        print('Modules selected:', ', '.join(sorted(selected)))
      PY
  artifacts:
    paths:
      - .gitlab-ci/generated-child-pipeline.yml
    expire_in: 1 hour
```
