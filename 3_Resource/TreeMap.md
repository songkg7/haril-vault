---
title: TreeMap
date: 2023-09-17T21:17:00
aliases: 
tags:
  - java
  - tree
  - map
  - red-black
  - data-structure
categories: 
updated: 2025-01-07T00:35
---
[[Java|Java]] 의 [[Map]] 은 인터페이스이다. TreeMap 은 Map 인터페이스의 구현체 중 하나이다.

TreeMap은 키-값 쌍으로 이루어진 데이터를 저장하는 자료구조이다. TreeMap은 내부적으로 이진 트리([[Binary Tree|Binary Tree]])를 사용하여 데이터를 저장하므로, 데이터의 삽입, 삭제, 검색 등의 연산을 빠르게 수행할 수 있다.

TreeMap은 키(Key)와 값(Value)을 가지는 요소들을 저장하는데, 이때 요소들은 트리의 노드(Node)로 구성된다. 각 노드는 자신보다 작은 값의 노드들과 자신보다 큰 값의 노드들을 가리키는 링크(자식노드)를 가지고 있으며, 이러한 구조가 이진트리(binary tree)를 형성한다.

TreeMap은 **키(Key)에 대한 정렬을 유지**하기 때문에, 요소들은 기본적으로 키(Key)에 대해 오름차순으로 정렬되어 있다. 따라서 TreeMap에서 제공하는 메서드를 사용하면 정렬된 순서대로 데이터를 조회하거나 **범위 검색(range search) 등의 연산**을 수행할 수 있다.

TreeMap의 시간 복잡도는 $O(logN)$이므로 많은 양의 데이터를 처리해야 하는 경우에도 빠른 성능을 제공한다. 그러나 추가적인 공간을 요구하기 때문에 메모리 사용량이 증가할 수 있다.

TreeMap의 활용 예시로는 사전(Dictionary)이나 전화번호부, 주소록 등의 데이터를 저장하는 용도로 사용될 수 있다. 또한 TreeMap은 자바(Java)에서 제공되는 컬렉션 프레임워크(Collection Framework)의 일부로 포함되어 있기 때문에, 자바 프로그래밍에서 많이 사용되는 자료구조 중 하나이다.
