---
title: "logback 과 logstash 로 json format logging 하기"
date: 2023-01-03 16:30:00 +0900
aliases: 
tags: 
categories: 
---

logback 관련 의존성 추가

```grooy
implementation 'ch.qos.logback.contrib:logback-json-classic:0.1.5'
implementation 'ch.qos.logback.contrib:logback-jackson:0.1.5' 
implementation 'net.logstash.logback:logstash-logback-encoder:6.6'
```

logback 설정 추가

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <conversionRule conversionWord="clr"
    converterClass="org.springframework.boot.logging.logback.ColorConverter"/>

  <property name="CONSOLE_LOG_PATTERN"
    value="[%d{yyyy-MM-dd HH:mm:ss}:%-3relative]  %clr(%-5level) %clr(${PID:-}){magenta} %clr(---){faint} %clr([%15.15thread]){faint} %clr(%-40.40logger{36}){cyan} %clr(:){faint} %msg%n"/>

  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
      <pattern>${CONSOLE_LOG_PATTERN}</pattern>
    </encoder>
  </appender>

  <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <encoder class="net.logstash.logback.encoder.LogstashEncoder">
      <timeZone>UTC</timeZone>
      <timestampPattern>yyyy-MM-dd'T'HH:mm:ss.SSS'Z'</timestampPattern>
      <fieldNames>
        <levelValue>[ignore]</levelValue>
      </fieldNames>
      <customFields>{"app":"api"}</customFields>
      <jsonGeneratorDecorator class="net.logstash.logback.decorate.CompositeJsonGeneratorDecorator">
        <decorator class="net.logstash.logback.decorate.PrettyPrintingJsonGeneratorDecorator"/>
        <decorator class="net.logstash.logback.mask.MaskingJsonGeneratorDecorator">
          <defaultMask>XXXX</defaultMask>
          <path>accessToken</path>
          <path>refreshToken</path>
          <path>password</path>
        </decorator>
      </jsonGeneratorDecorator>
    </encoder>
  </appender>

  <root level="info">
    <springProfile name="test, default">
      <appender-ref ref="STDOUT"/>
    </springProfile>
    <springProfile name="dev">
      <appender-ref ref="CONSOLE"/>
      <level value="debug"/>
    </springProfile>
  </root>
</configuration>
```

민감한 정보 masking 가능
