---
title: Java 의 접근 제어자
date: 2023-11-05 19:29:00 +0900
aliases: 
tags:
  - java
  - encapsulation
  - syntax
  - access-modifier
categories: 
updated: 2023-11-05 19:29:17 +0900
---

Java에서는 접근 제어자를 사용하여 클래스, 변수, 메서드 등의 접근 범위를 지정할 수 있습니다. 접근 제어자는 다음과 같이 4가지 종류가 있습니다.

1. private: 해당 멤버는 동일한 클래스에서만 접근 가능합니다. 외부 클래스나 하위 클래스에서는 접근할 수 없습니다.
2. default(package-private): 접근 제어자를 명시하지 않으면 기본적으로 default로 설정됩니다. 동일한 패키지 내에서만 접근 가능하며, 다른 패키지에서는 접근할 수 없습니다. default 의 동작은 언어마다 다르기 때문에 다른 패키지에서 접근할 수 없다는 의미로 package-private 이라고도 합니다.
3. protected: 동일한 패키지 내에서는 default와 같이 접근 가능하며, 다른 패키지의 하위 클래스에서도 접근할 수 있습니다.
4. public: 어떤 클래스든 상관없이 모든 곳에서 접근 가능합니다.

예를 들어, 아래와 같은 코드가 있다고 가정해봅시다.

```java
public class Person {
    private String name;
    protected int age;
    String gender;
    public String address;

    private void setName(String name) {
        this.name = name;
    }

    protected void setAge(int age) {
        this.age = age;
    }

    void setGender(String gender) {
        this.gender = gender;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
```

위의 코드에서 name 변수와 setName 메서드는 private으로 선언되어 있어 외부에서 직접 접근할 수 없습니다. age 변수와 setAge 메서드는 protected로 선언되어 있어 동일한 패키지 내에서는 접근 가능하며, 하위 클래스에서도 접근할 수 있습니다. gender 변수와 setGender 메서드는 default로 선언되어 있어 동일한 패키지 내에서만 접근 가능합니다. 마지막으로 address 변수와 setAddress 메서드는 public으로 선언되어 어느 곳에서나 접근할 수 있습니다.

이러한 접근 제어자의 사용은 정보 은닉과 캡슐화를 위해 중요합니다. 외부에서 직접적으로 접근할 필요가 없는 멤버들은 private으로 설정하여 보호하고, 필요한 경우에만 public으로 설정하여 외부에서 사용할 수 있도록 설계하는 것이 좋습니다.

## protected 를 사용해야 할 때

protected 접근 제어자는 동일한 패키지 내에서의 접근뿐만 아니라 다른 패키지에서 상속받은 클래스에서도 접근할 수 있습니다. 이러한 특징을 이용하여 다음과 같은 상황에서 protected를 사용할 수 있습니다.

1. 상속 관계에 있는 클래스에서의 접근 제어
   - 부모 클래스의 멤버를 자식 클래스에서 오버라이딩하거나 호출해야 할 때 protected로 선언하여 접근할 수 있도록 합니다.
   - 부모 클래스의 멤버가 private이면 자식 클래스에서는 직접 접근할 수 없으므로 protected로 선언하여 접근할 수 있도록 합니다.

2. 동일한 패키지 내에서의 접근 제어
   - 동일한 패키지 내에 있는 다른 클래스들이 해당 멤버에 접근해야 할 때 protected로 선언하여 접근할 수 있도록 합니다.
   - default(package-private)로 선언하면 동일한 패키지 내에서만 접근 가능하지만, protected로 선언하면 하위 클래스에서도 접근할 수 있습니다.

protected 키워드를 사용하는 것은 외부에 노출되는 것을 최소화하는 객체 지향 프로그래밍의 원칙 중 하나인 정보 은닉을 충족시키기 위해 중요합니다. 상속을 통해 클래스를 확장하거나 다른 클래스에서 해당 멤버를 사용해야 할 때 protected 접근 제어자를 사용하여 적절한 접근성을 제공할 수 있습니다.
