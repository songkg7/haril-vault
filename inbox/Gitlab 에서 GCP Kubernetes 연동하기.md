---
title: "Gitlab 에서 GCP Kubernetes 연동하기"
date: 2022-11-24 17:47:00 +0900
aliases: 
tags: 
categories: 
---

repository 의 .gitlab/<agent-name>/config.yaml 파일 생성. `yml` 이 아닌 `yaml` 이여야 함.


agent 설치

GCP CLI 설치 후 local 에서 kubernetes engine 접근

```bash
kubectl config get-context
```

```bash
kubectl config set-context my-context
```

gitlab 에서 infrastructure > kubernetes 메뉴의 connect cluster

helm 설치 후 gitlab chart 적용

