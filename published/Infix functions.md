---
title: "[Kotlin] Infix functions"
categories: [Kotlin]
tags: [kotlin, infix]
date: 2022-08-16 21:15:00 +0900
publish: true
fc-calendar: Gregorian Calendar
fc-date: 2022-08-16
aliases: 
---

[[Kotlin]] 에는 Infix function 이라는 메서드 정의 방법이 있는데요,  Java 를 주언어로 쓰는동안엔 상상도 못했던 문법이라 처음 Kotlin 을 시작하시는 분들을 위해 소개합니다.

단일 매개변수를 가진 멤버 함수는 Infix functions 로 변환될 수 있습니다.

Infix functions 의 대표적인 예로는 기본 라이브러리에 포함된 `to` 가 있습니다.

```kotlin

val pair = "Ferrari" to "Katrina"

println(pair)

// (Ferrari, Katrina)

```

필요에 따라 `to` 와 같은 infix functions 을 새로 정의할 수 있는데 예를 들면 `Int` 를 다음과 같이 확장할 수 있습니다.

```kotlin

infix fun Int.times(str: String) = str.repeat(this)

println(2 times "Hello ")

// Hello Hello

```

`to` 를 직접 `onto` 라는 infix function 으로 재정의해보면 다음과 같이 작성할 수 있습니다.

```kotlin

infix fun String.onto(other: String) = Pair(this, other)

val myPair = "McLaren" onto "Lucas"

println(myPair)

// (McLaren, Lucas)

```

이런 Kotlin 의 문법은 꽤나 파격적인 코딩 방법을 가능하게 합니다.

```kotlin

class Person(val name: String) {

    val likedPeople = mutableListOf<Person>()

  

    infix fun likes(other: Person) {

        likedPeople.add(other)

    }

}

  

fun main() {

    val sophia = Person("Sophia")

    val claudia = Person("Claudia")

  

    sophia likes claudia // !!

}

```

---

### Reference

[Kotlin Docs](https://play.kotlinlang.org/byExample/01_introduction/02_Functions)
