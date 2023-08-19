---
title: k8s hpa 적용
date: 2023-01-06 17:01:00 +0900
aliases: null
tags:
  - k8s
categories: null
updated: 2023-08-19 12:37:54 +0900
---

hpa 적용을 위해 다음 명령어를 실행해본다.

```bash
kubectl get hpa
```

```text
NAME             REFERENCE                   TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
my-api   Deployment/my-api   <unknown>/80%   1         3         1          57d
```

unknown 이라고 표시되는 경우,

```bash
kubectl edit deployment my-api
```


![[스크린샷 2023-01-06 오후 5.04.29.png]]

이렇게 resources 를 지정해주면 deployment 가 재실행되면서 정상적으로 matric 을 수집하기 시작한다.

```bash
kubectl set resource deployment my-api -c=my-api --limit=cpu=200m,memory=512Mi
```

명령을 통해서 바로 수정할 수도 있다.

## Reference

[k8s](https://kubernetes.io/ko/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)