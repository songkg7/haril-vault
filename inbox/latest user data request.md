---
title: "user data 요청이 발생하는 이유와 해결"
date: 2023-05-04 15:50:00 +0900
aliases: 
tags: [aws, linux]
categories: 
updated: 2023-05-04 15:50:38 +0900
---

[[DataDog]] 에서 APM 중인 노드에서 지속적으로 http 404 error 가 발생하는 것을 확인하고 해당 url 을 살펴본 결과, `/latest/user-data/` 라는 리소스를 `http://169.254.169.254` 에 요청하고 있는 것을 확인할 수 있었다.

해당 요청은 aws ec2 에서 linux user data 를 요청하는 것으로 linux instance 에 user data 를 설정하는 작업을 해주면 된다.

## Reference

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-add-user-data.html