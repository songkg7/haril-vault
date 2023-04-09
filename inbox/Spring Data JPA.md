---
title: "Spring Data JPA"
date: 2023-04-09 17:50:00 +0900
aliases: 
tags: [spring, jpa, orm, hibernate]
categories: [Spring]
---

## Overview

Spring Data JPA 란 무엇인가?

## Usage

### Query method

## Pros

## Cons

## Troubleshooting

**`@GenerateValue` 를 지정하면 id 를 직접 설정하는 동작이 정상적으로 동작하지 않는가?**

1. id 를 db 에 이미 존재하는지 확인하기 위해 select query 가 나감
2. 없으므로, id 와 함께 insert 가 되어야 하지만, persist 가 아닌 merge 로 동작하면서 id 와 함께 insert 하지 않는 쿼리가 발생
3. id 값에 지정된 값이 아닌 default 값이 설정됨
