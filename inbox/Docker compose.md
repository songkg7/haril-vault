---
title: "Docker compose"
date: 2023-02-11 23:59:00 +0900
aliases: 
tags: [docker, devops]
categories: DevOps
---

## Overview

[[Docker]] 를 프로젝트에 적용하다보면 하나의 프로젝트에서 다양한 서비스가 필요한 경우가 있다.

예를 들면 다음과 같다.

Spring application + Redis 3대로 구성된 클러스터 + MySQL

이런 상황에서는 MySQL 과 Redis 를 모두 합쳐서 4개의 컨테이너가 필요하다. 이러한 환경을 docker run 으로 구성하려면 굉장히 번거로운 설정 작업이 필요하게 된다. 이런 복잡함을 단순화하기 위해 docker compose 가 필요해진다.

