---
title: IAM Identity Center 를 활용한 SSO 인증 활성화
date: 2023-11-07 11:38:00 +0900
aliases: 
tags:
  - sso
  - credential
  - aws
  - iam
categories: 
updated: 2023-11-07 11:38:47 +0900
---

IAM Identity Center는 AWS Identity and Access Management(IAM) 서비스를 사용하여 SSO(Single Sign-On) 인증을 활성화하는 기능을 제공한다. SSO 인증을 활성화하면 사용자는 로컬에서 별도의 access key를 사용하지 않고도 AWS 리소스에 접근할 수 있다.

SSO 인증을 활성화하기 위해 IAM Identity Center를 사용하는 방법은 다음과 같다:

1. IAM Identity Center에 액세스하여 로그인한다.
2. IAM Identity Center에서 원하는 사용자 그룹을 선택하여 그룹에 속한 사용자들의 SSO 인증을 활성화한다.
3. 각 사용자는 자신의 IAM 계정으로 로그인하여 SSO 인증을 설정할 수 있다.

SSO 인증이 활성화되면, 사용자는 여러 개의 AWS 계정에 대한 액세스 권한이 있는 경우에도 단일 로그인으로 모든 계정에 접근할 수 있다. 이로써 사용자는 여러 개의 access key를 기억하거나 관리할 필요가 없어지며, 보안과 편의성 측면에서 이점을 얻을 수 있다.

## Reference

- [AWS SSO 를 이용한 IAM 중앙 관리](https://captcha.tistory.com/81)