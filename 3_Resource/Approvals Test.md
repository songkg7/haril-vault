---
title: Approvals Test
date: 2024-04-07 21:02:00 +0900
aliases: 
tags:
  - test
  - approval
categories: 
updated: 2024-10-05 11:44:36 +0900
---

## Approvals Testing 이란?

Approvals Testing은 단위 테스트 중에서 오브젝트의 상태값을 스냅샷으로 캡쳐하여, 개발자가 직접 판단하는 것이 아닌, 스냅샷 파일에 대한 비교를 통해 테스트 결과를 판단 하는 방식입니다.

## 언제 Approvals Testing 을 사용하나요?

1. JSON/XML 이나 오픈소스 컴포넌트로 만들어진 객체 등에 대해서는 구조적으로 무언가 다르기 보다는 값만 바뀔 수 있는 경우에 많이 사용됩니다.
2. 기존에 특정 값만 수정되어도 테스트 코드 전체를 수정해야 하는 경우
3. 웹 화면의 변경을 간접적으로 확인할 때 사용할 수 있습니다.

## Approvals Testing 의 장점

- 스냅샷 비교를 통해 빠른 피드백 제공
- 코드의 복잡도를 줄여줍니다.
- 코드 리팩토링 이후 쉽게 반영할 수 있습니다.
- 쉽게 사용이 가능합니다.

## Approvals Testing 의 단점

- 몇몇 경우엔 실제와 다른 결과가 반환 될 수 있음
- 객체의 구조적 차이는 알지 못함

## Reference

- https://github.com/approvals/ApprovalTests.Java
