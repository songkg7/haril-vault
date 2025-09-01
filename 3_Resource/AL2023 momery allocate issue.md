---
title: 
date: 2025-08-23T10:47:59+09:00
aliases: 
tags:
  - aws
  - image
  - docker
  - container
  - java
  - jdk
description: 
updated: 2025-08-23T15:07
---

[Containers OOM with Amazon Linux 2023 ECS AMI · Issue #240 · aws/amazon-ecs-ami · GitHub](https://github.com/aws/amazon-ecs-ami/issues/240)

- (AWS 에서는 AL2023 을 권장하지만) al2023 이미지를 사용할 경우 메모리 사용량이 매우 크게 증가하며, 메모리 누수로 보이는 현상까지 확인된다.
- ECS 에 LBS group 을 만들고 base-image 를 기반으로 팀 커스텀 이미지를 만들어야겠다.