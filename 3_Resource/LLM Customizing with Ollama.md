---
title: LLM Customizing with Ollama
date: 2024-11-11T23:23:00
aliases: 
tags:
  - ai
  - ollama
  - llm
description: 
updated: 2025-01-07T00:35
---

- gguf 파일을 Modelfile 에 얹어서 `ollama create {name} -f Modelfile`
- `ollama run {name}`
- 위 과정으로 간단하게 로컬에서 LLM 의 복제 생성 가능
- Modelfile 을 커스텀하면 아웃풋을 제어할 수 있음
- [[Retrieval-Augmented Generation|RAG]] 까지 쉽게

---

- 자신의 옵시디언 vault 를 [[Retrieval-Augmented Generation|RAG]] 로 써서 자연어 문서 검색이 가능하게 하면 어떨까?