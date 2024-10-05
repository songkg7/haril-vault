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
    gum style --foreground 213 "Operation cancelled. No files were deleted."
fi
