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
where file.ctime < file.ctime - dur(1 week)
sort date
```
