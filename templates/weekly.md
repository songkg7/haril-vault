---
title: {{title}}
date: {{date}}T{{time}}
tags: weekly
description: 
---

### Good

### Bad

### Action

### WIL

### Total

---

```dataview
LIST
FROM !"templates"
WHERE date >= <% tp.date.now("YYYY-MM-DD") %> - dur(1 week)
SORT date desc
```
