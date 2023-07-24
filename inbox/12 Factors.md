---
title: "12 Factors"
date: 2023-07-24 22:33:00 +0900
aliases: 
tags: [heroku, msa]
categories: 
updated: 2023-07-24 22:34:37 +0900
---

## What is 12 Factors?

The 12 Factors is a methodology for building modern, cloud-native applications. It was introduced by Heroku co-founder Adam Wiggins in 2011 as a set of best practices for developing scalable and maintainable software applications.

The 12 Factors provide guidelines on how to design and deploy applications that are portable, resilient, and easy to manage in a distributed environment such as the cloud. The factors cover various aspects of application development, including codebase management, dependencies, configuration, backing services, build/release processes, and more.

By following the 12 Factors, developers can create applications that are highly adaptable and can be easily deployed across different platforms or cloud providers. This methodology has become widely adopted in the industry and is considered a standard for building cloud-native applications.

The 12 Factors are as follows:

1. Codebase: One codebase tracked in version control, with multiple deploys.
2. Dependencies: Explicitly declare and isolate dependencies.
3. Config: Store configuration in the environment.
4. Backing services: Treat backing services as attached resources.
5. Build, release, run: Strictly separate build and run stages.
6. Processes: Execute the app as one or more stateless processes.
7. Port binding: Export services via port binding.
8. Concurrency: Scale out via the process model.
9. Disposability: Maximize robustness with fast startup and graceful shutdown.
10. Dev/prod parity: Keep development, staging, and production environments as similar as possible.
11. Logs: Treat logs as event streams.
12. Admin processes: Run admin/management tasks as one-off processes.

These factors provide a comprehensive framework that encompasses various aspects of application development and deployment strategies for modern cloud-based systems. By adhering to these principles, developers can ensure their applications are scalable, resilient, and easily maintainable in distributed environments like the cloud.
