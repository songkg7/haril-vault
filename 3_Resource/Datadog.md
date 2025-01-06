---
title: DataDog
date: 2023-05-08T13:14:00
aliases: 
tags:
  - datadog
  - apm
  - monitoring
categories: 
updated: 2025-01-07T00:35
---

```
  -Ddd.env={{env}} \
  -Ddd
  -Ddd.profiling.enabled=true \
  -XX:FlightRecorderOptions=stackdepth=256 \
```

```
-javaagent:/home/centos/datadog/dd-java-agent.jar \
-Ddd.logs.injection=true \
-Ddd.service=<service> \
-Ddd.env=<env> \
-Ddd.profiling.enabled=true \
-XX:FlightRecorderOptions=stackdepth=256
-jar .../your-service.jar
```

## Links

- [[Application Performance Monitoring|APM]]
