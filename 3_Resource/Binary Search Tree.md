---
title: Binary Search Tree
date: 2023-09-17T21:00:00
aliases:
  - BST
tags:
  - tree
  - algorithm
  - data-structure
  - sort
  - binary
categories: 
updated: 2025-01-07T00:35
---

이진탐색트리(Binary Search [[Tree]], BST) 는 왼쪽 자식은 부모보다 작고 오른쪽 자식은 부모보다 큰 이진트리([[Binary Tree|Binary Tree]]) 이다.

이진탐색트리는 다음과 같은 특징을 가지고 있다:

1. 왼쪽 자식은 부모보다 작다: 이진탐색트리의 모든 노드에서 왼쪽 서브트리에 속한 노드들의 값은 해당 노드보다 작다.
2. 오른쪽 자식은 부모보다 크다: 이진탐색트리의 모든 노드에서 오른쪽 서브트리에 속한 노드들의 값은 해당 노드보다 크다.
3. 중복된 값이 없다: 이진탐색트리에서는 동일한 값의 노드가 존재하지 않는다.

이진탐색트리는 이러한 특징을 활용하여 효율적인 탐색과 삽입, 삭제 연산을 수행할 수 있다. 탐색 연산은 현재 노드와 찾고자 하는 값을 비교하면서 왼쪽이나 오른쪽 자식으로 이동하며 수행되며, 삽입과 삭제 연산은 적절한 위치를 찾아서 새로운 노드를 추가하거나 기존의 노드를 삭제하는 방식으로 수행된다.

이진탐색트리는 정렬된 데이터를 저장하고 탐색하는데 효율적인 자료구조로 사용된다. 그러나 데이터의 분포에 따라 트리의 형태가 한쪽으로 치우치게 되면 최악의 경우 탐색, 삽입, 삭제 연산의 시간복잡도가 $O(n)$이 될 수 있으므로 이를 방지하기 위해 균형을 유지하는 자료구조인 [[Adelson-Velsky and Landis|AVL Tree]], 레드-블랙 트리([[Red-Black Tree]]) 등이 사용된다.

## Reference

- https://velog.io/@dlgosla/CS-%EC%9E%90%EB%A3%8C%EA%B5%AC%EC%A1%B0-%EC%9D%B4%EC%A7%84-%ED%8A%B8%EB%A6%AC-Binary-Tree-vzdhb2sp
