---
title: "bloom filter"
date: 2023-05-01 12:41:00 +0900
aliases: 
tags: [bloom-filter, hash, array]
categories: 
updated: 2023-05-01 12:43:42 +0900
---

## 블룸 필터에 대해서

블룸 필터(Bloom Filter)는 집합(set)의 멤버십 테스트를 위한 확률론적 자료 구조로, 빠른 속도와 작은 메모리 사용량을 가지고 있습니다.

블룸 필터는 일반적으로 비트 배열(bit array)로 구현되며, k개의 해시 함수(hash function)를 사용하여 입력 요소(element)를 k개의 비트 위치에 매핑합니다. 이때, 각 비트 위치는 0 또는 1의 값을 가질 수 있으며, 입력 요소가 이미 존재하지 않아도 1로 설정될 수 있습니다. 따라서 블룸 필터는 100% 정확성을 보장할 수 없지만, 일반적으로 거짓 양성(false positive) 오류만 발생하며, 이 오류는 해시 함수의 개수와 비트 배열의 크기에 따라 조절할 수 있습니다.

블룸 필터는 멤버십 테스트에 최적화된 자료 구조이므로, 다른 작업(예: 삽입, 삭제)은 지원하지 않습니다. 또한, 블룸 필터가 반환하는 결과가 "해당 요소가 집합에 있을 가능성이 있다"라는 것이므로, 추가적인 검증 작업이 필요합니다.

블룸 필터는 대규모 데이터 처리 및 검색 시스템에서 유용하게 사용됩니다. 예를 들어, 웹 검색 엔진에서는 블룸 필터를 사용하여 이미 색인(index)된 URL을 추적하고, 새로운 URL이 색인되었는지 여부를 빠르게 확인합니다. 또한, 스팸 필터링 및 네트워크 보안 등 다양한 분야에서 사용됩니다.

## 블룸 필터의 구현 방법

블룸 필터의 구현 방법은 다음과 같습니다.

1. 비트 배열(bit array)을 준비합니다. 이때, 비트 배열의 크기는 집합(set)의 크기에 따라 결정됩니다.
2. k개의 해시 함수(hash function)를 정의합니다. 이때, k는 적절한 값을 선택하여야 합니다. 일반적으로 k는 비트 배열의 크기와 집합(set)의 크기에 따라 결정됩니다.
3. 입력 요소(element)를 k개의 해시 함수(hash function)를 사용하여 비트 배열(bit array)의 k개의 위치에 매핑합니다. 이때, 각 위치에는 1로 설정합니다.
4. 멤버십 테스트 시, 입력 요소(element)를 k개의 해시 함수(hash function)를 사용하여 비트 배열(bit array)의 k개의 위치를 찾습니다. 이때, 모든 위치가 1이면 집합(set)에 해당 요소가 존재할 가능성이 높다고 판단합니다.

위와 같은 구현 방법을 통해 블룸 필터를 구현할 수 있습니다. 다만, 해시 함수(hash function)와 비트 배열(bit array)의 크기 선택 등 구현 방법에 따라 정확성과 성능이 달라질 수 있으므로 적절한 값 선택이 필요합니다.