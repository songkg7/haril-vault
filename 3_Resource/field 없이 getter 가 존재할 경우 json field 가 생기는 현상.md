---
title: field 없이 getter 가 존재할 경우 json field 가 생기는 현상
date: 2022-11-14T16:28:00
aliases: 
tags:
  - error
  - json
  - getter
categories: 
updated: 2025-01-07T00:35
---

## Overview

## Contents

객체에 field 없이 getter 가 존재할 때 presentation 계층에서 사용자에게 getter 의 이름이 노출되는 현상이 있다.

```java
class User {
	private String name;
	private int age;

	public int getDoubleAge() {
		return age * 2;
	}
}
```

```json
{
	"name": "user",
	"age": 20,
	"doubleAge": 40
}
```
