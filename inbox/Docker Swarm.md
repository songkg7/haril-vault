---
title: Docker Swarm
date: 2023-05-13 18:26:00 +0900
aliases: null
tags:
  - docker
  - swarm
categories: null
updated: 2023-08-19 12:38:04 +0900
---

[[Docker|Docker]]

[[Kubernetes|Kubernetes]]

Docker Swarm is a clustering and orchestration tool for Docker containers. It allows users to manage a group of Docker hosts as a single virtual system. Docker Swarm enables users to easily deploy, scale, and manage containerized applications across multiple hosts.

With Docker Swarm, users can create a swarm cluster consisting of multiple Docker hosts. The cluster is managed by a swarm manager, which acts as the control plane for the cluster. The swarm manager distributes tasks to worker nodes, which execute the tasks on behalf of the manager.

Docker Swarm provides several features that make it easy to deploy and manage containerized applications. These include:

- Service discovery: Docker Swarm provides built-in service discovery, which allows containers to find each other by name or label.

- Load balancing: Docker Swarm automatically load balances traffic to containers running on different hosts.

- Rolling updates: Docker Swarm allows users to perform rolling updates of their services without downtime.

- High availability: Docker Swarm ensures that services are highly available by automatically rescheduling tasks if a worker node fails.

Docker Swarm is an alternative to Kubernetes, another popular container orchestration tool. While Kubernetes is more feature-rich and complex than Docker Swarm, it also has a steeper learning curve. For smaller deployments or simpler use cases, Docker Swarm may be a more appropriate choice than Kubernetes.