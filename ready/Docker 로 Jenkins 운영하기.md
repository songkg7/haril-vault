---
title: "Docker 로 Jenkins 운영하기"
date: 2022-11-17 00:47:00 +0900
aliases: 
tags: [ci, cd, devops, jenkins]
categories: DevOps
---

## Overview

[[Docker]] 를 사용하여 [[Jenkins]] 를 설치하고 운영하는 법을 설명한다.

## Cotents

### Install

#### Docker

```bash
docker run --name jenkins-docker -d -p 8080:8080 -p 50000:50000 -v /home/jenkins:/var/jenkins_home -u root jenkins/jenkins:lts 
```

volume 을 마운트하여 Jenkins 데이터를 호스트 머신에 영속화한다. [[TeamCity]] 와 달리 Jenkins 는 파일로 모든 설정이 관리된다. 마운트를 설정해두면 인증 정보 및 데이터 관리가 매우 편리해지므로 꼭 설정하자. 대상 경로는 `/home/jenkins` 또는 `/var/lib/jenkins` 를 많이 사용한다.

이 글에서는 `/home/jenkins` 경로에 생성했다고 가정하고 진행한다.

### Authentication

master 든 node 든 보안 및 접근 제어를 위해 jenkins 라는 유저를 만들어서 진행한다.

#### 유저 접근 권한 설정

```bash
chown -R jenkins /var/lib/jenkins
```

#### SSH key 관리 에 대해

키가 없다면 `ssh-keygen` 으로 키를 하나 생성하여 private key, 와 public key 를 준비한다.

경로 입력창이 나올 경우 `/home/jenkins/.ssh/id_rsa` 를 입력하여 `/home/jenkins/.ssh` 아래에 키가 생성될 수 있도록 하면 된다.

#### GitLab

gitlab 의 개인 설정에 들어가면 SSH setting 탭이 있다. public key 를 추가해준다.

pipeline 에서 git 을 선택하면 repository 경로 입력창이 표시된다. git@~ 로 시작하는 SSH 경로를 입력해주면 붉은 에러가 표시된다. 해결하기 위해 credential 을 하나 생성한다. SSH credential 을 선택하여 생성하고 ID 값은 유용하게 사용될 수 있는 값이므로 입력하는 것을 권장한다.

#### Node 설정

node 는 Jenkins 의 역할을 효율적으로 분배할 수 있는 방법이다.

node 와 통신하기 위해 master 에 `ssh-keygen` 으로 키를 생성한다. 이미 생성해서 쓰고 있는게 있다면 재사용해도 무방하다.

![[jenkins-credentials-provider.png]]

- `ID`: ssh 키를 jenkins 내에서 식별할 수 있게 해주는 값이다. 설정해두면 jenkinsfile 등에서 credential 사용이 어느 정도 편해지므로 가급적 유의미한 값으로 설정하는 것이 좋다. 설정하지 않는다면 UUID 값이 생성된다.
- `Username`: linux 의 유저. 보통 jenkins 를 유저로 사용하므로 jenkins 를 입력해주면 된다. **입력하지 않을시 reject key error 를 볼 수 있으니 주의**한다.

#### Docker 접근 권한

docker group 이 없을 경우 생성한다. 보통은 docker 를 설치하면 자동으로 생성된다.

```bash
sudo groupadd docker
```

다음 명령어를 통해 jenkins user 에게 docker 를 실행할 수 있는 권한을 부여한다.

```bash
sudo gpasswd -a jenkins docker
# Adding user jenkins to group docker
```

```bash
sudo chmod 666 /var/run/docker.sock
```

docker daemon 을 재시작하여 변경된 설정을 적용시키자.

```bash
systemctl restart docker
```

이후로 `docker ps` 명령이 실행되는 것을 확인할 수 있다.

### Restart

Jenkins 의 버전을 업데이트하거나 플러그인을 설치, 제거, 업데이트하는 경우 Jenkins 가 재시작된다. 하지만 docker 로 관리 중일 경우 container 가 내려가버리기 때문에 jenkins 가 시작되지 않는다. restart 를 위해서는 container 에 restart 정책을 설정해줘야 한다.

```bash
docker update --restart=always jenkins-docker
```

이후로 jenkins-docker container 는 항상 running 상태를 유지한다.

## 주의사항

플러그인 업데이트의 경우 현재 운영중인 jenkins 의 버전과 호환되는지 신중하게 살펴본 후 업데이트해야 한다. Jenkins 의 버전과 플러그인의 버전이 맞지 않아서 pipeline 이 실패하는 일이 종종 생길 수 있다.

## Reference

[docker 로 Jenkins 관리하기](https://dev-overload.tistory.com/40)

## Links

[[Docker]]
