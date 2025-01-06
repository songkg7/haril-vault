---
title: Fixture Monkey
date: 2024-01-31T13:03:00
aliases: 
tags:
  - testing
  - test
  - fixture
  - naver
  - opensource
categories: 
updated: 2025-01-07T00:36
---

> "Write once, Test anywhere"

네이버에서 오픈소스로 개발되고 있는 테스트 객체 생성 라이브러리이다. 아마도 이름은 넷플릭스의 오픈소스, [Chaos Monkey](https://netflix.github.io/chaosmonkey/) 에서 따온 듯하다. 랜덤으로 테스트 픽스처를 생성해주기 때문에, 실제로 카오스 엔지니어링을 하는 체험을 할 수 있다.

약 2년 전 처음 접한 이후, 가장 좋아하는 오픈소스 라이브러리 중 하나가 되었다. 어쩌다보니 글도 2편이나 썼다.

- [Fixture Monkey 객체 생성 전략](https://songkg7.github.io/posts/Fixture-monkey-overview/)
- [Fixture Monkey 0.4.x](https://songkg7.github.io/posts/labmonkey/)

이후로 버전이 변할 때마다 변경점이 너무 많아 추가적인 글을 안적고 있다가, 최근 1.x 가 릴리즈되었기에 새로운 마음으로 다시 소개글을 써본다.

이전 글에서는 [[Java]] 를 기준으로 글을 작성했지만, 최근 추세에 맞춰서 [[Kotlin]] 으로 작성한다. 글 내용은 공식 문서를 기반으로 실제 사용 후기를 좀 섞었다.

## 왜 Fixture Monkey 가 필요한가

아래 같은 코드를 보면서 기존 방식에서 어떤 점이 문제인지 살펴보자.

> [!NOTE] Kotest
> [[Java]] 개발자들에게 익숙한 JUnit5 를 사용하여 예제를 작성했다. 하지만 Kotlin 환경에서는 [[Kotest]]를 사용하는 것을 조금 더 권장한다.

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
fun basic() {
    val actual: Product = Product(
        id = 1L,
        price = 1000L,
        productName = "productName",
        productType = ProductType.FOOD,
        options = listOf(
            "option1",
            "option2"
        ),
        createdAt = Instant.now(),
        merchantInfo = mapOf(
            1 to "merchant1",
            2 to "merchant2"
        )
    )

    // 테스트 목적에 비해 준비 과정이 길다
    actual shouldNotBe null
}
```

### 테스트 객체 생성의 어려움

테스트 코드를 살펴보면 assertion 을 위해 객체를 생성하기 위해 작성해야 하는 코드가 너무 많다고 느껴진다. 구현 내용상 프로퍼티를 설정하지 않으면 컴파일 에러가 발생하기 때문에, 무의미한 프로퍼티라도 반드시 작성해줘야 한다.

이렇게 테스트 코드에서 assertion 을 위해 준비해야하는 부분이 길어지면, 코드에 테스트 목적에 대한 의미가 불분명해질 수 있다. 처음 이 코드를 읽는 사람은 아무 의미 없는 프로퍼티여도 숨은 의미가 있는지 살펴봐야하기 때문이다. 이 과정은 개발자들의 피로감을 높인다.

### 엣지 케이스 인식의 어려움

직접 프로퍼티를 설정하여 객체를 생성할 경우, 프로퍼티가 고정되기 때문에 다양한 시나리오에서 나타날 수 있는 엣지 케이스를 놓치는 경우가 많다.

```kotlin
val actual: Product = Product(
    id = 1L, // 만약 id 가 음수가 되면 어떨까?
    // ...생략
)
```

엣지 케이스를 찾기 위해서는 하나하나 개발자가 프로퍼티를 설정해가며 검증해줘야 하는데, 대부분의 경우는 에러가 발생하고 나서야 알게 된다. 에러가 발생하기 전에 엣지 케이스를 수월하게 발견하기 위해서는 객체의 프로퍼티가 어느 정도 랜덤성을 갖고 설정되야 한다.

### 오브젝트 마더 패턴의 문제점

테스트 객체를 재사용하기 위해 팩토리 클래스를 생성하고 해당 클래스에서 객체를 생성하여 테스트 코드를 실행하는 패턴을 오브젝트 마더(Object mother) 패턴이라고 부른다.

하지만 이런 방법은 테스트 코드 뿐만이 아니라 팩토리까지 지속적으로 관리해야 하기 때문에 별로 좋아하는 방법이 아니다. 또한 여전히 엣지 케이스를 찾아내는데에는 전혀 도움이 되지 않는다.

## Fixture Monkey 를 사용해보자

Fixture Monkey 는 재사용성, 랜덤성을 통해 상술했던 문제점을 우아하게 해결한다. 지금부터 어떻게 문제를 해결하는지 살펴보자.

```kotlin
testImplementation("com.navercorp.fixturemonkey:fixture-monkey-starter-kotlin:1.0.13")
```

먼저 의존성을 추가해준다.

```kotlin
@Test
fun test() {
    val fixtureMonkey = FixtureMonkey.builder()
        .plugin(KotlinPlugin())
        .build()
}
```

`KotlinPlugin()` 을 적용하여 Kotlin 환경에서도 Fixture Monkey 를 사용할 수 있다.

위에서 사용했던 `Product` 클래스를 가지고 다시 테스트를 작성해보자.

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

불필요한 프로퍼티 설정 과정 없이 순식간에 `Product` 인스턴스를 생성하여 테스트할 수 있다. 모든 프로퍼티 값은 기본적으로 랜덤하게 채워진다.

![](https://i.imgur.com/OxgNxNx.png)

_여러 프로퍼티들을 잘 채워준다_

### Post Condition

하지만 대부분의 경우, **특정 조건에 맞는 프로퍼티 값이 필요**하다. 예를 들어 예시에서는 `id` 가 음수로 생성되었지만, 실제로 `id` 는 양수로 사용하는 경우가 많을 것이다.

![](https://i.imgur.com/ZdFuJtM.png)

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

### 다양한 프로퍼티 설정

`postCondition` 을 사용할 때는 주의해야할 점이 있는데, 만약 생성 조건을 너무 좁게 설정할 경우 객체 생성 비용이 너무 비싸질 수 있다. 이는 조건에 맞는 객체가 생성될 때까지 내부적으로 생성을 반복하기 때문이다. 이럴 때는 `setExp` 을 사용하여 특정 값을 고정하는 것이 훨씬 좋다.

```kotlin
val actual = fixtureMonkey.giveMeBuilder<Product>()
    .setExp(Product::id, 1L) // 고정값을 제외한 나머지는 랜덤이 된다
    .sample()

actual.id shouldBe 1L
```

프로퍼티가 컬렉션일 경우는 `sizeExp` 를 사용하여 컬렉션의 크기를 지정해줄 수도 있다.

```kotlin
val actual = fixtureMonkey.giveMeBuilder<Product>()
    .sizeExp(Product::options, 3)
    .sample()

actual.options.size shouldBe 3
```

`maxSize`, `minSize` 를 사용하면 컬렉션의 최대 최소 사이즈 조건을 간단하게 지정할 수 있다.

```kotlin
val actual = fixtureMonkey.giveMeBuilder<Product>()
    .maxSizeExp(Product::options, 10)
    .sample()

actual.options.size shouldBeLessThan 11
```

이 외에도 다양한 프로퍼티 지정 메서드들이 있으니, 필요할 때 살펴보시길 권한다.

## Conclusion

Fixture Monkey 는 단위테스트를 작성하면서 불편했던 부분들을 정말 잘 해소해준다. 이 글에서 예제로 언급하지는 않았지만, 빌더에 원하는 조건을 만들어놓고 재사용할 수 있고 프로퍼티에 랜덤성을 부여하여 개발자가 미처 찾지 못한 엣지 케이스들을 찾을 수 있게 도와준다. 덕분에 테스트 코드가 매우 짧아지고 오브젝트 마더같은 부가적인 코드가 필요없기 때문에 유지보수하기 편해지는 것은 덤이다.

Fixture Monkey 의 1.x 버전이 릴리즈되기 전에도 운영 환경에 도입해보며 테스트 코드 작성에 많은 도움을 받고 있었다. 이제는 안정화 버전이 된만큼 부담없이 도입해서 즐거운 테스트 코드 작성이 되시기를 바란다.

## Reference

- [Fixture Monkey](https://github.com/naver/fixture-monkey)
