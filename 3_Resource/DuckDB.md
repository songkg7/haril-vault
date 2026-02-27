---
title: DuckDB
date: 2026-01-19T15:07:26+09:00
aliases:
tags:
  - database
description:
updated: 2026-01-19T15:08
---

```bash
brew install duckdb
```

- 강력한 분석 기능 제공
- 다양한 파일 포맷 지원
- 단순한 의존성으로, 어디서나 간편하게 실행 가능

```bash
duckdb -c "SUMMARIZE SELECT * FROM 'sample_file.csv';"
```
