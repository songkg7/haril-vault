---
title: ArgoCD
date: 2024-08-07 11:18:00 +0900
aliases: 
tags:
  - cicd
categories: 
description: 
updated: 2024-08-07 11:18:26 +0900
---

## ArgoCD 의 특징

- GitOps: Git 저장소를 기반으로 배포 관리
- 다양한 배포 방식 지원 (Canary, Blue/Green 등)
- 다양한 Git 서비스 지원 (GitHub, BitBucket 등)
- CLI, API 제공
- 관리 UI 제공
- Webhook 지원
- 롤링 업데이트
- 커스텀 컨트롤러 추가 가능

## ArgoCD 설치

1. Kubernetes 클러스터에 ArgoCD 설치

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

2. Load Balancer로 노출하기 위해 Service 타입 변경 및 ingress 생성

```bash
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "LoadBalancer"}}'
```

```bash
kubectl apply -f ingress.yaml
```

3. ArgoCD UI 접속 및 로그인 정보 가져오기

```bash
export INGRESS_IP=$(kubectl get ingress argocd-ingress -n argocd \
  -o 'jsonpath={.status.loadBalancer.ingress[0].ip}')

echo "https://$INGRESS_IP"
echo "username: admin"
echo "password: $(kubectl get pod -n argocd \
  | grep 'argocd-server-' | awk '{print $1}')"
```

## 예제 소스 코드

### Guestbook 어플리케이션 배포하기

1. Guestbook 어플리케이션 소스 코드 Clone

```bash
git clone https://github.com/ibm-cloud-architecture/argocd-example-apps.git
cd argocd-example-apps
```

2. Guestbook 어플리케이션 배포

```bash
kubectl apply -f apps/guestbook.yaml
```

3. ArgoCD에서 Guestbook 어플리케이션 배포 결과 확인
4. Guestbook 어플리케이션 업데이트

```bash
sed -i 's/2.0/2.1/g' apps/guestbook.yaml
```

```bash
kubectl apply -f apps/guestbook.yaml
```

5. ArgoCD에서 Guestbook 어플리케이션 업데이트 결과 확인

### guestbook-ui 레파지토리를 이용한 Guestbook 어플리케이션 배포하기

1. guestbook-ui 레파지토리 Clone 및 배포

```bash
git clone https://github.com/ibm-cloud-architecture/guestbook-ui.git \
  apps/guestbook-ui \
  && kubectl apply -f apps/guestbook-ui/kubernetes/
```

2. ArgoCD에서 guestbook-ui 어플리케이션 배포 결과 확인
3. guestbok-ui 버전 변경 및 업데이트 수동 트리거로 설정하기

`apps/guestbok-ui/kubernetes/deployment.yaml` 파일을 아래와 같이 수정한다.

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: guestbook-ui
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: guestbook-ui
    spec:
      containers:
      - name: guestbook-ui
        image: ibmcase/guestbook-ui:2.0
        ports:
        - containerPort: 5000

```

4. guestbok-ui 버전을 `2.0`에서 `2.1`로 수정한다.

```bash
sed -i 's/2.0/2.1/g' apps/guestbook-ui/kubernetes/deployment.yaml
```

5. ArgoCD에서 guestbook-ui 어플리케이션 업데이트 결과 확인
6. 수동 트리거로 설정한 경우, UI에서 업데이트 배포를 수행할 수 있다.
7. git push 이벤트를 통해도 배포 가능하다.

## 참고 자료

- [Official Documentation](https://argoproj.github.io/argo-cd/)
- [ArgoCD on GitHub](https://github.com/argoproj/argo-cd)
- [ArgoCD Introduction](https://www.youtube.com/watch?v=JxqZUSELmSs)
