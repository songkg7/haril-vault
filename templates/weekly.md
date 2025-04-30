---
title: {{title}}
date: <% tp.file.creation_date("YYYY-MM-DDTHH:mm") %>
tags: weekly
description: 
---

### Good

<% tp.file.cursor() %>

### Bad

### Action

### WIL

### Total

---

```dataview
LIST
FROM !"templates"
WHERE date >= date(<% tp.date.now("YYYY-MM-DD") %>) - dur(1 week)
SORT date desc
```
