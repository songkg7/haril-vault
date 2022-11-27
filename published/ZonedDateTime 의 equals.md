---
title: "ZonedDateTime 의 equals"
date: 2022-11-21 16:51:00 +0900
aliases: 
tags: [java, zoneddatetime]
categories: Java
---

## Overview

[[Java]] 에는 시간을 표현할 수 있는 여러 객체들이 있습니다. 이번 글에서는 그 중 가장 많은 정보를 담고 있는 객체 중 하나인 `ZonedDateTime` 에 대해서 어떤 방식으로 시간 비교가 이루어지는지 적어보려 합니다.

## 다르지만 같은 시간?

간단하게 테스트 코드를 작성해보면서 특이점을 찾아보겠습니다.

```java
ZonedDateTime seoulZonedTime = ZonedDateTime.parse("2021-10-10T10:00:00+09:00[Asia/Seoul]");
ZonedDateTime utcTime = ZonedDateTime.parse("2021-10-10T01:00:00Z[UTC]");

assertThat(seoulZonedTime.equals(utcTime)).isFalse();  
assertThat(seoulZonedTime).isEqualTo(utcTime);
```

이 코드는 통과하는 테스트 코드입니다. `equals` 는 `false` 인데 `isEqualsTo` 는 통과하니 이게 어떻게 된 일일까요?

실제로 위 코드에서 2개의 `ZonedDateTime` 은 서로 같은 시간을 표현하고 있습니다. 하지만 `ZonedDateTime` 은 내부적으로 `LocalDateTime`, `ZoneOffset`, `ZoneId` 을 함께 가지는 객체이기 때문에 `equals` 를 통해 비교되는건 절대적인 시간이 아닌 객체들이 서로 같은 값을 지니는지 비교됩니다.

따라서, `equals` 를 통해서는 `false` 가 반환되게 됩니다.

![[스크린샷 2022-11-26 오전 7.53.57.png]]

_ZonedDateTime#equals_

하지만 `isEqaulTo` 는 그렇지 않은 것으로 보아 시간 객체에서 `isEqualTo` 는 동작방식이 다르다고 추측할 수 있습니다.

실제로 `ZonedDateTime` 을 비교할 때 `isEqualTo` 는 `ZonedDateTime` 의 `equals` 를 호출하지 않고 `ChronoZonedDateTimeByInstantComparator#compare` 를 호출하며 동작합니다.

![[스크린샷 2022-11-26 오전 6.46.13.png]]

![[스크린샷 2022-11-26 오전 6.48.25.png]]

_functinal interface 로 comparator 의 compare 가 호출되게 된다._

내부 구현을 보면 `toEpochSecoend()` 를 통해서 초로 변환 후 비교하는 것을 확인할 수 있습니다. `equals` 를 통한 객체 비교가 아닌 `compare` 를 통한 숫자 비교기 때문에 절대적인 시간을 비교하는 셈이 됩니다.

따라서 `ZonedDateTime` 을 직접 비교하는 것이 아니라 내부에 `ZonedDateTime` 을 포함한 객체를 비교할 때는 `equals` 가 호출되므로 `ZonedDateTime` 의 절대값으로 비교하고 싶다면, 객체 내부의 `equals` 를 재정의해주면 됩니다.

```java
public record Event(
        String name,
        ZonedDateTime eventDateTime
) { 
    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Event event = (Event) o;
        return Objects.equals(name, event.name)
                && Objects.equals(eventDateTime.toEpochSecond(), event.eventDateTime.toEpochSecond());
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, eventDateTime.toEpochSecond());
    }
}
```

```java
@Test
void equals() {
	ZonedDateTime time1 = ZonedDateTime.parse("2021-10-10T10:00:00+09:00[Asia/Seoul]");
	ZonedDateTime time2 = ZonedDateTime.parse("2021-10-10T01:00:00Z[UTC]");

	Event event1 = new Event("event", time1);
	Event event2 = new Event("event", time2);

	assertThat(event1).isEqualTo(event2); // pass
}
```

## Conclusion

- `ZonedDateTime` 간 `equals` 가 호출될 때 절대적 시간을 비교하고 싶다면 `toEpochSecond()` 처럼 변환 작업을 거친 후 비교해야 한다.
- `ZonedDateTime` 을 `isEqualTo` 로 직접 비교한다면 내부에서 변환 작업을 거치므로 따로 변환하지 않아도 된다.
- 객체 내부의 `ZonedDateTime` 이 있다면 필요에 따라 객체의 `equals` 를 재정의해야할 수 있다.
