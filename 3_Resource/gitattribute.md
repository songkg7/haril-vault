---
title:
date: 2025-11-07T02:11:42+09:00
aliases:
tags:
  - git
  - attribute
  - filemode
description:
updated: 2025-11-07T02:14
---

```
# 모든 텍스트 파일은 줄 바꿈(eol)을 LF(Linux)로 통일
* text=auto eol=lf
# .sh 파일은 LF로 통일하고, 항상 '실행 가능(executable)'으로 처리
*.sh text eol=lf executable
```

```bash
# 1. .gitattributes 파일 추가
git add .gitattributes

# 2. Git 인덱스를 강제로 새로 고침 (새 규칙 적용)
git add --renormalize .

# 3. 변경 사항 커밋
git commit -m "Add .gitattributes and normalize file modes"

# 4. 원격 저장소에 푸시 (필요시)
git push
```
