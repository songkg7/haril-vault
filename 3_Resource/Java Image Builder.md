---
title: Java Image Builder
date: 2023-04-29T22:23:00
aliases: JIB
tags:
  - docker
categories: 
updated: 2025-01-07T00:35
---

## JIB?

JIB는 [[Java]] Image Builder의 약자로, Docker 이미지를 빌드하기 위한 오픈 소스 도구입니다. JIB는 [[Gradle]] 플러그인 및 [[Maven]] 플러그인으로 사용할 수 있으며, [[Dockerfile]]을 작성할 필요 없이 Java 애플리케이션을 Docker 이미지로 패키징 할 수 있습니다. 또한 JIB는 속도와 보안 측면에서 이점을 제공하며, 이미지를 빌드하고 배포하는 과정을 단순화합니다.

## Usage

JIB를 사용하려면 먼저 Gradle 또는 Maven에 플러그인을 추가해야 합니다.

Gradle:

```
plugins {
  id 'com.google.cloud.tools.jib' version '3.3.1'
}
```

Maven:

```xml
<plugins>
    <plugin>
        <groupId>com.google.cloud.tools</groupId>
        <artifactId>jib-maven-plugin</artifactId>
        <version>1.8.0</version>
    </plugin>
</plugins>
```

그리고 JIB를 실행할 Java 애플리케이션의 이미지 이름과 버전을 설정해야 합니다.

Gradle:

```groovy
jib {
  from {
    image = 'adoptopenjdk:11-jre-hotspot'
  }
  to {
    image = 'my-image:latest'
  }
}
```

Maven:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>com.google.cloud.tools</groupId>
            <artifactId>jib-maven-plugin</artifactId>
            <version>1.8.0</version>
            <configuration>
                <from>
                    <image>adoptopenjdk:11-jre-hotspot</image>     
                </from>             
                <to>           
                    <image>my-image:latest</image>           
                </to>         
            </configuration>     
        </plugin>   
    </plugins> 
</build>
```

마지막으로, Gradle에서 `./gradlew jib` 명령어를 실행하거나 Maven에서 `mvn jib:build` 명령어를 실행하여 Docker 이미지를 빌드할 수 있습니다.

## Conclusion

JIB는 Java 애플리케이션을 Docker 이미지로 쉽게 패키징할 수 있는 오픈 소스 도구입니다. Gradle 또는 Maven 플러그인으로 사용 가능하며, Dockerfile 작성 없이도 이미지를 빌드할 수 있습니다. JIB를 사용하면 속도와 보안 측면에서 이점을 얻을 수 있으며, 이미지 빌드 및 배포 과정을 단순화할 수 있습니다.
