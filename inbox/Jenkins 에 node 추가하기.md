---
title: "Jenkins 에 node 추가하기"
date: 2022-12-30 11:27:00 +0900
aliases: 
tags: 
categories: 
---

[[Jenkins]] 에 node 를 추가하게 되면 Jenkins 자체의 부하를 줄이고 서버 자원을 효율적으로 활용할 수 있게 된다.

### Error 대처

`No ECDSA host key is known for gitlab.com and you have requested strict checking.` 가 출력될 경우 아래 명령을 통해 해당 repository 를 `known_hosts` 에 등록 후 재실행한다.

```bash
git ls-remote -h git@gitlab.com:seavantage/backend/bespoke/svmp-portinsight-batch-statistic.git HEAD
```

### node 에 Java agent 설치

```bash
yum update
```

### add user

```bash
adduser jenkins
```

jenkins 유저를 추가하고 `/home/jenkins` 경로가 홈으로 설정되었는지 확인한다.

### permission denied

permission denied (publickey) 가 발생할 경우, `.ssh` directory 의 실행권한을 확인해본다. directory 가 너무 많은 실행권한을 가지고 있으면 정상동작하지 않을 수 있다.

```bash
chmod 600 /home/jenkins/authorized_key
chmod 700 /home/jenkins/.ssh
```

### Known_hosts

known_hosts 관련 에러가 발생할 경우, jenkins 가 신규 노드를 허용된 노드라고 인식할 수 있도록 다음 명령을 통해 jenkins home 디렉토리 아래 known_hosts 에 추가해줘야 한다.

```bash
ssh-keyscan -H {new node IP} >> /var/lib/jenkins/.ssh/known_hosts
```

## Docker

jenkins 에서 docker 를 실행하기 위한 몇 가지 단계를 추가 작성한다.

```bash
groupadd -f docker
usermod -aG docker jenkins
chown root:docker /var/run/docker.sock
```
