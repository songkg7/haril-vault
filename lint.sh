#!/bin/bash
# Vault Lint: 고아 페이지, 오래된 페이지, index.md 누락 탐지
# Usage: bash lint.sh

VAULT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$VAULT_DIR"

echo "🔍 Vault Lint Report ($(date +%Y-%m-%d))"
echo "===================="
echo ""

# 1. Orphan Pages: 다른 파일에서 링크되지 않은 노트
echo "=== Orphan Pages (다른 파일에서 링크되지 않은 노트) ==="
orphan_count=0
for f in 3_Resource/*.md 1_Project/*.md 2_Area/*.md; do
  [ -f "$f" ] || continue
  basename_raw=$(basename "$f" .md)
  # 정규식 특수문자 이스케이프 (B+Tree, @Configuration 등 대응)
  basename_escaped=$(printf '%s' "$basename_raw" | sed 's/[.[\(*+?^$|{\\]/\\&/g')
  # rg -F (fixed string) 모드로 검색하여 regex 문제 회피
  count=$(rg -F -l "[[${basename_raw}]]" --glob "*.md" 2>/dev/null | grep -v "^${f}$" | wc -l | tr -d ' ')
  if [ "$count" -eq 0 ]; then
    # NFC/NFD 정규화 차이 대응: iconv 로 정규화 후 재검색
    nfc_name=$(echo "$basename_raw" | iconv -f UTF-8-MAC -t UTF-8 2>/dev/null || echo "$basename_raw")
    if [ "$nfc_name" != "$basename_raw" ]; then
      count2=$(rg -F -l "[[${nfc_name}]]" --glob "*.md" 2>/dev/null | grep -v "^${f}$" | wc -l | tr -d ' ')
      if [ "$count2" -gt 0 ]; then
        continue
      fi
    fi
    echo "  📄 $f"
    orphan_count=$((orphan_count + 1))
  fi
done
echo "  → 총 ${orphan_count}개 고아 페이지"
echo ""

# 2. Stale Pages: updated/ingested 날짜가 6개월 이상 된 페이지
echo "=== Stale Pages (6개월 이상 업데이트 안 된 페이지) ==="
six_months_ago=$(date -v-6m +%Y-%m-%d 2>/dev/null || date -d '6 months ago' +%Y-%m-%d 2>/dev/null)
stale_count=0
if [ -n "$six_months_ago" ]; then
  for f in 3_Resource/*.md 1_Project/*.md 2_Area/*.md; do
    [ -f "$f" ] || continue
    # updated: 또는 ingested: 둘 다 확인
    date_val=$(head -10 "$f" | grep -oE '(updated|ingested): [0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
    if [ -n "$date_val" ] && [[ "$date_val" < "$six_months_ago" ]]; then
      echo "  📅 $f (last: $date_val)"
      stale_count=$((stale_count + 1))
    fi
  done
fi
echo "  → 총 ${stale_count}개 오래된 페이지"
echo ""

# 3. Missing from index: index.md에 등록되지 않은 페이지
echo "=== Missing from Index (index.md에 없는 페이지) ==="
missing_count=0
if [ -f "index.md" ]; then
  # index.md를 NFC로 정규화한 임시 파일 생성
  index_nfc=$(mktemp)
  iconv -f UTF-8-MAC -t UTF-8 index.md > "$index_nfc" 2>/dev/null || cp index.md "$index_nfc"
  for f in 3_Resource/*.md 1_Project/*.md 2_Area/*.md; do
    [ -f "$f" ] || continue
    name=$(basename "$f" .md)
    # 파일명도 NFC로 정규화해서 비교
    name_nfc=$(echo "$name" | iconv -f UTF-8-MAC -t UTF-8 2>/dev/null || echo "$name")
    # [[name]] 또는 [[name|alias]] 형태 모두 검색
    if ! grep -qF "[[${name_nfc}]]" "$index_nfc" 2>/dev/null \
      && ! grep -qF "[[${name_nfc}|" "$index_nfc" 2>/dev/null \
      && ! grep -qF "[[${name}]]" "$index_nfc" 2>/dev/null \
      && ! grep -qF "[[${name}|" "$index_nfc" 2>/dev/null; then
      echo "  📋 $f"
      missing_count=$((missing_count + 1))
    fi
  done
  rm -f "$index_nfc"
fi
echo "  → 총 ${missing_count}개 미등록 페이지"
echo ""

# 4. Missing Concept Pages: [[wikilink]]가 3회 이상 등장하지만 파일이 없는 경우
echo "=== Missing Concept Pages (3회 이상 참조되지만 파일이 없는 개념) ==="
missing_concept_count=0
# 모든 md 파일에서 [[...]] 링크 추출
rg -oN '\[\[([^\]|]+)' --glob "*.md" 2>/dev/null \
  | sed 's/.*\[\[//' \
  | sort | uniq -c | sort -rn \
  | while read count name; do
    [ "$count" -lt 3 ] && break
    # raw/, templates/, .obsidian/ 참조는 스킵
    case "$name" in
      raw/*|templates/*|.obsidian/*|attachments/*) continue ;;
    esac
    # 파일 존재 여부 확인 (3_Resource, 1_Project, 2_Area)
    found=0
    for dir in 3_Resource 1_Project 2_Area; do
      if [ -f "${dir}/${name}.md" ]; then
        found=1
        break
      fi
    done
    # 루트에도 확인
    if [ "$found" -eq 0 ] && [ -f "${name}.md" ]; then
      found=1
    fi
    if [ "$found" -eq 0 ]; then
      echo "  💡 [[${name}]] (${count}회 참조)"
      missing_concept_count=$((missing_concept_count + 1))
    fi
  done
echo "  → 후보 페이지 리포트 완료"
echo ""

echo "=== Lint 완료 ==="
