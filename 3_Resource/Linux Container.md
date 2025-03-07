---
title: LXC
date: 2023-10-19T14:42:00
aliases:
  - LXC
tags: 
categories: 
updated: 2025-01-07T00:35
---

## LXC란

LXC(Linux Container)는 리눅스 커널을 기반으로 한 가상화 기술로, 여러 개의 격리된 환경에서 애플리케이션을 실행할 수 있게 해줍니다. 이는 가상 머신과 유사한 기능을 제공하지만, 가상 머신과는 달리 호스트 운영 체제와 동일한 커널을 공유하므로 성능 손실이 적습니다.

LXC는 네임스페이스, cgroups 및 chroot와 같은 리눅스 커널의 기능을 사용하여 격리된 환경을 만듭니다. 네임스페이스는 프로세스가 자원에 대한 가상화를 제공하고, cgroups는 자원 할당 및 제한을 관리하며, chroot는 파일 시스템의 루트 디렉토리를 변경하여 프로세스의 격리된 파일 시스템 환경을 생성합니다.

LXC를 사용하면 애플리케이션의 실행 환경을 표준화하고 관리하기 쉽게 만들 수 있습니다. 또한, 여러 개의 LXC 컨테이너를 동시에 실행할 수 있으며, 각각의 컨테이너는 독립적인 프로세스 공간과 파일 시스템을 갖습니다.

LXC는 가상 머신에 비해 빠른 성능을 제공하고, 리소스 사용량도 적습니다. 따라서, 서버 가상화, 애플리케이션 배포 및 테스트 등의 다양한 용도로 사용됩니다. 또한, LXC는 [[Docker]]와 같은 컨테이너 관리 도구의 기반이 되기도 합니다.

LXC는 리눅스 커널에서 기본적으로 지원되고 있으며, 다양한 리눅스 배포판에서 사용할 수 있습니다. LXC를 사용하기 위해서는 호스트 시스템에 LXC 패키지를 설치해야 하며, 필요한 설정을 통해 컨테이너를 생성하고 관리할 수 있습니다.

## 문제점

LXC는 격리된 환경을 제공하여 애플리케이션을 실행할 수 있지만, 가상 머신과는 달리 커널을 공유하기 때문에 보안 취약성이 존재할 수 있습니다. 컨테이너 간에 커널을 공유하기 때문에 한 컨테이너에서 다른 컨테이너로의 공격이 가능하며, 이는 호스트 시스템으로의 침입으로 이어질 수 있습니다.

또한, LXC는 가상 머신에 비해 격리 기능이 상대적으로 약합니다. 네임스페이스와 cgroups를 사용하여 프로세스와 리소스를 격리시키지만 완벽한 격리를 보장하지는 않습니다. 따라서, 공격자가 컨테이너 내부로 침입하여 다른 컨테이너나 호스트 시스템에 영향을 줄 수 있습니다.

또한, LXC는 복잡한 설정과 관리가 필요합니다. LXC를 사용하기 위해서는 호스트 시스템에 LXC 패키지를 설치하고 설정해야 하며, 각각의 컨테이너도 개별적으로 설정해야 합니다. 이는 초기 구성 및 유지 관리에 추가적인 작업과 시간이 필요하게 됩니다.

마지막으로, LXC는 다른 가상화 기술에 비해 상대적으로 낮은 수준의 추상화를 제공합니다. 이는 사용자가 직접 네트워크, 스토리지 및 리소스 관리 등을 설정해야 함을 의미합니다. 따라서, 초기 설정 및 운영에 있어서 높은 수준의 지식과 경험이 필요할 수 있습니다.
