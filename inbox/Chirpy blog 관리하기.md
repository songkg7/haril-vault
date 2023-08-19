---
title: Chirpy blog 관리하기
date: 2022-10-22 15:04:00 +0900
aliases: null
tags:
  - blog
  - chirpy
  - jekyll
categories: null
updated: 2023-08-19 12:38:00 +0900
---

## Overview

## Github pages

[[GitHub]] 에서 제공하는 페이지 기능을 사용하여 블로그를 생성해본다.

chirpy 의 경우, 간단하게 시작할 수 있는 starter 를 제공하지만 본인이 개발자이고 Google adsense 와 같은 부가기능을 사용하고 싶다면 chirpy repository 자체를 fork 하여 custom 하는 것이 낫다. 만약 간단하게 블로그 기능만 쓰고 싶다면 starter 로 시작해보는 것도 좋겠다.

## Customizing

### Configuration

`_config.yml` 파일을 통해 간단한 설정을 진행할 수 있다.

## Google

### Search console

블로그를 구글에 노출시키기 위한 설정을 진행한다.

### Analysis

현재 블로그에 대한 통계 등 다양한 insight 를 얻을 수 있는 서비스

### AdSense

블로그를 통해 수입을 얻고 싶다면 [[Google AdSense|AdSense]] 를 설정해주면 된다. 이제 막 시작한 블로그에는 잘 승인이 나지 않으니 어느 정도 꾸준히 관리한 이후 시도해보는 것을 추천한다.

[[Google AdSense|Adsence]] 를 사용하여 광고를 붙이기 위해선 `_includes` 폴더 아래에서 `head.html` 파일을 수정해주어야 한다.

