---
title: 스프링 빈 생성주기
date: 2023-07-15T13:51:00
aliases: 
tags:
  - spring
  - bean
categories: Spring
updated: 2025-01-07T00:35
---

In [[Spring framework|Spring]], a bean's lifecycle consists of several stages that define its creation, initialization, and destruction. Understanding the bean lifecycle is important for managing dependencies and performing necessary actions at specific stages.

1. Instantiation: In this stage, the framework creates an instance of the bean using its constructor or factory method.
2. Population of properties: Once the bean is instantiated, the framework injects any required dependencies into the bean's properties using setters or constructors.
3. BeanNameAware and BeanFactoryAware: If a bean implements the BeanNameAware or BeanFactoryAware interface, Spring sets the bean's name and reference to the BeanFactory before further initialization.
4. Pre-initialization: In this stage, Spring calls any registered BeanPostProcessors to perform custom modifications on the bean instance before it is fully initialized.
5. InitializingBean and init-method: If a bean implements InitializingBean interface, Spring invokes its afterPropertiesSet() method. Alternatively, you can specify an init-method in XML configuration to execute custom initialization logic.
6. Post-initialization: After initializing beans, Spring again calls all registered BeanPostProcessors to further modify or wrap the fully initialized beans if needed.
7. Ready for use: At this point, all dependencies are injected, and the bean is ready for use by other beans or components in the application context.
8. Destruction: When an application context is closed or a singleton bean is explicitly destroyed, Spring calls any registered destruction callbacks on beans implementing DisposableBean interface or having a destroy-method specified in XML configuration.

It's important to note that not all stages are mandatory for every bean; it depends on their specific requirements. Additionally, you can customize certain aspects of the lifecycle by implementing interfaces or specifying configuration options in XML or annotations.
