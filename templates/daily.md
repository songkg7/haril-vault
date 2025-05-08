---
title: {{title}}
date: {{date}}T{{time}}
tags: daily
description: 
---

## Memo

## Daily Scrum

{{date}}
- 

todo
- 

---

## Review

```dataview
task
from "daily"
where !completed AND date(file.name) <= date(this.file.name) - dur(1 day)
```
