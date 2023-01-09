---
title: "K8S NodePort"
date: 2023-01-09 16:37:00 +0900
aliases: 
tags: [k8s, gcp, nodeport, network]
categories: 
---

## Overview

[[Kubernetes]]

## NordPort

![[1*CdyUtG-8CfGu2oFC5s0KwA.webp]]
_이미지 수정_

NodePort 는 외부에서 Node 안의 pod 에 직접 접근할 수 있는 방법을 제공한다.

`elasticsearch-nodeport.yaml` 파일 생성

```yaml
apiVersion: v1
kind: Service
metadata:
  name: elasticsearch-svc-nodeport
  labels:
    app: elasticsearch
spec:
  type: NodePort # default 는 ClusterIP 이므로 반드시 명시한다.
  ports:
    - nodePort: 30920 # 지정하지 않으면 30000~32767 에서 자동으로 지정되므로 포트 충돌을 피하기 위해 활용할 수 있다.
      port: 9200
      targetPort: 9200
      protocol: TCP
  selector: # selector 를 사용하여 service 에 그룹화될 pod를 지정한다.
    app: elasticsearch
```

```bash
kubectl apply -f elasticsearch-nodeport.yaml
```

service 의 생성 확인

```bash
kubectl get svc -l app=elasticsearch
NAME                         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)             AGE
elasticsearch-svc-nodeport   NodePort    10.80.7.201   <none>        9200:30920/TCP      4h4m
```

```bash
kubectl get nodes -o wide
```

아마 아래와 비슷한 느낌으로 출력될 것이다.

```
NAME                                           STATUS   ROLES    AGE     VERSION            INTERNAL-IP   EXTERNAL-IP     OS-IMAGE                             KERNEL-VERSION   CONTAINER-RUNTIME
gke-my-cluster-dev-pool-9a123b5b-5jb2   Ready    <none>   4h4m    v1.23.13-gke.900   <IP>   <IP>    Container-Optimized OS from Google   5.10.147+        containerd://1.5.13
```

IP 는 각자의 환경에 따라 다르게 출력될텐데 cloud 기반의 k8s 를 사용하고 있다면 EXTERNAL-IP 로 요청하면 된다.

[[GCP]] 를 사용하고 있다면 외부에서 접속할 수 있도록 플랫폼의 방화벽 권한을 생성해줘야 한다.

```bash
gcloud compute firewall-rules create elastic-svc-rule --allow=tcp:30920
Creating firewall...⠹Created [https://www.googleapis.com/compute/v1/projects/sv-dev-365407/global/firewalls/elastic-svc-rule].
Creating firewall...done.
NAME              NETWORK  DIRECTION  PRIORITY  ALLOW      DENY  DISABLED
elastic-svc-rule  default  INGRESS    1000      tcp:30920        False
```

접근 확인

```bash
http <NORD-IP>:30920
```

```http
HTTP/1.1 200 OK
content-encoding: gzip
content-length: 331
content-type: application/json; charset=UTF-8

{
    "cluster_name": "elasticsearch-cluster",
    "cluster_uuid": "n-7FDrkDQza6UKAMU9NE-g",
    "name": "elasticsearch-node-1",
    "tagline": "You Know, for Search",
    "version": {
        "build_date": "2020-10-16T10:36:16.141335Z",
        "build_flavor": "oss",
        "build_hash": "c4138e51121ef06a6404866cddc601906fe5c868",
        "build_snapshot": false,
        "build_type": "docker",
        "lucene_version": "8.6.2",
        "minimum_index_compatibility_version": "6.0.0-beta1",
        "minimum_wire_compatibility_version": "6.8.0",
        "number": "7.9.3"
    }
}  
```

## Conclusion

NordPort 는 ClusterIP 의 상위 개념이라 생성될 때 ClusterIP 를 같이 생성한다.

그러나 연결을 시도하는 node 가 fail 상태일 경우 접근할 수 없게 된다. 따라서 Load balancer 를 사용하여 fail 상태인 노드에게 요청되는 접근을 다른 노드로 전환될 수 있도록 처리해야 한다.

## Reference

- [kubernetes in action](https://gist.github.com/ShinJJang/b2f7acb9eb9849bef60d2dc3a2cef9e1)
- [google cloud](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)