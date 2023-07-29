---
title: "How to Generate QnA using OpenAI API"
date: 2023-07-29 16:54:00 +0900
aliases: 
tags: [openai, qna, kotlin, side-project]
categories: 
updated: 2023-07-29 16:54:58 +0900
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
