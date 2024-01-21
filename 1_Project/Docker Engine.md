---
title: Docker Engine
date: 2023-10-15 09:57:00 +0900
aliases: []
tags:
  - docker
  - engine
  - container
categories: 
updated: 2024-01-21 14:49:10 +0900
related: "[[Docker|Docker]]"
---

> Docker Engine 의 내부 구조와 동작원리

## Background

### VMware

아주 예전에는 하나의 서버 당 하나의 애플리케이션이 동작됐다. 동일한 서버에서 여러 개의 애플리케이션을 안전하게 실행시키는 기술이 없었다.

그래서 새로운 애플리케이션이 필요할 때마다 서버를 구매해야했고, 성능과 규모가 좋은 것을 구매하느라 낭비가 심했다.

[[Virtual Machine|VM]]이라는 개념이 세상에 나오게 되면서, 하나의 운영체제 위에 여러 OS를 실행시켜 낭비를 크게 줄일 수 있었다.

하지만, 하나의 VM 마다 고유한 OS 가 필요하기 때문에 각각 CPU, RAM 및 기타 리소스를 소비하며 보다 많은 시간과 자원을 낭비하게 되었다. 또한 특정 OS 는 라이센스가 필요한 경우도 있었기 때문에, 별도의 업데이트 및 운영이 필요했다.

### Container

VM 모델의 단점들로 인해 구글과 같은 대형 회사들은 컨테이너 기술을 사용해왔다.

컨테이너 모델에서 컨테이너는 VM 과 유사하지만, 컨테이너는 OS 를 호스트머신과 공유하기 때문에 별도의 OS 가 필요하지 않았다. 즉, VM 에 비해서 OS 를 유지하는데 필요한 CPU, RAM 등의 스토리지와 같은 막대한 양의 시스템 리소스를 절약할 수 있었다.

결과적으로, VM 에 비해 컨테이너는 더 빠르게 동작했고 더 편하게 유지보수가 가능했다. 매우 휴대성(ultra-portable)이 뛰어났던 것도 장점 중 하나이다. 컨테이너는 VM 에 비해 가볍게 동작한다는 의미로 받아들여진다.

## 초기 Docker Engine

초기 Docker 는 현재 모델과는 다르게 Docker Daemon, [[Linux Container|LXC]] 라는 두 개의 주요 구성을 가지고 있었다.

### Docker daemon

이 때 Docker daemon 은 현재의 Docker daemon 과는 달랐는데, 모놀리 바이너리(monolithic binary)로 구성되어 있었다. (모듈화가 되어있지 않음)

Docker Daemon 에 Docker client, Docker API, container runtime, image builds 등을 비롯한 많은 코드들을 담고 있었다.

### LXC

[[Linux Container|LXC]]는 단일 컨트롤 호스트 상에서 여러개의 고립된 리눅스 시스템(컨테이너)들을 실행하기 위한 **운영 시스템 레벨 가상화 방법**이다. daemon 에게 Linux kernel 에 존재하는 컨테이너의 기본 building block 에 대한 namespaces 나 cgroups(control groups)와 같은 접근을 제공했다.

- namespace: 운영 시스템을 쪼개서 각각 고립된 상태로 운영되는 개념
- cgroups: namespace 로 고립된 환경에서 사용할 자원을 제한하는 역할 등을 하는 개념

이 기술들이 container 기술의 근간이 된다.

#### 문제점

LXC 는 리눅스에 특화되어 있는데, Docker 가 Multi-Platform 을 목표로 하는데 큰 리스크였다. 또한, 시스템을 구성하는 핵심적인 요소가 외부 시스템에 의존한다는 문제도 있었다.

때문에 Docker 사는 LXC 를 대체하기 위해 [[libcontainer]] 라는 독자적인 툴을 개발했으며, [[Go|Golang]] 으로 작성되어 platfrom-agnostic(불특정 플랫폼) 툴로 만들어주었다.

결국, Docker 0.9 부터 기본 실행 드라이버가 **LXC 에서 libcontainer 로 대체**된다.

### Libcontainer

Libcontainer 는 현재의 Docker Engine 에서 사용하고 있는 주요 컴포넌트이다.

Golang 으로 만들어져서 Container 를 생성시 namespaces, cgroups, capabilities 를 제공하고, filesystem 의 접근을 제한할 수 있습니다. 컨테이너가 생성된 후 작업을 수행할 수 있도록 컨테이너의 수명 주기를 관리할 수 있다.

Libcontainer 는 Docker 와 분리된 LXC 와는 다르게, Docker 내부에서 실행된다.

Docker 에서는 자체적으로 제작한 libcontainer 의 CLI wrapper 인 **runc** 를 사용한다.

## Docker Engine

[[Docker]] 는 Client-Server 모델을 구현한 애플리케이션이다. Docker Engine 은 Docker Components 와 서비스를 제공하는 **컨테이너를 구축하고 실행하는 핵심 소프트웨어**이다.

Docker Engine 은 Docker Deamon, REST API, API 를 통해 도커 데몬과 통신하는 CLI 등으로 모듈식 구성을 하고 있다. 개발자들이 Docker 라고 할 때, 주로 Docker Engine 을 의미한다.

![](https://blog.kakaocdn.net/dn/bPzExH/btrqQdT1n1z/QdqLFZpkpjUOK1FGWwwtNk/img.png)

컨테이너를 빌드, 실행, 배포하는 등의 무거운 작업은 Docker Daemon 이 하며, Docker Client 는 이러한 로컬 혹은 원격의 Docker Daemon 과 통신한다. 통신할 때는 UNIX socket(/var/run/docker.sock) 또는 네트워크 인터페이스를 통한 REST API 를 사용한다.

## Reference

- https://gngsn.tistory.com/128

#kakaobank 
