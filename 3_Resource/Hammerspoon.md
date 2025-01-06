---
title: Hammerspoon
date: 2023-02-02T09:37:00
aliases: 
tags:
  - hammerspoon
  - tool
  - keymap
  - lua
  - vim
categories: 
updated: 2025-01-07T00:35
---

```bash
brew install --cask hammerspoon
```

Karabiner 의 코딩 버전

[[Lua]]를 사용하여 맥os 의 키바인딩을 정의할 수 있다.

맥의 os api 를 래핑하고 있는 형태이기 때문에 호환성이 훌륭하다.

### insert mode 에서 esc 입력시 자동으로 한영 변환

[[Vim]] 에서 normal mode 에서 한글 입력시에는 대부분의 명령이 정상 동작하지 않기 때문에, esc 를 통해 normal mode 진입시 자동으로 영어로 변환해주는 기능이다.

```lua
-- key mapping for vim 
-- Convert input soruce as English and sends 'escape' if inputSource is not English.
-- Sends 'escape' if inputSource is English.
-- key bindding reference --> https://www.hammerspoon.org/docs/hs.hotkey.html
local inputEnglish = "com.apple.keylayout.ABC"
local esc_bind

function convert_to_eng_with_esc()
	local inputSource = hs.keycodes.currentSourceID()
	if not (inputSource == inputEnglish) then
		hs.eventtap.keyStroke({}, 'right')
		hs.keycodes.currentSourceID(inputEnglish)
	end
	esc_bind:disable()
	hs.eventtap.keyStroke({}, 'escape')
	esc_bind:enable()
end

esc_bind = hs.hotkey.new({}, 'escape', convert_to_eng_with_esc):enable()
```

## Reference

- [Hammerspoon GitHub](https://github.com/Hammerspoon/hammerspoon)
