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
list
from "daily"
where file.ctime < <% tp.date.now("YYYY-MM-DD") %> - dur(1 week)
sort date
```
