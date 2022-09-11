---
title: "NodeJS"
date: 2022-09-06 20:53:00 +0900
fc-calendar: Gregorian Calendar
fc-date: 2022-09-06
aliases: 
tags: [nodejs, javascript, server, backend]
categories: [NodeJS]
---

## Overview

## Install

### NVM

node 를 설치하기 전 nvm(node version manager)를 먼저 설치한다.

```bash
# homebrew
brew install nvm
```

Run the following command when the installation is finished.

```bash
nvm --version
```

if you can't run the above command, execute the following command.

```bash
vi ~/.bash_profile
```

please check if the contents below are printed out.

```bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```

```bash
source ~/.bash_profile
```

## 2. bash -> zsh

```bash
vi ~/.zshrc
```

append next lines

```bash
if [ -f ~/.bash_profile ]; then
	. ~/.bash_profile
fi
```

and please restart your application.

