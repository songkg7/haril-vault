---
title: Large Language Models
date: 2024-08-14 23:46:00 +0900
aliases:
  - LLM
tags:
  - ai
categories: 
description: 
updated: 2024-08-14 23:46:50 +0900
---

## LLM(Large Language Model) 이란

LLM(Large Language Model)은 기존의 GPT모델과 BERT의 모델을 크게 확장시킨 것입니다. 이전에 사용하던 GPT는 110M개, BERT는 340M개의 파라미터를 가지고 있었지만, LLM은 17B(=17억)개의 파라미터를 가지고 있습니다.

이렇게 많은 파라미터를 가진 언어 모델이 만들어진 이유는 최근 머신러닝에서 적용되고 있는 데이터셋인 BERT와 GPT와 같은 사전학습된 언어모델을 이용하여 문제해결 능력을 높이기 위해서입니다. 이러한 언어 모델들은 초등학교에서부터 대학교까지의 텍스트를 수집하여 수십억 개의 단어로 구성된 데이터셋을 다양한 방식으로 학습하였기 때문에 일반적인 과제에서 매우 효율적으로 작동합니다.

LLM은 여러가지 장점이 있습니다. 그 중 하나는 초자연어처리(Super-Natural NLP)입니다. 초자연어처리란, 자연어 처리 분야에서 자연스러운 결과를 얻기 위해 사람들이 모델을 조금씩 수정하는 것을 말합니다. 예를 들어 문장을 생성하게 할 때, 사람들이 문장의 일부를 고정시키고 모델에게 나머지 부분만 제공하여 결과문장을 만들도록 합니다. 이러한 방식으로 생성된 문장은 훨씬 더 자연스럽게 느껴집니다.

또 다른 장점은 zero shot learning입니다. Zero shot learning이란, 모델에게 어떠한 학습도 하지 않고 새로운 태스크를 수행하도록 하는 것입니다. 예를 들어 GPT-3에서 새로운 문제를 해결해달라고 요청하면, 모델은 그 문제에 대한 정답을 제공할 수 있습니다.

LLM은 2019년 발표되었으며, GPT-3 역시 LLM 기반의 모델입니다.

#### 참고

* [OpenAI Blog](https://openai.com/blog/gpt-3-apps/)
* [The AI Language Model that is Too Dangerous to Release](https://www.youtube.com/watch?v=5K1Vi_HGTAE)

## GPT(Generic Pre-trained Transformer)

GPT는 OpenAI에서 개발한 재미있는 프로젝트 중 하나로 NLP(자연어처리) 엔진을 만드는 것입니다. 이 프로젝트는 총 4가지의 다른 GPT 모델을 사용하였고, 각각의 모델은 다양한 수준의 파라미터를 가지고 있습니다.

* GPT-1: 117M 파라미터로 구성된 모델
* GPT-2: 345M 파라미터로 구성된 모델
* GPT-3: 175B 파라미터로 구성된 모델

GPT는 OpenAI에서 공개한 최초의 NLP(자연어처리) 엔진 중 하나입니다. GPT는 크게 두 가지 방식으로 동작하는데, 첫 번째 방식은 대화형 AI를 위한 인코딩과 디코딩을 수행하는 것이며, 두 번째 방식은 언어 모델링(Language Modeling)을 위한 인코딩과 디코딩을 수행합니다.

### 대화형 AI

대화형 AI는 사용자가 입력한 문장에 대해 해당 문장에 알맞은 응답문장을 생성합니다. 이러한 기능은 주로 챗봇을 만드는 데 사용됩니다. 대화형 AI를 구현하기 위해서는 인코더가 입력 문장을 학습하고, 디코더가 해당 문장의 의미를 파악하고 적절한 응답문장을 생성하는 것이 필요합니다.

GPT는 이러한 기능을 수행하기에 가장 좋은 모델 중 하나입니다. GPT가 인코딩과 디코딩 모두를 수행할 수 있는 이유는 트랜스포머(Transformer)라는 구조를 사용하기 때문입니다. 트랜스포머는 인코더와 디코더로 구성되어 있으며, 각각 입력 문장과 대응되는 출력문장을 생성합니다.

### 언어 모델링

GPT의 다른 기능 중 하나인 언어 모델링은 주어진 문장에서 다음에 등장할 단어를 예상하는 작업입니다. 예를 들면 나는 고양이를 좋아한다 라는 문장이 있을 때, 나는 고양이를 좋아한다 뒤에 동사로 *논다*가 올지, *잡는다*가 올지 등등 다음 단어를 예상하는 기능입니다.

일반적으로 자연어처리 분야에서 사용되던 언어 모델은 일반적인 텍스트를 학습할 수 있지만, GPT의 언어 모델은 다양한 대화형 데이터셋을 학습하였기 때문에 대화형 AI에서 우수한 성능을 발휘합니다.

#### 참고

* [OpenAI Blog](https://openai.com/blog/gpt-3-apps/)
* [GPT-3의 175B 파라미터의 의미: 초대규모 모델의 효율성과 열린 문제들](https://huggingface.co/blog/how-gpt3-works)
* [The AI Language Model that is Too Dangerous to Release](https://www.youtube.com/watch?v=5K1Vi_HGTAE)

## BERT(Bidirectional Encoder Representations from Transformers)

BERT는 구글에서 개발한 자연어처리(NLP) 분야의 놀라운 기술 중 하나입니다. BERT는 11개의 비슷한 모델로 구성되어 있으며, 그 중 가장 유명한 것은 BERT Largely Multilingual입니다. 이 모델은 104개 언어로 구성된 데이터셋을 사용하여 학습하였기 때문에 NLP 분야에서 매우 강력한 성능을 발휘합니다.

BERT가 주목받게 된 이유 중 하나는 사전학습(pre-training) 기법입니다. 사전학습이란, 컴퓨터가 인간처럼 문장을 이해하고 생성할 수 있도록 미리 학습시키는 것을 말합니다. BERT는 이를 위해 다양한 학습방법을 사용하였지만, 가장 주목할 만한 방법은 마스킹(Masking) 기법입니다.
