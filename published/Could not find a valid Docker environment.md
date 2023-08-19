---
title: Could not find a valid Docker environment
date: 2022-10-28 11:26:00 +0900
aliases: null
tags:
  - error
  - docker
categories: null
updated: 2023-08-19 12:38:08 +0900
---

## Overview

맥을 업데이트하고 [[Docker]] 가 제대로 동작하지 않아서 다시 설치하게 되었는데, 이후 test 실행시 container 가 정상적으로 실행되지 않는 에러가 있었다.
 
확인해보니 `/var/run/docker.sock` 가 정상적으로 설정되있지 않다는 내용이 출력되었는데 이를 해결하기 위한 방법을 공유한다.

## Description

해당 문제는 Docker desktop `4.13.0` 에서 나타나는 현상이다.

> _By default Docker will not create the /var/run/docker.sock symlink on the host and use the docker-desktop CLI context instead._ (see: [https://docs.docker.com/desktop/release-notes/](https://docs.docker.com/desktop/release-notes/))

현재 도커가 실행 중인 context 는 `docker context ls` 로 출력할 수 있으며, 다음과 같이 표시된다.

```console
NAME                TYPE                DESCRIPTION                               DOCKER ENDPOINT                                KUBERNETES ENDPOINT                                 ORCHESTRATOR
default             moby                Current DOCKER_HOST based configuration   unix:///var/run/docker.sock                    https://kubernetes.docker.internal:6443 (default)   swarm
desktop-linux *     moby                                                          unix:///Users/<USER>/.docker/run/docker.sock                           
```

default context 를 쓰도록 바꿔주거나 `unix:///Users/<USER>/.docker/run/docker.sock` 을 대상으로 연결되게끔 실행하면 정상적으로 동작하게 된다.  

## Solution

다음 명령어를 실행해본다.

```bash
docker context use default
```

아직 해결되지 않았다면 아래 명령어로 symbolic link 를 직접 생성하여 해결할 수 있다.

```bash
sudo ln -svf /Users/<USER>/.docker/run/docker.sock /var/run/docker.sock
```

## Reference

- [Stack overflow](https://stackoverflow.com/questions/74173489/docker-socket-is-not-found-while-using-intellij-idea-and-docker-desktop-on-macos)
