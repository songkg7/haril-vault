#!/bin/bash

# 변환할 디렉터리 지정 (예: ./target_folder)
TARGET_DIR="./3_Resource"

# 파일 확장자 지정 (모든 파일 대상으로 하려면 * 사용)
FILE_EXT="*"

# 모든 대상 파일 검색 및 처리
find "$TARGET_DIR" -type f -name "$FILE_EXT" | while read -r file; do

  # 파일 내용 변환
  sed -E -i '' 's/([0-9]{4}-[0-9]{2}-[0-9]{2}) ([0-9]{2}:[0-9]{2}:[0-9]{2}) [+-][0-9]{4}/\1T\2/g' "$file"
done

echo "변환 완료"

