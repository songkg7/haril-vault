---
title: "@Configuration"
date: 2023-01-24 01:53:00 +0900
aliases: 
tags: [java, annotation, bean, proxy]
categories: 
---

## Overview

## Contents

[[CGLIB]]

[[@Component]] 를 통해서 bean 을 등록하면 Lite mode 가 된다. lite mode 가 되면 Configuration 을 사용하는 것보다는 빠르지만 많은 차이는 없다. 중요한 것은 CGLIB 를 사용하냐 아니냐 의 차이이다.

| @Configuration | @Component      |
| -------------- | --------------- |
| CGLIB 사용     | CGLIB 사용 안함 |

[[@Bean]]

Lite mode

JdkDynamic proxy

## Conclusion
