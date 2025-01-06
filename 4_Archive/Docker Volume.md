---
title: Docker Volume
date: 2022-08-03T13:38:00
tags:
  - devops
  - docker
  - volume
categories: DevOps
updated: 2025-01-07T00:36
related: "[[Docker|Docker]]"
---

# Overview

**도커 컨테이너는 기본적으로 완전 격리상태**이기 때문에 기본적으로는 컨테이너 내부의 데이터를 호스트 머신에서 사용할 수 없다. 이 말은 곧, 컨테이너의 라이프 사이클에 내부 데이터가 완전히 의존하는 상태라는 것이다. 좀 더 쉽게 말하면 컨테이너가 사라지는 순간 데이터도 같이 사라지게 된다.

그럼 로그나 데이터베이스의 중요한 정보 등 컨테이너의 데이터를 컨테이너의 라이프사이클과는 관계없이 영구적으로 보관해야할 필요가 있는 경우에는 어떻게 해야할까?

바로 이럴 때 `volume` 을 사용할 수 있다.

# PostgreSQL local 에 설치해보기

간단하게 postgres 를 설치하고 사용해보는 예제를 통해 volume 에 대해서 살펴보자.

## volume 을 사용하지 않는 경우

### 1. Image pull

```bash

docker run -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=1234 -d postgres

```

### 2. connect postgres

```bash

docker exec -it postgres psql -U postgres

```

### 3. create user

```sql
create user testuser password '1234' superuser;
```

### 4. create database

```sql

create database testdb owner testuser;

```

유저와 DB 를 생성하는 과정은 `DBeaver` 나 `DataGrip` 같은 툴을 사용해도 무방하다.

사용이 끝나면 `docker stop postgres` 를 통해서 정지상태로 만들 수 있다. `docker ps -a` 로 컨테이너 리스트를 확인해보면 정지 상태가 되었을 뿐 아직 컨테이너가 제거된 상태는 아니다.

```bash
$ docker ps -a

CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES

5c72a3d21021 postgres "docker-entrypoint.s…" 54 seconds ago Exited (0) 43 seconds ago postgres
```

이 상태에서는 `docker start postgres` 를 통해서 언제든지 다시 사용할 수 있고 데이터가 사라지지도 않는다.

직접 확인해보자.

`\list` 명령어를 통해 PostgreSQL 의 모든 database 를 출력해보면 직접 만든 `testdb` 가 여전히 존재하는 것을 확인할 수 있다.

```sql

postgres=# \list

List of databases

Name | Owner | Encoding | Collate | Ctype | Access privileges

-----------+----------+----------+------------+------------+-----------------------

postgres | postgres | UTF8 | en_US.utf8 | en_US.utf8 |

template0 | postgres | UTF8 | en_US.utf8 | en_US.utf8 | =c/postgres +

| | | | | postgres=CTc/postgres

template1 | postgres | UTF8 | en_US.utf8 | en_US.utf8 | =c/postgres +

| | | | | postgres=CTc/postgres

testdb | testuser | UTF8 | en_US.utf8 | en_US.utf8 |

(4 rows)

```

그럼 `docker rm` 옵션을 사용하여 container 를 완전히 제거한다면 데이터는 어떻게 될까?

`docker rm postgres` 를 한 후, 다시 `docker run` 를 해보면 새로운 컨테이너가 생성되는 것을 확인할 수 있고, 데이터를 확인해보면 `testdb` 및 user 가 초기화되어 존재하지 않는 것을 알 수 있다.

```bash

$ docker rm postgres

postgres

$ docker run -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=1234 -d postgres

67c5c39658f5a21a833fd2fab6058f509ddac110c72749092335eec5516177c2

```

```bash

$ docker exec -it postgres psql -U postgres

psql (14.4 (Debian 14.4-1.pgdg110+1))

Type "help" for help.

  

postgres=# \list

List of databases

Name | Owner | Encoding | Collate | Ctype | Access privileges

-----------+----------+----------+------------+------------+-----------------------

postgres | postgres | UTF8 | en_US.utf8 | en_US.utf8 |

template0 | postgres | UTF8 | en_US.utf8 | en_US.utf8 | =c/postgres +

| | | | | postgres=CTc/postgres

template1 | postgres | UTF8 | en_US.utf8 | en_US.utf8 | =c/postgres +

| | | | | postgres=CTc/postgres

(3 rows)

  

postgres=#

```

### volume 을 사용하는 경우

우선 volume 을 만들어줘야한다.

```bash

$ docker volume create postgres

postgres

```

볼륨 생성을 확인하려면 `ls` 명령을 사용한다.

```bash
$ docker volume ls
DRIVER VOLUME NAME
local postgres
```
이번엔 postgres 컨테이너를 실행할 때 생성한 볼륨을 마운트해준다.

```bash

$ docker run -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=1234 -v postgres:/var/lib/postgresql/data -d postgres

002c552fe092da485ee30235d809c835eeb08bd7c00e6f91a2f172618682c48e

```

이후 과정은 volume 을 사용하지 않는 경우와 같다. 이제 `docker rm` 을 사용하여 컨테이너를 완전 삭제하는 경우에도 데이터는 volume 에 남아있기 때문에 사라지지 않는다.

위에서 잠깐 언급했듯이, 장기간 보관해야하는 로그 파일이라던지 백업 데이터의 같은 경우 volume 을 사용하여 컨테이너의 라이프 사이클에 의존하지 않는 영속화 처리를 할 수 있다.

## Conclusion

지금까지 Docker 에서 volume 은 무엇이고 어떻게 활용해야하는지에 대해 PostgreSQL 을 통해 살펴보았다. volume 은 Docker 컨테이너에서 사용되는 데이터 관리의 핵심 메커니즘이고, 사용하려는 컨테이너의 성격에 따라서 적절하게 volume 을 활용해줄 수 있다면 데이터를 안전하고 쉽게 관리할 수 있으니 익숙해지기만 한다면 개발 생산성 향상에 큰 도움이 될 것이다. 자세한 정보는 [공식 문서](https://docs.docker.com/storage/volumes/)를 참고하자.

## Reference

- [Use volumes](https://docs.docker.com/storage/volumes/)
