---
title: Datadog Metric Details
date: 2025-03-05T13:45:58+09:00
aliases: 
tags:
  - datadog
  - metric
description: 
updated: 2025-03-05T13:50
---

- `aws.kafka.offset_lag`: 모든 partion lag 의 총합, partion 별로 구분이 가능하기 때문에 파티셔닝이 제대로 되지 않는지 확인할 수 있음
- `aws.kafka.max_offset_lag`: partion 들의 lag 중 가장 큰 값, 파티션이 여러개라면 lag 이 분산되기 때문에 `aws.kafka.offset_lag` 에 비해 값이 작게 보일 수 있음
