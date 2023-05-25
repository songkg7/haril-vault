---
title: "DinD 와 DooD"
date: 2023-05-24 19:42:00 +0900
aliases: 
tags: [docker]
categories: 
updated: 2023-05-25 10:26:14 +0900
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

container 내부에서 cli 설치

```bash
#!/bin/sh
apt-get update

apt-get -y install apt-transport-https \ apt-utils \ ca-certificates \ curl \ gnupg2 \ zip \ unzip \ software-properties-common

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey;

apt-key add /tmp/dkey add-apt-repository \ "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \ $(lsb_release -cs) \ stable" && \ apt-get update

apt-get -y install docker-ce
```

## Reference

- [Jenkins 를 도커 컨테이너로 구축하기](https://postlude.github.io/2020/12/26/docker-in-docker/)
- [DinD 와 DooD](https://aidanbae.github.io/code/docker/dinddood/)
- https://www.skyer9.pe.kr/wordpress/?p=3382

## Links

- [[Jenkins|Jenkins]]
- [[Docker|Docker]]
