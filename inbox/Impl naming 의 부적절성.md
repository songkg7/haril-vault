---
title: "Impl naming"
date: 2022-08-18 12:45:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-18
aliases: 
tags: [convention]
categories: 
---

# Impl naming

## Overview

가끔 타인의 코드를 보다보면 ~Impl 이라는 naming 을 사용하는 특정 Interface 의 구현체를 보게 된다. 개인적으로 이런 naming 은 쓰지 말아야한다고 생각하는데 이 게시글에서는 왜 그렇게 생각하는지에 설명해보려 한다.

Class 는 기본적으로 자신의 역할을 명확하게 표현할 수 있어야한다. 하지만 ~Impl 이라는 suffix 는 단순히 구현체라는 것만 표현할 뿐, 역할을 표현하지 않는다. 또한 굳이 ~Impl 이라는 키워드를 달지 않아도 구현체라는 것은 코드를 보면 누구나 알 수 있다.

## Contents

## Conclusion

# Reference

# Links

- [[Code convention 과 개발자가 지켜야할 수칙에 관하여]]
