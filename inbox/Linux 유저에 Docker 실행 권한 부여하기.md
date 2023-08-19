---
title: Linux 유저에 Docker 실행 권한 부여하기
date: 2023-03-16 11:28:00 +0900
aliases: null
tags:
  - linux
  - docker
categories: null
updated: 2023-08-19 12:37:53 +0900
---

## add user

```bash
adduser jenkins
```

jenkins 유저를 추가하고 `/home/jenkins` 경로가 홈으로 설정되었는지 확인한다.

## 

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
