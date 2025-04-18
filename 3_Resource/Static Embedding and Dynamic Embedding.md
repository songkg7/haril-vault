---
title: 
date: 2025-04-13T21:04:25+09:00
aliases: 
tags:
  - llm
  - ai
  - embedding
description: 
updated: 2025-04-13T21:06
---

## Q. 동음이의어 처리는 어떻게 할까?

[static embedding과 dynamic embedding](https://deepdata.tistory.com/1437)

동음이의어를 판단할 수 있으려면 문맥을 이해할 수 있어야 한다. 특정 단어 단위로 토큰화할 경우 문맥을 알 수 없어서 정확한 의미를 파악하기 어려울 수 있다.

따라서 단어 단위가 아니라 문장 전체를 임베딩해야 한다.

사용자가 어떤 문장을 전달할 지 알기 어렵기 때문에 입력때마다 동적으로 임베딩하여 벡터를 조절할 필요가 있다. 이를 동적 임베딩이라고 한다.
