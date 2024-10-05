---
title: SSM
date: 2023-11-09 17:34:00 +0900
aliases: 
tags: 
categories: 
updated: 2024-10-05 11:44:36 +0900
---

### IAM role 생성

![[Pasted image 20231106123949.png]]

![[Pasted image 20231106124020.png]]

생성을 클릭하면 IAM role 이 하나 생성된다.

접속해보면 다음과 같은 문제가 발생할 것이다.

```bash
aws ssm start-session --target {instance_id}

SessionManagerPlugin is not found. Please refer to SessionManager Documentation here: http://docs.aws.amazon.com/console/systems-manager/session-manager-plugin-not-found
```

### aws session manager plugin 설치

```bash
brew tap dkanejs/aws-session-manager-plugin
brew install aws-session-manager-plugin
```
