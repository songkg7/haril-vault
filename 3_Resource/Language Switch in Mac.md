---
title: Language Switch in Mac
date: 2024-06-21T17:29:00
aliases: 
tags:
  - trouble-shooting
  - language
  - switcher
categories: 
updated: 2025-01-07T00:35
---

```bash
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0
```

중앙에 텍스트 박스가 너무 크게 표시됨

```bash
sudo mkdir -p /Library/Preferences/FeatureFlags/Domain
sudo /usr/libexec/PlistBuddy -c "Add 'redesigned_text_cursor:Enabled' bool false" /Library/Preferences/FeatureFlags/Domain/UIKit.plist
sudo reboot
```