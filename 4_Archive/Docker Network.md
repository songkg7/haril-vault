---
title: Docker Network
date: 2022-08-13T22:21:00
tags:
  - devops
  - docker
  - network
categories:
  - DevOps
fc-calendar: Gregorian Calendar
fc-date: 2022-08-13
updated: 2025-01-07T00:36
---

## Overview

Docker 컨테이너는 격리된 환경에서 돌아가기 때문에 기본적으로 다른 컨테이너와 통신이 불가능하다. 하지만 여러개의 컨테이너를 하나의 Docker 네트워크에 연결시키면 서로 통신이 가능해진다. 이번에는 서로 다른 컨테이너들간에 통신을 위해서 네트워크를 어떻게 구성해야하는지 알아본다.

## 네트워크 종류

Docker 네트워크는 `bridge`, `host`, `overlay` 등 목적에 따라 다양한 종류의 네트워크 드라이버를 지원한다.

- `bridge`: 하나의 호스트 컴퓨터 내에서 여러 컨테이너들이 서로 소통할 수 있도록 해준다.
- `host`: 컨테이너를 호스트 컴퓨터와 동일한 네트워크에서 컨테이너를 돌리기 위해서 사용된다.
- `overlay`: 여러 호스트에 분산되어 돌아가는 컨테이너들 간의 네트워킹을 위해서 사용된다.

## 네트워크 생성

`docker network create` 커맨드를 사용해서 새로운 Docker 네트워크를 생성해보도록 하자.

```bash
docker network create my-net
```

추가된 네트워크는 `docker network ls` 커맨드로 확인할 수 있다. `-d` 옵션을 사용하지 않았기 때문에 기본값인 `bridge` 네트워크로 생성된 것을 확인할 수 있다.

## 네트워크 상세 정보

방금 추가한 네트워크의 상세 정보를 `docker network inspect` 커맨드로 확인해보도록 하자.

```bash
docker network inspect my-net
```

`Containers` 항목을 보면 이 네트워크에 아무 컨테이너도 연결되지 않은 것을 알 수 있다.

## 네트워크에 컨테이너 연결

먼저 컨테이너 하나를 `one` 이라는 이름으로 실행해보도록 하자.

```bash
docker run -it -d --name one busybox
# af588368c67b8a273cf63a330ee5191838f261de1f3e455de39352e0e95deac4
```

컨테이너를 실행할 때 `--network` 옵션을 명시해주지 않으면, 기본적으로 `bridge` 라는 이름의 디폴트 네트워크에 붙게 된다.

> `busybox` 는 테스트용으로 사용하기 좋은 가벼운 명령어 라이브러리이다. 도커에서 공식적으로 제공된다.

{: .prompt-info }

```bash
docker network inspect bridge
```

이 `one` 컨테이너를 위에서 생성한 `my-net` 네트워크에 연결해보도록 하자. Docker 네트워크에 컨테이너를 연결할 때는 `docker network connect` 커맨드를 사용한다.

```bash
docker network connect my-net one
```

`my-net` 네트워크의 상세 정보를 다시 확인해보면 `Containers` 항목에 `one` 컨테이너가 추가된 것을 볼 수 있다. `one` 컨테이너에 IP `172.18.0.2` 가 할당된 것도 확인할 수 있다.

```bash
docker network inspect my-net
```

## 네트워크로부터 컨테이너 연결 해제

하나의 컨테이너는 여러 개의 네트워크에 동시에 연결할 수 있다. 최초에 `one` 컨테이너를 생성할 때 `bridge` 네트워크 붙었기 때문에, 현재 `one` 컨테이너는 `my-net` 네트워크와 `bridge` 네트워크에 동시에 붙어있게 된다.

`one` 컨테이너를 `bridge` 네트워크로부터 떼어 내보자. Docker 네트워크로부터 컨테이너의 연결을 끊을 때는 `docker network disconnect` 커맨드를 사용한다.

```bash
docker network disconnect bridge one
```

## 두번 째 컨테이너 연결

네트워크에 홀로 있는 컨테이너는 큰 의미가 없다. 하나의 컨테이너를 더 `my-net` 네트워크에 연결해보도록 하자.

이번에는 `--network` 옵션을 사용해서 컨테이너를 실행하면서 바로 연결할 네트워크를 지정해보자.

```bash
docker run -it -d --name two --network my-net busybox
# b1509c6fcdf8b2f0860902f204115017c3e2cc074810b330921c96e88ffb408e
```

`my-net` 네트워크의 상세 정보를 확인해보면 `two` 컨테이너에 IP `172.18.0.3` 가 할당되어 연결되어 있는 것을 확인할 수 있다.

```bash
docker network inspect my-net
```

## 컨테이너 간 네트워킹

이제 두 개의 컨테이너가 네트워크를 통해 서로 소통이 가능한지 테스트해보자.

먼저 `one` 컨테이너에서 `two` 컨테이너를 상대로 `ping` 명령어를 날려본다. 컨테이너 이름을 호스트네임(hostname)처럼 사용할 수 있다.

```bash
docker exec one ping two
# PING two (172.18.0.3): 56 data bytes
# 64 bytes from 172.18.0.3: seq=0 ttl=64 time=0.114 ms
# 64 bytes from 172.18.0.3: seq=1 ttl=64 time=0.915 ms
```

다음은 `two` 컨테이너에서 `one` 컨테이너로 `ping` 을 날려보자.

```bash

docker exec two ping one

# PING one (172.18.0.2): 56 data bytes

# 64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.108 ms

# 64 bytes from 172.18.0.2: seq=1 ttl=64 time=0.734 ms

# 64 bytes from 172.18.0.2: seq=2 ttl=64 time=0.270 ms

# 64 bytes from 172.18.0.2: seq=3 ttl=64 time=0.353 ms

# 64 bytes from 172.18.0.2: seq=4 ttl=64 time=0.371 ms

```

서로 원활한 통신이 가능한 것을 확인할 수 있다.

아래 명령을 사용하면 DNS 리졸브가 가능한 것도 확인할 수 있다.

```bash
nslookup two
```

![](https://i.imgur.com/mDUY6Ot.png)

## 네트워크 제거

마지막으로 `docker network rm` 커맨드를 사용하여 `my-net` 네트워크를 제거해보자.

```bash

docker network rm my-net

# Error response from daemon: error while removing network: network my-net id 05f28107caa4fc699ea71c07a0cb7a17f6be8ee65f6001ed549da137e555b648 has active endpoints

```

위와 같이 제거하려는 네트워크 상에서 실행 중인 컨테이너가 있을 때는 제거되지 않는다.

그럴 때는 해당 네트워크에 연결되어 실행 중인 모든 컨테이너를 먼저 중지시키고, 네트워크를 삭제해야 한다.

```bash

docker stop one two

# one

# two

docker network rm my-net

# my-net

```

## 네트워크 청소

하나의 호스트 컴퓨터에서 다수의 컨테이너를 돌리다보면 아무 컨테이너도 연결되어 있지 않은 네트워크가 생기기 마련이다. 이럴 때는 `docker network prune` 커맨드를 이용해서 불필요한 네트워크를 한번에 모두 제거할 수 있다.

```bash

docker network prune

WARNING! This will remove all custom networks not used by at least one container.

Are you sure you want to continue? [y/N] y

```

## Conclusion

이번 글을 통해서 `docker network` 키워드들에 대해 알아보았다.

- `ls`
- `create`
- `connect`
- `disconnet`
- `inspect`
- `rm`
- `prune`

도커 컨테이너를 사용하게 되면 컨테이너 간 통신이 필요할 때가 있다. DB 를 컨테이너화하여 사용할 때 뿐만 아니라, 컨테이너 클러스터링을 직접 구현해야할 때 또한 네트워크에 대한 이해가 반드시 필요하다. 여러 개의 컨테이너를 다루기 위한 핵심 지식으로써, 네트워크에 대해 반드시 숙지하도록 하자.

## Reference

- [docker docs - network](https://docs.docker.com/engine/reference/commandline/network/)
- [Dcoker 네트워크 사용법](https://www.daleseo.com/docker-networks/)
