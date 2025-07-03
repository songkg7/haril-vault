---
title: Spark
date: 2025-07-01T15:21:32+09:00
aliases: 
tags:
  - data
  - apache
  - analystic
  - scala
  - python
  - databricks
description: 
updated: 2025-07-01T15:24
---

```python
# JSON 변환
new_df = location_df.toJSON().map(lambda x: json.loads(x)).collect()
new_df
```
