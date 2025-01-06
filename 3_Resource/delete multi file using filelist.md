---
title: script 를 사용하여 여러 파일 한 번에 지우기
date: 2023-08-20T01:32:00
aliases: 
tags: linux, shell, fzf
categories: 
updated: 2025-01-07T00:35
---

먼저 삭제할 파일을 선택하여 텍스트 목록으로 저장합니다.

```bash
find * -type f | fzf --multi > ~/selected.txt
```

이제 아래 스크립트를 실행합니다.

```bash
while IFS= read -r file; do rm "$file"; done < ~/selected.txt
```

- `while` 루프: 텍스트 파일의 각 줄을 반복합니다.
- `IFS= read -r file`: 텍스트 파일에서 각 줄을 읽어 `file` 변수에 저장합니다. `IFS=` 부분은 선행/후행 공백이 파일 이름에 영향을 미치지 않도록 합니다.
- `do rm "$file";`: `file` 변수의 현재 값으로 지정된 파일을 삭제합니다.
- `done < filelist.txt`: 루프에 대한 입력이 "filelist.txt" 파일에서 와야 함을 나타냅니다.
