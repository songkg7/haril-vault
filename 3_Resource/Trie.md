---
title: Trie
date: 2023-10-05T14:13:00
aliases: 
tags:
  - trie
  - algorithm
  - tree
  - string
categories: 
updated: 2025-01-07T00:35
---

트라이(Trie)는 문자열을 효율적으로 저장하고 검색하기 위해 사용되는 트리([[Tree]]) 형태의 데이터 구조입니다. 접두사 트리(prefix tree)라고도 불리며, 접두사를 기반으로 한 효율적인 검색이 가능합니다.

트라이의 구조는 노드로 이루어져 있으며, 각 노드는 문자열에서 하나의 문자를 나타냅니다. 각 노드는 여러 개의 자식을 가지고 있는데, 이들은 엣지(edge)로 연결되어 있습니다. 엣지는 현재 문자 다음에 올 수 있는 문자들을 나타냅니다.

루트 노드는 빈 문자열을 나타내며, 각 자식 노드는 현재 문자 다음에 올 수 있는 가능한 문자를 나타냅니다. 트라이의 리프 노드는 완전한 단어를 나타냅니다.

트라이를 사용하는 주요 장점 중 하나는 **동일한 접두사를 가진 단어들을 효율적으로 검색할 수 있다**는 점입니다. 입력된 단어의 각 문자에 기반하여 트라이를 탐색함으로써 동일한 접두사를 가진 모든 단어들을 빠르게 찾아낼 수 있습니다.

트라이는 스펠 체크, 자동 완성, 검색 알고리즘 등 다양한 응용 분야에서 일반적으로 사용됩니다. 특히 대량의 문자열 집합이나 접두사를 기반으로 한 빠른 검색이 필요한 경우에 유용합니다.

검색 외에도 트라이는 삽입과 삭제와 같은 다른 연산을 지원합니다. 새로운 단어를 트라이에 삽입할 때는 단어의 각 문자를 반복적으로 새로운 노드로 추가합니다. 삭제는 주어진 단어와 해당하는 문자에 대응하는 노드들을 제거함으로써 이루어집니다.

트라이는 문자열에 대한 효율적인 저장과 검색을 제공하지만, 트리 형태의 구조 때문에 상당한 메모리 자원을 필요로 할 수 있습니다. 또한 메모리 사용을 최소화해야 하는 경우나 큰 알파벳을 다룰 때는 적합하지 않을 수 있습니다.

요약하자면, 트라이는 문자열을 문자 기반으로 나무 형태로 구성하여 효율적인 저장과 검색을 가능하게 하는 데이터 구조입니다. 접두사를 기반으로 한 빠른 검색을 제공하며, 스펠 체크와 자동 완성과 같은 응용 분야에서 널리 사용됩니다.
