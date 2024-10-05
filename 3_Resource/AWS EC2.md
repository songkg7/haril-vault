---
title: AWS EC2
date: 2023-11-09 17:36:00 +0900
aliases: 
tags: 
categories: 
updated: 2024-10-05 11:44:36 +0900
---

### EC2 인스턴스 생성

#### Docker 설치

```bash
sudo yum update -y
sudo yum install docker -y
```

```bash
sudo systemctl start docker # 도커 데몬 실행
sudo systemctl enable docker
```

![[Pasted image 20231107145058.png]]

도커는 항상 root 로 실행되기 때문에 편의를 위해 일반 사용자에게도 도커 실행 권한을 부여해주려 한다. ec2-user 를 docker 그룹에 추가함으로써 sudo 명령어를 사용하지 않고도 도커를 사용할 수 있게 해보자.

```bash
sudo usermod -aG docker [username]
sudo systemctl restart docker
```

이후 ec2-user 에서 로그아웃했다가 다시 접근해보면 `docker ps` 명령을 실행할 수 있는 것을 확인할 수 있다.

![[Pasted image 20231107145019.png]]

우선은 여기까지만 진행해두자.