---
title: Virtual Machine
date: 2023-10-07 14:38:00 +0900
aliases:
  - VM
tags:
  - vm
categories: 
updated: 2023-10-07 14:38:08 +0900
---

## 가상머신이란

가상머신(Virtual Machine, VM)은 실제 컴퓨터와 동일한 기능을 가진 소프트웨어로, 하드웨어를 에뮬레이트하여 가상의 컴퓨터 환경을 만들어내는 기술이다. 가상머신은 호스트 컴퓨터 위에 설치되고, 이를 통해 여러 개의 게스트 [[운영체제 (Operating system)|운영체제 (Operating system)]]를 동시에 실행할 수 있다.

가상머신은 주로 다음과 같은 목적으로 사용된다.

1. 운영체제 호환성: 다른 운영체제에서 실행되는 프로그램을 호스트 운영체제에서 실행할 수 있도록 한다. 예를 들어, Windows 운영체제에서 Linux 프로그램을 실행하기 위해 가상머신을 사용할 수 있다.
2. 개발 및 테스트: 소프트웨어 개발자는 가상머신을 사용하여 여러 개의 테스트 환경을 만들어내고, 서로 다른 운영체제나 소프트웨어 설정에서 애플리케이션을 테스트할 수 있다.
3. 자원 분리: 가상머신은 하나의 물리적인 서버에서 여러 개의 독립적인 가상 서버를 구축함으로써 자원을 효율적으로 분리하여 사용할 수 있다. 이를 통해 하나의 서버에서 여러 개의 운영체제나 애플리케이션을 실행할 수 있다.
4. 시스템 복구: 가상머신은 하드웨어 추상화를 통해 시스템 복구를 용이하게 해준다. 가상머신 이미지를 백업하고, 문제 발생 시 해당 이미지로 쉽게 복원할 수 있다.

가상머신은 호스트 운영체제 위에서 동작하지만, 가상화 기술을 사용하여 게스트 운영체제를 실행한다. 이러한 가상화 기술은 하이퍼바이저(Hypervisor)라는 소프트웨어로 구현되며, 커널 수준 가상화와 하드웨어 수준 가상화로 나뉜다.

- 커널 수준 가상화: 호스트 운영체제 위에 게스트 운영체제의 커널을 설치하여 실행하는 방식이다. 호스트와 게스트 간의 인터페이스가 필요하며, 호스트 운영체제의 자원을 공유한다.
- 하드웨어 수준 가상화: 하드웨어 레벨에서 직접 작동하여 게스트 운영체제를 실행하는 방식이다. 하이퍼바이저는 호스트 운영체제와 게스트 운영체제 간의 인터페이스로 작동하며, 각각의 운영체제는 독립적인 가상 환경을 가진다.

가상머신은 클라우드 컴퓨팅, 서버 가상화, 개발 및 테스트 등 다양한 분야에서 활용되고 있다. 현재 많은 기업들이 가상머신을 사용하여 비용과 자원을 절감하고, 유연성과 안정성을 높이는데 주력하고 있다.