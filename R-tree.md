---
title: R-tree
date: 2024-01-21 22:14:00 +0900
aliases: 
tags:
  - r-tree
  - spatial-index
  - gist
  - geometry
categories: 
updated: 2024-01-21 22:14:51 +0900
---

## R-tree 란?

R-tree는 공간 데이터를 효율적으로 관리하기 위한 인덱스 구조로, 공간 데이터베이스나 지리 정보 시스템에서 사용된다. R-tree는 다차원 공간 객체를 계층적으로 구성하여 검색과 질의를 빠르게 수행할 수 있도록 한다.

R-tree는 [[B+Tree]] 와 유사한 개념을 가지며, 다차원 공간 객체를 담는 리프 노드들을 포함하는 내부 노드들로 구성된다. 각 리프 노드는 하나 이상의 공간 객체를 저장하고, 내부 노드는 자식 노드들을 가지며 각 자식 노드가 포함하는 영역을 커버하는 최소 경계 사각형(MBR)을 유지한다. 이러한 리프 노드와 내부 노드의 구조로 인해 R-tree는 다차원 공간 객체에 대한 범위 검색과 근접성 검색 등 다양한 종류의 질의를 효율적으로 처리할 수 있다.

R-tree는 지리 정보 시스템에서 주로 사용되며, 위치 기반 서비스, 지리 분석, 지형 모델링 등 다양한 응용 분야에서 활용되고 있다.