---
title: Dropbox conflict 파일 정리하기
date: 2024-10-05 12:23:00 +0900
aliases: 
tags:
  - shell
  - gum
  - fd
categories: 
description: 
updated: 2024-10-05 12:55:32 +0900
---

[![AI Assisted Yes](https://img.shields.io/badge/AI%20Assisted-Yes-green?style=for-the-badge)](https://github.com/mefengl/made-by-ai)

## Overview

여러 기기에서 클라우드 저장소를 사용하다보면 충돌된 파일이 생성되서 더미처럼 남을 때가 있습니다. 개인적으로는 이런 파일들을 주기적으로 정리해주는 편인데요.

```bash
#!/bin/bash

# 'conflict'를 포함하는 파일 검색
file_list=$(find . -type f -name "*conflict*" 2>/dev/null)

# 검색된 파일이 없으면 종료
if [ -z "$file_list" ]; then
    echo "No files containing 'conflict' found. Exiting."
    exit 0
fi

# 파일 목록 출력 및 선택
echo "Found the following files containing 'conflict':"
select_files=()
i=1
while IFS= read -r file; do
    echo "$i) $file"
    select_files+=("$file")
    ((i++))
done <<< "$file_list"

# 사용자에게 삭제할 파일 선택 요청
echo "Enter the numbers of the files you want to delete (e.g., 1 2 3), or 'a' for all, or 'q' to quit:"
read -r selection

# 선택 처리
selected_files=()
if [[ $selection == "q" ]]; then
    echo "Operation cancelled. Exiting."
    exit 0
elif [[ $selection == "a" ]]; then
    selected_files=("${select_files[@]}")
else
    for num in $selection; do
        if [[ $num =~ ^[0-9]+$ ]] && ((num > 0 && num <= ${#select_files[@]})); then
            selected_files+=("${select_files[$((num-1))]}")
        fi
    done
fi

# 선택된 파일이 없으면 종료
if [ ${#selected_files[@]} -eq 0 ]; then
    echo "No valid files selected. Exiting."
    exit 0
fi

# 선택된 파일 목록 출력
echo "The following files will be deleted:"
printf '%s\n' "${selected_files[@]}"
echo

# 사용자에게 확인 요청
read -p "Are you sure you want to delete these files? (y/N): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    # 각 선택된 파일에 대해 삭제 수행
    for file in "${selected_files[@]}"; do
        if [ -e "$file" ]; then
            echo "Deleting: $file"
            rm -f "$file"
        else
            echo "File not found: $file"
        fi
    done
    echo "File deletion process completed."
else
    echo "Operation cancelled. No files were deleted."
fi
```

%% gif 로 만들어서 첨부하기 %%

기능적으로는 요구사항을 충실히 만족했으니 이 정도로도 충분히 사용할 수 있을거에요. 하지만 몇 가지 아쉬운 점도 있어요.

1. `rm` 은 특성상 실수로 제거될 경우 복구가 어려움
2. 삭제해야할 파일이 많다면 필터링이 다소 귀찮을 수 있음

## 조금 더 우아하게

UX 를 개선해봅시다.

Linux 기본 명령만 사용했던 이전 스크립트와 달리 몇가지 의존성이 추가되지만, 그만한 가치는 있을거에요.

사용하는 도구 fd, gum, trash-cli

- [GitHub - sharkdp/fd: A simple, fast and user-friendly alternative to 'find'](https://github.com/sharkdp/fd)
- [GitHub - charmbracelet/gum: A tool for glamorous shell scripts 🎀](https://github.com/charmbracelet/gum)
- [GitHub - andreafrancia/trash-cli: Command line interface to the freedesktop.org trashcan.](https://github.com/andreafrancia/trash-cli)

trash-cli 를 사용하여 실수로 잘못된 파일을 제거하는 것을 막는걸 추천

- `gum`과 `fd`가 설치되어 있는지 확인합니다.
- `fd -H -I -t f 'conflict'` 명령을 사용하여 파일명에 'conflict'를 포함하는 모든 파일을 검색합니다.
    - `-H`: 숨김 파일도 포함
    - `-I`: 무시 패턴 (.gitignore 등)을 무시
    - `-t f`: 일반 파일만 검색
- `gum choose`를 사용하여 사용자가 삭제할 파일을 선택할 수 있게 합니다.
- 선택된 파일 목록을 표시합니다.
- `gum confirm`을 사용하여 사용자에게 삭제 확인을 요청합니다.
- 확인되면 각 파일을 순차적으로 삭제합니다.
- `gum style`을 사용하여 결과 메시지에 색상을 적용합니다.

```bash
#!/bin/bash

# gum, fd, trash-cli 가 설치되어 있는지 확인
if ! command -v gum &> /dev/null || ! command -v fd &> /dev/null || ! command -v trash &> /dev/null; then
    echo "Error: This script requires 'gum', 'fd', and 'trash-cli' to be installed."
    echo "Please install them and try again."
    exit 1
fi

# fd를 사용하여 'conflict'를 포함하는 파일 검색
file_list=$(fd -H -I -t f 'conflict')

# 검색된 파일이 없으면 종료
if [ -z "$file_list" ]; then
    gum style --foreground 208 "No files containing 'conflict' found. Exiting."
    exit 0
fi

# gum choose를 사용하여 파일 선택
selected_files=$(echo "$file_list" | gum choose --no-limit --header "Select files to delete (Space to select, Enter to confirm):")

# 선택된 파일이 없으면 종료
if [ -z "$selected_files" ]; then
    gum style --foreground 208 "No files selected. Exiting."
    exit 0
fi

# 선택된 파일 목록 출력
gum style --border normal --padding "1 2" --border-foreground 212 "The following files will be deleted:"
echo "$selected_files"
echo

# gum confirm을 사용하여 사용자에게 확인 요청
if gum confirm "Are you sure you want to delete these files?"; then
    # 각 선택된 파일에 대해 삭제 수행
    echo "$selected_files" | while IFS= read -r file; do
        if [ -e "$file" ]; then
            gum style --foreground 214 "Deleting: $file"
            trash "$file"
        else
            gum style --foreground 203 "File not found: $file"
        fi
    done
    gum style --foreground 212 "File deletion process completed."
else
```

%% gif 로 만들어서 첨부하기 %%
