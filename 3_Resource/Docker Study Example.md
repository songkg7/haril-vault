---
title: Docker study example
date: 2023-10-13T22:08:00
aliases: 
tags:
  - docker
  - build
  - example
  - study
categories: 
updated: 2025-01-07T00:35
related: "[[Docker|Docker]]"
---

```bash
gh repo clone gilbutITbook/080258
```

## Chapter 4

```
cd ch04/execises/multi-stage
docker image build -t multi-stage .
```

### Java Server

```bash
cd ch04/execises/image-of-the-day
docker image build -t image-of-the-day .
docker network create nat
docker container run --name iotd -d -p 800:80 --network nat image-of-the-day
```

### Node Server

```bash
cd ch04/execises/access-log
docker image build -t access-log .
docker run --name accesslog -d -p 801:80 --network nat access-log
```

### Go Server

```bash
cd ch04/execises/image-gallery
docker image build -t image-gallery .
docker container run -d -p 802:80 --network nat image-gallery
```

http://localhost:802 에 접근해보면, 그 날의 천체 사진을 확인할 수 있다.

![[Pasted image 20231013222400.png]]

![[Pasted image 20231013222444.png]]

node 서버에서는 로그가 카운팅되었다.
