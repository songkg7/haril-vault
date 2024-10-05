#!/bin/bash

# fd와 fzf가 설치되어 있는지 확인
if ! command -v fd &> /dev/null || ! command -v fzf &> /dev/null; then
    echo "Error: This script requires both 'fd' and 'fzf' to be installed."
    echo "Please install them and try again."
    exit 1
fi

# fd로 파일을 검색하고 fzf로 선택하게 함
selected_files=$(fd -IH | fzf --multi --preview 'echo {}')

# 선택된 파일이 없으면 종료
if [ -z "$selected_files" ]; then
    echo "No files selected. Exiting."
    exit 0
fi

# 선택된 파일 목록 출력
echo "The following files will be deleted:"
echo "$selected_files"
echo

# 사용자에게 확인 요청
read -p "Are you sure you want to delete these files? (y/N): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    # 각 선택된 파일에 대해 삭제 수행
    echo "$selected_files" | while IFS= read -r file; do
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
