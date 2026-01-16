---
title:
date: 2026-01-16T10:45:44+09:00
aliases:
tags:
description:
updated: 2026-01-16T11:19
---

## Syntax sugar

### Brace expansion

```bash
echo {0..5}
# 0 1 2 3 4 5
```

```bash
cp file.txt{,.bak}
# cp file.txt file.txt.bak
```

```bash
touch {a,b,c}.{txt,log}
# a.txt, a.log, b.txt, b.log, c.txt, c.log 총 6개의 파일 한 번에 생성
```

### 이전 명령의 인자 가져오기

방금 입력한 명령어의 마지막 단어(인자)를 가져옵니다.

```bash
mkdir very_long_directory_name
cd !$
# cd very_long_directory_name
```

### 이전 명령 다시 실행하기

```bash
apt-get update
# 에러 발생 (권한 등)
sudo !!
```

### 산술 연산

```bash
echo $((10 + 5))
# 15
```

### 조건부 실행

앞이 성공하면 뒤에도 실행 (&&)

```bash
mkdir my_app && cd my_app
```

앞이 실패하면 뒤를 실행(||)

```bash
rm vital_file.txt || echo "파일 삭제 실패!"
```
