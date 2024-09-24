---
title: Kubernetes
date: 2022-08-20 14:09:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-08-20
aliases: k8s
tags:
  - devops
  - container
  - docker
  - cloud
categories:
  - Kubernetes
updated: 2024-01-31 13:57:41 +0900
---

## Overview

## Contents

### Private registry 사용하기

#### Secret 생성

```bash 
kubectl create secret docker-registry regcred --docker-server=registry.gitlab.com --docker-username=<username> --docker-password=<password> --docker-email=<email>
``` 

#### Secret 정상 생성 확인

```bash
kubectl get secret regcred --output=yaml
```

#### base64 로 인코딩된 부분을 인식가능하도록 출력

```bash 
kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
```

#### private-reg-pod.yaml 작성

```bash
vi private-reg-pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: private-reg
spec:
  containers:
  - name: <name>
    image: <your-image>
  imagePullSecrets:
  - name: regcred 
```

#### yaml 적용

```bash 
kubectl apply -f private-reg-pod.yaml
```

#### Pod 실행

```bash
kubectl get pod private-reg
```

## Conclusion

## Reference

- [cheatsheet](https://kubernetes.io/ko/docs/reference/kubectl/cheatsheet/)

## Links

- [[Docker]]
- [[Istio]]
- [[Minikube]]
- [[Helm]]
- [[Micro-Service Architecture]]
