---
title: mise
date: 2024-12-05 23:36:00 +0900
aliases: 
tags:
  - mise
  - python
  - package-manager
description: 
updated: 2024-12-05T23:38
---

## [[Python]]

### venv 관리

```toml
[env]
_.python.venv = ".venv" # relative to this file's directory
_.python.venv = "/root/.venv" # can be absolute
_.python.venv = "{{env.HOME}}/.cache/venv/myproj" # can use templates
_.python.venv = { path = ".venv", create = true } # create the venv if it doesn't exist
```

## Links

- [[asdf vs mise]]
- [[Easy devtools version management, mise|개발도구 버전 관리하기, mise]]
