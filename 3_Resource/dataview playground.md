---
title: dataview playground
date: 2023-05-01T11:53:00
aliases: 
tags: 
categories: 
updated: 2025-04-09T01:01
---

**특정 디렉토리를 리스트로 출력**

```dataview
list from "published"
```


```dataview
table length, rating
from "daily"
where file.name = "2025-03-28"
```

[mood:: okay] | [length:: 2 hour]

 **Rating**:: 6

```dataview
table date, date(date)
from ""
where date >= date(2025-04-09) - dur(1 week)
```