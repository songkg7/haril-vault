---
title: LinkedList
date: 2022-08-18T11:28:00
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-18
aliases:
  - 연결 리스트
tags:
  - data-structure
  - list
categories:
  - Data structure
updated: 2025-01-07T00:35
---

# LinkedList

## Overview

![[linked list.png]]

> 연속적인 메모리 위치에 저장되지 않는 선형 데이터 구조

각 노드는 데이터 필드와 다음 노드에 대한 참조를 포함하는 노드로 구성된다.

## Linked list 를 사용하는 이유

배열은 비슷한 우형의 선형 데이터를 저장하는데 사용할 수 있지만 제한 사항이 있다.

1. 배열의 크기가 고정되어 있어서 미리 요소의 수에 대해 할당을 받아야 한다.
2. 새로운 요소를 삽입하는 것은 비용이 많이 든다.
	1. 공간을 만들고, 기존 요소를 전부 이동해야 함

### 장점

1. 크기가 고정되어 있지 않다.
2. 삽입 / 삭제가 용이하다.

### 단점

1. 임의로 접근을 허용할 수 없다. 즉, 첫번째 노드부터 순차적으로 요소에 접근해야 한다. -> 이진 검색 수행 불가능
2. 포인터에 여분의 메모리 공간이 목록의 각 요소에 필요하다.

## Conclusion

# Reference

- [Code example](https://github.com/songkg7/java-practice/blob/main/algorithm/src/main/java/linkedlists/LinkedListNode.java)

# Links

- [[Data structure]]
