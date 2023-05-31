---
title: "Spring REST Docs"
date: 2022-11-04 18:59:00 +0900
aliases: 
tags: [java, documentation, docs]
categories: Spring
updated: 2023-05-31 16:24:29 +0900
---

## Overview

## Error

[Github issue](https://github.com/asciidoctor/asciidoctor-gradle-plugin/issues/652) 에서 공유되고 있는 문제.

```logs
A problem occurred configuring root project 'demo'.
> Could not resolve all files for configuration ':classpath'.
   > Could not find org.ysb33r.gradle:grolifant:0.16.1.
     Searched in the following locations:
       - https://plugins.gradle.org/m2/org/ysb33r/gradle/grolifant/0.16.1/grolifant-0.16.1.pom
     If the artifact you are trying to retrieve can be found in the repository but without metadata in 'Maven POM' format, you need to adjust the 'metadataSources { ... }' of the repository declaration.
     Required by:
         project : > org.asciidoctor.jvm.convert:org.asciidoctor.jvm.convert.gradle.plugin:3.3.2 > org.asciidoctor:asciidoctor-gradle-jvm:3.3.2
         project : > org.asciidoctor.jvm.convert:org.asciidoctor.jvm.convert.gradle.plugin:3.3.2 > org.asciidoctor:asciidoctor-gradle-jvm:3.3.2 > org.asciidoctor:asciidoctor-gradle-base:3.3.2

Possible solution:
 - Declare repository providing the artifact, see the documentation at https://docs.gradle.org/current/userguide/declaring_repositories.html 
```

JCenter 에 있던 grolifant 의존성이 MavenCentral 로 이동하게 되면서 기존 의존성을 찾지 못해 발생한 에러로 보인다. `org.asciidoctor.jvm.convert` plugin 이 외부의 라이브러리에 의존하고 있다가 그 라이브러리가 사라지면서 멀쩡하던 plugin 이 망가지게 되었다는 뜻인데, 특정 라이브러리에 대한 의존이 어떤 문제를 가져올 수 있는지 보여줄 수 있는 일련의 예가 될 수 있겠다.

```groovy
plugins {
    id 'org.springframework.boot' version '2.7.5'
    id 'io.spring.dependency-management' version '1.0.15.RELEASE'
    id "org.asciidoctor.jvm.convert" version "3.3.2"
    id 'java'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

ext {
    set('snippetsDir', file("build/generated-snippets"))
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-webflux'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'io.projectreactor:reactor-test'
    asciidoctorExt 'org.springframework.restdocs:spring-restdocs-asciidoctor'
    testImplementation 'org.springframework.restdocs:spring-restdocs-webtestclient'
}

configurations {
    asciidoctorExt
}

ext {
    snippetsDir = file('build/generated-snippets')
}

test {
    outputs.dir snippetsDir
}

asciidoctor {
    inputs.dir snippetsDir
    configurations 'asciidoctorExt'
    dependsOn test
} 
```

### Snippet 작성시 주의점

`org/springframework/restdocs/templates/` 아래에서 snippet 파일을 찾는다. 패키지를 생성할 때 `org.springframework.restdocs.templates` 처럼 `.` 을 사용해서 패키지를 생성하면 snippet 의 위치를 정상적으로 찾지 못하는 문제가 있었다.

```java
public class StandardTemplateResourceResolver implements TemplateResourceResolver {

	private final TemplateFormat templateFormat;

	/**
	 * Creates a new {@code StandardTemplateResourceResolver} that will produce default
	 * template resources formatted with the given {@code templateFormat}.
	 * @param templateFormat the format for the default snippet templates
	 */
	public StandardTemplateResourceResolver(TemplateFormat templateFormat) {
		this.templateFormat = templateFormat;
	}

	@Override
	public Resource resolveTemplateResource(String name) {
		Resource formatSpecificCustomTemplate = getFormatSpecificCustomTemplate(name);
		if (formatSpecificCustomTemplate.exists()) {
			return formatSpecificCustomTemplate;
		}
		Resource customTemplate = getCustomTemplate(name);
		if (customTemplate.exists()) {
			return customTemplate;
		}
		Resource defaultTemplate = getDefaultTemplate(name);
		if (defaultTemplate.exists()) {
			return defaultTemplate;
		}
		throw new IllegalStateException("Template named '" + name + "' could not be resolved");
	}

	private Resource getFormatSpecificCustomTemplate(String name) {
		return new ClassPathResource(String.format("org/springframework/restdocs/templates/%s/%s.snippet",
				this.templateFormat.getId(), name));
	}

	private Resource getCustomTemplate(String name) {
		return new ClassPathResource(String.format("org/springframework/restdocs/templates/%s.snippet", name));
	}

	private Resource getDefaultTemplate(String name) {
		return new ClassPathResource(String.format("org/springframework/restdocs/templates/%s/default-%s.snippet",
				this.templateFormat.getId(), name));
	}

}
```