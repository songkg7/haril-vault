---
title: Spring Batch
date: 2022-08-17T08:53:00
publish: false
aliases: 
tags:
  - spring
  - batch
categories: Spring
updated: 2025-01-07T00:35
---

[[Spring framework|Spring]]

# Spring Batch 를 왜 사용할까?

- 대용량 데이터 처리에 최적화되어 고성능을 발휘합니다.
- 효과적인 로깅, 통계 처리, 트랜잭션 관리 등 재사용 가능한 필수 기능을 지원합니다.
- 수동으로 처리하지 않도록 자동화되었습니다.
- 예외 사항과 비정상 동작에 대한 방어 기능이 있습니다.
- 스프링 부트 배치의 반복되는 작업 프로세스를 이해하면 비즈니스 로직에 집중할 수 있습니다.

일반적으로 스프링 배치의 절차는 `읽기 -> 처리 -> 쓰기` 를 따릅니다.

1. 읽기(read): 특정 데이터 레코드를 읽습니다.
2. 처리(processing): 원하는 방식으로 데이터를 가공 / 처리 합니다.
3. 쓰기(write): 수정된 데이터를 다시 저장합니다. 혹은 외부 API 를 통해 내보내기도 합니다.

아래 그림은 배치 처리와 관련된 객체들의 관계입니다.

![[Pasted image 20230806161744.png]]

- [[Job]]
- [[Step]]
- [[ItemReader]]
- [[ItemProcessor]]
- [[ItemWriter]]

`Job` 과 `Step` 은 1:M, `Step` 과 `ItemReader`, `ItemProcessor`, `ItemWriter` 는 1:1 의 관계를 가집니다.

즉, `Job` 이라는 하나의 큰 일감(Job)에 여러 단계(Step)을 두고, 각 단계를 배치의 기본 흐름대로 구현합니다.

## Reference

- https://deeplify.dev/back-end/spring/batch-architecture-and-components
