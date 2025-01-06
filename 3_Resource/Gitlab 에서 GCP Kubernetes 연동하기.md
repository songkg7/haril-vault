---
title: Gitlab 에서 GCP Kubernetes 연동하기
date: 2022-11-24T17:47:00
aliases: 
tags: 
categories: 
updated: 2025-01-07T00:35
---

[[GitLab]]
[[Kubernetes]]

repository 의 `.gitlab/<agent-name>/config.yaml` 파일 생성. `yml` 이 아닌 `yaml` 이여야 함.

agent 설치

[[Google Cloud Platform|GCP]] CLI 설치 후 local 에서 kubernetes engine 접근

```bash
kubectl config get-context
```

```bash
kubectl config set-context my-context
```

gitlab 에서 infrastructure > kubernetes 메뉴의 connect cluster

helm 설치 후 gitlab chart 적용

```bash
brew install helm
```
