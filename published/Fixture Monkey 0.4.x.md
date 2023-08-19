---
title: Fixture monkey 0.4.x
date: 2022-11-11 14:25:00 +0900
aliases: null
tags:
  - fixture
  - test
  - naver
  - open-source
categories: null
updated: 2023-08-19 12:38:06 +0900
---

## Overview

[[Fixture monkey]] 가 0.4.x 으로 업데이트되면서 많은 기능의 변경이 있었다. 이전 글을 작성한지 채 한달도 되지 않았는데 많은 수정이 발생해서(ㅠ) 당황스러웠지만, 커뮤니티가 활발한 신호라는 점으로 마음을 위로하면서 업데이트된 부분을 반영하여 새로 글을 작성한다.

## Contents
 
### 변경된 사항

#### LabMonkey

실험적인 기능이 추가된 인스턴스.

`FixtureMonkey` 를 상속하여 기존 기능을 지원하면서 몇가지 메서드들이 추가되었다. 전체적인 사용방법은 비슷하니, `FixtureMonkey` 대신에 `LabMonkey` 를 사용하면 될 것 같다. `1.0.0` 이후로는 `LabMonkey` 의 기능을 deprecated 하고 같은 기능을 `FixtureMonkey` 에서 제공할 예정이라고 한다.

```java
private final LabMonkey fixture = LabMonkey.create();
```

#### 객체 생성 방식의 변경

`ArbitraryGenerator` 가 아닌 `ArbitraryIntrospector` 가 담당하도록 변경되었다.

#### Record 지원

이제 `Record` 또한 fixture monkey 를 통해 생성할 수 있다.

```java
public record LottoRecord(int number) {} 
```

```java
class LottoRecordTest {

    private final LabMonkey fixture = LabMonkey.labMonkeyBuilder()
     .objectIntrospector(ConstructorPropertiesArbitraryIntrospector.INSTANCE)
            .build();

    @Test
    void shouldBetween1to45() {
        LottoRecord lottoRecord = fixture.giveMeOne(LottoRecord.class);

        System.out.println("lottoRecord: " + lottoRecord);
    }
} 
```

```console
lottoRecord: LottoRecord[number=-6]
```

`ConstructorPropertiesArbitraryIntrospector` 를 사용하여 객체를 생성하면 Record 객체를 생성할 수 있다. `0.3.x` 버전에서는 `ConstructorProperties` annotation 이 필요했었는데 이젠 프로덕션 코드에 수정을 가하지 않아도 되니 꽤나 큰 변화라고 할 수 있겠다.

이외에도 다양한 `Introspector` 가 존재하여 객체의 형태에 맞는 방식으로 객체 생성을 지원한다.

#### Plugin

```java
private final LabMonkey fixture = LabMonkey.labMonkeyBuilder()
		.objectIntrospector(ConstructorPropertiesArbitraryIntrospector.INSTANCE)
		.plugin(new JavaxValidationPlugin())
		.build(); 
```

`plugin()` 이라는 api 를 통해 간편하게 plugin 을 추가할 수 있다. `JavaxValidationPlugin` 을 추가해주면 java bean validation 기능을 적용하여 객체를 생성할 수 있다.

일종의 데코레이터 패턴으로 구현한 것 같은데, 여러가지 서드파티 플러그인의 개발 및 적용이 용이해질 것으로 보인다.

```java
public record LottoRecord(
        @Min(1)
        @Max(45)
        int number
) {
    public LottoRecord {
        if (number < 1 || number > 45) {
            throw new IllegalArgumentException("로또 번호는 1~45 사이의 숫자여야 합니다.");
        }
    }
} 
```

```java
@RepeatedTest(100)
void shouldBetween1to45() {
	LottoRecord lottoRecord = fixture.giveMeOne(LottoRecord.class);

	assertThat(lottoRecord.number()).isBetween(1, 45);
} 
```

## Conclusion

이전 글에서 아쉽다고 지적했던 부분이 대폭 개선되어서 정말 만족스럽다. 근데 document 가 좀 부실해진거 같은데...
