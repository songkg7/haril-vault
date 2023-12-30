---
title: Docker Study Chapter 10
date: 2023-11-03 08:49:00 +0900
aliases: 
tags:
  - docker
  - study
  - docker-compose
categories: 
updated: 2023-11-04 01:22:07 +0900
---

## 도커 컴포즈로 여러 개의 애플리케이션 배포하기

도커 컴포즈는 **프로젝트(project)** 라는 개념을 사용한다.

```
# prefix - suffix
{project_name}-{번호}
```

프로젝트 이름을 다르게 하면 같은 애플리케이션이여도 여러 벌을 실행할 수 있다.

## 설정 오버라이딩

```
# e.g.
docker-compose.yml > docker-compose-dev.yml > docker-compose-test.yml
```

기본 컴포즈 파일에는 모든 환경에 공통적으로 사용되는 설정을 정의하고 나머지 파일들은 각각 필요한 환경에 맞는 설정을 정의해서 사용할 수 있다.

```yaml
# docker-compose.yml
version: "3.7"

services:
  todo-web:
    image: diamol/ch06-todo-list
    ports:
      - 80
    environment:
      - Database:Provider=Sqlite
    networks:
      - app-net

networks:
  app-net:

# docker-compose-v2.yml
version: "3.7"

services:
  todo-web:
    image: diamol/ch06-todo-list:v2
```

이 예의 오버라이드 파일은 image 속성값 하나만 변경하는데, 이 속성은 기본 파일상의 위치와 마찬가지로 services 블록의 todo-web 블록 아래에 위치한다.

도커 컴포즈는 하나 이상의 파일이 인자로 지정됐을 때 이들 파일을 병합한다. 특히 `config` sub-command 가 이 때 유용한데, 이 부명령은 **입력 파일의 내용을 검증해 내용이 유효한 경우에만 최종 출력**을 내놓는다. 이 최종 출력이 실제 반영되는 컴포즈 파일이 되므로 오버라이드 결과를 예상할 수 있다.

```bash
$ docker compose -f ./docker-compose.yml -f ./docker-compose-v2.yml config
name: todo-list
services:
  todo-web:
    environment:
      Database:Provider: Sqlite
    image: diamol/ch06-todo-list:v2
    networks:
      app-net: null
    ports:
      - mode: ingress
        target: 80
        protocol: tcp
networks:
  app-net:
    name: todo-list_app-net
```

## 환경 변수와 비밀값을 이용해 설정 주입하기

- `environment` : 컨테이너 안에서만 사용되는 환경 변수를 추가
- `env_file`: 텍스트 파일의 경로를 값으로 받아 파일에 정의된 환경 변수가 컨테이너에 적용
- `secrets`: services 나 networks 처럼 최상위 프로퍼티

호스트 머신의 환경 변수를 컨테이너에 전달할 수도 있다.

```yaml
todo-web:
  ports:
    - "${TODO_WEB_PORT}:80"
  environment:
    - Database:Provider=Postgres
  env_file:
    - ./config/logging.information.env
  networks:
    - app-net
```

도커 컴포즈를 실행 중인 컴퓨터의 환경 변수 TODO_WEB_PORT 의 값이 8877 이었다면 ports 프로퍼티의 값이 "8877:80" 이 된다.

> [!tip]
> 도커 컴포즈로 애플리케이션을 실행할 때 대상 디렉터리에서 `.env` 파일을 발견하면, 이 파일을 환경 파일로 간주하고 애플리케이션을 실행하기 전에 먼저 적용한다.

## 확장 필드

확장 필드를 사용하면 docker-compose.yml 파일에서 중복을 제거할 수 있다.

> [!warning]
> 코어 컴포즈 파일에 정의된 확장 필드를 오버라이드 파일에서 사용할 수는 없다.

```yaml
x-logging: &logging
  logging:  
    options:
      max-size: '100m'
      max-file: '10'

x-labels: &labels
  app-name: image-gallery

services:
  accesslog:
    <<: *logging
    labels:
      <<: *labels
```

확장 필드를 정의해두면 서로 다른 서비스에서 같은 필드가 여러 번 중복될 때 매우 유용하게 사용할 수 있다.

## Fixed

- 244p 의 실습은 `.env` 파일이 정상 경로에 존재하지 않기 때문에 찾을 수 없어서 에러가 발생한다.
- 248p 의 실습은 compose 을 수정해야 정상 실행된다. yaml 파일에서는 같은 이름의 키가 존재할 수 없기 때문에 발생하는 에러로, 키를 다르게 수정해주면 해결된다.
