---
title: "DataDog"
date: 2023-05-08 13:14:00 +0900
aliases: 
tags: [datadog, apm, monitoring]
categories: 
updated: 2023-05-08 13:15:24 +0900
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