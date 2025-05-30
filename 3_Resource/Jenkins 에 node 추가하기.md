---
title: Jenkins 에 node 추가하기
date: 2022-12-30T11:27:00
aliases: 
tags:
  - jenkins
  - docker
  - ssh
  - linux
categories: 
updated: 2025-01-07T00:35
---

[[Jenkins]] 에 node 를 추가하게 되면 Jenkins 자체의 부하를 줄이고 서버 자원을 효율적으로 활용할 수 있게 된다.

## node 에 Java agent 설치

### Host

```bash
yum update
```

Amazon Linux 2 2023~

```bash
sudo yum install java-11-amazon-corretto-headless
# or
sudo yum install java-11-amazon-corretto
```
### Docker Agent

```bash
docker run -d --name agent --restart unless-stopped jenkins/ssh-agent "publickey"
```

```bash
docker run -d --name agent -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped jenkins/ssh-agent "publickey"
```

## add user

```bash
adduser jenkins
```

jenkins 유저를 추가하고 `/home/jenkins` 경로가 홈으로 설정되었는지 확인한다.

## permission denied

permission denied (publickey) 가 발생할 경우, `.ssh` directory 의 실행권한을 확인해본다. directory 가 너무 많은 실행권한을 가지고 있으면 정상동작하지 않을 수 있다.

```bash
chmod 600 /home/jenkins/.ssh/authorized_key
chmod 700 /home/jenkins/.ssh
```

## Known_hosts

Jenkins 에서 node strategy 를 known host strategy 를 선택하게 되면 등록된 host 만 노드로 인식할 수 있다.

known_hosts 관련 에러가 발생할 경우, jenkins 가 신규 노드를 허용된 노드라고 인식할 수 있도록 다음 명령을 통해 jenkins home 디렉토리 아래 known_hosts 에 추가해줘야 한다.

```bash
ssh-keyscan -H {new node IP} >> /var/lib/jenkins/.ssh/known_hosts
```

`No ECDSA host key is known for gitlab.com and you have requested strict checking.` 가 출력될 경우 아래 명령을 통해 해당 repository 를 node 의 `known_hosts` 에 등록 후 재실행한다.

```bash
git ls-remote -h git@~.git HEAD
# e.g. git ls-remote -h git@gitlab.com:seavantage/backend/hub/batch/svmp-ship-to-s3-batch.git HEAD
```

### node 에서 GitLab 접속의 경우

node 에서 GitLab 의 private repository 에 접근할 때도 마찬가지로 known_hosts 에 등록되어 있어야 가능하다. 이번엔 node 에서 아래 명령을 통해 등록해준다.

```bash
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
```

## Docker

jenkins 에서 docker 를 실행하기 위한 몇 가지 단계를 추가 작성한다.

```bash
groupadd -f docker
# gpasswd 사용을 권장
usermod -aG docker jenkins
chown root:docker /var/run/docker.sock
```

![[Linux 유저에 Docker 실행 권한 부여하기]]
