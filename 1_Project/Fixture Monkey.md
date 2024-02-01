---
title: Fixture Monkey
date: 2024-01-31 13:03:00 +0900
aliases: 
tags:
  - testing
  - test
  - fixture
  - naver
  - opensource
categories: 
updated: 2024-02-01 17:43:45 +0900
---

Naver 에서 공개한 테스트 객체 생성 라이브러리

> "Write once, Test anywhere"

작성할 내용

- postCondition 을 사용하여 특정 조건에 맞는 객체만 생성할 수 있다
    - 단, 퍼포먼스가 심각하게 저하될 수 있으므로 너무 좁은 조건은 set 을 대신 사용하는게 권장
- builder 는 미리 생성해놓고 재활용할 수 있다
    - 복잡한 기본값을 가진 객체라면 유용하다

아마도 이름은 넷플릭스의 오픈소스, 카오스 몽키에서 가져온 듯하다. 랜덤으로 테스트 픽스처를 생성해주기 때문에, 실제로 카오스 엔지니어링을 하는 체험을 할 수 있다.

약 2년 전 처음 접한 이후, 가장 좋아하는 오픈소스 라이브러리 중 하나가 되었다. 어쩌다보니 글도 2편이나 썼다.

- [[Fixture Monkey 0.3]]
- [[Fixture Monkey 0.4.x]]

버전이 변할 때마다 변경점이 너무 많아 추가적인 글을 안적고 있다가, 최근 1.x 가 릴리즈되어 최종_final 느낌의 글을 하나 써본다.

지금까지는 [[Java]] 를 기준으로 글을 작성했지만, 최근 추세에 맞춰서 [[Kotlin]] 으로 작성한다. 글 내용은 공식 문서를 기반으로 실제 사용 후기를 좀 섞었다.

## 왜 Fixture Monkey 가 필요한가

- 테스트 픽스처를 생성하는게 너무 번거로워서 테스트 코드의 원래 목적을 잊을 수 있다
- 오브젝트 마더 패턴 등을 사용하여 테스트 전용 클래스를 구현하는 것은, 결국 관리해야할 코드가 늘어난다는 것을 의미한다
- 엣지 케이스에 대한 고민도 어려운 부분이다. Fixture Monkey 는 테스트 픽스처의 프로퍼티를 랜덤하게 생성해줌으로써, 개발자가 미처 예상하지 못한 케이스도 찾아낼 수 있게 해준다. 결과적으로 코드의 안정성이 개선된다.

## Fixture Monkey Instance

```kotlin
testImplementation("com.navercorp.fixturemonkey:fixture-monkey-starter-kotlin:1.0.13")
```

먼저 의존성을 추가해주자.

```kotlin
@Test
fun test() {
    val fixtureMonkey = FixtureMonkey.builder()
        .plugin(KotlinPlugin())
        .build()
}
```

`KotlinPlugin()` 을 적용하여 Kotlin 환경에서도 Fixture Monkey 를 사용할 수 있다.

아래와 같은 클래스가 있다고 할 때,

```kotlin
data class Product (
    val id: Long,

    val productName: String,

    val price: Long,

    val options: List<String>,

    val createdAt: Instant,

    val productType: ProductType,

    val merchantInfo: Map<Int, String>
)

enum class ProductType {
    ELECTRONICS,
    CLOTHING,
    FOOD
}
```

```kotlin
@Test
fun test() {
    val fixtureMonkey = FixtureMonkey.builder()
        .plugin(KotlinPlugin())
        .build()

    val actual: Product = fixtureMonkey.giveMeOne()

    actual shouldNotBe null
}
```

순식간에 `Product` 인스턴스를 생성하여 테스트할 수 있다. 모든 속성 값은 기본적으로 랜덤하게 채워진다.

![](https://i.imgur.com/OxgNxNx.png)

_여러 프로퍼티들을 잘 채워준다_

## Property 설정

### Post Condition

하지만 대부분의 경우, **특정 조건에 맞는 프로퍼티 값이 필요**하다. 예를 들어 예시에서는 `id` 가 음수로 생성되었지만, 실제로 `id` 는 양수로 사용하는 경우가 많을 것이다.

랜덤 속성을 유지하되, 범위를 조금 제한해보자.

```kotlin
@RepeatedTest(10)
fun postCondition() {
    val fixtureMonkey = FixtureMonkey.builder()
        .plugin(KotlinPlugin())
        .build()

    val actual = fixtureMonkey.giveMeBuilder<Product>()
        .setPostCondition { it.id > 0 } // 생성 객체의 프로퍼티 조건을 지정한다
        .sample()

    actual.id shouldBeGreaterThan 0
}
```

값이 랜덤하게 생성되기 때문에, `@RepeatedTest` 를 사용하여 10번 반복하여 테스트를 실행해줬다.

![](https://i.imgur.com/9NCTgr5.png)

모두 통과하는걸 볼 수 있다. 모든 값이 랜덤하게 생성된다는 점은, 미처 생각하지 못한 **엣지 케이스를 찾는데 특히 유용**하다.

### setExp

`postCondition` 을 사용할 때는 주의해야할 점이 있는데, 만약 생성 조건을 너무 좁게 설정할 경우 객체 생성 비용이 너무 비싸질 수 있다. 이는 조건에 맞는 객체가 생성될 때까지 내부적으로 생성을 반복하기 때문이다. 이럴 때는 `setExp` 을 사용하여 특정 값을 고정하는 것이 훨씬 좋다.

```kotlin
val actual = fixtureMonkey.giveMeBuilder<Product>()
    .setExp(Product::id, 1L)
    .sample()

actual.id shouldBe 1L
```

## Kotest 와 함께

지금까지는 [[Java]] 개발자들에게 익숙한 JUnit5 를 사용하여 예제를 작성했다. 하지만 Kotlin 환경에서는 [[Kotest]]를 사용하는 것을 조금 더 권장한다.

## 아쉬운 점

거의 모든 면이 만족스럽지만, 아쉬운 점이 없지는 않다.

- 최신버전의 JUnit5 의 경우 parallel test 기능이 지원되지만, Fixture Monkey 는 parallel 기능을 지원하지 않기 때문에 아쉽지만 병렬 테스트는 수행할 수 없다.

## Reference

- [Fixture Monkey](https://github.com/naver/fixture-monkey)
