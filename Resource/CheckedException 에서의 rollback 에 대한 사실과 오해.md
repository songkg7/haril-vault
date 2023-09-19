---
title: CheckedException 에서의 rollback 에 대한 사실과 오해
date: 2022-09-05 15:52:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-05
aliases: null
tags:
  - checked-exception
  - unchecked-exception
  - java
  - transaction
categories: null
updated: 2023-08-08 21:47:55 +0900
---

## Overview

많은 블로그에서 CheckedException 과 UncheckedException 의 차이를 적으며, CheckedException 은 rollback 하지 않고, UncheckedException 은 rollback 이 된다고 적고 있다. 이것은 오해이며, 반은 맞고 반은 틀리다고 할 수 있다.

스프링 `@Transactional` 의 처리는 기본값이 있다. 그 기본값이 UncheckedException 만 rollback 하게 되어 있을 뿐, 설정값을 변경하는 것으로 동작을 수정할 수 있다.

## Links

[[Transaction]]