---
title: Promtail
date: 2024-01-18 15:47:00 +0900
aliases: 
tags:
  - monitoring
  - observability
  - promtail
  - log
categories: 
updated: 2024-10-05 11:44:36 +0900
---

경량 log 수집기. 로그를 [[Loki]] 로 전송하고 [[Grafana]] 등으로 모니터링할 수 있다.

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: <host_ip>/loki/api/v1/push

scrape_configs:
  - job_name: <name>
    static_configs:
      - targets:
          - localhost
        labels:
          job: label
          __path__: /var/log
```

```bash
docker run -d --name=promtail --restart always --volume="$PWD/promtail-config.yaml:/etc/promtail/config.yml" --volume="/var/log/:/var/log/" grafana/promtail
```
