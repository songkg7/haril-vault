---
title: MSA
date: 2024-01-31T13:57:00
aliases:
  - MSA
tags: 
categories: 
updated: 2025-01-07T00:35
---

## MSA 란?

MSA (Microservices Architecture)은 소프트웨어 시스템을 작고 독립적인 서비스로 분할하는 소프트웨어 아키텍처 패턴입니다. 이 아키텍처는 큰 규모의 애플리케이션을 여러 개의 작은 서비스로 나누어 개발하고, 각각의 서비스는 독립적으로 배포, 확장 및 유지보수할 수 있도록 설계됩니다.

MSA에서 각각의 서비스는 특정 기능을 수행하며, RESTful API 등을 통해 다른 서비스와 통신합니다. 이렇게 분리된 서비스들은 독립적으로 개발 및 배포가 가능하기 때문에, 전체 애플리케이션의 확장성과 유연성을 높일 수 있습니다.

MSA는 모놀리식 아키텍처에 비해 다음과 같은 장점을 가지고 있습니다:

1. 모듈성: 각각의 서비스는 독립적으로 개발 및 배포될 수 있으며, 필요에 따라 새로운 기능이나 수정 사항을 빠르게 반영할 수 있습니다.
2. 확장성: 필요한 서비스만 확장할 수 있기 때문에 전체 시스템의 성능을 향상시킬 수 있습니다.
3. 장애 격리: 하나의 서비스에서 장애가 발생해도 다른 서비스는 영향을 받지 않고 계속 정상적으로 동작할 수 있습니다.
4. 기술 다양성: 각각의 서비스는 독립적으로 선택된 기술 스택을 사용할 수 있으므로, 최신 기술을 도입하기 쉽습니다.

하지만 MSA는 분산 시스템으로서의 복잡성과 관리 비용이 증가할 수 있다는 단점도 가지고 있습니다. 따라서 MSA를 구현하기 전에 잘 고려하고 계획하는 것이 중요합니다.

MSA 는 조직의 구조를 모방한다.

![](https://i.imgur.com/PVxF40f.png)

![](https://i.imgur.com/O5PHOR7.png)
