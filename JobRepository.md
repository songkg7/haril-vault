---
title: "JobRepository"
date: 2022-08-17 16:56:00 +0900
publish: false
fc-calendar: Gregorian Calendar
fc-date: 2022-08-17
aliases: 
tags: [batch, job]
categories: Spring
---

JobRepository 는 배치 처리 정보를 담고 있는 매커니즘입니다. 어떤 Job 이 실행되었으며 몇 번 실행되었고 언제 끝났는지 등 배치 처리에 대한 메타 데이터를 저장합니다.

예를 들어 Job 하나가 실행되면 JobRepository 에서는 배치 실행에 관련된 정보를 담고 있는 도메인인 `JobExecution` 을 생성합니다.

JobRepository 는 Step 의 실행 정보를 담고 있는 `StepExecution` 도 저장소에 저장하며 전체 메타 데이터를 저장 / 관리하는 역할을 수행합니다.
