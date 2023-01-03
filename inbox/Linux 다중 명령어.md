---
title: "linux 다중 명령어"
date: 2022-11-17 09:56:00 +0900
aliases: 
tags: [linux, terminal, command]
categories: 
---

[[Linux]]

### Pipeline

pipeline 을 사용하면 terminal 명령의 출력결과를 다음 명령의 입력으로 넘겨줄 수 있다.

```bash
ls -al | grep test.md
```

다음 명령은 현재 경로를 클립보드로 복사한다.

```bash
pwd | pbcopy
```

### Write

test.md 파일로 "# HEAD" 내용을 전달한다. 파일이 없다면 생성하고 이미 내용이 있었다면 덮어쓴다.

```bash
echo "# HEAD" > test.md
```

```bash
cat test.md
# HEAD
```

```bash
echo "## OVERWRITE" > test.md
```

```bash
cat test.md
## OVERWRITE
```

내용을 append 하고 싶다면 `>>` 을 사용한다.

```bash
echo "# HEAD2" >> test.md
```

```bash
cat test.md
# HEAD
# HEAD2
```

& 는 앞의 명령어의 성공 여부와 관련이 있다.

명령 전달의 개수는 제한이 없다.
