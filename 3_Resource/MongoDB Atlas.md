---
title: MongoDB Atlas
date: 2022-12-22T21:18:00
aliases: 
tags:
  - mongodb
  - cloud
categories: MongoDB
updated: 2025-01-07T00:35
---

## Overview

Cloud 환경에서 [[MongoDB]] 를 사용하는 방법 중 하나인 MongoDB Atlas 를 소개한다.

## Content

```bash
brew install mongosh
```

```bash
mongosh "mongodb+srv://cluster0.nunzdot.mongodb.net/myFirstDatabase" --apiVersion 1 --username mongodb_user
Enter password: ****************
Current Mongosh Log ID:	63a44ee6928992a38b5b7cb7
Connecting to:		mongodb+srv://<credentials>@cluster0.nunzdot.mongodb.net/myFirstDatabase?appName=mongosh+1.6.1
Using MongoDB:		5.0.14 (API Version 1)
Using Mongosh:		1.6.1

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

Atlas atlas-zwjjhf-shard-0 [primary] myFirstDatabase>

Atlas atlas-zwjjhf-shard-0 [primary] myFirstDatabase> show dbs
admin  280.00 KiB
local    1.25 GiB
Atlas atlas-zwjjhf-shard-0 [primary] myFirstDatabase> show collections

Atlas atlas-zwjjhf-shard-0 [primary] myFirstDatabase> db
myFirstDatabase
Atlas atlas-zwjjhf-shard-0 [primary] myFirstDatabase>
```
