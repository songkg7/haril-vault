---
title: Observer pattern
date: 2022-12-12 12:27:00 +0900
aliases: null
tags:
  - design-pattern
  - observer
  - java
  - kotlin
categories: null
updated: 2023-08-19 12:38:13 +0900
---

## Overview

[[Design pattern]] 중의 하나

특정 데이터의 변화가 생기면 해당 데이터를 팔로우하고 있는 객체들에게 알려주어 데이터를 갱신하게 하는 작업에 사용된다.

## Contents

[[Java]] 와 [[Kotlin]] 에서 각각의 사용법을 살펴보고 비교해봅니다.

날씨 정보가 갱신되면 구독하고 있는 객체들에게 알려주는 예제입니다.

### Java

#### Direct implementation

```java
public interface Observer {

    void update(float temp, float humidity, float pressure);

} 
```

데이터가 변경되면 `Observer` 의 정보를 `update` 를 통해 변경합니다.

```java
public interface Subject {

    void registerObserver(Observer o);
    void removeObserver(Observer o);
    void notifyObservers();

}
```

`notifiyObservers` 를 통해 `Subject` 를 구독하고 있는 객체들에게 변경사항을 통지합니다.

```java
public interface DisplayElement {

        void display();

}
```

데이터 출력의 역할을 해줄 `DisplayElement` 입니다.

```java
public class Weather implements Subject {
    private final List<Observer> observers = new ArrayList<>();
    private float temperature;
    private float humidity;
    private float pressure;

    @Override
    public void registerObserver(Observer o) {
        observers.add(o);
    }

    @Override
    public void removeObserver(Observer o) {
        int i = observers.indexOf(o);
        if (i >= 0) {
            observers.remove(i);
        }
    }

    @Override
    public void notifyObservers() {
        observers.forEach(observer -> observer.update(temperature, humidity, pressure));
    }

    public void measurementsChanged() {
        notifyObservers();
    }

    public void setMeasurements(float temperature, float humidity, float pressure) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.pressure = pressure;
        measurementsChanged();
    }
}
```

```java
public class CurrentConditionsDisplay implements Observer, DisplayElement {

    private int id;
    private float temperature;
    private float humidity;
    private Subject weather;

    public CurrentConditionsDisplay(Subject weather, int id) {
        this.id = id;
        this.weather = weather;
        weather.registerObserver(this);
    }

    @Override
    public void display() {
        System.out.println(
                "Divice ID: " + id + " Current conditions: " + temperature + " F degrees and " + humidity
                        + "% humidity");
    }

    @Override
    public void update(float temp, float humidity, float pressure) {
        this.temperature = temp;
        this.humidity = humidity;
        display();
    }
}
```

#### Observable

```java
@Deprecated(since="9")
public class Observable {
...
}
```

`Observable` 의 문제점은 인터페이스가 아닌 클래스라는 점. 때문에 다중 상속을 지원하지 않는 자바에서는 코드 재사용에 문제가 생긴다.

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

- [observable](https://xzio.tistory.com/289) 
- [Observer pattern in Kotlin](https://in-kotlin.com/design-patterns/observer/)
