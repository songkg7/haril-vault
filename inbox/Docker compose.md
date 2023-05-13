---
title: "Docker compose"
date: 2023-02-11 23:59:00 +0900
aliases: 
tags: [docker, devops]
categories: DevOps
updated: 2023-05-13 18:57:20 +0900
---

## Overview

[[Docker]] 를 프로젝트에 적용하다보면 하나의 프로젝트에서 다양한 서비스가 필요한 경우가 있다.

예를 들면 다음과 같다.

Spring application + Redis 3대로 구성된 클러스터 + MySQL

이런 상황에서는 MySQL 과 Redis 를 모두 합쳐서 4개의 컨테이너가 필요하다. 이러한 환경을 docker run 으로 구성하려면 굉장히 번거로운 설정 작업이 필요하게 된다. 이런 복잡함을 단순화하기 위해 docker compose 가 필요해진다.

### 장점

1. 다중 컨테이너 애플리케이션을 쉽게 구성할 수 있다.
2. 각 컨테이너의 설정을 관리할 수 있다.
3. 여러 개의 서비스를 동시에 실행하고 관리하기 용이하다.
4. YAML 파일 형식으로 구성하기 때문에 가독성이 좋다.

### 구성 요소

Docker Compose 를 사용하기 위해서는 아래와 같은 구성 요소가 필요하다.

1. Docker: Docker Compose 는 Docker 에 의존한다.

2. Docker Compose CLI: Docker Compose 는 CLI(Command Line Interface) 로 사용한다.

3. YAML 파일: Docker Compose 는 YAML 파일을 사용하여 컨테이너를 정의한다.


### 사용 예시

아래는 docker-compose.yml 파일의 예시이다.

```
version: '3'
services:
  web:
    build: .
    ports:
      - "5000:5000"
  redis:
    image: "redis:alpine"
```

위의 예제에서는 두 개의 서비스인 web 과 redis 를 정의하고 있다. web 서비스는 현재 디렉토리에서 Dockerfile 을 찾아서 이미지를 빌드하고, 호스트와 컨테이너 간 포트 매핑을 설정한다. redis 서비스는 이미지를 가져와서 실행한다.

위와 같은 docker-compose.yml 파일을 실행하는 방법은 다음과 같다.

```
docker-compose up
```

위 명령어를 실행하면 정의된 서비스들을 실행하고, 로그를 출력한다. 만약 배포를 위한 이미지 빌드나 컨테이너 삭제 등의 작업을 수행하려면 다른 옵션을 사용해야 한다. 

### 결론

Docker Compose 는 다중 컨테이너 애플리케이션을 쉽게 구성하고 관리할 수 있도록 도와주는 도구이다. Docker Compose 를 사용하면 YAML 파일로 각 서비스의 설정과 연결 관계를 정의하여, 각각의 컨테이너를 쉽게 관리할 수 있다. 이로 인해 복잡한 멀티 컨테이너 환경에서 개발 및 배포가 용이해진다.