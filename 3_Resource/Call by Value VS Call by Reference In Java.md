---
title: Call by Value VS Call by Reference In Java
date: 2023-12-01T10:49:00
aliases: 
tags:
  - java
categories: 
updated: 2025-01-07T00:35
---

[[Java]] 는 Call by Reference 개념이 존재하지 않는다. Java 에서는 C 와는 달리 개발자가 포인터를 통해 메모리에 직접 접근할 수 없다. 원시값이 복사되느냐 주소값이 복사되느냐의 차이만 있을 뿐이다.

```java
public class Main {
    public static void main(String[] args) {
        Sample sample = new Sample();

        int var = 1; // primitive 타입 변수 int
        int[] arr = { 1 }; // reference 타입 변수 int[] 배열

        // 변수 자체를 보냄 (call by value)
        add_value(var);
        System.out.println(var); // 1 : 값 변화가 없음

        // 배열 자체를 보냄 (call by reference)
        add_reference(arr);
        System.out.println(arr[0]); // 101 : 값이 변화함
    }

    static void add_value(int var_arg) {
        var_arg += 100;
    }

    static void add_reference(int[] arr_arg) {
        arr_arg[0] += 100;
    }
}
```

## Reference

- [inpa blog](https://inpa.tistory.com/entry/JAVA-%E2%98%95-%EC%9E%90%EB%B0%94%EB%8A%94-Call-by-reference-%EA%B0%9C%EB%85%90%EC%9D%B4-%EC%97%86%EB%8B%A4-%E2%9D%93)
