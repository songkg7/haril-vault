---
title: "ZonedDateTime 과 LocalDateTime 의 비교"
date: 2022-11-21 16:51:00 +0900
aliases: 
tags: [java, zoneddatetime, localdatetime, kotlin]
categories:
---

## Overview

[[Java]] 의 시간 관련 클래스인 ZonedDateTime 과 LocalDateTime 간의 시간 비교에 대해 알아봅니다.

## Contents

다음 코드를 보고 정답을 맞추실 수 있다면 이 글을 굳이 읽을 필요가 없을 것 같습니다.

TODO write example code

```java
// seoul localTime compareTo seoul utc
2022.01.01 00:00:00+09:00[Asia/Seoul]

// zonedId.("UTC") vs ZoneOffset.UTC
```

LocalDateTime 과 ZonedDateTime 이 실제로는 같은 시간을 표현하고 있어도 동등비교가 안된다는 것을 알 수 있습니다.

그래서 실제로 비교하기 위해 두개의 시간을 UTC 로 변환 후 검사해야 합니다.

kotlin 의 경우 extension method 를 통해서 간단하게 문제를 해결할 수 있습니다.

```kotlin
fun ZonedDateTime.isEqaulsTo(localDateTime: LocalDateTime): Boolean
```

## Conclusion

시간 관련된 클래스들은 그 쓰임새가 많기 때문에 정확하게 알고 사용하는 것이 중요합니다.