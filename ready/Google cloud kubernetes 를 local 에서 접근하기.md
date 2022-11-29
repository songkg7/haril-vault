---
title: "Google cloud kubernetes 를 local 에서 접근하기"
date: 2022-11-24 13:38:00 +0900
aliases: 
tags: [gcp, kubernetes]
categories:
---

## Overview

간단한 명령어 한 줄을 치기 위해 web 으로 접근해서 cloud shell 을 열기보다 로컬에서 바로 입력 후 확인하는 것이 훨씬 하겠죠. 이번 글에서는 Google cloud [[Kubernetes]] 를 local 에서 CLI 를 통해 관리하기 위한 방법을 공유합니다.

## Contents

### GCP CLI 설치

먼저 gcp cli 를 설치해야 합니다. [gcp-cli](https://cloud.google.com/sdk/gcloud?hl=ko) 링크를 참조하여 자신에게 맞는 운영체제를 확인 후 설치합니다.

### 접속

설치가 끝났다면 다음 명령어를 통해 인증과정까지 완료해줍니다.

```bash
gcloud init
```

GCP kubernetes engine 으로 접근하여 cluster 의 연결 정보를 가져와야 합니다.

![[스크린샷 2022-11-24 오후 1.46.43.png]]

![[스크린샷 2022-11-24 오후 1.52.24.png]]

명령줄 액세스를 복사한 후, 터미널에서 실행해봅니다.

```bash
gcloud container clusters get-credentials sv-dev-cluster --zone asia-northeast3-a --project {projectId}
```

```console
Fetching cluster endpoint and auth data.
CRITICAL: ACTION REQUIRED: gke-gcloud-auth-plugin, which is needed for continued use of kubectl, was not found or is not executable. Install gke-gcloud-auth-plugin for use with kubectl by following https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
kubeconfig entry generated for sv-dev-cluster.
```

### Plugin 설치

최초 실행일 경우 `gke-gcloud-auth-plugin` 을 설치해달라는 에러가 출력됩니다. 다음 명령어를 통해 플러그인을 설치해줄 수 있습니다.

```bash
gcloud components install gke-gcloud-auth-plugin


Your current Google Cloud CLI version is: 408.0.1
Installing components from version: 408.0.1

┌────────────────────────────────────────────┐
│    These components will be installed.     │
├────────────────────────┬─────────┬─────────┤
│          Name          │ Version │   Size  │
├────────────────────────┼─────────┼─────────┤
│ gke-gcloud-auth-plugin │   0.4.0 │ 7.1 MiB │
└────────────────────────┴─────────┴─────────┘

For the latest full release notes, please visit:
  https://cloud.google.com/sdk/release_notes

Do you want to continue (Y/n)?  y

╔════════════════════════════════════════════════════════════╗
╠═ Creating update staging area                             ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: gke-gcloud-auth-plugin                       ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Installing: gke-gcloud-auth-plugin                       ═╣
╠════════════════════════════════════════════════════════════╣
╠═ Creating backup and activating new installation          ═╣
╚════════════════════════════════════════════════════════════╝

Performing post processing steps...done.

Update done!
```

다시 연결 명령어를 실행해보면,

```
Fetching cluster endpoint and auth data.
kubeconfig entry generated for sv-dev-cluster.
```

cluster 와 연결된 것을 확인할 수 있습니다. 연결이 성공하면 docker desktop 에도 변화가 생기는데요. 다음처럼 Kubernetes 탭에 새로운 정보가 표시되는 것을 확인할 수 있습니다.

![[스크린샷 2022-11-24 오후 1.38.01.png]]

이후 local terminal 에서 `kubectl` 을 실행하게 되면 GCP kubernetes engine 에서 실행 중인 정보를 확인할 수 있게 됩니다.

```bash
kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
my-application        1/1     1            1           20d
```

## Reference

[k8s-plugin](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke?hl=en)
