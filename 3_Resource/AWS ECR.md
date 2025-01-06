---
title: AWS ECR
date: 2023-11-09T17:37:00
aliases: 
tags: 
categories: 
updated: 2025-01-07T00:35
---

### ECR registry 생성

ECR registry 는 클릭 몇 번으로 간단하게 생성할 수 있다.

private registry 를 생성하고 리포지토리를 생성해준다. 이 때 리포지토리의 이름은 도커 이미지 이름으로 해야 하며, 이 리포지토리에 같은 이름의 이미지들이 버전 별로 저장되게 된다. sample-server 라는 ECR Repository 를 하나 생성했다.

![[Pasted image 20231107142000.png]]

check box 에 체크 표시를 하면 푸시 명령 보기 탭이 활성화 되는데 이 탭에서 ecr 에 로그인하는 과정 및 이미지를 푸시하는 과정이 자세히 설명되어 있으니 따라서 진행한다.

![[Pasted image 20231107142116.png]]

_이미지 푸시 완료_