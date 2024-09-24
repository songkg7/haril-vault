---
title: How to Generate QnA using OpenAI API
date: 2023-07-29 16:54:00 +0900
aliases: null
tags: openai, qna, kotlin, side-project
categories: null
updated: 2023-08-01 21:43:02 +0900
---

## Goal

1. 유저가 입력한 답은 질문과 함께 클라이언트에서 서버로 전송된다.
2. 서버는 Open AI API 를 사용하여 gpt model 에 해당 답에 대한 검사를 요청한다.
3. 검사 결과를 서버는 클라이언트로 전달한다.

## Kotlin Client

```kotlin
dependencies {
    implementation "com.aallam.openai:openai-client:3.3.0"
}
```

```kotlin
val chatCompletionRequest = ChatCompletionRequest(
  model = ModelId("gpt-3.5-turbo"),
  messages = listOf(
    ChatMessage(
      role = ChatRole.User,
      content = "Hello!"
    )
  )
)
val completion: ChatCompletion = openAI.chatCompletion(chatCompletionRequest)
// or, as flow
val completions: Flow<ChatCompletionChunk> = openAI.chatCompletions(chatCompletionRequest)
```

질문 데이터 저장방법

```json
[
    {
        "question": "What is the capital of the United States?",
        "choices": [
            "New York",
            "Washington D.C.",
            "Los Angeles",
            "Chicago"
        ],
        "correct": "Washington D.C.",
        "explanation": "The capital of the United States is Washington D.C.",
        "source": "https://en.wikipedia.org/wiki/Washington,_D.C.",
        "tags": [
            "geography",
            "united states"
        ],
        "DisplayCount": 1234,
        "correctCount": 300
    },
    {
        "question": "What is the capital of the Canada?",
        "choices": [
            "Toronto",
            "Ottawa",
            "Montreal",
            "Vancouver"
        ],
        "correct": "Ottawa",
        "explanation": "The capital of Canada is Ottawa.",
        "source": "https://en.wikipedia.org/wiki/Ottawa",
        "tags": [
            "geography",
            "canada"
        ],
        "DisplayCount": 1234,
        "correctCount": 10
    }
]
```
