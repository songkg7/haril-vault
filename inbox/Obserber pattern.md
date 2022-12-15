---
title: "Obserber pattern"
date: 2022-12-12 12:27:00 +0900
aliases: 
tags: [design-pattern, obserber, java, kotlin]
categories: 
---

## Overview

[[Design pattern]] 중의 하나

특정 데이터의 변화가 생기면 해당 데이터를 팔로우하고 있는 객체들에게 알려주어 데이터를 갱신하게 하는 작업에 사용된다.

## Contents

[[Java]] 와 [[Kotlin]] 에서 각각의 사용법을 살펴보고 비교해봅니다.

### Java

#### Direct implementation

```java

```

#### Observable

```java
```

#### Flow

java 9 에서부터 기존 `Observable` 은 deprecated 되었다. 문제점을 개선한 `Flow` 의 사용을 권장한다.

```java
```

### Kotlin

#### Standard

![[스크린샷 2022-12-15 오후 1.11.56.png]]

```kotlin
```

#### Build-in observable delegate

Kotlin 에서는 언어 레벨에서 Observer 를 구현할 수 있도록 지원합니다.

```kotlin
class Sensor {
    var temperature: Int by Delegates.observable(0) { property, oldValue, newValue ->
        onChange(property, oldValue, newValue)
    }

    private fun onChange(property: KProperty<*>, oldValue: Int, newValue: Int) {
        println("Sensor: ${property.name} is changed from $oldValue to $newValue")
    }

}

fun main() {
    val sensor = Sensor()
    sensor.temperature = 10
    sensor.temperature = 20
} 
```

#### Signal - Slot Mechanism

```kotlin
class Signal<TType> {

    class Connection

    private val callbacks = mutableMapOf<Connection, (TType) -> Unit>()

    fun emit(newValue: TType) {
        callbacks.forEach { it.value(newValue) }
    }

    fun connect(callback: (TType) -> Unit): Connection {
        val connection = Connection()
        callbacks[connection] = callback
        return connection
    }

    fun disconnect(connection: Connection) {
        callbacks.remove(connection)
    }
}

class Sensor {
    val temperatureChanged = Signal<Int>()
}

class Monitor {
    fun onTemperatureChanged(newValue: Int) {
        println("Monitor: Temperature is changed to $newValue")
    }
}

fun main() {
    val sensor = Sensor()
    val monitor = Monitor()
    sensor.temperatureChanged.connect { monitor.onTemperatureChanged(it) }

    sensor.temperatureChanged.emit(10)
}
```

## Conclusion

예제 링크

## Reference

[observable](https://xzio.tistory.com/289)

[Observer pattern in Kotlin](https://in-kotlin.com/design-patterns/observer/)
