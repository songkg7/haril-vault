---
title: Kotlin 에서 builder 는 정말 의미가 없을까?
date: 2022-10-12 20:09:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-10-12
aliases: 
tags:
  - kotlin
  - builder
  - design-pattern
categories: 
updated: 2023-09-04 11:57:33 +0900
---

[[Kotlin]] 은 default value 를 통해서 생성자로 값을 초기화하지 않아도 되는 기능을 이미 가지고 있다. 때문에 필요없는 파라미터를 굳이 생성자를 통해 전달하지 않아도 되기 때문에, `Builder` 를 구현하는 의미가 약한 것은 사실이다.

하지만 `Builder` 는 단순한 생성을 넘어서 초기화 과정에서 다양한 일을 할 수 있도록 도와주는 면이 분명 존재하기 때문에, Kotlin 이라고 해서 builder 가 필요없는 것은 아니라고 생각한다.

왜 그렇게 생각하는지 다음 예를 통해 살펴보자.


## Kotlin 에서 builder 를 대체할 수 있는 방법

## Kotlin 에서 Builder 를 구현하는 방법

```kotlin
class FoodOrder private constructor(
    val bread: String?,
    val condiments: String?,
    val meat: String?,
    val cheese: String?,
    val vegetables: String?,
) {
    data class Builder(
        private var bread: String? = null,
        private var condiments: String? = null,
        private var meat: String? = null,
        private var cheese: String? = null,
        private var vegetables: String? = null,
    ) {
        fun bread(bread: String) = apply { this.bread = bread }
        fun condiments(condiments: String) = apply { this.condiments = condiments }
        fun meat(meat: String) = apply { this.meat = meat }
        fun cheese(cheese: String) = apply { this.cheese = cheese }
        fun vegetables(vegetables: String) = apply { this.vegetables = vegetables }
        fun build() = FoodOrder(bread, condiments, meat, cheese, vegetables)
    }
} 
```

```kotlin
internal class FoodOrderTest: DescribeSpec({

    describe("builder pattern") {
        it("usage") {
            val order = FoodOrder.Builder()
                .bread("white bread")
                .condiments("mayo")
                .meat("chicken")
                .cheese("cheddar")
                .vegetables("lettuce")
                .build()

            with(order) {
                bread shouldBe "white bread"
                condiments shouldBe "mayo"
                meat shouldBe "chicken"
                cheese shouldBe "cheddar"
                vegetables shouldBe "lettuce"
            }
        }
    }
}) 
```

## Builder 를 통한 메소드 overloading

특정 field 가 first class collection 인 경우, 다양한 타입으로 받은 후 변환하는 과정을 builer 에 숨길 수 있다.

만약 Web API 를 구현하고 있다면, DTO 를 생성해서 전달해야할 경우가 생기는데 이럴 때 builder 를 이용하면 DTO 의 생성을 다양한 방식으로 제어할 수 있다.

## Conclusion

## Links

- [[Design Pattern]]
