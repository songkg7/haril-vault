---
title: CAP
date: 2024-01-27T14:40:00
aliases: 
tags:
  - consistency
  - availability
  - partition-tolerance
categories: 
updated: 2025-01-07T00:35
---

## CAP 정리

CAP 정리는 분산 시스템에서 일관성(Consistency), 가용성(Availability), 분할 내성(Partition tolerance) 중 어느 두 가지만 선택할 수 있다는 이론입니다.

- 일관성(Consistency): 모든 사용자가 동일한 시간에 동일한 데이터를 볼 수 있어야 합니다.
- 가용성(Availability): 모든 요청은 성공 또는 실패로 반환되어야 하며, 실패한 요청에 대해서도 응답이 있어야 합니다.
- 분할 내성(Partition tolerance): 네트워크의 분할로 인해 서버 간 통신이 실패하거나 지연되어도 시스템이 계속 작동해야 합니다.

CAP 이론은 이 세 가지 요소 중에서 두 가지만 선택할 수 있다고 주장합니다. 즉, 모든 상황에서 일관성, 가용성, 분할 내성을 모두 만족시킬 수 없다는 것을 의미합니다. 이러한 선택은 시스템 설계자에게 달려있으며, 어떤 요소를 우선시 할 것인지는 시스템의 목적과 환경에 따라 다를 수 있습니다.

CAP 이론은 대규모 분산 시스템의 설계와 운영에 많은 영향을 미쳤으며, NoSQL 데이터베이스와 같은 분산 데이터 저장 시스템의 선택에도 영향을 주고 있습니다.
