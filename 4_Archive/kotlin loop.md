---
title: kotlin loop
date: 2022-08-16T21:03:00
publish: true
fc-calendar: Gregorian Calendar
fc-date: 2022-08-16
aliases: 
tags:
  - kotlin
  - loop
  - 반복문
categories: Kotlin
updated: 2025-01-07T00:36
---

[[Kotlin]] 에서는 Java 보다 훨씬 심플하고 편리한 반복문을 작성할 수 있다. 어떻게 사용할 수 있는지 살펴보자.

### 1. `..` operator

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    for (index in 0..fruits.size - 1) {
        val fruit = fruits[index]
        println("$index: $fruit")
    }
}
```

`..` 을 사용하면 1씩 증가하는 전통적인 반복문이 만들어진다.

### 2. `downTo`

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    for (index in fruits.size - 1 downTo 0) {
        val fruit = fruits[index]
        println("$index: $fruit")
    }
}
```

`downTo` 를 사용하면 읽히는대로, 감소하는 반복문이 실행된다.

### 3. `step`

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    for (index in 0..fruits.size - 1 step 2) {
        val fruit = fruits[index]
        println("$index: $fruit")
    }
}
```

`step` keyword 로 특정 숫자만큼 건너뛰는 반복문을 구현할 수 있다. `downTo` 에도 똑같이 적용된다.

### 4. `until`

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    for (index in 0 until fruits.size) {
        val fruit = fruits[index]
        println("$index: $fruit")
    }
}
```

`until` 을 사용하면 마지막 숫자를 포함하지 않는 루프를 만들어준다. 덕분에 `-1` 을 제거할 수 있게 된다.

### 5. lastIndex

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    for (index in 0 .. fruits.lastIndex) {
        val fruit = fruits[index]
        println("$index: $fruit")
    }
}
```

이번엔 `lastIndex` 속성의 사용이다. 이제야 반복문이 조금은 편하게 읽히기 시작한다. 당연히 여기서 끝은 아니다.

### 6. indices

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    for (index in fruits.indices) {
        val fruit = fruits[index]
        println("$index: $fruit")
    }
}
```

indices 는 collection 의 인덱스 범위를 반환해준다.

### 7. `withIndex()`

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    for ((index, fruit) in fruits.withIndex()) {
        println("$index: $fruit")
    }
}
```

`withIndex()` 의 사용으로 인덱스와 값을 동시에 꺼내면서 마치 파이썬만큼 코드가 단순해졌다. 이 정도면 거의 대부분의 반복문 작성엔 충분하지만, 또 다른 방법이 하나 남아있다.

### 8. forEachIndexed

```kotlin
val fruits = listOf("Apple", "Banana", "Cherry", "Durian")

fun main() {
    fruits.forEachIndexed { index, fruit ->
        println("$index: $fruit")
    }
}
```

lambda 를 사용하여 코드를 하나의 문장에 가깝게 만든다. 좀 더 단순해지거나, 직관적인 표현이 될 수 있다. 적당한 방식을 고르면 되겠다.

---

## Reference

[Kotlin Tips: Loops](https://www.youtube.com/watch?v=i-kyPp1qFBA)
