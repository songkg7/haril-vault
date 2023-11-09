---
title: EC2 인스턴스에 이미지 배포하기
date: 2023-11-09 17:38:00 +0900
aliases: 
tags:
  - ec2
  - aws
  - infrastructure
categories: 
updated: 2023-11-09 17:38:32 +0900
---

### EC2 인스턴스에 이미지 배포하기

우리가 선택한 AWS Linux 2 에는 [[AWS CLI]]가 기본적으로 설치되어 있다.

```bash
aws --version
```

aws cli 는 EC2 인스턴스의 경우 EC2InstanceMetadata 를 사용하여 인증 정보를 해결할 수 있기 때문에, 인스턴스에 적절한 role 만 설정되어 있다면 별도의 토큰 없이도 cli 를 호출할 수 있다.

```bash
aws sts get-caller-identity
```

로그인을 진행해보자. 명령어는 ECR 에 이미지를 푸시했을 때 사용했던 명령어와 비슷하다.

![[Pasted image 20231107143718.png]]

_별도의 인증 없이도 로그인이 성공한다_

> [!NOTE] AccessDeniedException 이 발생하는 경우
> `ecr:GetAuthorizationToken` 권한을 EC2 인스턴스가 보유하고 있어야 한다. 웹 콘솔에서 인스턴스가 보유한 권한을 확인해보고, 없다면 권한을 추가해주면 된다. 필자는 `EC2InstanceProfileForImageBuilderECRContainerBuilds` role 을 default-ec2-ssm-role 에 추가해뒀다.

![[Pasted image 20231107144228.png]]

이후는 간단하다. ECR registry 에 있는 이미지를 run 명령을 통해 실행시키면 된다.

```bash
docker run -p 8080:8080 --name sample-server -d 056876186590.dkr.ecr.ap-northeast-2.amazonaws.com/sample-server:latest
```

![[Pasted image 20231107145644.png]]

_배포 완료!_

이제 테스트를 위한 서버 준비는 끝났다. 다음은 API 서버를 로컬에서 호출할 수 있도록 외부의 접근을 허용하는 과정을 진행해본다.

### EC2 인스턴스 외부에 공개하기

기본적으로 EC2 인스턴스에 설정하는 보안 그룹은 아웃바운드는 모두 허용하지만 인바운드는 제한한다. public IP 를 사용하는 EC2 인스턴스라면 보안 그룹의 인바운드 설정을 수정하여 외부 접근을 허용할 수 있다.

- 모든 트래픽, 본인의 IP 만

![](https://i.imgur.com/cBePThO.png)

이렇게 설정하면 로컬에서 발생시키는 트래픽이 EC2 로 접근할 수 있게 된다.

실제 운영 환경이라면 [[VPC]] 설정을 통해 private network 로 설정하고 사용해야하겠지만, 해당 내용은 다른 글에서 다뤄보겠다.
