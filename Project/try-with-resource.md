---
title: try-with-resource
date: 2023-10-16 15:36:00 +0900
aliases: 
tags:
  - resource
  - file
categories: 
updated: 2023-11-23 17:18:18 +0900
---
움
## Java 7 이전의 try-catch-finally

사용 후 반납해줘야 하는 자원들은 `Closable` 인터페이스를 구현하고 있으며 **사용 후에 close 메서드를 호출**해주어야 했다.

문제는 이러한 과정이 단점을 가지고 있다는 것이다.

- 자원 반납에 의해 코드가 복잡해짐
- 작업이 번거로움
- 실수로 자원을 반납하지 못하는 경우 발생
- 에러로 자원을 반납하지 못하는 경우 발생
- 에러 스택 트레이스가 누적되어 디버깅이 어려움

## Java 7 부터의 try-with-resource

Java 는 이러한 문제를 해결하고자 Java 7 부터 **자동으로 자원을 반납**해주는 try-with-resource 문법을 추가하였다.

Java 는 `AutoClosable` 인터페이스를 구현하고 있는 자원에 대해 try-with-resource 를 적용가능하도록 하였고, 이를 사용함으로써 코드가 유연해지고 누락되는 에러없이 모든 에러를 잡을 수 있게 되었다.

재미있는 점은 기존의 `Closable` 의 자식으로 `AutoClosable` 을 추가한 것이 아니라, 부모로 추가하였다는 점이다. 덕분에 하위호환성을 100% 보장하며 기존의 모든 Closable 인터페이스 구현체들은 별다른 수정없이 try-with-resource 문법을 사용할 수 있게 되었다.

## Conclusion

다음과 같은 이유로 Java 에서 자원을 관리할 때는 반드시 try-with-resource 문법을 사용해야 한다.

- 코드를 간결하게 만들 수 있음
- 번거로운 자원 반납 작업을 하지 않아도 됨
- 실수로 자원을 반납하지 못하는 경우를 방지할 수 있음
- 에러로 자원을 반납하지 못하는 경우를 방지할 수 있음
- 모든 에러에 대한 스택 트레이스를 남길 수 있음

## Reference

- https://mangkyu.tistory.com/217
