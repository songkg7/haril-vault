---
title: "DinD 와 DooD"
date: 2023-05-24 19:42:00 +0900
aliases: 
tags: [docker]
categories: 
updated: 2023-05-24 20:00:24 +0900
---

## Overview

![[Pasted image 20230524194733.png]]

## Contents

### Docker in Docker, DinD

### Docker out of Docker, DooD

Docker container 에서 Host 의 docker client 를 빌려서 쓰는 방식

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock busybox
```

## Reference

- [Jenkins 를 도커 컨테이너로 구축하기](https://postlude.github.io/2020/12/26/docker-in-docker/)
- [DinD 와 DooD](https://aidanbae.github.io/code/docker/dinddood/)

## Links

- [[Jenkins|Jenkins]]
- [[Docker|Docker]]
